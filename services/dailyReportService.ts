import { supabase } from './supabaseClient';

export interface DailyReportData {
    report_date: string;
    orders_created_today: number;
    orders_completed_today: number;
    orders_cancelled_today: number;
    pending_orders_count: number;
    revenue_today: number;
    revenue_today_pre_vat: number;
    revenue_completed_today: number;
    revenue_month_total: number;
    revenue_month_pre_vat: number;
    sales_by_employee: Array<{
        employee_name: string;
        role: string;
        orders_created: number;
        orders_completed: number;
        revenue: number;
    }>;
    status_transitions_today: Array<{ to_status: string; count: number }>;
    employee_activity: Array<{
        employee_name: string;
        total_actions: number;
        orders_created: number;
        status_updates: number;
        stage_actions: number;
        payment_updates: number;
    }>;
    payment_stats: {
        total_collected: number;
        unpaid_orders: number;
        debt_orders: number;
    };
}

export interface RevenueTrendPoint {
    date: string;
    revenue_pre_vat: number;
    revenue_total: number;
}

export const dailyReportService = {
    async getDailyReport(date?: string): Promise<DailyReportData> {
        const { data, error } = await supabase.rpc('get_daily_report', date ? { p_date: date } : {});
        if (error) throw error;
        return data as DailyReportData;
    },

    async getRevenueTrend(days = 7, endDate?: string): Promise<RevenueTrendPoint[]> {
        const params: any = { p_days: days };
        if (endDate) params.p_end_date = endDate;
        const { data, error } = await supabase.rpc('get_revenue_trend', params);
        if (error) throw error;
        return (data as RevenueTrendPoint[]) || [];
    },
};
