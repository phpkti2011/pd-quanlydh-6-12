import React, { useState, useRef, useEffect, useMemo } from 'react';
import { useNotifications } from '../hooks/useNotifications';
import { commissionService } from '../services/commissionService';
import { AppNotification, ProductionTierSummary } from '../types';

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
  const [showCommissionModal, setShowCommissionModal] = useState(false);
  const [commissionSummary, setCommissionSummary] = useState<ProductionTierSummary | null>(null);
  const [loadingSummary, setLoadingSummary] = useState(false);
  const dropdownRef = useRef<HTMLDivElement>(null);

  // Separate pinned (system) and regular notifications
  const { pinnedNotifs, regularNotifs } = useMemo(() => {
    const pinned: AppNotification[] = [];
    const regular: AppNotification[] = [];
    // Only pin the latest system notification (commission update)
    let foundPin = false;
    for (const n of notifications) {
      if (!foundPin && n.type === 'system' && n.title?.includes('Hoa Hồng')) {
        pinned.push(n);
        foundPin = true;
      } else {
        regular.push(n);
      }
    }
    return { pinnedNotifs: pinned, regularNotifs: regular };
  }, [notifications]);

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
    // System notification (commission) → open commission modal
    if (notif.type === 'system' && notif.title?.includes('Hoa Hồng')) {
      setLoadingSummary(true);
      setShowCommissionModal(true);
      setIsOpen(false);
      try {
        const now = new Date();
        const summary = await commissionService.getProductionCommissionSummary(now.getMonth() + 1, now.getFullYear());
        setCommissionSummary(summary);
      } catch (err) {
        console.error('Load commission summary error:', err);
      }
      setLoadingSummary(false);
      return;
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
              <>
              {/* Pinned: Commission notification */}
              {pinnedNotifs.map((notif) => (
                <div
                  key={notif.id}
                  onClick={() => handleNotifClick(notif)}
                  className="flex items-start gap-3 px-4 py-3 border-b-2 border-red-200 cursor-pointer transition-colors bg-red-50 hover:bg-red-100 sticky top-0 z-10"
                >
                  <div className="mt-0.5 w-8 h-8 rounded-full flex items-center justify-center flex-shrink-0 bg-red-100">
                    <i className="fa-solid fa-chart-line text-xs text-red-600"></i>
                  </div>
                  <div className="flex-1 min-w-0">
                    <div className="flex items-start justify-between gap-2">
                      <p className="text-sm leading-tight font-semibold text-red-700">
                        <i className="fa-solid fa-thumbtack mr-1 text-[10px]"></i>
                        {notif.title}
                      </p>
                      {!notif.is_read && (
                        <span className="w-2 h-2 bg-red-500 rounded-full flex-shrink-0 mt-1.5"></span>
                      )}
                    </div>
                    <p className="text-xs text-red-600 mt-0.5 line-clamp-3">
                      {notif.message}
                    </p>
                    <p className="text-[11px] text-red-400 mt-1">
                      {timeAgo(notif.created_at)} · <span className="underline">Xem chi tiết</span>
                    </p>
                  </div>
                </div>
              ))}

              {/* Regular notifications */}
              {regularNotifs.map((notif) => {
                const { icon, color } = getNotifIcon(notif.type);
                return (
                  <div
                    key={notif.id}
                    onClick={() => handleNotifClick(notif)}
                    className={`flex items-start gap-3 px-4 py-3 border-b border-gray-50 cursor-pointer transition-colors hover:bg-gray-50 ${
                      !notif.is_read ? 'bg-teal-50/40' : ''
                    }`}
                  >
                    <div className={`mt-0.5 w-8 h-8 rounded-full flex items-center justify-center flex-shrink-0 ${
                      !notif.is_read ? 'bg-teal-100' : 'bg-gray-100'
                    }`}>
                      <i className={`fa-solid ${icon} text-xs ${!notif.is_read ? 'text-teal-600' : color}`}></i>
                    </div>
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
              })}
              </>
            )}
          </div>
        </div>
      )}
      {/* Commission Detail Modal */}
      {showCommissionModal && (
        <div className="fixed inset-0 z-[9999] flex items-center justify-center bg-black bg-opacity-50" onClick={() => setShowCommissionModal(false)}>
          <div className="bg-white rounded-lg shadow-2xl w-full max-w-lg mx-4 overflow-hidden" onClick={e => e.stopPropagation()}>
            <div className="bg-gradient-to-r from-red-600 to-orange-500 text-white px-6 py-4 flex justify-between items-center">
              <div>
                <h3 className="text-lg font-bold">Hoa Hồng Sản Xuất</h3>
                <p className="text-sm text-red-100">Tháng {new Date().getMonth() + 1}/{new Date().getFullYear()}</p>
              </div>
              <button onClick={() => setShowCommissionModal(false)} className="text-white/80 hover:text-white">
                <i className="fa-solid fa-xmark text-xl"></i>
              </button>
            </div>

            <div className="p-6">
              {loadingSummary ? (
                <div className="text-center py-8 text-gray-400">
                  <i className="fa-solid fa-spinner fa-spin text-2xl mb-2"></i>
                  <p>Đang tải...</p>
                </div>
              ) : commissionSummary ? (
                <>
                  {/* Current Revenue */}
                  <div className="text-center mb-6">
                    <p className="text-sm text-gray-500 mb-1">Doanh số đơn hoàn thành trong tháng</p>
                    <p className="text-3xl font-bold text-gray-800">
                      {(commissionSummary.total_revenue / 1000000).toFixed(0)} triệu
                    </p>
                    <p className="text-xs text-gray-400">(chưa VAT)</p>
                  </div>

                  {/* Current Tier */}
                  <div className={`text-center rounded-lg p-4 mb-6 ${
                    commissionSummary.current_tier_pct >= 150 ? 'bg-green-50 text-green-700' :
                    commissionSummary.current_tier_pct >= 100 ? 'bg-blue-50 text-blue-700' :
                    commissionSummary.current_tier_pct >= 70 ? 'bg-orange-50 text-orange-700' :
                    'bg-red-50 text-red-700'
                  }`}>
                    <p className="text-sm font-medium mb-1">Mốc thưởng hiện tại</p>
                    <p className="text-4xl font-bold">×{commissionSummary.current_tier_pct}%</p>
                    {commissionSummary.current_tier_pct === 0 && <p className="text-xs mt-1">Chưa đạt mốc thưởng</p>}
                  </div>

                  {/* Next Tier */}
                  {commissionSummary.next_tier_threshold && (
                    <div className="bg-amber-50 border border-amber-200 rounded-lg p-3 mb-6 text-sm text-amber-800">
                      <i className="fa-solid fa-arrow-up mr-1"></i>
                      Mốc tiếp theo: <strong>{(commissionSummary.next_tier_threshold / 1000000).toFixed(0)} triệu</strong> → <strong>{commissionSummary.next_tier_pct}%</strong>
                      <span className="ml-1">(còn thiếu {((commissionSummary.next_tier_threshold - commissionSummary.total_revenue) / 1000000).toFixed(0)} triệu)</span>
                    </div>
                  )}

                  {/* All Tiers Table */}
                  {commissionSummary.all_tiers && commissionSummary.all_tiers.length > 0 && (
                    <div>
                      <h4 className="font-bold text-gray-700 mb-2 text-sm">Bảng mốc thưởng hoa hồng sản xuất</h4>
                      <table className="w-full text-sm border rounded-lg overflow-hidden">
                        <thead className="bg-gray-100">
                          <tr>
                            <th className="px-3 py-2 text-left text-gray-600">Doanh số (chưa VAT)</th>
                            <th className="px-3 py-2 text-center text-gray-600">Hệ số thưởng</th>
                          </tr>
                        </thead>
                        <tbody className="divide-y">
                          <tr className={commissionSummary.current_tier_pct === 0 ? 'bg-red-50 font-bold' : ''}>
                            <td className="px-3 py-2">Dưới {(Math.min(...commissionSummary.all_tiers.map((t: any) => t.min)) / 1000000).toFixed(0)} triệu</td>
                            <td className="px-3 py-2 text-center text-red-600">0%</td>
                          </tr>
                          {commissionSummary.all_tiers.map((tier: any, idx: number) => {
                            const isActive = commissionSummary.total_revenue >= tier.min && (tier.max === null || commissionSummary.total_revenue < tier.max);
                            const maxLabel = tier.max ? `${(tier.max / 1000000).toFixed(0)} triệu` : '∞';
                            return (
                              <tr key={idx} className={isActive ? 'bg-orange-50 font-bold' : ''}>
                                <td className="px-3 py-2">
                                  {(tier.min / 1000000).toFixed(0)} - {maxLabel}
                                  {isActive && <span className="ml-2 text-xs bg-orange-200 text-orange-800 px-1.5 py-0.5 rounded">hiện tại</span>}
                                </td>
                                <td className="px-3 py-2 text-center font-bold" style={{ color: tier.rate >= 150 ? '#15803d' : tier.rate >= 100 ? '#1d4ed8' : '#c2410c' }}>
                                  {tier.rate}%
                                </td>
                              </tr>
                            );
                          })}
                        </tbody>
                      </table>
                    </div>
                  )}

                  {/* Formula */}
                  <div className="mt-4 bg-gray-50 rounded-lg p-3 text-xs text-gray-600">
                    <p className="font-bold text-gray-700 mb-1">Công thức tính thưởng:</p>
                    <p className="font-mono">Thưởng thực nhận = (Thưởng CV chính + CV phụ) × {commissionSummary.current_tier_pct}%</p>
                  </div>
                </>
              ) : (
                <p className="text-center py-8 text-gray-400">Không có dữ liệu</p>
              )}
            </div>
          </div>
        </div>
      )}
    </div>
  );
};
