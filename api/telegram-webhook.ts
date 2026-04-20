import { createClient, SupabaseClient } from '@supabase/supabase-js';

const SUPABASE_URL = process.env.VITE_SUPABASE_URL || '';
const SUPABASE_SERVICE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY || '';
const TELEGRAM_BOT_TOKEN = process.env.TELEGRAM_BOT_TOKEN || '';
const TELEGRAM_CHAT_ID = process.env.TELEGRAM_CHAT_ID || '';

function statusLabel(s: string): string {
  const m: Record<string, string> = {
    'Moi': 'Mới', 'TiepNhan': 'Tiếp nhận', 'NhanFile': 'Nhận File',
    'XuLyFile': 'Xử lý File', 'BinhFile': 'Bình File', 'In': 'In',
    'ThanhPham': 'Thành Phẩm', 'DongGoi': 'Đóng gói',
    'ChoGiaoHang': 'Chờ giao hàng', 'DaGiaoHang': 'Đã giao hàng',
    'HoanThanh': 'Hoàn thành', 'Huy': 'Hủy', 'TamNgung': 'Tạm ngưng',
  };
  return m[s] || s;
}

function paymentLabel(s: string): string {
  const m: Record<string, string> = {
    'ChuaThanhToan': 'Chưa thanh toán', 'DaCoc': 'Đã đặt cọc',
    'DaThanhToan': 'Đã thanh toán', 'CongNo': 'Công nợ',
  };
  return m[s] || s;
}

function fmt(n: number): string {
  return new Intl.NumberFormat('vi-VN').format(n) + 'đ';
}

function getDb(): SupabaseClient {
  return createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY);
}

function todayRange(): { start: string; end: string } {
  const now = new Date();
  const vn = new Date(now.getTime() + 7 * 3600000);
  const d = vn.toISOString().split('T')[0];
  return { start: d + 'T00:00:00+07:00', end: d + 'T23:59:59+07:00' };
}

function dateRange(dateStr: string): { start: string; end: string } {
  return { start: dateStr + 'T00:00:00+07:00', end: dateStr + 'T23:59:59+07:00' };
}

// ====== QUERY FUNCTIONS ======

async function getDailyReport(dateStr?: string): Promise<string> {
  const db = getDb();
  const params = dateStr ? { p_date: dateStr } : {};
  const { data, error } = await db.rpc('get_daily_report', params);
  if (error) return `❌ Lỗi: ${error.message}`;

  const d = data;
  const date = new Date(d.report_date).toLocaleDateString('vi-VN');
  let msg = `📊 *BÁO CÁO NGÀY ${date}*\n━━━━━━━━━━━━━━━━━━━\n\n`;
  msg += `📋 *TỔNG QUAN*\n`;
  msg += `• Đơn mới: *${d.orders_created_today}* | HT: *${d.orders_completed_today}* | Hủy: *${d.orders_cancelled_today}*\n`;
  msg += `• Đang xử lý: *${d.pending_orders_count}*\n\n`;
  msg += `💰 *DOANH THU*\n`;
  msg += `• Đơn mới: *${fmt(d.revenue_today)}*\n`;
  msg += `• Hoàn thành: *${fmt(d.revenue_completed_today)}*\n\n`;
  const ps = d.payment_stats;
  msg += `🏦 *THANH TOÁN*\n`;
  msg += `• Thu ngày: *${fmt(ps.total_collected)}* | Chưa TT: *${ps.unpaid_orders}* | Nợ: *${ps.debt_orders}*\n\n`;
  if (d.sales_by_employee?.length > 0) {
    msg += `👥 *NVKD*\n`;
    d.sales_by_employee.forEach((e: any, i: number) => {
      const medal = ['🥇','🥈','🥉'][i] || '•';
      msg += `${medal} ${e.employee_name}: *${fmt(e.revenue)}* (${e.orders_created} đơn, ${e.orders_completed} HT)\n`;
    });
    msg += `\n`;
  }
  if (d.status_transitions_today?.length > 0) {
    msg += `🔄 *CHUYỂN TRẠNG THÁI*\n`;
    d.status_transitions_today.forEach((t: any) => {
      msg += `• → ${statusLabel(t.to_status)}: *${t.count}*\n`;
    });
    msg += `\n`;
  }
  if (d.employee_activity?.length > 0) {
    msg += `📈 *HOẠT ĐỘNG NV*\n`;
    d.employee_activity.slice(0, 10).forEach((a: any) => {
      const det = [];
      if (a.orders_created > 0) det.push(`${a.orders_created} tạo`);
      if (a.status_updates > 0) det.push(`${a.status_updates} CĐ`);
      if (a.stage_actions > 0) det.push(`${a.stage_actions} SX`);
      if (a.payment_updates > 0) det.push(`${a.payment_updates} TT`);
      msg += `• ${a.employee_name}: ${a.total_actions} (${det.join(', ')})\n`;
    });
  }
  msg += `\n🤖 _P&D Bot_`;
  return msg;
}

