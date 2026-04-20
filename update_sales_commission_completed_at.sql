-- ==============================================================================
-- CẬP NHẬT: Tính doanh số NVKD theo completed_at (từ tháng 3/2026)
-- Logic transition:
--   - Đơn tạo trước 01/03/2026: tính theo created_at (giữ nguyên)
--   - Đơn tạo từ 01/03/2026: tính theo completed_at
-- Chạy trong Supabase SQL Editor
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
    commission_tiers JSONB
) AS $$
DECLARE
    v_group_sales NUMERIC := 0;
    v_group_rate NUMERIC := 0;
    v_group_fund NUMERIC := 0;
    v_transition_date DATE := '2026-03-01';
BEGIN
    -- A. Calculate Total Group Sales with transition logic
    SELECT COALESCE(SUM(total_amount_pre_vat), 0)
    INTO v_group_sales
    FROM orders
    WHERE status = 'HoanThanh'
    AND (
        -- Đơn cũ (tạo trước 01/03/2026): tính theo created_at
        (created_at::DATE < v_transition_date
         AND created_at::DATE >= p_start_date
         AND created_at::DATE <= p_end_date)
        OR
        -- Đơn mới (tạo từ 01/03/2026): tính theo completed_at
        (created_at::DATE >= v_transition_date
         AND completed_at IS NOT NULL
         AND completed_at::DATE >= p_start_date
         AND completed_at::DATE <= p_end_date)
    );

    -- B. Find Group Bonus Rate
    SELECT rate INTO v_group_rate
    FROM commission_policies
    WHERE policy_type = 'GROUP_TIER'
    AND v_group_sales >= threshold_min
    ORDER BY threshold_min DESC
    LIMIT 1;

    v_group_fund := v_group_sales * COALESCE(v_group_rate, 0);

    -- C. Return Per-Employee with transition logic
    -- Ưu tiên commission_tiers từ sales_targets (theo tháng), fallback về profiles
    RETURN QUERY
    WITH rep_sales AS (
        SELECT
            p.id as user_id,
            p.full_name,
            -- Ưu tiên tiers từ sales_targets theo tháng, fallback về profiles
            COALESCE(
                (SELECT st.commission_tiers FROM sales_targets st
                 WHERE st.entity_type = 'user'
                 AND st.entity_id = p.id
                 AND st.period_month = EXTRACT(MONTH FROM p_start_date)::INT
                 AND st.period_year = EXTRACT(YEAR FROM p_start_date)::INT
                 AND st.commission_tiers IS NOT NULL
                 ORDER BY st.created_at DESC NULLS LAST, st.id DESC
                 LIMIT 1),
                p.commission_tiers
            ) as effective_tiers,
            COALESCE(SUM(o.total_amount_pre_vat), 0) as total_sales,
            COUNT(o.id) as order_count
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
    )
    SELECT
        rs.full_name,
        rs.total_sales,
        calculate_personal_commission_hybrid(rs.total_sales, rs.effective_tiers) as personal_comm_val,
        v_group_sales,
        CASE
            WHEN v_group_sales > 0 THEN (rs.total_sales / v_group_sales) * v_group_fund
            ELSE 0
        END as group_comm_val,
        0::NUMERIC,
        rs.effective_tiers as commission_tiers
    FROM rep_sales rs;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

NOTIFY pgrst, 'reload schema';
