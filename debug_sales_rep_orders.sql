-- Check distribution of sales_rep_id in orders
SELECT 
    sales_rep_id, 
    COUNT(*) as order_count,
    p.full_name as rep_name
FROM orders o
LEFT JOIN profiles p ON o.sales_rep_id = p.id
GROUP BY sales_rep_id, p.full_name;
