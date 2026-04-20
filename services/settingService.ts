import { supabase } from './supabaseClient';

export interface BankAccountConfig {
    bankId: string;   // e.g., 'MB', 'VCB'
    accountNo: string;
    accountName: string;
    template?: string; // e.g., 'compact', 'qr_only'
}

export interface BankSettings {
    vat: BankAccountConfig;
    nonVat: BankAccountConfig;
}

export const SETTING_KEYS = {
    BANK_CONFIG: 'bank_config'
};

export const settingService = {
    async getSetting<T>(key: string): Promise<T | null> {
        const { data, error } = await supabase
            .from('app_settings')
            .select('value')
            .eq('key', key)
            .single();

        if (error) {
            // Ignore "Row not found" error, return null
            if (error.code === 'PGRST116') return null;
            console.error(`Error fetching setting ${key}:`, error);
            return null;
        }

        return data?.value as T;
    },

    async saveSetting(key: string, value: any): Promise<void> {
        const { error } = await supabase
            .from('app_settings')
            .upsert({
                key,
                value,
                updated_at: new Date().toISOString()
            });

        if (error) {
            console.error(`Error saving setting ${key}:`, error);
            throw error;
        }
    }
};
