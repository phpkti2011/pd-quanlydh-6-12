-- ============================================================================
-- BACKFILL: điền đủ key cho commission_stages / commission_subtasks
-- ============================================================================
-- !! CHẠY NGAY SAU fix_stage_rate_no_fallback.sql, TRONG CÙNG MỘT LƯỢT !!
--    Giữa 2 bước đó, các khâu Ép Kim / Đã giao hàng / Bế Demi tạm về 0.
--    Script này chính là thứ giữ lại tiền cho 3 khâu đó.
--
-- MỤC ĐÍCH
--   1. Điền giá trị cho những key còn thiếu:
--        - Các khâu thường  -> 0  (đây chính là lỗi cần sửa: xưa nay chúng âm
--          thầm ăn mức chung, VD In = 20%, dù giao diện hiển thị 0).
--        - Ép Kim / Đã giao hàng / Bế Demi -> GIỮ NGUYÊN mức đang chạy, đọc
--          thẳng từ bảng commission_policies. Ba khâu này trước đây không có ô
--          cấu hình trong modal nên mọi người đều ăn mức chung; vá bằng 0 sẽ
--          cắt tiền của họ.
--   2. Đổi giá trị null thành 0 -> di chứng của parseFloat('') = NaN ở giao diện
--      (VD Trần Trinh Y: {"DongGoi": null, "ThanhPham": 1}).
--   3. Xoá key rác chữ thường / snake_case không bao giờ khớp part.stage
--      (VD ad@pd.com: {"in":0.05,"dong_goi":0.01,...}; testnvsx có cả "In" lẫn "in").
--
-- PHẠM VI: mọi profile trừ NhanVienKinhDoanh (NVKD không ăn hoa hồng sản xuất —
--          xem điều kiện p.role != 'NhanVienKinhDoanh' trong hàm tính thưởng).
--
-- Danh sách key phải khớp đúng 2 mảng đang render trong
-- components/EmployeeManager.tsx (tab Hoa hồng Quy trình / Hoa hồng Công đoạn).
-- ============================================================================


-- ----------------------------------------------------------------------------
-- BƯỚC 0. Xem hiện trạng TRƯỚC khi vá (chạy riêng, đọc kết quả rồi mới chạy tiếp)
-- ----------------------------------------------------------------------------
SELECT
    full_name,
    role,
    commission_stages,
    commission_subtasks
FROM profiles
WHERE role != 'NhanVienKinhDoanh'
ORDER BY full_name;


-- ----------------------------------------------------------------------------
-- BƯỚC 1. Xoá key rác chữ thường / snake_case
--         Toán tử #- xoá 1 key; nối liên tiếp để xoá nhiều key.
-- ----------------------------------------------------------------------------
UPDATE profiles
SET commission_stages =
        COALESCE(commission_stages, '{}'::jsonb)
        #- '{in}'          #- '{dong_goi}'   #- '{binh_file}'
        #- '{giao_hang}'   #- '{nhan_file}'  #- '{thanh_pham}'
        #- '{xu_ly_file}'  #- '{ep_kim}'     #- '{cho_giao_hang}'
WHERE role != 'NhanVienKinhDoanh';

UPDATE profiles
SET commission_subtasks =
        COALESCE(commission_subtasks, '{}'::jsonb)
        #- '{design}'      #- '{large_print}'  #- '{thiet_ke}'
        #- '{in_kho_lon}'  #- '{be_demi}'      #- '{gia_cong_ngoai}'
WHERE role != 'NhanVienKinhDoanh';


-- ----------------------------------------------------------------------------
-- BƯỚC 2. Đổi mọi giá trị null thành 0
--         Duyệt từng cặp key/value, thay null bằng 0, gộp lại thành object.
-- ----------------------------------------------------------------------------
UPDATE profiles p
SET commission_stages = COALESCE(
        (
            SELECT jsonb_object_agg(kv.key, COALESCE(kv.value, '0'::jsonb))
            FROM jsonb_each(p.commission_stages) AS kv(key, value)
        ),
        '{}'::jsonb
    )
WHERE p.role != 'NhanVienKinhDoanh'
  AND p.commission_stages IS NOT NULL
  AND EXISTS (
      SELECT 1 FROM jsonb_each(p.commission_stages) AS kv(key, value)
      WHERE jsonb_typeof(kv.value) = 'null'
  );

UPDATE profiles p
SET commission_subtasks = COALESCE(
        (
            SELECT jsonb_object_agg(kv.key, COALESCE(kv.value, '0'::jsonb))
            FROM jsonb_each(p.commission_subtasks) AS kv(key, value)
        ),
        '{}'::jsonb
    )
