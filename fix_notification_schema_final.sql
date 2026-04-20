-- FINAL SCHEMA FIX for Notification System
-- The previous error "column reference_id does not exist" implies the table exists but is missing columns.

-- 1. Add missing columns safely
ALTER TABLE notifications ADD COLUMN IF NOT EXISTS reference_id UUID REFERENCES orders(id) ON DELETE SET NULL;
ALTER TABLE notifications ADD COLUMN IF NOT EXISTS link TEXT;
ALTER TABLE notifications ADD COLUMN IF NOT EXISTS type TEXT;

-- 2. Drop and Recreate the Helper Function (to ensure it matches the new schema)
DROP FUNCTION IF EXISTS create_notification(UUID, TEXT, TEXT, TEXT, UUID, TEXT);

CREATE OR REPLACE FUNCTION create_notification(
    p_user_id UUID,
    p_title TEXT,
    p_message TEXT,
    p_type TEXT,
    p_ref_id UUID,
    p_link TEXT
) RETURNS VOID AS $$
BEGIN
    INSERT INTO notifications (user_id, title, message, type, reference_id, link)
    VALUES (p_user_id, p_title, p_message, p_type, p_ref_id, p_link);
END;
$$ LANGUAGE plpgsql;

-- 3. (Optional) Re-verify Triggers are present (The previous script should have added them, but running this won't hurt)
-- We rely on the previous script 'fix_notification_complete.sql' having run or this being run AFTER it.
-- But since the table schema was the blocker, fixing the schema should allow the PREVIOUS function calls to succeed.
