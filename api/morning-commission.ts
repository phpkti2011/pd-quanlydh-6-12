import { createClient } from '@supabase/supabase-js';

// Vercel Serverless Function - Thông báo mốc thưởng hoa hồng sản xuất mỗi sáng
// Triggered by Vercel Cron at 7:00 AM Vietnam (0:00 UTC), Mon-Sat

const SUPABASE_URL = process.env.VITE_SUPABASE_URL || '';
const SUPABASE_SERVICE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY || '';
const CRON_SECRET = process.env.CRON_SECRET || '';

function formatMoney(amount: number): string {
  if (amount >= 1000000) return (amount / 1000000).toFixed(0) + ' triệu';
  return new Intl.NumberFormat('vi-VN').format(amount) + 'đ';
}

function buildNotificationMessage(summary: any, month: number, year: number): string {
  const { total_revenue, current_tier_pct, next_tier_threshold, next_tier_pct, all_tiers } = summary;

  let msg = `Doanh số đơn hoàn thành trong tháng ${month}/${year}: ${formatMoney(total_revenue)} (chưa VAT).`;
  msg += `\n\nMốc thưởng hiện tại: ${current_tier_pct}% hoa hồng sản xuất.`;

  if (current_tier_pct === 0) {
    msg += ` (Chưa đạt mốc thưởng)`;
  }

  if (next_tier_threshold && next_tier_pct) {
    msg += `\nMốc tiếp theo: ${formatMoney(next_tier_threshold)} → ${next_tier_pct}%`;
    const remaining = next_tier_threshold - total_revenue;
    if (remaining > 0) {
      msg += ` (còn thiếu ${formatMoney(remaining)})`;
    }
  }

  // Show all tiers
  if (all_tiers && all_tiers.length > 0) {
    msg += `\n\nCác mốc thưởng hoa hồng sản xuất:`;
    // Below minimum threshold = 0%
    const minThreshold = Math.min(...all_tiers.map((t: any) => t.min));
    msg += `\n• Dưới ${formatMoney(minThreshold)}: 0%`;
    for (const tier of all_tiers) {
      const maxLabel = tier.max ? formatMoney(tier.max) : 'trở lên';
      const rangeLabel = tier.max
        ? `${formatMoney(tier.min)} - ${maxLabel}`
        : `${formatMoney(tier.min)} ${maxLabel}`;
      const marker = total_revenue >= tier.min && (tier.max === null || total_revenue < tier.max) ? ' ← hiện tại' : '';
      msg += `\n• ${rangeLabel}: ${tier.rate}%${marker}`;
    }
  }

  msg += `\n\nCông thức: Thưởng thực nhận = (Thưởng CV chính + CV phụ) × ${current_tier_pct}%`;

  return msg;
}

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

    // Get production commission summary
    const { data: summaryData, error: summaryError } = await supabase.rpc('get_production_commission_summary', {
      p_month: month,
      p_year: year
    });

    if (summaryError) {
      console.error('Summary error:', summaryError);
      return res.status(500).json({ error: 'Failed to get commission summary', details: summaryError.message });
    }

    const summary = summaryData?.[0];
    if (!summary) {
      return res.status(200).json({ success: true, message: 'No summary data available' });
    }

    // Get production staff only
    const { data: profiles, error: profilesError } = await supabase
      .from('profiles')
      .select('id, full_name, role')
      .in('role', ['Admin', 'NhanVienSanXuat', 'QuanLySanXuat', 'NhanVienBinhFile', 'NhanVienThietKe']);

    if (profilesError) {
      console.error('Profiles error:', profilesError);
      return res.status(500).json({ error: 'Failed to get profiles', details: profilesError.message });
    }

    if (!profiles || profiles.length === 0) {
      return res.status(200).json({ success: true, message: 'No eligible employees found' });
    }

    // Build notification message
    const message = buildNotificationMessage(summary, month, year);

    // Insert notifications for each employee
    const notifications = profiles.map((p: any) => ({
      user_id: p.id,
      title: 'Cập nhật Hoa Hồng Sản Xuất',
      message: message,
      type: 'system',
      is_read: false
    }));

    const { error: insertError } = await supabase
      .from('notifications')
      .insert(notifications);

    if (insertError) {
      console.error('Insert notifications error:', insertError);
      return res.status(500).json({ error: 'Failed to insert notifications', details: insertError.message });
    }

    return res.status(200).json({
      success: true,
      message: `Sent morning commission notifications to ${profiles.length} employees`,
      summary: {
        month,
        year,
        revenue: summary.total_revenue,
        tier_pct: summary.current_tier_pct
      }
    });
  } catch (err: any) {
    console.error('Error:', err);
    return res.status(500).json({ error: err.message });
  }
}
