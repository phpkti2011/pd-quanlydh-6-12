-- Add employee management columns to profiles table
ALTER TABLE profiles
ADD COLUMN IF NOT EXISTS employee_code TEXT,
ADD COLUMN IF NOT EXISTS position TEXT,
ADD COLUMN IF NOT EXISTS competency_score NUMERIC DEFAULT 0,
ADD COLUMN IF NOT EXISTS commission_rate NUMERIC DEFAULT 0,
ADD COLUMN IF NOT EXISTS subtask_commission_policy NUMERIC DEFAULT 0,
ADD COLUMN IF NOT EXISTS sales_commission_policy NUMERIC DEFAULT 0;

-- Optional: Add unique constraint on employee_code if populated
-- CREATE UNIQUE INDEX IF NOT EXISTS idx_profiles_employee_code ON profiles(employee_code);

NOTIFY pgrst, 'reload schema';
