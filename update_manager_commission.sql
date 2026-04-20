-- 1. Add column for Product Manager Commission Rate
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='profiles' AND column_name='product_manager_commission_rate') THEN
        ALTER TABLE profiles ADD COLUMN product_manager_commission_rate NUMERIC DEFAULT 0;
    END IF;
END $$;

-- 2. Update calculate_staff_commission to include Product Manager logic
DROP FUNCTION IF EXISTS calculate_staff_commission(DATE, DATE, TEXT);
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
    total_comm NUMERIC,
    tier_percentage NUMERIC
) AS $$
DECLARE
    v_total_month_sales NUMERIC := 0;
    v_tier_pct NUMERIC := 0;
    v_transition_date DATE := '2026-03-01';
BEGIN
    -- Calculate Total Month Sales (Pre-VAT) for Product Manager Commission
    -- Logic: chỉ status HoanThanh
    --   - Đơn cũ (trước 01/03/2026): theo created_at
    --   - Đơn mới (từ 01/03/2026): theo completed_at
    SELECT COALESCE(SUM(total_amount_pre_vat), 0)
    INTO v_total_month_sales
    FROM orders
    WHERE status = 'HoanThanh'
    AND (
        (created_at::DATE < v_transition_date
         AND created_at::DATE >= p_start_date
         AND created_at::DATE <= p_end_date)
        OR
        (created_at::DATE >= v_transition_date
         AND completed_at IS NOT NULL
         AND completed_at::DATE >= p_start_date
         AND completed_at::DATE <= p_end_date)
    );

    -- Get production tier rate based on total month sales
    v_tier_pct := get_production_tier_rate(v_total_month_sales);

    RETURN QUERY
    -- 1. Normal Staff Commission (Existing Logic)
    WITH participated_tasks AS (
        SELECT 
            p.id as user_id,
            p.full_name,
            COALESCE(p.competency_score, 1.0) as score,
            
            -- Fetch Rates (Personal -> Global -> 0)
            COALESCE((p.commission_stages->>part.stage)::NUMERIC, cp_proc.rate, 0) as process_rate,
            COALESCE((p.commission_subtasks->>part.stage)::NUMERIC, cp_sub.rate, 0) as subtask_rate,
            
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
        WHERE o.status = 'HoanThanh'
        AND (
            (o.created_at::DATE < v_transition_date
             AND o.created_at::DATE >= p_start_date
             AND o.created_at::DATE <= p_end_date)
            OR
            (o.created_at::DATE >= v_transition_date
             AND o.completed_at IS NOT NULL
             AND o.completed_at::DATE >= p_start_date
             AND o.completed_at::DATE <= p_end_date)
        )
    ),
    
    staff_calc AS (
        SELECT 
            pt.full_name as p_name,
            pt.score as p_score,
            
            -- Process Comm
            SUM(CASE 
                WHEN pt.stage_value = 0 THEN 
                    (pt.total_amount_pre_vat / pt.participant_count) * (pt.process_rate / 100.0) * pt.score 
                ELSE 0 
            END) as p_main,
            
            -- Sub-task Comm
            -- Nếu có phí riêng (stage_value > 0): tính theo phí
            -- Nếu không có phí riêng nhưng subtask_rate > 0: tính theo giá trị đơn / số người tham gia
            SUM(CASE
                WHEN pt.stage_value > 0 THEN
                    pt.stage_value * (pt.subtask_rate / 100.0)
                WHEN pt.subtask_rate > 0
                     AND pt.stage IN ('ThietKe','InKhoLon','BeDemi','GiaCongNgoai','EpKim','CanMang') THEN
                    (pt.total_amount_pre_vat / pt.participant_count) * (pt.subtask_rate / 100.0)
                ELSE 0
            END) as p_sub

        FROM participated_tasks pt
        WHERE (p_user_name IS NULL OR pt.full_name = p_user_name)
        GROUP BY pt.full_name, pt.score
    )

    SELECT
        sc.p_name,
        sc.p_score,
        ROUND(sc.p_main, 0),
        ROUND(sc.p_sub, 0),
        ROUND((sc.p_main + sc.p_sub) * v_tier_pct / 100.0, 0),
        v_tier_pct
    FROM staff_calc sc

    UNION ALL

    -- 2. Product Manager Commission (also affected by production tier)
    SELECT
        p.full_name,
        1.0 as competency_score,
        ROUND(v_total_month_sales * (p.product_manager_commission_rate / 100.0), 0) as main_task_comm,
        0 as sub_task_comm,
        ROUND(v_total_month_sales * (p.product_manager_commission_rate / 100.0) * v_tier_pct / 100.0, 0) as total_comm,
        v_tier_pct as tier_percentage
    FROM profiles p
    WHERE p.role = 'QuanLySanXuat'
    AND (p_user_name IS NULL OR p.full_name = p_user_name)
    AND p.product_manager_commission_rate IS NOT NULL
    AND p.product_manager_commission_rate > 0;
    
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

NOTIFY pgrst, 'reload schema';
