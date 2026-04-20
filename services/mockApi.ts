
import { Order, Customer, DashboardStats, FinancialReportData, CustomerAnalytics } from '../types';
import { supabase } from './supabaseClient';

// --- MOCK DATA FOR DEMO MODE ---
const MOCK_ORDERS: Order[] = [
    {
        id: 1,
        madon: "25PD0412.0107",
        tenKH: "HIỀN - IN CHẤT LƯỢNG VIỆT",
        maKH: "KH001",
        nguonKH: "Zalo",
        quycach: "In nhãn phụ:\n1/ file: FILE 6 NHÃN_IN\n2/ file: FILE 16 NHÃN (in decal giấy cán mờ bế demi)_IN\nDECAL GIẤY, CÁN MỜ, BẾ DEMI : Tổng 11tr800\nưu tiên làm file 16 nhãn để giao trước",
        ghiChuDonHang: "10h00 sáng thứ 2\nưu tiên làm mục 2 để giao trước",
        tongTienTruocVAT: 11800000,
        vatRate: 0,
        tienVAT: 0,
        tongTienSauVAT: 11800000,
        thanhToan: 'Công nợ',
        tienCoc: 0,
        hinhThucTT: 'Chuyển khoản',
        ngayGiaoHang: "2025-12-08T10:00",
        ngayTao: "2025-12-04",
        nhanVien: "Lê Thị Thủy",
        tinhTrang: "In",
        uuTien: "Bình thường",
        thietKe: false, inKhoLon: false, beDemi: true, giaCongNgoai: false, epKim: false,
        binhFileParticipants: [],
        inParticipants: [],
        thanhPhamParticipants: []
    },
    {
        id: 2,
        madon: "25PD0412.0108",
        tenKH: "CÔNG TY ABC",
        maKH: "KH002",
        nguonKH: "Facebook",
        quycach: "In tờ rơi A4, C150, in 2 mặt, cán màng mờ 2 mặt. Số lượng: 1000 tờ.",
        ghiChuDonHang: "Giao gấp chiều nay",
        tongTienTruocVAT: 2500000,
        vatRate: 8,
        tienVAT: 200000,
        tongTienSauVAT: 2700000,
        thanhToan: 'Đã cọc',
        tienCoc: 1000000,
        hinhThucTT: 'Tiền mặt',
        ngayGiaoHang: "2025-12-04T17:00",
        ngayTao: "2025-12-04",
        nhanVien: "Nguyễn Văn A",
        tinhTrang: "Bình File",
        uuTien: "Gấp",
        thietKe: true, inKhoLon: false, beDemi: false, giaCongNgoai: false, epKim: false,
        binhFileParticipants: [{ name: "Design Team", time: "10:30 04/12/2025" }],
        inParticipants: [],
        thanhPhamParticipants: []
    }
];

const MOCK_CUSTOMERS: Customer[] = [
    { maKH: "KH001", tenKH: "HIỀN - IN CHẤT LƯỢNG VIỆT", sdt: "0909123456", email: "hien@icloud.com", diachi: "123 Đường A, Q1", nguonKH: "Zalo", ghiChuCRM: "Khách VIP, thường in decal" },
    { maKH: "KH002", tenKH: "CÔNG TY ABC", sdt: "0912345678", email: "contact@abc.com", diachi: "456 Đường B, Q3", nguonKH: "Facebook", ghiChuCRM: "Khách mới" }
];

// Helper variables for mock data persistence in memory
let localOrders = [...MOCK_ORDERS];
let localCustomers = [...MOCK_CUSTOMERS];

