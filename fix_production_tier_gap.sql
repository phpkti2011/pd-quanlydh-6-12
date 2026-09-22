-- ============================================================================
-- FIX: Doanh số rơi vào KHOẢNG TRỐNG giữa 2 mốc -> thưởng sản xuất về 0%
-- ============================================================================
-- TRIỆU CHỨNG
--   Tháng 8/2026 doanh số 591 triệu, có mốc "0 - 580tr: 40%", nhưng màn
--   Thưởng HHSX hiện ×0% "Chưa đạt mốc" và mọi nhân viên Tổng thưởng = 0 đ
--   dù Thưởng CV chính / CV phụ đều có số.
--
-- NGUYÊN NHÂN
--   Cấu hình mốc có khoảng trống:
--       0          - 580.000.000 : 40%
--       620.000.000 - 660.000.000 : 70%     <- hở 580tr -> 620tr
--       660.000.000 - 690.000.000 : 100%
--       700.000.000 - 750.000.000 : 150%    <- hở 690tr -> 700tr
--       850.000.000 - vô cực      : 150%    <- hở 750tr -> 850tr
--
--   Hàm cũ coi cột "Đến" (threshold_max) là CHẶN CỨNG:
--       AND p_revenue >= threshold_min
--       AND (threshold_max IS NULL OR p_revenue < threshold_max)
--
--   Với 591tr: mốc 1 trượt vì (591 < 580) sai; mốc 2 trượt vì (591 >= 620)
--   sai. Không mốc nào khớp -> COALESCE(v_rate, 0) trả về 0.
--
--   Đây là lý do trong tháng 8 còn thấy 40% mà sang tháng 9 lại mất: lúc đó
--   doanh số chưa tới 580tr nên còn khớp mốc 1; hoàn thành thêm đơn, doanh số
--   vượt 580 và rơi vào lỗ -> mất sạch. Bán được nhiều hơn lại thành 0%.
--
-- CÁCH SỬA
--   Bỏ điều kiện chặn trên. ORDER BY threshold_min DESC LIMIT 1 sẵn có nghĩa
--   "lấy mốc CAO NHẤT đã vượt qua" — đúng nghiệp vụ: vượt mốc nào thì hưởng
--   mức đó cho tới khi chạm mốc cao hơn. Từ nay khoảng trống không còn khả
--   năng làm mất thưởng, kể cả khi cấu hình bị gõ hở.
--
--   Cột "Đến" chỉ còn ý nghĩa hiển thị. Giao diện Thiết lập KPI đã được sửa
--   để tự suy ra "Đến" = "Từ" của mốc kế tiếp, nên không tạo được lỗ nữa.
--
-- Có HAI bản hàm (2 overload cùng tồn tại trong CSDL), phải sửa cả hai:
--   3 tham số (revenue, month, year) - update_production_tiers_per_month.sql
--                                       <- bản đang dùng để tính thưởng
--   1 tham số (revenue)              - setup_production_commission_tiers.sql
--                                       <- bản cũ, sửa cho khỏi lệch
--
-- ĐỪNG đưa điều kiện threshold_max quay lại. Hai file gốc đã được sửa kèm.
-- ============================================================================


-- ----------------------------------------------------------------------------
-- 1. Bản 3 tham số — dùng để tính thưởng (có mốc riêng theo tháng + fallback)
-- ----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION get_production_tier_rate(
    p_revenue NUMERIC,
    p_month   INT,
    p_year    INT
)
RETURNS NUMERIC AS $$
DECLARE
    v_rate      NUMERIC := 0;
    v_has_month BOOLEAN;
BEGIN
    SELECT EXISTS(
        SELECT 1 FROM commission_policies
        WHERE policy_type = 'PRODUCTION_TIER'
          AND period_month = p_month
          AND period_year  = p_year
    ) INTO v_has_month;

    SELECT rate INTO v_rate
    FROM commission_policies
    WHERE policy_type = 'PRODUCTION_TIER'
      AND (
            (v_has_month AND period_month = p_month AND period_year = p_year)
         OR (NOT v_has_month AND period_month IS NULL)
          )
      AND p_revenue >= threshold_min
      -- KHÔNG chặn theo threshold_max: lấy mốc cao nhất đã vượt qua.
      -- Chặn trên khiến doanh số rơi vào khoảng trống giữa 2 mốc bị về 0%.
    ORDER BY threshold_min DESC
    LIMIT 1;

    RETURN COALESCE(v_rate, 0);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- ----------------------------------------------------------------------------
-- 2. Bản 1 tham số — bản cũ, chỉ đọc mốc global
-- ----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION get_production_tier_rate(p_revenue NUMERIC)
RETURNS NUMERIC AS $$
DECLARE
    v_rate NUMERIC := 0;
BEGIN
    SELECT rate INTO v_rate
    FROM commission_policies
    WHERE policy_type = 'PRODUCTION_TIER'
      AND p_revenue >= threshold_min
      -- KHÔNG chặn theo threshold_max — xem giải thích ở đầu file
    ORDER BY threshold_min DESC
    LIMIT 1;

    RETURN COALESCE(v_rate, 0);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

NOTIFY pgrst, 'reload schema';


-- ============================================================================
-- KIỂM TRA SAU KHI CHẠY
-- ============================================================================
-- 1. Tháng 8/2026 phải ra 40 (trước bản vá ra 0):
--    SELECT get_production_tier_rate(591000000, 8, 2026);
--
-- 2. Hai khoảng trống còn lại cũng phải ra đúng, không còn 0:
--    SELECT get_production_tier_rate(695000000, 8, 2026);  -- kỳ vọng 100
--    SELECT get_production_tier_rate(800000000, 8, 2026);  -- kỳ vọng 150
--
-- 3. Banner trên màn Thưởng HHSX:
--    SELECT * FROM get_production_commission_summary(8, 2026);
--    -> current_tier_pct = 40, next_tier_threshold = 620000000, next_tier_pct = 70
-- ============================================================================
