import { supabase } from './supabaseClient';
import { AppNotification } from '../types';

export const notificationService = {

  async getMyNotifications(limit = 50): Promise<AppNotification[]> {
    if (!supabase) return [];
    const { data, error } = await supabase
      .from('notifications')
      .select('*')
      .order('created_at', { ascending: false })
      .limit(limit);

    if (error) {
      console.error('Error fetching notifications:', error);
      return [];
    }
    return (data || []) as AppNotification[];
  },

  async getUnreadCount(): Promise<number> {
    if (!supabase) return 0;
    const { count, error } = await supabase
      .from('notifications')
      .select('*', { count: 'exact', head: true })
      .eq('is_read', false);

    if (error) {
      console.error('Error fetching unread count:', error);
      return 0;
    }
    return count || 0;
  },

  async markAsRead(id: string): Promise<void> {
    if (!supabase) return;
    const { error } = await supabase
      .from('notifications')
      .update({ is_read: true })
      .eq('id', id);

    if (error) {
      console.error('Error marking notification as read:', error);
    }
  },

  async markAllAsRead(): Promise<void> {
    if (!supabase) return;
    const { error } = await supabase
      .from('notifications')
      .update({ is_read: true })
      .eq('is_read', false);

    if (error) {
      console.error('Error marking all as read:', error);
    }
  },

  async deleteNotification(id: string): Promise<void> {
    if (!supabase) return;
    const { error } = await supabase
      .from('notifications')
      .delete()
      .eq('id', id);

    if (error) {
      console.error('Error deleting notification:', error);
    }
  }
};
