-- =====================================================
-- FIX: Restore staff commission functions to original
-- Run in Supabase SQL Editor (PRODUCTION)
-- =====================================================

-- 1. Drop ALL conflicting signatures
DROP FUNCTION IF EXISTS calculate_staff_commission(DATE, DATE, TEXT);
DROP FUNCTION IF EXISTS calculate_staff_commission(TEXT, TEXT, TEXT);

-- 2. Recreate original version (uses delivery_date/created_at, NOT completed_at)
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
        WHERE COALESCE(o.delivery_date, o.created_at)::DATE >= p_start_date 
        AND COALESCE(o.delivery_date, o.created_at)::DATE <= p_end_date
        AND o.status IN ('HoanThanh', 'DaGiaoHang')
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


-- 3. Restore get_staff_activity_details to original
DROP FUNCTION IF EXISTS get_staff_activity_details(DATE, DATE, TEXT);
DROP FUNCTION IF EXISTS get_staff_activity_details(TEXT, TEXT, TEXT);

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
        WHERE COALESCE(o.delivery_date, o.created_at)::DATE >= p_start_date 
        AND COALESCE(o.delivery_date, o.created_at)::DATE <= p_end_date
        AND o.status IN ('HoanThanh', 'DaGiaoHang')
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


-- 4. Backfill completed_at for existing HoanThanh orders
UPDATE orders 
SET completed_at = updated_at 
WHERE status = 'HoanThanh' 
AND completed_at IS NULL;


-- 5. Reload schema
NOTIFY pgrst, 'reload schema';