async function getOrdersByStatus(): Promise<string> {
  const db = getDb();
  const statuses = ['Moi','NhanFile','XuLyFile','BinhFile','In','ThanhPham','DongGoi','ChoGiaoHang','TamNgung'];
  let msg = `📦 *ĐƠN HÀNG THEO TRẠNG THÁI*\n━━━━━━━━━━━━━━━━━━━\n\n`;
  for (const s of statuses) {
    const { count } = await db.from('orders').select('*', { count: 'exact', head: true }).eq('status', s);
    if (count && count > 0) {
      msg += `• ${statusLabel(s)}: *${count}*\n`;
    }
  }
  const { count: total } = await db.from('orders').select('*', { count: 'exact', head: true }).not('status', 'in', '("HoanThanh","Huy")');
  msg += `\n📊 Tổng đang xử lý: *${total || 0}*`;
  return msg;
}

async function getDebtReport(): Promise<string> {
  const db = getDb();
  const { data, error } = await db.from('orders')
    .select('order_code, total_amount, deposit_amount, remaining_amount, customer:customers(name), sales_rep:profiles!orders_sales_rep_id_fkey(full_name)')
    .eq('payment_status', 'CongNo')
    .not('status', 'eq', 'Huy')
    .order('total_amount', { ascending: false })
    .limit(20);

  if (error) return `❌ Lỗi: ${error.message}`;

  const { count } = await db.from('orders').select('*', { count: 'exact', head: true }).eq('payment_status', 'CongNo').not('status', 'eq', 'Huy');

  let totalDebt = 0;
  let msg = `🏦 *BÁO CÁO CÔNG NỢ*\n━━━━━━━━━━━━━━━━━━━\n\n`;

  (data || []).forEach((o: any) => {
    const debt = (o.total_amount || 0) - (o.deposit_amount || 0);
    totalDebt += debt;
    const cust = o.customer?.name || 'N/A';
    msg += `• *${o.order_code}* — ${cust}\n  Nợ: *${fmt(debt)}* / Tổng: ${fmt(o.total_amount || 0)}\n`;
  });

  msg += `\n━━━━━━━━━━━━━━━━━━━\n`;
  msg += `📊 Tổng đơn nợ: *${count || 0}*\n`;
  msg += `💰 Top 20 nợ: *${fmt(totalDebt)}*`;
  return msg;
}

async function getUrgentOrders(): Promise<string> {
  const db = getDb();
  const { data, error } = await db.from('orders')
    .select('order_code, status, delivery_date, customer:customers(name), sales_rep:profiles!orders_sales_rep_id_fkey(full_name)')
    .eq('is_urgent', true)
    .not('status', 'in', '("HoanThanh","Huy")')
    .order('delivery_date', { ascending: true })
    .limit(20);

  if (error) return `❌ Lỗi: ${error.message}`;
  if (!data?.length) return `✅ Không có đơn gấp đang xử lý.`;

  let msg = `🔴 *ĐƠN HÀNG GẤP*\n━━━━━━━━━━━━━━━━━━━\n\n`;
  data.forEach((o: any) => {
    const dl = o.delivery_date ? new Date(o.delivery_date).toLocaleDateString('vi-VN') : 'N/A';
    msg += `• *${o.order_code}* — ${o.customer?.name || 'N/A'}\n  TT: ${statusLabel(o.status)} | Giao: ${dl}\n`;
  });
  msg += `\n📊 Tổng: *${data.length}* đơn gấp`;
  return msg;
}

