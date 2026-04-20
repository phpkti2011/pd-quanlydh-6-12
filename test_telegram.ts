import dotenv from 'dotenv';
dotenv.config({ path: '.env.local' });
import { createClient } from '@supabase/supabase-js';

const SUPABASE_URL = process.env.VITE_SUPABASE_URL || '';
const SUPABASE_SERVICE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY || '';
const TELEGRAM_BOT_TOKEN = process.env.TELEGRAM_BOT_TOKEN || '';
const TELEGRAM_CHAT_ID = process.env.TELEGRAM_CHAT_ID || '';

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

function formatReport(data: any): string {
  const d = data;
  const date = new Date(d.report_date).toLocaleDateString('vi-VN');

  let msg = `📊 *BÁO CÁO NGÀY ${date}*\n`;
  msg += `━━━━━━━━━━━━━━━━━━━\n\n`;

  msg += `📋 *TỔNG QUAN ĐƠN HÀNG*\n`;
  msg += `• Đơn tạo mới: *${d.orders_created_today}*\n`;
  msg += `• Đơn hoàn thành: *${d.orders_completed_today}*\n`;
  msg += `• Đơn hủy: *${d.orders_cancelled_today}*\n`;
  msg += `• Đơn đang xử lý: *${d.pending_orders_count}*\n\n`;

  msg += `💰 *DOANH THU*\n`;
  msg += `• Doanh thu đơn mới: *${formatMoney(d.revenue_today)}*\n`;
  msg += `• Doanh thu hoàn thành: *${formatMoney(d.revenue_completed_today)}*\n\n`;

  const ps = d.payment_stats;
  msg += `🏦 *THANH TOÁN*\n`;
  msg += `• Thu trong ngày: *${formatMoney(ps.total_collected)}*\n`;
  msg += `• Đơn chưa thanh toán: *${ps.unpaid_orders}*\n`;
  msg += `• Đơn công nợ: *${ps.debt_orders}*\n\n`;

  if (d.sales_by_employee && d.sales_by_employee.length > 0) {
    msg += `👥 *DOANH SỐ THEO NVKD*\n`;
    d.sales_by_employee.forEach((emp: any, i: number) => {
      const medal = i === 0 ? '🥇' : i === 1 ? '🥈' : i === 2 ? '🥉' : '•';
      msg += `${medal} ${emp.employee_name || 'N/A'}: *${formatMoney(emp.revenue)}* (${emp.orders_created} đơn, ${emp.orders_completed} HT)\n`;
    });
    msg += `\n`;
  }

  if (d.status_transitions_today && d.status_transitions_today.length > 0) {
    msg += `🔄 *CHUYỂN ĐỔI TRẠNG THÁI*\n`;
    d.status_transitions_today.forEach((t: any) => {
      msg += `• → ${statusLabel(t.to_status)}: *${t.count}* lượt\n`;
    });
    msg += `\n`;
  }

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

  console.log('✅ Dữ liệu:', JSON.stringify(data, null, 2));

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
    } else {
      console.error('❌ Lỗi Telegram:', result);
    }
  } catch (e: any) {
    if (fs.existsSync(tmpFile)) fs.unlinkSync(tmpFile);
    console.error('❌ Lỗi gửi:', e.message);
  }
}

main();
