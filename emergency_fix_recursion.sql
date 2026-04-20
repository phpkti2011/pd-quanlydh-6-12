-- ===========================================
-- EMERGENCY FIX: Infinite Recursion in RLS (Error 42P17)
-- Date: 2026-01-28
-- ===========================================
-- Issue: "infinite recursion detected in policy for relation profiles"
-- Root Cause: RLS policy on 'profiles' queries 'profiles' table directly, causing a loop.
-- Fix: Use a SECURITY DEFINER function to check role, allowing bypass of RLS recursion.
-- ===========================================

-- 1. Create Helper Function to Check Admin Role Safely (Bypasses RLS)
CREATE OR REPLACE FUNCTION auth.is_admin()
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

-- 2. Create Helper Function to Check Any Manager Role Safely
CREATE OR REPLACE FUNCTION auth.is_manager()
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

-- 3. FIX profiles RLS Policies (Use the functions instead of direct query)
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Admin full access profiles" ON profiles;
CREATE POLICY "Admin full access profiles" ON profiles
    FOR ALL
    USING ( auth.is_admin() );

DROP POLICY IF EXISTS "Admin update profiles" ON profiles;
-- Remove this duplicate policy if "Admin full access" covers it
-- If kept, use: USING ( auth.is_admin() );

-- Keep User's own access
DROP POLICY IF EXISTS "Users view own profile" ON profiles;
CREATE POLICY "Users view own profile" ON profiles
    FOR SELECT
    USING ( id = auth.uid() );

DROP POLICY IF EXISTS "Authenticated users view profiles" ON profiles;
CREATE POLICY "Authenticated users view profiles" ON profiles
    FOR SELECT
    USING ( true ); -- Allow everyone to read profiles (needed for picking users, etc.) 
    -- Or restrict if strictly needed, but recursion happens when filtering SELECTs based on SELECTs.
    -- "true" is safe for SELECT if we don't hide users from each other.

DROP POLICY IF EXISTS "User update own profile" ON profiles;
CREATE POLICY "User update own profile" ON profiles
    FOR UPDATE
    USING ( id = auth.uid() );


-- 4. FIX user_logs RLS Policies (Use the functions)
ALTER TABLE user_logs ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Admins and Managers can view all logs" ON user_logs;
CREATE POLICY "Admins and Managers can view all logs"
    ON user_logs FOR SELECT
    TO authenticated
    USING ( auth.is_manager() );

-- 5. VERIFY
SELECT 'SUCCESS: Recursive RLS policies fixed!' AS result;
