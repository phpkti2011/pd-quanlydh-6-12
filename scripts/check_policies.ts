
import { createClient } from '@supabase/supabase-js';

const supabaseUrl = 'https://vqedjnefqrjhcthvzmtg.supabase.co';
const serviceRoleKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZxZWRqbmVmcXJqaGN0aHZ6bXRnIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2NTAwMTM1NiwiZXhwIjoyMDgwNTc3MzU2fQ.YhkXrPbyvsj4ao46UXsUFLxF32mZ10ReUwr_YGPxu0g';

const supabase = createClient(supabaseUrl, serviceRoleKey);

async function checkPolicies() {
    console.log("Checking commission_policies...");

    const { data, error } = await supabase
        .from('commission_policies')
        .select('*')
        .eq('policy_type', 'MAINTASK_RATE')
        .order('id');

    if (error) {
        console.error("Error:", error);
    } else {
        console.table(data);
    }
}

checkPolicies();
