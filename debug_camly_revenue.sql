-- =====================================================
-- DEBUG DOANH THU CẨM LY THÁNG 3
-- =====================================================

-- Truy vấn 1: Doanh thu tạo trong tháng 3 (Dashboard)
SELECT '1. Doanh thu tạo trong T3 (Dashboard)' as loai,
       COUNT(*) as so_don,
       SUM(total_amount - COALESCE(vat_amount, 0)) as doanh_thu_chua_vat,
       SUM(total_amount) as doanh_thu_co_vat
FROM orders o
JOIN profiles p ON o.sales_rep_id = p.id
WHERE p.full_name ILIKE '%Cẩm Ly%'
AND o.created_at >= '2026-03-01'::TIMESTAMPTZ
AND o.created_at < '2026-04-01'::TIMESTAMPTZ
AND o.status != 'Huy';

-- Truy vấn 2: Doanh thu hoàn thành trong tháng 3 (Thưởng NVKD)
-- THEO LOGIC MỚI: completed_at trong T3 VÀ created_at >= 01/03/2026
SELECT '2. Doanh thu hoàn thành trong T3 (ĐÚNG LOGIC MỚI)' as loai,
       COUNT(*) as so_don,
       SUM(total_amount - COALESCE(vat_amount, 0)) as doanh_thu_chua_vat,
       SUM(total_amount) as doanh_thu_co_vat
FROM orders o
JOIN profiles p ON o.sales_rep_id = p.id
WHERE p.full_name ILIKE '%Cẩm Ly%'
AND o.status = 'HoanThanh'
AND o.completed_at >= '2026-03-01'::DATE 
AND o.completed_at < '2026-04-01'::DATE
AND o.created_at >= '2026-03-01'::TIMESTAMPTZ;

-- Truy vấn 3: Doanh thu hoàn thành trong tháng 3 (LOGIC BỊ SAI TRƯỚC FIX)
-- chỉ completed_at trong T3, không xét created_at
SELECT '3. Doanh thu hoàn thành trong T3 (NẾU CHƯA FIX LỖI TRÙNG T2)' as loai,
       COUNT(*) as so_don,
       SUM(total_amount - COALESCE(vat_amount, 0)) as doanh_thu_chua_vat,
       SUM(total_amount) as doanh_thu_co_vat
FROM orders o
JOIN profiles p ON o.sales_rep_id = p.id
WHERE p.full_name ILIKE '%Cẩm Ly%'
AND o.status = 'HoanThanh'
AND o.completed_at >= '2026-03-01'::DATE 
AND o.completed_at < '2026-04-01'::DATE;

-- Truy vấn 4: Tính thử bằng function hiện tại trong DB
SELECT * FROM calculate_sales_commission('2026-03-01'::DATE, '2026-03-31'::DATE, 'Nguyễn Thị Cẩm Ly');
