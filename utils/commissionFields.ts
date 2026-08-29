/**
 * Nguồn duy nhất cho danh sách khâu tính hoa hồng sản xuất.
 *
 * DÙNG CHUNG cho modal Chỉnh sửa nhân viên và Bảng % hoa hồng — đừng copy
 * thành bản thứ hai. Thêm khâu ở một chỗ mà quên chỗ kia sẽ đẻ lại đúng lỗi
 * "thiếu key = mất tiền" đã phải đi vá (xem fix_stage_rate_no_fallback.sql).
 *
 * Khoá phải khớp ĐÚNG giá trị order_process_participants.stage mà SQL join vào.
 * Khâu nào không có key trong JSON thì hàm tính thưởng hiểu là 0 (không còn lấy
 * mức chung của công ty nữa). Vì vậy khi lưu phải ghi ĐỦ mọi key ở 2 mảng này,
 * đừng chỉ ghi ô nào Admin gõ vào.
 *
 * Ép Kim cố tình có mặt ở CẢ HAI mảng, không phải trùng lặp:
 *   - Đơn CÓ phí ép kim  -> thưởng tính trên phí đó, dùng commission_subtasks.EpKim
 *   - Đơn KHÔNG có phí   -> thưởng tính trên giá trị đơn, dùng commission_stages.EpKim
 * (xem CASE stage_value trong setup_production_defect_deduction.sql)
 */

export interface CommissionField {
    /** Khoá lưu trong JSON, khớp order_process_participants.stage */
    key: string;
    /** Nhãn đầy đủ, dùng trong modal chỉnh sửa */
    label: string;
    /** Nhãn ngắn cho tiêu đề cột bảng ma trận (cột hẹp) */
    shortLabel: string;
}

export const STAGE_COMMISSION_FIELDS: CommissionField[] = [
    { key: 'NhanFile', label: 'Nhận File', shortLabel: 'Nhận File' },
    { key: 'XuLyFile', label: 'Xử lý File', shortLabel: 'Xử lý File' },
    { key: 'BinhFile', label: 'Bình File', shortLabel: 'Bình File' },
    { key: 'In', label: 'In ấn', shortLabel: 'In ấn' },
    { key: 'ThanhPham', label: 'Thành phẩm', shortLabel: 'Thành phẩm' },
    { key: 'EpKim', label: 'Ép Kim (đơn không có phí ép kim)', shortLabel: 'Ép Kim' },
    { key: 'DongGoi', label: 'Đóng gói', shortLabel: 'Đóng gói' },
    { key: 'GiaoHang', label: 'Giao hàng', shortLabel: 'Giao hàng' },
    { key: 'DaGiaoHang', label: 'Đã giao hàng', shortLabel: 'Đã giao' },
];

export const SUBTASK_COMMISSION_FIELDS: CommissionField[] = [
    { key: 'ThietKe', label: 'Thiết Kế', shortLabel: 'Thiết Kế' },
    { key: 'InKhoLon', label: 'In Khổ Lớn', shortLabel: 'In Khổ Lớn' },
    { key: 'BeDemi', label: 'Bế Demi', shortLabel: 'Bế Demi' },
    { key: 'GiaCongNgoai', label: 'Gia công ngoài', shortLabel: 'Gia công ngoài' },
    { key: 'EpKim', label: 'Ép Kim (theo phí ép kim)', shortLabel: 'Ép Kim' },
];

/** Đảm bảo JSON lưu xuống luôn có đủ key và toàn số (không null, không NaN). */
export const fillCommissionKeys = (
    fields: CommissionField[],
    current?: Record<string, any> | null
): Record<string, number> => {
    const result: Record<string, number> = {};
    fields.forEach(({ key }) => {
        const value = Number(current?.[key]);
        result[key] = Number.isFinite(value) ? value : 0;
    });
    return result;
};

/** Đọc 1 ô về dạng số an toàn (ô chưa cấu hình / null / NaN đều thành 0). */
export const readRate = (source: Record<string, any> | null | undefined, key: string): number => {
    const value = Number(source?.[key]);
    return Number.isFinite(value) ? value : 0;
};

/** Key đã từng được lưu xuống CSDL chưa? (hiển thị 0 nhưng chưa cấu hình) */
export const isRateUnset = (source: Record<string, any> | null | undefined, key: string): boolean =>
    !(source && Object.prototype.hasOwnProperty.call(source, key));
