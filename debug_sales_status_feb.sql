-- Check STATUS of orders created between Feb 1 and Feb 5, 2026
SELECT 
    sales_rep_id, 
    p.full_name as rep_name,
    status,
    COUNT(*) as count_per_status
FROM orders o
LEFT JOIN profiles p ON o.sales_rep_id = p.id
WHERE o.created_at >= '2026-02-01 00:00:00' 
  AND o.created_at <= '2026-02-05 23:59:59'
GROUP BY sales_rep_id, p.full_name, status
ORDER BY sales_rep_id, status;
