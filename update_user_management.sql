-- 1. Add columns for Employee Management to profiles table
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'profiles' AND column_name = 'employee_code') THEN
        ALTER TABLE profiles ADD COLUMN employee_code TEXT;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'profiles' AND column_name = 'position') THEN
        ALTER TABLE profiles ADD COLUMN position TEXT;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'profiles' AND column_name = 'competency_score') THEN
        ALTER TABLE profiles ADD COLUMN competency_score NUMERIC DEFAULT 1.0;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'profiles' AND column_name = 'commission_rate') THEN
        ALTER TABLE profiles ADD COLUMN commission_rate NUMERIC DEFAULT 0.0;
    END IF;
    -- These might be JSONB or extra columns. Based on EmployeeManager, they seem to be stored.
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'profiles' AND column_name = 'commission_subtasks') THEN
        ALTER TABLE profiles ADD COLUMN commission_subtasks JSONB DEFAULT '{}'::jsonb;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'profiles' AND column_name = 'commission_stages') THEN
        ALTER TABLE profiles ADD COLUMN commission_stages JSONB DEFAULT '{}'::jsonb;
    END IF;
END $$;

-- 2. Trigger to automatically create profile on SignUp
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, email, full_name, role)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'full_name', NEW.email),
    'Khach' -- Default role
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Drop trigger if exists to recreate
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();

-- 3. RLS Policies for Profiles (Update)
-- Ensure Admin can update ANY profile
DROP POLICY IF EXISTS "Admin update all profiles" ON profiles;
CREATE POLICY "Admin update all profiles" ON profiles
  FOR UPDATE USING (
    get_current_user_role() = 'Admin' 
  );
-- Ensure Users can update OWN profile (optional, mostly for self-service)
DROP POLICY IF EXISTS "Users update own profile" ON profiles;
CREATE POLICY "Users update own profile" ON profiles
  FOR UPDATE USING (
    auth.uid() = id
  );

-- Ensure correct permissions for reading
DROP POLICY IF EXISTS "Anyone can read basic profile info" ON profiles;
-- Actually, we have "Public profiles are viewable by everyone" usually, or at least authenticated.
-- Let's make sure:
CREATE POLICY "Authenticated users view profiles" ON profiles
    FOR SELECT TO authenticated USING (true);
