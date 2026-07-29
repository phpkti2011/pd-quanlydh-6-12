
import { supabase } from './supabaseClient';
import { authService } from './auth';

export interface ActivityLog {
    id: string;
    created_at: string;
    user_id: string | null;
    user_name: string;
    user_role: string | null;
    action_type: string;
    entity_type: string | null;
    entity_id: string | null;
    entity_uuid: string | null;
    details: any;
    source: string | null;
    total_count: number;
}

// true khi RPC get_activity_logs chưa tồn tại (chưa chạy setup_audit_trail.sql).
// Lúc đó CSDL cũng chưa có trigger nên KHÔNG có hoạt động mới nào được ghi lại.
let rpcMissing = false;
export const isAuditTrailMissing = () => rpcMissing;

export interface LogFilters {
    userId?: string;
    actionType?: string;
    entityType?: string;
    startDate?: string;
    endDate?: string;
    entityId?: string;
    limit?: number;
    offset?: number;
}

export const logService = {
    /**
     * Ghi lại hành động của người dùng.
     *
     * LƯU Ý: mọi thay đổi DỮ LIỆU (đơn hàng, khách hàng, nhân viên, công đoạn)
     * đã được trigger trong CSDL tự ghi — xem setup_audit_trail.sql. Hàm này
     * chỉ còn dùng cho những sự kiện mà CSDL không nhìn thấy được, cụ thể là
     * đăng nhập / đăng xuất. Đừng gọi nó để ghi thay đổi dữ liệu, sẽ bị trùng.
     */
    logActivity: async (
        actionType: string,
        entityType: string,
        entityId: string,
        details: any = {}
    ) => {
        try {
            const session = await authService.getSession();
            if (!session?.user) return;

            // Lấy tên từ bảng profiles (nguồn chuẩn) thay vì auth.user_metadata —
            // metadata chỉ được set lúc đăng ký nên đổi tên nhân viên là log sai.
            let userName = session.user.email || 'Không rõ';
            try {
                const profile = await authService.getUserProfile(session.user.id);
                if (profile?.full_name) userName = profile.full_name;
            } catch {
                // Không lấy được profile thì dùng email, không chặn việc ghi log
            }

            const { error } = await supabase.from('user_logs').insert({
                user_id: session.user.id,
                user_name: userName,
                action_type: actionType,
                entity_type: entityType,
                entity_id: entityId,
                details: details,
                source: 'app'
            });

            if (error) console.error('Ghi nhật ký thất bại:', actionType, error.message);

        } catch (err) {
            console.error('Ghi nhật ký thất bại:', err);
        }
    },

    /**
     * Đọc nhật ký hoạt động qua RPC get_activity_logs.
     * RPC join sang profiles để lấy tên hiện tại và hỗ trợ phân trang.
     *
     * Nếu chưa chạy setup_audit_trail.sql thì RPC chưa tồn tại — khi đó tự
     * chuyển sang đọc thẳng bảng user_logs để màn hình vẫn xem được log cũ.
     */
    getLogs: async (filters: LogFilters): Promise<ActivityLog[]> => {
        const { data, error } = await supabase.rpc('get_activity_logs', {
            p_user_id: filters.userId || null,
            p_action_type: filters.actionType || null,
            p_entity_type: filters.entityType || null,
            p_entity_id: filters.entityId || null,
            p_start: filters.startDate || null,
            p_end: filters.endDate ? filters.endDate + 'T23:59:59' : null,
            p_limit: filters.limit ?? 50,
            p_offset: filters.offset ?? 0
        });

        if (error) {
            // PGRST202 = không tìm thấy hàm trong schema cache
            const missingRpc = error.code === 'PGRST202'
                || /get_activity_logs/i.test(error.message || '');
            if (missingRpc) {
                rpcMissing = true;
                console.warn('Chưa chạy setup_audit_trail.sql — đang đọc trực tiếp bảng user_logs.');
                return logService.getLogsFallback(filters);
            }
            throw error;
        }
        rpcMissing = false;
        return (data || []) as ActivityLog[];
    },

    /** Đọc trực tiếp bảng user_logs (dùng khi RPC chưa được cài) */
    getLogsFallback: async (filters: LogFilters): Promise<ActivityLog[]> => {
        const limit = filters.limit ?? 50;
        const offset = filters.offset ?? 0;

        let query = supabase
            .from('user_logs')
            .select('*', { count: 'exact' })
            .order('created_at', { ascending: false })
            .range(offset, offset + limit - 1);

        if (filters.userId) query = query.eq('user_id', filters.userId);
        if (filters.actionType) query = query.eq('action_type', filters.actionType);
        if (filters.entityType) query = query.eq('entity_type', filters.entityType);
        if (filters.entityId) query = query.ilike('entity_id', `${filters.entityId}%`);
        if (filters.startDate) query = query.gte('created_at', filters.startDate);
        if (filters.endDate) query = query.lte('created_at', filters.endDate + 'T23:59:59');

        const { data, error, count } = await query;
        if (error) throw error;

        return (data || []).map((r: any) => ({
            ...r,
            user_role: null,
            entity_uuid: r.entity_uuid ?? null,
            source: r.source ?? 'app',
            total_count: count ?? (data || []).length,
        })) as ActivityLog[];
    }
};
