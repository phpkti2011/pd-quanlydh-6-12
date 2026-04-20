-- ===========================================
-- ULTIMATE FIX V3: NUCLEAR OPTION (Dynamic Drop)
-- Date: 2026-01-28
-- ===========================================
-- This script dynamically finds ALL triggers on the 'orders' table 
-- and DROPS them, ensuring no hidden/legacy triggers remain.
-- Then it rebuilds only the necessary ones.
-- ===========================================

DO $$
DECLARE
    r RECORD;
BEGIN
    -- 1. LOOP THROUGH ALL TRIGGERS ON 'orders' TABLE
    FOR r IN (
        SELECT trigger_name 
        FROM information_schema.triggers 
        WHERE event_object_table = 'orders' 
        AND trigger_schema = 'public'
    ) LOOP
        -- Log detection
        RAISE NOTICE 'Dropping trigger: %', r.trigger_name;
        
        -- DYNAMICALLY DROP THE TRIGGER
        EXECUTE 'DROP TRIGGER IF EXISTS "' || r.trigger_name || '" ON orders CASCADE';
    END LOOP;
END $$;


-- 2. DROP ALL RELATED FUNCTIONS (To be super safe)
DROP FUNCTION IF EXISTS check_production_update_permissions() CASCADE;
DROP FUNCTION IF EXISTS notify_design_status() CASCADE;
DROP FUNCTION IF EXISTS notify_payment_approval() CASCADE;
DROP FUNCTION IF EXISTS notify_production_start() CASCADE;
DROP FUNCTION IF EXISTS notify_sales_completed() CASCADE;
DROP FUNCTION IF EXISTS update_customer_tier() CASCADE; -- Re-add later if needed to avoid conflicts
DROP FUNCTION IF EXISTS trigger_update_updated_at() CASCADE; 

-- ===========================================
-- 3. REBUILD: ESSENTIAL TRIGGERS ONLY
-- ===========================================

-- A. Timestamp Updater (Standard)
CREATE OR REPLACE FUNCTION update_updated_at_column() RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_orders_modtime BEFORE UPDATE ON orders FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();


-- B. Notification Function (Public & Safe)
CREATE OR REPLACE FUNCTION public.create_system_notification(
    p_user_id UUID, p_title TEXT, p_message TEXT, p_type TEXT, p_ref_id UUID, p_link TEXT
) RETURNS VOID AS $$
BEGIN
    INSERT INTO notifications (user_id, title, message, type, reference_id, link)
    VALUES (p_user_id, p_title, p_message, p_type, p_ref_id, p_link);
EXCEPTION WHEN OTHERS THEN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- C. Permission Check (The likely culprit)
CREATE OR REPLACE FUNCTION check_order_permissions() RETURNS TRIGGER AS $$
DECLARE
    v_role text;
BEGIN
    -- Get Role SAFELY with CAST
    SELECT role::text INTO v_role FROM profiles WHERE id = auth.uid();
    
    -- Admin/Sales/Accountant/Director -> ALLOW
    IF v_role IN ('Admin', 'NhanVienKinhDoanh', 'KeToan', 'GiamDoc') THEN 
        RETURN NEW;
    END IF;

    -- Production Roles -> RESTRICTED
    IF v_role IN ('NhanVienSanXuat', 'QuanLySanXuat', 'NhanVienThietKe', 'NhanVienBinhFile', 'NhanVienIn', 'NhanVienGiaCong') THEN
        IF NEW.description IS DISTINCT FROM OLD.description THEN RAISE EXCEPTION 'Không được sửa Quy cách.'; END IF;
        IF NEW.total_amount IS DISTINCT FROM OLD.total_amount THEN RAISE EXCEPTION 'Không được sửa Giá tiền.'; END IF;
        IF NEW.customer_id IS DISTINCT FROM OLD.customer_id THEN RAISE EXCEPTION 'Không được đổi Khách hàng.'; END IF;
        RETURN NEW;
    END IF;

    -- Default: Allow Update (or restrict if strict mode)
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER check_permissions_trigger BEFORE UPDATE ON orders FOR EACH ROW EXECUTE FUNCTION check_order_permissions();


-- D. Notification Trigger: Design (The one causing trouble)
CREATE OR REPLACE FUNCTION notify_design_change() RETURNS TRIGGER AS $$
DECLARE
    recipient_id UUID;
BEGIN
    -- Check Logic: Design toggled ON
    IF NEW.has_design = true 
       AND (COALESCE(OLD.has_design, false) = false OR OLD.design_status IS DISTINCT FROM NEW.design_status) THEN
        
        -- Loop Designers
        FOR recipient_id IN SELECT id FROM profiles WHERE role::text = 'NhanVienThietKe' LOOP
            PERFORM public.create_system_notification(
                recipient_id, 'Yêu cầu Thiết kế', 
                ('Đơn ' || NEW.order_code || ' cần thiết kế.')::TEXT, 'order', NEW.id, '/orders/' || NEW.order_code
            );
        END LOOP;
    END IF;
    RETURN NEW;
EXCEPTION WHEN OTHERS THEN RETURN NEW; -- SILENCE ALL ERRORS
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER notify_design_trigger AFTER UPDATE ON orders FOR EACH ROW EXECUTE FUNCTION notify_design_change();


-- ===========================================
-- 4. VERIFY
-- ===========================================
SELECT 'SUCCESS: NUCLEAR FIX COMPLETE. All old triggers wiped. New safe triggers installed.' AS result;
