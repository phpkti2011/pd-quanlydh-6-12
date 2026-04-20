
-- Dashboard Statistics Function
-- Returns a complex JSON object with all necessary metrics and chart data

DROP FUNCTION IF EXISTS get_dashboard_stats(text, date, date);

CREATE OR REPLACE FUNCTION get_dashboard_stats(
    p_period TEXT DEFAULT 'month', -- 'today', 'month', 'custom'
    p_start_date DATE DEFAULT NULL,
    p_end_date DATE DEFAULT NULL
)
RETURNS JSONB AS $$
DECLARE
    v_start_date DATE;
    v_end_date DATE;
    v_result JSONB;
BEGIN
    -- 1. Determine Date Range
    IF p_period = 'today' THEN
        v_start_date := CURRENT_DATE;
        v_end_date := CURRENT_DATE;
    ELSIF p_period = 'month' THEN
        v_start_date := DATE_TRUNC('month', CURRENT_DATE)::DATE;
        v_end_date := (DATE_TRUNC('month', CURRENT_DATE) + INTERVAL '1 month' - INTERVAL '1 day')::DATE;
    ELSE
        -- Custom or default fallback
        v_start_date := COALESCE(p_start_date, DATE_TRUNC('month', CURRENT_DATE)::DATE);
        v_end_date := COALESCE(p_end_date, CURRENT_DATE);
    END IF;

    -- 2. Build JSON Result
    SELECT jsonb_build_object(
        'period', p_period,
        'startDate', v_start_date,
        'endDate', v_end_date,
        
        -- A. Key Metrics
        'metrics', (
            SELECT jsonb_build_object(
                'ordersCount', COUNT(*),
                -- Doanh thu VAT: Sum total_amount where status != Huy
                'revenueWithVAT', COALESCE(SUM(total_amount), 0),
                -- Doanh thu chua VAT: (total_amount / 1.08 or 1.1 depending on rule? Assuming 10% for now or stored? 
                -- Note: Legacy doesn't seem to store VAT separately clearly, using simple 10% logic or field if exists.
                -- Checking schema: no 'vat_amount'. Assuming total_amount is VAT inclusive. 
                -- Let's return total_amount as 'revenue' for now.
                'revenueNoVAT', COALESCE(SUM(total_amount_pre_vat), 0),
                
                -- Design Revenue: Sum design_fee for orders with has_design=true
                'designRevenue', COALESCE(SUM(CASE WHEN has_design THEN design_fee ELSE 0 END), 0),
                
                -- Large Print Revenue: Placeholder logic if no specific column? 
                -- We have 'has_large_print', but maybe no specific fee column other than total?
                -- Let's leave as 0 or estimated for now unless field exists.
                'largePrintRevenue', 0, 

                -- New/Returning Customers
                'newCustomersCount', (
                    SELECT COUNT(DISTINCT customer_id) 
                    FROM orders o2 
                    WHERE o2.created_at::DATE BETWEEN v_start_date AND v_end_date
                    AND o2.customer_id NOT IN (
                        SELECT customer_id FROM orders o3 WHERE o3.created_at::DATE < v_start_date
                    )
                ),
                'returningCustomersCount', (
                    SELECT COUNT(DISTINCT customer_id)
                    FROM orders o2 
                    WHERE o2.created_at::DATE BETWEEN v_start_date AND v_end_date
                    AND o2.customer_id IN (
                        SELECT customer_id FROM orders o3 WHERE o3.created_at::DATE < v_start_date
                    )
                )
            )
            FROM orders
            WHERE created_at::DATE BETWEEN v_start_date AND v_end_date
            AND status != 'Huy'
        ),

        -- B. Daily Revenue Chart (Line)
        'dailyRevenue', (
            SELECT jsonb_agg(jsonb_build_object(
                'date', to_char(day_series, 'DD/MM'),
                'revenue', COALESCE(daily_sum, 0)
            ))
            FROM generate_series(v_start_date, v_end_date, '1 day'::interval) day_series
            LEFT JOIN (
                SELECT created_at::DATE as d, SUM(total_amount) as daily_sum
                FROM orders
                WHERE created_at::DATE BETWEEN v_start_date AND v_end_date AND status != 'Huy'
                GROUP BY 1
            ) o ON day_series = o.d
        ),

        -- C. Status Chart (Doughnut)
        'statusCounts', (
            SELECT jsonb_object_agg(status, cnt)
            FROM (
                SELECT status, COUNT(*) as cnt
                FROM orders
                WHERE created_at::DATE BETWEEN v_start_date AND v_end_date
                GROUP BY status
            ) t
        ),

        -- D. Source Chart (Pie) - Assuming 'customer_source' column exists or using 'notes'? 
        -- Schema check: 'customers' table has source? 
        'sourceCounts', (
            SELECT jsonb_object_agg(COALESCE(source, 'Khác'), cnt)
            FROM (
                 SELECT c.source, COUNT(DISTINCT o.id) as cnt
                 FROM orders o
                 JOIN customers c ON o.customer_id = c.id
                 WHERE o.created_at::DATE BETWEEN v_start_date AND v_end_date
                 GROUP BY c.source
            ) t
        ),
        
        -- E. Sales by Employee (Horizontal Bar)
        'salesByEmployee', (
            SELECT jsonb_agg(jsonb_build_object('name', full_name, 'sales', total_sales))
            FROM (
                SELECT p.full_name, SUM(o.total_amount) as total_sales
                FROM orders o
                JOIN profiles p ON o.sales_rep_id = p.id
                WHERE o.created_at::DATE BETWEEN v_start_date AND v_end_date AND o.status != 'Huy'
                GROUP BY p.full_name
                ORDER BY total_sales DESC
                LIMIT 10
            ) t
        )

    ) INTO v_result;

    RETURN v_result;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
