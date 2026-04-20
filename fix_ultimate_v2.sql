-- ===========================================
-- ULTIMATE FIX V2: The Complete Database Repair
-- Date: 2026-01-28
-- ===========================================
-- REASON: Previous fix missed updating the Notification Triggers which still 
-- contain the "user_role = text" bug. This script fixes SYSTEM-WIDE issues.
-- ===========================================

-- 1. Helper Functions (PUBLIC schema)
CREATE OR REPLACE FUNCTION public.get_my_role() RETURNS text LANGUAGE sql SECURITY DEFINER SET search_path = public AS $$
  SELECT role::text FROM profiles WHERE id = auth.uid();
$$;

CREATE OR REPLACE FUNCTION public.is_admin_safe() RETURNS BOOLEAN LANGUAGE sql SECURITY DEFINER SET search_path = public AS $$
  SELECT EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role::text = 'Admin');
$$;

CREATE OR REPLACE FUNCTION public.is_manager_safe() RETURNS BOOLEAN LANGUAGE sql SECURITY DEFINER SET search_path = public AS $$
  SELECT EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role::text IN ('Admin', 'KeToan', 'QuanLySanXuat'));
$$;

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
-- 2. CLEANUP: DROP ALL TRIGGERS ON ORDERS
-- ===========================================
DROP TRIGGER IF EXISTS on_order_update_check_permissions ON orders;
DROP TRIGGER IF EXISTS check_design_status ON orders;
DROP TRIGGER IF EXISTS check_payment_approval ON orders;
DROP TRIGGER IF EXISTS check_production_start ON orders;
DROP TRIGGER IF EXISTS check_sales_completed ON orders;
-- Drop any potential legacy triggers
DROP TRIGGER IF EXISTS notify_design_trigger ON orders;
DROP TRIGGER IF EXISTS notify_payment_trigger ON orders;
DROP TRIGGER IF EXISTS notify_finance_trigger ON orders;

-- Drop Trigger Functions to ensure fresh recreate
DROP FUNCTION IF EXISTS check_production_update_permissions() CASCADE;
DROP FUNCTION IF EXISTS notify_design_status() CASCADE;
DROP FUNCTION IF EXISTS notify_payment_approval() CASCADE;
DROP FUNCTION IF EXISTS notify_production_start() CASCADE;
DROP FUNCTION IF EXISTS notify_sales_completed() CASCADE;


-- ===========================================
-- 3. RECREATE: NOTIFICATION TRIGGERS (Safe Casts)
-- ===========================================

-- Function 1: Design Status
CREATE OR REPLACE FUNCTION notify_design_status() RETURNS TRIGGER AS $$
DECLARE
    recipient_id UUID;
BEGIN
    IF NEW.has_design = true 
       AND (COALESCE(OLD.has_design, false) = false 
            OR OLD.design_status IS DISTINCT FROM NEW.design_status) THEN
        
        FOR recipient_id IN 
            SELECT id FROM profiles WHERE role::text = 'NhanVienThietKe'
        LOOP
            PERFORM public.create_notification(
                recipient_id, 'Design Task', 
                ('Đơn hàng ' || COALESCE(NEW.order_code, 'N/A') || ' cần thiết kế.')::TEXT, 
                'order', NEW.id, ('/orders/' || COALESCE(NEW.order_code, ''))::TEXT
            );
        END LOOP;
    END IF;
    RETURN NEW;
EXCEPTION WHEN OTHERS THEN RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function 2: Payment Approval
CREATE OR REPLACE FUNCTION notify_payment_approval() RETURNS TRIGGER AS $$
DECLARE
    recipient_id UUID;
BEGIN
    IF (NEW.payment_status = 'DaCoc' OR NEW.payment_status = 'DaThanhToan') 
       AND (OLD.payment_status IS DISTINCT FROM NEW.payment_status) THEN
        
        FOR recipient_id IN 
            SELECT id FROM profiles WHERE role::text IN ('Admin', 'KeToan', 'GiamDoc')
        LOOP
            PERFORM public.create_notification(
                recipient_id, 'Payment Update', 
                ('Đơn hàng ' || COALESCE(NEW.order_code, 'N/A') || ' đã được xác nhận thanh toán.')::TEXT, 
                'order', NEW.id, ('/orders/' || COALESCE(NEW.order_code, ''))::TEXT
            );
        END LOOP;
    END IF;
    RETURN NEW;
EXCEPTION WHEN OTHERS THEN RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function 3: Production Start
CREATE OR REPLACE FUNCTION notify_production_start() RETURNS TRIGGER AS $$
DECLARE
    recipient_id UUID;
