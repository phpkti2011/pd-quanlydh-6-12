-- ==============================================================================
-- COMPLETE FIX for Sales Commission Calculation
-- Run this entire script in Supabase SQL Editor
-- ==============================================================================

-- Step 1: Drop old function
DROP FUNCTION IF EXISTS calculate_personal_commission_hybrid(NUMERIC, JSONB);

-- Step 2: Create fixed function
CREATE OR REPLACE FUNCTION calculate_personal_commission_hybrid(
    p_sales NUMERIC,
    p_tiers JSONB
)
RETURNS NUMERIC AS $$
DECLARE
    v_tier RECORD;
    v_prev_tier_rate NUMERIC := 0; 
    v_comm NUMERIC := 0;
    v_current_index INT := 0;
BEGIN
    -- Handle empty cases
    IF p_sales <= 0 OR p_tiers IS NULL OR jsonb_array_length(p_tiers) = 0 THEN
        RETURN 0;
    END IF;

    -- Iterate through JSONB tiers sorted by min value
    FOR v_tier IN 
        SELECT 
            COALESCE((tier->>'min')::NUMERIC, 0) as min_val,
            (tier->>'max')::NUMERIC as max_val,
            COALESCE((tier->>'rate')::NUMERIC, 0) as rate_val,
            row_number() OVER (ORDER BY (tier->>'min')::NUMERIC ASC) as tier_index
        FROM jsonb_array_elements(p_tiers) as tier
        ORDER BY (tier->>'min')::NUMERIC ASC
    LOOP
        v_current_index := v_tier.tier_index;
        
        -- Is this tier an "infinite" tier (max is NULL or 0)?
        IF v_tier.max_val IS NULL OR v_tier.max_val = 0 THEN
            -- Check if sales falls into this infinite tier
            IF p_sales >= v_tier.min_val THEN
                -- HYBRID LOGIC for infinite tier
                IF v_current_index > 1 THEN
                    -- Formula: (Threshold * PrevRate) + (Excess * CurrentRate)
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
        
        -- CRITICAL: Update prev_tier_rate AFTER checking current tier
        v_prev_tier_rate := v_tier.rate_val;
    END LOOP;

    RETURN 0;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- Step 3: Test the function directly
DO $$
DECLARE
    v_result NUMERIC;
    v_tiers JSONB := '[{"min":0,"max":230000000,"rate":0.5},{"min":230000000,"max":280000000,"rate":1.2},{"min":280000000,"max":0,"rate":2}]'::jsonb;
    v_sales NUMERIC := 335800177.92;
    v_expected NUMERIC;
BEGIN
    v_result := calculate_personal_commission_hybrid(v_sales, v_tiers);
    -- Expected: 280000000 * 0.012 + 55800177.92 * 0.02 = 3360000 + 1116003.56 = 4476003.56
    v_expected := 280000000 * 0.012 + (v_sales - 280000000) * 0.02;
    
    RAISE NOTICE '========================================';
    RAISE NOTICE 'TEST RESULT:';
    RAISE NOTICE 'Sales: %', v_sales;
    RAISE NOTICE 'Actual Commission: %', v_result;
    RAISE NOTICE 'Expected Commission: %', v_expected;
    RAISE NOTICE 'Match: %', (ABS(v_result - v_expected) < 1);
    RAISE NOTICE '========================================';
END $$;

-- Step 4: Refresh schema
NOTIFY pgrst, 'reload schema';
