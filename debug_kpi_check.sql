-- DEBUG: Check staff commission data for February 2026
-- Run ALL queries in Supabase SQL Editor

-- 1. Check if staff have participation records in Feb orders
SELECT p.full_name, p.role, COUNT(DISTINCT part.order_id) as orders_participated, COUNT(*) as total_participations
FROM order_process_participants part
JOIN orders o ON part.order_id = o.id
JOIN profiles p ON part.user_id = p.id
WHERE o.status = 'HoanThanh'
AND p.role NOT IN ('NhanVienKinhDoanh', 'QuanLySanXuat')
AND o.created_at::DATE >= '2026-02-01' AND o.created_at::DATE <= '2026-02-28'
GROUP BY p.full_name, p.role
ORDER BY total_participations DESC;

-- 2. Check commission rates for staff (commission_stages, commission_subtasks)
SELECT full_name, role, commission_stages, commission_subtasks, competency_score
FROM profiles 
WHERE role NOT IN ('NhanVienKinhDoanh', 'QuanLySanXuat')
AND deleted_at IS NULL
ORDER BY full_name;

-- 3. Check commission_policies table (global rates)
SELECT * FROM commission_policies ORDER BY policy_type, apply_to;

-- 4. Sample: show actual calculation for first 5 participation records
SELECT 
    p.full_name, p.role, part.stage, 
    o.order_code, o.total_amount_pre_vat, o.total_amount, o.vat_amount,
    (o.total_amount - COALESCE(o.vat_amount, 0)) as calculated_pre_vat,
    COALESCE((p.commission_stages->>part.stage)::NUMERIC, 0) as user_process_rate,
    COALESCE((p.commission_subtasks->>part.stage)::NUMERIC, 0) as user_subtask_rate,
    cp_proc.rate as global_process_rate,
    cp_sub.rate as global_subtask_rate,
    CASE 
        WHEN part.stage = 'ThietKe' THEN o.design_fee
        WHEN part.stage = 'InKhoLon' THEN o.large_print_fee
        WHEN part.stage = 'EpKim' THEN o.ep_kim_fee
        WHEN part.stage = 'BeDemi' THEN o.be_demi_fee
        WHEN part.stage = 'GiaCongNgoai' THEN o.gia_cong_ngoai_fee
        WHEN part.stage = 'CanMang' THEN o.can_mang_fee
        ELSE 0
    END as stage_fee
FROM order_process_participants part
JOIN orders o ON part.order_id = o.id
JOIN profiles p ON part.user_id = p.id
LEFT JOIN commission_policies cp_proc ON cp_proc.policy_type = 'MAINTASK_RATE' AND cp_proc.apply_to = part.stage
LEFT JOIN commission_policies cp_sub ON cp_sub.policy_type = 'SUBTASK_RATE' AND cp_sub.apply_to = part.stage
WHERE o.status = 'HoanThanh'
AND p.role NOT IN ('NhanVienKinhDoanh', 'QuanLySanXuat')
AND o.created_at::DATE >= '2026-02-01' AND o.created_at::DATE <= '2026-02-28'
LIMIT 10;
