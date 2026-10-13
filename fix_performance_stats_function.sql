-- ==============================================================================
-- FIX: Repair 'get_performance_stats' function missing error
-- + TỐI ƯU: hết lỗi "canceling statement due to statement timeout" khi xem tháng nhiều đơn
--
-- Nguyên nhân timeout bản cũ:
--   1. Truy vấn con COUNT(*) nằm trong SELECT DISTINCT -> chạy lặp cho từng dòng tham gia.
--   2. o.created_at::DATE / o.completed_at::DATE -> không dùng được index, quét cả bảng orders.
--   3. Join profiles + order_process_participants hai lần.
-- Bản mới: lọc ngày theo khoảng (dùng index), join một lần (valid_parts), đếm bằng GROUP BY.
-- Kết quả giữ nguyên so với bản cũ.
-- ==============================================================================

-- 0. Index hỗ trợ (IF NOT EXISTS nên chạy lại an toàn)
CREATE INDEX IF NOT EXISTS idx_orders_completed_at ON orders(completed_at);
CREATE INDEX IF NOT EXISTS idx_order_process_participants_order_id ON order_process_participants(order_id);
CREATE INDEX IF NOT EXISTS idx_order_process_participants_user_id ON order_process_participants(user_id);

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
        -- Chỉ đơn đã hoàn thành, theo logic transition completed_at.
        -- So sánh theo khoảng [start, end+1) thay vì ép ::DATE để dùng được index.
        SELECT o.id as order_id, o.total_amount_pre_vat
        FROM orders o
        WHERE o.status = 'HoanThanh'
        AND o.rework_of_order_id IS NULL
        AND (
            (o.created_at < v_transition_date
             AND o.created_at >= p_start_date
             AND o.created_at < p_end_date + 1)
            OR
            (o.created_at >= v_transition_date
             AND o.completed_at IS NOT NULL
             AND o.completed_at >= p_start_date
             AND o.completed_at < p_end_date + 1)
        )
    ),
    -- Mọi lượt tham gia hợp lệ (đúng vai trò sản xuất) của các đơn đủ điều kiện — join MỘT lần
    valid_parts AS (
        SELECT
            part.order_id,
            part.user_id,
            p.full_name,
            eo.total_amount_pre_vat
        FROM order_process_participants part
        JOIN eligible_orders eo ON eo.order_id = part.order_id
        JOIN profiles p ON part.user_id = p.id
        WHERE p.role::text IN ('NhanVienSanXuat', 'QuanLySanXuat', 'NhanVienBinhFile', 'NhanVienThietKe')
    ),
    -- Số người DISTINCT tham gia 1 đơn (gộp tất cả công đoạn) — không lọc theo p_user_name
    order_participants AS (
        SELECT
            vp.order_id,
            COUNT(DISTINCT vp.user_id) as distinct_participant_count
        FROM valid_parts vp
        GROUP BY vp.order_id
    ),
    -- Mỗi user tham gia 1 đơn chỉ tính 1 lần; COUNT(*) = số lượt làm của user trong đơn đó
    user_order_pairs AS (
        SELECT
            vp.user_id,
            vp.full_name,
            vp.order_id,
            vp.total_amount_pre_vat,
            op.distinct_participant_count,
            COUNT(*) as participation_count_in_order
        FROM valid_parts vp
        JOIN order_participants op ON op.order_id = vp.order_id
        WHERE (p_user_name IS NULL OR vp.full_name = p_user_name)
        GROUP BY vp.user_id, vp.full_name, vp.order_id, vp.total_amount_pre_vat, op.distinct_participant_count
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
