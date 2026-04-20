import { supabase } from './supabaseClient';
import { Customer, CustomerAnalytics, CustomerLog, InvoiceProfile } from '../types';

export const customerService = {
    // Get all customers with optional search
    getAllCustomers: async (search?: string): Promise<Customer[]> => {
        let query = supabase
            .from('customers')
            .select('*, sales_rep:sales_rep_id(full_name)')
            .order('created_at', { ascending: false });

        if (search) {
            query = query.or(`name.ilike.%${search}%,phone.ilike.%${search}%,code.ilike.%${search}%`);
        }

        const { data, error } = await query;
        if (error) throw error;

        // Default mapping Supabase DB -> App Type
        // DB columns: code, name, phone, email, address, source, crm_notes
        // App Type: code, name, phone, email, address, source, crm_notes
        return data as Customer[];
    },

    // Get single customer details
    getCustomerById: async (id: string): Promise<Customer | null> => {
        const { data, error } = await supabase
            .from('customers')
            .select('*')
            .eq('id', id)
            .single();

        if (error) throw error;
        return data as Customer;
    },

    // Create new customer
    createCustomer: async (customer: Partial<Customer>): Promise<Customer> => {
        // 1. Generate Code via DB Function
        const { data: codeData, error: codeError } = await supabase
            .rpc('generate_customer_code');

        if (codeError) throw new Error("Failed to generate customer code: " + codeError.message);

        const newCode = codeData as string;

        // 2. Get Current User for Ownership
        const { data: { session } } = await supabase.auth.getSession();
        const userId = session?.user?.id;

        // 3. Insert
        const { data, error } = await supabase
            .from('customers')
            .insert([{
                code: newCode,
                name: customer.name,
                phone: customer.phone,
                email: customer.email,
                address: customer.address,
                source: customer.source || 'Khác',
                crm_notes: customer.crm_notes,
                is_urgent_entry: customer.is_urgent_entry,
                refused_provide_phone: customer.refused_provide_phone,
                pipeline_stage: customer.pipeline_stage || 'NEW',
                sales_rep_id: userId // Auto-assign creator
            }])
            .select()
            .single();

        if (error) throw error;
        return data as Customer;
    },

    // Update customer
    updateCustomer: async (id: string, customer: Partial<Customer>): Promise<void> => {
        // 'id' passed here is usually the 'code' from legacy UI.
        // Try to update by code.
        const { error } = await supabase
            .from('customers')
            .update({
                name: customer.name,
                phone: customer.phone,
                email: customer.email,
                address: customer.address,
                source: customer.source,
                crm_notes: customer.crm_notes,
                is_urgent_entry: customer.is_urgent_entry,
                refused_provide_phone: customer.refused_provide_phone
            })
            .eq('code', id);

        if (error) throw error;
    },

    // Get Analytics
    getCustomerAnalytics: async (customerId: string): Promise<CustomerAnalytics> => {
        // Resolve UUID from Code if needed
        let uuid = customerId;
        if (customerId.startsWith('KH')) {
            const { data } = await supabase.from('customers').select('id').eq('code', customerId).single();
            if (data) uuid = data.id;
        }

        const { data, error } = await supabase.rpc('get_customer_analytics', { customer_id_input: uuid });

        if (error) {
            console.error("Analytics error", error);
            return { totalRevenue: 0, orderCount: 0, lastOrderDate: 'N/A', avgDaysBetweenOrders: 0 };
        }

        return {
            totalRevenue: data.totalRevenue || 0,
            orderCount: data.orderCount || 0,
            lastOrderDate: data.lastOrderDate ? new Date(data.lastOrderDate).toLocaleDateString('vi-VN') : 'Chưa có',
            avgDaysBetweenOrders: data.avgDaysBetweenOrders || 0
        };
    },

    async getCustomerLogs(customerId: string) {
        // Resolve UUID from Code if needed
        let uuid = customerId;
        if (customerId.startsWith('KH')) {
            const { data } = await supabase.from('customers').select('id').eq('code', customerId).single();
            if (data) uuid = data.id;
        }

        const { data, error } = await supabase
            .from('customer_logs')
            .select('*, created_by_user:created_by(full_name)')
            .eq('customer_id', uuid)
            .order('created_at', { ascending: false });

        if (error) throw error;
        return data as any[];
    },

    async addCustomerLog(log: { customer_id: string; type: string; content: string }) {
        // Resolve UUID from Code if needed
        let uuid = log.customer_id;
        if (log.customer_id.startsWith('KH')) {
            const { data } = await supabase.from('customers').select('id').eq('code', log.customer_id).single();
            if (data) uuid = data.id;
        }

        const { data, error } = await supabase
            .from('customer_logs')
            .insert([{ ...log, customer_id: uuid }])
            .select()
            .single();

        if (error) throw error;
        return data;
    },

    async updateCustomerTags(customerId: string, tags: string[]) {
        const { error } = await supabase
            .from('customers')
            .update({ tags })
            .eq(customerId.startsWith('KH') ? 'code' : 'id', customerId);

        if (error) throw error;
    },

    // AI Compliance Check
    async getComplianceIssues() {
        const { data, error } = await supabase
            .from('customers')
            .select('id, code, name')
            .eq('is_urgent_entry', true)
            .eq('refused_provide_phone', false)
            .or('phone.is.null,phone.eq.""'); // Missing phone

        if (error) {
            console.error("Compliance check error", error);
            return [];
        }
        return data as Customer[];
    },

    // Phase 3: Update Pipeline Stage
    async updatePipelineStage(customerId: string, stage: string) {
        const { error } = await supabase
            .from('customers')
            .update({ pipeline_stage: stage })
            .eq(customerId.startsWith('KH') ? 'code' : 'id', customerId);

        if (error) throw error;
    },

    // Invoice Profiles Management
    async getInvoiceProfiles(customerId: string): Promise<InvoiceProfile[]> {
        // Resolve UUID from Code if needed
        let uuid = customerId;
        if (customerId.startsWith('KH')) {
            const { data } = await supabase.from('customers').select('id').eq('code', customerId).single();
            if (data) uuid = data.id;
        }

        const { data, error } = await supabase
            .from('customer_invoice_profiles')
            .select('*')
            .eq('customer_id', uuid)
            .order('created_at', { ascending: false });

        if (error) throw error;
        return data as InvoiceProfile[];
    },

    async createInvoiceProfile(profile: Partial<InvoiceProfile>): Promise<InvoiceProfile> {
        const { data, error } = await supabase
            .from('customer_invoice_profiles')
            .insert([profile])
            .select()
            .single();

        if (error) throw error;
        return data as InvoiceProfile;
    },

    async deleteInvoiceProfile(id: string): Promise<void> {
        const { error } = await supabase
            .from('customer_invoice_profiles')
            .delete()
            .eq('id', id);

        if (error) throw error;
    },

    // ===== CUSTOMER REPORT FUNCTIONS =====

    async getCustomerReportData(): Promise<{
        id: string;
        code: string;
        name: string;
        phone?: string;
        email?: string;
        tags?: string[];
        crm_notes?: string;
        tier?: string;
        total_orders: number;
        total_revenue: number;
        cancelled_orders: number;
        last_order_date: string | null;
        days_since_last_order: number | null;
    }[]> {
        // 1. Fetch all customers
        const { data: customers, error: custErr } = await supabase
            .from('customers')
            .select('id, code, name, phone, email, tags, crm_notes, tier')
            .order('name');
        if (custErr) throw custErr;

        // 2. Fetch all orders (lightweight: only needed fields, exclude cancelled count separately)
        const { data: orders, error: ordErr } = await supabase
            .from('orders')
            .select('customer_id, total_amount, status, created_at');
        if (ordErr) throw ordErr;

        // 3. Aggregate client-side
        const orderMap = new Map<string, { total: number; revenue: number; cancelled: number; lastDate: string | null }>();
        for (const o of (orders || [])) {
            if (!o.customer_id) continue;
            const entry = orderMap.get(o.customer_id) || { total: 0, revenue: 0, cancelled: 0, lastDate: null };
            if (o.status === 'Huy') {
                entry.cancelled++;
            } else {
                entry.total++;
                entry.revenue += (o.total_amount || 0);
            }
            if (!entry.lastDate || new Date(o.created_at) > new Date(entry.lastDate)) {
                entry.lastDate = o.created_at;
            }
            orderMap.set(o.customer_id, entry);
        }

        const now = new Date();
        return (customers || []).map(c => {
            const stats = orderMap.get(c.id) || { total: 0, revenue: 0, cancelled: 0, lastDate: null };
            const daysSince = stats.lastDate
                ? Math.floor((now.getTime() - new Date(stats.lastDate).getTime()) / (1000 * 60 * 60 * 24))
                : null;
            return {
                ...c,
                total_orders: stats.total,
                total_revenue: stats.revenue,
                cancelled_orders: stats.cancelled,
                last_order_date: stats.lastDate,
                days_since_last_order: daysSince,
            };
        });
    },

    async getDuplicateCustomers(): Promise<{
        type: 'phone' | 'name';
        value: string;
        customers: { id: string; code: string; name: string; phone?: string; email?: string }[];
    }[]> {
        const { data, error } = await supabase
            .from('customers')
            .select('id, code, name, phone, email');
        if (error) throw error;

        const results: { type: 'phone' | 'name'; value: string; customers: typeof data }[] = [];

        // Group by phone
        const phoneMap = new Map<string, typeof data>();
        for (const c of (data || [])) {
            const phone = (c.phone || '').trim();
            if (!phone) continue;
            const list = phoneMap.get(phone) || [];
            list.push(c);
            phoneMap.set(phone, list);
        }
        for (const [phone, custs] of phoneMap) {
            if (custs.length > 1) {
                results.push({ type: 'phone', value: phone, customers: custs });
            }
        }

        // Group by name (normalized: lowercase + trim)
        const nameMap = new Map<string, typeof data>();
        for (const c of (data || [])) {
            const name = (c.name || '').trim().toLowerCase();
            if (!name) continue;
            const list = nameMap.get(name) || [];
            list.push(c);
            nameMap.set(name, list);
        }
        for (const [name, custs] of nameMap) {
            if (custs.length > 1) {
                results.push({ type: 'name', value: name, customers: custs });
            }
        }

        return results;
    },

    // Merge duplicate customer: transfer all orders to primary, then delete secondary
    async mergeCustomers(primaryId: string, secondaryId: string): Promise<{ transferredOrders: number }> {
        console.log('[MergeCustomers] Starting merge:', { primaryId, secondaryId });

        // 1. Transfer orders from secondary to primary
        let transferredOrders = 0;
        try {
            const { data: orders, error: fetchErr } = await supabase
                .from('orders')
                .select('id')
                .eq('customer_id', secondaryId);
            if (fetchErr) {
                console.error('[MergeCustomers] Error fetching orders:', fetchErr);
                throw new Error('Lỗi khi tìm đơn hàng: ' + fetchErr.message);
            }

            transferredOrders = (orders || []).length;
            console.log('[MergeCustomers] Found orders to transfer:', transferredOrders);

            if (transferredOrders > 0) {
                const { error: updateErr } = await supabase
                    .from('orders')
                    .update({ customer_id: primaryId })
                    .eq('customer_id', secondaryId);
                if (updateErr) {
                    console.error('[MergeCustomers] Error transferring orders:', updateErr);
                    throw new Error('Lỗi khi chuyển đơn hàng: ' + updateErr.message);
                }
                console.log('[MergeCustomers] Orders transferred successfully');
            }
        } catch (err: any) {
            console.error('[MergeCustomers] Order transfer failed:', err);
            throw err;
        }

        // 2. Transfer customer_logs (optional - has ON DELETE CASCADE as fallback)
        try {
            const { error: logErr } = await supabase
                .from('customer_logs')
                .update({ customer_id: primaryId })
                .eq('customer_id', secondaryId);
            if (logErr) console.warn('[MergeCustomers] Log transfer warning (non-blocking):', logErr.message);
            else console.log('[MergeCustomers] Customer logs transferred');
        } catch (e) {
            console.warn('[MergeCustomers] customer_logs transfer skipped:', e);
        }

        // 3. Transfer invoice profiles (optional - has ON DELETE CASCADE as fallback)
        try {
            const { error: invErr } = await supabase
                .from('customer_invoice_profiles')
                .update({ customer_id: primaryId })
                .eq('customer_id', secondaryId);
            if (invErr) console.warn('[MergeCustomers] Invoice profile transfer warning (non-blocking):', invErr.message);
            else console.log('[MergeCustomers] Invoice profiles transferred');
        } catch (e) {
            console.warn('[MergeCustomers] customer_invoice_profiles transfer skipped:', e);
        }

        // 4. Delete secondary customer (this will cascade-delete logs & invoice profiles if transfer failed above)
        try {
            const { error: delErr } = await supabase
                .from('customers')
                .delete()
                .eq('id', secondaryId);
            if (delErr) {
                console.error('[MergeCustomers] Delete error:', delErr);
                throw new Error('Không thể xóa KH trùng: ' + delErr.message);
            }
            console.log('[MergeCustomers] Secondary customer deleted successfully');
        } catch (err: any) {
            console.error('[MergeCustomers] Delete failed:', err);
            throw err;
        }

        console.log('[MergeCustomers] Merge completed successfully! Transferred:', transferredOrders, 'orders');
        return { transferredOrders };
    }
};
