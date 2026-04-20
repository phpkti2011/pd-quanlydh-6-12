-- OPTIMIZE PERFORMANCE
-- Add missing indexes heavily used by Triggers (update_customer_tier) and Reporting (Commissions)
-- This eliminates Sequential Scans on 'orders' table during updates.

BEGIN;

CREATE INDEX IF NOT EXISTS idx_orders_customer_id ON orders(customer_id);
CREATE INDEX IF NOT EXISTS idx_orders_sales_rep_id ON orders(sales_rep_id);
CREATE INDEX IF NOT EXISTS idx_orders_status ON orders(status);
CREATE INDEX IF NOT EXISTS idx_orders_created_at ON orders(created_at DESC);

-- Also index for Commission lookup
CREATE INDEX IF NOT EXISTS idx_st_entity ON sales_targets(entity_id, entity_type);

COMMIT;

NOTIFY pgrst, 'reload schema';
