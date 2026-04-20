-- ==============================================================================
-- FIX SALES COMMISSION: Fallback to Global Policies if Personal Rates are missing
-- ==============================================================================

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
    group_comm NUMERIC,
    group_sales_total NUMERIC
) AS $$
BEGIN
    RETURN QUERY
    WITH sales_data AS (
        -- 1. Calculate Personal Sales for each Rep
        SELECT 
            p.id as user_id,
            p.full_name,
            -- Fetch Rates (Personal -> Global -> 0)
            COALESCE((p.commission_sales->>'rate')::NUMERIC, cp_personal.rate, 0) as personal_rate,
            COALESCE((p.commission_sales->>'threshold')::NUMERIC, cp_personal.threshold_min, 0) as personal_threshold,
            
            -- Fetch Group Rates (if Admin)
            COALESCE((p.commission_sales->>'group_rate')::NUMERIC, cp_group.rate, 0) as group_rate,
            
            COALESCE(SUM(o.total_amount), 0) as total_sales
        FROM profiles p
        LEFT JOIN orders o ON o.sales_rep_id = p.id 
            AND o.created_at::DATE >= p_start_date 
            AND o.created_at::DATE <= p_end_date
            AND o.status != 'Huy'
        
        -- Join Global Policies
        LEFT JOIN commission_policies cp_personal ON cp_personal.policy_type = 'SALES_PERSONAL_RATE'
        LEFT JOIN commission_policies cp_group ON cp_group.policy_type = 'SALES_GROUP_RATE'
        
        WHERE p.role IN ('NhanVienKinhDoanh', 'Admin') 
        AND (p_sales_rep_name IS NULL OR p.full_name = p_sales_rep_name)
        GROUP BY p.id, p.full_name, p.commission_sales, cp_personal.rate, cp_personal.threshold_min, cp_group.rate
    ),
    
    group_total AS (
        -- 2. Calculate Total Group Sales (for Group Bonus)
        SELECT SUM(total_sales) as grand_total FROM sales_data
    )

    SELECT 
        sd.full_name,
        sd.total_sales,
        
        -- A. Personal Commission: (Sales - Threshold) * Rate
        CASE 
            WHEN sd.total_sales > sd.personal_threshold THEN 
                (sd.total_sales - sd.personal_threshold) * sd.personal_rate
            ELSE 0 
        END as prob_comm,
        
        -- B. Group Commission: Grand Total * Group Rate (Only if rate > 0)
        CASE 
            WHEN sd.group_rate > 0 THEN 
                (SELECT grand_total FROM group_total) * sd.group_rate
            ELSE 0 
        END as group_comm,
        
        (SELECT grand_total FROM group_total) as group_sales_total
        
    FROM sales_data sd;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Re-apply notification
NOTIFY pgrst, 'reload schema';
