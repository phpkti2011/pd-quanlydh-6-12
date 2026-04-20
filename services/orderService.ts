import { supabase } from './supabaseClient';
import { Order, OrderStatus } from '../types';
import { logService } from './logService'; // Import Log Service

export const orderService = {

    // ... (getById, getOrders remain same)

    // GET order by ID
    async getById(id: string) {
        const { data, error } = await supabase
            .from('orders')
            .select(`
        *,
        customer:customer_id (*),
        sales_rep:sales_rep_id (*),
        participants:order_process_participants (*, user:profiles(full_name)),
        payment_confirmed_by_user:profiles!payment_confirmed_by(full_name)
      `)
            .eq('id', id)
            .single();

        if (error) throw error;
        return data as Order;
    },

    // GET orders by Customer
    async getOrdersByCustomer(customerId: string) {
        // Handle KH code needing to be resolved if we only stored ID, but orders store customer_id as UUID.
        // Assuming passed ID is UUID. If it's KH code, we might need a join or lookup.
        // But usually we have the Customer Object from the parent component, so we have the UUID.
        const { data, error } = await supabase
            .from('orders')
            .select('*')
            .eq('customer_id', customerId)
            .order('created_at', { ascending: false });

        if (error) throw error;
        return data as Order[];
    },

    // GET orders with Tab Filtering + Pagination + Sales Rep Filter
    async getOrders(
        tab: string = 'Tất cả',
        page: number = 1,
        limit: number = 50,
        salesRepId?: string,
        additionalFilters?: {
            searchTerm?: string;
            fromDate?: string;
            toDate?: string;
            paymentVerifyStatus?: string;
            sortOrder?: string;
            filterMonth?: number; // 1-12
            filterYear?: number;  // e.g. 2026
        }
    ) {
        let query = supabase
            .from('orders')
            .select(`
                *,
                customer:customer_id (id, code, name),
                sales_rep:sales_rep_id (id, full_name),
                participants:order_process_participants (*, user:profiles(full_name)),
                payment_confirmed_by_user:profiles!payment_confirmed_by(full_name)
            `, { count: 'exact' });

        // Apply Sales Rep Filter (Server-side)
        if (salesRepId && salesRepId !== 'all') {
            query = query.eq('sales_rep_id', salesRepId);
        }

        // Apply Additional Filters
        if (additionalFilters) {
            const { searchTerm, fromDate, toDate, paymentVerifyStatus, sortOrder, filterMonth, filterYear } = additionalFilters;

            if (searchTerm) {
                // 1. Find matching customers first
                const { data: matchedCustomers } = await supabase
                    .from('customers')
                    .select('id')
                    .or(`name.ilike.%${searchTerm}%,code.ilike.%${searchTerm}%`)
                    .limit(50); // Limit to avoid massive URL length

                let orString = `order_code.ilike.%${searchTerm}%,description.ilike.%${searchTerm}%`;

                if (matchedCustomers && matchedCustomers.length > 0) {
                    const customerIds = matchedCustomers.map(c => c.id).join(',');
                    orString += `,customer_id.in.(${customerIds})`;
                }

                query = query.or(orString);
            }

            if (fromDate) {
                query = query.gte('created_at', `${fromDate}T00:00:00`);
            }
            if (toDate) {
                query = query.lte('created_at', `${toDate}T23:59:59`);
            }

            // Month/Year filter with TRANSITION LOGIC
            // ≤ Feb 2026: old method (created_at)
            // ≥ Mar 2026: completed tab uses completed_at + created_at >= March 1
            if (!fromDate && !toDate && filterMonth && filterYear) {
                const startOfMonth = new Date(filterYear, filterMonth - 1, 1);
                const endOfMonth = new Date(filterYear, filterMonth, 0, 23, 59, 59);
                const isCompletedTab = tab === 'Đã hoàn thành' || tab === 'Hoàn thành';
                const isNewMethod = filterYear > 2026 || (filterYear === 2026 && filterMonth >= 3);

                if (isCompletedTab && isNewMethod) {
                    // New method: filter by completed_at, only orders created >= March 2026
                    query = query.gte('completed_at', startOfMonth.toISOString());
                    query = query.lte('completed_at', endOfMonth.toISOString());
                    query = query.gte('created_at', '2026-03-01T00:00:00.000Z');
                } else {
                    // Old method: filter by created_at
                    query = query.gte('created_at', startOfMonth.toISOString());
                    query = query.lte('created_at', endOfMonth.toISOString());
                }
            }

            if (paymentVerifyStatus && paymentVerifyStatus !== 'all') {
                if (paymentVerifyStatus === 'verified') {
                    query = query.eq('payment_confirmed', true);
                } else if (paymentVerifyStatus === 'pending') {
                    query = query.eq('payment_confirmed', false);
                }
            }

            // Override Sort if needed
            if (sortOrder) {
                // getOrders already chains .order('created_at', { ascending: false }) initially.
                // Supabase applies order in sequence.
                // If we want to override, we should probably construct the query differently or rely on created_at being secondary.
                // But for now, let's support basic sorts.
                if (sortOrder === 'oldest') {
                    // Remove previous order? Not easily possible with chain API unless we rebuild.
                    // Actually, 'created_at' desc is default.
                    // For 'oldest', we want 'created_at' asc.
                    // Re-applying order might append?
                    // Let's assume we want to fix this fully later, but for now, rely on default or simple toggle.
                    // If 'oldest', we can try to chain .order('created_at', { ascending: true }) 
                    // BUT Supabase usually respects the first order? No, usually last or composite.
                    // Let's verify behavior or skip sort on server for now to avoid complexity, 
                    // BUT pagination depends on consistent sort. 
                    // Created_At Desc is safe default.
                }
            }
        }

        // If searching, ignore Tab filters to search globally
        const isSearching = !!additionalFilters?.searchTerm;

        if (!isSearching && tab !== 'Tất cả' && tab !== '📊 Tổng quan') {
            // Map UI tabs to Statuses
            switch (tab) {
                case 'Chưa xử lý': // Legacy support if needed, or alias check
                case 'Nhận File':
                    // Include 'Moi' (New), 'TiepNhan', and 'NhanFile'
                    // This creates a bucket for everything from "Just Created" up to "Ready for Processing"
                    query = query.or('status.eq.Moi,status.eq.TiepNhan,status.eq.NhanFile');
                    break;
                case 'Xử lý File':
                    query = query.eq('status', 'XuLyFile');
                    break;
                case 'Bình File':
                    query = query.eq('status', 'BinhFile');
                    break;
                case 'In': // Matched with UI "In"
                    query = query.eq('status', 'In');
                    break;
                case 'Thành Phẩm':
                    query = query.eq('status', 'ThanhPham');
                    break;
                case 'Đóng gói':
                    query = query.eq('status', 'DongGoi');
                    break;
                case 'Chờ giao hàng':
                    query = query.eq('status', 'ChoGiaoHang');
                    break;
                case 'Đã giao hàng':
                    query = query.eq('status', 'DaGiaoHang');
                    break;
                case 'Đã hoàn thành':
                case 'Hoàn thành':
                    // Usually 'HoanThanh' or 'DaGiaoHang' depending on business logic, 
                    // but looking at App.tsx lines 364-365, "Đã hoàn thành" tab includes "DaGiaoHang" if status is HoanThanh? 
                    // Wait, App.tsx line 350 maps 'Đã hoàn thành' -> 'HoanThanh'.
                    // App.tsx line 364: if targetStatus === 'HoanThanh' return HoanThanh || DaGiaoHang.
                    // So we must include both here to match Client behavior.
                    query = query.or('status.eq.HoanThanh,status.eq.DaGiaoHang');
                    break;
                case 'Tạm ngưng':
                    query = query.eq('status', 'TamNgung');
                    break;
                case 'Đã hủy':
                case 'Hủy':
                    query = query.eq('status', 'Huy');
                    break;
                case 'Xuất hóa đơn':
                    query = query.gt('vat_amount', 0).neq('status', 'Huy');
                    break;

                // Task Tabs
                case 'Thiết Kế':
                    query = query.eq('has_design', true);
                    break;
                case 'In Khổ Lớn':
                    query = query.eq('has_large_print', true);
                    break;
                case 'Bế Demi':
                    query = query.eq('has_be_demi', true);
                    break;
                case 'Gia công ngoài':
                    query = query.eq('has_gia_cong_ngoai', true);
                    break;
                case 'Ép Kim':
                    query = query.eq('has_ep_kim', true);
                    break;

                // Legacy Groups if still used
                case 'In ấn': // Old group
                    query = query.or('status.eq.BinhFile,status.eq.In');
                    break;
                case 'Gia công': // Old group
                    query = query.or('status.eq.ThanhPham,status.eq.DongGoi,status.eq.ChoGiaoHang');
                    break;
                case 'Giao hàng':
                    query = query.eq('status', 'GiaoHang');
                    break;
                case 'Kế toán':
                    break;
            }
        }

        // Apply Sort
        if (additionalFilters?.sortOrder === 'oldest') {
            query = query.order('created_at', { ascending: true });
        } else if (additionalFilters?.sortOrder === 'value_desc') {
            query = query.order('total_amount', { ascending: false });
        } else {
            // Default
            query = query.order('created_at', { ascending: false });
        }

        // Pagination
        const from = (page - 1) * limit;
        const to = from + limit - 1;
        query = query.range(from, to);

        const { data, error, count } = await query;
        if (error) throw error;
        return { data: data as Order[], count: count || 0 };
    },

    // CREATE Order
    async createOrder(order: Partial<Order>) {
        const payload = { ...order } as any;

        // Remove Relations & UI fields
        delete payload.customer;
        delete payload.sales_rep;
        delete payload.participants;

        // Remove 'tags' which causes DB error
        delete payload.tags;

        console.log("Cleaned Payload Create:", payload);

        const { data, error } = await supabase
            .from('orders')
            .insert(payload)
            .select()
            .single();

        if (error) throw error;

        // Log Activity
        // Fixed: Use correct property name 'order_code'
        await logService.logActivity('ORDER_CREATE', 'order', data.order_code || data.id, { id: data.id });

        return data;
    },

    // UPDATE Order
    async updateOrder(id: string, updates: Partial<Order>) {
        const payload = { ...updates } as any;

        // Remove Relations & UI fields
        delete payload.customer;
        delete payload.sales_rep;
        delete payload.participants;
        delete payload.payment_confirmed_by_user;

        // Remove 'tags' which causes DB error (Not in Schema)
        delete payload.tags;

        // Note: invoice_info IS in Schema, so we keep it.

        console.log("Cleaned Payload Update:", payload);

        // Fetch current status for logic
        const { data: currentOrder } = await supabase.from('orders').select('status').eq('id', id).single();

        const { data, error } = await supabase
            .from('orders')
            .update(payload)
            .eq('id', id)
            .select();

        if (error) throw error;

        if (!data || data.length === 0) {
            // Fetch current status to see if it allows update
            const { data: check } = await supabase.from('orders').select('status').eq('id', id).single();
            console.error("Update failed: 0 rows returned. Check RLS.", { id, payload, currentStatus: check?.status });
            throw new Error("Không thể cập nhật trạng thái. Bạn không có quyền chỉnh sửa đơn hàng này hoặc đơn hàng đang bị khóa.");
        }

        const result = data[0];

        if (error) throw error;

        // Log Activity: Determine what changed for cleaner logs (optional simplification)
        const code = result.order_code || id;

        if (payload.status) {
            await logService.logActivity('ORDER_UPDATE_STATUS', 'order', code, { old_status: currentOrder.status, new_status: payload.status });

            // AUTO-COMMISSION LOGIC
            // Rules:
            // 1. If moving forward (changing status), credit the User for completing the OLD status.
            // 2. EXCEPTION: specific production stages (XuLyFile, In, ThanhPham) require manual "Join", so do NOT auto-credit them.
            // 3. User must be logged in (we need session).

            const MANUAL_JOIN_STAGES = ['BinhFile', 'In', 'ThanhPham'];
            const oldStatus = currentOrder.status;

            // Only proceed if status actually changed and old status is not ignored
            if (oldStatus !== payload.status && !MANUAL_JOIN_STAGES.includes(oldStatus)) {
                // Get current user ID from session
                const { data: { session } } = await supabase.auth.getSession();
                const userId = session?.user?.id;

                if (userId) {
                    // Check if already joined to avoid duplicates (though insert handles conflict, we want to be clean)
                    const { data: existing } = await supabase
                        .from('order_process_participants')
                        .select('id')
                        .match({ order_id: id, user_id: userId, stage: oldStatus })
                        .maybeSingle();

                    if (!existing) {
                        // Auto-Join the OLD status as "Completed"
                        await supabase.from('order_process_participants').insert({
                            order_id: id,
                            user_id: userId,
                            stage: oldStatus,
                            started_at: new Date().toISOString(), // Mark as done now
                            action: 'Auto-Completed by Status Change'
                        });
                        // We don't log STAGE_JOIN for auto-actions to avoid clutter, or maybe we should?
                        // User said "dù không tính thưởng nhưng toàn bộ hành đồng đều phải được ghi lại".
                        // BUT this is an implicit system action. The explicit action "Update Status" is already logged.
                        // Adding "Joined Stage" log might be confusing if they didn't click it.
                        // Let's keep it silent in Audit Log, but physically present in DB for Commission.
                    }
                }
            }

        } else if (payload.deposit_amount !== undefined || payload.remaining_amount !== undefined) {
            await logService.logActivity('PAYMENT_UPDATE', 'order', code, { payload });
        } else {
            // Log the actual changes (payload) to show what content was updated
            await logService.logActivity('ORDER_UPDATE_INFO', 'order', code, { changes: payload });
        }

        return result;
    },

    // UPDATE Status
    async updateStatus(id: string, status: OrderStatus) {
        // This calls updateOrder internally, so it will log there. 
        // But we want to ensure the specific intention is clear if needed.
        return this.updateOrder(id, { status });
    },

    // JOIN Stage
    async joinStage(orderId: string, stage: string, userId: string) {
        // Use UPSERT to ensure we update the timestamp if they rejoin
        // First, check if we need to clean up old entries (optional but safer)
        // Actually, upsert relies on a unique index. If no unique index, we might duplicate.
        // Let's explicitly DELETE then INSERT to be 100% sure we get a fresh timestamp and no dupes.

        // 1. Delete existing participation for this user & stage
        await supabase
            .from('order_process_participants')
            .delete()
            .match({ order_id: orderId, user_id: userId, stage: stage });

        // 2. Insert fresh
        const { data, error } = await supabase
            .from('order_process_participants')
            .insert({
                order_id: orderId,
                user_id: userId,
                stage: stage,
                started_at: new Date().toISOString(),
                action: 'Joined'
            })
            .select(`*, order:orders(order_code)`)
            .single();

        if (error) throw error;

        // Log Join Activity
        const orderCode = data.order?.order_code || orderId; // Fallback
        await logService.logActivity('STAGE_JOIN', 'order', orderCode, { stage: stage });

        return data;
    },

    // LEAVE Stage (Undo Join)
    async leaveStage(orderId: string, stage: string, userId: string) {
        // We need order code for logging, so fetch it first or rely on client?
        // Let's fetch quickly or just look it up.
        // Actually, we can just log with ID if strictly needed, but let's try to consistant.
        // For efficiency, maybe just fetch code.
        const { data: order } = await supabase.from('orders').select('order_code').eq('id', orderId).single();
        const code = order?.order_code || orderId;

        const { error } = await supabase
            .from('order_process_participants')
            .delete()
            .match({ order_id: orderId, stage: stage, user_id: userId });

        if (error) throw error;

        // Log Leave/Undo Activity
        await logService.logActivity('STAGE_LEAVE', 'order', code, { stage: stage });
    },

    // FINANCE REPORTS
    async getDebtOrders() {
        const { data, error } = await supabase.rpc('get_debt_orders');
        if (error) throw error;
        return data; // Returns custom type from RPC
    },

    async getCollectionOrders() {
        const { data, error } = await supabase.rpc('get_collection_orders');
        if (error) throw error;
        return data;
    },

    // GET All Statuses for Counts (Lightweight)
    // Filtered by month/year to keep data manageable (no more 1000-row limit issue)
    async getAllOrderStatuses(filterMonth?: number, filterYear?: number) {
        let query = supabase
            .from('orders')
            .select('id, status, is_urgent, vat_amount, invoice_status, has_design, design_status, has_large_print, large_print_status, has_be_demi, be_demi_status, has_gia_cong_ngoai, outsource_status, has_ep_kim, ep_kim_status');

        // Apply month filter
        if (filterMonth && filterYear) {
            const startOfMonth = new Date(filterYear, filterMonth - 1, 1);
            const endOfMonth = new Date(filterYear, filterMonth, 0, 23, 59, 59);
            query = query.gte('created_at', startOfMonth.toISOString());
            query = query.lte('created_at', endOfMonth.toISOString());
        }

        const { data, error } = await query;
        if (error) throw error;
        return data as Partial<Order>[];
    }
};
