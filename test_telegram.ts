import dotenv from 'dotenv';
dotenv.config({ path: '.env.local' });
import { createClient } from '@supabase/supabase-js';

const SUPABASE_URL = process.env.VITE_SUPABASE_URL || '';
const SUPABASE_SERVICE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY || '';
const TELEGRAM_BOT_TOKEN = process.env.TELEGRAM_BOT_TOKEN || '';
const TELEGRAM_CHAT_ID = process.env.TELEGRAM_CHAT_ID || '';

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
  msg += `🎯 *NỔI BẬT*\n`;
  buildHighlightLine(d).forEach(line => { msg += `${line}\n`; });
  msg += `${SEPARATOR}\n\n`;

  msg += `📋 *TỔNG QUAN ĐƠN HÀNG*\n`;
  msg += `┌ Tạo mới:    *${d.orders_created_today}*\n`;
  msg += `├ Hoàn thành: *${d.orders_completed_today}*\n`;
  msg += `├ Hủy:        *${d.orders_cancelled_today}*\n`;
  msg += `└ Đang xử lý: *${d.pending_orders_count}*\n\n`;

  msg += `💰 *DOANH THU*\n`;
  msg += `┌ Đơn mới (chưa VAT):    *${formatMoney(d.revenue_today_pre_vat)}*\n`;
  msg += `├ Đơn mới (có VAT):      *${formatMoney(d.revenue_today)}*\n`;
  msg += `├ Hoàn thành (chưa VAT): *${formatMoney(d.revenue_completed_today)}*\n`;
  msg += `├ Tháng (có VAT):        *${formatMoney(d.revenue_month_total)}*\n`;
  msg += `└ Tháng (chưa VAT):      *${formatMoney(d.revenue_month_pre_vat)}*\n\n`;

  const ps = d.payment_stats || {};
  msg += `🏦 *THANH TOÁN*\n`;
  msg += `┌ Thu trong ngày:  *${formatMoney(ps.total_collected)}*\n`;
  msg += `├ Chưa thanh toán: *${ps.unpaid_orders} đơn*\n`;
  msg += `└ Công nợ:         *${ps.debt_orders} đơn*\n\n`;

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

async function main() {
  console.log('🔄 Đang lấy dữ liệu báo cáo...');

  const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY);
  const { data, error } = await supabase.rpc('get_daily_report');

  if (error) {
    console.error('❌ Lỗi DB:', error.message);
    process.exit(1);
  }

  const message = formatReport(data);
  console.log('\n📝 Tin nhắn Telegram:\n', message);

  console.log('\n🔄 Đang gửi Telegram...');
  const fs = await import('fs');
  const { execSync } = await import('child_process');
  const payload = JSON.stringify({
    chat_id: TELEGRAM_CHAT_ID,
    text: message,
    parse_mode: 'Markdown',
  });
  const tmpFile = 'tmp_telegram_payload.json';
  try {
    fs.writeFileSync(tmpFile, payload, 'utf-8');
    const curlResult = execSync(
      `curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" -H "Content-Type: application/json" -d @${tmpFile}`,
      { encoding: 'utf-8', timeout: 15000 }
    );
    fs.unlinkSync(tmpFile);
    const result = JSON.parse(curlResult);
    if (result.ok) {
      console.log('✅ Gửi Telegram thành công!');
      console.log('   (Test local chỉ gửi text. Vào Vercel Cron > Run để test full bao gồm 2 ảnh chart.)');
    } else {
      console.error('❌ Lỗi Telegram:', result);
    }
  } catch (e: any) {
    if (fs.existsSync(tmpFile)) fs.unlinkSync(tmpFile);
    console.error('❌ Lỗi gửi:', e.message);
  }
}

main();
