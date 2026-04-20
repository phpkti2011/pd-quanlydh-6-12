
-- 1. Ensure new roles exist in the ENUM
ALTER TYPE user_role ADD VALUE IF NOT EXISTS 'QuanLySanXuat';
ALTER TYPE user_role ADD VALUE IF NOT EXISTS 'NhanVienBinhFile';
ALTER TYPE user_role ADD VALUE IF NOT EXISTS 'NhanVienThietKe';

-- 2. Add UPDATE policy for profiles so Admin can change roles
DROP POLICY IF EXISTS "Admin update profiles" ON profiles;
CREATE POLICY "Admin update profiles" ON profiles
  FOR UPDATE USING (
    get_current_user_role() = 'Admin'
  );

-- 3. Allow users to update their own base fields (optional, but good practice)
DROP POLICY IF EXISTS "User update own profile" ON profiles;
CREATE POLICY "User update own profile" ON profiles
  FOR UPDATE USING (
    auth.uid() = id
  );
