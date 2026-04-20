import { supabase } from './supabaseClient';

export interface Comment {
    id: string;
    order_id: string;
    user_id: string;
    context_key: string;
    content: string;
    ai_summary?: string;
    created_at: string;
    user?: {
        full_name: string;
        email: string;
    };
    is_auto_generated?: boolean;
}

export const commentService = {
    async getComments(orderId: string, contextKey: string) {
        const { data, error } = await supabase
            .from('order_comments')
            .select(`
                *,
                user:profiles(full_name, email)
            `)
            .eq('order_id', orderId)
            .eq('context_key', contextKey)
            .order('created_at', { ascending: true });

        if (error) throw error;
        return data as Comment[];
    },

    async addComment(orderId: string, contextKey: string, content: string, aiSummary?: string, isAuto?: boolean) {
        const { data: userData } = await supabase.auth.getUser();
        if (!userData.user) throw new Error("Not logged in");

        const { data, error } = await supabase
            .from('order_comments')
            .insert({
                order_id: orderId,
                user_id: userData.user.id,
                context_key: contextKey,
                content: content,
                ai_summary: aiSummary,
                is_auto_generated: isAuto || false
            })
            .select()
            .single();

        if (error) throw error;
        return data;
    }
};