async function searchOrder(keyword: string): Promise<string> {
  const db = getDb();
  const kw = `%${keyword}%`;
  const { data, error } = await db.from('orders')
    .select('order_code, status, payment_status, total_amount, created_at, delivery_date, description, customer:customers(name, phone), sales_rep:profiles!orders_sales_rep_id_fkey(full_name)')
    .or(`order_code.ilike.${kw},description.ilike.${kw}`)
    .order('created_at', { ascending: false })
    .limit(5);

  if (error) return `❌ Lỗi: ${error.message}`;
  if (!data?.length) {
    // Tìm theo tên khách hàng
    const { data: d2 } = await db.from('orders')
      .select('order_code, status, payment_status, total_amount, created_at, customer:customers(name, phone), sales_rep:profiles!orders_sales_rep_id_fkey(full_name)')
      .ilike('customers.name' as any, kw)
      .order('created_at', { ascending: false })
      .limit(5);
    if (!d2?.length) return `🔍 Không tìm thấy đơn nào với: "${keyword}"`;
    return formatOrderList(d2, keyword);
  }
  return formatOrderList(data, keyword);
}

function formatOrderList(data: any[], keyword: string): string {
  let msg = `🔍 *TÌM: "${keyword}"* — ${data.length} kết quả\n━━━━━━━━━━━━━━━━━━━\n\n`;
  data.forEach((o: any) => {
    const date = new Date(o.created_at).toLocaleDateString('vi-VN');
    msg += `📋 *${o.order_code}*\n`;
    msg += `• KH: ${o.customer?.name || 'N/A'}\n`;
    msg += `• TT: ${statusLabel(o.status)} | TT toán: ${paymentLabel(o.payment_status)}\n`;
    msg += `• Tổng: *${fmt(o.total_amount || 0)}* | Ngày: ${date}\n`;
    msg += `• NVKD: ${o.sales_rep?.full_name || 'N/A'}\n\n`;
  });
  return msg;
}

async function getEmployeeStats(name?: string): Promise<string> {
  const db = getDb();
  const { start, end } = todayRange();

  if (name) {
    // Tìm nhân viên cụ thể
    const kw = `%${name}%`;
    const { data: staff } = await db.from('profiles').select('id, full_name, role').ilike('full_name', kw).limit(1);
    if (!staff?.length) return `❌ Không tìm thấy nhân viên: "${name}"`;

    const s = staff[0];
    // Đơn hôm nay
    const { count: todayOrders } = await db.from('orders').select('*', { count: 'exact', head: true }).eq('sales_rep_id', s.id).gte('created_at', start).lte('created_at', end);
    // Tổng đơn
    const { count: totalOrders } = await db.from('orders').select('*', { count: 'exact', head: true }).eq('sales_rep_id', s.id);
    // Doanh thu tháng
    const monthStart = new Date().toISOString().slice(0, 7) + '-01T00:00:00+07:00';
    const { data: monthData } = await db.from('orders').select('total_amount').eq('sales_rep_id', s.id).gte('created_at', monthStart).not('status', 'eq', 'Huy');
    const monthRevenue = (monthData || []).reduce((sum: number, o: any) => sum + (o.total_amount || 0), 0);
    // Đơn đang xử lý
    const { count: pendingOrders } = await db.from('orders').select('*', { count: 'exact', head: true }).eq('sales_rep_id', s.id).not('status', 'in', '("HoanThanh","Huy")');

    let msg = `👤 *${s.full_name}*\n━━━━━━━━━━━━━━━━━━━\n\n`;
    msg += `• Vai trò: ${s.role}\n`;
    msg += `• Đơn hôm nay: *${todayOrders || 0}*\n`;
    msg += `• Tổng đơn: *${totalOrders || 0}*\n`;
    msg += `• Đơn đang xử lý: *${pendingOrders || 0}*\n`;
    msg += `• DT tháng này: *${fmt(monthRevenue)}*\n`;
    return msg;
  }

  // Danh sách nhân viên kinh doanh
  const { data: employees } = await db.from('profiles')
    .select('id, full_name, role')
    .eq('role', 'NhanVienKinhDoanh')
    .or('is_locked.is.null,is_locked.eq.false');

  if (!employees?.length) return `❌ Không có NVKD nào.`;

  let msg = `👥 *NHÂN VIÊN KINH DOANH*\n━━━━━━━━━━━━━━━━━━━\n\n`;
  const monthStart = new Date().toISOString().slice(0, 7) + '-01T00:00:00+07:00';

  for (const e of employees) {
    const { count: todayC } = await db.from('orders').select('*', { count: 'exact', head: true }).eq('sales_rep_id', e.id).gte('created_at', start).lte('created_at', end);
    const { data: mData } = await db.from('orders').select('total_amount').eq('sales_rep_id', e.id).gte('created_at', monthStart).not('status', 'eq', 'Huy');
    const mRev = (mData || []).reduce((sum: number, o: any) => sum + (o.total_amount || 0), 0);
    msg += `• *${e.full_name}*: Hôm nay ${todayC || 0} đơn | DT tháng: ${fmt(mRev)}\n`;
  }
  return msg;
}

