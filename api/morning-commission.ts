import { createClient } from '@supabase/supabase-js';

// Vercel Serverless Function - Thông báo mốc thưởng hoa hồng sản xuất mỗi sáng
// Triggered by Vercel Cron at 7:00 AM Vietnam (0:00 UTC), Mon-Sat
//
// Nội dung tin nhắn và danh sách người nhận nằm TRONG SQL
// (build_production_revenue_message + notify_production_revenue,
//  xem setup_production_revenue_notify.sql).
//
// ĐỪNG dựng lại nội dung ở đây. Trước đây file này có hàm
// buildNotificationMessage riêng, trong khi trigger "vượt mốc" cần đúng nội dung
// đó -> hai bản song song sẽ lệch nhau, đúng loại lỗi đã phải đi vá nhiều lần.

const SUPABASE_URL = process.env.VITE_SUPABASE_URL || '';
const SUPABASE_SERVICE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY || '';
const CRON_SECRET = process.env.CRON_SECRET || '';

export default async function handler(req: any, res: any) {
  // Verify cron secret
  const authHeader = req.headers['authorization'];
  const queryKey = req.query?.key;
  const isAuthorized = !CRON_SECRET
    || authHeader === `Bearer ${CRON_SECRET}`
    || queryKey === CRON_SECRET;
  if (!isAuthorized) {
    return res.status(401).json({ error: 'Unauthorized' });
  }

  if (!SUPABASE_URL || !SUPABASE_SERVICE_KEY) {
    return res.status(500).json({ error: 'Missing Supabase config' });
  }

  try {
    const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY);

    const now = new Date();
    // Convert to Vietnam timezone (UTC+7)
    const vnNow = new Date(now.getTime() + 7 * 60 * 60 * 1000);
    const month = vnNow.getMonth() + 1;
    const year = vnNow.getFullYear();

    // p_require_admin = false: cron chạy bằng service key, không có auth.uid()
    const { data: sentCount, error: notifyError } = await supabase.rpc('notify_production_revenue', {
      p_month: month,
      p_year: year,
      p_headline: null,
      p_require_admin: false
    });

    if (notifyError) {
      console.error('Notify error:', notifyError);
      return res.status(500).json({ error: 'Failed to send notifications', details: notifyError.message });
    }

    return res.status(200).json({
      success: true,
      message: `Sent morning commission notifications to ${sentCount ?? 0} employees`,
      month,
      year
    });
  } catch (err: any) {
    console.error('Error:', err);
    return res.status(500).json({ error: err.message });
  }
}
