-- =====================================================
-- Update Sales Commission: Tính Thưởng Theo Tháng Trước
-- =====================================================
-- Logic mới:
-- - Thưởng tháng T = doanh số đơn TẠO trong tháng T-1 và ĐÃ HOÀN THÀNH
-- - Hoàn thành = status = 'HoanThanh'
-- - Doanh số = total_amount_pre_vat (chưa VAT)
-- - Doanh số cá nhân cũng tính theo đơn hoàn thành (bỏ qua payment_status)
-- =====================================================

-- 1. Drop ALL existing function versions to avoid conflicts
DROP FUNCTION IF EXISTS calculate_sales_commission(INT, INT, TEXT);
DROP FUNCTION IF EXISTS calculate_sales_commission(INT, INT);
DROP FUNCTION IF EXISTS calculate_sales_commission(TEXT, TEXT, TEXT);
DROP FUNCTION IF EXISTS calculate_sales_commission(TEXT, TEXT);
DROP FUNCTION IF EXISTS calculate_sales_commission(DATE, DATE, TEXT);
DROP FUNCTION IF EXISTS calculate_sales_commission(DATE, DATE);
DROP FUNCTION IF EXISTS public.calculate_sales_commission(INT, INT, TEXT);
DROP FUNCTION IF EXISTS public.calculate_sales_commission(TEXT, TEXT, TEXT);
DROP FUNCTION IF EXISTS public.calculate_sales_commission(DATE, DATE, TEXT);

-- 2. Create new function with updated logic
CREATE OR REPLACE FUNCTION calculate_sales_commission(
    p_start_date TEXT,  -- Format: 'YYYY-MM-DD' (Start of current month)
    p_end_date TEXT,    -- Format: 'YYYY-MM-DD' (End of current month)
    p_sales_rep_name TEXT DEFAULT NULL
)
RETURNS TABLE (
    sales_rep_id UUID,
    sales_rep_name TEXT,
    personal_sales NUMERIC,
    completed_sales NUMERIC,        -- NEW: Doanh số đơn hoàn thành
    completed_order_count INT,      -- NEW: Số đơn hoàn thành
    commission_tiers JSONB,
    personal_comm NUMERIC,
    group_sales_total NUMERIC,
    group_target NUMERIC,
    group_rate NUMERIC,
    group_bonus_fund NUMERIC,
    group_comm NUMERIC,
    total_comm NUMERIC
) AS $$
DECLARE
    v_current_month INT;
    v_current_year INT;
    v_prev_month INT;
    v_prev_year INT;
    v_group_total_sales NUMERIC := 0;
    v_group_target NUMERIC := 0;
    v_group_rate NUMERIC := 0;
    v_group_bonus_fund NUMERIC := 0;
