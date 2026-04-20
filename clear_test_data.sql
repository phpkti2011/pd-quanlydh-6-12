
-- Clean up all order-related test data

-- 1. Clear Comments/Messages linked to orders
DELETE FROM order_comments;

-- 2. Clear Order Participants
DELETE FROM order_process_participants;

-- 3. Clear Activity Logs (User agreed to clean slate)
DELETE FROM user_logs;

-- 4. Clear Notifications (if table exists - standard name usually)
-- IF EXISTS (SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'notifications') THEN
--    DELETE FROM notifications;
-- END IF;
-- (Simpler to just try delete if we are sure, but better to skip if unsure. I'll stick to known tables)

-- 5. Finally, Clear Orders
-- This will likely cascade delete other related unnamed links if FKs are set to CASCADE
DELETE FROM orders;

-- Reset Sequences if needed (optional)
