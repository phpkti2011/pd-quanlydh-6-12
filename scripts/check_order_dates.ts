
import { createClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';
import path from 'path';

dotenv.config({ path: path.join(process.cwd(), '.env.local') });

const supabaseUrl = process.env.VITE_SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY; // Use Service Role to bypass RLS for debugging

if (!supabaseUrl || !supabaseKey) {
    console.error("Missing VITE_SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY");
    process.exit(1);
}

const supabase = createClient(supabaseUrl, supabaseKey);

async function checkDates() {
    const { data, error } = await supabase
        .from('orders')
        .select('created_at, delivery_date')
        .limit(10);

    if (error) {
        console.error("Error:", error);
        return;
    }

    if (!data || data.length === 0) {
        console.log("No orders found in database.");
        return;
    }

    console.log("Sample Order Dates:");
    data.forEach(o => console.log(`Created: ${o.created_at}, Delivery: ${o.delivery_date}`));

    // Get range
    const { data: minMax } = await supabase
        .from('orders')
        .select('created_at')
        .order('created_at', { ascending: true })
        .limit(1);

    const { data: maxDate } = await supabase
        .from('orders')
        .select('created_at')
        .order('created_at', { ascending: false })
        .limit(1);

    if (minMax && maxDate) {
        console.log(`\nTime Range: ${minMax[0].created_at} to ${maxDate[0].created_at}`);
    }
}

checkDates();
