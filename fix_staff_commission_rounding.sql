-- =====================================================
-- Fix Staff Commission 5.0: ROUNDING FIX
-- 1. Summary: Làm tròn đến đơn vị nghìn (ROUND -3)
-- 2. Details: Làm tròn đến đơn vị đồng (ROUND 0) để không còn số lẻ
-- 3. Logic: Giữ nguyên (Main/1000, Sub/100, CTE Grouping)
-- =====================================================

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='profiles' AND column_name='product_manager_commission_rate') THEN
        ALTER TABLE profiles ADD COLUMN product_manager_commission_rate NUMERIC DEFAULT 0;
    END IF;
END $$;

-- Drop all versions
DROP FUNCTION IF EXISTS calculate_staff_commission(DATE, DATE, TEXT);
DROP FUNCTION IF EXISTS calculate_staff_commission(DATE, DATE);
DROP FUNCTION IF EXISTS calculate_staff_commission(TEXT, TEXT, TEXT);
DROP FUNCTION IF EXISTS calculate_staff_commission(TEXT, TEXT);
DROP FUNCTION IF EXISTS public.calculate_staff_commission(DATE, DATE, TEXT);
DROP FUNCTION IF EXISTS public.calculate_staff_commission(DATE, DATE);
DROP FUNCTION IF EXISTS public.calculate_staff_commission(TEXT, TEXT, TEXT);
DROP FUNCTION IF EXISTS public.calculate_staff_commission(TEXT, TEXT);

CREATE OR REPLACE FUNCTION calculate_staff_commission(
    p_start_date TEXT,
    p_end_date TEXT,
    p_user_name TEXT DEFAULT NULL
)
RETURNS TABLE (
    participant_name TEXT,
    competency_score NUMERIC,
    main_task_comm NUMERIC,
    sub_task_comm NUMERIC,
    total_comm NUMERIC
) AS $$
DECLARE
    v_total_month_sales NUMERIC := 0;
    v_start DATE;
    v_end DATE;
BEGIN
    v_start := p_start_date::DATE;
    v_end := p_end_date::DATE;

    -- Calculate Total Month Sales
    SELECT COALESCE(SUM(total_amount_pre_vat), 0)
    INTO v_total_month_sales
    FROM orders
    WHERE COALESCE(delivery_date, created_at)::DATE >= v_start 
    AND COALESCE(delivery_date, created_at)::DATE <= v_end
    AND status IN ('HoanThanh', 'DaGiaoHang');

    RETURN QUERY
    WITH raw_data AS (
        -- 1. Normal Staff Commission (Excluding NVKD)
        WITH participated_tasks AS (
            SELECT 
                p.id as user_id,
                p.full_name,
                COALESCE(p.competency_score, 1.0) as score,
                
                -- Fetch Rates
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
            WHERE COALESCE(o.delivery_date, o.created_at)::DATE >= v_start 
            AND COALESCE(o.delivery_date, o.created_at)::DATE <= v_end
            AND o.status IN ('HoanThanh', 'DaGiaoHang')
            AND p.role != 'NhanVienKinhDoanh' 
        )
        
        SELECT 
            pt.full_name as p_name,
            pt.score as p_score,
            
            -- Process Comm (Quy trình): DIVIDE BY 1000
            SUM(CASE 
                WHEN pt.stage_value = 0 THEN 
                    (pt.total_amount_pre_vat / pt.participant_count) * (pt.process_rate / 1000.0) * pt.score 
                ELSE 0 
            END) as p_main,
            
            -- Sub-task Comm (Công đoạn): DIVIDE BY 100
            SUM(CASE 
                WHEN pt.stage_value > 0 THEN 
                    pt.stage_value * (pt.subtask_rate / 100.0)
                ELSE 0 
            END) as p_sub
        FROM participated_tasks pt
        WHERE (p_user_name IS NULL OR pt.full_name = p_user_name)
        GROUP BY pt.full_name, pt.score

        UNION ALL

        -- 2. Product Manager Commission
        SELECT
            p.full_name as p_name,
            1.0 as p_score,
            ROUND(v_total_month_sales * (p.product_manager_commission_rate / 100.0), 0) as p_main,
            0 as p_sub
        FROM profiles p
        WHERE (p.role = 'QuanLySanXuat' OR p.product_manager_commission_rate > 0)
        AND (p_user_name IS NULL OR p.full_name = p_user_name)
        AND p.product_manager_commission_rate IS NOT NULL 
        AND p.product_manager_commission_rate > 0
        AND p.role != 'NhanVienKinhDoanh'
    )

    -- AGGREGATE RESULTS BY USER + ROUNDING -3 (Thousands)
    SELECT 
        p_name,
        MAX(p_score) as competency_score,
        ROUND(SUM(p_main), -3) as main_task_comm,
        ROUND(SUM(p_sub), -3) as sub_task_comm,
        ROUND(SUM(p_main) + SUM(p_sub), -3) as total_comm
    FROM raw_data
    GROUP BY p_name;
    
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION calculate_staff_commission(TEXT, TEXT, TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION calculate_staff_commission(TEXT, TEXT, TEXT) TO anon;

NOTIFY pgrst, 'reload schema';
