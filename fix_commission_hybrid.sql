
-- ==============================================================================
-- FIX: calculate_personal_commission_hybrid - Correctly track previous tier rate
-- ==============================================================================

DROP FUNCTION IF EXISTS calculate_personal_commission_hybrid(NUMERIC, JSONB);

CREATE OR REPLACE FUNCTION calculate_personal_commission_hybrid(
    p_sales NUMERIC,
    p_tiers JSONB
)
RETURNS NUMERIC AS $$
DECLARE
    v_tier RECORD;
    v_prev_tier_rate NUMERIC := 0; 
    v_comm NUMERIC := 0;
    v_tiers_count INT;
    v_current_index INT := 0;
BEGIN
    -- Handle empty cases
    IF p_sales <= 0 OR p_tiers IS NULL OR jsonb_array_length(p_tiers) = 0 THEN
        RETURN 0;
    END IF;
    
    v_tiers_count := jsonb_array_length(p_tiers);

    -- Iterate through JSONB tiers sorted by min value
    FOR v_tier IN 
        SELECT 
            COALESCE((tier->>'min')::NUMERIC, 0) as min_val,
            (tier->>'max')::NUMERIC as max_val, -- Can be NULL or 0 for infinity
            COALESCE((tier->>'rate')::NUMERIC, 0) as rate_val,
            row_number() OVER (ORDER BY (tier->>'min')::NUMERIC ASC) as tier_index
        FROM jsonb_array_elements(p_tiers) as tier
        ORDER BY (tier->>'min')::NUMERIC ASC
    LOOP
        v_current_index := v_tier.tier_index;
        
        -- Is this tier an "infinite" tier (max is NULL or 0)?
        -- Infinite tier means: min <= sales (no upper bound)
        IF v_tier.max_val IS NULL OR v_tier.max_val = 0 THEN
            -- Check if sales falls into this infinite tier
            IF p_sales >= v_tier.min_val THEN
                -- HYBRID LOGIC for infinite tier:
                -- Base amount (threshold) uses PREVIOUS tier's rate
                -- Excess amount uses CURRENT tier's rate
                IF v_current_index > 1 THEN
                    -- Formula: (Threshold * PrevRate) + (Excess * CurrentRate)
                    v_comm := (v_tier.min_val * (v_prev_tier_rate / 100.0)) + 
                              ((p_sales - v_tier.min_val) * (v_tier.rate_val / 100.0));
                ELSE
                    -- First tier is infinite (rare), just flat rate
                    v_comm := p_sales * (v_tier.rate_val / 100.0);
                END IF;
                RETURN v_comm;
            END IF;
        ELSE
            -- Finite tier with max boundary
            -- Check if sales falls within [min, max]
            IF p_sales >= v_tier.min_val AND p_sales <= v_tier.max_val THEN
                -- FLAT LOGIC: Apply rate to entire sales
                v_comm := p_sales * (v_tier.rate_val / 100.0);
                RETURN v_comm;
            END IF;
        END IF;
        
        -- IMPORTANT: Always update prev_tier_rate for the NEXT iteration
        -- This happens whether or not we matched the current tier
        v_prev_tier_rate := v_tier.rate_val;
    END LOOP;

    RETURN 0;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- Notify reload
NOTIFY pgrst, 'reload schema';
