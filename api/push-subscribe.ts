import { createClient } from '@supabase/supabase-js';

const SUPABASE_URL = process.env.VITE_SUPABASE_URL || '';
const SUPABASE_SERVICE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY || '';

export default async function handler(req: any, res: any) {
  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method not allowed' });
  }

  try {
    const { subscription, userId, action } = req.body;

    if (!subscription || !userId) {
      return res.status(400).json({ error: 'Missing subscription or userId' });
    }

    const db = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY);

    if (action === 'unsubscribe') {
      // Xóa subscription khỏi DB
      const { error } = await db.from('push_subscriptions')
        .delete()
        .eq('user_id', userId)
        .eq('endpoint', subscription.endpoint);

      if (error) {
        console.error('DB error:', error);
        return res.status(500).json({ error: 'Failed to remove subscription' });
      }
      return res.status(200).json({ success: true, action: 'unsubscribed' });
    }

    // Upsert subscription (nếu đã có thì update)
    const { error } = await db.from('push_subscriptions').upsert({
      user_id: userId,
      endpoint: subscription.endpoint,
      keys_p256dh: subscription.keys.p256dh,
      keys_auth: subscription.keys.auth,
      user_agent: req.headers['user-agent'] || '',
    }, {
      onConflict: 'user_id,endpoint',
    });

    if (error) {
      console.error('DB error:', error);
      return res.status(500).json({ error: 'Failed to save subscription' });
    }

    return res.status(200).json({ success: true, action: 'subscribed' });
  } catch (err: any) {
    console.error('Error:', err);
    return res.status(500).json({ error: err.message });
  }
}
