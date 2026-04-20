-- Add missing 'tags' column for CRM Automation
ALTER TABLE customers 
ADD COLUMN IF NOT EXISTS tags TEXT[] DEFAULT '{}';

COMMENT ON COLUMN customers.tags IS 'Array of customer tags (e.g. Khách Mới, Khách Quen, VIP)';
