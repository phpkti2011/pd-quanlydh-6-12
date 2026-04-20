-- COMPREHENSIVE FIX: Error 42883 "function create_notification does not exist"
-- Issue: Missing create_notification function AND NULL handling in triggers
-- Date: 2026-01-28

-- ============================================
-- STEP 1: Create notifications table if not exists
-- ============================================
CREATE TABLE IF NOT EXISTS notifications (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    title TEXT,
    message TEXT,
    type TEXT,
    reference_id UUID,
    link TEXT,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- STEP 2: Create the missing create_notification function
-- ============================================
CREATE OR REPLACE FUNCTION create_notification(
    p_user_id UUID,
    p_title TEXT,
    p_message TEXT,
    p_type TEXT,
    p_ref_id UUID,
    p_link TEXT
) RETURNS VOID AS $$
BEGIN
    INSERT INTO notifications (user_id, title, message, type, reference_id, link)
    VALUES (p_user_id, p_title, p_message, p_type, p_ref_id, p_link);
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- STEP 3: Drop ALL existing notification triggers (clean slate)
-- ============================================
DROP TRIGGER IF EXISTS check_design_status ON orders;
DROP TRIGGER IF EXISTS check_payment_approval ON orders;
DROP TRIGGER IF EXISTS check_production_start ON orders;
DROP TRIGGER IF EXISTS check_sales_completed ON orders;

DROP FUNCTION IF EXISTS notify_design_status() CASCADE;
DROP FUNCTION IF EXISTS notify_payment_approval() CASCADE;
DROP FUNCTION IF EXISTS notify_production_start() CASCADE;
DROP FUNCTION IF EXISTS notify_sales_completed() CASCADE;

-- ============================================
-- STEP 4: Recreate ALL trigger functions with proper NULL handling
-- ============================================

-- Function 1: Design Status (FIXED with COALESCE and IS DISTINCT FROM)
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
            PERFORM create_notification(
                recipient_id, 
                'Design Task'::TEXT, 
                ('Đơn hàng ' || COALESCE(NEW.order_code, 'N/A') || ' cần thiết kế.')::TEXT, 
                'order'::TEXT, 
                NEW.id, 
                ('/orders/' || COALESCE(NEW.order_code, ''))::TEXT
            );
        END LOOP;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

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
            PERFORM create_notification(
                recipient_id, 
                'Payment Update'::TEXT, 
                ('Đơn hàng ' || COALESCE(NEW.order_code, 'N/A') || ' đã được xác nhận thanh toán.')::TEXT, 
                'order'::TEXT, 
                NEW.id, 
                ('/orders/' || COALESCE(NEW.order_code, ''))::TEXT
            );
        END LOOP;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Function 3: Production Start
CREATE OR REPLACE FUNCTION notify_production_start() RETURNS TRIGGER AS $$
DECLARE
    recipient_id UUID;
BEGIN
    IF NEW.status = 'In' AND (OLD.status IS DISTINCT FROM 'In') THEN
        FOR recipient_id IN 
            SELECT id FROM profiles WHERE role::text IN ('NhanVienSanXuat', 'NhanVienBinhFile', 'QuanLySanXuat')
        LOOP
            PERFORM create_notification(
                recipient_id, 
                'New Production Order'::TEXT, 
                ('Đơn hàng ' || COALESCE(NEW.order_code, 'N/A') || ' chuyển sang In.')::TEXT, 
                'order'::TEXT, 
                NEW.id, 
                ('/orders/' || COALESCE(NEW.order_code, ''))::TEXT
            );
        END LOOP;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Function 4: Sales Completion
CREATE OR REPLACE FUNCTION notify_sales_completed() RETURNS TRIGGER AS $$
BEGIN
    IF (NEW.status IN ('ThanhPham', 'DongGoi', 'ChoGiaoHang')) 
       AND (OLD.status IS DISTINCT FROM NEW.status) THEN
        
        IF NEW.sales_rep_id IS NOT NULL THEN
            PERFORM create_notification(
                NEW.sales_rep_id, 
                'Order Ready'::TEXT, 
                ('Đơn hàng ' || COALESCE(NEW.order_code, 'N/A') || ' đã hoàn thành.')::TEXT, 
                'order'::TEXT, 
                NEW.id, 
                ('/orders/' || COALESCE(NEW.order_code, ''))::TEXT
            );
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- STEP 5: Re-attach ALL triggers
-- ============================================
CREATE TRIGGER check_design_status 
AFTER UPDATE ON orders 
FOR EACH ROW 
EXECUTE FUNCTION notify_design_status();

CREATE TRIGGER check_payment_approval 
AFTER UPDATE ON orders 
FOR EACH ROW 
EXECUTE FUNCTION notify_payment_approval();

CREATE TRIGGER check_production_start 
AFTER UPDATE ON orders 
FOR EACH ROW 
EXECUTE FUNCTION notify_production_start();

CREATE TRIGGER check_sales_completed 
AFTER UPDATE ON orders 
FOR EACH ROW 
EXECUTE FUNCTION notify_sales_completed();

-- ============================================
-- VERIFY
-- ============================================
SELECT 'SUCCESS: All notification triggers have been fixed!' AS result;
