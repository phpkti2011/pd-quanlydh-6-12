-- ==============================================================================
-- calculate_sales_commission — NGUỒN DUY NHẤT của hoa hồng + thưởng nhóm NVKD
--
-- 1. Doanh số NVKD tính theo completed_at (từ tháng 3/2026)
--      - Đơn tạo trước 01/03/2026: tính theo created_at (giữ nguyên)
--      - Đơn tạo từ 01/03/2026: tính theo completed_at
--    Doanh số luôn là CHƯA VAT (total_amount_pre_vat).
--
-- 2. THƯỞNG NHÓM (chạy lại file này là đủ, không còn dùng bảng GROUP_TIER):
--      - Chỉ tiêu + % thưởng lấy từ màn "Thiết lập KPI" (bảng sales_targets):
--        dòng Phòng Kinh Doanh ('Sales'); không có thì dòng Toàn Công Ty ('Company').
--      - Doanh số nhóm (chưa VAT) >= chỉ tiêu  ->  quỹ = doanh số nhóm x % / 100.
--        Chưa đạt, hoặc chưa nhập chỉ tiêu     ->  quỹ = 0.
--      - Quỹ CHIA ĐÔI:
--          khoảng 1 = quỹ/2 x (doanh số cá nhân / doanh số nhóm)
--          khoảng 2 = quỹ/2 x (số đơn cá nhân  / số đơn nhóm)
--        Thưởng nhóm của 1 NVKD = khoảng 1 + khoảng 2.
--      - Doanh số nhóm và số đơn nhóm chỉ tính các đơn có NVKD phụ trách, đúng bằng
--        tập đơn đem chia, nên tổng thưởng nhóm của mọi NVKD = quỹ (lệch tối đa
--        vài đồng do làm tròn từng người).
--      - Số đơn KHÔNG tính đơn sản xuất lại (rework_of_order_id IS NOT NULL).
--
-- Lưu ý khi sửa: file fix_commission_transition.sql và fix_kpi_staff_commission.sql
-- cũng từng định nghĩa hàm này (bản cũ, có VAT). ĐỪNG chạy lại chúng.
--
-- Chạy trong Supabase SQL Editor. Chỉ file này, không cần file nào khác.
-- Chạy XONG rồi mới deploy phần giao diện (SalesCommissionModal) đọc các cột mới.
-- ==============================================================================

DROP FUNCTION IF EXISTS calculate_sales_commission(DATE, DATE);
DROP FUNCTION IF EXISTS calculate_sales_commission(DATE, DATE, TEXT);

CREATE OR REPLACE FUNCTION calculate_sales_commission(
    p_start_date DATE,
    p_end_date DATE,
    p_sales_rep_name TEXT DEFAULT NULL
)
RETURNS TABLE (
    sales_rep_name TEXT,
    personal_sales NUMERIC,
    personal_comm NUMERIC,
    group_sales_total NUMERIC,
    group_comm NUMERIC,
    total_comm NUMERIC,
    commission_tiers JSONB,
    -- Các cột thêm sau (giao diện Thưởng NVKD đọc):
    group_target NUMERIC,          -- chỉ tiêu doanh số nhóm (chưa VAT), 0 = chưa nhập
    group_rate NUMERIC,            -- % thưởng (vd 1 = 1%)
    group_bonus_fund NUMERIC,      -- quỹ thưởng nhóm (0 nếu chưa đạt chỉ tiêu)
    completed_order_count BIGINT,  -- số đơn hoàn thành của NVKD này (không tính đơn SX lại)
    group_order_count BIGINT,      -- tổng số đơn hoàn thành của nhóm
    group_comm_sales NUMERIC,      -- khoảng 1: phần chia theo doanh số
    group_comm_orders NUMERIC      -- khoảng 2: phần chia theo số đơn
) AS $$
DECLARE
    v_group_sales NUMERIC := 0;
    v_group_orders BIGINT := 0;
    v_group_target NUMERIC := 0;
    v_group_rate NUMERIC := 0;
    v_group_fund NUMERIC := 0;
    v_month INT := EXTRACT(MONTH FROM p_start_date)::INT;
    v_year INT := EXTRACT(YEAR FROM p_start_date)::INT;
    v_transition_date DATE := '2026-03-01';
