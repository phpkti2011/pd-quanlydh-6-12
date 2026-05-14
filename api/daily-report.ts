import { createClient } from '@supabase/supabase-js';

// Vercel Serverless Function - Gửi báo cáo hàng ngày qua Telegram
// Triggered by Vercel Cron 3 lần/ngày (Thứ 2 - Thứ 7, trừ chủ nhật):
//   12:10 VN (05:10 UTC) - 17:40 VN (10:40 UTC) - 20:00 VN (13:00 UTC)

const SUPABASE_URL = process.env.VITE_SUPABASE_URL || '';
const SUPABASE_SERVICE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY || '';
const TELEGRAM_BOT_TOKEN = process.env.TELEGRAM_BOT_TOKEN || '';
const TELEGRAM_CHAT_ID = process.env.TELEGRAM_CHAT_ID || '';
const CRON_SECRET = process.env.CRON_SECRET || '';

const SEPARATOR = '━━━━━━━━━━━━━━━━━━━━━━━';

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
  return new Intl.NumberFormat('vi-VN').format(amount || 0) + 'đ';
}

function formatMoneyShort(amount: number): string {
  const n = amount || 0;
  if (n >= 1_000_000_000) return (n / 1_000_000_000).toFixed(1).replace(/\.0$/, '') + ' tỷ';
  if (n >= 1_000_000) return (n / 1_000_000).toFixed(1).replace(/\.0$/, '') + 'M';
  if (n >= 1_000) return (n / 1_000).toFixed(0) + 'k';
  return n.toString() + 'đ';
}

// Pad cho monospace alignment trong code block (tính theo char count, không phải display width)
function padRight(text: string, width: number): string {
  const len = [...text].length;
  return text + ' '.repeat(Math.max(0, width - len));
}

function buildHighlightLine(d: any): string[] {
  const lines: string[] = [];
  const ordersNew = d.orders_created_today || 0;
  const revToday = formatMoneyShort(d.revenue_today || 0);
  const revMonth = formatMoneyShort(d.revenue_month_total || 0);
  const debt = d.payment_stats?.debt_orders || 0;

  lines.push(`   • ${ordersNew} đơn mới  •  💰 ${revToday}`);
  lines.push(`   • ${revMonth} doanh thu tháng (có VAT)`);
  if (debt > 0) lines.push(`   • ${debt} đơn công nợ cần xử lý`);
  return lines;
}

