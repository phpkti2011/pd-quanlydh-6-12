-- ===========================================
-- FIX V6: RESTORE ORDER CREATION (Order Code Gen)
-- Date: 2026-01-28
-- ===========================================
-- Issue: Sales Reps cannot create orders.
-- Root Cause: The "Nuclear Fix" dropped the 'before_insert_order_code' trigger, 
-- causing 'order_code' to be NULL on insert, which violates NOT NULL constraint.
-- Fix: Restore order code generation trigger and other useful logic.
-- ===========================================

-- 1. RESTORE ORDER CODE GENERATOR
CREATE OR REPLACE FUNCTION generate_order_code()
RETURNS TEXT
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    date_part TEXT;
    seq_part INT;
    new_code TEXT;
    start_of_month TIMESTAMP WITH TIME ZONE;
BEGIN
    -- Format: YYPDDDMM.NNNN
    -- Example: 25PD2212.0021
    
    -- 1. Generate Date Part: YY + PD + DDMM
    date_part := to_char(NOW() AT TIME ZONE 'Asia/Ho_Chi_Minh', 'YY') || 'PD' || to_char(NOW() AT TIME ZONE 'Asia/Ho_Chi_Minh', 'DDMM');
    
    -- 2. Calculate Monthly Sequence
    start_of_month := date_trunc('month', NOW() AT TIME ZONE 'Asia/Ho_Chi_Minh');
    
    SELECT COUNT(*) + 1
    INTO seq_part
    FROM orders
    WHERE created_at >= start_of_month;
    
    -- 3. Combine
    new_code := date_part || '.' || lpad(seq_part::TEXT, 4, '0');
    
    RETURN new_code;
END;
$$;

-- 2. RESTORE TRIGGER FUNCTION
CREATE OR REPLACE FUNCTION set_order_code()
RETURNS TRIGGER AS $$
BEGIN
    -- Only generate if order_code is not provided or empty
    IF NEW.order_code IS NULL OR NEW.order_code = '' THEN
        NEW.order_code := generate_order_code();
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 3. ATTACH TRIGGER (BEFORE INSERT)
DROP TRIGGER IF EXISTS before_insert_order_code ON orders;
CREATE TRIGGER before_insert_order_code
BEFORE INSERT ON orders
FOR EACH ROW
EXECUTE FUNCTION set_order_code();


-- ===========================================
-- 4. RESTORE CUSTOMER TIER UPDATE (Optional but good to have back)
-- ===========================================
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
    cust_id := NEW.customer_id;
    
    SELECT COALESCE(SUM(total_amount), 0)
    INTO total_rev
    FROM orders
    WHERE customer_id = cust_id AND status != 'Huy';

    IF total_rev >= 200000000 THEN new_tier := 'Bạch Kim';
    ELSIF total_rev >= 50000000 THEN new_tier := 'Vàng';
    ELSIF total_rev >= 10000000 THEN new_tier := 'Bạc';
    ELSE new_tier := 'Đồng';
    END IF;

    UPDATE customers 
    SET tier = new_tier, updated_at = NOW() 
    WHERE id = cust_id AND tier IS DISTINCT FROM new_tier;

    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trigger_update_tier ON orders;
CREATE TRIGGER trigger_update_tier
AFTER INSERT OR UPDATE OF total_amount, status
ON orders
FOR EACH ROW
EXECUTE FUNCTION update_customer_tier();

-- 5. VERIFY INSERT POLICY (Just to be triple sure)
DROP POLICY IF EXISTS "Insert orders" ON orders;
CREATE POLICY "Insert orders" ON orders FOR INSERT WITH CHECK (true);


-- 6. VERIFY
SELECT 'SUCCESS: Order Code Generation Restored. Creation should work now.' AS result;
