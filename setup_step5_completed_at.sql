-- =====================================================
-- Add completed_at column + auto-set trigger
-- Run in Supabase SQL Editor (PRODUCTION project)
-- =====================================================

-- 1. Add column
ALTER TABLE orders ADD COLUMN IF NOT EXISTS completed_at TIMESTAMPTZ;

-- 2. Trigger: auto-set completed_at when order becomes HoanThanh
CREATE OR REPLACE FUNCTION set_completed_at()
RETURNS TRIGGER AS $$
BEGIN
    -- Only set completed_at when status changes TO HoanThanh
    IF NEW.status = 'HoanThanh' 
       AND (OLD.status IS NULL OR OLD.status != 'HoanThanh') THEN
        NEW.completed_at = NOW();
    END IF;
    
    -- If status moves BACK from completed (e.g. re-opened), clear completed_at
    IF NEW.status != 'HoanThanh' 
       AND OLD.status = 'HoanThanh' THEN
        NEW.completed_at = NULL;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_set_completed_at ON orders;
CREATE TRIGGER trigger_set_completed_at
    BEFORE UPDATE ON orders
    FOR EACH ROW
    EXECUTE FUNCTION set_completed_at();

-- 3. Update commission functions to use completed_at

-- Sales Commission
CREATE OR REPLACE FUNCTION calculate_sales_commission(
    p_month INT, p_year INT, p_viewer_role TEXT DEFAULT 'NhanVien'
)
RETURNS TABLE (
    sales_rep_id UUID, sales_rep_name TEXT, personal_sales NUMERIC,
    commission_tier JSONB, personal_commission NUMERIC, group_sales NUMERIC,
    group_target NUMERIC, group_rate NUMERIC, group_commission_fund NUMERIC,
    total_commission NUMERIC
) AS $$
DECLARE
    v_group_total_sales NUMERIC := 0;
    v_group_target NUMERIC := 0;
    v_group_rate NUMERIC := 0;
    v_group_bonus_fund NUMERIC := 0;
BEGIN
    IF p_viewer_role = 'KeToan' THEN
        RETURN QUERY SELECT NULL::UUID, NULL::TEXT, NULL::NUMERIC, NULL::JSONB, NULL::NUMERIC, NULL::NUMERIC, NULL::NUMERIC, NULL::NUMERIC, NULL::NUMERIC, NULL::NUMERIC WHERE FALSE;
        RETURN;
    END IF;

    -- Use completed_at instead of delivery_date
    SELECT COALESCE(SUM(grand_total), 0) INTO v_group_total_sales
    FROM orders
    WHERE EXTRACT(MONTH FROM completed_at) = p_month 
      AND EXTRACT(YEAR FROM completed_at) = p_year
      AND status = 'HoanThanh';

    SELECT target_amount, commission_rate
    INTO v_group_target, v_group_rate
    FROM sales_targets 
    WHERE period_month = p_month AND period_year = p_year AND department_name = 'Sales'
    LIMIT 1;

    IF v_group_target IS NULL THEN
         SELECT target_amount, commission_rate INTO v_group_target, v_group_rate
         FROM sales_targets WHERE period_month = p_month AND period_year = p_year AND department_name = 'Company' LIMIT 1;
    END IF;

    v_group_target := COALESCE(v_group_target, 99999999999);
    v_group_rate := COALESCE(v_group_rate, 0);

    IF v_group_total_sales >= v_group_target THEN
        v_group_bonus_fund := v_group_total_sales * (v_group_rate / 100);
    ELSE
        v_group_bonus_fund := 0;
    END IF;

    RETURN QUERY
    WITH monthly_sales AS (
        SELECT 
            o.sales_rep_id, p.full_name, p.commission_tiers,
            COALESCE(SUM(o.grand_total), 0) as total_sales
        FROM orders o
        JOIN profiles p ON o.sales_rep_id = p.id
        WHERE EXTRACT(MONTH FROM o.completed_at) = p_month 
          AND EXTRACT(YEAR FROM o.completed_at) = p_year
          AND o.status = 'HoanThanh'
        GROUP BY o.sales_rep_id, p.full_name, p.commission_tiers
    )
    SELECT 
        ms.sales_rep_id, ms.full_name, ms.total_sales, ms.commission_tiers,
        (
            SELECT COALESCE(SUM(
                CASE 
                    WHEN ms.total_sales >= (tier->>'max')::numeric THEN 
                        ((tier->>'max')::numeric - (tier->>'min')::numeric) * ((tier->>'rate')::numeric / 100)
                    WHEN ms.total_sales > (tier->>'min')::numeric AND ms.total_sales < (tier->>'max')::numeric THEN
                        (ms.total_sales - (tier->>'min')::numeric) * ((tier->>'rate')::numeric / 100)
                    WHEN ms.total_sales > (tier->>'min')::numeric AND ((tier->>'max') IS NULL OR (tier->>'max')::numeric = 0) THEN
                         (ms.total_sales - (tier->>'min')::numeric) * ((tier->>'rate')::numeric / 100)
                    ELSE 0
                END
            ), 0) FROM jsonb_array_elements(ms.commission_tiers) as tier
        ) as personal_commission,
        v_group_total_sales, v_group_target, v_group_rate, v_group_bonus_fund,
        (
             (SELECT COALESCE(SUM(
                CASE 
                    WHEN ms.total_sales >= (tier->>'max')::numeric THEN 
                        ((tier->>'max')::numeric - (tier->>'min')::numeric) * ((tier->>'rate')::numeric / 100)
                    WHEN ms.total_sales > (tier->>'min')::numeric AND ms.total_sales < (tier->>'max')::numeric THEN
                        (ms.total_sales - (tier->>'min')::numeric) * ((tier->>'rate')::numeric / 100)
                    WHEN ms.total_sales > (tier->>'min')::numeric AND ((tier->>'max') IS NULL OR (tier->>'max')::numeric = 0) THEN
                         (ms.total_sales - (tier->>'min')::numeric) * ((tier->>'rate')::numeric / 100)
                    ELSE 0
                END
            ), 0) FROM jsonb_array_elements(ms.commission_tiers) as tier)
            + (CASE WHEN v_group_total_sales > 0 THEN (ms.total_sales / v_group_total_sales) * v_group_bonus_fund ELSE 0 END)
        ) as total_commission
    FROM monthly_sales ms;
