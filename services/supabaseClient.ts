import { createClient, SupabaseClient } from '@supabase/supabase-js';
import { SUPABASE_URL, SUPABASE_ANON_KEY } from '../constants';

let supabase: SupabaseClient | null = null;

try {
    const supabaseUrl = SUPABASE_URL as string;
    if (supabaseUrl && supabaseUrl !== "YOUR_SUPABASE_URL" && supabaseUrl.startsWith("http")) {
        supabase = createClient(supabaseUrl, SUPABASE_ANON_KEY);
    } else {
        console.warn("Supabase is not configured properly. Falling back to Mock Data mode.");
    }
} catch (error) {
    console.error("Error initializing Supabase client:", error);
}

export { supabase };
