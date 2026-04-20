import { supabase } from './supabaseClient';

export interface PublicOrderInfo {
    order_code: string;
    created_at: string;
    status: string;
    delivery_date: string | null;
    customer_name: string | null;
    description: string | null;
    notes: string | null;
    items: any; // JSONB
}

export const trackingService = {
    async getOrderInfo(token: string): Promise<PublicOrderInfo | null> {
        // Validate UUID format client-side
        const uuidRegex = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
        if (!uuidRegex.test(token)) {
            console.error('Invalid UUID format:', token);
            throw new Error('Mã theo dõi không hợp lệ (Sai định dạng).');
        }

        const { data, error } = await supabase
            .rpc('get_public_order_info', { p_token: token })
            .single();

        if (error) {
            console.error('RPC Error fetching tracking info:', error);
            throw new Error(error.message || 'Lỗi kết nối máy chủ.');
        }
        return data;
    }
};
