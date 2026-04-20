-- =====================================================
-- DEBUG: KPI Revenue Check - Chạy từng query trong Supabase SQL Editor
-- Mục đích: Xác định tại sao KPI đạt nhưng không tính thưởng
-- =====================================================

-- === THAY ĐỔI THÁNG/NĂM Ở ĐÂY ===
-- Hiện tại đang debug tháng 3/2026
DO $$ BEGIN
    RAISE NOTICE 'Debug cho tháng: 3/2026, từ 2026-03-01 đến 2026-03-31';
END $$;

-- =====================================================
-- QUERY 1: Kiểm tra function hiện tại đang deploy (version nào)
-- =====================================================
SELECT 
    p.proname as function_name,
    pg_get_function_arguments(p.oid) as arguments,
    LEFT(pg_get_functiondef(p.oid), 500) as first_500_chars
FROM pg_proc p
WHERE p.proname = 'calculate_staff_commission'
ORDER BY p.oid DESC;

-- =====================================================
-- QUERY 2: Kiểm tra doanh thu KPI thực tế (cách tính trong function)
-- Đây là v_kpi_revenue trong function
-- =====================================================
SELECT 
    COUNT(*) as so_don,
    SUM(total_amount) as tong_total_amount,
    SUM(COALESCE(vat_amount, 0)) as tong_vat_amount,
    SUM(total_amount - COALESCE(vat_amount, 0)) as doanh_thu_kpi_tinh_duoc,
    COUNT(*) FILTER (WHERE vat_amount IS NULL) as so_don_null_vat
FROM orders 
WHERE status != 'Huy'
AND created_at::DATE >= '2026-03-01' AND created_at::DATE <= '2026-03-31';

-- =====================================================
-- QUERY 3: Kiểm tra mục tiêu KPI trong bảng sales_targets
-- =====================================================
SELECT 
    id, entity_type, department_name, period_month, period_year, 
    target_amount, commission_rate
FROM sales_targets
WHERE period_month = 3 AND period_year = 2026
ORDER BY department_name;

-- =====================================================
-- QUERY 4: Kiểm tra v_kpi_met thủ công
-- =====================================================
WITH kpi_data AS (
    SELECT 
        COALESCE(SUM(total_amount - COALESCE(vat_amount, 0)), 0) as v_kpi_revenue
    FROM orders 
    WHERE status != 'Huy'
    AND created_at::DATE >= '2026-03-01' AND created_at::DATE <= '2026-03-31'
),
target_data AS (
    SELECT COALESCE(target_amount, 0) as v_company_target
    FROM sales_targets 
    WHERE department_name = 'Company' 
    AND period_month = 3 AND period_year = 2026
    LIMIT 1
)
SELECT 
    kpi_data.v_kpi_revenue,
    COALESCE(target_data.v_company_target, 0) as v_company_target,
    CASE 
        WHEN COALESCE(target_data.v_company_target, 0) = 0 THEN 'KPI ĐẠT (target = 0, luôn đạt)'
        WHEN kpi_data.v_kpi_revenue >= COALESCE(target_data.v_company_target, 0) THEN 'KPI ĐẠT ✅'
        ELSE 'KPI KHÔNG ĐẠT ❌ — Thiếu: ' || (COALESCE(target_data.v_company_target, 0) - kpi_data.v_kpi_revenue)::TEXT
    END as ket_qua_kpi
FROM kpi_data
CROSS JOIN target_data;

-- =====================================================
-- QUERY 5: Gọi function trực tiếp (tháng 3/2026)
-- =====================================================
SELECT * FROM calculate_staff_commission('2026-03-01'::DATE, '2026-03-31'::DATE);

-- =====================================================
-- QUERY 6 (Tùy chọn): Nếu dùng tháng khác, thay đổi ngày ở đây
-- Ví dụ tháng 2/2026:
-- =====================================================
-- SELECT * FROM calculate_staff_commission('2026-02-01'::DATE, '2026-02-28'::DATE);
