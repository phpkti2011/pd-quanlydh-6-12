-- ============================================================
-- DAILY REPORT FUNCTION
-- Chạy trong Supabase SQL Editor
-- ============================================================

ALTER TABLE orders ADD COLUMN IF NOT EXISTS completed_at TIMESTAMPTZ;

CREATE OR REPLACE FUNCTION get_daily_report(p_date DATE DEFAULT CURRENT_DATE)
RETURNS JSON AS $$
DECLARE
    v_result JSON;
    v_start TIMESTAMPTZ;
    v_end TIMESTAMPTZ;
    v_month_start TIMESTAMPTZ;
    v_month_end TIMESTAMPTZ;
BEGIN
    v_start := p_date::timestamptz;
    v_end := (p_date + 1)::timestamptz;
    v_month_start := date_trunc('month', p_date)::timestamptz;
    v_month_end := (date_trunc('month', p_date) + interval '1 month')::timestamptz;

    -- Đơn sản xuất lại (rework_of_order_id IS NOT NULL, xem setup_rework_orders.sql):
    --   * KHÔNG tính vào số đơn (giống đơn Hủy)
    --   * chi phí làm lại (rework_cost) TRỪ khỏi doanh thu; đơn thường có
    --     rework_cost = 0 nên total_amount - rework_cost không đổi gì
    --   * doanh số theo NVKD KHÔNG trừ (quyết định của Admin)
    SELECT json_build_object(
        'report_date', p_date,
        'orders_created_today', (
            SELECT COUNT(*) FROM orders
            WHERE created_at >= v_start AND created_at < v_end
            AND rework_of_order_id IS NULL
        ),
        'orders_completed_today', (
            SELECT COUNT(*) FROM orders
            WHERE status::text = 'HoanThanh'
            AND rework_of_order_id IS NULL
            AND CASE
                WHEN completed_at IS NOT NULL THEN completed_at >= v_start AND completed_at < v_end
                ELSE updated_at >= v_start AND updated_at < v_end
            END
        ),
        'orders_cancelled_today', (
            SELECT COUNT(*) FROM orders
            WHERE status::text = 'Huy'
            AND rework_of_order_id IS NULL
            AND updated_at >= v_start AND updated_at < v_end
        ),
        'revenue_today', (
            SELECT COALESCE(SUM(total_amount - COALESCE(rework_cost, 0)), 0) FROM orders
            WHERE created_at >= v_start AND created_at < v_end
            AND status::text NOT IN ('Huy')
        ),
        'revenue_today_pre_vat', (
            SELECT COALESCE(SUM(total_amount_pre_vat - COALESCE(rework_cost, 0)), 0) FROM orders
            WHERE created_at >= v_start AND created_at < v_end
            AND status::text NOT IN ('Huy')
        ),
        'revenue_completed_today', (
            SELECT COALESCE(SUM(total_amount_pre_vat - COALESCE(rework_cost, 0)), 0) FROM orders
            WHERE status::text = 'HoanThanh'
            AND CASE
                WHEN completed_at IS NOT NULL THEN completed_at >= v_start AND completed_at < v_end
                ELSE updated_at >= v_start AND updated_at < v_end
            END
        ),
        'revenue_month_total', (
            SELECT COALESCE(SUM(total_amount - COALESCE(rework_cost, 0)), 0) FROM orders
            WHERE created_at >= v_month_start AND created_at < v_month_end
            AND status::text NOT IN ('Huy')
        ),
        'revenue_month_pre_vat', (
            SELECT COALESCE(SUM(total_amount_pre_vat - COALESCE(rework_cost, 0)), 0) FROM orders
            WHERE created_at >= v_month_start AND created_at < v_month_end
            AND status::text NOT IN ('Huy')
        ),
        -- Đơn sản xuất lại tạo trong tháng (chưa hủy) và tổng chi phí của chúng
        'rework_count_month', (
            SELECT COUNT(*) FROM orders
            WHERE rework_of_order_id IS NOT NULL
            AND created_at >= v_month_start AND created_at < v_month_end
            AND status::text NOT IN ('Huy')
        ),
        'rework_cost_month', (
            SELECT COALESCE(SUM(COALESCE(rework_cost, 0)), 0) FROM orders
            WHERE rework_of_order_id IS NOT NULL
            AND created_at >= v_month_start AND created_at < v_month_end
            AND status::text NOT IN ('Huy')
        ),
        'sales_by_employee', (
            SELECT COALESCE(json_agg(emp_stats ORDER BY emp_stats.revenue DESC), '[]'::json)
            FROM (
                SELECT
                    p.full_name AS employee_name,
                    p.role::text AS role,
                    COUNT(o.id) FILTER (WHERE o.rework_of_order_id IS NULL) AS orders_created,
                    COALESCE(SUM(o.total_amount), 0) AS revenue,
                    COUNT(CASE WHEN o.rework_of_order_id IS NULL
                        AND o.status::text = 'HoanThanh'
                        AND CASE
                            WHEN o.completed_at IS NOT NULL THEN o.completed_at >= v_start AND o.completed_at < v_end
                            ELSE o.updated_at >= v_start AND o.updated_at < v_end
                        END
                    THEN 1 END) AS orders_completed
                FROM profiles p
                LEFT JOIN orders o ON o.sales_rep_id = p.id
                    AND o.created_at >= v_start AND o.created_at < v_end
                    AND o.status::text != 'Huy'
                WHERE p.role::text = 'NhanVienKinhDoanh'
                AND (p.is_locked IS NULL OR p.is_locked = false)
                GROUP BY p.id, p.full_name, p.role
            ) emp_stats
        ),
        'status_transitions_today', (
            SELECT COALESCE(json_agg(trans ORDER BY trans.count DESC), '[]'::json)
            FROM (
                SELECT
                    details->>'new_status' AS to_status,
                    COUNT(*) AS count
                FROM user_logs
                WHERE action_type = 'ORDER_UPDATE_STATUS'
                AND created_at >= v_start AND created_at < v_end
                AND details->>'new_status' IS NOT NULL
                GROUP BY details->>'new_status'
            ) trans
        ),
        'employee_activity', (
            SELECT COALESCE(json_agg(act ORDER BY act.total_actions DESC), '[]'::json)
            FROM (
                SELECT
                    ul.user_name AS employee_name,
                    COUNT(*) AS total_actions,
                    COUNT(CASE WHEN ul.action_type = 'ORDER_CREATE' THEN 1 END) AS orders_created,
                    COUNT(CASE WHEN ul.action_type = 'ORDER_UPDATE_STATUS' THEN 1 END) AS status_updates,
                    COUNT(CASE WHEN ul.action_type IN ('STAGE_JOIN', 'STAGE_LEAVE') THEN 1 END) AS stage_actions,
                    COUNT(CASE WHEN ul.action_type = 'PAYMENT_UPDATE' THEN 1 END) AS payment_updates
                FROM user_logs ul
                WHERE ul.created_at >= v_start AND ul.created_at < v_end
                GROUP BY ul.user_name
            ) act
        ),
        'pending_orders_count', (
            SELECT COUNT(*) FROM orders
            WHERE status::text NOT IN ('HoanThanh', 'Huy')
        ),
        'payment_stats', json_build_object(
            'total_collected', (
                SELECT COALESCE(SUM(deposit_amount + COALESCE(remaining_amount, 0)), 0)
                FROM orders
                WHERE payment_confirmed = true
                AND payment_confirmed_at >= v_start AND payment_confirmed_at < v_end
            ),
            'unpaid_orders', (
                SELECT COUNT(*) FROM orders
                WHERE payment_status::text = 'ChuaThanhToan'
                AND status::text NOT IN ('Huy', 'Moi')
            ),
            'debt_orders', (
                SELECT COUNT(*) FROM orders
                WHERE payment_status::text = 'CongNo'
            )
        )
    ) INTO v_result;

    RETURN v_result;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
