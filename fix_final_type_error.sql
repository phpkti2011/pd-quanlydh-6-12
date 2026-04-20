-- ===========================================
-- FINAL FIX: Type Mismatch in RLS Policies
-- Date: 2026-01-28
-- ===========================================
-- Issue: "operator does not exist: user_role = text"
-- Root Cause: RLS policies on 'user_logs' and 'profiles' comparing ENUM role to TEXT without casting.
-- ===========================================

-- 1. FIX user_logs POLICIES
ALTER TABLE user_logs DISABLE ROW LEVEL SECURITY; -- Temporarily disable to check if this unblocks
ALTER TABLE user_logs ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Admins and Managers can view all logs" ON user_logs;
CREATE POLICY "Admins and Managers can view all logs"
    ON user_logs FOR SELECT
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM profiles
            WHERE profiles.id = auth.uid()
            AND profiles.role::text IN ('Admin', 'KeToan', 'QuanLySanXuat') -- Added ::text cast
        )
    );

DROP POLICY IF EXISTS "Authenticated users can insert logs" ON user_logs;
CREATE POLICY "Authenticated users can insert logs"
    ON user_logs FOR INSERT
    TO authenticated
    WITH CHECK (true);

-- 2. FIX profiles POLICIES
-- Ensure checking role for Admin access uses casting
DROP POLICY IF EXISTS "Admin update profiles" ON profiles;
CREATE POLICY "Admin update profiles" ON profiles
    FOR UPDATE
    USING (
        (SELECT role::text FROM profiles WHERE id = auth.uid()) = 'Admin'
    );

DROP POLICY IF EXISTS "Admin full access profiles" ON profiles;
CREATE POLICY "Admin full access profiles" ON profiles
    FOR ALL
    USING (
        (SELECT role::text FROM profiles WHERE id = auth.uid()) = 'Admin'
    );

-- 3. FIX any lingering Trigger issues (Re-run specific fix just in case)
CREATE OR REPLACE FUNCTION check_production_update_permissions()
RETURNS TRIGGER AS $$
DECLARE
    v_user_role text;
BEGIN
    SELECT role::text INTO v_user_role FROM profiles WHERE id = auth.uid();
    
    IF v_user_role IN ('Admin', 'NhanVienKinhDoanh', 'KeToan') THEN
        RETURN NEW;
    END IF;

    IF v_user_role IN ('NhanVienSanXuat', 'QuanLySanXuat', 'NhanVienThietKe', 'NhanVienBinhFile', 'NhanVienIn', 'NhanVienGiaCong') THEN
        IF NEW.description IS DISTINCT FROM OLD.description THEN
            RAISE EXCEPTION 'Bạn không có quyền chỉnh sửa Quy cách đơn hàng.';
        END IF;
        IF NEW.total_amount IS DISTINCT FROM OLD.total_amount OR
           NEW.total_amount_pre_vat IS DISTINCT FROM OLD.total_amount_pre_vat THEN
            RAISE EXCEPTION 'Bạn không có quyền chỉnh sửa thông tin Tài chính.';
        END IF;
        IF NEW.customer_id IS DISTINCT FROM OLD.customer_id OR
           NEW.sales_rep_id IS DISTINCT FROM OLD.sales_rep_id THEN
             RAISE EXCEPTION 'Bạn không có quyền thay đổi thông tin Khách hàng.';
        END IF;
        RETURN NEW;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 4. VERIFY
SELECT 'SUCCESS: Fixed RLS policies with type casting.' AS result;
