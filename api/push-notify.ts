import { createClient } from '@supabase/supabase-js';
import webpush from 'web-push';

// API này được gọi bởi Supabase Database Webhook khi có notification INSERT mới
// Hoặc gọi thủ công từ app khi cần push cho 1 user

const SUPABASE_URL = process.env.VITE_SUPABASE_URL || '';
const SUPABASE_SERVICE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY || '';
const VAPID_PUBLIC_KEY = process.env.VAPID_PUBLIC_KEY || '';
const VAPID_PRIVATE_KEY = process.env.VAPID_PRIVATE_KEY || '';
const CRON_SECRET = process.env.CRON_SECRET || '';

if (VAPID_PUBLIC_KEY && VAPID_PRIVATE_KEY) {
  webpush.setVapidDetails('mailto:admin@pdprint.vn', VAPID_PUBLIC_KEY, VAPID_PRIVATE_KEY);
}

export default async function handler(req: any, res: any) {
  if (req.method !== 'POST') return res.status(405).json({ error: 'Method not allowed' });

  // Bảo mật
  const authHeader = req.headers['authorization'];
  const queryKey = req.query?.key;
  const isAuthorized = !CRON_SECRET
    || authHeader === `Bearer ${CRON_SECRET}`
    || queryKey === CRON_SECRET;
  if (!isAuthorized) return res.status(401).json({ error: 'Unauthorized' });

  try {
    const body = req.body;

    // Supabase webhook gửi record trong body.record (INSERT event)
    // Hoặc gọi trực tiếp với { userId, title, body }
    let userId: string, title: string, message: string;

    if (body.record) {
      // Từ Supabase Database Webhook
      userId = body.record.user_id;
      title = body.record.title;
      message = body.record.message || '';
    } else {
      userId = body.userId;
      title = body.title;
      message = body.body || body.message || '';
    }

    if (!userId || !title) {
      return res.status(400).json({ error: 'Missing userId or title' });
    }

    const db = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY);

    // Lấy push subscriptions của user
    const { data: subs } = await db
      .from('push_subscriptions')
      .select('endpoint, keys_p256dh, keys_auth')
      .eq('user_id', userId);

    if (!subs?.length) {
      return res.status(200).json({ success: true, sent: 0 });
    }

    const payload = JSON.stringify({
      title,
      body: message,
      icon: '/logo.png',
      tag: 'pd-push-' + Date.now(),
      url: '/',
    });

    let sent = 0;
    const expired: string[] = [];

    for (const sub of subs) {
      try {
        await webpush.sendNotification(
          { endpoint: sub.endpoint, keys: { p256dh: sub.keys_p256dh, auth: sub.keys_auth } },
          payload
        );
        sent++;
      } catch (err: any) {
        if (err.statusCode === 410 || err.statusCode === 404) {
          expired.push(sub.endpoint);
        }
      }
    }

    // Cleanup
    if (expired.length > 0) {
      await db.from('push_subscriptions').delete().in('endpoint', expired);
    }

    return res.status(200).json({ success: true, sent });
  } catch (err: any) {
    console.error('Push notify error:', err);
    return res.status(500).json({ error: err.message });
  }
}
