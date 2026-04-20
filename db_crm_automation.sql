-- CRM Automation: Customer Stats & Auto-Tagging
-- This trigger automatically updates order_count, last_order_at, and manages lifecycle tags (Khách Mới/Khách Quen)

CREATE OR REPLACE FUNCTION update_customer_crm_stats()
RETURNS TRIGGER 
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    cust_id UUID;
    total_orders INTEGER;
    last_date TIMESTAMP WITH TIME ZONE;
    current_tags TEXT[];
BEGIN
    -- Determine customer_id
    cust_id := NEW.customer_id;
    
    -- 1. Calculate Stats (Count valid orders)
    SELECT COUNT(*), MAX(created_at)
    INTO total_orders, last_date
    FROM orders
    WHERE customer_id = cust_id AND status != 'Huy';

    -- 2. Fetch current tags
    SELECT tags INTO current_tags FROM customers WHERE id = cust_id;
    IF current_tags IS NULL THEN
        current_tags := ARRAY[]::TEXT[];
    END IF;

    -- 3. Auto-Tagging Logic
    -- Remove old lifecycle tags to prevent duplicates or stale state
    current_tags := array_remove(current_tags, 'Khách Mới');
    current_tags := array_remove(current_tags, 'Khách Quen');

    IF total_orders = 1 THEN
        current_tags := array_append(current_tags, 'Khách Mới');
    ELSIF total_orders >= 2 THEN
        current_tags := array_append(current_tags, 'Khách Quen');
    END IF;

    -- 4. Update Customer Record
    UPDATE customers 
    SET 
        order_count = total_orders,
        last_order_at = last_date,
        tags = current_tags,
        updated_at = NOW()
    WHERE id = cust_id;

    RETURN NEW;
END;
$$;

-- Drop trigger if exists to avoid conflicts
DROP TRIGGER IF EXISTS trigger_update_crm_stats ON orders;

-- Create Trigger
-- Runs after INSERT (new order) or UPDATE of status (cancelled/uncancelled)
CREATE TRIGGER trigger_update_crm_stats
AFTER INSERT OR UPDATE OF status
ON orders
FOR EACH ROW
EXECUTE FUNCTION update_customer_crm_stats();