BEGIN
    -- Parse current month/year from p_start_date
    v_current_month := EXTRACT(MONTH FROM p_start_date::DATE);
    v_current_year := EXTRACT(YEAR FROM p_start_date::DATE);

    -- Calculate PREVIOUS month (for bonus calculation)
    IF v_current_month = 1 THEN
        v_prev_month := 12;
        v_prev_year := v_current_year - 1;
    ELSE
        v_prev_month := v_current_month - 1;
        v_prev_year := v_current_year;
    END IF;

    -- =========================================
    -- 1. Calculate Group Total Sales (Completed Orders from PREVIOUS month)
    -- Logic: Orders CREATED in previous month AND status = 'HoanThanh'
    -- =========================================
    SELECT COALESCE(SUM(total_amount_pre_vat), 0)
    INTO v_group_total_sales
    FROM orders
    WHERE 
        EXTRACT(MONTH FROM created_at) = v_prev_month 
        AND EXTRACT(YEAR FROM created_at) = v_prev_year
        AND status = 'HoanThanh';  -- Only completed orders

    -- =========================================
    -- 2. Fetch Group Target & Rate from sales_targets
    -- =========================================
    SELECT target_amount, commission_rate
    INTO v_group_target, v_group_rate
    FROM sales_targets 
    WHERE 
        period_month = v_current_month   -- Target is for current month
        AND period_year = v_current_year
        AND (department_name ILIKE 'Sales' OR department_name ILIKE '%Kinh Doanh%')
    ORDER BY created_at DESC
    LIMIT 1;

    -- Fallback to Company target if Sales not found
    IF v_group_target IS NULL THEN
        SELECT target_amount, commission_rate
        INTO v_group_target, v_group_rate
        FROM sales_targets 
        WHERE 
            period_month = v_current_month 
            AND period_year = v_current_year
            AND department_name = 'Company'
        LIMIT 1;
    END IF;

    v_group_target := COALESCE(v_group_target, 99999999999);
    v_group_rate := COALESCE(v_group_rate, 0);

    -- =========================================
    -- 3. Calculate Group Bonus Fund
    -- =========================================
    IF v_group_total_sales >= v_group_target THEN
        v_group_bonus_fund := v_group_total_sales * (v_group_rate / 100);
    ELSE
        v_group_bonus_fund := 0;
    END IF;

    -- =========================================
    -- 4. Calculate Personal Commission & Distribute Group Bonus
    -- =========================================
    RETURN QUERY
    WITH monthly_sales AS (
        SELECT 
            o.sales_rep_id,
            COALESCE(p.full_name, 'Chưa gán NV') as rep_name,
            COALESCE(p.commission_tiers, '[]'::jsonb) as comm_tiers,
            -- Personal Sales: Orders CREATED in prev month AND completed
            COALESCE(SUM(o.total_amount_pre_vat), 0) as total_sales,
            COUNT(o.id)::INT as order_count
        FROM orders o
        LEFT JOIN profiles p ON o.sales_rep_id = p.id
        WHERE 
            EXTRACT(MONTH FROM o.created_at) = v_prev_month 
            AND EXTRACT(YEAR FROM o.created_at) = v_prev_year
            AND o.status = 'HoanThanh'  -- Only completed orders
        GROUP BY o.sales_rep_id, p.full_name, p.commission_tiers
    ),
    
    valid_sales AS (
        SELECT * FROM monthly_sales WHERE total_sales > 0
    )
    
    SELECT 
        ms.sales_rep_id,
        ms.rep_name::TEXT,
        ms.total_sales as personal_sales,
        ms.total_sales as completed_sales,  -- Same as personal_sales now
        ms.order_count as completed_order_count,
        ms.comm_tiers,
        
        -- Personal Commission (Hybrid Logic)
        (
            WITH tier_data AS (
                SELECT 
                    (t->>'min')::numeric as min_val,
                    COALESCE(NULLIF((t->>'max')::numeric, 0), 99999999999) as max_val,
                    (t->>'rate')::numeric as rate
                FROM jsonb_array_elements(ms.comm_tiers) t
            ),
            match_tier AS (
                SELECT * FROM tier_data 
                WHERE ms.total_sales > min_val AND ms.total_sales <= max_val
                ORDER BY min_val DESC LIMIT 1
            ),
            prev_tier AS (
                SELECT * FROM tier_data
                WHERE max_val <= (SELECT min_val FROM match_tier)
                ORDER BY min_val DESC LIMIT 1
            )
            SELECT COALESCE(
                CASE 
                    -- Case A: Finite Tier -> Apply Rate to WHOLE SALES
                    WHEN (SELECT max_val FROM match_tier) < 99999999999 THEN
                        ms.total_sales * (SELECT rate FROM match_tier) / 100
                    
                    -- Case B: Infinite Tier -> Marginal Logic
                    ELSE
                        (
                            COALESCE((SELECT max_val FROM prev_tier), 0) * 
                            COALESCE((SELECT rate FROM prev_tier), 0) / 100
                        )
                        +
                        (
                            (ms.total_sales - COALESCE((SELECT max_val FROM prev_tier), 0)) * 
                            (SELECT rate FROM match_tier) / 100
                        )
                END
            , 0)
        ) as personal_comm,

        v_group_total_sales as group_sales_total,
        v_group_target,
        v_group_rate,
        v_group_bonus_fund,

        -- Group Share (Calculated)
        (
            CASE WHEN v_group_total_sales > 0 THEN
                (ms.total_sales / v_group_total_sales) * v_group_bonus_fund
            ELSE 0 END
        ) as group_comm,

        -- Total Commission (Sum of Personal + Group Share)
        (
            (
                WITH tier_data AS (
                    SELECT 
                        (t->>'min')::numeric as min_val,
                        COALESCE(NULLIF((t->>'max')::numeric, 0), 99999999999) as max_val,
                        (t->>'rate')::numeric as rate
                    FROM jsonb_array_elements(ms.comm_tiers) t
                ),
                match_tier AS (
                    SELECT * FROM tier_data 
                    WHERE ms.total_sales > min_val AND ms.total_sales <= max_val
                    ORDER BY min_val DESC LIMIT 1
                ),
                prev_tier AS (
                    SELECT * FROM tier_data
                    WHERE max_val <= (SELECT min_val FROM match_tier)
                    ORDER BY min_val DESC LIMIT 1
                )
                SELECT COALESCE(
                    CASE 
                        WHEN (SELECT max_val FROM match_tier) < 99999999999 THEN
                            ms.total_sales * (SELECT rate FROM match_tier) / 100
                        ELSE
                            (
                                COALESCE((SELECT max_val FROM prev_tier), 0) * 
                                COALESCE((SELECT rate FROM prev_tier), 0) / 100
                            )
                            +
                            (
                                (ms.total_sales - COALESCE((SELECT max_val FROM prev_tier), 0)) * 
                                (SELECT rate FROM match_tier) / 100
                            )
                    END
                , 0)
            )
            + 
            (
                CASE WHEN v_group_total_sales > 0 THEN
                    (ms.total_sales / v_group_total_sales) * v_group_bonus_fund
                ELSE 0 END
            )
        ) as total_comm
    FROM monthly_sales ms
    WHERE p_sales_rep_name IS NULL OR ms.rep_name ILIKE '%' || p_sales_rep_name || '%';
END;
$$ LANGUAGE plpgsql;

-- =========================================
-- 3. Grant permissions
-- =========================================
GRANT EXECUTE ON FUNCTION calculate_sales_commission(TEXT, TEXT, TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION calculate_sales_commission(TEXT, TEXT, TEXT) TO anon;

-- =========================================
-- 4. Test Query (Optional - Run manually)
-- =========================================
-- SELECT * FROM calculate_sales_commission('2026-02-01', '2026-02-28', NULL);
