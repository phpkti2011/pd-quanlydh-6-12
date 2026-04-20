-- DISABLE Notification Triggers
-- This script removes the triggers causing errors during Order Status Updates.

-- 1. Drop Phase 1 Trigger & Function (Payment Approval)
DROP TRIGGER IF EXISTS check_payment_approval ON orders CASCADE;
DROP FUNCTION IF EXISTS notify_payment_approval() CASCADE;

-- 2. Drop Phase 2 Triggers & Functions (Design, Production, Sales)
DROP TRIGGER IF EXISTS check_design_status ON orders CASCADE;
DROP FUNCTION IF EXISTS notify_design_status() CASCADE;

DROP TRIGGER IF EXISTS check_production_start ON orders CASCADE;
DROP FUNCTION IF EXISTS notify_production_start() CASCADE;

DROP TRIGGER IF EXISTS check_sales_completed ON orders CASCADE;
DROP FUNCTION IF EXISTS notify_sales_completed() CASCADE;

-- 3. Drop Helper Function
DROP FUNCTION IF EXISTS create_notification(UUID, TEXT, TEXT, TEXT, UUID, TEXT) CASCADE;

-- Note: The 'notifications' table remains but will no longer be populated by triggers.