function formatReport(data: any): string {
  const d = data;
  const date = new Date(d.report_date).toLocaleDateString('vi-VN');

  let msg = `📊 *BÁO CÁO NGÀY ${date}*\n`;
  msg += `${SEPARATOR}\n`;

  // Nổi bật
  msg += `🎯 *NỔI BẬT*\n`;
  buildHighlightLine(d).forEach(line => { msg += `${line}\n`; });
  msg += `${SEPARATOR}\n\n`;

  // Tổng quan đơn hàng
  msg += `📋 *TỔNG QUAN ĐƠN HÀNG*\n`;
  msg += `┌ Tạo mới:    *${d.orders_created_today}*\n`;
  msg += `├ Hoàn thành: *${d.orders_completed_today}*\n`;
  msg += `├ Hủy:        *${d.orders_cancelled_today}*\n`;
  msg += `└ Đang xử lý: *${d.pending_orders_count}*\n\n`;

  // Doanh thu
  msg += `💰 *DOANH THU*\n`;
  msg += `┌ Đơn mới (chưa VAT):    *${formatMoney(d.revenue_today_pre_vat)}*\n`;
  msg += `├ Đơn mới (có VAT):      *${formatMoney(d.revenue_today)}*\n`;
  msg += `├ Hoàn thành (chưa VAT): *${formatMoney(d.revenue_completed_today)}*\n`;
  msg += `├ Tháng (có VAT):        *${formatMoney(d.revenue_month_total)}*\n`;
  msg += `└ Tháng (chưa VAT):      *${formatMoney(d.revenue_month_pre_vat)}*\n\n`;

  // Thanh toán
  const ps = d.payment_stats || {};
  msg += `🏦 *THANH TOÁN*\n`;
  msg += `┌ Thu trong ngày:  *${formatMoney(ps.total_collected)}*\n`;
  msg += `├ Chưa thanh toán: *${ps.unpaid_orders} đơn*\n`;
  msg += `└ Công nợ:         *${ps.debt_orders} đơn*\n\n`;

  // Doanh số NVKD (monospace table trong code block)
  if (d.sales_by_employee && d.sales_by_employee.length > 0) {
    const list = d.sales_by_employee.filter((e: any) => Number(e.revenue) > 0 || e.orders_created > 0);
    if (list.length > 0) {
      msg += `👥 *DOANH SỐ THEO NVKD*\n`;
      msg += '```\n';
      list.slice(0, 10).forEach((emp: any, i: number) => {
        const medal = i === 0 ? '🥇' : i === 1 ? '🥈' : i === 2 ? '🥉' : ' •';
        const name = padRight(emp.employee_name || 'N/A', 14);
        const rev = padRight(formatMoneyShort(Number(emp.revenue) || 0), 8);
        msg += `${medal} ${name} ${rev}  (${emp.orders_created} đơn / ${emp.orders_completed} HT)\n`;
      });
      msg += '```\n\n';
    }
  }

  // Chuyển đổi trạng thái (compact 2 cột)
  if (d.status_transitions_today && d.status_transitions_today.length > 0) {
    msg += `🔄 *CHUYỂN ĐỔI TRẠNG THÁI*\n`;
    const items = d.status_transitions_today.map((t: any) =>
      `→ ${statusLabel(t.to_status)}: *${t.count}*`
    );
    for (let i = 0; i < items.length; i += 2) {
      const a = items[i];
      const b = items[i + 1];
      msg += b ? `   ${a}    ${b}\n` : `   ${a}\n`;
    }
    msg += `\n`;
  }

  // Hoạt động nhân viên
  if (d.employee_activity && d.employee_activity.length > 0) {
    msg += `📈 *HOẠT ĐỘNG NHÂN VIÊN*\n`;
    d.employee_activity.forEach((a: any) => {
      const details: string[] = [];
      if (a.orders_created > 0) details.push(`${a.orders_created} tạo`);
      if (a.status_updates > 0) details.push(`${a.status_updates} cập nhật`);
      if (a.stage_actions > 0) details.push(`${a.stage_actions} c.đoạn`);
      if (a.payment_updates > 0) details.push(`${a.payment_updates} TT`);
      const tail = details.length ? ` (${details.join(' / ')})` : '';
      msg += `   ${a.employee_name}: *${a.total_actions}* thao tác${tail}\n`;
    });
    msg += `\n`;
  }

  msg += `${SEPARATOR}\n`;
  msg += `🤖 _P&D Order Manager_`;

  return msg;
}

function buildLineChartUrl(trend: Array<{ date: string; revenue_pre_vat: number; revenue_total: number }>): string {
  const labels = trend.map(p => {
    const d = new Date(p.date);
    return `${d.getDate()}/${d.getMonth() + 1}`;
  });
  const config = {
    type: 'line',
    data: {
      labels,
      datasets: [
        {
          label: 'Chưa VAT',
          data: trend.map(p => Number(p.revenue_pre_vat) || 0),
          borderColor: 'rgb(13, 148, 136)',
          backgroundColor: 'rgba(13, 148, 136, 0.1)',
          tension: 0.3,
          fill: false,
        },
        {
          label: 'Có VAT',
          data: trend.map(p => Number(p.revenue_total) || 0),
          borderColor: 'rgb(22, 163, 74)',
          backgroundColor: 'rgba(22, 163, 74, 0.1)',
          tension: 0.3,
          fill: false,
        },
      ],
    },
    options: {
      plugins: {
        title: { display: true, text: 'Doanh thu 7 ngày qua', font: { size: 16 } },
        legend: { position: 'top' },
      },
      scales: {
        y: { beginAtZero: true, ticks: { callback: 'TICK_MONEY' } },
      },
    },
  };
  let json = JSON.stringify(config);
  json = json.replace('"TICK_MONEY"',
    'function(v){if(v>=1e9)return(v/1e9).toFixed(1)+"tỷ";if(v>=1e6)return(v/1e6).toFixed(0)+"M";if(v>=1e3)return(v/1e3).toFixed(0)+"k";return v;}'
  );
  return `https://quickchart.io/chart?bkg=white&w=800&h=420&devicePixelRatio=2&c=${encodeURIComponent(json)}`;
}

