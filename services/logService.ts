
import { supabase } from './supabaseClient';
import { authService } from './auth';

export const logService = {
    /**
     * Log a user activity
     * @param actionType - e.g. 'LOGIN', 'ORDER_CREATE', 'ORDER_STATUS_UPDATE'
     * @param entityType - e.g. 'order', 'payment', 'system'
     * @param entityId - e.g. 'DH-123'
     * @param details - Any specific details about the change
     */
    logActivity: async (
        actionType: string,
        entityType: string,
        entityId: string,
        details: any = {}
    ) => {
        try {
            // Get current user info locally if possible to avoid extra calls, but session is best
            const session = await authService.getSession();
            if (!session?.user) return; // Anonymous actions usually not logged or handled differently

            // We can fetch profile name efficiently or pass it in. 
            // For now, let's try to get it from cache or session metadata if available.
            // Or just fire and forget.

            // Note: In a real app, we might want to queue these or handle them in a way that doesn't block UI.
            // For simplicity, we'll just await lightly or not await.

            // To get user_name, we might need to query profiles if not in specific context. 
            // However, usually we have userProfile in App context. 
            // Let's assume the DB trigger might fill user_name or we fetch it.
            // For now, let's just insert basic info.

            const { error } = await supabase.from('user_logs').insert({
                user_id: session.user.id,
                user_name: session.user.user_metadata?.full_name || session.user.email || 'Unknown',
                action_type: actionType,
                entity_type: entityType,
                entity_id: entityId,
                details: details
            });

            if (error) console.error('Log Error:', error);

        } catch (err) {
            console.error('Logging failed:', err);
        }


    },

    /**
     * Fetch logs for viewing
     */
    getLogs: async (filters: {
        userId?: string;
        actionType?: string;
        startDate?: string;
        endDate?: string;
        entityId?: string;
    }) => {
        let query = supabase
            .from('user_logs')
            .select('*')
            .order('created_at', { ascending: false })
            .limit(100); // Pagination later if needed

        if (filters.userId) query = query.eq('user_id', filters.userId);
        if (filters.actionType) query = query.eq('action_type', filters.actionType);
        if (filters.entityId) query = query.ilike('entity_id', `%${filters.entityId}%`);
        if (filters.startDate) query = query.gte('created_at', filters.startDate);
        if (filters.endDate) query = query.lte('created_at', filters.endDate + 'T23:59:59');

        const { data, error } = await query;
        if (error) throw error;

        // Enrich user_name if missing (optional step if we didn't save it)
        // ideally we join with profiles but let's stick to single table for simplicity first
        return data || [];
    }
};
