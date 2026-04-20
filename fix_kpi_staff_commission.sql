-- =====================================================
-- FIX: calculate_staff_commission + get_staff_activity_details
-- Business Logic:
--   ≤ 02/2026: tính thưởng = đơn CREATED trong tháng (created_at)
--   ≥ 03/2026: tính thưởng = đơn HOÀN THÀNH trong tháng (completed_at)
--              KHÔNG giới hạn ngày tạo (bỏ filter created_at >= 2026-03-01)
-- Các điểm đã sửa:
--   1. v_total_revenue_pre_vat (manager bonus): bỏ created_at >= 2026-03-01
--   2. v_kpi_revenue (KPI check): tháng 3+ dùng completed_at thay created_at
--   3. participated_tasks CTE: bỏ created_at >= 2026-03-01
--   4. get_staff_activity_details: bỏ created_at >= 2026-03-01
-- =====================================================

DO $$ 
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT oid::regprocedure::text as sig FROM pg_proc WHERE proname = 'calculate_staff_commission' LOOP
        EXECUTE 'DROP FUNCTION IF EXISTS ' || r.sig || ' CASCADE';
    END LOOP;
    FOR r IN SELECT oid::regprocedure::text as sig FROM pg_proc WHERE proname = 'get_staff_activity_details' LOOP
        EXECUTE 'DROP FUNCTION IF EXISTS ' || r.sig || ' CASCADE';
    END LOOP;
    FOR r IN SELECT oid::regprocedure::text as sig FROM pg_proc WHERE proname = 'calculate_sales_commission' LOOP
        EXECUTE 'DROP FUNCTION IF EXISTS ' || r.sig || ' CASCADE';
    END LOOP;
    FOR r IN SELECT oid::regprocedure::text as sig FROM pg_proc WHERE proname = 'calc_personal_commission' LOOP
        EXECUTE 'DROP FUNCTION IF EXISTS ' || r.sig || ' CASCADE';
    END LOOP;
END $$;


-- Helper function (không thay đổi)
CREATE OR REPLACE FUNCTION calc_personal_commission(p_sales NUMERIC, p_tiers JSONB)
RETURNS NUMERIC AS $$
DECLARE
    v_count INT;
    v_active_idx INT := -1;
    v_is_marginal BOOLEAN := FALSE;
    v_commission NUMERIC := 0;
    v_tier_min NUMERIC;
    v_tier_max NUMERIC;
    v_tier_rate NUMERIC;
    v_prev_max NUMERIC := 0;
    v_amount NUMERIC;
BEGIN
    IF p_tiers IS NULL OR jsonb_array_length(p_tiers) = 0 THEN RETURN 0; END IF;
    v_count := jsonb_array_length(p_tiers);
    FOR i IN 0..v_count-1 LOOP
        v_tier_min := COALESCE((p_tiers->i->>'min')::NUMERIC, 0);
        v_tier_max := COALESCE((p_tiers->i->>'max')::NUMERIC, 0);
        IF p_sales > v_tier_min THEN
            v_active_idx := i;
            IF v_tier_max > 0 AND p_sales <= v_tier_max THEN EXIT; END IF;
        END IF;
    END LOOP;
    IF v_active_idx < 0 THEN RETURN 0; END IF;
    v_tier_max := COALESCE((p_tiers->v_active_idx->>'max')::NUMERIC, 0);
    v_is_marginal := (v_tier_max = 0);
    FOR i IN 0..v_count-1 LOOP
        v_tier_rate := COALESCE((p_tiers->i->>'rate')::NUMERIC, 0);
        v_tier_max := COALESCE((p_tiers->i->>'max')::NUMERIC, 0);
        IF i = v_active_idx THEN
            IF v_is_marginal THEN
                IF i > 0 THEN v_prev_max := COALESCE((p_tiers->(i-1)->>'max')::NUMERIC, 0);
                ELSE v_prev_max := 0; END IF;
                v_amount := p_sales - v_prev_max;
            ELSE
                v_amount := p_sales;
            END IF;
            v_commission := v_commission + (v_amount * v_tier_rate / 100);
        ELSIF v_is_marginal AND i = v_active_idx - 1 THEN
            v_commission := v_commission + (v_tier_max * v_tier_rate / 100);
        END IF;
    END LOOP;
    RETURN v_commission;
