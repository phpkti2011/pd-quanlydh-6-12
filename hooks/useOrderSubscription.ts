import { useEffect } from 'react';
import { supabase } from '../services/supabaseClient';

interface UseOrderSubscriptionProps {
    onNewOrder: () => void;
}

export const useOrderSubscription = ({ onNewOrder }: UseOrderSubscriptionProps) => {
    useEffect(() => {
        if (!supabase) return;

        const channel = supabase
            .channel('public:orders')
            .on(
                'postgres_changes',
                {
                    event: '*',
                    schema: 'public',
                    table: 'orders',
                },
                () => {
                    onNewOrder();
                }
            )
            .subscribe();

        return () => {
            supabase.removeChannel(channel);
        };
    }, [onNewOrder]);
};
