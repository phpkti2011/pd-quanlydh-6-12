-- =====================================================
-- RESET HOÀN TOÀN: Drop tất cả và khôi phục function gốc
-- =====================================================

-- ========================
-- BƯỚC 1: DROP TẤT CẢ CÁC PHIÊN BẢN FUNCTION
-- ========================
DROP FUNCTION IF EXISTS calculate_staff_commission(DATE, DATE, TEXT);
DROP FUNCTION IF EXISTS calculate_staff_commission(DATE, DATE);
DROP FUNCTION IF EXISTS calculate_staff_commission(TEXT, TEXT, TEXT);
DROP FUNCTION IF EXISTS calculate_staff_commission(TEXT, TEXT);
DROP FUNCTION IF EXISTS public.calculate_staff_commission(DATE, DATE, TEXT);
DROP FUNCTION IF EXISTS public.calculate_staff_commission(DATE, DATE);
DROP FUNCTION IF EXISTS public.calculate_staff_commission(TEXT, TEXT, TEXT);
DROP FUNCTION IF EXISTS public.calculate_staff_commission(TEXT, TEXT);

-- ========================
-- BƯỚC 2: TẠO LẠI FUNCTION GỐC (KHÔNG THAY ĐỔI GÌ)
-- ========================
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
DECLARE
    v_total_month_sales NUMERIC := 0;
BEGIN
    -- Calculate Total Month Sales (Pre-VAT) for Product Manager Commission
    -- Only completed orders
    SELECT COALESCE(SUM(total_amount_pre_vat), 0)
    INTO v_total_month_sales
    FROM orders
    WHERE COALESCE(delivery_date, created_at)::DATE >= p_start_date 
    AND COALESCE(delivery_date, created_at)::DATE <= p_end_date
    AND status IN ('HoanThanh', 'DaGiaoHang');

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
        WHERE COALESCE(o.delivery_date, o.created_at)::DATE >= p_start_date 
        AND COALESCE(o.delivery_date, o.created_at)::DATE <= p_end_date
        AND o.status IN ('HoanThanh', 'DaGiaoHang')
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
            SUM(CASE 
                WHEN pt.stage_value > 0 THEN 
                    pt.stage_value * (pt.subtask_rate / 100.0)
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
        ROUND(sc.p_main + sc.p_sub, 0)
    FROM staff_calc sc

    UNION ALL

    -- 2. Product Manager Commission
    SELECT
        p.full_name,
        1.0 as competency_score, -- Standard score for Manager calculation context
        ROUND(v_total_month_sales * (p.product_manager_commission_rate / 100.0), 0) as main_task_comm, -- Put in Main Task column
        0 as sub_task_comm,
        ROUND(v_total_month_sales * (p.product_manager_commission_rate / 100.0), 0) as total_comm
    FROM profiles p
    WHERE (p.role = 'QuanLySanXuat' OR p.product_manager_commission_rate > 0)
    AND (p_user_name IS NULL OR p.full_name = p_user_name)
    AND p.product_manager_commission_rate IS NOT NULL 
    AND p.product_manager_commission_rate > 0;
    
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ========================
-- BƯỚC 3: GRANT PERMISSIONS
-- ========================
GRANT EXECUTE ON FUNCTION calculate_staff_commission(DATE, DATE, TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION calculate_staff_commission(DATE, DATE, TEXT) TO anon;

NOTIFY pgrst, 'reload schema';

-- ========================
-- BƯỚC 4: TEST QUERY - Kiểm tra kết quả
-- ========================
-- Chạy query này sau khi thực hiện các bước trên để kiểm tra:
-- SELECT * FROM calculate_staff_commission('2026-01-01'::DATE, '2026-01-31'::DATE, 'Bùi văn Nghĩa');
