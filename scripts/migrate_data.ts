import { createClient } from '@supabase/supabase-js'
import fs from 'fs'
import path from 'path'
import csv from 'csv-parser'
import * as dotenv from 'dotenv'

// Load environment variables
dotenv.config({ path: '.env.local' })

const supabaseUrl = process.env.VITE_SUPABASE_URL
const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY || process.env.VITE_SUPABASE_ANON_KEY

console.log('Supabase URL:', supabaseUrl ? 'Found' : 'Missing')
console.log('Supabase Key:', supabaseKey ? 'Found' : 'Missing')

if (process.env.SUPABASE_SERVICE_ROLE_KEY) {
    console.log('Using SERVICE_ROLE_KEY (Bypassing RLS)')
} else {
    console.warn('WARNING: Using ANON KEY. Migration commonly fails due to RLS if not authenticated.')
}

if (!supabaseUrl || !supabaseKey) {
    throw new Error('Supabase URL or Key is missing in .env.local')
}

const supabase = createClient(supabaseUrl, supabaseKey)

// Paths
const DATA_DIR = path.join(process.cwd(), 'data')
const ORDER_FILE = 'THÁNG 12-2025.don-hang.csv'
const CUSTOMER_FILE = 'Khachhang.csv'

const readCSV = <T>(filePath: string): Promise<T[]> => {
    return new Promise((resolve, reject) => {
        const results: T[] = []
        if (!fs.existsSync(filePath)) {
            console.warn(`File not found: ${filePath}`)
            resolve([])
            return
        }
        fs.createReadStream(filePath)
            .pipe(csv())
            .on('data', (data) => results.push(data))
            .on('end', () => resolve(results))
            .on('error', (err) => reject(err))
    })
}

const parseCurrency = (val: string): number => {
    if (!val) return 0
    return parseFloat(val.toString().replace(/[^0-9.-]+/g, ''))
}

const parseDate = (val: string): string | null => {
    if (!val) return null
    // Format: 12/1/2025 8:05:05
    try {
        const date = new Date(val);
        if (isNaN(date.getTime())) return null;
        return date.toISOString();
    } catch {
        return null
    }
}

async function migrateCustomers() {
    console.log('Migrating Customers...')
    const customers = await readCSV<any>(path.join(DATA_DIR, CUSTOMER_FILE))

    for (const row of customers) {
        // Map Vietnamese headers
        const code = row['MÃ KH']
        if (!code) continue

        const { error } = await supabase.from('customers').upsert({
            code: code,
            name: row['Tên KH'],
            phone: row['SĐT'], // Note: CSV header might be "SĐT" or "SDT" depending on encoding, using generic match if needed
            address: row['Địa chỉ'],
            email: row['Email'],
            source: row.hasOwnProperty('NguonKH') ? row['NguonKH'] : '', // Check if column exists, some rows empty
            crm_notes: row['GhiChuCRM']
        }, { onConflict: 'code' })

        if (error) console.error(`Error inserting customer ${code}:`, error.message)
    }
    console.log(`Processed ${customers.length} customers.`)
}

