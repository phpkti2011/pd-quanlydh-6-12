import { createClient } from '@supabase/supabase-js';

// Vercel Serverless Function - Gửi báo cáo hàng ngày qua Telegram
// Triggered by Vercel Cron 3 lần/ngày (Thứ 2 - Thứ 7, trừ chủ nhật):
//   12:10 VN (05:10 UTC) - 17:40 VN (10:40 UTC) - 20:00 VN (13:00 UTC)

const SUPABASE_URL = process.env.VITE_SUPABASE_URL || '';
const SUPABASE_SERVICE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY || '';
const TELEGRAM_BOT_TOKEN = process.env.TELEGRAM_BOT_TOKEN || '';
const TELEGRAM_CHAT_ID = process.env.TELEGRAM_CHAT_ID || '';
const CRON_SECRET = process.env.CRON_SECRET || '';

// Map status code sang tiếng Việt
function statusLabel(status: string): string {
  const map: Record<string, string> = {
    'Moi': 'Mới', 'TiepNhan': 'Tiếp nhận', 'NhanFile': 'Nhận File',
    'XuLyFile': 'Xử lý File', 'BinhFile': 'Bình File', 'In': 'In',
    'ThanhPham': 'Thành Phẩm', 'DongGoi': 'Đóng gói',
    'ChoGiaoHang': 'Chờ giao hàng', 'DaGiaoHang': 'Đã giao hàng',
    'HoanThanh': 'Hoàn thành', 'Huy': 'Hủy', 'TamNgung': 'Tạm ngưng',
  };
  return map[status] || status;
}

function formatMoney(amount: number): string {
  return new Intl.NumberFormat('vi-VN').format(amount) + 'đ';
}

function formatReport(data: any, debugMarker?: string): string {
  const d = data;
  const date = new Date(d.report_date).toLocaleDateString('vi-VN');

  let msg = `📊 *BÁO CÁO NGÀY ${date}*\n`;
  msg += `━━━━━━━━━━━━━━━━━━━\n\n`;

  // Tổng quan
  msg += `📋 *TỔNG QUAN ĐƠN HÀNG*\n`;
  msg += `• Đơn tạo mới: *${d.orders_created_today}*\n`;
  msg += `• Đơn hoàn thành: *${d.orders_completed_today}*\n`;
  msg += `• Đơn hủy: *${d.orders_cancelled_today}*\n`;
  msg += `• Đơn đang xử lý: *${d.pending_orders_count}*\n\n`;

  // Doanh thu
  msg += `💰 *DOANH THU*\n`;
  msg += `• Doanh thu đơn mới (chưa VAT): *${formatMoney(d.revenue_today_pre_vat || 0)}*\n`;
  msg += `• Doanh thu đơn mới (có VAT): *${formatMoney(d.revenue_today)}*\n`;
  msg += `• Doanh thu hoàn thành (chưa VAT): *${formatMoney(d.revenue_completed_today)}*\n`;
  msg += `• Doanh thu tháng (có VAT): *${formatMoney(d.revenue_month_total || 0)}*\n`;
  msg += `• Doanh thu tháng (chưa VAT): *${formatMoney(d.revenue_month_pre_vat || 0)}*\n\n`;

  // Thanh toán
  const ps = d.payment_stats;
  msg += `🏦 *THANH TOÁN*\n`;
  msg += `• Thu trong ngày: *${formatMoney(ps.total_collected)}*\n`;
  msg += `• Đơn chưa thanh toán: *${ps.unpaid_orders}*\n`;
  msg += `• Đơn công nợ: *${ps.debt_orders}*\n\n`;

  // Doanh số NVKD
  if (d.sales_by_employee && d.sales_by_employee.length > 0) {
    msg += `👥 *DOANH SỐ THEO NVKD*\n`;
    d.sales_by_employee.forEach((emp: any, i: number) => {
      const medal = i === 0 ? '🥇' : i === 1 ? '🥈' : i === 2 ? '🥉' : '•';
      msg += `${medal} ${emp.employee_name || 'N/A'}: *${formatMoney(emp.revenue)}* (${emp.orders_created} đơn, ${emp.orders_completed} HT)\n`;
    });
    msg += `\n`;
  }

  // Chuyển đổi trạng thái
  if (d.status_transitions_today && d.status_transitions_today.length > 0) {
    msg += `🔄 *CHUYỂN ĐỔI TRẠNG THÁI*\n`;
    d.status_transitions_today.forEach((t: any) => {
      msg += `• → ${statusLabel(t.to_status)}: *${t.count}* lượt\n`;
    });
    msg += `\n`;
  }

  // Hoạt động nhân viên
  if (d.employee_activity && d.employee_activity.length > 0) {
    msg += `📈 *HOẠT ĐỘNG NHÂN VIÊN*\n`;
    d.employee_activity.forEach((a: any) => {
      msg += `• ${a.employee_name}: ${a.total_actions} thao tác`;
      const details = [];
      if (a.orders_created > 0) details.push(`${a.orders_created} tạo đơn`);
      if (a.status_updates > 0) details.push(`${a.status_updates} cập nhật`);
      if (a.stage_actions > 0) details.push(`${a.stage_actions} công đoạn`);
      if (a.payment_updates > 0) details.push(`${a.payment_updates} thanh toán`);
      if (details.length > 0) msg += ` (${details.join(', ')})`;
      msg += `\n`;
    });
    msg += `\n`;
  }

  msg += `━━━━━━━━━━━━━━━━━━━\n`;
  msg += `🤖 _P&D Order Manager_`;
  if (debugMarker) {
    msg += `\n${debugMarker}`;
  }

  return msg;
}

