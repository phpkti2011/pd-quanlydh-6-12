-- CLEAN TEST DATA SCRIPT

BEGIN;

-- 1. Delete all Orders
-- Cascades to:
-- - order_process_participants
-- - order_comments (if any)
-- - order_items (if any, though schema seems to treat orders as flat mostly or joined)
DELETE FROM orders;

-- 2. Clean Audit Logs related to Orders
DELETE FROM audit_logs WHERE table_name = 'orders';

COMMIT;

-- Verification
DO $$
DECLARE
    order_count INT;
    part_count INT;
BEGIN
    SELECT COUNT(*) INTO order_count FROM orders;
    SELECT COUNT(*) INTO part_count FROM order_process_participants;
    
    RAISE NOTICE 'Cleanup Complete. Remaining Orders: %, Remaining Participants: %', order_count, part_count;
END $$;
