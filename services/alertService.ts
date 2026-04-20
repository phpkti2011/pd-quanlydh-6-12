import { supabase } from './supabaseClient';

export interface AlertItem {
    id: string;
    order_code: string;
    alert_msg: string;
    [key: string]: any;
}

export interface SalesAlerts {
    debt: AlertItem[];
    deadline: AlertItem[];
    approval: AlertItem[];
}

export interface ProductionAlerts {
    urgent: AlertItem[];
    bottleneck: AlertItem[];
}

export const alertService = {
    // Get Personalized Sales Alerts
    getSalesAlerts: async (): Promise<SalesAlerts> => {
        const { data: { session } } = await supabase.auth.getSession();
        if (!session?.user) return { debt: [], deadline: [], approval: [] };

        const { data, error } = await supabase
            .rpc('get_sales_alerts', { p_user_id: session.user.id });

        if (error) {
            console.error('Error fetching sales alerts:', error);
            return { debt: [], deadline: [], approval: [] };
        }
        return data as SalesAlerts;
    },

    // Get Production Alerts (Global for now, can be role-filtered)
    getProductionAlerts: async (): Promise<ProductionAlerts> => {
        const { data, error } = await supabase
            .rpc('get_production_alerts');

        if (error) {
            console.error('Error fetching production alerts:', error);
            return { urgent: [], bottleneck: [] };
        }
        return data as ProductionAlerts;
    }
};
