
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

async function syncProfiles() {
    console.log("Fetching Auth Users...");

    // 1. Get List of Users from Auth (Admin API)
    const { data: { users }, error: userError } = await supabase.auth.admin.listUsers();

    if (userError || !users) {
        console.error("Error fetching users:", userError);
        return;
    }

    console.log(`Found ${users.length} users in Auth.`);

    for (const user of users) {
        console.log(`Processing ${user.email} (${user.id})...`);

        // 2. Check if profile exists
        const { data: existing } = await supabase
            .from('profiles')
            .select('id, role')
            .eq('id', user.id)
            .single();

        if (!existing) {
            console.log(`- Profile missing. Creating...`);
            // Default role based on email or just 'Admin' for the test user
            let role = 'NhanVienKinhDoanh'; // Default
            if (user.email?.includes('test') || user.email?.includes('admin')) {
                role = 'Admin';
            }

            const { error: insertError } = await supabase
                .from('profiles')
                .insert({
                    id: user.id,
                    email: user.email,
                    full_name: user.user_metadata?.full_name || user.email?.split('@')[0],
                    role: role
                });

            if (insertError) console.error("Insert failed:", insertError);
            else console.log(`- Created profile as ${role}`);
        } else {
            console.log(`- Profile exists. Role: ${existing.role}`);
            if (user.email?.includes('test') && existing.role !== 'Admin') {
                console.log("  -> Updating test user to Admin...");
                await supabase
                    .from('profiles')
                    .update({ role: 'Admin' })
                    .eq('id', user.id);
            }
        }
    }
}

syncProfiles();
