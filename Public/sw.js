// Service Worker cho P&D Order Manager - Push Notifications

const CACHE_NAME = 'pd-orders-v1';

// Install - cache basic assets
self.addEventListener('install', (event) => {
  self.skipWaiting();
});

// Activate - cleanup old caches
self.addEventListener('activate', (event) => {
  event.waitUntil(clients.claim());
});

// Handle push notifications từ server
self.addEventListener('push', (event) => {
  let data = { title: 'P&D Order Manager', body: 'Bạn có thông báo mới', icon: '/logo.png' };

  if (event.data) {
    try {
      data = { ...data, ...event.data.json() };
    } catch (e) {
      data.body = event.data.text();
    }
  }

  // Kiểm tra nếu app đang mở thì không hiện push (realtime đã xử lý)
  event.waitUntil(
    clients.matchAll({ type: 'window', includeUncontrolled: true }).then((clientList) => {
      const hasActiveClient = clientList.some((c) => c.visibilityState === 'visible');
      if (hasActiveClient) {
        // App đang mở, realtime subscription đã hiện notification rồi
        return;
      }

      return self.registration.showNotification(data.title, {
        body: data.body,
        icon: data.icon || '/logo.png',
        badge: '/logo.png',
        vibrate: [200, 100, 200],
        tag: data.tag || 'pd-notification',
        renotify: true,
        requireInteraction: false,
        data: {
          url: data.url || '/',
          notifId: data.notifId,
        },
        actions: [
          { action: 'open', title: 'Mở app' },
          { action: 'dismiss', title: 'Bỏ qua' },
        ],
      });
    })
  );
});

// Handle notification click
self.addEventListener('notificationclick', (event) => {
  event.notification.close();

  if (event.action === 'dismiss') return;

  // Trích mã đơn hàng từ body (vd: "26PD2703.0549")
  const body = event.notification.body || '';
  const match = body.match(/\d{2}PD\d{4}\.\d{4}/);
  const orderCode = match ? match[0] : '';
  const targetUrl = orderCode ? '/?search=' + encodeURIComponent(orderCode) : '/';

  event.waitUntil(
    clients.matchAll({ type: 'window', includeUncontrolled: true }).then((clientList) => {
      // Nếu app đang mở, gửi message để search + focus
      for (const client of clientList) {
        if (client.url.includes(self.location.origin) && 'focus' in client) {
          if (orderCode) {
            client.postMessage({ type: 'SEARCH_ORDER', orderCode });
          }
          return client.focus();
        }
      }
      // Nếu chưa mở, mở tab mới với search param
      return clients.openWindow(targetUrl);
    })
  );
});

// Listen for messages from the app (để show notification từ realtime subscription)
self.addEventListener('message', (event) => {
  if (event.data && event.data.type === 'SHOW_NOTIFICATION') {
    const { title, body, icon, tag, url, notifId } = event.data;
    self.registration.showNotification(title || 'P&D Order Manager', {
      body: body || '',
      icon: icon || '/logo.png',
      badge: '/logo.png',
      vibrate: [200, 100, 200],
      tag: tag || 'pd-notification-' + Date.now(),
      renotify: true,
      data: { url: url || '/', notifId },
      actions: [
        { action: 'open', title: 'Mở app' },
        { action: 'dismiss', title: 'Bỏ qua' },
      ],
    });
  }
});
