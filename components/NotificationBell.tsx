import React, { useState, useRef, useEffect } from 'react';
import { useNotifications } from '../hooks/useNotifications';
import { AppNotification } from '../types';

// Thời gian tương đối (tiếng Việt)
function timeAgo(dateString: string): string {
  const now = new Date();
  const date = new Date(dateString);
  const seconds = Math.floor((now.getTime() - date.getTime()) / 1000);

  if (seconds < 60) return 'Vừa xong';
  const minutes = Math.floor(seconds / 60);
  if (minutes < 60) return `${minutes} phút trước`;
  const hours = Math.floor(minutes / 60);
  if (hours < 24) return `${hours} giờ trước`;
  const days = Math.floor(hours / 24);
  if (days < 30) return `${days} ngày trước`;
  const months = Math.floor(days / 30);
  return `${months} tháng trước`;
}

// Icon theo loại thông báo
function getNotifIcon(type: string): { icon: string; color: string } {
  switch (type) {
    case 'order': return { icon: 'fa-box', color: 'text-blue-500' };
    case 'payment': return { icon: 'fa-credit-card', color: 'text-green-500' };
    case 'comment': return { icon: 'fa-comment', color: 'text-purple-500' };
    default: return { icon: 'fa-bell', color: 'text-gray-500' };
  }
}

interface NotificationBellProps {
  userId: string;
  onOpenOrder?: (orderId: string) => void;
}

