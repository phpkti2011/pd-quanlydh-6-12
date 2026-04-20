-- =====================================================
-- FIX: FORCE ZERO COMMISSION FOR LƯƠNG TRUNG HẬU
-- Nguyên nhân: UI hiển thị 0 nhưng bản chất là "Chưa cấu hình" -> Hệ thống tự lấy mức Chung (Global Policy).
-- Script này sẽ set cứng các mức hoa hồng về 0 cho nhân viên này.
-- =====================================================

UPDATE profiles
SET commission_stages = jsonb_build_object(
    'NhanFile', 0,
    'XuLyFile', 0,
    'BinhFile', 0,
    'In', 0,
    'ThieKe', 0, -- Typo in old data? Adding just in case/cleanup
    'ThanhPham', 0,
    'DongGoi', 0,
    'GiaoHang', 0,
    'ChoGiaoHang', 0
) || COALESCE(commission_stages, '{}'::jsonb) -- Preserve other existing keys if any
WHERE full_name = 'Lương Trung Hậu';

-- Verify update
SELECT full_name, commission_stages 
FROM profiles 
WHERE full_name = 'Lương Trung Hậu';
