import { createClient } from '@supabase/supabase-js';

const supabaseUrl = 'https://vqedjnefqrjhcthvzmtg.supabase.co';
const serviceRoleKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZxZWRqbmVmcXJqaGN0aHZ6bXRnIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2NTAwMTM1NiwiZXhwIjoyMDgwNTc3MzU2fQ.YhkXrPbyvsj4ao46UXsUFLxF32mZ10ReUwr_YGPxu0g';

const supabase = createClient(supabaseUrl, serviceRoleKey);

async function debugCommission() {
    // 1. Get Ly's commission_tiers
    console.log("=== 1. Checking Ly's Commission Tiers ===");
    const { data: profiles, error: profileError } = await supabase
        .from('profiles')
        .select('full_name, commission_tiers')
        .ilike('full_name', '%Ly%');

    if (profileError) {
        console.error("Profile Error:", profileError);
    } else {
        console.log("Profiles with Ly:");
        profiles?.forEach(p => {
            console.log(`  ${p.full_name}:`, JSON.stringify(p.commission_tiers, null, 2));
        });
    }

    // 2. Test the calculate_sales_commission function
    console.log("\n=== 2. Testing calculate_sales_commission ===");
    const { data: commData, error: commError } = await supabase.rpc('calculate_sales_commission', {
        p_start_date: '2026-01-01',
        p_end_date: '2026-01-31',
        p_sales_rep_name: null
    });

    if (commError) {
        console.error("Commission Error:", commError);
    } else {
        console.log("Commission Results:");
        commData?.forEach((c: any) => {
            if (c.sales_rep_name?.includes('Ly')) {
                console.log(`  ${c.sales_rep_name}:`);
                console.log(`    Personal Sales: ${c.personal_sales?.toLocaleString()}`);
                console.log(`    Personal Comm: ${c.personal_comm?.toLocaleString()}`);
                console.log(`    Tiers: ${JSON.stringify(c.commission_tiers)}`);
            }
        });
    }
}

debugCommission();
