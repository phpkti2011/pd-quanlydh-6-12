-- ==============================================================================
-- COMPLETE FIX V2 - With CASCADE to handle dependencies
-- Run this ENTIRE script in Supabase SQL Editor
-- ==============================================================================

-- Step 1: Drop the function with CASCADE to remove dependencies
DROP FUNCTION IF EXISTS calculate_personal_commission_hybrid(NUMERIC, JSONB) CASCADE;

-- Step 2: Recreate the fixed function
CREATE OR REPLACE FUNCTION calculate_personal_commission_hybrid(
    p_sales NUMERIC,
    p_tiers JSONB
)
RETURNS NUMERIC AS $$
DECLARE
    v_tier RECORD;
    v_prev_tier_rate NUMERIC := 0; 
    v_comm NUMERIC := 0;
    v_tier_index INT := 0;
BEGIN
    -- Handle empty cases
    IF p_sales <= 0 OR p_tiers IS NULL OR jsonb_array_length(p_tiers) = 0 THEN
        RETURN 0;
    END IF;

    -- Iterate through tiers sorted by min
    FOR v_tier IN 
        SELECT 
            COALESCE((tier->>'min')::NUMERIC, 0) as min_val,
            (tier->>'max')::NUMERIC as max_val,
            COALESCE((tier->>'rate')::NUMERIC, 0) as rate_val
        FROM jsonb_array_elements(p_tiers) as tier
        ORDER BY (tier->>'min')::NUMERIC ASC
    LOOP
        v_tier_index := v_tier_index + 1;
        
        -- Infinite tier (max is NULL or 0)
        IF v_tier.max_val IS NULL OR v_tier.max_val = 0 THEN
            IF p_sales >= v_tier.min_val THEN
                -- HYBRID: Base * PrevRate + Excess * CurrentRate
                IF v_tier_index > 1 THEN
                    v_comm := (v_tier.min_val * (v_prev_tier_rate / 100.0)) + 
                              ((p_sales - v_tier.min_val) * (v_tier.rate_val / 100.0));
                ELSE
                    v_comm := p_sales * (v_tier.rate_val / 100.0);
                END IF;
                RETURN v_comm;
            END IF;
        ELSE
            -- Finite tier
            IF p_sales >= v_tier.min_val AND p_sales <= v_tier.max_val THEN
                v_comm := p_sales * (v_tier.rate_val / 100.0);
                RETURN v_comm;
            END IF;
        END IF;
        
        -- CRITICAL: Update prev_tier_rate for next iteration
        v_prev_tier_rate := v_tier.rate_val;
    END LOOP;

    RETURN 0;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- Step 3: Test immediately
SELECT calculate_personal_commission_hybrid(
    335800177.92,
    '[{"min":0,"max":230000000,"rate":0.5},{"min":230000000,"max":280000000,"rate":1.2},{"min":280000000,"max":0,"rate":2}]'::jsonb
) as result;

-- Expected result: 4476003.56 (rounded to 4476004)
-- If you see 6716004, something is wrong

-- Step 4: Reload schema
NOTIFY pgrst, 'reload schema';
