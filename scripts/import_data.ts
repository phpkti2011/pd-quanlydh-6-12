
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import { parse } from 'csv-parse/sync';
import { createClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Load environment variables
const envPath = path.resolve(__dirname, '../.env.local');
console.log('Loading env from:', envPath);
dotenv.config({ path: envPath });

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL || process.env.VITE_SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY || process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY || process.env.VITE_SUPABASE_ANON_KEY;

if (!supabaseUrl || !supabaseKey) {
    console.error('Missing Supabase URL or Key in .env.local');
    process.exit(1);
}

const supabase = createClient(supabaseUrl, supabaseKey, {
    auth: {
        autoRefreshToken: false,
        persistSession: false
    }
});

const DATA_DIR = path.resolve(__dirname, '../data');

// --- MAPPINGS ---

const STATUS_MAP: Record<string, string> = {
    'Chờ giao hàng': 'ChoGiaoHang',
    'Đã hoàn thành': 'HoanThanh',
    'In': 'In',
    'Gia công': 'ThanhPham',
    'Hủy': 'Huy',
    'Thiết kế': 'XuLyFile',
    'Mới': 'Moi'
};

const ROLE_MAP: Record<string, string> = {
    'Admin': 'Admin',
    'Nhân Viên Kinh Doanh': 'NhanVienKinhDoanh',
    'Nhân viên Sản Xuất': 'NhanVienSanXuat',
    'Kế toán': 'KeToan',
    'Nhân viên Bình File': 'NhanVienSanXuat',
    'Nhân viên Thiết Kế': 'NhanVienSanXuat'
};

function normalizeStatus(status: string): string {
    if (!status) return 'Moi';
    const s = status.trim();
    return STATUS_MAP[s] || 'Moi';
}

function normalizePaymentStatus(status: string): string {
    if (!status) return 'ChuaThanhToan';
    const s = status.trim().toLowerCase();
    if (s.includes('đã thanh toán')) return 'DaThanhToan';
    if (s.includes('công nợ')) return 'CongNo';
    if (s.includes('kế toán duyệt')) return 'DaThanhToan';
    return 'ChuaThanhToan';
}

function parseMoney(str: string): number {
    if (!str) return 0;
    const clean = str.replace(/[^0-9]/g, '');
    return parseInt(clean, 10) || 0;
}

function parseDate(str: string): Date | null {
    if (!str) return null;
    try {
        const d = new Date(str);
        if (!isNaN(d.getTime())) return d;
        const parts = str.split(' ')[0].split('/');
        if (parts.length === 3) {
            return new Date(`${parts[2]}-${parts[1]}-${parts[0]}`); // yyyy-mm-dd
        }
        return null;
    } catch {
        return null;
    }
}

// --- MAIN IMPORT ---

async function importData() {
    console.log('Starting Data Import...');

    // 1. Process Users (Quyen.csv)
    console.log('Processing Users...');
    const usersMap = new Map<string, string>(); // Name -> Email

    try {
        const quyenContent = fs.readFileSync(path.join(DATA_DIR, 'Quyen.csv'), 'utf8');
        const quyenRows = parse(quyenContent, { columns: true, skip_empty_lines: true, bom: true });

        for (const row of quyenRows) {
            const name = row['Tên Nhân Viên'] || row['Tên'];
            const email = (row['Email'] || '').trim();

            if (!email) continue;
            if (name) usersMap.set(name.trim(), email);

            // Create user if not exists
            const { data: newUser, error: createError } = await supabase.auth.admin.createUser({
                email: email,
                password: 'password123',
                email_confirm: true,
                user_metadata: { full_name: name || email }
            });

            if (!createError) {
                console.log(`Created user ${email}`);
            }
        }
    } catch (e) {
        console.error("Error processing users", e);
    }

    // 2. Resolve Profile IDs & Update Roles
    const profileMap = new Map<string, string>(); // Email -> ProfileID

    // Initial fetch
    let { data: profiles } = await supabase.from('profiles').select('id, email');
    profiles?.forEach(p => { if (p.email) profileMap.set(p.email, p.id); });

    // Update Roles using Quyen.csv again
    try {
        const quyenContent = fs.readFileSync(path.join(DATA_DIR, 'Quyen.csv'), 'utf8');
        const quyenRows = parse(quyenContent, { columns: true, skip_empty_lines: true, bom: true });

        for (const row of quyenRows) {
            const email = (row['Email'] || '').trim();
            const rawRole = (row['Role'] || '').trim();
            const name = row['Tên Nhân Viên'] || row['Tên'];
            if (!email) continue;

            const userId = profileMap.get(email);
            if (userId) {
                const role = ROLE_MAP[rawRole] || 'NhanVienSanXuat';
                await supabase.from('profiles').update({
                    role: role,
                    full_name: name || undefined
                }).eq('id', userId);
            }
        }
        console.log('Updated user roles.');
    } catch (e) { }

    const getProfileId = (name: string): string | null => {
        const email = usersMap.get(name);
        if (!email) return null;
        return profileMap.get(email) || null;
    };

    // 3. Import Customers (Khachhang.csv)
    console.log('Importing Customers...');
    try {
        const khContent = fs.readFileSync(path.join(DATA_DIR, 'Khachhang.csv'), 'utf8');
        const khRows = parse(khContent, { columns: true, skip_empty_lines: true, bom: true });

        const customersBatch = [];
        for (const row of khRows) {
            const code = row['MÃ KH'] || row['Mã KH'];
            const name = row['Tên KH'] || row['Tên khách hàng'];
            if (!code || !name) continue;

            customersBatch.push({
                code: code.trim(),
                name: name.trim(),
                phone: row['SĐT'] || null,
                address: row['Địa chỉ'] || null,
                email: row['Email'] || null,
                source: row['Nguồn khách'] || row['Nguồn KH'] || null,
                updated_at: new Date()
            });
        }

        if (customersBatch.length > 0) {
            for (let i = 0; i < customersBatch.length; i += 500) {
                const chunk = customersBatch.slice(i, i + 500);
                const { error } = await supabase.from('customers').upsert(chunk, { onConflict: 'code' });
                if (error) console.error('Error bulk upserting customers:', error.message);
                else console.log(`Upserted chunk ${i / 500 + 1} (${chunk.length} customers)`);
            }
        }
        console.log(`Finished processing ${customersBatch.length} customers.`);
    } catch (e) {
        console.error("Error importing customers", e);
    }

    // Reload Customer Map
    const customerMap = new Map<string, string>();
    const { data: dbCustomers } = await supabase.from('customers').select('id, code');
    dbCustomers?.forEach(c => customerMap.set(c.code, c.id));

    // 4. Import Orders (THÁNG 12-2025.don-hang.csv)
    console.log('Importing Orders...');
    let ordersCount = 0;
    try {
        const fileStream = fs.readFileSync(path.join(DATA_DIR, 'THÁNG 12-2025.don-hang.csv'), 'utf8');
        const ordersRows = parse(fileStream, { columns: true, skip_empty_lines: true, bom: true });

        let orderCodeKey = 'Mã đơn';
        let customerCodeKey = 'MÃ KH';

        if (ordersRows.length > 0) {
            const keys = Object.keys(ordersRows[0]);
            const findKey = (search: string) => keys.find(k => k.toLowerCase().includes(search.toLowerCase()));
            orderCodeKey = findKey('mã đơn') || findKey('ma don') || 'Mã đơn';
            customerCodeKey = findKey('mã kh') || findKey('ma kh') || 'MÃ KH';
            console.log(`Using Order Key: "${orderCodeKey}", Customer Key: "${customerCodeKey}"`);
        }

        for (const row of ordersRows) {
            const orderCode = row[orderCodeKey];
            if (!orderCode) continue; // Skip empty/invalid rows

            const customerCode = row[customerCodeKey];
            const customerId = customerMap.get(customerCode);
            const salesRepName = row['Nhân viên KD'];
            const salesRepId = salesRepName ? getProfileId(salesRepName) : null;
            const createdDate = row['Thời gian tạo'] ? parseDate(row['Thời gian tạo']) : new Date();
            const deliveryDate = row['Thời gian giao'] ? parseDate(row['Thời gian giao']) : null;

            const orderData = {
                order_code: orderCode,
                customer_id: customerId,
                sales_rep_id: salesRepId,
                description: row['Quy cách'],
                notes: row['Ghi chú đơn hàng'],
                total_amount_pre_vat: parseMoney(row['Tổng tiền trước VAT']),
                vat_amount: parseMoney(row['Tiền VAT']),
                total_amount: parseMoney(row['Tổng tiền sau VAT']) || (parseMoney(row['Tổng tiền trước VAT']) + parseMoney(row['Tiền VAT'])),
                deposit_amount: parseMoney(row['TIEN_COC']),
                remaining_amount: parseMoney(row['CON_LAI']),
                status: normalizeStatus(row['Tình trạng']),
                payment_status: normalizePaymentStatus(row['Thanh toán']),
                is_urgent: (row['Ưu Tiên'] || '').toLowerCase().includes('gấp'),
                delivery_date: deliveryDate,
                created_at: createdDate,
                has_design: !!row['THIET_KE_STATUS'],
                design_fee: parseMoney(row['PHI_THIET_KE']),
                has_large_print: !!row['IN_KHO_LON_STATUS'],
                large_print_fee: parseMoney(row['PHI_IN_KHO_LON']),
                has_be_demi: !!row['BE_DEMI_STATUS'],
                be_demi_fee: 0,
                has_ep_kim: !!row['EP_KIM_STATUS'],
                ep_kim_fee: 0
            };

            const { data: upsertedOrder, error: orderError } = await supabase.from('orders')
                .upsert(orderData, { onConflict: 'order_code' })
                .select('id')
                .single();

            if (orderError) {
                console.error(`Failed to insert order ${orderCode}:`, orderError.message);
                continue;
            }

            const orderId = upsertedOrder.id;
            ordersCount++;

            await processParticipants(orderId, row, getProfileId, supabase);
        }
        console.log(`Imported ${ordersCount} orders.`);
    } catch (e) {
        console.error("Error importing orders", e);
    }
}

async function processParticipants(orderId: string, row: any, getProfileId: any, supabase: any) {
    const mappings = [
        { col: 'BinhFileParticipants', stage: 'BinhFile' },
        { col: 'InParticipants', stage: 'In' },
        { col: 'ThanhPhamParticipants', stage: 'ThanhPham' }
    ];

    for (const m of mappings) {
        const jsonStr = row[m.col];
        if (!jsonStr || jsonStr === '[]') continue;
        try {
            const participants = JSON.parse(jsonStr);
            if (Array.isArray(participants)) {
                for (const p of participants) {
                    const profileId = getProfileId(p.name);
                    if (!profileId) continue;
                    await supabase.from('order_process_participants').insert({
                        order_id: orderId,
                        user_id: profileId,
                        stage: m.stage,
                        action: 'Joined',
                        started_at: p.time ? new Date(p.time) : new Date()
                    });
                }
            }
        } catch (e) { }
    }

    // Completion columns
    const completionCols = [
        { userCol: 'ThietKe_NguoiHT', timeCol: 'ThietKe_TGHT', stage: 'XuLyFile' }, // Mapped from 'Thiết kế'
        { userCol: 'InKhoLon_NguoiHT', timeCol: 'InKhoLon_TGHT', stage: 'In' }, // Mapped to In?
        { userCol: 'BeDemi_NguoiHT', timeCol: 'BeDemi_TGHT', stage: 'ThanhPham' }, // Mapped to ThanhPham?
        { userCol: 'EpKim_NguoiHT', timeCol: 'EpKim_TGHT', stage: 'ThanhPham' }
    ];
    // Note: Stage names in `order_process_participants` should be consistent.
    // I am using simplified mapping based on schema Enum or loose strings.

    for (const c of completionCols) {
        const names = row[c.userCol];
        const time = row[c.timeCol];
        if (!names) continue;

        const nameList = names.split(',').map((s: string) => s.trim());
        for (const name of nameList) {
            const profileId = getProfileId(name);
            if (!profileId) continue;
            await supabase.from('order_process_participants').insert({
                order_id: orderId,
                user_id: profileId,
                stage: c.stage,
                action: 'Completed',
                started_at: time ? parseDate(time) : new Date()
            });
        }
    }
}

importData().catch(e => console.error(e));
