-- ===========================================
-- FIX V7: ADD MISSING TIER COLUMN
-- Date: 2026-01-28
-- ===========================================
-- Issue: Order creation fails with 'column "tier" does not exist'.
-- Root Cause: The 'update_customer_tier' trigger tries to update 'customers.tier',
-- but this column is missing from the table.
-- Fix: Add the missing 'tier' column to 'customers'.
-- ===========================================

-- 1. ADD COLUMN IF NOT EXISTS
ALTER TABLE customers 
ADD COLUMN IF NOT EXISTS tier TEXT DEFAULT 'Đồng';

-- 2. VERIFY & INDEX (Optional for performance)
CREATE INDEX IF NOT EXISTS idx_customers_tier ON customers(tier);

-- 3. VERIFY
SELECT 'SUCCESS: Added missing tier column to customers table.' AS result;
