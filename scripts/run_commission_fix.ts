import { createClient } from '@supabase/supabase-js';

const supabaseUrl = 'https://vqedjnefqrjhcthvzmtg.supabase.co';
const serviceRoleKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZxZWRqbmVmcXJqaGN0aHZ6bXRnIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2NTAwMTM1NiwiZXhwIjoyMDgwNTc3MzU2fQ.YhkXrPbyvsj4ao46UXsUFLxF32mZ10ReUwr_YGPxu0g';

const supabase = createClient(supabaseUrl, serviceRoleKey);

async function fixCommissionFunction() {
    console.log("🔧 Fixing calculate_personal_commission_hybrid function...");

    const sql = `
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
            IF p_sales >= v_tier.min_val AND p_sales <= v_tier.max_val THEN
                -- FLAT LOGIC: Apply rate to entire sales
                v_comm := p_sales * (v_tier.rate_val / 100.0);
                RETURN v_comm;
            END IF;
        END IF;
        
        -- IMPORTANT: Always update prev_tier_rate for the NEXT iteration
        v_prev_tier_rate := v_tier.rate_val;
    END LOOP;

    RETURN 0;
END;
$$ LANGUAGE plpgsql IMMUTABLE;
`;

    const { error } = await supabase.rpc('exec_sql', { sql_query: sql });

    if (error) {
        // Try direct SQL if exec_sql doesn't exist
        console.log("⚠️ exec_sql not available, trying pgrest direct...");

        // Use Supabase SQL via management API
        const response = await fetch(`${supabaseUrl}/rest/v1/rpc/`, {
            method: 'POST',
            headers: {
                'apikey': serviceRoleKey,
                'Authorization': `Bearer ${serviceRoleKey}`,
                'Content-Type': 'application/json'
            }
        });

        console.error("❌ Cannot execute SQL directly via API.");
        console.log("\n📋 SOLUTION: Please run this SQL manually in Supabase Dashboard:");
        console.log("1. Go to: https://supabase.com/dashboard/project/vqedjnefqrjhcthvzmtg/sql/new");
        console.log("2. Paste the content of file: fix_commission_hybrid.sql");
        console.log("3. Click 'Run'");
        return;
    }

    console.log("✅ Function updated successfully!");

    // Test the fix
    console.log("\n🧪 Testing the fix...");
    const { data: testData, error: testError } = await supabase.rpc('calculate_sales_commission', {
        p_start_date: '2026-01-01',
        p_end_date: '2026-01-31'
    });

    if (testError) {
        console.error("Test Error:", testError);
    } else {
        testData?.forEach((c: any) => {
            if (c.sales_rep_name?.includes('Ly')) {
                console.log(`\n${c.sales_rep_name}:`);
                console.log(`  Sales: ${c.personal_sales?.toLocaleString()}`);
                console.log(`  Commission: ${c.personal_comm?.toLocaleString()}`);
            }
        });
    }
}

fixCommissionFunction();
