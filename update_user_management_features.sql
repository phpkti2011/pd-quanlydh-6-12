-- ==============================================================================
-- UPDATE USER MANAGEMENT FEATURES
-- 1. Add Locking Mechanism
-- 2. Enable Permanent Deletion (Cascading)
-- ==============================================================================

-- 1. Add is_locked column
ALTER TABLE profiles 
ADD COLUMN IF NOT EXISTS is_locked BOOLEAN DEFAULT FALSE;

-- 2. Update Foreign Key Constraints to allow Deletion from Profiles (Auth.Users)

-- Orders: SALES_REP_ID -> Set Null (Keep the order, just remove the rep assignment)
ALTER TABLE orders 
DROP CONSTRAINT IF EXISTS orders_sales_rep_id_fkey;

ALTER TABLE orders
ADD CONSTRAINT orders_sales_rep_id_fkey
FOREIGN KEY (sales_rep_id) 
REFERENCES profiles(id)
ON DELETE SET NULL;

-- Audit Logs: PERFORMED_BY -> Set Null (Keep the history, remove the actor link)
-- Skip if table doesn't exist (DB này dùng user_logs thay vì audit_logs)
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'audit_logs') THEN
        EXECUTE 'ALTER TABLE audit_logs DROP CONSTRAINT IF EXISTS audit_logs_performed_by_fkey';
        EXECUTE 'ALTER TABLE audit_logs ADD CONSTRAINT audit_logs_performed_by_fkey FOREIGN KEY (performed_by) REFERENCES profiles(id) ON DELETE SET NULL';
    END IF;
END $$;

-- Order Process Participants -> CASCADE (Remove the work participation record)
ALTER TABLE order_process_participants
DROP CONSTRAINT IF EXISTS order_process_participants_user_id_fkey;

ALTER TABLE order_process_participants
ADD CONSTRAINT order_process_participants_user_id_fkey
FOREIGN KEY (user_id)
REFERENCES profiles(id)
ON DELETE CASCADE;

-- 3. Create Admin Function to Delete User (Requires Security Definer to touch auth.users)
CREATE OR REPLACE FUNCTION admin_delete_user(target_user_id UUID)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
    -- Check if requesting user is Admin (optional, but good practice)
    -- However, RLS on the RPC execution is usually handled by Supabase, 
    -- and we will call this via the client which must have Admin role to see the button.
    -- Strict check:
    IF NOT EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'Admin') THEN
        RAISE EXCEPTION 'Access Denied: Only Admins can delete users.';
    END IF;

    -- XOÁ MỀM, KHÔNG xoá auth.users.
    --
    -- Bản cũ ở đây là `DELETE FROM auth.users WHERE id = target_user_id;` và nó
    -- LUÔN thất bại: user_logs.user_id tham chiếu auth.users(id) mà không có
    -- ON DELETE (create_audit_logs.sql:5), nên Postgres chặn với lỗi
    -- "violates foreign key constraint user_logs_user_id_fkey".
    -- Ai từng đăng nhập đều có dòng trong user_logs => hỏng với mọi nhân viên.
    --
    -- Ngoài ra order_process_participants.user_id là ON DELETE CASCADE, nên nếu
    -- có xoá cứng được thì cũng mất sạch lịch sử công đoạn — đúng thứ hộp thoại
    -- xác nhận ở giao diện hứa GIỮ LẠI.
    --
    -- ĐỪNG đưa DELETE quay lại. Xem fix_admin_delete_user_soft.sql.
    UPDATE profiles
    SET
        deleted_at = NOW(),
        is_locked  = TRUE,
        updated_at = NOW()
    WHERE id = target_user_id;
END;
$$;

-- 4. Create Admin Function to Lock/Unlock User
CREATE OR REPLACE FUNCTION admin_toggle_lock_user(target_user_id UUID, p_is_locked BOOLEAN)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'Admin') THEN
        RAISE EXCEPTION 'Access Denied: Only Admins can lock/unlock users.';
    END IF;

    UPDATE profiles 
    SET is_locked = p_is_locked,
        updated_at = NOW()
    WHERE id = target_user_id;
END;
$$;

-- 5. Force Schema Reload
NOTIFY pgrst, 'reload schema';