// Helper để map từ DB (snake_case) sang App (camelCase)
const mapOrderFromDB = (data: any): Order => ({
    id: data.id,
    madon: data.madon,
    tenKH: data.ten_kh,
    maKH: data.ma_kh,
    sdt: data.sdt,
    email: data.email,
    diachi: data.diachi,
    nguonKH: data.nguon_kh,
    quycach: data.quycach,
    ghiChuDonHang: data.ghi_chu_don_hang,
    tongTienTruocVAT: data.tong_tien_truoc_vat,
    vatRate: data.vat_rate,
    tienVAT: data.tien_vat,
    tongTienSauVAT: data.tong_tien_sau_vat,
    thanhToan: data.thanh_toan,
    tienCoc: data.tien_coc,
    hinhThucTT: data.hinh_thuc_tt,
    ngayGiaoHang: data.ngay_giao_hang,
    ngayTao: data.ngay_tao,
    nhanVien: data.nhan_vien,
    tinhTrang: data.tinh_trang,
    uuTien: data.uu_tien,

    thietKe: data.thiet_ke,
    thietKeStatus: data.thiet_ke_status,
    inKhoLon: data.in_kho_lon,
    inKhoLonStatus: data.in_kho_lon_status,
    beDemi: data.be_demi,
    beDemiStatus: data.be_demi_status,
    giaCongNgoai: data.gia_cong_ngoai,
    giaCongNgoaiStatus: data.gia_cong_ngoai_status,
    epKim: data.ep_kim,
    epKimStatus: data.ep_kim_status,

    binhFileParticipants: data.binh_file_participants || [],
    inParticipants: data.in_participants || [],
    thanhPhamParticipants: data.thanh_pham_participants || []
});

// Helper để map từ App (camelCase) sang DB (snake_case)
const mapOrderToDB = (order: Partial<Order>) => {
    const mapped: any = {};
    if (order.madon !== undefined) mapped.madon = order.madon;
    if (order.tenKH !== undefined) mapped.ten_kh = order.tenKH;
    if (order.maKH !== undefined) mapped.ma_kh = order.maKH;
    if (order.sdt !== undefined) mapped.sdt = order.sdt;
    if (order.email !== undefined) mapped.email = order.email;
    if (order.diachi !== undefined) mapped.diachi = order.diachi;
    if (order.nguonKH !== undefined) mapped.nguon_kh = order.nguonKH;
    if (order.quycach !== undefined) mapped.quycach = order.quycach;
    if (order.ghiChuDonHang !== undefined) mapped.ghi_chu_don_hang = order.ghiChuDonHang;
    if (order.tongTienTruocVAT !== undefined) mapped.tong_tien_truoc_vat = order.tongTienTruocVAT;
    if (order.vatRate !== undefined) mapped.vat_rate = order.vatRate;
    if (order.tienVAT !== undefined) mapped.tien_vat = order.tienVAT;
    if (order.tongTienSauVAT !== undefined) mapped.tong_tien_sau_vat = order.tongTienSauVAT;
    if (order.thanhToan !== undefined) mapped.thanh_toan = order.thanhToan;
    if (order.tienCoc !== undefined) mapped.tien_coc = order.tienCoc;
    if (order.hinhThucTT !== undefined) mapped.hinh_thuc_tt = order.hinhThucTT;
    if (order.ngayGiaoHang !== undefined) mapped.ngay_giao_hang = order.ngayGiaoHang;
    if (order.nhanVien !== undefined) mapped.nhan_vien = order.nhanVien;
    if (order.tinhTrang !== undefined) mapped.tinh_trang = order.tinhTrang;
    if (order.uuTien !== undefined) mapped.uu_tien = order.uuTien;

    if (order.thietKe !== undefined) mapped.thiet_ke = order.thietKe;
    if (order.inKhoLon !== undefined) mapped.in_kho_lon = order.inKhoLon;
    if (order.beDemi !== undefined) mapped.be_demi = order.beDemi;
    if (order.giaCongNgoai !== undefined) mapped.gia_cong_ngoai = order.giaCongNgoai;
    if (order.epKim !== undefined) mapped.ep_kim = order.epKim;

    // Status tasks update
    if (order.thietKeStatus !== undefined) mapped.thiet_ke_status = order.thietKeStatus;
    if (order.inKhoLonStatus !== undefined) mapped.in_kho_lon_status = order.inKhoLonStatus;
    if (order.beDemiStatus !== undefined) mapped.be_demi_status = order.beDemiStatus;
    if (order.giaCongNgoaiStatus !== undefined) mapped.gia_cong_ngoai_status = order.giaCongNgoaiStatus;
    if (order.epKimStatus !== undefined) mapped.ep_kim_status = order.epKimStatus;

    return mapped;
};

