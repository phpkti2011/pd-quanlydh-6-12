import { supabase } from './supabaseClient';

export interface AppSettings {
    GOOGLE_AI_API_KEY?: string;
    GOOGLE_AI_INSTRUCTION?: string;
    // Add other settings here
}

export const settingsService = {
    async getSetting(key: string): Promise<any> {
        try {
            const { data, error } = await supabase
                .from('app_settings')
                .select('value')
                .eq('key', key)
                .single();

            if (error) {
                // If not found, return null
                if (error.code === 'PGRST116') return null;
                throw error;
            }
            return data?.value || null;
        } catch (error) {
            console.error(`Error fetching setting ${key}:`, error);
            return null;
        }
    },

    async saveSetting(key: string, value: any): Promise<boolean> {
        try {
            const { error } = await supabase
                .from('app_settings')
                .upsert({
                    key,
                    value,
                    updated_at: new Date().toISOString()
                }, { onConflict: 'key' });

            if (error) throw error;
            return true;
        } catch (error) {
            console.error(`Error saving setting ${key}:`, error);
            return false;
        }
    },

    // Specific Getters
    async getAIConfig() {
        const apiKey = await this.getSetting('GOOGLE_AI_API_KEY');
        const instruction = await this.getSetting('GOOGLE_AI_INSTRUCTION');
        return {
            apiKey: apiKey?.value || '',
            instruction: instruction?.value || ''
        };
    },

    async saveAIConfig(apiKey: string, instruction: string) {
        const r1 = await this.saveSetting('GOOGLE_AI_API_KEY', { value: apiKey });
        const r2 = await this.saveSetting('GOOGLE_AI_INSTRUCTION', { value: instruction });
        return r1 && r2;
    }
};
