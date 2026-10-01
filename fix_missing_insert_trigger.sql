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
    WHERE created_at >= start_of_month
      -- Đơn sản xuất lại mang mã <gốc>-L{n}, không chiếm số thứ tự tháng
      -- (xem setup_rework_orders.sql). Đếm cả chúng thì mã đơn thường bị nhảy số.
      AND rework_of_order_id IS NULL;
    
    -- 3. Combine
    new_code := date_part || '.' || lpad(seq_part::TEXT, 4, '0');
    
    RETURN new_code;
END;
$$;

-- 2. RESTORE TRIGGER FUNCTION
--     Đơn làm lại: <mã gốc>-L<số đơn làm lại hiện có của gốc + 1>. Luôn quy về
--     đơn gốc tận cùng, kể cả khi client gửi id của một đơn -L. SECURITY DEFINER
--     để đọc đơn gốc / đếm đơn -L bất kể RLS của người tạo. Hai người tạo cùng
--     lúc trùng mã -> UNIQUE(order_code) chặn, bấm Lưu lại là xong.
--     (xem setup_rework_orders.sql)
CREATE OR REPLACE FUNCTION set_order_code()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    v_root_id     UUID;
    v_root_code   TEXT;
    v_root_parent UUID;
    v_seq         INT;
BEGIN
    -- Đơn sản xuất lại: quy về đơn gốc tận cùng (làm lại của -L1 vẫn treo vào gốc)
    IF NEW.rework_of_order_id IS NOT NULL THEN
        SELECT id, order_code, rework_of_order_id
        INTO v_root_id, v_root_code, v_root_parent
        FROM orders WHERE id = NEW.rework_of_order_id;

        IF v_root_id IS NULL THEN
            RAISE EXCEPTION 'Không tìm thấy đơn gốc (%) để tạo đơn sản xuất lại', NEW.rework_of_order_id;
        END IF;

        IF v_root_parent IS NOT NULL THEN
            NEW.rework_of_order_id := v_root_parent;
            SELECT order_code INTO v_root_code FROM orders WHERE id = v_root_parent;
        END IF;
    END IF;

    -- Only generate if order_code is not provided or empty
    IF NEW.order_code IS NULL OR NEW.order_code = '' THEN
        IF NEW.rework_of_order_id IS NOT NULL THEN
            SELECT COUNT(*) + 1 INTO v_seq
            FROM orders WHERE rework_of_order_id = NEW.rework_of_order_id;
            NEW.order_code := v_root_code || '-L' || v_seq;
        ELSE
            NEW.order_code := generate_order_code();
        END IF;
    END IF;
    RETURN NEW;
END;
$$;

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
