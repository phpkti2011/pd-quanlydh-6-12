-- =====================================================
-- FIX: Xóa bản ghi KPI trùng lặp trong sales_targets
-- Nguyên nhân: entity_id = NULL không bị ràng buộc bởi UNIQUE constraint
-- =====================================================

-- BƯỚC 1: Xem tất cả bản ghi Company để hiểu rõ
SELECT id, entity_type, department_name, period_month, period_year, 
       target_amount, commission_rate, created_at, updated_at
FROM sales_targets
WHERE department_name = 'Company'
ORDER BY period_year, period_month, created_at DESC;

-- BƯỚC 2: Xóa bản ghi trùng — GIỮ LẠI bản ghi MỚI NHẤT (created_at lớn nhất)
-- cho mỗi (department_name, period_month, period_year)
DELETE FROM sales_targets
WHERE id IN (
    SELECT id FROM (
        SELECT id,
               ROW_NUMBER() OVER (
                   PARTITION BY department_name, period_month, period_year
                   ORDER BY COALESCE(updated_at, created_at) DESC  -- Giữ mới nhất
               ) as rn
        FROM sales_targets
        WHERE entity_type IN ('company', 'department')  -- Chỉ xóa Company/Sales records
        AND department_name IS NOT NULL
    ) ranked
    WHERE rn > 1  -- Xóa tất cả trừ bản ghi mới nhất
);

-- BƯỚC 3: Kiểm tra sau khi xóa
SELECT department_name, period_month, period_year, target_amount, commission_rate, updated_at
FROM sales_targets
WHERE department_name IN ('Company', 'Sales')
ORDER BY period_year DESC, period_month DESC, department_name;

-- BƯỚC 4: Verify tháng 2 đã đúng
SELECT 
    (SELECT COALESCE(SUM(total_amount - COALESCE(vat_amount,0)),0) FROM orders 
     WHERE status != 'Huy' AND created_at::DATE BETWEEN '2026-02-01' AND '2026-02-28') as v_kpi_revenue,
    (SELECT COALESCE(target_amount, 0) FROM sales_targets 
     WHERE department_name='Company' AND period_month=2 AND period_year=2026 
     ORDER BY COALESCE(updated_at, created_at) DESC LIMIT 1) as v_company_target_moi_nhat;