export const api = {
    getOrders: async (filterStatus: string): Promise<Order[]> => {
        if (!supabase) {
            // --- MOCK LOGIC ---
            let result = [...localOrders];
            if (filterStatus !== "Tất cả" && filterStatus !== "📊 Tổng quan") {
                if (filterStatus === "Gấp") {
                    result = result.filter(o => o.uuTien === 'Gấp');
                } else if (["Thiết Kế", "In Khổ Lớn", "Bế Demi", "Gia công ngoài", "Ép Kim"].includes(filterStatus)) {
                    if (filterStatus === "Thiết Kế") result = result.filter(o => o.thietKe);
                    if (filterStatus === "In Khổ Lớn") result = result.filter(o => o.inKhoLon);
                    if (filterStatus === "Bế Demi") result = result.filter(o => o.beDemi);
                    if (filterStatus === "Gia công ngoài") result = result.filter(o => o.giaCongNgoai);
                    if (filterStatus === "Ép Kim") result = result.filter(o => o.epKim);
                } else {
                    result = result.filter(o => o.tinhTrang === filterStatus);
                }
            }
            return Promise.resolve(result);
        }

        // --- SUPABASE LOGIC ---
        let query = supabase.from('orders').select('*').order('created_at', { ascending: false });

        if (filterStatus !== "Tất cả" && filterStatus !== "📊 Tổng quan") {
            if (filterStatus === "Gấp") {
                query = query.eq('uu_tien', 'Gấp');
            } else if (["Thiết Kế", "In Khổ Lớn", "Bế Demi", "Gia công ngoài", "Ép Kim"].includes(filterStatus)) {
                if (filterStatus === "Thiết Kế") query = query.eq('thiet_ke', true);
                if (filterStatus === "In Khổ Lớn") query = query.eq('in_kho_lon', true);
                if (filterStatus === "Bế Demi") query = query.eq('be_demi', true);
                if (filterStatus === "Gia công ngoài") query = query.eq('gia_cong_ngoai', true);
                if (filterStatus === "Ép Kim") query = query.eq('ep_kim', true);
            } else {
                query = query.eq('tinh_trang', filterStatus);
            }
        }

        const { data, error } = await query;
        if (error) {
            console.error("Error fetching orders from Supabase:", error);
            return [];
        }
        return data.map(mapOrderFromDB);
    },

    getOrderCounts: async (): Promise<Record<string, number>> => {
        if (!supabase) {
            // --- MOCK LOGIC ---
            const counts: Record<string, number> = { "Tất cả": localOrders.length };
            ["Xuất hóa đơn", "Nhận File", "Bình File", "In", "Thành Phẩm", "Đóng gói", "Chờ giao hàng", "Đã hoàn thành", "Gấp", "Đã hủy", "Thiết Kế", "In Khổ Lớn", "Bế Demi", "Gia công ngoài", "Ép Kim"].forEach(k => counts[k] = 0);

            localOrders.forEach(o => {
                if (counts[o.tinhTrang] !== undefined) counts[o.tinhTrang]++;
                else counts[o.tinhTrang] = 1;

                if (o.uuTien === 'Gấp') counts['Gấp']++;
                if (o.thietKe) counts['Thiết Kế']++;
                if (o.inKhoLon) counts['In Khổ Lớn']++;
                if (o.beDemi) counts['Bế Demi']++;
                if (o.giaCongNgoai) counts['Gia công ngoài']++;
                if (o.epKim) counts['Ép Kim']++;
                if (o.tinhTrang === 'Đã hoàn thành') counts['Xuất hóa đơn']++;
            });
            return Promise.resolve(counts);
        }

        // --- SUPABASE LOGIC ---
        const { data, error } = await supabase.from('orders').select('tinh_trang, uu_tien, thiet_ke, in_kho_lon, be_demi, gia_cong_ngoai, ep_kim, thanh_toan');

        if (error || !data) return {};

        const counts: Record<string, number> = { "Tất cả": data.length };

        ["Xuất hóa đơn", "Nhận File", "Bình File", "In", "Thành Phẩm", "Đóng gói", "Chờ giao hàng", "Đã hoàn thành", "Gấp", "Đã hủy", "Thiết Kế", "In Khổ Lớn", "Bế Demi", "Gia công ngoài", "Ép Kim"].forEach(k => counts[k] = 0);

        data.forEach((o: any) => {
            if (counts[o.tinh_trang] !== undefined) counts[o.tinh_trang]++;
            else counts[o.tinh_trang] = 1;

            if (o.uu_tien === 'Gấp') counts['Gấp']++;
            if (o.thiet_ke) counts['Thiết Kế']++;
            if (o.in_kho_lon) counts['In Khổ Lớn']++;
            if (o.be_demi) counts['Bế Demi']++;
            if (o.gia_cong_ngoai) counts['Gia công ngoài']++;
            if (o.ep_kim) counts['Ép Kim']++;

            if (o.tinh_trang === 'Đã hoàn thành') counts['Xuất hóa đơn']++;
        });

        return counts;
    },

    getStats: async (): Promise<DashboardStats> => {
        let orders: any[] = [];

        if (!supabase) {
            // --- MOCK LOGIC ---
            orders = localOrders;
        } else {
            // --- SUPABASE LOGIC ---
            const { data } = await supabase.from('orders').select('tong_tien_sau_vat, tong_tien_truoc_vat, tinh_trang, ten_kh');
            orders = data || [];
        }

        // Common Logic
        if (orders.length === 0) return { ordersCount: 0, revenue: 0, revenueNoVAT: 0, designRevenue: 0, newCustomers: 0, returningCustomers: 0, statusCounts: {}, monthlyRevenue: [] };

        const revenue = orders.reduce((sum, o) => sum + (o.tongTienSauVAT || o.tong_tien_sau_vat || 0), 0);
        const revenueNoVAT = orders.reduce((sum, o) => sum + (o.tongTienTruocVAT || o.tong_tien_truoc_vat || 0), 0);
        const statusCounts: Record<string, number> = {};
        orders.forEach(o => {
            const status = o.tinhTrang || o.tinh_trang;
            statusCounts[status] = (statusCounts[status] || 0) + 1;
        });

        return {
            ordersCount: orders.length,
            revenue,
            revenueNoVAT,
            designRevenue: revenue * 0.05,
            newCustomers: 12,
            returningCustomers: Math.max(0, orders.length - 12),
            statusCounts,
            monthlyRevenue: [
                { date: '01/12', value: revenue * 0.1 },
                { date: '10/12', value: revenue * 0.3 },
                { date: '20/12', value: revenue * 0.4 },
                { date: '30/12', value: revenue * 0.2 },
            ]
        };
    },

    saveOrder: async (order: Partial<Order>): Promise<void> => {
        if (!supabase) {
            // --- MOCK LOGIC ---
            if (order.id) {
                localOrders = localOrders.map(o => o.id === order.id ? { ...o, ...order } : o);
            } else {
                const newOrder: Order = {
                    ...(order as Order),
                    id: localOrders.length + 1,
                    madon: `DH${Math.floor(Math.random() * 100000)}`,
                    ngayTao: new Date().toISOString().split('T')[0],
                    binhFileParticipants: [], inParticipants: [], thanhPhamParticipants: [],
                    thietKe: order.thietKe || false, inKhoLon: order.inKhoLon || false, beDemi: order.beDemi || false, giaCongNgoai: order.giaCongNgoai || false, epKim: order.epKim || false
                };
                localOrders.unshift(newOrder);
            }
            return Promise.resolve();
        }

        // --- SUPABASE LOGIC ---
        const dbData = mapOrderToDB(order);

        if (order.id) {
            const { error } = await supabase.from('orders').update(dbData).eq('id', order.id);
            if (error) throw error;
        } else {
            const newOrderData = {
                ...dbData,
                madon: `DH${Math.floor(Math.random() * 100000)}`,
                ngay_tao: new Date().toISOString(),
                nhan_vien: 'Admin',
                binh_file_participants: [],
                in_participants: [],
                thanh_pham_participants: []
            };
            const { error } = await supabase.from('orders').insert([newOrderData]);
            if (error) throw error;
        }
    },

    getAllCustomers: async (): Promise<Customer[]> => {
        if (!supabase) return Promise.resolve(localCustomers);

        const { data, error } = await supabase.from('customers').select('*');
        if (error) return [];
        return data.map((c: any) => ({
            maKH: c.ma_kh,
            tenKH: c.ten_kh,
            sdt: c.sdt,
            email: c.email,
            diachi: c.diachi,
            nguonKH: c.nguon_kh,
            ghiChuCRM: c.ghi_chu_crm
        }));
    },

    getCustomerAnalytics: async (maKH: string): Promise<CustomerAnalytics> => {
        let orders: any[] = [];
        if (!supabase) {
            orders = localOrders.filter(o => o.maKH === maKH);
        } else {
            const { data } = await supabase.from('orders').select('tong_tien_sau_vat, created_at').eq('ma_kh', maKH);
            orders = data || [];
        }

        if (orders.length === 0) {
            return { totalRevenue: 0, orderCount: 0, lastOrderDate: 'N/A', avgDaysBetweenOrders: 0 };
        }

        const totalRevenue = orders.reduce((sum, o) => sum + (o.tongTienSauVAT || o.tong_tien_sau_vat || 0), 0);
        // Simple mock logic for date since DB formats vary
        return {
            totalRevenue,
            orderCount: orders.length,
            lastOrderDate: new Date().toLocaleDateString('vi-VN'),
            avgDaysBetweenOrders: 5
        };
    },

    saveCustomer: async (customer: Customer): Promise<void> => {
        if (!supabase) {
            const exists = localCustomers.find(c => c.maKH === customer.maKH);
            if (exists) {
                localCustomers = localCustomers.map(c => c.maKH === customer.maKH ? customer : c);
            } else {
                localCustomers.push(customer);
            }
            return Promise.resolve();
        }

        const dbData = {
            ma_kh: customer.maKH,
            ten_kh: customer.tenKH,
            sdt: customer.sdt,
            email: customer.email,
            diachi: customer.diachi,
            nguon_kh: customer.nguonKH,
            ghi_chu_crm: customer.ghiChuCRM
        };
        const { error } = await supabase.from('customers').upsert(dbData);
        if (error) throw error;
    },

    getFinancialReport: async (startDate: string, endDate: string): Promise<FinancialReportData> => {
        let orders: any[] = [];
        if (!supabase) {
            // In mock mode, just return all orders for simplicity in this demo
            orders = localOrders;
        } else {
            const { data, error } = await supabase.from('orders')
                .select('total_amount, deposit_amount, remaining_amount, payment_status, payment_method_deposit, payment_method_remaining')
                .gte('created_at', startDate)
                .lte('created_at', endDate + 'T23:59:59');
            if (error) {
                console.error('Financial report query error:', error);
            }
            orders = data || [];
        }

        if (orders.length === 0) return { tongThuTienMat: 0, tongThuChuyenKhoan: 0, tongDoanhThuDaThu: 0, congNoMoiPhatSinh: 0 };

        let tienMat = 0;
        let chuyenKhoan = 0;
        let daThu = 0;
        let congNo = 0;

        orders.forEach((o: any) => {
            const total = o.total_amount || o.tongTienSauVAT || o.tong_tien_sau_vat || 0;
            const deposit = o.deposit_amount || o.tienCoc || o.tien_coc || 0;
            const remaining = o.remaining_amount || 0;
            const status = o.payment_status || o.thanhToan || o.thanh_toan || '';
            const depositMethod = o.payment_method_deposit || o.hinhThucTT || o.hinh_thuc_tt || '';
            const remainingMethod = o.payment_method_remaining || '';

            // Handle both enum values (DB) and Vietnamese text (mock)
            if (status === 'DaThanhToan' || status === 'Đã thanh toán') {
                daThu += total;
                if (depositMethod === 'Tiền mặt') tienMat += deposit;
                else chuyenKhoan += deposit;
                const paidRemaining = total - deposit;
                if (paidRemaining > 0) {
                    if (remainingMethod === 'Tiền mặt') tienMat += paidRemaining;
                    else chuyenKhoan += paidRemaining;
                }
            } else if (status === 'DaCoc' || status === 'Đã cọc') {
                daThu += deposit;
                if (depositMethod === 'Tiền mặt') tienMat += deposit;
                else if (deposit > 0) chuyenKhoan += deposit;
                congNo += remaining > 0 ? remaining : (total - deposit);
            } else if (status === 'CongNo' || status === 'Công nợ') {
                congNo += total;
            } else {
                // ChuaThanhToan or other
                congNo += total;
            }
        });

        return {
            tongThuTienMat: tienMat,
            tongThuChuyenKhoan: chuyenKhoan,
            tongDoanhThuDaThu: daThu,
            congNoMoiPhatSinh: congNo
        };
    },

    joinStage: async (orderId: number, stage: 'binhFile' | 'in' | 'thanhPham'): Promise<void> => {
        const newParticipant = { name: 'Admin', time: new Date().toLocaleString('vi-VN') };

        if (!supabase) {
            localOrders = localOrders.map(o => {
                if (o.id === orderId) {
                    const key = stage === 'binhFile' ? 'binhFileParticipants' : stage === 'in' ? 'inParticipants' : 'thanhPhamParticipants';
                    return { ...o, [key]: [...o[key], newParticipant] };
                }
                return o;
            });
            return Promise.resolve();
        }

        const colMap = { 'binhFile': 'binh_file_participants', 'in': 'in_participants', 'thanhPham': 'thanh_pham_participants' };
        const colName = colMap[stage];
        const { data } = await supabase.from('orders').select(colName).eq('id', orderId).single();
        const currentParticipants = data ? data[colName] : [];
        await supabase.from('orders').update({ [colName]: [...currentParticipants, newParticipant] }).eq('id', orderId);
    },

    undoJoinStage: async (orderId: number, stage: 'binhFile' | 'in' | 'thanhPham'): Promise<void> => {
        if (!supabase) {
            localOrders = localOrders.map(o => {
                if (o.id === orderId) {
                    const key = stage === 'binhFile' ? 'binhFileParticipants' : stage === 'in' ? 'inParticipants' : 'thanhPhamParticipants';
                    return { ...o, [key]: o[key].filter(p => p.name !== 'Admin') };
                }
                return o;
            });
            return Promise.resolve();
        }

        const colMap = { 'binhFile': 'binh_file_participants', 'in': 'in_participants', 'thanhPham': 'thanh_pham_participants' };
        const colName = colMap[stage];
        const { data } = await supabase.from('orders').select(colName).eq('id', orderId).single();
        let currentParticipants = data ? data[colName] : [];
        currentParticipants = currentParticipants.filter((p: any) => p.name !== 'Admin');
        await supabase.from('orders').update({ [colName]: currentParticipants }).eq('id', orderId);
    },

    updateTaskStatus: async (orderId: number, task: string, status: 'complete' | 'undo'): Promise<void> => {
        const newStatus = status === 'complete' ? 'Đã hoàn thành' : 'Chưa làm';
        const taskKey = task + 'Status'; // e.g., thietKeStatus

        if (!supabase) {
            localOrders = localOrders.map(o => o.id === orderId ? { ...o, [taskKey]: newStatus } : o);
            return Promise.resolve();
        }

        const colMap: Record<string, string> = {
            'thietKe': 'thiet_ke_status',
            'inKhoLon': 'in_kho_lon_status',
            'beDemi': 'be_demi_status',
            'giaCongNgoai': 'gia_cong_ngoai_status',
            'epKim': 'ep_kim_status'
        };
        const dbCol = colMap[task];
        if (dbCol) {
            await supabase.from('orders').update({ [dbCol]: newStatus }).eq('id', orderId);
        }
    }
};
