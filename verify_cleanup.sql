-- VERIFY CLEANUP
DO $$
DECLARE
    order_count INT;
BEGIN
    SELECT COUNT(*) INTO order_count FROM orders;
    
    IF order_count = 0 THEN
        RAISE EXCEPTION 'VERIFICATION SUCCESS: Orders table is empty.';
    ELSE
        RAISE EXCEPTION 'VERIFICATION FAILED: Orders table has % rows.', order_count;
    END IF;
END $$;
