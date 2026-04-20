-- =====================================================
-- Setup Production Commission Tiers (Thưởng Hoa Hồng Sản Xuất)
-- Mốc thưởng theo doanh số công ty (chưa VAT):
--   < 550tr: 0%
--   550-650tr: 70%
--   650-750tr: 100%
--   750-850tr: 150%
--   > 850tr: 150% (giữ nguyên)
-- =====================================================

-- 1. Seed Production Tier data into commission_policies
DELETE FROM commission_policies WHERE policy_type = 'PRODUCTION_TIER';

INSERT INTO commission_policies (id, policy_type, apply_to, threshold_min, threshold_max, rate)
VALUES
    (uuid_generate_v4(), 'PRODUCTION_TIER', 'TIER_1', 550000000, 650000000, 70),
    (uuid_generate_v4(), 'PRODUCTION_TIER', 'TIER_2', 650000000, 750000000, 100),
    (uuid_generate_v4(), 'PRODUCTION_TIER', 'TIER_3', 750000000, 850000000, 150),
    (uuid_generate_v4(), 'PRODUCTION_TIER', 'TIER_4', 850000000, NULL, 150);

-- 2. Helper function: get_production_tier_rate
-- Trả về % thưởng sản xuất dựa trên doanh số
CREATE OR REPLACE FUNCTION get_production_tier_rate(p_revenue NUMERIC)
RETURNS NUMERIC AS $$
DECLARE
    v_rate NUMERIC := 0;
BEGIN
    SELECT rate INTO v_rate
    FROM commission_policies
    WHERE policy_type = 'PRODUCTION_TIER'
    AND p_revenue >= threshold_min
    AND (threshold_max IS NULL OR p_revenue < threshold_max)
    ORDER BY threshold_min DESC
    LIMIT 1;

    RETURN COALESCE(v_rate, 0);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 3. Summary function for morning notification
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
    v_transition_date DATE := '2026-03-01';
BEGIN
    v_start := make_date(p_year, p_month, 1);
    v_end := (v_start + interval '1 month' - interval '1 day')::DATE;

    -- Calculate total month revenue (pre-VAT), same logic as calculate_staff_commission
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

    -- Get current tier rate
    v_current_pct := get_production_tier_rate(v_revenue);

    -- Get next tier (the tier with the lowest threshold_min that is above current revenue)
    SELECT cp.threshold_min, cp.rate
    INTO v_next_threshold, v_next_pct
    FROM commission_policies cp
    WHERE cp.policy_type = 'PRODUCTION_TIER'
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
        ) FROM commission_policies cp WHERE cp.policy_type = 'PRODUCTION_TIER');
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

NOTIFY pgrst, 'reload schema';
