-- =====================================================
-- DEBUG: Tại sao Trần Hải Âu không có hoa hồng In Khổ Lớn
-- Chạy từng query trong Supabase SQL Editor
-- =====================================================

-- QUERY 1: Kiểm tra commission_subtasks trong database
-- (xem InKhoLon có được lưu đúng không)
SELECT full_name, role, 
       commission_subtasks,
       commission_subtasks->>'InKhoLon' as inkholon_rate
FROM profiles
WHERE full_name ILIKE '%hải âu%' OR full_name ILIKE '%hai au%';

-- QUERY 2: Kiểm tra Trần Hải Âu có tham gia công đoạn InKhoLon không
SELECT o.order_code, o.status, o.has_large_print, 
       o.large_print_fee, o.completed_at::DATE as ngay_hoan_thanh,
       o.created_at::DATE as ngay_tao,
       part.stage
FROM order_process_participants part
JOIN orders o ON part.order_id = o.id
JOIN profiles p ON part.user_id = p.id
WHERE (p.full_name ILIKE '%hải âu%' OR p.full_name ILIKE '%hai au%')
AND part.stage = 'InKhoLon'
ORDER BY o.created_at DESC
LIMIT 20;

-- QUERY 3: Kiểm tra các đơn có InKhoLon mà large_print_fee = 0 hoặc NULL
SELECT COUNT(*) as so_don_inkholon_khong_co_phi,
       COUNT(*) FILTER (WHERE o.large_print_fee > 0) as co_phi,
       COUNT(*) FILTER (WHERE o.large_print_fee = 0 OR o.large_print_fee IS NULL) as khong_co_phi
FROM order_process_participants part
JOIN orders o ON part.order_id = o.id
JOIN profiles p ON part.user_id = p.id
WHERE (p.full_name ILIKE '%hải âu%' OR p.full_name ILIKE '%hai au%')
AND part.stage = 'InKhoLon'
AND o.status = 'HoanThanh';
