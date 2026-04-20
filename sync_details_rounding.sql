-- =====================================================
-- Sync Details Function 2.0: ROUNDING
-- 1. Main Task: Chia 1000
-- 2. Sub Task: Chia 100
-- 3. Rounding: ROUND 0 (Bỏ số lẻ) để hiển thị gọn gàng
-- =====================================================

DROP FUNCTION IF EXISTS get_staff_activity_details(DATE, DATE, TEXT);
DROP FUNCTION IF EXISTS get_staff_activity_details(TEXT, TEXT, TEXT);
DROP FUNCTION IF EXISTS get_staff_activity_details(DATE, DATE);
DROP FUNCTION IF EXISTS get_staff_activity_details(TEXT, TEXT);

CREATE OR REPLACE FUNCTION get_staff_activity_details(
    p_start_date TEXT,
    p_end_date TEXT,
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
    total_comm NUMERIC
) AS $$
DECLARE
    v_start DATE;
    v_end DATE;
BEGIN
    v_start := p_start_date::DATE;
    v_end := p_end_date::DATE;

    RETURN QUERY
    -- 1. Regular Staff Commission Details
    WITH participated_tasks AS (
        SELECT 
            p.id as user_id,
            p.full_name,
            COALESCE(p.competency_score, 1.0) as score,
            COALESCE((p.commission_stages->>part.stage)::NUMERIC, cp_proc.rate, 0) as process_rate,
            COALESCE((p.commission_subtasks->>part.stage)::NUMERIC, cp_sub.rate, 0) as subtask_rate,

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
        WHERE COALESCE(o.delivery_date, o.created_at)::DATE >= v_start 
        AND COALESCE(o.delivery_date, o.created_at)::DATE <= v_end
        AND o.status IN ('HoanThanh', 'DaGiaoHang')
    ),
    
    staff_details AS (
        SELECT 
            pt.full_name,
            pt.order_code,
            pt.stage,
            pt.started_at,
            pt.finished_at,
            pt.score,
            pt.participant_count,
            
            -- Process Commission: DIVIDE BY 1000
            CASE 
                WHEN pt.stage_value = 0 THEN 
                    (pt.total_amount_pre_vat / pt.participant_count) * (pt.process_rate / 1000.0) * pt.score 
                ELSE 0 
            END as process_comm_val,
            
            -- Sub-task Commission: DIVIDE BY 100
            CASE 
                WHEN pt.stage_value > 0 THEN 
                    pt.stage_value * (pt.subtask_rate / 100.0)
                ELSE 0 
            END as stage_comm_val
        FROM participated_tasks pt
        WHERE (p_user_name IS NULL OR pt.full_name = p_user_name)
    )

    SELECT 
        sd.full_name,
        sd.order_code,
        sd.stage,
        sd.started_at,
        sd.finished_at,
        sd.score,
        sd.participant_count,
        ROUND(sd.process_comm_val, 0), -- Round 0 to remove decimals
        ROUND(sd.stage_comm_val, 0),   -- Round 0
        ROUND(sd.process_comm_val + sd.stage_comm_val, 0)
    FROM staff_details sd

    UNION ALL

    -- 2. Product Manager Commission Details
    SELECT
        p.full_name,
        o.order_code,
        'DoanhSo' as stage,
        o.created_at as started_at,
        o.delivery_date as finished_at,
        1.0 as score,
        1 as participant_count,
        ROUND(o.total_amount_pre_vat * (p.product_manager_commission_rate / 100.0), 0) as process_comm,
        0 as stage_comm,
        ROUND(o.total_amount_pre_vat * (p.product_manager_commission_rate / 100.0), 0) as total_comm
    FROM orders o
    CROSS JOIN profiles p
    WHERE 
        COALESCE(o.delivery_date, o.created_at)::DATE >= v_start 
        AND COALESCE(o.delivery_date, o.created_at)::DATE <= v_end
        AND o.status IN ('HoanThanh', 'DaGiaoHang')
        AND (p.role = 'QuanLySanXuat' OR p.product_manager_commission_rate > 0)
        AND p.product_manager_commission_rate IS NOT NULL 
        AND p.product_manager_commission_rate > 0
        AND (p_user_name IS NULL OR p.full_name = p_user_name)
    
    ORDER BY started_at DESC;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

NOTIFY pgrst, 'reload schema';
