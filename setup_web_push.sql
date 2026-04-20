-- ============================================================
-- WEB PUSH NOTIFICATIONS SETUP
-- Chạy trong Supabase SQL Editor
-- ============================================================

-- 1. Bảng lưu push subscriptions của từng device
CREATE TABLE IF NOT EXISTS push_subscriptions (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    endpoint TEXT NOT NULL,
    keys_p256dh TEXT NOT NULL,
    keys_auth TEXT NOT NULL,
    user_agent TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(user_id, endpoint)
);

-- Index
CREATE INDEX IF NOT EXISTS idx_push_subs_user ON push_subscriptions(user_id);

-- RLS
ALTER TABLE push_subscriptions ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users manage own subscriptions" ON push_subscriptions;
CREATE POLICY "Users manage own subscriptions" ON push_subscriptions
    FOR ALL USING (user_id = auth.uid());

DROP POLICY IF EXISTS "Service can read all subscriptions" ON push_subscriptions;
CREATE POLICY "Service can read all subscriptions" ON push_subscriptions
    FOR SELECT USING (true);

-- 2. Function để lấy subscriptions theo user_id (dùng trong API)
CREATE OR REPLACE FUNCTION get_push_subscriptions(p_user_id UUID)
RETURNS TABLE(endpoint TEXT, keys_p256dh TEXT, keys_auth TEXT) AS $$
BEGIN
    RETURN QUERY
    SELECT ps.endpoint, ps.keys_p256dh, ps.keys_auth
    FROM push_subscriptions ps
    WHERE ps.user_id = p_user_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================
-- DONE! Chạy xong SQL này, sau đó deploy app.
-- ============================================================
