import { Order } from '../types';
import { isAwaitingApprovalAtPrint, isSampleApprovedAtPrint } from './sampleApproval';

// Công thức đếm số trên badge của từng tab trạng thái / công đoạn.
// Dùng CHUNG cho 2 tập dữ liệu, không được chép lại ở chỗ khác:
//   - đơn tạo trong tháng đang chọn        -> số ĐỎ  (orderService.getAllOrderStatuses)
//   - đơn tháng liền trước còn chưa xong   -> số XANH (orderService.getPrevMonthPendingStatuses)
// Vì tập "chưa xong" đã loại HoanThanh/Huy từ truy vấn nên hoan_thanh/huy luôn ra 0,
// badge xanh ở 2 tab đó tự ẩn (badge chỉ hiện khi > 0).
export function buildTabCounts(rows: Partial<Order>[]): Record<string, number> {
    // Đơn sản xuất lại chỉ đếm ở tab riêng; mọi tab trạng thái / công đoạn đếm đơn thường
    const normalOrders = rows.filter((o: any) => !o.rework_of_order_id);

    return {
        all: rows.length,
        xuat_hoa_don: normalOrders.filter((o: any) => o.vat_amount > 0 && o.status !== 'Huy').length,
        nhan_file: normalOrders.filter((o: any) => ['Moi', 'TiepNhan', 'NhanFile'].includes(o.status)).length,
        xu_ly_file: normalOrders.filter((o: any) => o.status === 'XuLyFile').length,
        binh_file: normalOrders.filter((o: any) => o.status === 'BinhFile').length,
        in: normalOrders.filter((o: any) => o.status === 'In').length,
        cho_duyet_mau: normalOrders.filter((o: any) => isAwaitingApprovalAtPrint(o)).length,
        da_duyet_mau: normalOrders.filter((o: any) => isSampleApprovedAtPrint(o)).length,
        thanh_pham: normalOrders.filter((o: any) => o.status === 'ThanhPham').length,
        dong_goi: normalOrders.filter((o: any) => o.status === 'DongGoi').length,
        cho_giao_hang: normalOrders.filter((o: any) => o.status === 'ChoGiaoHang').length,
        da_giao_hang: normalOrders.filter((o: any) => o.status === 'DaGiaoHang').length,
        hoan_thanh: normalOrders.filter((o: any) => o.status === 'HoanThanh').length,
        gap: normalOrders.filter((o: any) => o.is_urgent && o.status !== 'Huy' && o.status !== 'HoanThanh').length,
        huy: normalOrders.filter((o: any) => o.status === 'Huy').length,
        tam_ngung: normalOrders.filter((o: any) => o.status === 'TamNgung').length,

        // Task Counts
        thiet_ke: normalOrders.filter((o: any) => o.has_design).length,
        in_kho_lon: normalOrders.filter((o: any) => o.has_large_print).length,
        be_demi: normalOrders.filter((o: any) => o.has_be_demi).length,
        gia_cong_ngoai: normalOrders.filter((o: any) => o.has_gia_cong_ngoai).length,
        ep_kim: normalOrders.filter((o: any) => o.has_ep_kim).length,

        // Đơn sản xuất lại đang làm (chưa xong, chưa hủy)
        san_xuat_lai: rows.filter((o: any) => o.rework_of_order_id && o.status !== 'HoanThanh' && o.status !== 'Huy').length,
    };
}

// Tháng liền trước tháng đang chọn. JS tự chuẩn hoá biên năm:
// tháng 1/2026 -> 01/12/2025 .. 31/12/2025.
export function prevMonthRange(filterMonth: number, filterYear: number) {
    return {
        prevStart: new Date(filterYear, filterMonth - 2, 1),
        prevEnd: new Date(filterYear, filterMonth - 1, 0, 23, 59, 59),
    };
}

// Nhãn hiển thị cho tháng liền trước, vd "tháng 9" (kèm năm nếu khác năm đang chọn).
export function prevMonthLabel(filterMonth: number, filterYear: number): string {
    const { prevStart } = prevMonthRange(filterMonth, filterYear);
    const m = prevStart.getMonth() + 1;
    const y = prevStart.getFullYear();
    return y === filterYear ? `tháng ${m}` : `tháng ${m}/${y}`;
}
