-- Check if function exists
SELECT routine_name, routine_type 
FROM information_schema.routines 
WHERE routine_name = 'calculate_sales_commission_v2';
