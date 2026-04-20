-- FIX PRODUCTION UPDATE NEW ORDERS
-- Problem: Production staff can see 'Moi' orders but cannot update them because 'Update orders' policy explicitly excluded 'Moi'.
-- Solution: Allow Production staff to update 'Moi' orders (to transition them to 'NhanFile' etc).

BEGIN;

DROP POLICY IF EXISTS "Update orders" ON orders;

CREATE POLICY "Update orders" ON orders
  FOR UPDATE USING (
    auth.uid() = sales_rep_id 
    OR
    get_current_user_role() IN ('Admin', 'NhanVienKinhDoanh', 'KeToan') 
    OR
    -- Production can update ANY active order (including Moi, excluding Huy)
    (status != 'Huy' AND 
     get_current_user_role() IN ('NhanVienSanXuat', 'QuanLySanXuat', 'NhanVienThietKe', 'NhanVienBinhFile'))
  );

-- Also ensure they can SELECT 'Moi' orders if not already
DROP POLICY IF EXISTS "Production see active orders" ON orders;
CREATE POLICY "Production see active orders" ON orders
  FOR SELECT USING (
    status != 'Huy' AND -- Changed from NOT IN ('Moi', 'Huy') to just != 'Huy'
    get_current_user_role() IN ('NhanVienSanXuat', 'QuanLySanXuat', 'NhanVienThietKe', 'NhanVienBinhFile')
  );

COMMIT;

NOTIFY pgrst, 'reload schema';
