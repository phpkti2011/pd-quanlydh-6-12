
-- ==============================================================================
-- 0. SCHEMA SAFEGUARDS (Fix "column rate does not exist" error)
-- ==============================================================================

-- Ensure commission_policies table exists
CREATE TABLE IF NOT EXISTS commission_policies (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    policy_type TEXT NOT NULL, -- 'GROUP_TIER', etc.
    threshold_min NUMERIC DEFAULT 0,
    rate NUMERIC NOT NULL DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Aggressively ensure columns exist (idempotent)
DO $$
BEGIN
    -- Add 'rate' column if it doesn't exist
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='commission_policies' AND column_name='rate') THEN
        ALTER TABLE commission_policies ADD COLUMN rate NUMERIC NOT NULL DEFAULT 0;
    END IF;

    -- Add 'threshold_min' column if it doesn't exist
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='commission_policies' AND column_name='threshold_min') THEN
        ALTER TABLE commission_policies ADD COLUMN threshold_min NUMERIC DEFAULT 0;
    END IF;

    -- Add 'policy_type' column if it doesn't exist
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='commission_policies' AND column_name='policy_type') THEN
        ALTER TABLE commission_policies ADD COLUMN policy_type TEXT;
    END IF;
    -- Add 'commission_tiers' to profiles if not exists
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='profiles' AND column_name='commission_tiers') THEN
        ALTER TABLE profiles ADD COLUMN commission_tiers JSONB DEFAULT '[]'::jsonb;
    END IF;
END $$;


-- ==============================================================================
-- 1. Helper Function: Calculate Personal Commission (Hybrid Logic)
-- ==============================================================================

-- Drop first to allow signature changes
DROP FUNCTION IF EXISTS calculate_personal_commission_hybrid(NUMERIC, JSONB);

CREATE OR REPLACE FUNCTION calculate_personal_commission_hybrid(
    p_sales NUMERIC,
    p_tiers JSONB
)
RETURNS NUMERIC AS $$
DECLARE
    v_tier RECORD;
    v_prev_rate NUMERIC := 0; 
    v_is_first BOOLEAN := TRUE;
    v_comm NUMERIC := 0;
BEGIN
    -- Handle empty cases
    IF p_sales <= 0 OR p_tiers IS NULL OR jsonb_array_length(p_tiers) = 0 THEN
        RETURN 0;
    END IF;

    -- Iterate directly through JSONB array using cursor loop
    FOR v_tier IN 
        SELECT 
            COALESCE((tier->>'min')::NUMERIC, 0) as min_val,
            (tier->>'max')::NUMERIC as max_val, -- Can be NULL
            COALESCE((tier->>'rate')::NUMERIC, 0) as rate_val
        FROM jsonb_array_elements(p_tiers) as tier
        ORDER BY (tier->>'min')::NUMERIC ASC
    LOOP
        -- Check if sales is within this tier's headers
        -- Cond: Sales >= Min AND (Max IS NULL OR Sales <= Max)
        IF p_sales >= v_tier.min_val AND (v_tier.max_val IS NULL OR p_sales <= v_tier.max_val) THEN
            -- Found the active tier
            
            -- HEURISTIC: If Max is NULL (Infinite) or 0, assume Hybrid Logic (Top Tier)
            IF v_tier.max_val IS NULL OR v_tier.max_val = 0 THEN
                -- HYBRID LOGIC
                IF NOT v_is_first THEN
                    -- Comm = (Base_Threshold * Prev_Rate) + (Excess_Sales * Curr_Rate)
                    -- Base_Threshold is v_tier.min_val (e.g. 250m)
                    v_comm := (v_tier.min_val * (v_prev_rate / 100.0)) + 
                              ((p_sales - v_tier.min_val) * (v_tier.rate_val / 100.0));
                ELSE
                    -- If it's the first and only tier (infinite from 0), just flat rate
                    v_comm := p_sales * (v_tier.rate_val / 100.0);
                END IF;
            ELSE
                -- FLAT LOGIC (Middle/Lower Tiers): Sales * Rate
                v_comm := p_sales * (v_tier.rate_val / 100.0);
            END IF;
            
            RETURN v_comm;
        END IF;

        -- Store rate for next iteration
        v_prev_rate := v_tier.rate_val;
        v_is_first := FALSE;
    END LOOP;

    RETURN 0;
