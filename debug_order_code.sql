-- 1. Check for orders with empty or suspicious codes
SELECT id, order_code, created_at 
FROM orders 
WHERE order_code IS NULL OR order_code = '' OR order_code LIKE '%PD.%';

-- 2. Test the generation function directly
SELECT generate_order_code() as generated_code;

-- 3. Check if trigger exists
SELECT tgname, tgrelid::regclass, tgtype, tgenabled 
FROM pg_trigger 
WHERE tgname = 'before_insert_order_code';

-- 4. Check function definition (to verify timezone logic)
SELECT pg_get_functiondef('generate_order_code'::regproc);
