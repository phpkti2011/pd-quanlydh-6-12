-- FIX ORDER STATUS UPDATE ERROR
-- Limit: Production users (NhanVienSanXuat) could not update order status because:
-- 1. Triggers on 'orders' (updating customers) were executing as the user, failing RLS on 'customers' table.
-- 2. OR 'orders' UPDATE policy was overwritten/missing permissions.

BEGIN;

-- 1. Ensure 'orders' UPDATE policy allows Production Staff
DROP POLICY IF EXISTS "Update orders" ON orders;

CREATE POLICY "Update orders" ON orders
  FOR UPDATE USING (
    auth.uid() = sales_rep_id -- Sales Reps
    OR
    get_current_user_role() IN ('Admin', 'NhanVienKinhDoanh', 'KeToan') -- Admin/Sales/Accountant
    OR
    -- Production can update ACTIVE orders (not New/Cancelled)
    (status NOT IN ('Moi', 'Huy') AND 
     get_current_user_role() IN ('NhanVienSanXuat', 'QuanLySanXuat', 'NhanVienThietKe', 'NhanVienBinhFile'))
  );

-- 2. FIX TRIGGERS: Ensure they are SECURITY DEFINER so they can update 'customers' table
-- even if the logged-in user (NhanVienSanXuat) does not have direct permission to update customers.

CREATE OR REPLACE FUNCTION update_customer_tier()
RETURNS TRIGGER 
LANGUAGE plpgsql
SECURITY DEFINER -- Critical: Run as Owner (Admin)
AS $$
DECLARE
    total_rev NUMERIC;
    new_tier TEXT;
    cust_id UUID;
BEGIN
    cust_id := NEW.customer_id;
    
    -- Calculate total revenue (excluding Cancelled)
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

    -- Update Customer (Bypass RLS due to SECURITY DEFINER)
    UPDATE customers 
    SET tier = new_tier, 
        updated_at = NOW() 
    WHERE id = cust_id AND tier != new_tier;

    RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION update_customer_crm_stats()
RETURNS TRIGGER 
LANGUAGE plpgsql
SECURITY DEFINER -- Critical: Run as Owner (Admin)
AS $$
DECLARE
    cust_id UUID;
    total_orders INTEGER;
    last_date TIMESTAMP WITH TIME ZONE;
    current_tags TEXT[];
BEGIN
    cust_id := NEW.customer_id;
    
    -- Calculate Stats
    SELECT COUNT(*), MAX(created_at)
    INTO total_orders, last_date
    FROM orders
    WHERE customer_id = cust_id AND status != 'Huy';

    -- Update Customer (Bypass RLS)
    UPDATE customers 
    SET 
        order_count = total_orders,
        last_order_at = last_date,
        updated_at = NOW()
    WHERE id = cust_id;

    RETURN NEW;
END;
$$;

COMMIT;

-- Re-notify schema cache
NOTIFY pgrst, 'reload schema';
