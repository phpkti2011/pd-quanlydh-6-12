import { supabase } from './supabaseClient';

export interface UserProfile {
    id: string;
    email: string;
    role?: string;
    full_name?: string;
    is_locked?: boolean;
}

export const authService = {
    /**
     * Sign in with Email and Password
     */
    signInWithEmail: async (email: string, password: string) => {
        if (!supabase) throw new Error("Supabase client not initialized");

        const { data, error } = await supabase.auth.signInWithPassword({
            email,
            password,
        });

        if (error) throw error;

        // Ghi nhật ký đăng nhập. Import động vì logService đã import file này
        // (import tĩnh hai chiều sẽ tạo vòng lặp phụ thuộc).
        try {
            const { logService } = await import('./logService');
            await logService.logActivity('LOGIN', 'system', email, {});
        } catch (e) {
            console.error('Không ghi được nhật ký đăng nhập:', e);
        }

        return data;
    },

    /**
     * Sign Out
     */
    signOut: async () => {
        if (!supabase) return;

        // Ghi log TRƯỚC khi huỷ session, nếu không sẽ không còn ai để ghi tên
        try {
            const { data } = await supabase.auth.getSession();
            if (data.session?.user) {
                const { logService } = await import('./logService');
                await logService.logActivity('LOGOUT', 'system', data.session.user.email || '', {});
            }
        } catch (e) {
            console.error('Không ghi được nhật ký đăng xuất:', e);
        }

        const { error } = await supabase.auth.signOut();
        if (error) throw error;
    },

    /**
     * Get Current Session
     */
    getSession: async () => {
        if (!supabase) return null;
        const { data } = await supabase.auth.getSession();
        return data.session;
    },

    /**
     * Get Current User Profile (including role from 'profiles' table)
     */
    getUserProfile: async (userId: string): Promise<UserProfile | null> => {
        if (!supabase) return null;

        const { data: profile, error } = await supabase
            .from('profiles')
            .select('id, email, full_name, role, is_locked')
            .eq('id', userId)
            .single();

        if (error) {
            console.error("Error fetching profile:", error);
            return null;
        }

        return profile;
    },
    /**
     * Get All Sales Reps
     */
    getAllSalesReps: async (): Promise<UserProfile[]> => {
        if (!supabase) return [];

        const { data, error } = await supabase
            .from('profiles')
            .select('id, email, full_name, role')
            .eq('role', 'NhanVienKinhDoanh');

        if (error) {
            console.error("Error fetching sales reps:", error);
            return [];
        }

        return data as UserProfile[];
    },
    /**
     * Send Password Reset Email
     */
    resetPasswordForEmail: async (email: string) => {
        if (!supabase) throw new Error("Supabase client not initialized");
        const { error } = await supabase.auth.resetPasswordForEmail(email, {
            redirectTo: window.location.origin + '/reset-password',
        });
        if (error) throw error;
    },
};
