-- Update the calculate_sales_commission function to use commission_rate from sales_targets
CREATE OR REPLACE FUNCTION calculate_sales_commission(
    p_month INT, 
    p_year INT,
    p_viewer_role TEXT DEFAULT 'NhanVien' 
)
RETURNS TABLE (
    sales_rep_id UUID,
    sales_rep_name TEXT,
    personal_sales NUMERIC,
    commission_tier JSONB,
    personal_commission NUMERIC,
    group_sales NUMERIC,
    group_target NUMERIC,
    group_rate NUMERIC,
    group_commission_fund NUMERIC,
    total_commission NUMERIC
) AS $$
DECLARE
    v_group_total_sales NUMERIC := 0;
    v_group_target NUMERIC := 0;
    v_group_rate NUMERIC := 0;
    v_group_bonus_fund NUMERIC := 0;
BEGIN
    -- 0. Security Check
    IF p_viewer_role = 'KeToan' THEN
        RETURN QUERY SELECT NULL::UUID, NULL::TEXT, NULL::NUMERIC, NULL::JSONB, NULL::NUMERIC, NULL::NUMERIC, NULL::NUMERIC, NULL::NUMERIC, NULL::NUMERIC, NULL::NUMERIC WHERE FALSE;
        RETURN;
    END IF;

    -- 1. Calculate Group Total Sales (Completed Orders Only)
    SELECT COALESCE(SUM(grand_total), 0)
    INTO v_group_total_sales
    FROM orders
    WHERE 
        EXTRACT(MONTH FROM delivery_date) = p_month 
        AND EXTRACT(YEAR FROM delivery_date) = p_year
        AND status IN ('HoanThanh', 'DaGiaoHang');

    -- 2. Fetch Group Target & Rate from sales_targets (Department 'Sales' or 'Company')
    -- Priority: 'Sales' Department Target, fallback to 'Company' if needed, or 0.
    -- Now fetching rate directly from sales_targets too!
    SELECT target_amount, commission_rate
    INTO v_group_target, v_group_rate
    FROM sales_targets 
    WHERE 
        period_month = p_month 
        AND period_year = p_year
        AND department_name = 'Sales' -- Specifically look for Sales Dept target
    LIMIT 1;

    -- If no Sales target found, try Company? (Optional, stick to Sales for now as per UI)
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

    v_group_target := COALESCE(v_group_target, 99999999999); -- Default high if missing to avoid accidental bonus
    v_group_rate := COALESCE(v_group_rate, 0);

    -- 3. Calculate Group Bonus Fund
    -- Logic: If Total Sales >= Target, then Fund = Total Sales * Rate
    IF v_group_total_sales >= v_group_target THEN
        v_group_bonus_fund := v_group_total_sales * (v_group_rate / 100);
    ELSE
        v_group_bonus_fund := 0;
    END IF;

    -- 4. Calculate Personal Commissions & Distribute Group Func
    RETURN QUERY
    WITH monthly_sales AS (
        SELECT 
            o.sales_rep_id,
            p.full_name,
            p.commission_tiers,
            COALESCE(SUM(o.grand_total), 0) as total_sales
        FROM orders o
        JOIN profiles p ON o.sales_rep_id = p.id
        WHERE 
            EXTRACT(MONTH FROM o.delivery_date) = p_month 
            AND EXTRACT(YEAR FROM o.delivery_date) = p_year
            AND o.status IN ('HoanThanh', 'DaGiaoHang')
        GROUP BY o.sales_rep_id, p.full_name, p.commission_tiers
    )
    SELECT 
        ms.sales_rep_id,
        ms.sales_rep_name,
        ms.total_sales,
        ms.commission_tiers,
        
        -- Personal Commission Calculation (Hybrid Logic)
        (
            SELECT COALESCE(SUM(
                CASE 
                    -- Case 1: Range fully covered (Sales >= Tier Max)
                    WHEN ms.total_sales >= (tier->>'max')::numeric THEN 
                        ((tier->>'max')::numeric - (tier->>'min')::numeric) * ((tier->>'rate')::numeric / 100)
                    
                    -- Case 2: Range partially covered (Sales inside Tier)
                    WHEN ms.total_sales > (tier->>'min')::numeric AND ms.total_sales < (tier->>'max')::numeric THEN
                        (ms.total_sales - (tier->>'min')::numeric) * ((tier->>'rate')::numeric / 100)
                    
                    -- Case 3: Top tier (Max is null/0/infinity)
                    -- If Sales > Min AND Max is infinite
                    WHEN ms.total_sales > (tier->>'min')::numeric AND ((tier->>'max') IS NULL OR (tier->>'max')::numeric = 0) THEN
                         (ms.total_sales - (tier->>'min')::numeric) * ((tier->>'rate')::numeric / 100)
                    
                    ELSE 0
                END
            ), 0)
            FROM jsonb_array_elements(ms.commission_tiers) as tier
        ) as personal_commission,

        v_group_total_sales as group_sales,
        v_group_target as group_target,
        v_group_rate as group_rate,
        v_group_bonus_fund as group_commission_fund,

        -- Total Commission = Personal + Group Share
        -- Group Share = (Personal Sales / Total Group Sales) * Bonus Fund
        (
             (
                SELECT COALESCE(SUM(
                    CASE 
                        WHEN ms.total_sales >= (tier->>'max')::numeric THEN 
                            ((tier->>'max')::numeric - (tier->>'min')::numeric) * ((tier->>'rate')::numeric / 100)
                        WHEN ms.total_sales > (tier->>'min')::numeric AND ms.total_sales < (tier->>'max')::numeric THEN
                            (ms.total_sales - (tier->>'min')::numeric) * ((tier->>'rate')::numeric / 100)
                        WHEN ms.total_sales > (tier->>'min')::numeric AND ((tier->>'max') IS NULL OR (tier->>'max')::numeric = 0) THEN
                             (ms.total_sales - (tier->>'min')::numeric) * ((tier->>'rate')::numeric / 100)
                        ELSE 0
                    END
                ), 0)
                FROM jsonb_array_elements(ms.commission_tiers) as tier
            )
            + 
            (
                CASE WHEN v_group_total_sales > 0 THEN
                    (ms.total_sales / v_group_total_sales) * v_group_bonus_fund
                ELSE 0 END
            )
        ) as total_commission
    FROM monthly_sales ms;
END;
$$ LANGUAGE plpgsql;
