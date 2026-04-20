
import { createClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';
import path from 'path';

dotenv.config({ path: path.join(process.cwd(), '.env.local') });

const supabaseUrl = process.env.VITE_SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

if (!supabaseUrl || !supabaseKey) {
    console.error("Missing env vars");
    process.exit(1);
}

const supabase = createClient(supabaseUrl, supabaseKey);

async function checkProfiles() {
    console.log("Checking profiles table...");
    const { data: profiles, error } = await supabase
        .from('profiles')
        .select('*');

    if (error) {
        console.error("Error fetching profiles:", error);
        return;
    }

    console.log(`Found ${profiles?.length} profiles.`);
    profiles?.forEach(p => {
        console.log(`- Email: ${p.email}, Role: ${p.role}, Name: ${p.full_name}, ID: ${p.id}`);
    });

    // Check specifically for test@pnd.com if not in list (though Select * should catch it if sync trigger works)
}

checkProfiles();