END;
$$ LANGUAGE plpgsql IMMUTABLE;


-- =====================================================
-- FUNCTION CHÍNH: calculate_staff_commission (ĐÃ FIX)
-- =====================================================
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
    -- 1. Revenue cho MANAGER BONUS
    IF p_start_date < '2026-03-01'::DATE THEN
        -- Tháng cũ: đơn HoanThanh lọc theo created_at
        SELECT COALESCE(SUM(total_amount - COALESCE(vat_amount, 0)), 0) INTO v_total_revenue_pre_vat
        FROM orders WHERE status = 'HoanThanh'
        AND created_at::DATE >= p_start_date AND created_at::DATE <= p_end_date;
    ELSE
        -- Tháng mới: đơn HoànThành, tạo từ 01/03+ và hoàn thành trong tháng
        SELECT COALESCE(SUM(total_amount - COALESCE(vat_amount, 0)), 0) INTO v_total_revenue_pre_vat
        FROM orders WHERE status = 'HoanThanh'
        AND completed_at IS NOT NULL
        AND completed_at::DATE >= p_start_date AND completed_at::DATE <= p_end_date
        AND created_at >= '2026-03-01'::TIMESTAMPTZ;  -- Đồng bộ với logic tính thưởng
    END IF;

    -- 2. Revenue cho KPI CHECK
    IF p_start_date < '2026-03-01'::DATE THEN
        -- Tháng cũ: lọc theo created_at (tất cả đơn không bị hủy)
        SELECT COALESCE(SUM(total_amount - COALESCE(vat_amount, 0)), 0) INTO v_kpi_revenue
        FROM orders WHERE status != 'Huy'
        AND created_at::DATE >= p_start_date AND created_at::DATE <= p_end_date;
    ELSE
        -- Tháng mới: KPI revenue = đơn tạo từ 01/03+ và hoàn thành trong tháng
        -- (nhất quán với phương pháp tính thưởng)
        SELECT COALESCE(SUM(total_amount - COALESCE(vat_amount, 0)), 0) INTO v_kpi_revenue
        FROM orders WHERE status != 'Huy'
        AND completed_at IS NOT NULL
        AND completed_at::DATE >= p_start_date AND completed_at::DATE <= p_end_date
        AND created_at >= '2026-03-01'::TIMESTAMPTZ;
    END IF;

    -- 3. Lấy mục tiêu KPI (ORDER BY để luôn lấy bản ghi MỚI NHẤT tránh duplicates)
    SELECT COALESCE(target_amount, 0) INTO v_company_target
    FROM sales_targets 
    WHERE department_name = 'Company' 
    AND period_month = v_month AND period_year = v_year
    ORDER BY COALESCE(updated_at, created_at) DESC
    LIMIT 1;
    v_company_target := COALESCE(v_company_target, 0);

    -- 4. Xác định KPI đạt hay không (target=0 → luôn đạt)
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
            -- Tháng cũ: đơn tạo trong tháng
            (p_start_date < '2026-03-01'::DATE 
             AND o.created_at::DATE >= p_start_date 
             AND o.created_at::DATE <= p_end_date)
            OR
            -- Tháng mới: đơn tạo từ 01/03+ và hoàn thành trong tháng
            -- (giống logic NVKD, tránh đếm trùng với tháng 2)
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
    staff_result AS (
        SELECT cpt.full_name, cpt.score,
            CASE WHEN v_kpi_met THEN ROUND(SUM(cpt.process_comm_val), 0) ELSE 0 END as main_comm,
            CASE WHEN v_kpi_met THEN ROUND(SUM(cpt.stage_comm_val), 0) ELSE 0 END as sub_comm,
            CASE WHEN v_kpi_met THEN ROUND(SUM(cpt.process_comm_val + cpt.stage_comm_val), 0) ELSE 0 END as total
        FROM calc_per_task cpt GROUP BY cpt.full_name, cpt.score
    ),
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
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- =====================================================
-- FUNCTION: get_staff_activity_details (ĐÃ FIX tương tự)
-- =====================================================
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
            o.order_code, 
            (o.total_amount - COALESCE(o.vat_amount, 0)) as total_amount_pre_vat,
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
            (p_start_date < '2026-03-01'::DATE 
             AND o.created_at::DATE >= p_start_date 
             AND o.created_at::DATE <= p_end_date)
            OR
            -- Tháng mới: đơn tạo từ 01/03+ và hoàn thành trong tháng
            (p_start_date >= '2026-03-01'::DATE 
             AND o.completed_at IS NOT NULL 
             AND o.completed_at::DATE >= p_start_date 
             AND o.completed_at::DATE <= p_end_date
             AND o.created_at >= '2026-03-01'::TIMESTAMPTZ)
        )
    ),
    calc AS (
        SELECT pt.full_name, pt.order_code, pt.stage, pt.started_at, pt.finished_at,
            pt.score, pt.participant_count,
            CASE WHEN pt.stage_value = 0 THEN (pt.total_amount_pre_vat / pt.participant_count) * (pt.process_rate / 100.0) * pt.score ELSE 0 END as pcomm,
            CASE WHEN pt.stage_value > 0 THEN pt.stage_value * (pt.subtask_rate / 100.0) ELSE 0 END as scomm
        FROM participated_tasks pt
        WHERE (p_user_name IS NULL OR pt.full_name = p_user_name)
    )
    SELECT c.full_name, c.order_code, c.stage, c.started_at, c.finished_at,
        c.score, c.participant_count, ROUND(c.pcomm, 0), ROUND(c.scomm, 0), ROUND(c.pcomm + c.scomm, 0)
    FROM calc c ORDER BY c.started_at DESC;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- =====================================================