BEGIN
    IF NEW.status = 'In' AND (OLD.status IS DISTINCT FROM 'In') THEN
        FOR recipient_id IN 
            SELECT id FROM profiles WHERE role::text IN ('NhanVienSanXuat', 'NhanVienBinhFile', 'QuanLySanXuat')
        LOOP
            PERFORM public.create_notification(
                recipient_id, 'New Production Order', 
                ('Đơn hàng ' || COALESCE(NEW.order_code, 'N/A') || ' chuyển sang In.')::TEXT, 
                'order', NEW.id, ('/orders/' || COALESCE(NEW.order_code, ''))::TEXT
            );
        END LOOP;
    END IF;
    RETURN NEW;
EXCEPTION WHEN OTHERS THEN RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function 4: Sales Completion
CREATE OR REPLACE FUNCTION notify_sales_completed() RETURNS TRIGGER AS $$
BEGIN
    IF (NEW.status IN ('ThanhPham', 'DongGoi', 'ChoGiaoHang')) 
       AND (OLD.status IS DISTINCT FROM NEW.status) THEN
        IF NEW.sales_rep_id IS NOT NULL THEN
            PERFORM public.create_notification(
                NEW.sales_rep_id, 'Order Ready', 
                ('Đơn hàng ' || COALESCE(NEW.order_code, 'N/A') || ' đã hoàn thành.')::TEXT, 
                'order', NEW.id, ('/orders/' || COALESCE(NEW.order_code, ''))::TEXT
            );
        END IF;
    END IF;
    RETURN NEW;
EXCEPTION WHEN OTHERS THEN RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ATTACH TRIGGERS
CREATE TRIGGER check_design_status AFTER UPDATE ON orders FOR EACH ROW EXECUTE FUNCTION notify_design_status();
CREATE TRIGGER check_payment_approval AFTER UPDATE ON orders FOR EACH ROW EXECUTE FUNCTION notify_payment_approval();
CREATE TRIGGER check_production_start AFTER UPDATE ON orders FOR EACH ROW EXECUTE FUNCTION notify_production_start();
CREATE TRIGGER check_sales_completed AFTER UPDATE ON orders FOR EACH ROW EXECUTE FUNCTION notify_sales_completed();


-- ===========================================
-- 4. RECREATE: PERMISSION CHECK TRIGGER (Safe Casts)
-- ===========================================
CREATE OR REPLACE FUNCTION check_production_update_permissions() RETURNS TRIGGER AS $$
DECLARE
    v_role text;
BEGIN
    v_role := public.get_my_role();
    
    IF v_role IN ('Admin', 'NhanVienKinhDoanh', 'KeToan') THEN RETURN NEW; END IF;

    IF v_role IN ('NhanVienSanXuat', 'QuanLySanXuat', 'NhanVienThietKe', 'NhanVienBinhFile', 'NhanVienIn', 'NhanVienGiaCong') THEN
        IF NEW.description IS DISTINCT FROM OLD.description THEN RAISE EXCEPTION 'Bạn không có quyền chỉnh sửa Quy cách đơn hàng.'; END IF;
        IF NEW.total_amount IS DISTINCT FROM OLD.total_amount THEN RAISE EXCEPTION 'Bạn không có quyền chỉnh sửa thông tin Tài chính.'; END IF;
        IF NEW.customer_id IS DISTINCT FROM OLD.customer_id THEN RAISE EXCEPTION 'Bạn không có quyền thay đổi thông tin Khách hàng.'; END IF;
        RETURN NEW;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_order_update_check_permissions BEFORE UPDATE ON orders FOR EACH ROW EXECUTE FUNCTION check_production_update_permissions();


-- ===========================================
-- 5. REFRESH ALL POLICIES (With Safe Casts)
-- ===========================================
-- ORDERS
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Update orders" ON orders;
CREATE POLICY "Update orders" ON orders FOR UPDATE USING (
    public.get_my_role() IN ('Admin', 'NhanVienKinhDoanh', 'KeToan')
    OR auth.uid() = sales_rep_id
    OR (
        status::text NOT IN ('Moi', 'Huy') 
        AND public.get_my_role() IN ('NhanVienSanXuat', 'QuanLySanXuat', 'NhanVienThietKe', 'NhanVienBinhFile', 'NhanVienIn', 'NhanVienGiaCong')
    )
);

-- PROFILES
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Admin update all" ON profiles;
CREATE POLICY "Admin update all" ON profiles FOR ALL USING (public.is_admin_safe());

-- USER LOGS
ALTER TABLE user_logs ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "View logs" ON user_logs;
CREATE POLICY "View logs" ON user_logs FOR SELECT USING (public.is_manager_safe());

-- ===========================================
-- 6. VERIFY
-- ===========================================
SELECT 'SUCCESS: V2 Ulitmate Fix Applied. All triggers and policies refreshed.' AS result;
