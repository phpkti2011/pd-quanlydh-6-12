-- 1. Refine Orders RLS
-- Drop old restrictive policies
DROP POLICY IF EXISTS "Production see active orders" ON orders;
DROP POLICY IF EXISTS "Update orders" ON orders;

-- Allow all production-related roles to see active orders (Not Moi/Huy)
CREATE POLICY "Production see active orders" ON orders
  FOR SELECT USING (
    status NOT IN ('Moi', 'Huy') AND 
    get_current_user_role() IN ('NhanVienSanXuat', 'QuanLySanXuat', 'NhanVienThietKe', 'NhanVienBinhFile')
  );

-- Allow Production to UPDATE active orders (to change status/workflow)
CREATE POLICY "Update orders" ON orders
  FOR UPDATE USING (
    auth.uid() = sales_rep_id -- Sales Reps can update their own
    OR
    get_current_user_role() IN ('Admin', 'NhanVienKinhDoanh', 'KeToan') -- Admin/Sales/Accountant
    OR
    (status NOT IN ('Moi', 'Huy') AND 
     get_current_user_role() IN ('NhanVienSanXuat', 'QuanLySanXuat', 'NhanVienThietKe', 'NhanVienBinhFile')) -- Production
  );

-- 2. Secure Order Process Participants
ALTER TABLE order_process_participants ENABLE ROW LEVEL SECURITY;

-- Everyone can view participants (to see progress)
DROP POLICY IF EXISTS "View participants" ON order_process_participants;
CREATE POLICY "View participants" ON order_process_participants
  FOR SELECT USING (true);

-- Users can only insert their OWN participation (Join)
DROP POLICY IF EXISTS "Insert own participation" ON order_process_participants;
CREATE POLICY "Insert own participation" ON order_process_participants
  FOR INSERT WITH CHECK (
    auth.uid() = user_id
  );

-- Users can update/delete their OWN participation (Leave/Finish)
DROP POLICY IF EXISTS "Update own participation" ON order_process_participants;
CREATE POLICY "Update own participation" ON order_process_participants
  FOR UPDATE USING (
    auth.uid() = user_id OR get_current_user_role() = 'Admin'
  );

DROP POLICY IF EXISTS "Delete own participation" ON order_process_participants;
CREATE POLICY "Delete own participation" ON order_process_participants
  FOR DELETE USING (
     auth.uid() = user_id OR get_current_user_role() = 'Admin'
  );

-- 3. Profiles RLS (Ensure Production can Read basic profiles for autocomplete)
DROP POLICY IF EXISTS "Authenticated users view profiles" ON profiles;
CREATE POLICY "Authenticated users view profiles" ON profiles
    FOR SELECT TO authenticated USING (true);

-- 4. Commission Policies RLS (Read Only for everyone)
DROP POLICY IF EXISTS "Read commission policies" ON commission_policies;
CREATE POLICY "Read commission policies" ON commission_policies
    FOR SELECT TO authenticated USING (true);

DROP POLICY IF EXISTS "Admin manage commission policies" ON commission_policies;
CREATE POLICY "Admin manage commission policies" ON commission_policies
    FOR ALL USING (get_current_user_role() = 'Admin');

-- 5. Customers RLS (Fix "Vãng lai" issue for Staff)
ALTER TABLE customers ENABLE ROW LEVEL SECURITY;

-- Allow everyone logged in to SEE customer list (needed for Order List)
DROP POLICY IF EXISTS "Authenticated users view customers" ON customers;
CREATE POLICY "Authenticated users view customers" ON customers
    FOR SELECT TO authenticated USING (true);
