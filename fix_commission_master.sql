-- 1. CLEANUP: Drop ALL existing versions of the function to avoid conflicts
DROP FUNCTION IF EXISTS calculate_sales_commission(INT, INT, TEXT);
DROP FUNCTION IF EXISTS calculate_sales_commission(INT, INT);

-- 2. SCHEMA: Ensure commission_rate column exists in sales_targets
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'sales_targets' AND column_name = 'commission_rate') THEN
        ALTER TABLE sales_targets ADD COLUMN commission_rate NUMERIC DEFAULT 0;
    END IF;
END $$;

-- 3. LOGIC: Re-create the function with V3 Logic (Rate from Sales Targets)
CREATE OR REPLACE FUNCTION calculate_sales_commission(
    p_month INT, 
    p_year INT,
    p_viewer_role TEXT DEFAULT 'NhanVien' 
)
RETURNS TABLE (
    sales_rep_id UUID,
    sales_rep_name TEXT,
    personal_sales NUMERIC,
    commission_tiers JSONB,
    personal_comm NUMERIC,      -- Renamed from personal_commission
    group_sales_total NUMERIC,  -- Renamed from group_sales
    group_target NUMERIC,
    group_rate NUMERIC,
    group_bonus_fund NUMERIC,   -- Renamed from group_commission_fund
    group_comm NUMERIC,         -- NEW: Individual share of group bonus
    total_comm NUMERIC          -- Renamed from total_commission
) AS $$
DECLARE
    v_group_total_sales NUMERIC := 0;
    v_group_target NUMERIC := 0;
    v_group_rate NUMERIC := 0;
    v_group_bonus_fund NUMERIC := 0;
BEGIN
    -- 0. Security Check
    IF p_viewer_role = 'KeToan' THEN
        RETURN QUERY SELECT NULL::UUID, NULL::TEXT, NULL::NUMERIC, NULL::JSONB, NULL::NUMERIC, NULL::NUMERIC, NULL::NUMERIC, NULL::NUMERIC, NULL::NUMERIC, NULL::NUMERIC, NULL::NUMERIC WHERE FALSE;
        RETURN;
    END IF;

    -- 1. Calculate Group Total Sales (Completed Orders Only)
    -- Fallback date: Delivery Date -> Created At
    SELECT COALESCE(SUM(total_amount_pre_vat), 0)
    INTO v_group_total_sales
    FROM orders
    WHERE 
        EXTRACT(MONTH FROM COALESCE(delivery_date, created_at)) = p_month 
        AND EXTRACT(YEAR FROM COALESCE(delivery_date, created_at)) = p_year
        AND status IN ('HoanThanh', 'DaGiaoHang');

    -- 2. Fetch Group Target & Rate from sales_targets
    SELECT target_amount, commission_rate
    INTO v_group_target, v_group_rate
    FROM sales_targets 
    WHERE 
        period_month = p_month 
        AND period_year = p_year

        AND (department_name ILIKE 'Sales' OR department_name ILIKE '%Kinh Doanh%')
    ORDER BY created_at DESC -- Prefer latest entry if duplicates
    LIMIT 1;

    -- Fallback to Company if Sales target missing
    IF v_group_target IS NULL THEN
         SELECT target_amount, commission_rate
         INTO v_group_target, v_group_rate
         FROM sales_targets 
         WHERE 
            period_month = p_month 
            AND period_year = p_year
            AND department_name = 'Company'
         LIMIT 1;
    END IF;

    v_group_target := COALESCE(v_group_target, 99999999999); 
    v_group_rate := COALESCE(v_group_rate, 0);

    -- 3. Calculate Group Bonus Fund
    IF v_group_total_sales >= v_group_target THEN
        v_group_bonus_fund := v_group_total_sales * (v_group_rate / 100);
    ELSE
        v_group_bonus_fund := 0;
    END IF;

    -- 4. Calculate Personal Commissions & Distribute Group Bonus
    RETURN QUERY
    WITH monthly_sales AS (
        SELECT 
            o.sales_rep_id,
            COALESCE(p.full_name, 'Chưa gán NV') as sales_rep_name,
            COALESCE(p.commission_tiers, '[]'::jsonb) as commission_tiers,
            COALESCE(SUM(o.total_amount_pre_vat), 0) as total_sales
        FROM orders o
        LEFT JOIN profiles p ON o.sales_rep_id = p.id
        WHERE 
            EXTRACT(MONTH FROM COALESCE(o.delivery_date, o.created_at)) = p_month 
            AND EXTRACT(YEAR FROM COALESCE(o.delivery_date, o.created_at)) = p_year
            -- Sales Rep Logic: Exclude Cancelled, Include Deposited/Paid/Debt
            AND o.status != 'Huy'
            AND o.payment_status IN ('DaCoc', 'DaThanhToan', 'CongNo')
        GROUP BY o.sales_rep_id, p.full_name, p.commission_tiers
    ),
    
    -- Filter out Sales Reps with 0 sales if needed (optional, keeping clean)
    valid_sales AS (
        SELECT * FROM monthly_sales WHERE total_sales > 0
    )
    SELECT 
        ms.sales_rep_id,
        ms.sales_rep_name,
        ms.total_sales as personal_sales,
        ms.commission_tiers,
        
        -- Personal Commission (Hybrid Logic)
        (
            WITH tier_data AS (
                SELECT 
                    (t->>'min')::numeric as min_val,
                    COALESCE(NULLIF((t->>'max')::numeric, 0), 99999999999) as max_val, -- Treat 0 as Infinity
                    (t->>'rate')::numeric as rate
                FROM jsonb_array_elements(ms.commission_tiers) t
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
                    -- (Base from Prev Tier Max * Prev Tier Rate) + (Excess * Current Rate)
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

        -- Total Commission (Sum of Hybrid Personal + Group Share)
        (
             (
                WITH tier_data AS (
                    SELECT 
                        (t->>'min')::numeric as min_val,
                        COALESCE(NULLIF((t->>'max')::numeric, 0), 99999999999) as max_val,
                        (t->>'rate')::numeric as rate
                    FROM jsonb_array_elements(ms.commission_tiers) t
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
    FROM monthly_sales ms;
END;
$$ LANGUAGE plpgsql;
