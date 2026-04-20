-- Create V2 function to avoid conflict/caching issues with V1
DROP FUNCTION IF EXISTS calculate_sales_commission_v2(DATE, DATE, TEXT);

CREATE OR REPLACE FUNCTION calculate_sales_commission_v2(
    p_start_date DATE,
    p_end_date DATE,
    p_sales_rep_name TEXT DEFAULT NULL -- Optional filter
)
RETURNS TABLE (
    sales_rep_name TEXT,
    personal_sales NUMERIC,
    personal_comm NUMERIC,
    group_sales_total NUMERIC,
    group_comm NUMERIC,
    total_comm NUMERIC,
    -- New Metrics
    total_orders INTEGER,
    highest_order_value NUMERIC,
    new_customers INTEGER,
    success_rate NUMERIC, 
    active_days INTEGER
) AS $$
DECLARE
    v_group_sales NUMERIC;
    v_group_rate NUMERIC := 0;
    v_group_fund NUMERIC;
BEGIN
    -- 1. Calculate Group Sales (Only Valid Orders)
    SELECT COALESCE(SUM(total_amount), 0)
    INTO v_group_sales
    FROM orders
    WHERE created_at::DATE >= p_start_date AND created_at::DATE <= p_end_date
    AND status != 'Huy';

    -- 2. Determine Group Rate
    SELECT rate INTO v_group_rate
    FROM commission_policies
    WHERE policy_type = 'GROUP_TIER'
    AND v_group_sales >= threshold_min
    ORDER BY threshold_min DESC
    LIMIT 1;

    v_group_fund := v_group_sales * COALESCE(v_group_rate, 0);

    RETURN QUERY
    WITH rep_sales_stats AS (
        SELECT 
            p.full_name,
            p.id as rep_id,
            -- Revenue (Excluding Cancelled)
            COALESCE(SUM(CASE WHEN o.status != 'Huy' THEN o.total_amount ELSE 0 END), 0) as total_sales,
            
            -- Count Orders (Valid Only - 'HoanThanh', 'DaGiaoHang', 'Moi', etc. except 'Huy')
            COUNT(CASE WHEN o.status != 'Huy' THEN 1 END) as valid_order_count,
            
            -- Total Created (For Success Rate)
            COUNT(*) as total_created_count,
            
            -- Max Value (Valid Only)
            COALESCE(MAX(CASE WHEN o.status != 'Huy' THEN o.total_amount ELSE 0 END), 0) as max_val,
            
            -- Active Days (Valid Orders Only)
            COUNT(DISTINCT CASE WHEN o.status != 'Huy' THEN o.created_at::DATE END) as active_days_count

        FROM orders o
        JOIN profiles p ON o.sales_rep_id = p.id
        WHERE o.created_at::DATE >= p_start_date AND o.created_at::DATE <= p_end_date
        -- Note: We do NOT filter status != 'Huy' here so we can count total attempts
        AND (p_sales_rep_name IS NULL OR p.full_name = p_sales_rep_name)
        GROUP BY p.full_name, p.id
    ),
    rep_new_customers AS (
        SELECT 
            sales_rep_id,
            COUNT(*) as new_cust_count
        FROM customers
        WHERE created_at::DATE >= p_start_date AND created_at::DATE <= p_end_date
        GROUP BY sales_rep_id
    )
    SELECT 
        rss.full_name,
        rss.total_sales,
        -- Calculate Personal Comm based on Tiers
        (
            SELECT COALESCE(rate, 0)
            FROM commission_policies cp
            WHERE cp.policy_type = 'SALES_TIER' 
            AND cp.apply_to = rss.full_name
            AND rss.total_sales > cp.threshold_min
            ORDER BY cp.threshold_min DESC
            LIMIT 1
        ) * rss.total_sales as personal_comm_val,
        
        v_group_sales,
        
        -- Group Comm Contribution
        CASE WHEN v_group_sales > 0 THEN (rss.total_sales / v_group_sales) * v_group_fund 
             ELSE 0 END as group_comm_val,
             
        0::NUMERIC, -- Total placeholder

        -- New Metrics Mapping
        rss.valid_order_count::INTEGER,
        rss.max_val,
        COALESCE(rnc.new_cust_count, 0)::INTEGER,
        -- Success Rate: (Valid / Total Created) * 100
        CASE WHEN rss.total_created_count > 0 THEN ROUND((rss.valid_order_count::NUMERIC / rss.total_created_count) * 100, 1) 
             ELSE 0 END,
        rss.active_days_count::INTEGER

    FROM rep_sales_stats rss
    LEFT JOIN rep_new_customers rnc ON rss.rep_id = rnc.sales_rep_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
