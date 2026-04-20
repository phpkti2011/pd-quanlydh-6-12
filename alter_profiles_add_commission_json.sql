
-- Add JSONB columns for flexible commission configuration
ALTER TABLE profiles
ADD COLUMN IF NOT EXISTS commission_subtasks JSONB DEFAULT '{}'::jsonb,
ADD COLUMN IF NOT EXISTS commission_stages JSONB DEFAULT '{}'::jsonb;

-- Notify pgrst to reload schema
NOTIFY pgrst, 'reload schema';
