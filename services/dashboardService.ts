
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

// Ngày YYYY-MM-DD (giờ Việt Nam, UTC+7). Dùng giờ VN cố định thay vì giờ máy
// để kỳ xem không đổi theo múi giờ trình duyệt.
const VN_OFFSET = '+07:00';
const toVnDate = (d: Date) => new Date(d.getTime() + 7 * 3600 * 1000).toISOString().split('T')[0];
const dayStart = (ymd: string) => new Date(`${ymd}T00:00:00.000${VN_OFFSET}`);
const dayEnd = (ymd: string) => new Date(`${ymd}T23:59:59.999${VN_OFFSET}`);

export const dashboardService = {
    /**
     * Toàn bộ số liệu màn Tổng quan do CSDL tính trong MỘT hàm
     * get_dashboard_overview (setup_dashboard_overview.sql). Không kéo từng dòng đơn
     * về đây để cộng: Supabase cắt ở 1.000 dòng nên xem nhiều tháng sẽ thiếu số.
     */
    async getStats(period: 'today' | 'month' | 'custom', startDate?: string, endDate?: string): Promise<DashboardStats> {
        const todayVn = toVnDate(new Date());
        let startYmd: string, endYmd: string;

        if (period === 'today') {
            startYmd = endYmd = todayVn;
        } else if (period === 'month') {
            const [y, m] = todayVn.split('-').map(Number);
            startYmd = `${y}-${String(m).padStart(2, '0')}-01`;
            endYmd = toVnDate(new Date(Date.UTC(y, m, 0)));
        } else {
            const [y, m] = todayVn.split('-').map(Number);
            startYmd = startDate || `${y}-${String(m).padStart(2, '0')}-01`;
            endYmd = endDate || toVnDate(new Date(Date.UTC(y, m, 0)));
        }

        const { data, error } = await supabase.rpc('get_dashboard_overview', {
            p_start: dayStart(startYmd).toISOString(),
            p_end: dayEnd(endYmd).toISOString(),
        });

        if (error) {
            console.error('Dashboard Fetch Error:', error);
            throw error;
        }

        const r = (data || {}) as any;
        return {
            period,
            startDate: startYmd,
            endDate: endYmd,
            metrics: r.metrics,
            dailyRevenue: r.dailyRevenue || [],
            statusCounts: r.statusCounts || {},
            sourceCounts: r.sourceCounts || {},
            salesByEmployee: r.salesByEmployee || [],
            incompleteOrders: (r.incompleteOrders || []) as Order[],
            newCustomersList: r.newCustomersList || [],
        };
    }
};