async function getRevenueByPeriod(period: string): Promise<string> {
  const db = getDb();
  let start: string, end: string, label: string;
  const now = new Date();
  const vnNow = new Date(now.getTime() + 7 * 3600000);

  if (period === 'week') {
    const day = vnNow.getDay() || 7;
    const mon = new Date(vnNow);
    mon.setDate(mon.getDate() - day + 1);
    start = mon.toISOString().split('T')[0] + 'T00:00:00+07:00';
    end = vnNow.toISOString().split('T')[0] + 'T23:59:59+07:00';
    label = 'TUẦN NÀY';
  } else if (period === 'month') {
    start = vnNow.toISOString().slice(0, 7) + '-01T00:00:00+07:00';
    end = vnNow.toISOString().split('T')[0] + 'T23:59:59+07:00';
    label = `THÁNG ${vnNow.getMonth() + 1}`;
  } else {
    start = vnNow.getFullYear() + '-01-01T00:00:00+07:00';
    end = vnNow.toISOString().split('T')[0] + 'T23:59:59+07:00';
    label = `NĂM ${vnNow.getFullYear()}`;
  }

  const { data, error } = await db.from('orders')
    .select('total_amount, status')
    .gte('created_at', start).lte('created_at', end)
    .not('status', 'eq', 'Huy');

  if (error) return `❌ Lỗi: ${error.message}`;

  const total = (data || []).reduce((s: number, o: any) => s + (o.total_amount || 0), 0);
  const completed = (data || []).filter((o: any) => o.status === 'HoanThanh');
  const completedRev = completed.reduce((s: number, o: any) => s + (o.total_amount || 0), 0);

  let msg = `💰 *DOANH THU ${label}*\n━━━━━━━━━━━━━━━━━━━\n\n`;
  msg += `• Tổng DT: *${fmt(total)}*\n`;
  msg += `• DT hoàn thành: *${fmt(completedRev)}*\n`;
  msg += `• Số đơn: *${data?.length || 0}*\n`;
  msg += `• Đơn HT: *${completed.length}*\n`;
  return msg;
}

async function getCustomerSearch(keyword: string): Promise<string> {
  const db = getDb();
  const kw = `%${keyword}%`;
  const { data, error } = await db.from('customers')
    .select('code, name, phone, tier, order_count, last_order_at')
    .or(`name.ilike.${kw},phone.ilike.${kw},code.ilike.${kw}`)
    .order('order_count', { ascending: false })
    .limit(10);

  if (error) return `❌ Lỗi: ${error.message}`;
  if (!data?.length) return `🔍 Không tìm thấy KH: "${keyword}"`;

  let msg = `👤 *TÌM KH: "${keyword}"* — ${data.length} KQ\n━━━━━━━━━━━━━━━━━━━\n\n`;
  data.forEach((c: any) => {
    msg += `• *${c.name}* (${c.code})\n`;
    msg += `  SĐT: ${c.phone || 'N/A'} | Hạng: ${c.tier || 'N/A'} | Đơn: ${c.order_count || 0}\n`;
  });
  return msg;
}

async function getDeliveryToday(): Promise<string> {
  const db = getDb();
  const { start, end } = todayRange();
  const { data, error } = await db.from('orders')
    .select('order_code, status, delivery_date, delivery_address, customer:customers(name, phone), sales_rep:profiles!orders_sales_rep_id_fkey(full_name)')
    .gte('delivery_date', start).lte('delivery_date', end)
    .not('status', 'in', '("HoanThanh","Huy")')
    .order('delivery_date', { ascending: true });

  if (error) return `❌ Lỗi: ${error.message}`;
  if (!data?.length) return `📦 Hôm nay không có đơn cần giao.`;

  let msg = `🚚 *GIAO HÀNG HÔM NAY* — ${data.length} đơn\n━━━━━━━━━━━━━━━━━━━\n\n`;
  data.forEach((o: any) => {
    msg += `• *${o.order_code}* — ${o.customer?.name || 'N/A'}\n`;
    msg += `  TT: ${statusLabel(o.status)} | ĐC: ${o.delivery_address || 'N/A'}\n`;
    msg += `  SĐT: ${o.customer?.phone || 'N/A'}\n\n`;
  });
  return msg;
}