END;
$$ LANGUAGE plpgsql IMMUTABLE;


-- ==============================================================================
-- 2. Main RPC: calculate_sales_commission
-- ==============================================================================

-- Drop ALL variations to avoid overloading confusion and ensure we replace the correct one
DROP FUNCTION IF EXISTS calculate_sales_commission(DATE, DATE);
DROP FUNCTION IF EXISTS calculate_sales_commission(DATE, DATE, TEXT);

CREATE OR REPLACE FUNCTION calculate_sales_commission(
    p_start_date DATE,
    p_end_date DATE,
    p_sales_rep_name TEXT DEFAULT NULL
)
RETURNS TABLE (
    sales_rep_name TEXT,
    personal_sales NUMERIC,
    personal_comm NUMERIC,
    group_sales_total NUMERIC,
    group_comm NUMERIC,
    total_comm NUMERIC,
    commission_tiers JSONB -- Added column for visualization
) AS $$
DECLARE
    v_group_sales NUMERIC := 0;
    v_group_rate NUMERIC := 0;
    v_group_fund NUMERIC := 0;
BEGIN
    -- A. Calculate Total Company/Group Sales (Active orders in period)
    -- Using Pre-VAT as requested
    SELECT COALESCE(SUM(total_amount_pre_vat), 0)
    INTO v_group_sales
    FROM orders
    WHERE created_at::DATE >= p_start_date 
    AND created_at::DATE <= p_end_date
    AND status != 'Huy';

    -- B. Find Group Bonus Rate (if any)
    -- Looks at commission_policies for 'GROUP_TIER'
    -- Safe check for rate column is done at schema level
    SELECT rate INTO v_group_rate
    FROM commission_policies
    WHERE policy_type = 'GROUP_TIER'
    AND v_group_sales >= threshold_min
    ORDER BY threshold_min DESC
    LIMIT 1;

    v_group_fund := v_group_sales * COALESCE(v_group_rate, 0);

    -- C. Return Table with Per-Employee Calculations
    RETURN QUERY
    WITH rep_sales AS (
        SELECT 
            p.id as user_id,
            p.full_name,
            p.commission_tiers,
            COALESCE(SUM(o.total_amount_pre_vat), 0) as total_sales
        FROM orders o
        JOIN profiles p ON o.sales_rep_id = p.id
        WHERE o.created_at::DATE >= p_start_date 
        AND o.created_at::DATE <= p_end_date
        AND o.status != 'Huy'
        -- Optional Filter: If p_sales_rep_name is provided, filter ONLY that user
        -- BUT usually we want context of Group Sales first (calculated above correctly), 
        -- and here we list everyone or just one.
        AND (p_sales_rep_name IS NULL OR p.full_name = p_sales_rep_name)
        GROUP BY p.id, p.full_name, p.commission_tiers
    )
    SELECT 
        rs.full_name,
        rs.total_sales,
        
        -- 1. Personal Comm: Use Helper Function
        -- Note: Ensure commission_tiers is passed correctly
        calculate_personal_commission_hybrid(rs.total_sales, rs.commission_tiers) as personal_comm_val,
        
        v_group_sales,
        
        -- 2. Group Comm: Distribute fund proportional to contribution
        -- Formula: (Personal Sales / Group Sales) * Group Fund
        CASE 
            WHEN v_group_sales > 0 THEN (rs.total_sales / v_group_sales) * v_group_fund 
            ELSE 0 
        END as group_comm_val,
        
        0::NUMERIC, -- Placeholder for total
        
        rs.commission_tiers as commission_tiers -- Return tiers for UI
    FROM rep_sales rs;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- ==============================================================================
-- 3. NOTIFY RELOAD
-- ==============================================================================
NOTIFY pgrst, 'reload schema';
