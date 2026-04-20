-- ==============================================================================
-- CẤU HÌNH CÁC MỐC THƯỞNG NHÓM (SALES_GROUP_TIER)
-- Bảng tính: commission_policies
-- ==============================================================================

-- 1. Xóa các mốc cũ (nếu có) để tránh trùng lặp
DELETE FROM commission_policies WHERE policy_type = 'SALES_GROUP_TIER';

-- 2. Thêm các mốc mới (Anh vui lòng chỉnh sửa số liệu ở đây theo ý muốn)

-- MỐC 1: Từ 0 đến 200 Triệu -> Thưởng 0%
INSERT INTO commission_policies (policy_type, threshold_min, threshold_max, rate)
VALUES ('SALES_GROUP_TIER', 0, 200000000, 0);

-- MỐC 2: Từ 200 Triệu đến 500 Triệu -> Thưởng 0.5%
INSERT INTO commission_policies (policy_type, threshold_min, threshold_max, rate)
VALUES ('SALES_GROUP_TIER', 200000001, 500000000, 0.5);

-- MỐC 3: Từ 500 Triệu đến 1 Tỷ -> Thưởng 1.0%
INSERT INTO commission_policies (policy_type, threshold_min, threshold_max, rate)
VALUES ('SALES_GROUP_TIER', 500000001, 1000000000, 1.0);

-- MỐC 4: Trên 1 Tỷ -> Thưởng 1.5%
INSERT INTO commission_policies (policy_type, threshold_min, threshold_max, rate)
VALUES ('SALES_GROUP_TIER', 1000000001, 9999999999, 1.5);

-- Kiểm tra lại kết quả
SELECT * FROM commission_policies WHERE policy_type = 'SALES_GROUP_TIER' ORDER BY threshold_min ASC;
