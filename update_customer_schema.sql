-- Add new columns for CRM Upgrade Phase 1

-- 1. Refused Provide Phone (Khách từ chối cung cấp SĐT)
ALTER TABLE customers 
ADD COLUMN IF NOT EXISTS refused_provide_phone BOOLEAN DEFAULT FALSE;

-- 2. Urgent Entry (Gấp - Bổ sung sau)
ALTER TABLE customers 
ADD COLUMN IF NOT EXISTS is_urgent_entry BOOLEAN DEFAULT FALSE;

-- 3. Order Count (Lifecycle tracking)
ALTER TABLE customers 
ADD COLUMN IF NOT EXISTS order_count INTEGER DEFAULT 0;

-- 4. Last Order Date (Churn tracking)
ALTER TABLE customers 
ADD COLUMN IF NOT EXISTS last_order_at TIMESTAMP WITH TIME ZONE;

-- Comment on columns
COMMENT ON COLUMN customers.refused_provide_phone IS 'Flag if customer explicitly refused to provide phone number';
COMMENT ON COLUMN customers.is_urgent_entry IS 'Flag if customer entry was created in urgent mode without phone';
COMMENT ON COLUMN customers.order_count IS 'Total number of valid orders placed by this customer';
COMMENT ON COLUMN customers.last_order_at IS 'Timestamp of the most recent order';

-- Optional: Create an index on phone for faster lookup (if not exists)
CREATE INDEX IF NOT EXISTS idx_customers_phone ON customers(phone);
