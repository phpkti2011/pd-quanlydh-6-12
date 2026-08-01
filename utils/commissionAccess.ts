/**
 * Phân quyền xem thưởng hoa hồng — MỘT nơi quyết định duy nhất.
 *
 * Trước đây mỗi màn hình tự viết điều kiện riêng nên lệch nhau, và tệ hơn là
 * "hỏng theo kiểu mở toang": khi không xác định được tên người dùng thì hệ
 * thống trả về thưởng của TẤT CẢ mọi người thay vì từ chối.
 *
 * Nguyên tắc ở đây ngược lại: KHÔNG chắc chắn thì CHẶN.
 */

/** Vai trò được xem thưởng của tất cả mọi người. Thêm 'KeToan' vào đây nếu
 *  muốn Kế toán xem lại được toàn bộ để đối chiếu bảng lương. */
export const COMMISSION_VIEW_ALL_ROLES: string[] = ['Admin'];

export interface CommissionScope {
    /** Được xem thưởng của mọi người */
    canViewAll: boolean;
    /** Tên dùng để lọc. Chỉ là undefined khi canViewAll = true */
    filterName?: string;
    /** true = KHÔNG được phép truy vấn, phải hiện lý do thay vì gọi API */
    blocked: boolean;
    reason?: string;
}

export const NO_NAME_REASON =
    'Tài khoản của bạn chưa có Họ và tên nên không xác định được thưởng của ai. ' +
    'Vui lòng cập nhật Họ và tên trong Cài đặt tài khoản, hoặc liên hệ Admin.';

/**
 * @param role     vai trò người đang đăng nhập (App.tsx truyền xuống qua prop)
 * @param fullName họ tên người đang đăng nhập
 */
export function resolveCommissionScope(role?: string, fullName?: string): CommissionScope {
    if (role && COMMISSION_VIEW_ALL_ROLES.includes(role)) {
        return { canViewAll: true, filterName: undefined, blocked: false };
    }

    const name = (fullName || '').trim();
    if (!name) {
        // Điểm mấu chốt: không có tên thì CHẶN, tuyệt đối không để lọt thành
        // "không lọc" — vì phía CSDL, không lọc nghĩa là trả về tất cả.
        return { canViewAll: false, blocked: true, reason: NO_NAME_REASON };
    }

    return { canViewAll: false, filterName: name, blocked: false };
}
