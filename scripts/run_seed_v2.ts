
import { createClient } from '@supabase/supabase-js';

const supabaseUrl = 'https://vqedjnefqrjhcthvzmtg.supabase.co';
const serviceRoleKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZxZWRqbmVmcXJqaGN0aHZ6bXRnIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2NTAwMTM1NiwiZXhwIjoyMDgwNTc3MzU2fQ.YhkXrPbyvsj4ao46UXsUFLxF32mZ10ReUwr_YGPxu0g';

const supabase = createClient(supabaseUrl, serviceRoleKey);

async function runSeed() {
    console.log("Seeding Commission Policies (Manual Check - V3 New Formula)...");

    const policies = [
        // MAINTASK_RATE: Stage Contribution % (User agreed to: In=20%, etc.)
        { type: 'MAINTASK_RATE', code: 'NhanFile', rate: 5.0 },
        { type: 'MAINTASK_RATE', code: 'XuLyFile', rate: 10.0 },
        { type: 'MAINTASK_RATE', code: 'BinhFile', rate: 5.0 },
        { type: 'MAINTASK_RATE', code: 'In', rate: 20.0 },
        { type: 'MAINTASK_RATE', code: 'ThanhPham', rate: 20.0 },
        { type: 'MAINTASK_RATE', code: 'DongGoi', rate: 5.0 },
        { type: 'MAINTASK_RATE', code: 'GiaoHang', rate: 5.0 },
        { type: 'MAINTASK_RATE', code: 'DaGiaoHang', rate: 5.0 },
        { type: 'MAINTASK_RATE', code: 'EpKim', rate: 15.0 },

        // SUBTASK_RATE: Rate on Fee => Keep as is for now, or match user expectation?
        // User didn't specify subtask changes, but let's keep reasonable defaults
        { type: 'SUBTASK_RATE', code: 'ThietKe', rate: 10.0 },
        { type: 'SUBTASK_RATE', code: 'InKhoLon', rate: 5.0 },
        { type: 'SUBTASK_RATE', code: 'EpKim', rate: 10.0 },
        { type: 'SUBTASK_RATE', code: 'BeDemi', rate: 5.0 },
        { type: 'SUBTASK_RATE', code: 'CanMang', rate: 5.0 },
        { type: 'SUBTASK_RATE', code: 'GiaCongNgoai', rate: 0.0 }
    ];

    for (const p of policies) {
        // Check existing
        const { data: existing } = await supabase
            .from('commission_policies')
            .select('id')
            .eq('policy_type', p.type)
            .eq('apply_to', p.code)
            .maybeSingle();

        if (existing) {
            // Update
            const { error } = await supabase
                .from('commission_policies')
                .update({ rate: p.rate })
                .eq('id', existing.id);
            if (error) console.error(`Error updating ${p.code}:`, error.message);
            else console.log(`Updated ${p.code} to ${p.rate}%`);
        } else {
            // Insert
            const { error } = await supabase
                .from('commission_policies')
                .insert({ policy_type: p.type, apply_to: p.code, rate: p.rate });
            if (error) console.error(`Error inserting ${p.code}:`, error.message);
            else console.log(`Inserted ${p.code} at ${p.rate}%`);
        }
    }

    console.log("Seeding complete.");
}

runSeed();