function buildBarChartUrl(topNvkd: Array<{ employee_name: string; revenue: number }>): string {
  const top = topNvkd.filter(e => Number(e.revenue) > 0).slice(0, 10);
  const config = {
    type: 'bar',
    data: {
      labels: top.map(e => e.employee_name || 'N/A'),
      datasets: [
        {
          label: 'Doanh số (có VAT)',
          data: top.map(e => Number(e.revenue) || 0),
          backgroundColor: 'rgba(59, 130, 246, 0.75)',
          borderColor: 'rgb(37, 99, 235)',
          borderWidth: 1,
        },
      ],
    },
    options: {
      indexAxis: 'y',
      plugins: {
        title: { display: true, text: 'Top NVKD theo doanh số ngày', font: { size: 16 } },
        legend: { display: false },
      },
      scales: {
        x: { beginAtZero: true, ticks: { callback: 'TICK_MONEY' } },
      },
    },
  };
  let json = JSON.stringify(config);
  json = json.replace('"TICK_MONEY"',
    'function(v){if(v>=1e9)return(v/1e9).toFixed(1)+"tỷ";if(v>=1e6)return(v/1e6).toFixed(0)+"M";if(v>=1e3)return(v/1e3).toFixed(0)+"k";return v;}'
  );
  const height = Math.max(300, top.length * 36 + 80);
  return `https://quickchart.io/chart?bkg=white&w=800&h=${height}&devicePixelRatio=2&c=${encodeURIComponent(json)}`;
}

async function sendTelegram(text: string): Promise<boolean> {
  const url = `https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage`;
  const res = await fetch(url, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      chat_id: TELEGRAM_CHAT_ID,
      text,
      parse_mode: 'Markdown',
    }),
  });
  if (!res.ok) {
    const err = await res.text();
    console.error('Telegram sendMessage error:', err);
    return false;
  }
  return true;
}

async function sendPhoto(photoUrl: string, caption: string): Promise<boolean> {
  const url = `https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendPhoto`;
  const res = await fetch(url, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      chat_id: TELEGRAM_CHAT_ID,
      photo: photoUrl,
      caption,
      parse_mode: 'Markdown',
    }),
  });
  if (!res.ok) {
    const err = await res.text();
    console.error('Telegram sendPhoto error:', err);
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
    const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY);

    // 1. Fetch báo cáo ngày
    const { data, error } = await supabase.rpc('get_daily_report');
    if (error) {
      console.error('DB error (get_daily_report):', error);
      return res.status(500).json({ error: 'Database error', details: error.message });
    }

    // 2. Fetch trend 7 ngày (fail silently nếu RPC chưa được deploy)
    let trend: any[] = [];
    try {
      const { data: trendData, error: trendErr } = await supabase.rpc('get_revenue_trend', { p_days: 7 });
      if (trendErr) throw trendErr;
      trend = trendData || [];
    } catch (e: any) {
      console.warn('get_revenue_trend not available, skipping line chart:', e.message);
    }

    // 3. Gửi text trước
    const sentText = await sendTelegram(formatReport(data));
    if (!sentText) {
      return res.status(500).json({ error: 'Failed to send Telegram text message' });
    }

    // 4. Gửi Line chart (nếu có trend)
    if (trend.length > 0) {
      const photoUrl = buildLineChartUrl(trend);
      await sendPhoto(photoUrl, '📈 *Doanh thu 7 ngày qua*');
    }

    // 5. Gửi Bar chart (nếu có NVKD)
    const topNvkd = (data?.sales_by_employee || []).filter((e: any) => Number(e.revenue) > 0);
    if (topNvkd.length > 0) {
      const photoUrl = buildBarChartUrl(topNvkd);
      await sendPhoto(photoUrl, '👥 *Top NVKD theo doanh số*');
    }

    return res.status(200).json({
      success: true,
      message: 'Daily report sent',
      charts: { line: trend.length > 0, bar: topNvkd.length > 0 },
    });
  } catch (err: any) {
    console.error('Error:', err);
    return res.status(500).json({ error: err.message });
  }
}
