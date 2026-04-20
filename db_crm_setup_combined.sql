-- Combined CRM Setup Script
-- Execute all CRM-related schemas, functions, and triggers

-- =====================================================
-- Part 1: Customer Functions
-- =====================================================

-- Function: Auto-generate Customer Code (KH + YY + Sequence)
-- Format: KH240001, KH250001
CREATE OR REPLACE FUNCTION generate_customer_code()
RETURNS TEXT
LANGUAGE plpgsql
AS $$
DECLARE
    year_prefix TEXT;
    next_seq INT;
    new_code TEXT;
BEGIN
    -- Get current year last 2 digits (e.g., '24', '25')
    year_prefix := to_char(NOW(), 'YY');
    
    -- Find max code for current year to increment
    -- Codes starting with 'KH' + year_prefix
    SELECT COALESCE(MAX(SUBSTRING(code FROM 5)::INT), 0) + 1
    INTO next_seq
    FROM customers
    WHERE code LIKE 'KH' || year_prefix || '%';

    -- Format: KH + YY + 0000 (padding)
    new_code := 'KH' || year_prefix || lpad(next_seq::TEXT, 4, '0');
    
    RETURN new_code;
END;
$$;

-- Function: Get Customer Analytics
-- Returns useful stats for the Customer Manager UI
CREATE OR REPLACE FUNCTION get_customer_analytics(customer_id_input UUID)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    result JSONB;
BEGIN
    SELECT jsonb_build_object(
        'totalRevenue', COALESCE(SUM(total_amount), 0),
        'orderCount', COUNT(id),
        'lastOrderDate', MAX(created_at),
        'avgDaysBetweenOrders', 0 -- Placeholder for more complex calculation if needed
    )
    INTO result
    FROM orders
    WHERE customer_id = customer_id_input AND status != 'Huy';

    RETURN result;
END;
$$;

-- =====================================================
-- Part 2: CRM Schema Updates
-- =====================================================

-- Add CRM fields to customers table
ALTER TABLE customers ADD COLUMN IF NOT EXISTS tier TEXT DEFAULT 'Đồng';
ALTER TABLE customers ADD COLUMN IF NOT EXISTS tags TEXT[] DEFAULT '{}';
ALTER TABLE customers ADD COLUMN IF NOT EXISTS loyalty_points INT DEFAULT 0;

-- Create Customer Interaction Logs table
CREATE TABLE IF NOT EXISTS customer_logs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  customer_id UUID REFERENCES customers(id) ON DELETE CASCADE,
  type TEXT NOT NULL, -- 'Call', 'Visit', 'Note', 'Complaint'
  content TEXT,
  created_by UUID REFERENCES profiles(id), -- Nullable if system gen? Better keep references.
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS for logs
ALTER TABLE customer_logs ENABLE ROW LEVEL SECURITY;

-- Policy: Admin/Sales/Accountant can view all logs
DROP POLICY IF EXISTS "View customer logs" ON customer_logs;
CREATE POLICY "View customer logs" ON customer_logs
  FOR SELECT USING (
    get_current_user_role() IN ('Admin', 'NhanVienKinhDoanh', 'KeToan')
  );

-- Policy: Admin/Sales/Accountant can insert logs
DROP POLICY IF EXISTS "Insert customer logs" ON customer_logs;
CREATE POLICY "Insert customer logs" ON customer_logs
  FOR INSERT WITH CHECK (
    get_current_user_role() IN ('Admin', 'NhanVienKinhDoanh', 'KeToan')
  );

-- =====================================================
-- Part 3: CRM Triggers (Auto Tier Update)
-- =====================================================

-- Function to calculate total revenue and update tier
CREATE OR REPLACE FUNCTION update_customer_tier()
RETURNS TRIGGER 
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    total_rev NUMERIC;
    new_tier TEXT;
    cust_id UUID;
BEGIN
    -- Determine customer_id (from NEW or OLD depending on operation, usually NEW for Update/Insert)
    cust_id := NEW.customer_id;
    
    -- Calculate total revenue for this customer (only non-cancelled orders)
    SELECT COALESCE(SUM(total_amount), 0)
    INTO total_rev
    FROM orders
    WHERE customer_id = cust_id AND status != 'Huy';

    -- Determine Tier
    IF total_rev >= 200000000 THEN
        new_tier := 'Bạch Kim';
    ELSIF total_rev >= 50000000 THEN
        new_tier := 'Vàng';
    ELSIF total_rev >= 10000000 THEN
        new_tier := 'Bạc';
    ELSE
        new_tier := 'Đồng';
    END IF;

    -- Update Customer Table if tier changes
    UPDATE customers 
    SET tier = new_tier, 
        updated_at = NOW() 
    WHERE id = cust_id AND tier != new_tier;

    RETURN NEW;
END;
$$;

-- Trigger on Orders Table
DROP TRIGGER IF EXISTS trigger_update_tier ON orders;
CREATE TRIGGER trigger_update_tier
AFTER INSERT OR UPDATE OF total_amount, status
ON orders
FOR EACH ROW
EXECUTE FUNCTION update_customer_tier();
