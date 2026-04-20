import { createClient } from '@supabase/supabase-js';
import webpush from 'web-push';

const SUPABASE_URL = process.env.VITE_SUPABASE_URL || '';
const SUPABASE_SERVICE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY || '';
const VAPID_PUBLIC_KEY = process.env.VAPID_PUBLIC_KEY || '';
const VAPID_PRIVATE_KEY = process.env.VAPID_PRIVATE_KEY || '';
const VAPID_EMAIL = process.env.VAPID_EMAIL || 'mailto:admin@pdprint.vn';

// Configure web-push
if (VAPID_PUBLIC_KEY && VAPID_PRIVATE_KEY) {
  webpush.setVapidDetails(VAPID_EMAIL, VAPID_PUBLIC_KEY, VAPID_PRIVATE_KEY);
}

export default async function handler(req: any, res: any) {
  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method not allowed' });
  }

  // Bảo mật: chỉ cho phép gọi từ internal (Supabase webhook hoặc có secret)
  const authHeader = req.headers['authorization'];
  const CRON_SECRET = process.env.CRON_SECRET || '';
  if (CRON_SECRET && authHeader !== `Bearer ${CRON_SECRET}`) {
    return res.status(401).json({ error: 'Unauthorized' });
  }

  try {
    const { userId, title, body, url, tag } = req.body;

    if (!userId || !title) {
      return res.status(400).json({ error: 'Missing userId or title' });
    }

    const db = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY);

    // Lấy tất cả subscriptions của user
    const { data: subs, error } = await db
      .from('push_subscriptions')
      .select('endpoint, keys_p256dh, keys_auth')
      .eq('user_id', userId);

    if (error || !subs?.length) {
      return res.status(200).json({ success: true, sent: 0, message: 'No subscriptions found' });
    }

    const payload = JSON.stringify({
      title,
      body: body || '',
      icon: '/logo.png',
      url: url || '/',
      tag: tag || 'pd-push-' + Date.now(),
    });

    let sent = 0;
    let failed = 0;
    const expiredEndpoints: string[] = [];

    for (const sub of subs) {
      const pushSubscription = {
        endpoint: sub.endpoint,
        keys: {
          p256dh: sub.keys_p256dh,
          auth: sub.keys_auth,
        },
      };

      try {
        await webpush.sendNotification(pushSubscription, payload);
        sent++;
      } catch (err: any) {
        // 410 Gone hoặc 404 = subscription expired, xóa khỏi DB
        if (err.statusCode === 410 || err.statusCode === 404) {
          expiredEndpoints.push(sub.endpoint);
        }
        failed++;
      }
    }

    // Cleanup expired subscriptions
    if (expiredEndpoints.length > 0) {
      await db.from('push_subscriptions')
        .delete()
        .in('endpoint', expiredEndpoints);
    }

    return res.status(200).json({
      success: true,
      sent,
      failed,
      cleaned: expiredEndpoints.length,
    });
  } catch (err: any) {
    console.error('Push error:', err);
    return res.status(500).json({ error: err.message });
  }
}
