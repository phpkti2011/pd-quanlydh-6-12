
-- Add JSONB column for Tiered Commission Policy
-- Structure: Array of objects [{ "min": 0, "max": 100, "rate": 1 }, ...]
ALTER TABLE profiles
ADD COLUMN IF NOT EXISTS commission_tiers JSONB DEFAULT '[]'::jsonb;

-- Notify schema reload
NOTIFY pgrst, 'reload schema';
