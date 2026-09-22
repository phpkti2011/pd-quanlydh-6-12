-- ============================================================================
-- Mốc thưởng sản xuất CHUNG — lưới an toàn cho tháng chưa cấu hình riêng
-- ============================================================================
-- VÌ SAO CẦN
--   Mốc thưởng sản xuất lưu theo TỪNG THÁNG. Khi tính thưởng, hàm
--   get_production_tier_rate hỏi theo thứ tự:
--     1. Tháng này có mốc riêng  -> dùng mốc của tháng đó
--     2. Chưa cấu hình           -> lùi về mốc CHUNG (period_month IS NULL)
--
--   Nếu tháng nào quên cấu hình mà mốc chung cũng trống thì
--   COALESCE(v_rate, 0) trả về 0% -> cả xưởng mất thưởng, KHÔNG cảnh báo gì.
--   File này đặt sẵn bộ mốc chung để chuyện đó không xảy ra.
--
-- AN TOÀN
--   Mọi câu lệnh đều giới hạn `period_month IS NULL`, nên KHÔNG đụng mốc riêng
--   của bất kỳ tháng nào. Chạy lại nhiều lần cũng được.
--
--   apply_to dùng TIER_1..5, không đụng tên TIER_<năm>_<tháng>_<n> mà
--   save_production_tiers đặt cho mốc theo tháng (tránh vướng UNIQUE).
--
-- ĐỪNG chạy setup_production_commission_tiers.sql — dòng 12 của file đó là
-- `DELETE FROM commission_policies WHERE policy_type = 'PRODUCTION_TIER'`,
-- xoá sạch mốc của MỌI tháng chứ không riêng mốc chung.
-- ============================================================================


-- ----------------------------------------------------------------------------
-- 1. Bộ mốc chung (lấy theo chính sách tháng 8/2026)
--    Sửa số ở đây nếu muốn bộ mốc chung khác.
-- ----------------------------------------------------------------------------
DELETE FROM commission_policies
WHERE policy_type = 'PRODUCTION_TIER'
  AND period_month IS NULL;

INSERT INTO commission_policies
    (id, policy_type, apply_to, threshold_min, threshold_max, rate, period_month, period_year)
VALUES
    (uuid_generate_v4(), 'PRODUCTION_TIER', 'TIER_1',         0, 620000000,  40, NULL, NULL),
    (uuid_generate_v4(), 'PRODUCTION_TIER', 'TIER_2', 620000000, 660000000,  70, NULL, NULL),
    (uuid_generate_v4(), 'PRODUCTION_TIER', 'TIER_3', 660000000, 700000000, 100, NULL, NULL),
    (uuid_generate_v4(), 'PRODUCTION_TIER', 'TIER_4', 700000000, 850000000, 150, NULL, NULL),
    (uuid_generate_v4(), 'PRODUCTION_TIER', 'TIER_5', 850000000,      NULL, 150, NULL, NULL);


-- ----------------------------------------------------------------------------
-- 2. Hàm lưu mốc chung — cho nút "Đặt làm mốc chung" trên giao diện
--    Không tái dùng save_production_tiers được: hàm đó xoá theo
--    `period_month = p_month`, mà `period_month = NULL` không bao giờ khớp.
-- ----------------------------------------------------------------------------
DROP FUNCTION IF EXISTS save_global_production_tiers(TEXT);

CREATE OR REPLACE FUNCTION save_global_production_tiers(p_tiers TEXT)
RETURNS void AS $$
DECLARE
    v_tiers JSONB;
BEGIN
    -- Mốc chung ảnh hưởng MỌI tháng chưa cấu hình riêng -> chỉ Admin
    IF NOT EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'Admin') THEN
        RAISE EXCEPTION 'Access Denied: Only Admins can set global production tiers.';
    END IF;

    v_tiers := p_tiers::JSONB;

    -- Chỉ xoá mốc CHUNG, không đụng mốc của tháng nào
    DELETE FROM commission_policies
    WHERE policy_type = 'PRODUCTION_TIER'
      AND period_month IS NULL;

    INSERT INTO commission_policies
        (id, policy_type, apply_to, threshold_min, threshold_max, rate, period_month, period_year)
    SELECT
        uuid_generate_v4(),
        'PRODUCTION_TIER',
        'TIER_' || row_number() OVER (ORDER BY (elem->>'min')::NUMERIC),
        (elem->>'min')::NUMERIC,
        CASE WHEN elem->>'max' = '' OR elem->>'max' IS NULL THEN NULL ELSE (elem->>'max')::NUMERIC END,
        (elem->>'rate')::NUMERIC,
        NULL,
        NULL
    FROM jsonb_array_elements(v_tiers) AS elem;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION save_global_production_tiers(TEXT) TO authenticated;

NOTIFY pgrst, 'reload schema';


-- ============================================================================
-- KIỂM TRA SAU KHI CHẠY
-- ============================================================================
-- 1. Bộ mốc chung phải ra đúng 5 dòng:
--    SELECT apply_to, threshold_min, threshold_max, rate
--    FROM commission_policies
--    WHERE policy_type = 'PRODUCTION_TIER' AND period_month IS NULL
--    ORDER BY threshold_min;
--
-- 2. Mốc riêng của các tháng KHÔNG bị đụng:
--    SELECT period_year, period_month, COUNT(*)
--    FROM commission_policies
--    WHERE policy_type = 'PRODUCTION_TIER' AND period_month IS NOT NULL
--    GROUP BY period_year, period_month
--    ORDER BY period_year, period_month;
--
-- 3. Một tháng chưa cấu hình riêng giờ đã có hệ số (thay vì 0):
--    SELECT get_production_tier_rate(650000000, 12, 2026);  -- kỳ vọng 70
-- ============================================================================
