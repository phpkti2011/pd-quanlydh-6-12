-- AI Assistant Alert System
-- Returns JSON arrays of "Action Items" for Frontend/Chatbot

-- 1. Sales Alerts Function
CREATE OR REPLACE FUNCTION get_sales_alerts(p_user_id UUID)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    debt_alerts JSON;
    deadline_alerts JSON;
    approval_alerts JSON;
BEGIN
    -- A. Debt Warning: Delivered > 3 days ago AND Remaining > 0
    SELECT json_agg(t) INTO debt_alerts
    FROM (
        SELECT id, order_code, remaining_amount, customer_id, 'Khách nợ quá hạn 3 ngày' as alert_msg
        FROM orders
        WHERE sales_rep_id = p_user_id
        AND status IN ('GiaoHang', 'DaGiaoHang', 'HoanThanh')
        AND payment_status != 'DaThanhToan'
        AND remaining_amount > 0
        AND updated_at < NOW() - INTERVAL '3 days'
    ) t;

    -- B. Delivery Risk: Due Today/Tomorrow AND Not Delivered
    SELECT json_agg(t) INTO deadline_alerts
    FROM (
        SELECT id, order_code, delivery_date, status, 'Đơn cần giao gấp' as alert_msg
        FROM orders
        WHERE sales_rep_id = p_user_id
        AND status NOT IN ('GiaoHang', 'DaGiaoHang', 'HoanThanh', 'Huy')
        AND delivery_date <= (CURRENT_DATE + 1)
    ) t;

    -- C. Waiting for Approval (Payment)
    SELECT json_agg(t) INTO approval_alerts
    FROM (
        SELECT id, order_code, total_amount, 'Đang chờ kế toán duyệt tiền' as alert_msg
        FROM orders
        WHERE sales_rep_id = p_user_id
        AND payment_confirmed = false
        AND (payment_method_deposit IS NOT NULL OR payment_method_remaining IS NOT NULL)
    ) t;

    RETURN json_build_object(
        'debt', COALESCE(debt_alerts, '[]'::json),
        'deadline', COALESCE(deadline_alerts, '[]'::json),
        'approval', COALESCE(approval_alerts, '[]'::json)
    );
END;
$$;

-- 2. Production Alerts Function (Global for Managers)
CREATE OR REPLACE FUNCTION get_production_alerts()
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    urgent_sos JSON;
    bottlenecks JSON;
BEGIN
    -- A. Urgent SOS: Valid Urgent orders NOT Finished, Due Today
    SELECT json_agg(t) INTO urgent_sos
    FROM (
        SELECT id, order_code, status, delivery_date, 'ĐƠN GẤP CẦN XỬ LÝ NGAY' as alert_msg
        FROM orders
        WHERE is_urgent = true
        AND status NOT IN ('HoanThanh', 'GiaoHang', 'DaGiaoHang', 'Huy')
        AND delivery_date <= CURRENT_DATE
    ) t;

    -- B. Bottlenecks: Stuck in Design/Pre-press > 2 days
    SELECT json_agg(t) INTO bottlenecks
    FROM (
        SELECT id, order_code, status, created_at, 'Đơn bị kẹt năng suất' as alert_msg
        FROM orders
        WHERE status IN ('TiepNhan', 'NhanFile', 'ThietKe', 'BinhFile')
        AND created_at < NOW() - INTERVAL '2 days'
    ) t;

    RETURN json_build_object(
        'urgent', COALESCE(urgent_sos, '[]'::json),
        'bottleneck', COALESCE(bottlenecks, '[]'::json)
    );
END;
$$;