export const NotificationBell: React.FC<NotificationBellProps> = ({ userId, onOpenOrder }) => {
  const { notifications, unreadCount, markAsRead, markAllAsRead, isLoading } = useNotifications(userId);
  const [isOpen, setIsOpen] = useState(false);
  const [pushEnabled, setPushEnabled] = useState(false);
  const dropdownRef = useRef<HTMLDivElement>(null);

  // Kiểm tra trạng thái push subscription thực tế
  useEffect(() => {
    async function checkPush() {
      if (!('serviceWorker' in navigator) || !('PushManager' in window)) return;
      try {
        const reg = await navigator.serviceWorker.ready;
        const sub = await reg.pushManager.getSubscription();
        setPushEnabled(!!sub && Notification.permission === 'granted');
      } catch { setPushEnabled(false); }
    }
    checkPush();
  }, []);

  // Close khi click bên ngoài
  useEffect(() => {
    function handleClickOutside(e: MouseEvent) {
      if (dropdownRef.current && !dropdownRef.current.contains(e.target as Node)) {
        setIsOpen(false);
      }
    }
    if (isOpen) {
      document.addEventListener('mousedown', handleClickOutside);
      return () => document.removeEventListener('mousedown', handleClickOutside);
    }
  }, [isOpen]);

  const handleNotifClick = async (notif: AppNotification) => {
    if (!notif.is_read) {
      await markAsRead(notif.id);
    }
    // Trích mã đơn hàng từ message (vd: "26PD2703.0549")
    if (onOpenOrder) {
      const match = notif.message?.match(/\d{2}PD\d{4}\.\d{4}/);
      if (match) {
        onOpenOrder(match[0]);
        setIsOpen(false);
      }
    }
  };

  return (
    <div className="relative" ref={dropdownRef}>
      {/* Bell Button */}
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="w-8 h-8 rounded hover:bg-teal-50 text-gray-500 hover:text-teal-600 transition-colors flex items-center justify-center relative"
        title="Thông báo"
      >
        <i className={`fa-solid fa-bell ${unreadCount > 0 ? 'text-teal-600' : ''}`}></i>
        {unreadCount > 0 && (
          <span className="absolute -top-1 -right-1 bg-red-500 text-white text-[10px] font-bold rounded-full min-w-[18px] h-[18px] flex items-center justify-center px-1 shadow-sm">
            {unreadCount > 99 ? '99+' : unreadCount}
          </span>
        )}
      </button>

      {/* Dropdown Panel */}
      {isOpen && (
        <div className="fixed sm:absolute right-4 sm:right-auto sm:left-0 top-16 sm:top-10 w-[calc(100vw-2rem)] sm:w-96 bg-white rounded-lg shadow-2xl border border-gray-200 z-[9999] overflow-hidden">
          {/* Header */}
          <div className="flex items-center justify-between px-4 py-3 border-b border-gray-100 bg-gray-50">
            <h3 className="font-semibold text-gray-800 text-sm">
              <i className="fa-solid fa-bell mr-1.5 text-teal-600"></i>
              Thông báo
              {unreadCount > 0 && (
                <span className="ml-2 bg-red-100 text-red-600 text-xs px-2 py-0.5 rounded-full font-medium">
                  {unreadCount} mới
                </span>
              )}
            </h3>
            {unreadCount > 0 && (
              <button
                onClick={markAllAsRead}
                className="text-xs text-teal-600 hover:text-teal-800 font-medium hover:underline"
              >
                Đọc tất cả
              </button>
            )}
          </div>

          {/* Push Toggle */}
          <div className="flex items-center justify-between px-4 py-2.5 border-b border-gray-100 bg-gray-50/50">
            <div className="flex items-center gap-2">
              <i className={`fa-solid fa-mobile-screen-button text-sm ${pushEnabled ? 'text-teal-600' : 'text-gray-400'}`}></i>
              <span className="text-xs text-gray-600">Thông báo đẩy</span>
              {'Notification' in window && Notification.permission === 'denied' && (
                <span className="text-[10px] text-red-500">(Đã chặn)</span>
              )}
            </div>
            <button
              onClick={async (e) => {
                e.stopPropagation();
                if (!('Notification' in window) || !('serviceWorker' in navigator)) {
                  alert('Trình duyệt không hỗ trợ thông báo đẩy.');
                  return;
                }
                if (Notification.permission === 'denied') {
                  alert('Thông báo đã bị chặn.\n\nĐể bật lại:\n• Chrome: Nhấn icon khóa trên thanh địa chỉ > Notifications > Allow\n• Safari: Settings > Notifications > Cho phép');
                  return;
                }

                if (pushEnabled) {
                  // === TẮT: UI chuyển ngay ===
                  setPushEnabled(false);
                  const reg = await navigator.serviceWorker.ready;
                  const sub = await reg.pushManager.getSubscription();
                  if (sub) {
                    sub.unsubscribe();
                    fetch('/api/push-subscribe', {
                      method: 'POST',
                      headers: { 'Content-Type': 'application/json' },
                      body: JSON.stringify({ subscription: sub.toJSON(), userId, action: 'unsubscribe' }),
                    }).catch(() => {});
                  }
                } else {
                  // === BẬT ===
                  if (Notification.permission === 'default') {
                    const result = await Notification.requestPermission();
                    if (result !== 'granted') return;
                  }
                  // UI chuyển ngay
                  setPushEnabled(true);

                  const vapidKey = 'BCnSyN6U9wmWy5w0EunHniKgjy8K8c-OOnhqrSoW37oLyg4OOjF6qDS7mUvi6R3m2eD3Rli06grXWV0_z4YIcl8';
                  const urlBase64ToUint8Array = (base64String: string) => {
                    const padding = '='.repeat((4 - base64String.length % 4) % 4);
                    const base64 = (base64String + padding).replace(/-/g, '+').replace(/_/g, '/');
                    const rawData = window.atob(base64);
                    return Uint8Array.from([...rawData].map(c => c.charCodeAt(0)));
                  };

                  try {
                    const reg = await navigator.serviceWorker.ready;
                    let subscription = await reg.pushManager.getSubscription();
                    if (!subscription) {
                      subscription = await reg.pushManager.subscribe({
                        userVisibleOnly: true,
                        applicationServerKey: urlBase64ToUint8Array(vapidKey),
                      });
                    }
                    fetch('/api/push-subscribe', {
                      method: 'POST',
                      headers: { 'Content-Type': 'application/json' },
                      body: JSON.stringify({ subscription: subscription.toJSON(), userId }),
                    }).catch(() => {});
                  } catch {
                    setPushEnabled(false);
                  }
                }
              }}
              className={`relative w-11 h-6 rounded-full transition-colors duration-200 focus:outline-none ${
                pushEnabled ? 'bg-teal-500' : 'bg-gray-300'
              }`}
              title={pushEnabled ? 'Nhấn để tắt' : 'Nhấn để bật'}
            >
              <span className={`absolute top-0.5 left-0.5 w-5 h-5 bg-white rounded-full shadow transition-transform duration-200 flex items-center justify-center ${
                pushEnabled ? 'translate-x-5' : ''
              }`}>
                <i className={`fa-solid text-[8px] ${
                  pushEnabled ? 'fa-check text-teal-600' : 'fa-bell text-gray-400'
                }`}></i>
              </span>
            </button>
          </div>

          {/* Notification List */}
          <div className="max-h-[400px] overflow-y-auto">
            {isLoading ? (
              <div className="flex items-center justify-center py-8 text-gray-400">
                <i className="fa-solid fa-circle-notch fa-spin mr-2"></i>
                Đang tải...
              </div>
            ) : notifications.length === 0 ? (
              <div className="flex flex-col items-center justify-center py-10 text-gray-400">
                <i className="fa-solid fa-bell-slash text-3xl mb-2"></i>
                <span className="text-sm">Không có thông báo</span>
              </div>
            ) : (
              notifications.map((notif) => {
                const { icon, color } = getNotifIcon(notif.type);
                return (
                  <div
                    key={notif.id}
                    onClick={() => handleNotifClick(notif)}
                    className={`flex items-start gap-3 px-4 py-3 border-b border-gray-50 cursor-pointer transition-colors hover:bg-gray-50 ${
                      !notif.is_read ? 'bg-teal-50/40' : ''
                    }`}
                  >
                    {/* Icon */}
                    <div className={`mt-0.5 w-8 h-8 rounded-full flex items-center justify-center flex-shrink-0 ${
                      !notif.is_read ? 'bg-teal-100' : 'bg-gray-100'
                    }`}>
                      <i className={`fa-solid ${icon} text-xs ${!notif.is_read ? 'text-teal-600' : color}`}></i>
                    </div>

                    {/* Content */}
                    <div className="flex-1 min-w-0">
                      <div className="flex items-start justify-between gap-2">
                        <p className={`text-sm leading-tight ${!notif.is_read ? 'font-semibold text-gray-900' : 'text-gray-700'}`}>
                          {notif.title}
                        </p>
                        {!notif.is_read && (
                          <span className="w-2 h-2 bg-teal-500 rounded-full flex-shrink-0 mt-1.5"></span>
                        )}
                      </div>
                      <p className="text-xs text-gray-500 mt-0.5 line-clamp-2">
                        {notif.message}
                      </p>
                      <p className="text-[11px] text-gray-400 mt-1">
                        {timeAgo(notif.created_at)}
                      </p>
                    </div>
                  </div>
                );
              })
            )}
          </div>
        </div>
      )}
    </div>
  );
};
