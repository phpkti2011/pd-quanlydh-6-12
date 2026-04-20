-- COMPLETE FIX FOR COMMISSION CALCULATION
-- 1. Handles missing commission keys (treats as 0 instead of global rate)
-- 2. Correctly divides commission rates by 100 (e.g. 2% becomes 0.02)
-- 3. Updates both Summary and Detail report functions
-- 4. Includes verify query at the end

-- ==========================================
-- 1. Update calculate_staff_commission (Summary Report)
-- ==========================================
DROP FUNCTION IF EXISTS calculate_staff_commission(DATE, DATE, TEXT) CASCADE;

CREATE OR REPLACE FUNCTION calculate_staff_commission(
    p_start_date DATE,
    p_end_date DATE,
    p_user_name TEXT DEFAULT NULL
)
RETURNS TABLE (
    participant_name TEXT,
    competency_score NUMERIC,
    main_task_comm NUMERIC,
    sub_task_comm NUMERIC,
    total_comm NUMERIC
) AS $$
BEGIN
    RETURN QUERY
    WITH participated_tasks AS (
        SELECT 
            p.id as user_id,
            p.full_name,
            COALESCE(p.competency_score, 1.0) as score,
            
            -- FIX CHECKING KEYS
            CASE 
                WHEN p.commission_stages ? part.stage THEN 
                    COALESCE((p.commission_stages->>part.stage)::NUMERIC, 0)
                WHEN (p.commission_stages IS NULL OR p.commission_stages = '{}'::jsonb) THEN 
                    COALESCE(cp_proc.rate, 0)
                ELSE 0
            END as process_rate,
            
            CASE 
                WHEN p.commission_subtasks ? part.stage THEN 
                    COALESCE((p.commission_subtasks->>part.stage)::NUMERIC, 0)
                WHEN (p.commission_subtasks IS NULL OR p.commission_subtasks = '{}'::jsonb) THEN 
                    COALESCE(cp_sub.rate, 0)
                ELSE 0
            END as subtask_rate,
            
            part.stage,
            o.id as order_id,
            o.total_amount_pre_vat, 
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
            pt.user_id,
            pt.full_name,
            pt.score,
            pt.stage,
            
            -- FIX DIVISION BY 100
            CASE 
                WHEN pt.stage_value = 0 THEN 
                    (pt.total_amount_pre_vat / pt.participant_count) * (pt.process_rate / 100.0) * pt.score 
                ELSE 0 
            END as process_comm_val,
            
            CASE 
                WHEN pt.stage_value > 0 THEN 
                    pt.stage_value * (pt.subtask_rate / 100.0)
                ELSE 0 
            END as stage_comm_val

        FROM participated_tasks pt
        WHERE (p_user_name IS NULL OR pt.full_name = p_user_name)
    )
    
    SELECT 
        cpt.full_name,
        cpt.score,
        ROUND(SUM(cpt.process_comm_val), 0) as main_comm,
        ROUND(SUM(cpt.stage_comm_val), 0) as sub_comm,
        ROUND(SUM(cpt.process_comm_val + cpt.stage_comm_val), 0) as total_comm
    FROM calc_per_task cpt
    GROUP BY cpt.full_name, cpt.score;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ==========================================
-- 2. Update get_staff_activity_details (Detailed Report)
-- ==========================================
DROP FUNCTION IF EXISTS get_staff_activity_details(DATE, DATE, TEXT) CASCADE;

CREATE OR REPLACE FUNCTION get_staff_activity_details(
    p_start_date DATE,
    p_end_date DATE,
    p_user_name TEXT DEFAULT NULL
)
RETURNS TABLE (
    user_name TEXT,
    order_code TEXT,
    stage TEXT,
    started_at TIMESTAMPTZ,
    finished_at TIMESTAMPTZ,
    score NUMERIC,
    participant_count BIGINT,
    process_comm NUMERIC,
    stage_comm NUMERIC,
    total_comm NUMERIC,
    -- Debug columns
    rate_val NUMERIC,
    debug_stage_val NUMERIC
) AS $$
BEGIN
    RETURN QUERY
    WITH participated_tasks AS (
        SELECT 
            p.id as user_id,
            p.full_name,
            COALESCE(p.competency_score, 1.0) as score,
            
            -- FIX CHECKING KEYS
            CASE 
                WHEN p.commission_stages ? part.stage THEN 
                    COALESCE((p.commission_stages->>part.stage)::NUMERIC, 0)
                WHEN (p.commission_stages IS NULL OR p.commission_stages = '{}'::jsonb) THEN 
                    COALESCE(cp_proc.rate, 0)
                ELSE 0
            END as process_rate,
            
            CASE 
                WHEN p.commission_subtasks ? part.stage THEN 
                    COALESCE((p.commission_subtasks->>part.stage)::NUMERIC, 0)
                WHEN (p.commission_subtasks IS NULL OR p.commission_subtasks = '{}'::jsonb) THEN 
                    COALESCE(cp_sub.rate, 0)
                ELSE 0
            END as subtask_rate,

            part.stage,
            part.started_at,
            part.finished_at,
            o.id as order_id,
            o.order_code,
            o.total_amount_pre_vat, 
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
            pt.full_name,
            pt.order_code,
            pt.stage,
            pt.started_at,
            pt.finished_at,
            pt.score,
            pt.participant_count,
            pt.process_rate,
            pt.subtask_rate,
            pt.stage_value,
            
            -- FIX DIVISION BY 100
            CASE 
                WHEN pt.stage_value = 0 THEN 
                    (pt.total_amount_pre_vat / pt.participant_count) * (pt.process_rate / 100.0) * pt.score 
                ELSE 0 
            END as process_comm_val,
            
            CASE 
                WHEN pt.stage_value > 0 THEN 
                    pt.stage_value * (pt.subtask_rate / 100.0)
                ELSE 0 
            END as stage_comm_val
        FROM participated_tasks pt
        WHERE (p_user_name IS NULL OR pt.full_name = p_user_name)
    )
    
    SELECT 
        cpt.full_name,
        cpt.order_code,
        cpt.stage,
        cpt.started_at,
        cpt.finished_at,
        cpt.score,
        cpt.participant_count,
        ROUND(cpt.process_comm_val, 0),
        ROUND(cpt.stage_comm_val, 0),
        ROUND(cpt.process_comm_val + cpt.stage_comm_val, 0),
        -- Debug columns
        cpt.process_rate,
        cpt.stage_value
    FROM calc_per_task cpt
    ORDER BY cpt.started_at DESC;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

NOTIFY pgrst, 'reload schema';

-- ==========================================
-- 3. Verification Query
-- ==========================================
SELECT 
    order_code,
    stage,
    score,
    participant_count,
    rate_val as "Rate (%)",
    debug_stage_val as "Subtask Fee",
    process_comm as "Thưởng QT (Main)",
    stage_comm as "Thưởng CĐ (Sub)",
    total_comm as "Total"
FROM get_staff_activity_details('2026-01-01', '2026-02-01', 'Bùi Văn Nghĩa')
WHERE order_code = '26PD3101.0712';
