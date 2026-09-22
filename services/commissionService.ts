
import { supabase } from './supabaseClient';
import { SalesCommissionResult, StaffCommissionResult, CommissionPolicy, ProductionTierSummary, DefectDeduction } from '../types';

export const commissionService = {
    /**
     * Calculate Sales Commission
     */
    calculateSalesCommission: async (
        startDate: string,
        endDate: string,
        salesRepName?: string
    ): Promise<SalesCommissionResult[]> => {
        if (!supabase) return [];

        const { data, error } = await supabase.rpc('calculate_sales_commission', {
            p_start_date: startDate,
            p_end_date: endDate,
            p_sales_rep_name: salesRepName || null // Pass salesRepName if provided
        });

        if (error) {
            console.error("Error fetching sales commission:", error);
            throw error;
        }

        return data as SalesCommissionResult[];
    },

    /**
     * Calculate Staff Commission
     */
    calculateStaffCommission: async (
        startDate: string,
        endDate: string,
        userName?: string
    ): Promise<StaffCommissionResult[]> => {
        if (!supabase) return [];

        const { data, error } = await supabase.rpc('calculate_staff_commission', {
            p_start_date: startDate,
            p_end_date: endDate,
            p_user_name: userName || null
        });

        if (error) {
            console.error("Error fetching staff commission:", error);
            throw error;
        }

        return data as StaffCommissionResult[];
    },

    async getStaffActivityDetails(startDate: string, endDate: string, userName?: string) {
        // Validation check
        if (new Date(startDate) > new Date(endDate)) {
            throw new Error("Ngày kết thúc phải lớn hơn hoặc bằng ngày bắt đầu");
        }

        const { data, error } = await supabase.rpc('get_staff_activity_details', {
            p_start_date: startDate,
            p_end_date: endDate,
            p_user_name: userName || null
        });

        if (error) {
            console.error('getStaffActivityDetails Error:', error);
            throw new Error(error.message);
        }
        return data || [];
    },

    async getPerformanceStats(startDate: string, endDate: string, userName?: string) {
        if (new Date(startDate) > new Date(endDate)) {
            throw new Error("Ngày kết thúc phải lớn hơn hoặc bằng ngày bắt đầu");
        }

        const { data, error } = await supabase.rpc('get_performance_stats', {
            p_start_date: startDate,
            p_end_date: endDate,
            p_user_name: userName || null
        });

        if (error) {
            console.error('getPerformanceStats Error:', error);
            throw new Error(error.message);
        }
        return data || [];
    },

    /**
     * Get orders contributing to a sales rep's commission
     */
    getSalesRepOrders: async (startDate: string, endDate: string, salesRepName: string) => {
        if (!supabase) return [];

        const TRANSITION_DATE = '2026-03-01';

        // Query via profiles to get sales_rep_id
        const { data: profile } = await supabase
            .from('profiles')
            .select('id')
            .eq('full_name', salesRepName)
            .single();

        if (!profile) return [];

        // Query old orders (created before March 2026): by created_at
        const { data: oldOrders } = await supabase
            .from('orders')
            .select('id, order_code, total_amount_pre_vat, total_amount, status, created_at, completed_at, customer:customers(name)')
            .lt('created_at', TRANSITION_DATE)
            .gte('created_at', startDate)
            .lte('created_at', endDate + 'T23:59:59')
            .eq('status', 'HoanThanh')
            .eq('sales_rep_id', profile.id)
            .order('created_at', { ascending: false });

        // Query new orders (created from March 2026): by completed_at
        const { data: newOrders } = await supabase
            .from('orders')
            .select('id, order_code, total_amount_pre_vat, total_amount, status, created_at, completed_at, customer:customers(name)')
            .gte('created_at', TRANSITION_DATE)
            .not('completed_at', 'is', null)
            .gte('completed_at', startDate)
            .lte('completed_at', endDate + 'T23:59:59')
            .eq('status', 'HoanThanh')
            .eq('sales_rep_id', profile.id)
            .order('completed_at', { ascending: false });

        // Merge and deduplicate
        const allOrders = [...(oldOrders || []), ...(newOrders || [])];
        const seen = new Set<string>();
        return allOrders.filter(o => {
            if (seen.has(o.id)) return false;
            seen.add(o.id);
            return true;
        });
    },

    /**
     * Get Commission Policies (Admin Config)
     */
    async getCommissionPolicies(type: string = 'MAINTASK_RATE') {
        const { data, error } = await supabase
            .from('commission_policies')
            .select('*')
            .eq('policy_type', type)
            .order('id');

        if (error) throw error;
        return data as CommissionPolicy[];
    },

    /**
     * Update Policy Rate
     */
    async updateCommissionPolicy(id: string, updates: Partial<CommissionPolicy>) {
        const { data, error } = await supabase
            .from('commission_policies')
            .update(updates)
            .eq('id', id)
            .select();

        if (error) throw error;
        return data;
    },

    /**
     * Get Production Commission Tiers cho 1 tháng cụ thể.
     * Nếu tháng đó chưa cấu hình riêng -> fallback về mốc global (period_month IS NULL).
     */
    async getProductionTiers(month: number, year: number): Promise<CommissionPolicy[]> {
        // 1. Ưu tiên mốc riêng của tháng
        const { data: monthData, error: monthErr } = await supabase
            .from('commission_policies')
            .select('*')
            .eq('policy_type', 'PRODUCTION_TIER')
            .eq('period_month', month)
            .eq('period_year', year)
            .order('threshold_min', { ascending: true });

        if (monthErr) throw monthErr;
        if (monthData && monthData.length > 0) return monthData as CommissionPolicy[];

        // 2. Fallback: mốc global (chưa gắn tháng)
        const { data: globalData, error: globalErr } = await supabase
            .from('commission_policies')
            .select('*')
            .eq('policy_type', 'PRODUCTION_TIER')
            .is('period_month', null)
            .order('threshold_min', { ascending: true });

        if (globalErr) throw globalErr;
        return (globalData || []) as CommissionPolicy[];
    },

    /**
     * Upsert a Production Tier
     */
    /**
     * Save all production tiers at once via RPC (bypasses RLS)
     */
    async saveProductionTiers(
        tiers: { threshold_min: number; threshold_max: number | null; rate: number }[],
        month: number,
        year: number
    ) {
        const payload = tiers.map(t => ({
            min: t.threshold_min,
            max: t.threshold_max,
            rate: t.rate
        }));
        const { error } = await supabase.rpc('save_production_tiers', {
            p_tiers: JSON.stringify(payload),
            p_month: month,
            p_year: year
        });
        if (error) throw error;
    },

    /**
     * Lưu bộ mốc CHUNG (period_month IS NULL) — lưới an toàn cho mọi tháng
     * chưa cấu hình riêng. Chỉ Admin (hàm SQL tự chặn).
     * Xem fix_production_global_tiers.sql
     */
    async saveGlobalProductionTiers(
        tiers: { threshold_min: number; threshold_max: number | null; rate: number }[]
    ) {
        const payload = tiers.map(t => ({
            min: t.threshold_min,
            max: t.threshold_max,
            rate: t.rate
        }));
        const { error } = await supabase.rpc('save_global_production_tiers', {
            p_tiers: JSON.stringify(payload)
        });
        if (error) throw error;
    },

    /**
     * Gửi thông báo doanh số + mốc thưởng cho nhân viên sản xuất.
     * Nội dung do SQL dựng (build_production_revenue_message) — dùng chung với
     * cron 7h sáng và trigger tự báo khi vượt mốc, để không có 2 bản lệch nhau.
     * Trả về số người đã nhận (0 nếu bị chặn gửi trùng trong 10 phút).
     * Xem setup_production_revenue_notify.sql
     */
    async notifyProductionRevenue(month: number, year: number, headline?: string): Promise<number> {
        const { data, error } = await supabase.rpc('notify_production_revenue', {
            p_month: month,
            p_year: year,
            p_headline: headline ?? null,
            p_require_admin: true
        });
        if (error) throw error;
        return (data as number) ?? 0;
    },

    /**
     * Tháng này đang lấy mốc từ đâu? Khớp đúng thứ tự ưu tiên của
     * get_production_tier_rate: mốc riêng của tháng trước, không có thì mốc chung.
     *   'month'  - có mốc riêng của tháng
     *   'global' - đang mượn mốc chung
     *   'none'   - không có mốc nào -> mọi người nhận 0%
     */
    async getProductionTierSource(month: number, year: number): Promise<'month' | 'global' | 'none'> {
        const { count: monthCount } = await supabase
            .from('commission_policies')
            .select('id', { count: 'exact', head: true })
            .eq('policy_type', 'PRODUCTION_TIER')
            .eq('period_month', month)
            .eq('period_year', year);

        if ((monthCount || 0) > 0) return 'month';

        const { count: globalCount } = await supabase
            .from('commission_policies')
            .select('id', { count: 'exact', head: true })
            .eq('policy_type', 'PRODUCTION_TIER')
            .is('period_month', null);

        return (globalCount || 0) > 0 ? 'global' : 'none';
    },

    /**
     * Get Production Commission Summary (for display & notifications)
     */
    async getProductionCommissionSummary(month: number, year: number): Promise<ProductionTierSummary | null> {
        const { data, error } = await supabase.rpc('get_production_commission_summary', {
            p_month: month,
            p_year: year
        });

        if (error) {
            console.error('getProductionCommissionSummary Error:', error);
            throw error;
        }

        if (data && data.length > 0) {
            return data[0] as ProductionTierSummary;
        }
        return null;
    },

    // ===== TRỪ SAI HỎNG SẢN XUẤT =====
    // Bảng production_defect_deductions bị RLS khoá chỉ cho Admin, nên nhân viên
    // gọi các hàm này sẽ nhận danh sách rỗng / bị từ chối ghi.

    async getDefectDeductions(month: number, year: number): Promise<DefectDeduction[]> {
        const { data, error } = await supabase
            .from('production_defect_deductions')
            .select('*, created_by_user:created_by(full_name)')
            .eq('period_month', month)
            .eq('period_year', year)
            .order('created_at', { ascending: false });

        if (error) throw error;
        return (data || []) as DefectDeduction[];
    },

    async addDefectDeduction(input: {
        month: number;
        year: number;
        amount: number;
        reason?: string;
        orderCode?: string;
    }) {
        const { data: { session } } = await supabase.auth.getSession();

        const { error } = await supabase
            .from('production_defect_deductions')
            .insert({
                period_month: input.month,
                period_year: input.year,
                amount: input.amount,
                reason: input.reason || null,
                order_code: input.orderCode || null,
                created_by: session?.user?.id || null
            });

        if (error) throw error;
    },

    async deleteDefectDeduction(id: string) {
        const { error } = await supabase
            .from('production_defect_deductions')
            .delete()
            .eq('id', id);

        if (error) throw error;
    }
};