async function sendTelegram(text: string): Promise<boolean> {
  const url = `https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage`;
  const res = await fetch(url, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      chat_id: TELEGRAM_CHAT_ID,
      text: text,
      parse_mode: 'Markdown',
    }),
  });

  if (!res.ok) {
    const err = await res.text();
    console.error('Telegram API error:', err);
    return false;
  }
  return true;
}

export default async function handler(req: any, res: any) {
  // Verify cron secret (bảo mật) — hỗ trợ header hoặc query param
  const authHeader = req.headers['authorization'];
  const queryKey = req.query?.key;
  const isAuthorized = !CRON_SECRET
    || authHeader === `Bearer ${CRON_SECRET}`
    || queryKey === CRON_SECRET;
  if (!isAuthorized) {
    return res.status(401).json({ error: 'Unauthorized' });
  }

  // Validate config
  if (!SUPABASE_URL || !SUPABASE_SERVICE_KEY) {
    return res.status(500).json({ error: 'Missing Supabase config' });
  }
  if (!TELEGRAM_BOT_TOKEN || !TELEGRAM_CHAT_ID) {
    return res.status(500).json({ error: 'Missing Telegram config' });
  }

  try {
    // Dùng service role key để bypass RLS
    const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY);

    // Gọi function báo cáo
    const { data, error } = await supabase.rpc('get_daily_report');

    if (error) {
      console.error('DB error:', error);
      return res.status(500).json({ error: 'Database error', details: error.message });
    }

    // Debug marker: ID ngẫu nhiên + thời gian UTC + nguồn gọi
    // Mục đích: phân biệt khi nhận trùng tin -> biết là 1 invocation gửi đôi hay 2 invocation
    const invId = Math.random().toString(36).slice(2, 8).toUpperCase();
    const utcNow = new Date().toISOString().replace('T', ' ').slice(0, 19);
    const isVercelCron = !!req.headers['x-vercel-cron'];
    const userAgent = (req.headers['user-agent'] || '').toString().slice(0, 40);
    const source = isVercelCron ? 'vercel-cron' : `other (UA: ${userAgent || 'none'})`;
    const debugMarker = `\`[${invId}] ${utcNow} UTC | ${source}\``;

    // Format và gửi Telegram
    const message = formatReport(data, debugMarker);
    const sent = await sendTelegram(message);

    if (!sent) {
      return res.status(500).json({ error: 'Failed to send Telegram message' });
    }

    return res.status(200).json({ success: true, message: 'Daily report sent' });
  } catch (err: any) {
    console.error('Error:', err);
    return res.status(500).json({ error: err.message });
  }
}
