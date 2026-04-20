
import { supabase } from './supabaseClient';
import { Order } from '../types';

export interface DashboardStats {
    period: string;
    startDate: string;
    endDate: string;
    metrics: {
        ordersCount: number;
        revenueWithVAT: number;
        revenueNoVAT: number;
        designRevenue: number;
        largePrintRevenue: number;
        newCustomersCount: number;
        returningCustomersCount: number;
        completedRevenueNoVAT: number; // NEW: Doanh số hoàn thành chưa VAT
    };
    dailyRevenue: { date: string; revenue: number }[];
    statusCounts: Record<string, number>;
    sourceCounts: Record<string, number>;
    salesByEmployee: { name: string; sales: number }[];
    tabCounts: Record<string, number>;
    incompleteOrders: Order[];
    newCustomersList: {
        customer_id: string;
        customer_name: string;
        customer_phone: string;
        customer_source: string;
        first_order_code: string;
        first_order_date: string;
        sales_rep: string;
    }[];
}

export const dashboardService = {
    async getStats(period: 'today' | 'month' | 'custom', startDate?: string, endDate?: string): Promise<DashboardStats> {
        // 1. Determine Date Range
        let start: Date, end: Date;
        const now = new Date();

        if (period === 'today') {
            start = new Date(now.getFullYear(), now.getMonth(), now.getDate());
            end = new Date(now.getFullYear(), now.getMonth(), now.getDate(), 23, 59, 59, 999);
        } else if (period === 'month') {
            start = new Date(now.getFullYear(), now.getMonth(), 1);
            end = new Date(now.getFullYear(), now.getMonth() + 1, 0, 23, 59, 59, 999);
        } else {
            start = startDate ? new Date(startDate) : new Date(now.getFullYear(), now.getMonth(), 1);
            end = endDate ? new Date(endDate) : new Date(now.getFullYear(), now.getMonth() + 1, 0, 23, 59, 59, 999);
            end.setHours(23, 59, 59, 999);
        }

        // 2. Fetch ALL Orders (including 'Huy' for tab counts)
        // Explicitly fetch customer data for charts
        const { data: allOrdersData, error } = await supabase
            .from('orders')
            .select(`
                *,
                sales_rep:sales_rep_id (full_name),
                customer:customer_id (id, source, tags)
            `)
            .gte('created_at', start.toISOString())
            .lte('created_at', end.toISOString());

        if (error) {
            console.error("Dashboard Fetch Error:", error);
            throw error;
        }
        const allOrders = allOrdersData as Order[] || [];

        // Fetch DOANH THU HOÀN THÀNH riêng biệt để không ảnh hưởng đến logic của đơn tạo trong kỳ
        let completedRevenueNoVATValue = 0;
        const isNewMethod = start.getFullYear() > 2026 || (start.getFullYear() === 2026 && start.getMonth() >= 2);

        let completedRevQuery = supabase
            .from('orders')
            .select('total_amount, vat_amount, created_at, status')
            .eq('status', 'HoanThanh')
            .gte('completed_at', start.toISOString())
            .lte('completed_at', end.toISOString());

        if (isNewMethod) {
            completedRevQuery = completedRevQuery.gte('created_at', '2026-03-01T00:00:00Z');
        }

        const { data: completedOrdersData } = await completedRevQuery;

        if (completedOrdersData) {
            completedOrdersData.forEach(o => {
                completedRevenueNoVATValue += ((o.total_amount || 0) - (o.vat_amount || 0));
            });
        }

        // 3. Initialize Aggregators
        const metrics = {
            ordersCount: 0,
            revenueWithVAT: 0,
            revenueNoVAT: 0,
            designRevenue: 0,
            largePrintRevenue: 0,
            newCustomersCount: 0,
            returningCustomersCount: 0,
            completedRevenueNoVAT: completedRevenueNoVATValue
        };

        const dailyRevMap: Record<string, number> = {};
        const statusMap: Record<string, number> = {};
        const employeeSalesMap: Record<string, number> = {};
        const sourceMap: Record<string, number> = {}; // For Customer Source chart
        const customerSet = new Set<string>(); // Track unique customers
        const newCustomerIds = new Set<string>(); // Track new customer IDs

        const tabCounts: Record<string, number> = {
            all: 0, moi: 0, tiep_nhan: 0, nhan_file: 0, xu_ly_file: 0, binh_file: 0,
            in: 0, thanh_pham: 0, dong_goi: 0, cho_giao_hang: 0, da_giao_hang: 0,
            hoan_thanh: 0, huy: 0, tam_ngung: 0,
            thiet_ke: 0, in_kho_lon: 0, be_demi: 0, gia_cong_ngoai: 0, ep_kim: 0,
            xuat_hoa_don: 0, gap: 0
        };

        // 4. Get customers' first order dates from ALL history (not just current period)
        // This is needed to correctly identify new vs returning customers
        const uniqueCustomerIds = [...new Set(allOrders.filter(o => o.customer_id).map(o => o.customer_id))];

        const customerFirstOrderMap = new Map<string, string>(); // customer_id -> first order date

        if (uniqueCustomerIds.length > 0) {
            // Query first order for each customer from entire history
            const { data: firstOrders } = await supabase
                .from('orders')
                .select('customer_id, created_at')
                .in('customer_id', uniqueCustomerIds)
                .neq('status', 'Huy')
                .order('created_at', { ascending: true });

            if (firstOrders) {
                firstOrders.forEach(order => {
                    if (order.customer_id && !customerFirstOrderMap.has(order.customer_id)) {
                        customerFirstOrderMap.set(order.customer_id, order.created_at);
                    }
                });
            }
        }

        // 4b. Second Pass: Calculate metrics
        const processedCustomers = new Set<string>();

        allOrders.forEach(order => {
            // Tab Counts (ALL orders)
            tabCounts.all++;

            const statusKey = order.status === 'TiepNhan' ? 'tiep_nhan' :
                order.status === 'NhanFile' ? 'nhan_file' :
                    order.status === 'XuLyFile' ? 'xu_ly_file' :
                        order.status === 'BinhFile' ? 'binh_file' :
                            order.status === 'In' ? 'in' :
                                order.status === 'ThanhPham' ? 'thanh_pham' :
                                    order.status === 'DongGoi' ? 'dong_goi' :
                                        order.status === 'ChoGiaoHang' ? 'cho_giao_hang' :
                                            order.status === 'DaGiaoHang' ? 'da_giao_hang' :
                                                order.status === 'HoanThanh' ? 'hoan_thanh' :
                                                    order.status === 'Huy' ? 'huy' :
                                                        order.status === 'TamNgung' ? 'tam_ngung' :
                                                            order.status === 'Moi' ? 'moi' : null;

            if (statusKey && tabCounts[statusKey] !== undefined) {
                tabCounts[statusKey]++;
            }
            if (order.status === 'DaGiaoHang') tabCounts['hoan_thanh']++;

            // Subtasks
            if (order.has_design && order.design_status !== 'Completed') tabCounts.thiet_ke++;
            if (order.has_large_print && order.large_print_status !== 'Completed') tabCounts.in_kho_lon++;
            if (order.has_be_demi && order.be_demi_status !== 'Completed') tabCounts.be_demi++;
            if (order.has_gia_cong_ngoai && order.outsource_status !== 'Completed') tabCounts.gia_cong_ngoai++;
            if (order.has_ep_kim && order.ep_kim_status !== 'Completed') tabCounts.ep_kim++;
            if (order.invoice_status !== 'Issued') tabCounts.xuat_hoa_don++;
            if (order.is_urgent && !['Huy', 'HoanThanh', 'DaGiaoHang'].includes(order.status)) tabCounts.gap++;

            // Metrics & Charts (Exclude 'Huy')
            if (order.status !== 'Huy') {
                metrics.ordersCount++;
                const totalAmt = order.total_amount || 0;
                const vatAmt = order.vat_amount || 0;

                metrics.revenueWithVAT += totalAmt;
                metrics.revenueNoVAT += (totalAmt - vatAmt); // CORRECT CALCULATION

                if (order.has_design) metrics.designRevenue += (order.design_fee || 0);
                if (order.has_large_print) metrics.largePrintRevenue += (order.large_print_fee || 0);

                // Daily Revenue
                const dateKey = new Date(order.created_at).toISOString().split('T')[0];
                dailyRevMap[dateKey] = (dailyRevMap[dateKey] || 0) + totalAmt;

                // Status Counts
                statusMap[order.status] = (statusMap[order.status] || 0) + 1;

                // Employee Sales - TRANSITION LOGIC
                // ≤ Feb 2026: old method (all HoanThanh in period by created_at)
                // ≥ Mar 2026: only orders with completed_at in period AND created >= March 1
                if (order.sales_rep?.full_name && order.status === 'HoanThanh') {
                    const isNewMethod = start.getFullYear() > 2026 || (start.getFullYear() === 2026 && start.getMonth() >= 2); // month is 0-indexed

                    if (isNewMethod) {
                        const completedDate = (order as any).completed_at ? new Date((order as any).completed_at) : null;
                        const createdDate = new Date(order.created_at);
                        const marchCutoff = new Date('2026-03-01T00:00:00Z');

                        // Only count if completed in period AND created >= March 2026
                        if (completedDate && completedDate >= start && completedDate <= end && createdDate >= marchCutoff) {
                            employeeSalesMap[order.sales_rep.full_name] = (employeeSalesMap[order.sales_rep.full_name] || 0) + (totalAmt - vatAmt);
                        }
                    } else {
                        // Old method: count all HoanThanh in period (filtered by created_at already)
                        employeeSalesMap[order.sales_rep.full_name] = (employeeSalesMap[order.sales_rep.full_name] || 0) + (totalAmt - vatAmt);
                    }
                }

                // Customer Source
                if (order.customer?.source) {
                    sourceMap[order.customer.source] = (sourceMap[order.customer.source] || 0) + 1;
                }

                // Customer Lifecycle (New vs Returning) - UPDATED LOGIC
                // New = Only the first order of the customer EVER (and it's in this period)
                // Returning = Any order that is NOT the first order ever
                if (order.customer_id) {
                    const firstOrderDate = customerFirstOrderMap.get(order.customer_id);

                    if (firstOrderDate) {
                        const isFirstOrderEver = order.created_at === firstOrderDate;
                        const firstOrderInPeriod = new Date(firstOrderDate) >= start && new Date(firstOrderDate) <= end;

                        if (isFirstOrderEver && firstOrderInPeriod) {
                            // This IS the customer's first order ever, and it's in this period = New
                            metrics.newCustomersCount++;
                            newCustomerIds.add(order.customer_id);
                        } else if (!isFirstOrderEver && !processedCustomers.has(order.customer_id)) {
                            // This is NOT the first order, count as returning (once per period)
                            processedCustomers.add(order.customer_id);
                            metrics.returningCustomersCount++;
                        }
                    }

                    customerSet.add(order.customer_id);
                }
            }
        });

        // 5. Format Arrays
        // 5. Format Arrays
        // Fill in missing dates for the chart
        const filledDailyRevenue: { date: string; revenue: number }[] = [];
        const currentDate = new Date(start);
        const endDateObj = new Date(end);

        while (currentDate <= endDateObj) {
            const dateStr = currentDate.toISOString().split('T')[0];
            filledDailyRevenue.push({
                date: dateStr,
                revenue: dailyRevMap[dateStr] || 0
            });
            currentDate.setDate(currentDate.getDate() + 1);
        }

        const dailyRevenue = filledDailyRevenue.sort((a, b) => a.date.localeCompare(b.date));

        const salesByEmployee = Object.entries(employeeSalesMap)
            .map(([name, sales]) => ({ name, sales }))
            .sort((a, b) => b.sales - a.sales);

        // 6. Incomplete Orders Report
        // Filter: Created in period AND Status NOT IN (Completed, Cancelled, Paused)
        // NOTE: DaGiaoHang IS included so employees can see delivered orders and mark them HoanThanh
        const incompleteOrders = allOrders.filter(o =>
            !['HoanThanh', 'Huy', 'TamNgung'].includes(o.status)
        ).sort((a, b) => {
            // Sort Priority: Urgent > Created Recently
            if (a.is_urgent && !b.is_urgent) return -1;
            if (!a.is_urgent && b.is_urgent) return 1;
            return new Date(b.created_at).getTime() - new Date(a.created_at).getTime();
        });

        // Lấy danh sách khách hàng mới (thông tin đầy đủ từ orders đã fetch)
        const newCustomersList = allOrders
            .filter(o => o.customer_id && newCustomerIds.has(o.customer_id) && o.created_at === customerFirstOrderMap.get(o.customer_id))
            .map(o => ({
                customer_id: o.customer_id,
                customer_name: o.customer?.name || 'N/A',
                customer_phone: o.customer?.phone || '',
                customer_source: o.customer?.source || '',
                first_order_code: o.order_code || '',
                first_order_date: o.created_at,
                sales_rep: o.sales_rep?.full_name || '',
            }));

        return {
            period,
            startDate: start.toISOString().split('T')[0],
            endDate: end.toISOString().split('T')[0],
            metrics,
            dailyRevenue,
            statusCounts: statusMap,
            sourceCounts: sourceMap,
            salesByEmployee,
            tabCounts,
            incompleteOrders,
            newCustomersList
        };
    }
};
