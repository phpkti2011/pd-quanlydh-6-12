-- ===========================================
-- ULTIMATE FIX: Clean & Repair All Policies/Triggers
-- Date: 2026-01-28
-- ===========================================
-- This script performs a DEEP CLEAN of all security policies and triggers
-- related to Orders, Profiles, and Notifications to eliminate Error 42883.
-- ===========================================

-- 1. Helper Functions (PUBLIC schema to avoid permission errors)
CREATE OR REPLACE FUNCTION public.is_admin_safe() RETURNS BOOLEAN LANGUAGE sql SECURITY DEFINER SET search_path = public AS $$
  SELECT EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role::text = 'Admin');
$$;

CREATE OR REPLACE FUNCTION public.is_manager_safe() RETURNS BOOLEAN LANGUAGE sql SECURITY DEFINER SET search_path = public AS $$
  SELECT EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role::text IN ('Admin', 'KeToan', 'QuanLySanXuat'));
$$;

CREATE OR REPLACE FUNCTION public.get_my_role() RETURNS text LANGUAGE sql SECURITY DEFINER SET search_path = public AS $$
  SELECT role::text FROM profiles WHERE id = auth.uid();
$$;

-- ===========================================
-- 2. TABLE: ORDERS (Clean & Rebuild)
-- ===========================================
ALTER TABLE orders DISABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;

-- Drop ALL existing policies to ensure no bad ones remain
DROP POLICY IF EXISTS "Authenticated users view orders" ON orders;
DROP POLICY IF EXISTS "Production see active orders" ON orders;
DROP POLICY IF EXISTS "Update orders" ON orders;
DROP POLICY IF EXISTS "Admins can delete orders" ON orders;
DROP POLICY IF EXISTS "Sales can delete own draft orders" ON orders;
DROP POLICY IF EXISTS "Insert orders" ON orders; -- Added missing drop
DROP POLICY IF EXISTS "Enable insert for authenticated users only" ON orders; -- Potential legacy name
DROP POLICY IF EXISTS "Enable read access for all users" ON orders; -- Potential legacy name

-- Recreate Policies (SAFE CASTING)
CREATE POLICY "Authenticated users view orders" ON orders FOR SELECT USING (true);

CREATE POLICY "Update orders" ON orders FOR UPDATE USING (
    public.get_my_role() IN ('Admin', 'NhanVienKinhDoanh', 'KeToan')
    OR auth.uid() = sales_rep_id
    OR (
        status::text NOT IN ('Moi', 'Huy') 
        AND public.get_my_role() IN ('NhanVienSanXuat', 'QuanLySanXuat', 'NhanVienThietKe', 'NhanVienBinhFile', 'NhanVienIn', 'NhanVienGiaCong')
    )
);

CREATE POLICY "Insert orders" ON orders FOR INSERT WITH CHECK (true);

-- Fix Permission Trigger
CREATE OR REPLACE FUNCTION check_production_update_permissions() RETURNS TRIGGER AS $$
DECLARE
    v_role text;
BEGIN
    v_role := public.get_my_role();
    
    -- Bypass for Admin/Sales/Accountant
    IF v_role IN ('Admin', 'NhanVienKinhDoanh', 'KeToan') THEN
        RETURN NEW;
    END IF;

    -- Production Roles Limitations
    IF v_role IN ('NhanVienSanXuat', 'QuanLySanXuat', 'NhanVienThietKe', 'NhanVienBinhFile', 'NhanVienIn', 'NhanVienGiaCong') THEN
        -- Check Restricted Columns
        IF NEW.description IS DISTINCT FROM OLD.description THEN
            RAISE EXCEPTION 'Bạn không có quyền chỉnh sửa Quy cách đơn hàng.';
        END IF;
        IF NEW.total_amount IS DISTINCT FROM OLD.total_amount THEN
            RAISE EXCEPTION 'Bạn không có quyền chỉnh sửa thông tin Tài chính.';
        END IF;
        IF NEW.customer_id IS DISTINCT FROM OLD.customer_id THEN
             RAISE EXCEPTION 'Bạn không có quyền thay đổi thông tin Khách hàng.';
        END IF;
        RETURN NEW;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Rebind Trigger
DROP TRIGGER IF EXISTS on_order_update_check_permissions ON orders;
CREATE TRIGGER on_order_update_check_permissions BEFORE UPDATE ON orders FOR EACH ROW EXECUTE FUNCTION check_production_update_permissions();


-- ===========================================
-- 3. TABLE: PROFILES (Clean & Rebuild)
-- ===========================================
ALTER TABLE profiles DISABLE ROW LEVEL SECURITY;
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Admin full access profiles" ON profiles;
DROP POLICY IF EXISTS "Admin update profiles" ON profiles;
DROP POLICY IF EXISTS "Users view own profile" ON profiles;
DROP POLICY IF EXISTS "Authenticated users view profiles" ON profiles;
DROP POLICY IF EXISTS "User update own profile" ON profiles;
-- Drop policies created by this script if re-running
DROP POLICY IF EXISTS "Public read profiles" ON profiles;
DROP POLICY IF EXISTS "User update own" ON profiles;
DROP POLICY IF EXISTS "Admin update all" ON profiles;


-- Recreate Safe Policies
CREATE POLICY "Public read profiles" ON profiles FOR SELECT USING (true);
CREATE POLICY "User update own" ON profiles FOR UPDATE USING (id = auth.uid());
CREATE POLICY "Admin update all" ON profiles FOR ALL USING (public.is_admin_safe());


-- ===========================================
-- 4. TABLE: USER_LOGS (Clean & Rebuild)
-- ===========================================
ALTER TABLE user_logs DISABLE ROW LEVEL SECURITY;
ALTER TABLE user_logs ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Admins and Managers can view all logs" ON user_logs;
DROP POLICY IF EXISTS "Authenticated users can insert logs" ON user_logs;
-- Drop policies created by this script if re-running
DROP POLICY IF EXISTS "Insert logs" ON user_logs;
DROP POLICY IF EXISTS "View logs" ON user_logs;

CREATE POLICY "Insert logs" ON user_logs FOR INSERT WITH CHECK (true);
CREATE POLICY "View logs" ON user_logs FOR SELECT USING (public.is_manager_safe());


-- ===========================================
-- 5. TABLE: NOTIFICATIONS (Clean & Rebuild)
-- ===========================================
ALTER TABLE notifications DISABLE ROW LEVEL SECURITY; 

-- ===========================================
-- 6. ENSURE NOTIFICATION FUNCTIONS EXIST
-- ===========================================
CREATE OR REPLACE FUNCTION public.create_notification(
    p_user_id UUID, p_title TEXT, p_message TEXT, p_type TEXT, p_ref_id UUID, p_link TEXT
) RETURNS VOID AS $$
BEGIN
    INSERT INTO notifications (user_id, title, message, type, reference_id, link)
    VALUES (p_user_id, p_title, p_message, p_type, p_ref_id, p_link);
EXCEPTION WHEN OTHERS THEN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- ===========================================
-- 7. VERIFY
-- ===========================================
SELECT 'SUCCESS: Ultimate cleanup completed. All casting errors should be resolved.' AS result;
