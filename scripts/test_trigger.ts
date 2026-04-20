
import { createClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';
import path from 'path';

// Load env vars
dotenv.config({ path: path.resolve(process.cwd(), '.env.local') });

const supabaseUrl = process.env.VITE_SUPABASE_URL;
const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

if (!supabaseUrl || !supabaseServiceKey) {
    console.error('Missing Supabase URL or Service Role Key');
    process.exit(1);
}

const supabase = createClient(supabaseUrl, supabaseServiceKey);

async function testTrigger() {
    console.log('--- STARTING TRIGGER TEST ---');

    // 1. Create a dummy customer
    const { data: customer, error: custError } = await supabase
        .from('customers')
        .insert({
            code: 'TEST_CUST_TRIG',
            name: 'Test Customer Trigger',
            phone: '0123456789'
        })
        .select()
        .single();

    if (custError) {
        console.error('Error creating customer:', custError);
        return;
    }
    console.log('1. Created Customer:', customer.id);

    // 2. Create a dummy order
    const { data: order, error: orderError } = await supabase
        .from('orders')
        .insert({
            order_code: 'TEST_ORDER_TRIG',
            customer_id: customer.id,
            status: 'Moi'
        })
        .select()
        .single();

    if (orderError) {
        console.error('Error creating order:', orderError);
        // Cleanup customer if order fails
        await supabase.from('customers').delete().eq('id', customer.id);
        return;
    }
    console.log('2. Created Order with status:', order.status);

    // 3. Create a dummy user to get a profile ID
    console.log('3. Creating dummy user for participant...');

    const email = `test_staff_${Date.now()}@example.com`;
    const { data: userAuth, error: userError } = await supabase.auth.admin.createUser({
        email: email,
        password: 'password123',
        email_confirm: true
    });

    if (userError) {
        console.error("Error creating auth user:", userError);
        // Cleanup
        await supabase.from('orders').delete().eq('id', order.id);
        await supabase.from('customers').delete().eq('id', customer.id);
        return;
    }

    const userId = userAuth.user.id;
    console.log('   Created User ID:', userId);

    // Manually ensure profile exists (in case trigger is missing or delayed)
    const { error: profileError } = await supabase.from('profiles').insert({
        id: userId,
        email: email,
        full_name: 'Test Staff Trigger',
        role: 'NhanVienSanXuat'
    });

    if (profileError) {
        console.log('   Profile insert note (might be duplicate):', profileError.message);
    }

    // 4. Insert participant for "In" stage
    console.log('4. Inserting participant for stage "In"...');

    const { error: partError } = await supabase
        .from('order_process_participants')
        .insert({
            order_id: order.id,
            user_id: userId,
            stage: 'In',
            started_at: new Date().toISOString()
        });

    if (partError) {
        console.error('Error inserting participant:', partError);
    } else {
        console.log('   Participant inserted.');

        // 5. Fetch order again to check status
        const { data: updatedOrder, error: fetchError } = await supabase
            .from('orders')
            .select('status')
            .eq('id', order.id)
            .single();

        if (fetchError) {
            console.error('Error fetching updated order:', fetchError);
        } else {
            console.log('5. Updated Order Status:', updatedOrder.status);

            if (updatedOrder.status === 'In') {
                console.log('SUCCESS: Status automatically updated to "In"!');
            } else {
                console.error('FAILURE: Status did not update. Expected "In", got:', updatedOrder.status);
            }
        }
    }

    // Cleanup
    console.log('--- CLEANING UP ---');
    await supabase.from('orders').delete().eq('id', order.id);
    await supabase.from('customers').delete().eq('id', customer.id);
    await supabase.auth.admin.deleteUser(userId);
    console.log('Cleanup done.');
}

testTrigger();
