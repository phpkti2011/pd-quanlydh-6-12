-- Fix invalid enum value 'ThietKe' in get_production_alerts function
-- Replaces 'ThietKe' with 'XuLyFile' which is the correct enum value for Design/Processing

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
    -- Changed 'ThietKe' to 'XuLyFile'
    SELECT json_agg(t) INTO bottlenecks
    FROM (
        SELECT id, order_code, status, created_at, 'Đơn bị kẹt năng suất' as alert_msg
        FROM orders
        WHERE status IN ('TiepNhan', 'NhanFile', 'XuLyFile', 'BinhFile')
        AND created_at < NOW() - INTERVAL '2 days'
    ) t;

    RETURN json_build_object(
        'urgent', COALESCE(urgent_sos, '[]'::json),
        'bottleneck', COALESCE(bottlenecks, '[]'::json)
    );
END;
$$;
