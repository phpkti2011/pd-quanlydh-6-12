-- RUN THIS IN SUPABASE SQL EDITOR TO TEST DIRECTLY
-- This will show you what the function returns vs expected

-- First, let's see what the current function returns
SELECT calculate_personal_commission_hybrid(
    335800177.92,
    '[{"min":0,"max":230000000,"rate":0.5},{"min":230000000,"max":280000000,"rate":1.2},{"min":280000000,"max":0,"rate":2}]'::jsonb
) as current_result;

-- Expected: 4476003.56 (which is 280000000 * 0.012 + 55800177.92 * 0.02)
-- If it returns 6716004, the function was NOT updated correctly

-- To see the function definition:
SELECT prosrc 
FROM pg_proc 
WHERE proname = 'calculate_personal_commission_hybrid';
