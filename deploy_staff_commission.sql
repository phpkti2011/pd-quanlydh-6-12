-- DEPLOY: Staff Commission Function (standalone)
-- Run this ENTIRE block in Supabase SQL Editor

-- Drop old version first
DROP FUNCTION IF EXISTS calculate_staff_commission(DATE, DATE, TEXT);

-- Create new version with KPI policy
CREATE OR REPLACE FUNCTION calculate_staff_commission(
    p_start_date DATE, p_end_date DATE, p_user_name TEXT DEFAULT NULL
)
RETURNS TABLE (
    participant_name TEXT, competency_score NUMERIC,
    main_task_comm NUMERIC, sub_task_comm NUMERIC, total_comm NUMERIC
) AS $$
DECLARE
    v_total_revenue_pre_vat NUMERIC := 0;
    v_kpi_revenue NUMERIC := 0;
    v_company_target NUMERIC := 0;
    v_kpi_met BOOLEAN := TRUE;
    v_month INT := EXTRACT(MONTH FROM p_start_date);
    v_year INT := EXTRACT(YEAR FROM p_start_date);
BEGIN
    -- 1. Revenue for MANAGER BONUS (HoanThanh only)
    IF p_start_date < '2026-03-01'::DATE THEN
        SELECT COALESCE(SUM(total_amount - COALESCE(vat_amount, 0)), 0) INTO v_total_revenue_pre_vat
        FROM orders WHERE status = 'HoanThanh'
        AND created_at::DATE >= p_start_date AND created_at::DATE <= p_end_date;
    ELSE
        SELECT COALESCE(SUM(total_amount - COALESCE(vat_amount, 0)), 0) INTO v_total_revenue_pre_vat
        FROM orders WHERE status = 'HoanThanh'
        AND completed_at IS NOT NULL
        AND completed_at::DATE >= p_start_date AND completed_at::DATE <= p_end_date
        AND created_at >= '2026-03-01'::TIMESTAMPTZ;
    END IF;

    -- 2. Revenue for KPI CHECK (all non-cancelled, matches dashboard)
    SELECT COALESCE(SUM(total_amount - COALESCE(vat_amount, 0)), 0) INTO v_kpi_revenue
    FROM orders WHERE status != 'Huy'
    AND created_at::DATE >= p_start_date AND created_at::DATE <= p_end_date;

    -- 3. Fetch Company KPI target
    SELECT COALESCE(target_amount, 0) INTO v_company_target
    FROM sales_targets 
    WHERE department_name = 'Company' 
    AND period_month = v_month AND period_year = v_year
    LIMIT 1;
    v_company_target := COALESCE(v_company_target, 0);

    -- 4. KPI met? (target=0 → always met)
    IF v_company_target > 0 AND v_kpi_revenue < v_company_target THEN
        v_kpi_met := FALSE;
    END IF;

    RETURN QUERY
    WITH participated_tasks AS (
        SELECT 
            p.id as user_id, p.full_name, p.role,
            COALESCE(p.competency_score, 1.0) as score,
            COALESCE((p.commission_stages->>part.stage)::NUMERIC, cp_proc.rate, 0) as process_rate,
            COALESCE((p.commission_subtasks->>part.stage)::NUMERIC, cp_sub.rate, 0) as subtask_rate,
            part.stage, o.id as order_id, 
            (o.total_amount - COALESCE(o.vat_amount, 0)) as order_pre_vat,
            COUNT(*) OVER (PARTITION BY part.order_id, part.stage) as participant_count,
            CASE 
                WHEN part.stage = 'ThietKe' THEN COALESCE(o.design_fee, 0)
                WHEN part.stage = 'InKhoLon' THEN COALESCE(o.large_print_fee, 0)
                WHEN part.stage = 'EpKim' THEN COALESCE(o.ep_kim_fee, 0)
                WHEN part.stage = 'BeDemi' THEN COALESCE(o.be_demi_fee, 0)
                WHEN part.stage = 'GiaCongNgoai' THEN COALESCE(o.gia_cong_ngoai_fee, 0)
                WHEN part.stage = 'CanMang' THEN COALESCE(o.can_mang_fee, 0)
                ELSE 0
            END as stage_value
        FROM order_process_participants part
        JOIN orders o ON part.order_id = o.id
        JOIN profiles p ON part.user_id = p.id
        LEFT JOIN commission_policies cp_proc ON cp_proc.policy_type = 'MAINTASK_RATE' AND cp_proc.apply_to = part.stage
        LEFT JOIN commission_policies cp_sub ON cp_sub.policy_type = 'SUBTASK_RATE' AND cp_sub.apply_to = part.stage
        WHERE o.status = 'HoanThanh'
        AND p.role != 'NhanVienKinhDoanh'
        AND p.role != 'QuanLySanXuat'
        AND (
            (p_start_date < '2026-03-01'::DATE 
             AND o.created_at::DATE >= p_start_date 
             AND o.created_at::DATE <= p_end_date)
            OR
            (p_start_date >= '2026-03-01'::DATE 
             AND o.completed_at IS NOT NULL 
             AND o.completed_at::DATE >= p_start_date 
             AND o.completed_at::DATE <= p_end_date
             AND o.created_at >= '2026-03-01'::TIMESTAMPTZ)
        )
    ),
    calc_per_task AS (
        SELECT 
            pt.full_name, pt.score,
            CASE WHEN pt.stage_value = 0 THEN (pt.order_pre_vat / pt.participant_count) * (pt.process_rate / 100.0) * pt.score ELSE 0 END as process_comm_val,
            CASE WHEN pt.stage_value > 0 THEN pt.stage_value * (pt.subtask_rate / 100.0) ELSE 0 END as stage_comm_val
        FROM participated_tasks pt
        WHERE (p_user_name IS NULL OR pt.full_name = p_user_name)
    ),
    -- Staff commission (0 if KPI not met)
    staff_result AS (
        SELECT cpt.full_name, cpt.score,
            CASE WHEN v_kpi_met THEN ROUND(SUM(cpt.process_comm_val), 0) ELSE 0 END as main_comm,
            CASE WHEN v_kpi_met THEN ROUND(SUM(cpt.stage_comm_val), 0) ELSE 0 END as sub_comm,
            CASE WHEN v_kpi_met THEN ROUND(SUM(cpt.process_comm_val + cpt.stage_comm_val), 0) ELSE 0 END as total
        FROM calc_per_task cpt GROUP BY cpt.full_name, cpt.score
    ),
    -- Manager bonus (100% if KPI met, 40% if not)
    manager_bonus AS (
        SELECT p.full_name, COALESCE(p.competency_score, 1.0) as score,
            CASE WHEN v_kpi_met 
                THEN ROUND(v_total_revenue_pre_vat * (p.product_manager_commission_rate / 100.0), 0)
                ELSE ROUND(v_total_revenue_pre_vat * (p.product_manager_commission_rate / 100.0) * 0.4, 0)
            END as mgr_bonus
        FROM profiles p
        WHERE p.product_manager_commission_rate > 0
        AND p.deleted_at IS NULL
        AND p.role != 'NhanVienKinhDoanh'
        AND (p_user_name IS NULL OR p.full_name = p_user_name)
    ),
    combined AS (
        SELECT 
            COALESCE(s.full_name, m.full_name) as full_name,
            COALESCE(s.score, m.score) as score,
            COALESCE(s.main_comm, 0) + COALESCE(m.mgr_bonus, 0) as main_comm,
            COALESCE(s.sub_comm, 0) as sub_comm,
            COALESCE(s.total, 0) + COALESCE(m.mgr_bonus, 0) as total
        FROM staff_result s
        FULL OUTER JOIN manager_bonus m ON s.full_name = m.full_name
    )
    SELECT c.full_name, c.score, c.main_comm, c.sub_comm, c.total
    FROM combined c;
END;
$$ LANGUAGE plpgsql;

-- Grant access
GRANT EXECUTE ON FUNCTION calculate_staff_commission(DATE, DATE, TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION calculate_staff_commission(DATE, DATE, TEXT) TO anon;

-- Verify: test with Feb 2026
SELECT * FROM calculate_staff_commission('2026-02-01'::DATE, '2026-02-28'::DATE);
