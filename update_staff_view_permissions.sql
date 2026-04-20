-- Relax RLS for Orders to ensure Production/Delivery see "New" (Moi) orders
-- and ensure Delivery Staff are included.

-- 1. Helper Function (Ensure it exists)
CREATE OR REPLACE FUNCTION get_current_user_role_text()
RETURNS text
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT role::text FROM profiles WHERE id = auth.uid();
$$;

-- 2. Drop existing restrictive policies
DROP POLICY IF EXISTS "Production see active orders" ON orders;
DROP POLICY IF EXISTS "Staff view all orders" ON orders; -- In case of re-run

-- 3. Create new inclusive policy for SELECT
CREATE POLICY "Staff view all orders" ON orders
  FOR SELECT USING (
    -- 1. Privileged Roles (Admin, Sales, Accountant)
    get_current_user_role_text() IN ('Admin', 'NhanVienKinhDoanh', 'KeToan') 
    
    OR
    
    -- 2. Production & Delivery Staff
    -- Removed "status NOT IN ('Moi', 'Huy')" restriction so they can see New orders.
    get_current_user_role_text() IN (
        'NhanVienSanXuat', 
        'QuanLySanXuat', 
        'NhanVienThietKe', 
        'NhanVienBinhFile', 
        'NhanVienIn', 
        'NhanVienGiaCong',
        'NhanVienGiaoHang' -- Added Delivery Staff
    )
  );

-- 4. Ensure Update Policy also includes Delivery if needed, 
-- or strictly follow the previous logic (Update only if assigned or specialized role).
-- For now, we only fix Visibility (SELECT).