async function getTopCustomers(): Promise<string> {
  const db = getDb();
  const monthStart = new Date().toISOString().slice(0, 7) + '-01T00:00:00+07:00';

  const { data, error } = await db.from('orders')
    .select('total_amount, customer:customers(name, code)')
    .gte('created_at', monthStart)
    .not('status', 'eq', 'Huy');

  if (error) return `❌ Lỗi: ${error.message}`;

  const custMap: Record<string, { name: string; revenue: number; count: number }> = {};
  (data || []).forEach((o: any) => {
    const name = o.customer?.name || 'N/A';
    if (!custMap[name]) custMap[name] = { name, revenue: 0, count: 0 };
    custMap[name].revenue += o.total_amount || 0;
    custMap[name].count++;
  });

  const sorted = Object.values(custMap).sort((a, b) => b.revenue - a.revenue).slice(0, 10);

  let msg = `🏆 *TOP KH THÁNG NÀY*\n━━━━━━━━━━━━━━━━━━━\n\n`;
  sorted.forEach((c, i) => {
    const medal = ['🥇','🥈','🥉'][i] || `${i+1}.`;
    msg += `${medal} *${c.name}*\n   DT: *${fmt(c.revenue)}* | ${c.count} đơn\n`;
  });
  return msg;
}

// ====== MESSAGE PARSER ======

