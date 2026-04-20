-- COMPLETE FIX for Notification System
-- 1. Ensure Table Exists
CREATE TABLE IF NOT EXISTS notifications (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    title TEXT,
    message TEXT,
    type TEXT, -- 'order', 'system', etc.
    reference_id UUID, -- Links to orders.id
    link TEXT, -- Frontend route
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Define/Redefine the Helper Function
-- Explicitly defining this ensures the triggers find the exact signature they need.
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

-- 3. Drop Triggers & Functions (Cleanup)
DROP FUNCTION IF EXISTS notify_design_status() CASCADE;
DROP FUNCTION IF EXISTS notify_production_start() CASCADE;
DROP FUNCTION IF EXISTS notify_sales_completed() CASCADE;
DROP FUNCTION IF EXISTS notify_payment_approval() CASCADE;

-- 4. Recreate Trigger Functions (with explicit CAST for roles to avoid 'operator does not exist')

-- Function 1: Payment Approval
CREATE OR REPLACE FUNCTION notify_payment_approval() RETURNS TRIGGER AS $$
DECLARE
    recipient_id UUID;
BEGIN
    IF (NEW.payment_status = 'DaCoc' OR NEW.payment_status = 'DaThanhToan') 
       AND (OLD.payment_status != NEW.payment_status OR OLD.payment_status IS NULL) THEN
        FOR recipient_id IN SELECT id FROM profiles WHERE role::text IN ('Admin', 'KeToan', 'GiamDoc') LOOP
            PERFORM create_notification(recipient_id, 'Payment Update', 'Đơn hàng ' || NEW.order_code || ' đã được xác nhận thanh toán.', 'order', NEW.id, '/orders/' || NEW.order_code);
        END LOOP;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Function 2: Design Status
CREATE OR REPLACE FUNCTION notify_design_status() RETURNS TRIGGER AS $$
DECLARE
    recipient_id UUID;
BEGIN
    IF NEW.has_design = true AND (OLD.has_design = false OR OLD.design_status != NEW.design_status OR OLD.design_status IS NULL) THEN
        FOR recipient_id IN SELECT id FROM profiles WHERE role::text = 'NhanVienThietKe' LOOP
            PERFORM create_notification(recipient_id, 'Design Task', 'Đơn hàng ' || NEW.order_code || ' cần thiết kế.', 'order', NEW.id, '/orders/' || NEW.order_code);
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
    IF NEW.status = 'In' AND (OLD.status != 'In' OR OLD.status IS NULL) THEN
        FOR recipient_id IN SELECT id FROM profiles WHERE role::text IN ('NhanVienSanXuat', 'NhanVienBinhFile', 'QuanLySanXuat') LOOP
            PERFORM create_notification(recipient_id, 'New Production Order', 'Đơn hàng ' || NEW.order_code || ' chuyển sang In.', 'order', NEW.id, '/orders/' || NEW.order_code);
        END LOOP;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Function 4: Sales Completion
CREATE OR REPLACE FUNCTION notify_sales_completed() RETURNS TRIGGER AS $$
BEGIN
    IF (NEW.status = 'ThanhPham' OR NEW.status = 'DongGoi' OR NEW.status = 'ChoGiaoHang') 
       AND (OLD.status != NEW.status OR OLD.status IS NULL) THEN
        IF NEW.sales_rep_id IS NOT NULL THEN
            PERFORM create_notification(NEW.sales_rep_id, 'Order Ready', 'Đơn hàng ' || NEW.order_code || ' đã hoàn thành.', 'order', NEW.id, '/orders/' || NEW.order_code);
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 5. Attach Triggers
CREATE TRIGGER check_payment_approval AFTER UPDATE ON orders FOR EACH ROW EXECUTE FUNCTION notify_payment_approval();
CREATE TRIGGER check_design_status AFTER UPDATE ON orders FOR EACH ROW EXECUTE FUNCTION notify_design_status();
CREATE TRIGGER check_production_start AFTER UPDATE ON orders FOR EACH ROW EXECUTE FUNCTION notify_production_start();
CREATE TRIGGER check_sales_completed AFTER UPDATE ON orders FOR EACH ROW EXECUTE FUNCTION notify_sales_completed();
