-- Fix "operator does not exist: user_role = text" error triggers
-- Updated to use CASCADE to automatically drop dependent triggers (fixes "cannot drop function" error)

-- 1. Drop existing functions with CASCADE to remove ALL dependent triggers automatically
DROP FUNCTION IF EXISTS notify_design_status() CASCADE;
DROP FUNCTION IF EXISTS notify_production_start() CASCADE;
DROP FUNCTION IF EXISTS notify_sales_completed() CASCADE;
DROP FUNCTION IF EXISTS notify_payment_approval() CASCADE;

-- 2. Recreate functions with explicit CAST to text for Roles

-- Function 1: Payment Approval (Admin/Accountant/Director)
CREATE OR REPLACE FUNCTION notify_payment_approval() RETURNS TRIGGER AS $$
DECLARE
    recipient_id UUID;
BEGIN
    -- Only fire if payment status changed to Paid/Deposit
    IF (NEW.payment_status = 'DaCoc' OR NEW.payment_status = 'DaThanhToan') 
       AND (OLD.payment_status != NEW.payment_status OR OLD.payment_status IS NULL) THEN
        
        -- Loop through Admins/Accountants/Directors
        FOR recipient_id IN 
            SELECT id FROM profiles WHERE role::text IN ('Admin', 'KeToan', 'GiamDoc')
        LOOP
            PERFORM create_notification(
                recipient_id,
                'Payment Update',
                'Đơn hàng ' || NEW.order_code || ' đã được xác nhận thanh toán (' || NEW.payment_status || ').',
                'order',
                NEW.id,
                '/orders/' || NEW.order_code
            );
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
    -- Fire if has_design is TRUE and (was false OR changed status)
    IF NEW.has_design = true AND (OLD.has_design = false OR OLD.design_status != NEW.design_status OR OLD.design_status IS NULL) THEN
        -- Notify Designers
        FOR recipient_id IN 
            SELECT id FROM profiles WHERE role::text = 'NhanVienThietKe'
        LOOP
            PERFORM create_notification(
                recipient_id,
                'Design Task',
                'Đơn hàng ' || NEW.order_code || ' cần thiết kế/cập nhật.',
                'order',
                NEW.id,
                '/orders/' || NEW.order_code
            );
        END LOOP;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Function 3: Production Start (Status = In)
CREATE OR REPLACE FUNCTION notify_production_start() RETURNS TRIGGER AS $$
DECLARE
    recipient_id UUID;
BEGIN
    -- Fire if Status becomes 'In'
    IF NEW.status = 'In' AND (OLD.status != 'In' OR OLD.status IS NULL) THEN
        -- Notify Production Team
        FOR recipient_id IN 
            SELECT id FROM profiles WHERE role::text IN ('NhanVienSanXuat', 'NhanVienBinhFile', 'QuanLySanXuat')
        LOOP
            PERFORM create_notification(
                recipient_id,
                'New Production Order',
                'Đơn hàng ' || NEW.order_code || ' đã chuyển sang In.',
                'order',
                NEW.id,
                '/orders/' || NEW.order_code
            );
        END LOOP;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Function 4: Sales Completion
CREATE OR REPLACE FUNCTION notify_sales_completed() RETURNS TRIGGER AS $$
BEGIN
    -- Fire if Status becomes Production Finished or later
    IF (NEW.status = 'ThanhPham' OR NEW.status = 'DongGoi' OR NEW.status = 'ChoGiaoHang') 
       AND (OLD.status != NEW.status OR OLD.status IS NULL) THEN
        
        -- Notify Sales Rep (if exists)
        IF NEW.sales_rep_id IS NOT NULL THEN
            PERFORM create_notification(
                NEW.sales_rep_id,
                'Order Ready',
                'Đơn hàng ' || NEW.order_code || ' đã hoàn thành sản xuất.',
                'order',
                NEW.id,
                '/orders/' || NEW.order_code
            );
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 3. Re-attach Triggers

CREATE TRIGGER check_payment_approval
AFTER UPDATE ON orders
FOR EACH ROW
EXECUTE FUNCTION notify_payment_approval();

CREATE TRIGGER check_design_status
AFTER UPDATE ON orders
FOR EACH ROW
EXECUTE FUNCTION notify_design_status();

CREATE TRIGGER check_production_start
AFTER UPDATE ON orders
FOR EACH ROW
EXECUTE FUNCTION notify_production_start();

CREATE TRIGGER check_sales_completed
AFTER UPDATE ON orders
FOR EACH ROW
EXECUTE FUNCTION notify_sales_completed();