async function handleMessage(chatId: string, text: string): Promise<string> {
  const cmd = text.trim().toLowerCase()
    .normalize('NFD').replace(/[\u0300-\u036f]/g, '').replace(/đ/g, 'd').replace(/Đ/g, 'D');
  const original = text.trim();

  // /start hoặc help
  if (cmd === '/start' || cmd === 'help' || cmd === '/help' || cmd === 'menu') {
    return `🤖 *P&D Bot - Trợ lý đơn hàng*\n━━━━━━━━━━━━━━━━━━━\n\n` +
      `📊 *Báo cáo:*\n` +
      `• *báo cáo* — BC hôm nay\n` +
      `• *hôm qua* — BC hôm qua\n` +
      `• *bc 20/03/2026* — BC theo ngày\n\n` +
      `💰 *Doanh thu:*\n` +
      `• *doanh thu tuần* / *tháng* / *năm*\n\n` +
      `📦 *Đơn hàng:*\n` +
      `• *trạng thái* — Đơn theo TT\n` +
      `• *đơn gấp* — Đơn urgent\n` +
      `• *giao hôm nay* — Đơn giao hôm nay\n` +
      `• *tìm [mã/tên]* — Tìm đơn\n\n` +
      `🏦 *Tài chính:*\n` +
      `• *công nợ* — BC công nợ\n\n` +
      `👥 *Nhân viên:*\n` +
      `• *nhân viên* — DS NVKD\n` +
      `• *nv [tên]* — Chi tiết NV\n\n` +
      `👤 *Khách hàng:*\n` +
      `• *top khách* — Top KH tháng\n` +
      `• *kh [tên/SĐT]* — Tìm KH\n`;
  }

  // Báo cáo hôm nay
  if (/^(bao cao|bc|report|baocao|\/baocao)$/.test(cmd)) {
    return await getDailyReport();
  }

  // Hôm qua
  if (/^(hom qua|\/homqua|yesterday)$/.test(cmd)) {
    const y = new Date(Date.now() + 7 * 3600000);
    y.setDate(y.getDate() - 1);
    return await getDailyReport(y.toISOString().split('T')[0]);
  }

  // Báo cáo theo ngày: "bc 20/03/2026" hoặc "bc 2026-03-20"
  const dateVN = original.match(/(?:báo cáo|bao cao|bc|report)\s+(\d{1,2})\/(\d{1,2})\/(\d{4})/i);
  if (dateVN) {
    const d = `${dateVN[3]}-${dateVN[2].padStart(2,'0')}-${dateVN[1].padStart(2,'0')}`;
    return await getDailyReport(d);
  }
  const dateISO = original.match(/(?:báo cáo|bao cao|bc|report)\s+(\d{4}-\d{2}-\d{2})/i);
  if (dateISO) return await getDailyReport(dateISO[1]);

  // Doanh thu
  if (/doanh thu tuan|dt tuan|revenue week/.test(cmd)) return await getRevenueByPeriod('week');
  if (/doanh thu thang|dt thang|revenue month/.test(cmd)) return await getRevenueByPeriod('month');
  if (/doanh thu nam|dt nam|revenue year/.test(cmd)) return await getRevenueByPeriod('year');
  if (/^(doanh thu|dt|revenue)$/.test(cmd)) return await getRevenueByPeriod('month');

  // Trạng thái đơn
  if (/^(trang thai|don hang|status|\/status)$/.test(cmd)) return await getOrdersByStatus();

  // Đơn gấp
  if (/don gap|urgent|gap/.test(cmd) && !cmd.startsWith('tim') && !cmd.startsWith('search')) return await getUrgentOrders();

  // Giao hôm nay
  if (/giao hom nay|delivery today|giao hang/.test(cmd)) return await getDeliveryToday();

  // Công nợ
  if (/^(cong no|\/congno|debt)$/.test(cmd)) return await getDebtReport();

  // Nhân viên cụ thể: "nv Ly" hoặc "nhân viên Cẩm Ly"
  const nvMatch = original.match(/^(?:nv|nhân viên|nhan vien)\s+(.+)/i);
  if (nvMatch) return await getEmployeeStats(nvMatch[1].trim());

  // Danh sách nhân viên
  if (/^(nhan vien|nhân viên|nv|nvkd|\/nhanvien|staff)$/.test(cmd)) return await getEmployeeStats();

  // Tìm đơn: "tìm PD2703" hoặc "tìm ANH BẢO"
  const searchMatch = original.match(/^(?:tìm|tim|search|tìm đơn|tim don|đơn|don)\s+(.+)/i);
  if (searchMatch) return await searchOrder(searchMatch[1].trim());

  // Tìm khách: "kh Lộc" hoặc "khách hàng 0901"
  const khMatch = original.match(/^(?:kh|khách hàng|khach hang|customer)\s+(.+)/i);
  if (khMatch) return await getCustomerSearch(khMatch[1].trim());

  // Top khách
  if (/top khach|top kh|top customer/.test(cmd)) return await getTopCustomers();

  // Nếu nhập mã đơn trực tiếp (VD: "26PD2703.0001")
  if (/^\d{2}PD\d{4}\.\d+$/i.test(original.trim())) return await searchOrder(original.trim());

  // Không hiểu → gợi ý
  return `🤔 Không hiểu: "${original}"\n\nGõ *menu* để xem danh sách lệnh.`;
}

// ====== SEND TELEGRAM ======

async function sendTelegram(chatId: string, text: string): Promise<boolean> {
  // Telegram limit 4096 chars, split if needed
  const chunks: string[] = [];
  if (text.length > 4000) {
    const lines = text.split('\n');
    let chunk = '';
    for (const line of lines) {
      if ((chunk + line + '\n').length > 4000) {
        chunks.push(chunk);
        chunk = line + '\n';
      } else {
        chunk += line + '\n';
      }
    }
    if (chunk) chunks.push(chunk);
  } else {
    chunks.push(text);
  }

  for (const chunk of chunks) {
    const url = `https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage`;
    await fetch(url, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ chat_id: chatId, text: chunk, parse_mode: 'Markdown' }),
    });
  }
  return true;
}

// ====== WEBHOOK HANDLER ======

export default async function handler(req: any, res: any) {
  if (req.method !== 'POST') return res.status(200).json({ ok: true });

  try {
    const { message } = req.body || {};
    if (!message?.text) return res.status(200).json({ ok: true });

    const chatId = String(message.chat.id);

    // Bảo mật: chỉ cho phép chat_id đã cấu hình
    if (TELEGRAM_CHAT_ID && chatId !== TELEGRAM_CHAT_ID) {
      await sendTelegram(chatId, '⛔ Bạn không có quyền sử dụng bot này.');
      return res.status(200).json({ ok: true });
    }

    const reply = await handleMessage(chatId, message.text);
    await sendTelegram(chatId, reply);
    return res.status(200).json({ ok: true });
  } catch (err: any) {
    console.error('Webhook error:', err);
    return res.status(200).json({ ok: true });
  }
}
