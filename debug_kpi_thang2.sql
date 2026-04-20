-- =====================================================
-- DEBUG QUICK: In ra các giá trị nội bộ function tháng 2/2026
-- Chạy TOÀN BỘ block này trong Supabase SQL Editor
-- =====================================================

DO $$
DECLARE
    v_kpi_revenue NUMERIC := 0;
    v_company_target NUMERIC := 0;
    v_total_revenue_pre_vat NUMERIC := 0;
    v_kpi_met BOOLEAN := TRUE;
BEGIN
    -- Tính doanh thu KPI (cách cũ - created_at, tháng 2)
    SELECT COALESCE(SUM(total_amount - COALESCE(vat_amount, 0)), 0) INTO v_kpi_revenue
    FROM orders WHERE status != 'Huy'
    AND created_at::DATE >= '2026-02-01' AND created_at::DATE <= '2026-02-28';

    -- Lấy target từ sales_targets
    SELECT COALESCE(target_amount, 0) INTO v_company_target
    FROM sales_targets 
    WHERE department_name = 'Company' 
    AND period_month = 2 AND period_year = 2026
    LIMIT 1;
    v_company_target := COALESCE(v_company_target, 0);

    -- KPI check
    IF v_company_target > 0 AND v_kpi_revenue < v_company_target THEN
        v_kpi_met := FALSE;
    END IF;

    -- Manager revenue
    SELECT COALESCE(SUM(total_amount - COALESCE(vat_amount, 0)), 0) INTO v_total_revenue_pre_vat
    FROM orders WHERE status = 'HoanThanh'
    AND created_at::DATE >= '2026-02-01' AND created_at::DATE <= '2026-02-28';

    RAISE NOTICE '=== DEBUG THÁNG 2/2026 ===';
    RAISE NOTICE 'v_kpi_revenue     = %', v_kpi_revenue;
    RAISE NOTICE 'v_company_target  = %', v_company_target;
    RAISE NOTICE 'v_kpi_met         = %', v_kpi_met;
    RAISE NOTICE 'v_total_rev_mgr   = %', v_total_revenue_pre_vat;
    RAISE NOTICE '========================';
    
    IF v_company_target = 0 THEN
        RAISE NOTICE '⚠️  KHÔNG có KPI target tháng 2 → luôn đạt';
    ELSIF v_kpi_met THEN
        RAISE NOTICE '✅ KPI ĐẠT: % >= %', v_kpi_revenue, v_company_target;
    ELSE
        RAISE NOTICE '❌ KPI KHÔNG ĐẠT: % < %', v_kpi_revenue, v_company_target;
        RAISE NOTICE '   Thiếu: %', v_company_target - v_kpi_revenue;
    END IF;
END;
$$;

-- Sau khi chạy DO block, xem MESSAGES tab trong Supabase để thấy RAISE NOTICE
-- Hoặc dùng query đơn giản này:
SELECT 
    (SELECT COALESCE(SUM(total_amount - COALESCE(vat_amount,0)),0) FROM orders 
     WHERE status != 'Huy' AND created_at::DATE BETWEEN '2026-02-01' AND '2026-02-28') as v_kpi_revenue,
    (SELECT COALESCE(target_amount, 0) FROM sales_targets 
     WHERE department_name='Company' AND period_month=2 AND period_year=2026 LIMIT 1) as v_company_target,
    (SELECT COUNT(*) FROM sales_targets 
     WHERE department_name='Company' AND period_month=2 AND period_year=2026) as co_record_company;