WHERE p.role != 'NhanVienKinhDoanh'
  AND p.commission_subtasks IS NOT NULL
  AND EXISTS (
      SELECT 1 FROM jsonb_each(p.commission_subtasks) AS kv(key, value)
      WHERE jsonb_typeof(kv.value) = 'null'
  );


-- ----------------------------------------------------------------------------
-- BƯỚC 3. Điền giá trị cho các key còn thiếu
--         Thứ tự `mặc định || hiện có` rất quan trọng: vế PHẢI thắng, nên giá
--         trị đã cấu hình tường minh được giữ nguyên, chỉ key thiếu mới nhận
--         giá trị mặc định bên dưới.
--
--         Đọc mức từ commission_policies đang chạy (không hardcode) để chắc
--         chắn khớp production. Số trong COALESCE chỉ là phao cứu sinh nếu
--         bảng chính sách thiếu dòng.
-- ----------------------------------------------------------------------------
UPDATE profiles
SET commission_stages =
        jsonb_build_object(
            -- Về 0: đây chính là các khâu đang rò rỉ mức chung
            'NhanFile',  0,
            'XuLyFile',  0,
            'BinhFile',  0,
            'In',        0,
            'ThanhPham', 0,
            'DongGoi',   0,
            'GiaoHang',  0,
            -- GIỮ NGUYÊN mức đang chạy (chưa từng có ô cấu hình trong modal)
            'EpKim',      COALESCE((SELECT rate FROM commission_policies
                                    WHERE policy_type = 'MAINTASK_RATE'
                                      AND apply_to = 'EpKim' LIMIT 1), 15),
            'DaGiaoHang', COALESCE((SELECT rate FROM commission_policies
                                    WHERE policy_type = 'MAINTASK_RATE'
                                      AND apply_to = 'DaGiaoHang' LIMIT 1), 5)
        ) || COALESCE(commission_stages, '{}'::jsonb)
WHERE role != 'NhanVienKinhDoanh';

UPDATE profiles
SET commission_subtasks =
        jsonb_build_object(
            -- Mức chung của 3 khâu này vốn đã là 0, để 0 không ai mất gì
            'ThietKe',      0,
            'InKhoLon',     0,
            'GiaCongNgoai', 0,
            -- GIỮ NGUYÊN mức đang chạy
            'EpKim',  COALESCE((SELECT rate FROM commission_policies
                                WHERE policy_type = 'SUBTASK_RATE'
                                  AND apply_to = 'EpKim' LIMIT 1), 2),
            'BeDemi', COALESCE((SELECT rate FROM commission_policies
                                WHERE policy_type = 'SUBTASK_RATE'
                                  AND apply_to = 'BeDemi' LIMIT 1), 2)
        ) || COALESCE(commission_subtasks, '{}'::jsonb)
WHERE role != 'NhanVienKinhDoanh';


-- ----------------------------------------------------------------------------
-- BƯỚC 4. Đối chiếu SAU khi vá
--         Kỳ vọng: cột thieu_key_quy_trinh và thieu_key_cong_doan đều = 0,
--         cột co_gia_tri_null = false ở mọi dòng.
-- ----------------------------------------------------------------------------
SELECT
    full_name,
    role,
    commission_stages,
    commission_subtasks,
    -- Dùng jsonb_exists() thay cho toán tử `?` vì một số client SQL hiểu nhầm
    -- dấu ? là placeholder tham số.
    (SELECT COUNT(*) FROM unnest(ARRAY[
        'NhanFile','XuLyFile','BinhFile','In','ThanhPham',
        'EpKim','DongGoi','GiaoHang','DaGiaoHang'
     ]) k WHERE NOT jsonb_exists(commission_stages, k))   AS thieu_key_quy_trinh,
    (SELECT COUNT(*) FROM unnest(ARRAY[
        'ThietKe','InKhoLon','BeDemi','GiaCongNgoai','EpKim'
     ]) k WHERE NOT jsonb_exists(commission_subtasks, k)) AS thieu_key_cong_doan,
    EXISTS (
        SELECT 1 FROM jsonb_each(commission_stages) kv
        WHERE jsonb_typeof(kv.value) = 'null'
        UNION ALL
        SELECT 1 FROM jsonb_each(commission_subtasks) kv
        WHERE jsonb_typeof(kv.value) = 'null'
    )                                                   AS co_gia_tri_null
FROM profiles
WHERE role != 'NhanVienKinhDoanh'
ORDER BY full_name;