BEGIN
    -- A. Doanh số + số đơn của CẢ NHÓM (các đơn có NVKD phụ trách).
    --    Không phụ thuộc p_sales_rep_name: NVKD xem riêng vẫn thấy đúng phần của mình.
    SELECT COALESCE(SUM(o.total_amount_pre_vat), 0),
           COUNT(o.id) FILTER (WHERE o.rework_of_order_id IS NULL)
    INTO v_group_sales, v_group_orders
    FROM orders o
    JOIN profiles p ON o.sales_rep_id = p.id
    WHERE o.status = 'HoanThanh'
    AND (
        -- Đơn cũ (tạo trước 01/03/2026): tính theo created_at
        (o.created_at::DATE < v_transition_date
         AND o.created_at::DATE >= p_start_date
         AND o.created_at::DATE <= p_end_date)
        OR
        -- Đơn mới (tạo từ 01/03/2026): tính theo completed_at
        (o.created_at::DATE >= v_transition_date
         AND o.completed_at IS NOT NULL
         AND o.completed_at::DATE >= p_start_date
         AND o.completed_at::DATE <= p_end_date)
    );

    -- B. Chỉ tiêu + % thưởng nhóm từ màn Thiết lập KPI.
    --    Ưu tiên Phòng Kinh Doanh, không có (hoặc chỉ tiêu = 0) thì Toàn Công Ty.
    SELECT st.target_amount, st.commission_rate
    INTO v_group_target, v_group_rate
    FROM sales_targets st
    WHERE st.department_name = 'Sales'
    AND st.period_month = v_month
    AND st.period_year = v_year
    AND COALESCE(st.target_amount, 0) > 0
    ORDER BY st.created_at DESC NULLS LAST, st.id DESC
    LIMIT 1;

    IF v_group_target IS NULL THEN
        SELECT st.target_amount, st.commission_rate
        INTO v_group_target, v_group_rate
        FROM sales_targets st
        WHERE st.department_name = 'Company'
        AND st.period_month = v_month
        AND st.period_year = v_year
        AND COALESCE(st.target_amount, 0) > 0
        ORDER BY st.created_at DESC NULLS LAST, st.id DESC
        LIMIT 1;
    END IF;

    v_group_target := COALESCE(v_group_target, 0);
    v_group_rate := COALESCE(v_group_rate, 0);

    -- C. Quỹ thưởng nhóm: chỉ có khi đã đặt chỉ tiêu VÀ doanh số nhóm đạt chỉ tiêu.
    IF v_group_target > 0 AND v_group_sales >= v_group_target THEN
        v_group_fund := ROUND(v_group_sales * v_group_rate / 100, 0);
    ELSE
        v_group_fund := 0;
    END IF;

    -- D. Từng NVKD.
    -- Ưu tiên commission_tiers từ sales_targets (theo tháng), fallback về profiles
    RETURN QUERY
    WITH rep_sales AS (
        SELECT
            p.id as user_id,
            p.full_name,
            COALESCE(
                (SELECT st.commission_tiers FROM sales_targets st
                 WHERE st.entity_type = 'user'
                 AND st.entity_id = p.id
                 AND st.period_month = v_month
                 AND st.period_year = v_year
                 AND st.commission_tiers IS NOT NULL
                 ORDER BY st.created_at DESC NULLS LAST, st.id DESC
                 LIMIT 1),
                p.commission_tiers
            ) as effective_tiers,
            COALESCE(SUM(o.total_amount_pre_vat), 0) as total_sales,
            -- Đơn sản xuất lại không tính vào số đơn (setup_rework_orders.sql)
            COUNT(o.id) FILTER (WHERE o.rework_of_order_id IS NULL) as order_count
        FROM orders o
        JOIN profiles p ON o.sales_rep_id = p.id
        WHERE o.status = 'HoanThanh'
        AND (
            -- Đơn cũ: theo created_at
            (o.created_at::DATE < v_transition_date
             AND o.created_at::DATE >= p_start_date
             AND o.created_at::DATE <= p_end_date)
            OR
            -- Đơn mới: theo completed_at
            (o.created_at::DATE >= v_transition_date
             AND o.completed_at IS NOT NULL
             AND o.completed_at::DATE >= p_start_date
             AND o.completed_at::DATE <= p_end_date)
        )
        AND (p_sales_rep_name IS NULL OR p.full_name = p_sales_rep_name)
        GROUP BY p.id, p.full_name, p.commission_tiers
    ),
    calc AS (
        SELECT
            rs.full_name,
            rs.total_sales,
            rs.order_count,
            rs.effective_tiers,
            calculate_personal_commission_hybrid(rs.total_sales, rs.effective_tiers) as personal_comm_val,
            -- Khoảng 1: chia theo tỉ lệ doanh số
            CASE WHEN v_group_sales > 0
                 THEN ROUND(v_group_fund / 2 * rs.total_sales / v_group_sales, 0)
                 ELSE 0 END as comm_by_sales,
            -- Khoảng 2: chia theo tỉ lệ số đơn
            CASE WHEN v_group_orders > 0
                 THEN ROUND(v_group_fund / 2 * rs.order_count / v_group_orders, 0)
                 ELSE 0 END as comm_by_orders
        FROM rep_sales rs
    )
    SELECT
        c.full_name,
        c.total_sales,
        c.personal_comm_val,
        v_group_sales,
        c.comm_by_sales + c.comm_by_orders,
        c.personal_comm_val + c.comm_by_sales + c.comm_by_orders,
        c.effective_tiers,
        v_group_target,
        v_group_rate,
        v_group_fund,
        c.order_count,
        v_group_orders,
        c.comm_by_sales,
        c.comm_by_orders
    FROM calc c;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION calculate_sales_commission(DATE, DATE, TEXT) TO authenticated;

NOTIFY pgrst, 'reload schema';

-- ==============================================================================
-- KIỂM TRA SAU KHI CHẠY (chạy riêng, đổi tháng nếu cần):
--   SELECT sales_rep_name, personal_sales, completed_order_count,
--          group_comm_sales, group_comm_orders, group_comm,
--          group_target, group_rate, group_bonus_fund
--   FROM calculate_sales_commission('2026-10-01', '2026-10-31');
-- Tổng cột group_comm của các dòng phải bằng group_bonus_fund (lệch vài đồng do làm tròn).
-- ==============================================================================
