import { createClient } from '@supabase/supabase-js';

const supabaseUrl = 'https://jcvklwdxdnmhsgpicysr.supabase.co';
const serviceRoleKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Impjdmtsd2R4ZG5taHNncGljeXNyIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTczMDMyOTMxOSwiZXhwIjoyMDQ1OTA1MzE5fQ.8S4_jnz7B5-Y3L8TP0mYYUxOT6A1Y28oVBEU_Zq7fd4';
const supabase = createClient(supabaseUrl, serviceRoleKey);

async function debugCommission() {
    // 1. Get Bùi Văn Nghĩa's profile
    const { data: profiles, error: profileError } = await supabase
        .from('profiles')
        .select('id, full_name, commission_stages, commission_subtasks')
        .ilike('full_name', '%Nghĩa%');

    if (profileError) {
        console.error('Error fetching profile:', profileError);
        return;
    }

    const profile = profiles?.[0];
    if (!profile) {
        console.error('Profile not found');
        return;
    }

    console.log('=== Profile of Bùi Văn Nghĩa ===');
    console.log('ID:', profile.id);
    console.log('commission_stages:', JSON.stringify(profile.commission_stages, null, 2));
    console.log('commission_subtasks:', JSON.stringify(profile.commission_subtasks, null, 2));

    // 2. Check order 26PD0701.0095
    const { data: order, error: orderError } = await supabase
        .from('orders')
        .select('id, order_code, total_amount_pre_vat, status')
        .eq('order_code', '26PD0701.0095')
        .single();

    if (orderError) {
        console.error('Error fetching order:', orderError);
        return;
    }

    console.log('\n=== Order 26PD0701.0095 ===');
    console.log('Order ID:', order.id);
    console.log('Total Amount Pre VAT:', order.total_amount_pre_vat);
    console.log('Status:', order.status);

    // 3. Check participation record
    const { data: participants, error: partError } = await supabase
        .from('order_process_participants')
        .select('*')
        .eq('order_id', order.id)
        .eq('stage', 'In');

    console.log('\n=== Participants for "In" stage ===');
    console.log(JSON.stringify(participants, null, 2));

    // 4. Check global commission policies for 'In'
    const { data: policies, error: polError } = await supabase
        .from('commission_policies')
        .select('*')
        .eq('apply_to', 'In');

    console.log('\n=== Commission Policies for "In" ===');
    console.log(JSON.stringify(policies, null, 2));

    // 5. Direct calculation test
    console.log('\n=== Manual Calculation ===');
    const stageKey = 'In';
    const personalRate = profile.commission_stages?.[stageKey];
    console.log('Personal rate for "In":', personalRate);

    if (participants && participants.length > 0) {
        const participantCount = participants.length;
        const orderValue = order.total_amount_pre_vat;

        // Get global rate if personal is null
        const globalRate = policies?.find(p => p.policy_type === 'MAINTASK_RATE')?.rate || 0;
        console.log('Global rate for "In":', globalRate);

        const effectiveRate = personalRate !== undefined ? personalRate : globalRate;
        console.log('Effective rate:', effectiveRate);

        // Calculate commission
        const commission = (orderValue / participantCount) * (effectiveRate / 100) * 1.0;
        console.log('Calculated commission:', commission);
    }
}

debugCommission().catch(console.error);
