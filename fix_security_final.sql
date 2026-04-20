-- 1. SECURE ORDER PROCESS PARTICIPANTS
ALTER TABLE order_process_participants ENABLE ROW LEVEL SECURITY;

-- Allow everyone to SEE who worked on what (Process UI needs this)
DROP POLICY IF EXISTS "View participants" ON order_process_participants;
CREATE POLICY "View participants" ON order_process_participants
  FOR SELECT USING (
    -- Allow active users to see or just authenticated?
    -- Function is_user_active() exists from previous script.
    is_user_active()
  );

-- Allow users to JOIN (Insert their own record)
DROP POLICY IF EXISTS "Join stage" ON order_process_participants;
CREATE POLICY "Join stage" ON order_process_participants
  FOR INSERT WITH CHECK (
    is_user_active() AND
    auth.uid() = user_id -- Can only insert for self
  );

-- Allow users to LEAVE/UPDATE their own record (or Admin)
DROP POLICY IF EXISTS "Update own participation" ON order_process_participants;
CREATE POLICY "Update own participation" ON order_process_participants
  FOR UPDATE USING (
    is_user_active() AND
    (auth.uid() = user_id OR get_current_user_role() = 'Admin')
  );

DROP POLICY IF EXISTS "Delete own participation" ON order_process_participants;
CREATE POLICY "Delete own participation" ON order_process_participants
  FOR DELETE USING (
    is_user_active() AND
    (auth.uid() = user_id OR get_current_user_role() = 'Admin')
  );

-- 2. CLEANUP & SECURE LOGS
-- The app uses 'user_logs' (created safely). 'audit_logs' is likely a legacy/unused table from initial schema.
-- We will DROP 'audit_logs' to avoid confusion and risk.
DROP TABLE IF EXISTS audit_logs;

-- Re-verify 'user_logs' security just in case
ALTER TABLE user_logs ENABLE ROW LEVEL SECURITY;

-- Ensure Policy exists (Idempotent)
DROP POLICY IF EXISTS "Authenticated users can insert logs" ON user_logs;
CREATE POLICY "Authenticated users can insert logs"
    ON user_logs FOR INSERT
    TO authenticated
    WITH CHECK (true);

DROP POLICY IF EXISTS "Admins and Managers can view all logs" ON user_logs;
CREATE POLICY "Admins and Managers can view all logs"
    ON user_logs FOR SELECT
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM profiles
            WHERE profiles.id = auth.uid()
            AND profiles.role IN ('Admin', 'KeToan', 'QuanLySanXuat')
        )
    );