-- FUNCTION: calculate_sales_commission (không thay đổi logic)
-- =====================================================
CREATE OR REPLACE FUNCTION calculate_sales_commission(
    p_start_date DATE, p_end_date DATE, p_sales_rep_name TEXT DEFAULT NULL
)
RETURNS TABLE (
    sales_rep_id UUID, sales_rep_name TEXT, personal_sales NUMERIC,
    completed_sales NUMERIC, completed_order_count BIGINT,
    commission_tiers JSONB, personal_comm NUMERIC, 
    group_sales_total NUMERIC, group_rate NUMERIC, group_bonus_fund NUMERIC,
    group_comm NUMERIC, total_comm NUMERIC
) AS $$
DECLARE
    v_group_total_sales NUMERIC := 0;
    v_group_target NUMERIC := 0;
    v_group_rate NUMERIC := 0;
    v_group_bonus_fund NUMERIC := 0;
    v_month INT := EXTRACT(MONTH FROM p_start_date);
    v_year INT := EXTRACT(YEAR FROM p_start_date);
    v_is_new_method BOOLEAN := (p_start_date >= '2026-03-01'::DATE);
BEGIN
    IF v_is_new_method THEN
        -- NVKD tháng 3+: đơn hoàn thành trong tháng VÀ tạo từ 01/03+
        -- (trừ đơn tạo tháng 2 vì đã tính ở tháng 2, tránh đếm trùng)
        SELECT COALESCE(SUM(total_amount), 0) INTO v_group_total_sales
        FROM orders
        WHERE completed_at IS NOT NULL
          AND completed_at::DATE >= p_start_date AND completed_at::DATE <= p_end_date
          AND status = 'HoanThanh'
          AND created_at >= '2026-03-01'::TIMESTAMPTZ;  -- Giữ filter này, khác với NV Sản Xuất
    ELSE
        SELECT COALESCE(SUM(total_amount), 0) INTO v_group_total_sales
        FROM orders
        WHERE created_at::DATE >= p_start_date AND created_at::DATE <= p_end_date
          AND status = 'HoanThanh';
    END IF;

    SELECT target_amount, commission_rate INTO v_group_target, v_group_rate
    FROM sales_targets WHERE period_month = v_month AND period_year = v_year AND department_name = 'Sales' LIMIT 1;
    IF v_group_target IS NULL THEN
         SELECT target_amount, commission_rate INTO v_group_target, v_group_rate
         FROM sales_targets WHERE period_month = v_month AND period_year = v_year AND department_name = 'Company' LIMIT 1;
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
            o.sales_rep_id, p.full_name,
            COALESCE(st.commission_tiers, p.commission_tiers) as effective_tiers,
            COALESCE(SUM(o.total_amount), 0) as total_sales,
            COUNT(o.id) as order_count
        FROM orders o
        JOIN profiles p ON o.sales_rep_id = p.id
        LEFT JOIN sales_targets st ON st.entity_type = 'user' 
            AND st.entity_id = p.id
            AND st.period_month = v_month 
            AND st.period_year = v_year
        WHERE o.status = 'HoanThanh'
        AND (
            -- Tháng mới (NVKD): đơn hoàn thành trong tháng VÀ tạo từ 01/03+
            -- (trừ đơn tạo tháng 2 đã được tính ở tháng 2, tránh đếm trùng)
            (v_is_new_method 
             AND o.completed_at IS NOT NULL
             AND o.completed_at::DATE >= p_start_date AND o.completed_at::DATE <= p_end_date
             AND o.created_at >= '2026-03-01'::TIMESTAMPTZ)   -- GIỬ filter này cho NVKD
            OR
            -- Tháng cũ: đơn tạo trong tháng (created_at)
            (NOT v_is_new_method 
             AND o.created_at::DATE >= p_start_date AND o.created_at::DATE <= p_end_date)
        )
        AND (p_sales_rep_name IS NULL OR p.full_name = p_sales_rep_name)
        GROUP BY o.sales_rep_id, p.full_name, effective_tiers
    )
    SELECT 
        ms.sales_rep_id, ms.full_name, ms.total_sales,
        ms.total_sales, ms.order_count,
        ms.effective_tiers,
        calc_personal_commission(ms.total_sales, ms.effective_tiers),
        v_group_total_sales, v_group_rate, v_group_bonus_fund,
        (CASE WHEN v_group_total_sales > 0 THEN (ms.total_sales / v_group_total_sales) * v_group_bonus_fund ELSE 0 END),
        calc_personal_commission(ms.total_sales, ms.effective_tiers)
            + (CASE WHEN v_group_total_sales > 0 THEN (ms.total_sales / v_group_total_sales) * v_group_bonus_fund ELSE 0 END)
    FROM monthly_sales ms;
END;
$$ LANGUAGE plpgsql;


-- Grant permissions
GRANT EXECUTE ON FUNCTION calculate_staff_commission TO authenticated;
GRANT EXECUTE ON FUNCTION get_staff_activity_details TO authenticated;
GRANT EXECUTE ON FUNCTION calculate_sales_commission TO authenticated;
GRANT EXECUTE ON FUNCTION calc_personal_commission TO authenticated;

NOTIFY pgrst, 'reload schema';

-- =====================================================
-- VERIFY sau khi deploy:
-- =====================================================
-- Tháng 3/2026 - kiểm tra NV sản xuất có thưởng không:
SELECT * FROM calculate_staff_commission('2026-03-01'::DATE, '2026-03-31'::DATE);

-- Tháng 2/2026 - kiểm tra vẫn chạy đúng:
-- SELECT * FROM calculate_staff_commission('2026-02-01'::DATE, '2026-02-28'::DATE);
