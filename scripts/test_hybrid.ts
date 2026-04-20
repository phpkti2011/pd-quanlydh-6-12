import { createClient } from '@supabase/supabase-js';

const supabaseUrl = 'https://vqedjnefqrjhcthvzmtg.supabase.co';
const serviceRoleKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZxZWRqbmVmcXJqaGN0aHZ6bXRnIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2NTAwMTM1NiwiZXhwIjoyMDgwNTc3MzU2fQ.YhkXrPbyvsj4ao46UXsUFLxF32mZ10ReUwr_YGPxu0g';

const supabase = createClient(supabaseUrl, serviceRoleKey);

async function testHybridFunction() {
    // Test the hybrid function directly with known tiers
    const tiers = JSON.stringify([
        { min: 0, max: 230000000, rate: 0.5 },
        { min: 230000000, max: 280000000, rate: 1.2 },
        { min: 280000000, max: 0, rate: 2 }  // max=0 means infinity
    ]);

    const sales = 335800177.92;

    console.log("Testing calculate_personal_commission_hybrid directly...");
    console.log(`Sales: ${sales}`);
    console.log(`Tiers: ${tiers}`);

    // Call the function directly
    const { data, error } = await supabase.rpc('calculate_personal_commission_hybrid', {
        p_sales: sales,
        p_tiers: tiers
    });

    if (error) {
        console.error("Error:", error);
    } else {
        console.log(`Result: ${data}`);

        // Expected calculation:
        // Base (280M) at prev rate (1.2%) = 280,000,000 * 0.012 = 3,360,000
        // Excess (55,800,177.92) at current rate (2%) = 55,800,177.92 * 0.02 = 1,116,003.56
        // Total = 4,476,003.56
        const expected = 280000000 * 0.012 + (sales - 280000000) * 0.02;
        console.log(`Expected: ${expected.toFixed(2)}`);
        console.log(`Difference: ${(data - expected).toFixed(2)}`);
    }
}

testHybridFunction();