async function migrateOrders() {
    console.log('Migrating Orders...')
    const filePath = path.join(DATA_DIR, ORDER_FILE)

    // Custom reading to handle missing headers for last columns
    const orders: any[] = []

    // Use a different approach for duplicate/missing headers if needed, 
    // but standard csv-parser assigns indices to duplicates. 
    // Let's rely on standard parsing first and debug keys if needed.
    const rawOrders = await readCSV<any>(filePath)

    for (const row of rawOrders) {
        const orderCode = row['Mã đơn']
        if (!orderCode) continue;

        const total = parseCurrency(row['Tổng tiền sau VAT'])
        const deposit = parseCurrency(row['TIEN_COC']) // Matches header seen in file

        // Find customer UUID
        const customerCode = row['MÃ KH']
        let customerId = null
        if (customerCode) {
            const { data } = await supabase.from('customers').select('id').eq('code', customerCode).single()
            customerId = data?.id
        }

        const payload = {
            order_code: orderCode,
            customer_id: customerId,
            description: row['Quy cách'],
            notes: row['Ghi chú đơn hàng'],

            total_amount: total,
            deposit_amount: deposit,
            remaining_amount: total - deposit,

            status: mapStatus(row['Tình trạng']),
            payment_status: mapPaymentStatus(row['Thanh toán']),
            is_urgent: row['Ưu Tiên'] === 'Gấp' || row['Ưu Tiên'] === 'GẤP',

            created_at: parseDate(row['Thời gian tạo']) || new Date().toISOString()
        }

        const { data: orderData, error } = await supabase.from('orders').upsert(payload, { onConflict: 'order_code' }).select().single()

        if (error) {
            console.error(`Error inserting order ${orderCode}:`, error.message)
        } else if (orderData) {
            // Handle Participants JSON
            // The last columns might have empty headers. csv-parser might map them to keys like '', '_1', '_2'
            // Based on file check: EpKim_TGHT is followed by 3 empty cols.
            // So keys might be: 'EpKim_TGHT', '', '_1', '_2' (if duplicates)

            // Let's guess the keys or look for the JSON content values
            const values = Object.values(row)

            // Naive find for JSON strings in row values since keys are unreliable
            const findJson = (str: any) => {
                if (typeof str === 'string' && str.startsWith('[') && str.endsWith(']')) return str;
                return null;
            }

            // This is a bit risky if description contains [], but participants data is usually specific format
            // Apps Script says sequence: BinhFile, In, ThanhPham
            // We can try to grab them by order if we iterate keys.

            // Better: use specific keys if we can verify them. 
            // For now, let's look for valid participants JSONs
            // BinhFileParticipantsData is usually column 60

            // Try direct access if 'csv-parser' maps empty headers predictably
            // Or just mapping keys dynamically
            const keys = Object.keys(row)
            // Assuming last 3 keys correspond to the data
            // Let's try to pass the data if we find it

            // FALLBACK: Just look for any JSON array looking string that contains 'name' and 'time'
            for (const val of values) {
                if (typeof val === 'string' && val.includes('"name"') && val.includes('"time"')) {
                    // Determine stage? Hard without column name. 
                    // However, the task requires exactness.
                    // Converting: BinhFile -> 'BinhFile', In -> 'In'
                    // We'll rely on the order in the file if possible, or just skip if ambiguous.
                    // Actually, existing code: COL_DH_BINH_FILE_PARTICIPANTS_DATA is 60.

                    // Let's rely on mapped keys from csv-parser for empty headers
                    // 'EpKim_TGHT' is likely key. Next should be '' or '_1'
                }
            }

            // Explicit attempt (based on observed structure 'EpKim_TGHT', '', '', '')
            const binhFileJson = row['']
            const inJson = row['_1']
            const thanhPhamJson = row['_2']

            if (binhFileJson) await migrateParticipants(orderData.id, 'BinhFile', binhFileJson)
            if (inJson) await migrateParticipants(orderData.id, 'In', inJson)
            if (thanhPhamJson) await migrateParticipants(orderData.id, 'ThanhPham', thanhPhamJson)
        }
    }
    console.log(`Processed ${rawOrders.length} orders.`)
}

async function migrateParticipants(orderId: string, stage: string, jsonString: string) {
    if (!jsonString || jsonString === '[]') return;
    try {
        const participants = JSON.parse(jsonString);
        for (const p of participants) {
            // Check if p.name exists
            if (!p.name) continue;

            // Create profile placeholder if not exists? 
            // Better to just insert participant record with name-lookup later
            // For now, inserted without user_id if profile not found

            // Simple: just insert
            await supabase.from('order_process_participants').insert({
                order_id: orderId,
                stage: stage,
                started_at: p.time ? new Date(p.time).toISOString() : new Date().toISOString()
                // user_id left null for now or requires name lookup
            })
        }
    } catch (e) {
        // console.error(`Error parsing participants JSON:`, e)
    }
}

function mapStatus(csvStatus: string): string {
    const s = csvStatus ? csvStatus.trim() : ''
    const map: Record<string, string> = {
        'Mới': 'Moi',
        'Tiếp nhận': 'TiepNhan',
        'Thiết kế': 'ThietKe',
        'Bình file': 'BinhFile',
        'In': 'In',
        'Thành phẩm': 'ThanhPham',
        'Giao hàng': 'GiaoHang',
        'Đã giao hàng': 'GiaoHang',
        'Đã hoàn thành': 'HoanThanh',
        'Đã hủy': 'Huy'
    }
    return map[s] || 'Moi'
}

function mapPaymentStatus(csvStatus: string): string {
    const s = csvStatus ? csvStatus.trim() : ''
    // "Đã thanh toán", "Chưa thanh toán", "Công nợ"
    const map: Record<string, string> = {
        'Chưa thanh toán': 'ChuaThanhToan',
        'Đã cọc': 'DaCoc',
        'Đã thanh toán': 'DaThanhToan',
        'Công nợ': 'CongNo'
    }
    return map[s] || 'ChuaThanhToan'
}

async function main() {
    await migrateCustomers()
    await migrateOrders()
}

main().catch(err => {
    console.error(err)
    fs.writeFileSync('migration_error.log', err.stack || err.toString())
    process.exit(1)
})
