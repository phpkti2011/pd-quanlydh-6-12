-- =====================================================
-- Mốc thưởng Sản xuất (PRODUCTION_TIER) theo TỪNG THÁNG
-- Trước đây mốc lưu global (không gắn tháng) -> set tháng 6 đè luôn tháng 5.
-- Sau bản này: mốc lưu theo period_month/period_year.
--   - Dòng có period_month/year = NULL  => mốc GLOBAL (fallback)
--   - Tháng nào đã cấu hình riêng => dùng mốc của tháng đó
--   - Tháng chưa cấu hình => fallback về mốc global
-- Chạy TOÀN BỘ script này trong Supabase SQL Editor.
-- =====================================================

-- 1. Thêm cột tháng/năm (nullable; chỉ PRODUCTION_TIER dùng,
--    các policy khác như GROUP_TIER/MAINTASK_RATE giữ NULL = global)
ALTER TABLE commission_policies
    ADD COLUMN IF NOT EXISTS period_month INT,
    ADD COLUMN IF NOT EXISTS period_year  INT;

-- 2. Lưu mốc sản xuất theo tháng (admin, bypass RLS)
--    Chỉ xoá mốc của ĐÚNG tháng/năm rồi chèn lại -> không đụng tháng khác.
DROP FUNCTION IF EXISTS save_production_tiers(JSONB);
DROP FUNCTION IF EXISTS save_production_tiers(TEXT);
DROP FUNCTION IF EXISTS save_production_tiers(TEXT, INT, INT);
CREATE OR REPLACE FUNCTION save_production_tiers(
    p_tiers TEXT,
    p_month INT,
    p_year  INT
)
RETURNS void AS $$
DECLARE
    v_tiers JSONB;
BEGIN
    v_tiers := p_tiers::JSONB;

    -- Xoá mốc hiện có của đúng tháng/năm này
    DELETE FROM commission_policies
    WHERE policy_type = 'PRODUCTION_TIER'
      AND period_month = p_month
      AND period_year  = p_year;

    -- Chèn mốc mới, gắn tháng/năm.
    -- apply_to phải mang theo năm/tháng để KHÔNG đụng UNIQUE(policy_type, apply_to)
    -- với mốc global cũ (TIER_1..n) hoặc mốc tháng khác.
    INSERT INTO commission_policies (id, policy_type, apply_to, threshold_min, threshold_max, rate, period_month, period_year)
    SELECT
        uuid_generate_v4(),
        'PRODUCTION_TIER',
        'TIER_' || p_year || '_' || p_month || '_' || row_number() OVER (ORDER BY (elem->>'min')::NUMERIC),
        (elem->>'min')::NUMERIC,
        CASE WHEN elem->>'max' = '' OR elem->>'max' IS NULL THEN NULL ELSE (elem->>'max')::NUMERIC END,
        (elem->>'rate')::NUMERIC,
        p_month,
        p_year
    FROM jsonb_array_elements(v_tiers) AS elem;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 3. Lấy % thưởng sản xuất theo doanh số + tháng (có fallback global)
--    Giữ luôn bản 1 tham số cũ (gọi mốc global) để không vỡ phụ thuộc khác.
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
      AND (threshold_max IS NULL OR p_revenue < threshold_max)
    ORDER BY threshold_min DESC
    LIMIT 1;

    RETURN COALESCE(v_rate, 0);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 4. Summary cho thông báo/UI: dùng mốc theo tháng (fallback global)
CREATE OR REPLACE FUNCTION get_production_commission_summary(
    p_month INT,
    p_year INT
)
RETURNS TABLE (
    total_revenue NUMERIC,
    current_tier_pct NUMERIC,
    next_tier_threshold NUMERIC,
    next_tier_pct NUMERIC,
    all_tiers JSONB
) AS $$
DECLARE
    v_start DATE;
    v_end DATE;
    v_revenue NUMERIC := 0;
    v_current_pct NUMERIC := 0;
    v_next_threshold NUMERIC;
    v_next_pct NUMERIC;
    v_has_month BOOLEAN;
    v_transition_date DATE := '2026-03-01';
BEGIN
    v_start := make_date(p_year, p_month, 1);
    v_end := (v_start + interval '1 month' - interval '1 day')::DATE;

    -- Doanh thu tháng (chưa VAT), cùng logic transition với calculate_staff_commission
    SELECT COALESCE(SUM(total_amount_pre_vat), 0)
    INTO v_revenue
    FROM orders
    WHERE status = 'HoanThanh'
    AND (
        (created_at::DATE < v_transition_date
         AND created_at::DATE >= v_start
         AND created_at::DATE <= v_end)
        OR
        (created_at::DATE >= v_transition_date
         AND completed_at IS NOT NULL
         AND completed_at::DATE >= v_start
         AND completed_at::DATE <= v_end)
    );

    -- Có mốc riêng cho tháng này không?
    SELECT EXISTS(
        SELECT 1 FROM commission_policies
        WHERE policy_type = 'PRODUCTION_TIER'
          AND period_month = p_month AND period_year = p_year
    ) INTO v_has_month;

    -- % hiện tại theo tháng (hàm đã tự fallback global)
    v_current_pct := get_production_tier_rate(v_revenue, p_month, p_year);

    -- Mốc kế tiếp (ngưỡng nhỏ nhất > doanh thu) trong tập mốc hiệu lực của tháng
    SELECT cp.threshold_min, cp.rate
    INTO v_next_threshold, v_next_pct
    FROM commission_policies cp
    WHERE cp.policy_type = 'PRODUCTION_TIER'
      AND (
            (v_has_month AND cp.period_month = p_month AND cp.period_year = p_year)
         OR (NOT v_has_month AND cp.period_month IS NULL)
          )
      AND cp.threshold_min > v_revenue
    ORDER BY cp.threshold_min ASC
    LIMIT 1;

    RETURN QUERY
    SELECT
        v_revenue,
        v_current_pct,
        v_next_threshold,
        v_next_pct,
        (SELECT jsonb_agg(
            jsonb_build_object(
                'min', cp.threshold_min,
                'max', cp.threshold_max,
                'rate', cp.rate
            ) ORDER BY cp.threshold_min
        )
         FROM commission_policies cp
         WHERE cp.policy_type = 'PRODUCTION_TIER'
           AND (
                 (v_has_month AND cp.period_month = p_month AND cp.period_year = p_year)
              OR (NOT v_has_month AND cp.period_month IS NULL)
               ));
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

NOTIFY pgrst, 'reload schema';
