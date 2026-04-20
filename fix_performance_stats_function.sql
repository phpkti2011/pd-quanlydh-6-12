-- ==============================================================================
-- FIX: Repair 'get_performance_stats' function missing error
-- ==============================================================================

-- 1. Drop old versions to be safe (both signatures)
DROP FUNCTION IF EXISTS get_performance_stats(DATE, DATE);
DROP FUNCTION IF EXISTS get_performance_stats(DATE, DATE, TEXT);

-- 2. Re-create the function with correct 3-argument signature
CREATE OR REPLACE FUNCTION get_performance_stats(
    p_start_date DATE,
    p_end_date DATE,
    p_user_name TEXT DEFAULT NULL
)
RETURNS TABLE (
    user_name TEXT,
    total_participation BIGINT,
    total_orders BIGINT,
    total_process_comm NUMERIC,
    total_stage_comm NUMERIC,
    total_revenue_generated NUMERIC 
) AS $$
DECLARE
    v_transition_date DATE := '2026-03-01';
BEGIN
    RETURN QUERY
    WITH eligible_orders AS (
        -- Chỉ đơn đã hoàn thành, theo logic transition completed_at
        SELECT o.id as order_id, o.total_amount_pre_vat
        FROM orders o
        WHERE o.status = 'HoanThanh'
        AND (
            (o.created_at::DATE < v_transition_date
             AND o.created_at::DATE >= p_start_date
             AND o.created_at::DATE <= p_end_date)
            OR
            (o.created_at::DATE >= v_transition_date
             AND o.completed_at IS NOT NULL
             AND o.completed_at::DATE >= p_start_date
             AND o.completed_at::DATE <= p_end_date)
        )
    ),
    -- Số người DISTINCT tham gia 1 đơn (gộp tất cả công đoạn)
    order_participants AS (
        SELECT
            part.order_id,
            COUNT(DISTINCT part.user_id) as distinct_participant_count
        FROM order_process_participants part
        JOIN eligible_orders eo ON eo.order_id = part.order_id
        JOIN profiles p ON part.user_id = p.id
        WHERE p.role::text IN ('NhanVienSanXuat', 'QuanLySanXuat', 'NhanVienBinhFile', 'NhanVienThietKe')
        GROUP BY part.order_id
    ),
    -- Mỗi user tham gia 1 đơn chỉ tính 1 lần (DISTINCT)
    user_order_pairs AS (
        SELECT DISTINCT
            p.id as user_id,
            p.full_name,
            part.order_id,
            eo.total_amount_pre_vat,
            op.distinct_participant_count,
            -- Đếm số lượt làm (count rows) riêng để hiển thị
            (SELECT COUNT(*) FROM order_process_participants pp
             WHERE pp.user_id = p.id AND pp.order_id = part.order_id) as participation_count_in_order
        FROM order_process_participants part
        JOIN eligible_orders eo ON eo.order_id = part.order_id
        JOIN order_participants op ON op.order_id = part.order_id
        JOIN profiles p ON part.user_id = p.id
        WHERE p.role::text IN ('NhanVienSanXuat', 'QuanLySanXuat', 'NhanVienBinhFile', 'NhanVienThietKe')
        AND (p_user_name IS NULL OR p.full_name = p_user_name)
    )

    SELECT
        uop.full_name,
        SUM(uop.participation_count_in_order)::BIGINT as total_participation,
        COUNT(DISTINCT uop.order_id)::BIGINT as total_orders,
        0::NUMERIC as total_process_comm,
        0::NUMERIC as total_stage_comm,
        ROUND(SUM(uop.total_amount_pre_vat / NULLIF(uop.distinct_participant_count, 0)), 0) as total_revenue_generated
    FROM user_order_pairs uop
    GROUP BY uop.full_name
    ORDER BY total_revenue_generated DESC;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 3. Notify Schema Reload (Important for PostgREST cache)
NOTIFY pgrst, 'reload schema';
