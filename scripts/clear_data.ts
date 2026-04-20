
import { createClient } from '@supabase/supabase-js';
import fs from 'fs';
import path from 'path';
import dotenv from 'dotenv';

// 1. Load Environment Variables from .env.local
const envPath = path.resolve(process.cwd(), '.env.local');
if (fs.existsSync(envPath)) {
    const envConfig = dotenv.parse(fs.readFileSync(envPath));
    for (const k in envConfig) {
        process.env[k] = envConfig[k];
    }
} else {
    console.warn("No .env.local found, trying process.env...");
}

const supabaseUrl = process.env.VITE_SUPABASE_URL;
const supabaseKey = process.env.VITE_SUPABASE_ANON_KEY;

if (!supabaseUrl || !supabaseKey) {
    console.error("Missing Supabase credentials in .env.local");
    console.error("URL:", supabaseUrl ? "Found" : "Missing");
    console.error("KEY:", supabaseKey ? "Found" : "Missing");
    process.exit(1);
}

const supabase = createClient(supabaseUrl, supabaseKey);

async function clearData() {
    console.log("Starting data cleanup...");

    // 1. Order Comments
    const { error: errComments } = await supabase.from('order_comments').delete().neq('id', '00000000-0000-0000-0000-000000000000');
    if (errComments) console.error("Error clearing order_comments:", errComments);
    else console.log("Cleared order_comments");

    // 2. Order Process Participants
    const { error: errParticipants } = await supabase.from('order_process_participants').delete().neq('id', '00000000-0000-0000-0000-000000000000');
    if (errParticipants) console.error("Error clearing order_process_participants:", errParticipants);
    else console.log("Cleared order_process_participants");

    // 3. User Logs
    const { error: errLogs } = await supabase.from('user_logs').delete().neq('id', '00000000-0000-0000-0000-000000000000');
    if (errLogs) console.error("Error clearing user_logs:", errLogs);
    else console.log("Cleared user_logs");

    // 4. Commission Logs (found earlier: commission_logs might not exist, but checking commissionService, looks like it calculates on the fly? 
    // Wait, if there IS a table, I should clear it. But I didn't see one in list_dir SQLs.
    // I will check if 'sales_targets' or similar needs cleaning.
    // Generally logs and orders are the main test artifacts.

    // 4. Orders
    const { error: errOrders } = await supabase.from('orders').delete().neq('id', '00000000-0000-0000-0000-000000000000');
    if (errOrders) console.error("Error clearing orders:", errOrders);
    else console.log("Cleared orders");

    console.log("Cleanup finished.");
}

clearData();
