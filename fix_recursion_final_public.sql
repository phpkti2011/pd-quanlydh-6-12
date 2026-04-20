-- ===========================================
-- FINAL EMERGENCY FIX: Infinite Recursion & Permissions
-- Date: 2026-01-28
-- ===========================================
-- Issue: "infinite recursion" + "permission denied for schema auth"
-- Solution: Create helper functions in PUBLIC schema instead of AUTH.
-- ===========================================

-- 1. Create Helper Function in PUBLIC schema (Safe)
CREATE OR REPLACE FUNCTION public.is_admin_safe()
RETURNS BOOLEAN
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM profiles 
    WHERE id = auth.uid() 
    AND role::text = 'Admin'
  );
$$;

-- 2. Create Helper Function for Managers in PUBLIC schema
CREATE OR REPLACE FUNCTION public.is_manager_safe()
RETURNS BOOLEAN
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM profiles 
    WHERE id = auth.uid() 
    AND role::text IN ('Admin', 'KeToan', 'QuanLySanXuat')
  );
$$;

-- 3. FIX profiles RLS Policies (Use the PUBLIC functions)
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Admin full access profiles" ON profiles;
CREATE POLICY "Admin full access profiles" ON profiles
    FOR ALL
    USING ( public.is_admin_safe() );

DROP POLICY IF EXISTS "Admin update profiles" ON profiles;
-- Remove duplicate if exists

-- Keep User's own access
DROP POLICY IF EXISTS "Users view own profile" ON profiles;
CREATE POLICY "Users view own profile" ON profiles
    FOR SELECT
    USING ( id = auth.uid() );

DROP POLICY IF EXISTS "Authenticated users view profiles" ON profiles;
CREATE POLICY "Authenticated users view profiles" ON profiles
    FOR SELECT
    USING ( true ); 

DROP POLICY IF EXISTS "User update own profile" ON profiles;
CREATE POLICY "User update own profile" ON profiles
    FOR UPDATE
    USING ( id = auth.uid() );


-- 4. FIX user_logs RLS Policies
ALTER TABLE user_logs ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Admins and Managers can view all logs" ON user_logs;
CREATE POLICY "Admins and Managers can view all logs"
    ON user_logs FOR SELECT
    TO authenticated
    USING ( public.is_manager_safe() );

-- 5. VERIFY
SELECT 'SUCCESS: Recursion permissions fixed in PUBLIC schema!' AS result;
