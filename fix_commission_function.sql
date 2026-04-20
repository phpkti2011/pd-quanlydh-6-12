-- ==============================================================================
-- FIX SALES COMMISSION: Use commission_tiers column
-- Version 2: Added group_rate and group_bonus_fund for UI
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
    group_sales_total NUMERIC,
    kpi_target NUMERIC,
    commission_tiers JSONB,
    tier_rate_applied NUMERIC,
    group_rate NUMERIC,      -- New
    group_bonus_fund NUMERIC -- New
) AS $$
BEGIN
    RETURN QUERY
    WITH sales_data AS (
        SELECT 
            p.id as user_id,
            p.full_name,
            COALESCE(SUM(o.total_amount), 0) as total_sales,
            
            -- Fetch Sales Target for this month (KPI)
            COALESCE((
                SELECT target_amount FROM sales_targets 
                WHERE entity_type = 'user' AND entity_id = p.id 
                AND period_month = EXTRACT(MONTH FROM p_start_date)::INT 
                AND period_year = EXTRACT(YEAR FROM p_start_date)::INT
                LIMIT 1
            ), 0) as kpi_target,

            -- Fetch Commission Tiers (Personal)
            p.commission_tiers,
            
            -- Fetch Group Rate (Global Policy)
            -- Assuming we might have a policy table or just hardcode/json for now if policy table empty
            COALESCE(
                 (SELECT rate FROM commission_policies WHERE policy_type = 'SALES_GROUP_RATE' LIMIT 1),
                 0.01 -- Default 1% if no policy found
            ) as group_rate,
            
            p.role

        FROM profiles p
        LEFT JOIN orders o ON o.sales_rep_id = p.id 
            AND o.created_at::DATE >= p_start_date 
            AND o.created_at::DATE <= p_end_date
            AND o.status != 'Huy'
        WHERE p.role IN ('NhanVienKinhDoanh', 'Admin') 
        AND (p_sales_rep_name IS NULL OR p.full_name = p_sales_rep_name)
        GROUP BY p.id, p.full_name, p.commission_tiers, p.role
    ),
    
    group_info AS (
        SELECT 
            SUM(total_sales) as grand_total,
            -- Fetch Company/Department Target
            COALESCE((
                SELECT target_amount FROM sales_targets
                WHERE department_name = 'Sales'
                AND period_month = EXTRACT(MONTH FROM p_start_date)::INT
                AND period_year = EXTRACT(YEAR FROM p_start_date)::INT
                LIMIT 1
            ), 0) as group_target
        FROM sales_data
    ),

    calculated_tiers AS (
        SELECT 
            sd.user_id,
            sd.full_name,
            sd.total_sales,
            sd.kpi_target,
            sd.group_rate,
            sd.commission_tiers,
            sd.role,
            
            -- Find matching tier for Personal Sales
            (
                SELECT (tier->>'rate')::NUMERIC
                FROM jsonb_array_elements(sd.commission_tiers) as tier
                WHERE sd.total_sales >= (tier->>'min')::NUMERIC
                AND (
                    (tier->>'max')::NUMERIC = 0 OR 
                    sd.total_sales <= (tier->>'max')::NUMERIC
                )
                ORDER BY (tier->>'min')::NUMERIC DESC
                LIMIT 1
            ) as matched_rate
        FROM sales_data sd
    )

    SELECT 
        ct.full_name,
        ct.total_sales,
        
        -- Personal Commission:
        ROUND(ct.total_sales * COALESCE(ct.matched_rate, 0) / 100, 0) as personal_comm,
        
        -- Group Bonus Logic:
        CASE 
            WHEN ct.role = 'Admin' AND (SELECT grand_total FROM group_info) >= (SELECT group_target FROM group_info) THEN
                ROUND((SELECT grand_total FROM group_info) * ct.group_rate, 0)
            ELSE 0
        END as group_comm, 
        
        (SELECT grand_total FROM group_info) as group_sales_total,
        ct.kpi_target,
        ct.commission_tiers, 
        COALESCE(ct.matched_rate, 0) as tier_rate_applied,
        
        -- New fields
        ct.group_rate,
        ROUND((SELECT grand_total FROM group_info) * ct.group_rate, 0) as group_bonus_fund
        
    FROM calculated_tiers ct;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

NOTIFY pgrst, 'reload schema';