END;
$$ LANGUAGE plpgsql;


-- Staff Commission: use completed_at
DROP FUNCTION IF EXISTS calculate_staff_commission(DATE, DATE, TEXT);

CREATE OR REPLACE FUNCTION calculate_staff_commission(
    p_start_date DATE, p_end_date DATE, p_user_name TEXT DEFAULT NULL
)
RETURNS TABLE (
    participant_name TEXT, competency_score NUMERIC,
    main_task_comm NUMERIC, sub_task_comm NUMERIC, total_comm NUMERIC
) AS $$
BEGIN
    RETURN QUERY
    WITH participated_tasks AS (
        SELECT 
            p.id as user_id, p.full_name,
            COALESCE(p.competency_score, 1.0) as score,
            COALESCE((p.commission_stages->>part.stage)::NUMERIC, cp_proc.rate, 0) as process_rate,
            COALESCE((p.commission_subtasks->>part.stage)::NUMERIC, cp_sub.rate, 0) as subtask_rate,
            part.stage, o.id as order_id, o.total_amount_pre_vat,
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
        WHERE COALESCE(o.completed_at, o.delivery_date, o.created_at)::DATE >= p_start_date 
        AND COALESCE(o.completed_at, o.delivery_date, o.created_at)::DATE <= p_end_date
        AND o.status = 'HoanThanh'
    ),
    calc_per_task AS (
        SELECT 
            pt.full_name, pt.score,
            CASE WHEN pt.stage_value = 0 THEN (pt.total_amount_pre_vat / pt.participant_count) * (pt.process_rate / 100.0) * pt.score ELSE 0 END as process_comm_val,
            CASE WHEN pt.stage_value > 0 THEN pt.stage_value * (pt.subtask_rate / 100.0) ELSE 0 END as stage_comm_val
        FROM participated_tasks pt
        WHERE (p_user_name IS NULL OR pt.full_name = p_user_name)
    )
    SELECT cpt.full_name, cpt.score,
        ROUND(SUM(cpt.process_comm_val), 0), ROUND(SUM(cpt.stage_comm_val), 0),
        ROUND(SUM(cpt.process_comm_val + cpt.stage_comm_val), 0)
    FROM calc_per_task cpt GROUP BY cpt.full_name, cpt.score;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- Staff Activity Details: use completed_at
DROP FUNCTION IF EXISTS get_staff_activity_details(DATE, DATE, TEXT);

CREATE OR REPLACE FUNCTION get_staff_activity_details(
    p_start_date DATE, p_end_date DATE, p_user_name TEXT DEFAULT NULL
)
RETURNS TABLE (
    user_name TEXT, order_code TEXT, stage TEXT,
    started_at TIMESTAMPTZ, finished_at TIMESTAMPTZ, score NUMERIC,
    participant_count BIGINT, process_comm NUMERIC, stage_comm NUMERIC, total_comm NUMERIC
) AS $$
BEGIN
    RETURN QUERY
    WITH participated_tasks AS (
        SELECT 
            p.full_name, COALESCE(p.competency_score, 1.0) as score,
            COALESCE((p.commission_stages->>part.stage)::NUMERIC, cp_proc.rate, 0) as process_rate,
            COALESCE((p.commission_subtasks->>part.stage)::NUMERIC, cp_sub.rate, 0) as subtask_rate,
            part.stage, part.started_at, part.finished_at,
            o.order_code, o.total_amount_pre_vat,
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
        WHERE COALESCE(o.completed_at, o.delivery_date, o.created_at)::DATE >= p_start_date 
        AND COALESCE(o.completed_at, o.delivery_date, o.created_at)::DATE <= p_end_date
        AND o.status = 'HoanThanh'
    ),
    calc AS (
        SELECT pt.full_name, pt.order_code, pt.stage, pt.started_at, pt.finished_at,
            pt.score, pt.participant_count,
            CASE WHEN pt.stage_value = 0 THEN (pt.total_amount_pre_vat / pt.participant_count) * pt.process_rate * pt.score ELSE 0 END as pcomm,
            CASE WHEN pt.stage_value > 0 THEN pt.stage_value * pt.subtask_rate ELSE 0 END as scomm
        FROM participated_tasks pt
        WHERE (p_user_name IS NULL OR pt.full_name = p_user_name)
    )
    SELECT c.full_name, c.order_code, c.stage, c.started_at, c.finished_at,
        c.score, c.participant_count, ROUND(c.pcomm, 0), ROUND(c.scomm, 0), ROUND(c.pcomm + c.scomm, 0)
    FROM calc c ORDER BY c.started_at DESC;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- 4. Reload schema
NOTIFY pgrst, 'reload schema';
