-- Comprehensive Fix for Production Permissions (View All, Edit Specifics)

-- 1. Helper Function (Text Return)
CREATE OR REPLACE FUNCTION get_current_user_role_text()
RETURNS text
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT role::text FROM profiles WHERE id = auth.uid();
$$;

-- 2. CUSTOMERS RLS
ALTER TABLE customers ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Authenticated users view customers" ON customers;
CREATE POLICY "Authenticated users view customers" ON customers
    FOR SELECT TO authenticated USING (true);
-- (Keep insert/update restricted to Admin/Sales)

-- 3. ORDERS COLUMN-LEVEL SECURITY TRIGGER
-- Enforce that Production staff can ONLY update specific columns (Status, Notes, Sub-tasks)
CREATE OR REPLACE FUNCTION check_production_update_permissions()
RETURNS TRIGGER AS $$
DECLARE
    user_role text;
BEGIN
    -- Bypass for Admin/Sales/Accountant
    user_role := get_current_user_role_text();
    IF user_role IN ('Admin', 'NhanVienKinhDoanh', 'KeToan') THEN
        RETURN NEW;
    END IF;

    -- For Production Roles:
    IF user_role IN ('NhanVienSanXuat', 'QuanLySanXuat', 'NhanVienThietKe', 'NhanVienBinhFile', 'NhanVienIn', 'NhanVienGiaCong') THEN
        
        -- CHECKS: If any RESTRICTED column is changed, raise error.
        
        -- 1. Description (Quy cach)
        IF NEW.description IS DISTINCT FROM OLD.description THEN
            RAISE EXCEPTION 'Bạn không có quyền chỉnh sửa Quy cách đơn hàng.';
        END IF;

        -- 2. Financials
        IF NEW.total_amount IS DISTINCT FROM OLD.total_amount OR
           NEW.total_amount_pre_vat IS DISTINCT FROM OLD.total_amount_pre_vat OR
           NEW.vat_amount IS DISTINCT FROM OLD.vat_amount OR
           NEW.deposit_amount IS DISTINCT FROM OLD.deposit_amount OR 
           NEW.remaining_amount IS DISTINCT FROM OLD.remaining_amount THEN
            RAISE EXCEPTION 'Bạn không có quyền chỉnh sửa thông tin Tài chính.';
        END IF;

        -- 3. Customer / Sales Rep / Code
        IF NEW.customer_id IS DISTINCT FROM OLD.customer_id OR
           NEW.sales_rep_id IS DISTINCT FROM OLD.sales_rep_id OR 
           NEW.order_code IS DISTINCT FROM OLD.order_code THEN
             RAISE EXCEPTION 'Bạn không có quyền thay đổi thông tin Khách hàng/Người phụ trách.';
        END IF;

        -- 4. Payment Status (Requires clarification, strictly Sales/Accountant usually)
        -- User said "tick hoàn thành công đoạn phụ... hoàn thành đơn hàng". 
        -- Did not explicitly say "Thanh toán". Assuming restricted.
        IF NEW.payment_status IS DISTINCT FROM OLD.payment_status THEN
            RAISE EXCEPTION 'Bạn không có quyền cập nhật trạng thái Thanh toán.';
        END IF;

        -- ALLOWED: status, notes, status_note, design_*, large_print_*, etc.
        RETURN NEW;
    END IF;

    -- If role not recognized (e.g. Khach), reject update
    RETURN OLD; 
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_order_update_check_permissions ON orders;
CREATE TRIGGER on_order_update_check_permissions
    BEFORE UPDATE ON orders
    FOR EACH ROW
    EXECUTE PROCEDURE check_production_update_permissions();


-- 4. ORDERS RLS POLICIES (Refresh)
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Update orders" ON orders;
DROP POLICY IF EXISTS "Production see active orders" ON orders;

-- Select: Production sees Active Orders (Non-Moi/Huy) OR maybe ALL? 
-- User said "hien thi thi van phai nhin thay duoc".
-- Let's make SELECT permissive for active orders, OR all orders?
-- Usually we hide 'Moi' (Drafts from Sales) from Production to avoid confusion.
-- But if they need to see history, maybe allow all?
-- Current logic: "status NOT IN ('Moi', 'Huy')" - strictly active workflow.
-- Let's stick to Active Workflow for now to avoid clutter, as requested previously.
CREATE POLICY "Production see active orders" ON orders
  FOR SELECT USING (
    get_current_user_role_text() IN ('Admin', 'NhanVienKinhDoanh', 'KeToan') 
    OR
    (status NOT IN ('Moi', 'Huy') AND 
     get_current_user_role_text() IN ('NhanVienSanXuat', 'QuanLySanXuat', 'NhanVienThietKe', 'NhanVienBinhFile', 'NhanVienIn', 'NhanVienGiaCong'))
  );

-- Update: Allow access to row (Trigger will filter columns)
CREATE POLICY "Update orders" ON orders
  FOR UPDATE USING (
    get_current_user_role_text() IN ('Admin', 'NhanVienKinhDoanh', 'KeToan')
    OR
    auth.uid() = sales_rep_id
    OR
    (status NOT IN ('Moi', 'Huy') AND 
     get_current_user_role_text() IN ('NhanVienSanXuat', 'QuanLySanXuat', 'NhanVienThietKe', 'NhanVienBinhFile', 'NhanVienIn', 'NhanVienGiaCong'))
  );

-- 5. ORDER PROCESS PARTICIPANTS
DROP POLICY IF EXISTS "Insert own participation" ON order_process_participants;
CREATE POLICY "Insert own participation" ON order_process_participants
  FOR INSERT WITH CHECK ( auth.uid() = user_id );

DROP POLICY IF EXISTS "Update own participation" ON order_process_participants;
CREATE POLICY "Update own participation" ON order_process_participants
  FOR UPDATE USING ( auth.uid() = user_id OR get_current_user_role_text() = 'Admin' );
