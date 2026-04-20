-- Fix RLS: Allow creating and updating customers
-- Currently only SELECT is allowed, which causes the "new row violates row-level security policy" error.

-- 1. Insert Policy
DROP POLICY IF EXISTS "Insert customers" ON customers;
CREATE POLICY "Insert customers" ON customers
  FOR INSERT WITH CHECK (
    get_current_user_role() IN ('Admin', 'NhanVienKinhDoanh', 'KeToan')
  );

-- 2. Update Policy
DROP POLICY IF EXISTS "Update customers" ON customers;
CREATE POLICY "Update customers" ON customers
  FOR UPDATE USING (
    get_current_user_role() IN ('Admin', 'NhanVienKinhDoanh', 'KeToan')
  );
