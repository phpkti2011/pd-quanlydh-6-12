-- ===========================================
-- FIX V5: RELAXED PERMISSIONS FOR STATUS UPDATE
-- Date: 2026-01-28
-- ===========================================
-- Issue: "Update failed: 0 rows returned"
-- Root Cause: RLS Policy filters out the row entirely for Production staff if status is 'Moi'.
-- But "TiepNhan" action usually happens when status is 'Moi' -> transitioning to 'TiepNhan'.
-- If RLS hides 'Moi' orders from update, they can't accept them.
-- ===========================================

-- 1. Helper Function
CREATE OR REPLACE FUNCTION public.get_my_role() RETURNS text LANGUAGE sql SECURITY DEFINER SET search_path = public AS $$
  SELECT role::text FROM profiles WHERE id = auth.uid();
$$;

-- 2. UPDATE ORDERS RLS POLICY (More Permissive for Update)
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Update orders" ON orders;

CREATE POLICY "Update orders" ON orders FOR UPDATE USING (
    -- Admin/Sales/Accountant/Director can update anything
    public.get_my_role() IN ('Admin', 'NhanVienKinhDoanh', 'KeToan', 'GiamDoc')
    OR
    -- Sales Rep can update their own orders
    auth.uid() = sales_rep_id
    OR
    -- Production Roles can update ANY order that is NOT Cancelled ('Huy')
    -- We REMOVE the check for 'Moi' so they can transition from Moi -> TiepNhan
    (
        status::text != 'Huy'
        AND public.get_my_role() IN ('NhanVienSanXuat', 'QuanLySanXuat', 'NhanVienThietKe', 'NhanVienBinhFile', 'NhanVienIn', 'NhanVienGiaCong')
    )
);

-- 3. UPDATE TRIGGER (Ensure Logic is Sound)
CREATE OR REPLACE FUNCTION check_order_permissions() RETURNS TRIGGER AS $$
DECLARE
    v_role text;
BEGIN
    v_role := public.get_my_role();
    
    -- Full Access
    IF v_role IN ('Admin', 'NhanVienKinhDoanh', 'KeToan', 'GiamDoc') THEN RETURN NEW; END IF;

    -- Production Roles
    IF v_role IN ('NhanVienSanXuat', 'QuanLySanXuat', 'NhanVienThietKe', 'NhanVienBinhFile', 'NhanVienIn', 'NhanVienGiaCong') THEN
        -- Allow Status Update.
        -- Only block critical business fields.
        IF NEW.description IS DISTINCT FROM OLD.description THEN RAISE EXCEPTION 'Bạn không có quyền chỉnh sửa Quy cách đơn hàng.'; END IF;
        IF NEW.total_amount IS DISTINCT FROM OLD.total_amount THEN RAISE EXCEPTION 'Bạn không có quyền chỉnh sửa Giá tiền.'; END IF;
        IF NEW.customer_id IS DISTINCT FROM OLD.customer_id THEN RAISE EXCEPTION 'Bạn không có quyền đổi Khách hàng.'; END IF;
        RETURN NEW;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS check_permissions_trigger ON orders;
CREATE TRIGGER check_permissions_trigger BEFORE UPDATE ON orders FOR EACH ROW EXECUTE FUNCTION check_order_permissions();

-- 4. VERIFY
SELECT 'SUCCESS: RLS Permissions relaxed. Production can now update New orders.' AS result;
