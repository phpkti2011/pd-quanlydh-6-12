import { useState, useEffect, useCallback, useRef } from 'react';
import { supabase } from '../services/supabaseClient';
import { notificationService } from '../services/notificationService';
import { AppNotification } from '../types';

// Phát âm thanh "ding" bằng Web Audio API (không cần file)
function playNotificationSound() {
  try {
    const AudioContext = window.AudioContext || (window as any).webkitAudioContext;
    if (!AudioContext) return;

    const ctx = new AudioContext();
    const osc = ctx.createOscillator();
    const gain = ctx.createGain();

    osc.connect(gain);
    gain.connect(ctx.destination);

    osc.frequency.value = 880;
    osc.type = 'sine';

    gain.gain.setValueAtTime(0.3, ctx.currentTime);
    gain.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + 0.2);

    osc.start(ctx.currentTime);
    osc.stop(ctx.currentTime + 0.2);
  } catch (e) {
    // Silent fail - browser may block audio
  }
}

// Hiển thị notification qua Service Worker (hoạt động cả khi minimize/background)
async function showBrowserNotification(notif: AppNotification) {
  if (!('Notification' in window)) return;
  if (Notification.permission !== 'granted') return;

  try {
    // Ưu tiên gửi qua Service Worker (hoạt động trên mobile + background)
    if ('serviceWorker' in navigator && navigator.serviceWorker.controller) {
      navigator.serviceWorker.controller.postMessage({
        type: 'SHOW_NOTIFICATION',
        title: notif.title,
        body: notif.message || '',
        icon: '/logo.png',
        tag: 'pd-notif-' + notif.id,
        url: '/',
        notifId: notif.id,
      });
      return;
    }

    // Fallback: dùng Notification API trực tiếp (chỉ hoạt động khi tab active)
    new Notification(notif.title, {
      body: notif.message || '',
      icon: '/logo.png',
      tag: notif.id,
    });
  } catch (e) {
    // Silent fail
  }
}

export function useNotifications(userId: string | null) {
  const [notifications, setNotifications] = useState<AppNotification[]>([]);
  const [unreadCount, setUnreadCount] = useState(0);
  const [isLoading, setIsLoading] = useState(true);
  const initializedRef = useRef(false);

  // Đăng ký Push Subscription khi mount
  useEffect(() => {
    if (!userId) return;

    async function setupPush() {
      // Hỏi quyền
      if ('Notification' in window && Notification.permission === 'default') {
        await Notification.requestPermission().catch(() => {});
      }
      if (!('Notification' in window) || Notification.permission !== 'granted') return;
      if (!('serviceWorker' in navigator)) return;

      try {
        const reg = await navigator.serviceWorker.ready;

        // Kiểm tra đã có subscription chưa
        let subscription = await reg.pushManager.getSubscription();

        if (!subscription) {
          // Đăng ký push subscription mới với VAPID public key
          const vapidKey = 'BCnSyN6U9wmWy5w0EunHniKgjy8K8c-OOnhqrSoW37oLyg4OOjF6qDS7mUvi6R3m2eD3Rli06grXWV0_z4YIcl8';
          // Convert VAPID key
          const urlBase64ToUint8Array = (base64String: string) => {
            const padding = '='.repeat((4 - base64String.length % 4) % 4);
            const base64 = (base64String + padding).replace(/-/g, '+').replace(/_/g, '/');
            const rawData = window.atob(base64);
            return Uint8Array.from([...rawData].map(c => c.charCodeAt(0)));
          };

          subscription = await reg.pushManager.subscribe({
            userVisibleOnly: true,
            applicationServerKey: urlBase64ToUint8Array(vapidKey),
          });
        }

        // Gửi subscription lên server để lưu
        await fetch('/api/push-subscribe', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            subscription: subscription.toJSON(),
            userId,
          }),
        });
        console.log('✅ Push subscription registered');
      } catch (e) {
        console.log('Push subscription failed:', e);
      }
    }

    setupPush();
  }, [userId]);

  // Fetch ban đầu
  const fetchNotifications = useCallback(async () => {
    if (!userId) return;
    setIsLoading(true);
    try {
      const [notifs, count] = await Promise.all([
        notificationService.getMyNotifications(50),
        notificationService.getUnreadCount(),
      ]);
      setNotifications(notifs);
      setUnreadCount(count);
    } catch (e) {
      console.error('Error fetching notifications:', e);
    } finally {
      setIsLoading(false);
    }
  }, [userId]);

  useEffect(() => {
    if (userId && !initializedRef.current) {
      initializedRef.current = true;
      fetchNotifications();
    }
  }, [userId, fetchNotifications]);

  // Realtime subscription
  useEffect(() => {
    if (!userId || !supabase) return;

    const channel = supabase
      .channel(`notifications:${userId}`)
      .on(
        'postgres_changes',
        {
          event: 'INSERT',
          schema: 'public',
          table: 'notifications',
          filter: `user_id=eq.${userId}`,
        },
        (payload) => {
          const newNotif = payload.new as AppNotification;
          setNotifications((prev) => [newNotif, ...prev].slice(0, 50));
          setUnreadCount((prev) => prev + 1);
          playNotificationSound();
          showBrowserNotification(newNotif);
        }
      )
      .subscribe();

    return () => {
      supabase.removeChannel(channel);
    };
  }, [userId]);

  // Mark as read
  const markAsRead = useCallback(async (id: string) => {
    await notificationService.markAsRead(id);
    setNotifications((prev) =>
      prev.map((n) => (n.id === id ? { ...n, is_read: true } : n))
    );
    setUnreadCount((prev) => Math.max(0, prev - 1));
  }, []);

  // Mark all as read
  const markAllAsRead = useCallback(async () => {
    await notificationService.markAllAsRead();
    setNotifications((prev) => prev.map((n) => ({ ...n, is_read: true })));
    setUnreadCount(0);
  }, []);

  return { notifications, unreadCount, markAsRead, markAllAsRead, isLoading, refetch: fetchNotifications };
}
