-- ==============================================================================
-- FINAL FIX: Recreate calculate_sales_commission
-- ==============================================================================

-- Step 1: Drop ALL versions of the function
DROP FUNCTION IF EXISTS calculate_sales_commission(DATE, DATE) CASCADE;
DROP FUNCTION IF EXISTS calculate_sales_commission(DATE, DATE, TEXT) CASCADE;
DROP FUNCTION IF EXISTS calculate_sales_commission(INT, INT) CASCADE;
DROP FUNCTION IF EXISTS calculate_sales_commission(INT, INT, TEXT) CASCADE;

-- Step 2: Recreate the main RPC function
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
BEGIN
    -- A. Calculate Total Group Sales
    SELECT COALESCE(SUM(total_amount_pre_vat), 0)
    INTO v_group_sales
    FROM orders
    WHERE created_at::DATE >= p_start_date 
    AND created_at::DATE <= p_end_date
    AND status != 'Huy';

    -- B. Find Group Bonus Rate
    SELECT rate INTO v_group_rate
    FROM commission_policies
    WHERE policy_type = 'GROUP_TIER'
    AND v_group_sales >= threshold_min
    ORDER BY threshold_min DESC
    LIMIT 1;

    v_group_fund := v_group_sales * COALESCE(v_group_rate, 0);

    -- C. Return Table with Per-Employee Calculations
    RETURN QUERY
    WITH rep_sales AS (
        SELECT 
            p.id as user_id,
            p.full_name,
            p.commission_tiers,
            COALESCE(SUM(o.total_amount_pre_vat), 0) as total_sales
        FROM orders o
        JOIN profiles p ON o.sales_rep_id = p.id
        WHERE o.created_at::DATE >= p_start_date 
        AND o.created_at::DATE <= p_end_date
        AND o.status != 'Huy'
        AND (p_sales_rep_name IS NULL OR p.full_name = p_sales_rep_name)
        GROUP BY p.id, p.full_name, p.commission_tiers
    )
    SELECT 
        rs.full_name,
        rs.total_sales,
        
        -- Use the FIXED helper function
        calculate_personal_commission_hybrid(rs.total_sales, rs.commission_tiers) as personal_comm_val,
        
        v_group_sales,
        
        CASE 
            WHEN v_group_sales > 0 THEN (rs.total_sales / v_group_sales) * v_group_fund 
            ELSE 0 
        END as group_comm_val,
        
        0::NUMERIC,
        
        rs.commission_tiers
    FROM rep_sales rs;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Step 3: Test with explicit types
SELECT sales_rep_name, personal_sales, personal_comm 
FROM calculate_sales_commission('2026-01-01'::DATE, '2026-01-31'::DATE, NULL::TEXT)
WHERE sales_rep_name LIKE '%Ly%';

-- Step 4: Reload
NOTIFY pgrst, 'reload schema';
