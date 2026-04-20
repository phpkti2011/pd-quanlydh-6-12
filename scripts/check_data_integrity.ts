
import { createClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';
import path from 'path';

dotenv.config({ path: path.join(process.cwd(), '.env.local') });

const supabaseUrl = process.env.VITE_SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

if (!supabaseUrl || !supabaseKey) {
    process.exit(1);
}

const supabase = createClient(supabaseUrl, supabaseKey);

async function inspectData() {
    console.log("--- Inspecting Orders ---");
    const { data: orders } = await supabase
        .from('orders')
        .select('id, sales_rep_id, created_at')
        .limit(5);
    console.log('Orders sample (sales_rep_id):', orders);

    console.log("\n--- Inspecting Participants ---");
    const { data: parts } = await supabase
        .from('order_process_participants')
        .select('id, user_id, stage')
        .limit(5);
    console.log('Participants sample (user_id):', parts);

    console.log("\n--- Inspecting Profiles ---");
    const { data: profiles } = await supabase
        .from('profiles')
        .select('id, email, full_name, role');
    console.log('Profiles:', profiles);
}

inspectData();
