/**
 * Sắp xếp họ tên theo quy ước Việt Nam: xếp theo TÊN GỌI (chữ cuối),
 * trùng tên gọi thì mới xét tới họ đệm.
 *
 * Luôn dùng localeCompare với locale 'vi', KHÔNG so sánh chuỗi thô — bảng chữ
 * cái tiếng Việt coi ă â đ ê ô ơ ư là các chữ riêng, so sánh thô sẽ đẩy hết
 * tên có dấu xuống cuối và xếp sai (vd Phương trước Phúc).
 */

/** Lấy tên gọi = chữ cuối cùng trong họ tên */
export const getGivenName = (fullName?: string): string => {
    const parts = (fullName || '').trim().split(/\s+/);
    return parts.length ? parts[parts.length - 1] : '';
};

/** So sánh 2 họ tên theo quy ước Việt Nam */
export const compareVietnameseName = (a?: string, b?: string): number => {
    const na = (a || '').trim();
    const nb = (b || '').trim();
    const byGiven = getGivenName(na).localeCompare(getGivenName(nb), 'vi');
    return byGiven !== 0 ? byGiven : na.localeCompare(nb, 'vi');
};
