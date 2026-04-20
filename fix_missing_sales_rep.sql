-- ==============================================================================
-- FIX MISSING SALES_REP_ID (Corrected)
-- Problem: 'orders' table does not have 'user_id' column.
-- Solution: Retrieve creator from 'user_logs' (action_type = 'ORDER_CREATE') or 'order_process_participants'.
-- ==============================================================================

-- 1. Update from USER_LOGS (Most accurate for "Created By")
UPDATE orders o
SET sales_rep_id = ul.user_id::uuid
FROM user_logs ul
JOIN profiles p ON p.id = ul.user_id::uuid
WHERE (o.order_code = ul.entity_id OR o.id::text = ul.entity_id)
  AND ul.action_type = 'ORDER_CREATE'
  AND p.role IN ('NhanVienKinhDoanh', 'Admin')
  AND o.sales_rep_id IS NULL;

-- 2. Update from ORDER_PROCESS_PARTICIPANTS (Backup: First participant joined 'Moi' or 'TiepNhan')
-- This assumes the person who started the order process is likely the Sales Rep if they have that role.
UPDATE orders o
SET sales_rep_id = opp.user_id
FROM order_process_participants opp
JOIN profiles p ON p.id = opp.user_id
WHERE o.id = opp.order_id
  AND opp.stage IN ('Moi', 'TiepNhan')
  AND p.role IN ('NhanVienKinhDoanh')
  AND o.sales_rep_id IS NULL;

-- Verify
SELECT id, order_code, sales_rep_id 
FROM orders 
WHERE sales_rep_id IS NOT NULL 
LIMIT 10;
