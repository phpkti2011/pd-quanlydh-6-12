
import { createClient } from '@supabase/supabase-js';

const supabaseUrl = 'https://vqedjnefqrjhcthvzmtg.supabase.co';
// Using Service Role Key to bypass RLS for logic verification
const serviceRoleKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZxZWRqbmVmcXJqaGN0aHZ6bXRnIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2NTAwMTM1NiwiZXhwIjoyMDgwNTc3MzU2fQ.YhkXrPbyvsj4ao46UXsUFLxF32mZ10ReUwr_YGPxu0g';

const supabase = createClient(supabaseUrl, serviceRoleKey);

async function searchDebug(term: string) {
    console.log(`Searching for term: "${term}"`);

    // 1. Search Customers
    const { data: matchedCustomers, error: custError } = await supabase
        .from('customers')
        .select('id, name, code')
        .or(`name.ilike.%${term}%,code.ilike.%${term}%`)
        .limit(50);

    if (custError) {
        console.error("Customer Search Error:", custError);
        return;
    }

    console.log(`Found ${matchedCustomers?.length} customers matches.`);
    if (matchedCustomers && matchedCustomers.length > 0) {
        matchedCustomers.forEach((c: any) => console.log(` - ${c.name} (${c.code}) [${c.id}]`));
    } else {
        console.log("No customers found.");
    }

    // 2. Construct Order Query
    let query = supabase
        .from('orders')
        .select('id, order_code, description, customer_id, customer:customer_id(name)');

    let orString = `order_code.ilike.%${term}%,description.ilike.%${term}%`;

    if (matchedCustomers && matchedCustomers.length > 0) {
        const customerIds = matchedCustomers.map((c: any) => c.id).join(',');
        // This is the logic from orderService.ts
        orString += `,customer_id.in.(${customerIds})`;
    }

    console.log("OR String:", orString);

    query = query.or(orString);
    query = query.limit(10);
    query = query.order('created_at', { ascending: false });

    const { data: orders, error: orderError } = await query;

    if (orderError) {
        console.error("Order Search Error:", orderError);
        return;
    }

    console.log(`Found ${orders?.length} orders.`);
    if (orders) {
        orders.forEach((o: any) => console.log(` - Order: ${o.order_code}, Cust: ${(o.customer as any)?.name}`));
    }
}

searchDebug('steel');
