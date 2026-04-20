-- 1. ADD SOFT DELETE & LOCK COLUMNS
ALTER TABLE profiles 
ADD COLUMN IF NOT EXISTS deleted_at TIMESTAMPTZ,
ADD COLUMN IF NOT EXISTS is_locked BOOLEAN DEFAULT FALSE;

-- 2. UPDATE ADMIN_DELETE_USER (SOFT DELETE)
CREATE OR REPLACE FUNCTION admin_delete_user(target_user_id UUID)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
    -- Check if requester is Admin
    IF NOT EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'Admin') THEN
        RAISE EXCEPTION 'Access Denied: Only Admins can delete users.';
    END IF;

    -- Soft Delete: Update Profile instead of deleting from auth
    UPDATE profiles
    SET 
        deleted_at = NOW(),
        is_locked = TRUE, -- Lock account
        updated_at = NOW()
    WHERE id = target_user_id;

    -- Optional: We could also rename the email to free it up, but for Soft Delete we usually keep it to prevent duplicates
    -- If user wants to reuse email, they must hard delete. 
END;
$$;

-- 3. HELPER FOR CHECKING ACTIVE STATUS (Used in RLS)
-- Checks if the CURRENT user is allowed to access data
CREATE OR REPLACE FUNCTION is_user_active()
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
  SELECT EXISTS (
    SELECT 1 FROM profiles 
    WHERE id = auth.uid() 
      AND (is_locked IS FALSE OR is_locked IS NULL)
      AND deleted_at IS NULL
  );
$$;

-- 4. UPDATE RLS POLICIES TO ENFORCE LOCKING
-- We need to update policies on major tables. 
-- Note: 'Admin' might need bypass, but usually even locked Admins should be blocked.
-- Strategy: Add "AND is_user_active()" to the USING clause.

-- A. ORDERS
DROP POLICY IF EXISTS "Sales see own orders" ON orders;
CREATE POLICY "Sales see own orders" ON orders
  FOR SELECT USING (
    is_user_active() AND (
      auth.uid() = sales_rep_id OR 
      get_current_user_role() IN ('Admin', 'KeToan')
    )
  );

DROP POLICY IF EXISTS "Production see active orders" ON orders;
CREATE POLICY "Production see active orders" ON orders
  FOR SELECT USING (
    is_user_active() AND (
      (status NOT IN ('Moi', 'Huy') AND get_current_user_role() = 'NhanVienSanXuat')
    )
  );

DROP POLICY IF EXISTS "Insert orders" ON orders;
CREATE POLICY "Insert orders" ON orders
  FOR INSERT WITH CHECK (
    is_user_active() AND
    get_current_user_role() IN ('Admin', 'NhanVienKinhDoanh', 'KeToan')
  );

DROP POLICY IF EXISTS "Update orders" ON orders;
CREATE POLICY "Update orders" ON orders
  FOR UPDATE USING (
    is_user_active() AND
    get_current_user_role() IN ('Admin', 'NhanVienKinhDoanh', 'KeToan')
  );

-- B. CUSTOMERS
DROP POLICY IF EXISTS "View customers" ON customers;
CREATE POLICY "View customers" ON customers
  FOR SELECT USING (
    is_user_active() AND
    get_current_user_role() IN ('Admin', 'NhanVienKinhDoanh', 'KeToan')
  );

DROP POLICY IF EXISTS "Insert customers" ON customers;
CREATE POLICY "Insert customers" ON customers
  FOR INSERT WITH CHECK (
    is_user_active() AND
    get_current_user_role() IN ('Admin', 'NhanVienKinhDoanh', 'KeToan')
  );

DROP POLICY IF EXISTS "Update customers" ON customers;
CREATE POLICY "Update customers" ON customers
  FOR UPDATE USING (
    is_user_active() AND
    get_current_user_role() IN ('Admin', 'NhanVienKinhDoanh', 'KeToan')
  );

-- C. PROFILES (Prevent locked users from even seeing profiles?)
-- Ideally yes.
DROP POLICY IF EXISTS "View own profile" ON profiles;
CREATE POLICY "View own profile" ON profiles 
  FOR SELECT USING (
    -- Allow user to see their own profile even if locked (so they can at least know they exist?)
    -- User requested "Block at backend".
    -- If we block getting their own profile, App.tsx might loop or error out. 
    -- However, App.tsx checks profile.is_locked using valid credentials. 
    -- If RLS blocks it, getProfile returns null.
    -- App.tsx handles null profile by just setting session userRole = empty. 
    -- But we want to explicitly TELL them they are locked. 
    -- So we should probably ALLOW reading OWN profile even if locked, but nothing else.
    auth.uid() = id OR 
    (is_user_active() AND get_current_user_role() IN ('Admin', 'KeToan'))
  );

-- D. COMMISSION POLICIES & OTHERS
-- Apply generic lock check
ALTER TABLE commission_policies ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "View policies" ON commission_policies;
CREATE POLICY "View policies" ON commission_policies
    FOR SELECT USING (is_user_active());

-- 5. UPDATE EXISTING PROFILES TO NULL DELETED_AT
UPDATE profiles SET deleted_at = NULL WHERE deleted_at IS NULL;
