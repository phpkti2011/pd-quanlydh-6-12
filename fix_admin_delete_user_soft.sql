-- ============================================================================
-- FIX: Nút xoá nhân viên báo lỗi khoá ngoại — trả admin_delete_user về XOÁ MỀM
-- ============================================================================
-- TRIỆU CHỨNG
--   Bấm nút xoá bất kỳ nhân viên nào trong Quản lý Nhân Viên đều báo:
--     update or delete on table "users" violates foreign key constraint
--     "user_logs_user_id_fkey" on table "user_logs"
--
-- NGUYÊN NHÂN
--   Hàm admin_delete_user đang chạy là bản XOÁ CỨNG (DELETE FROM auth.users),
--   trong khi user_logs.user_id tham chiếu auth.users(id) mà KHÔNG có ON DELETE
--   (create_audit_logs.sql:5) -> Postgres chặn. Ai từng đăng nhập đều có dòng
--   trong user_logs, nên nút xoá hỏng với MỌI nhân viên.
--
--   Repo có 2 định nghĩa hàm này, bản sai mới hơn nên đã ghi đè bản đúng:
--     secure_and_optimize.sql:7-30            (26/12/2025) - xoá mềm  [ĐÚNG]
--     update_user_management_features.sql:44  (29/04/2026) - xoá cứng [SAI]
--
--   Giao diện luôn hứa xoá mềm: hộp thoại xác nhận ghi rõ "Vô hiệu hóa tài
--   khoản (Soft Delete)" và "Lịch sử làm việc được GIỮ LẠI", danh sách nhân
--   viên cũng đã lọc sẵn .is('deleted_at', null).
--
-- CÁCH SỬA
--   Trả hàm về xoá mềm: đánh dấu deleted_at + khoá tài khoản, giữ nguyên bản
--   ghi. Không cần đụng tới ràng buộc khoá ngoại nào.
--
-- VÌ SAO KHÔNG ĐI ĐƯỜNG XOÁ CỨNG
--   Phải nới 7 ràng buộc: user_logs.user_id, app_settings.updated_by,
--   orders.payment_confirmed_by, customers.sales_rep_id,
--   customer_logs.created_by, sales_targets.entity_id,
--   production_defect_deductions.created_by.
--   Và order_process_participants.user_id đang là ON DELETE CASCADE -> sẽ xoá
--   sạch lịch sử công đoạn, đúng thứ hộp thoại hứa giữ, làm lệch báo cáo
--   thưởng của mọi tháng cũ.
--
-- ĐỪNG chạy lại update_user_management_features.sql bản cũ — nó sẽ ghi đè
-- hàm này về xoá cứng và lỗi quay lại y hệt. (File đó đã được sửa kèm theo.)
-- ============================================================================

CREATE OR REPLACE FUNCTION admin_delete_user(target_user_id UUID)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
    -- Chỉ Admin mới được xoá
    IF NOT EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'Admin') THEN
        RAISE EXCEPTION 'Access Denied: Only Admins can delete users.';
    END IF;

    -- XOÁ MỀM: đánh dấu đã nghỉ + khoá tài khoản, KHÔNG đụng auth.users.
    -- is_locked là thứ chặn đăng nhập (App.tsx kiểm tra cờ này), nên phải đặt
    -- cùng lúc với deleted_at.
    UPDATE profiles
    SET
        deleted_at = NOW(),
        is_locked  = TRUE,
        updated_at = NOW()
    WHERE id = target_user_id;
END;
$$;

NOTIFY pgrst, 'reload schema';

-- ============================================================================
-- KIỂM TRA SAU KHI CHẠY
-- ============================================================================
-- 1. Hàm không còn DELETE:
--    SELECT prosrc FROM pg_proc WHERE proname = 'admin_delete_user';
--
-- 2. Xoá thử trên giao diện, rồi soi lại bản ghi (thay <email>):
--    SELECT full_name, email, deleted_at, is_locked
--    FROM profiles WHERE email = '<email>';
--    -> dòng VẪN CÒN, deleted_at có giá trị, is_locked = true.
--
-- 3. Lịch sử còn nguyên — số dòng công đoạn của người đó không đổi:
--    SELECT COUNT(*) FROM order_process_participants
--    WHERE user_id = (SELECT id FROM profiles WHERE email = '<email>');
-- ============================================================================
