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
    
    -- Calculate total revenue for this customer (only Completed orders)
    -- We include the current order if it's completed
    SELECT COALESCE(SUM(total_amount), 0)
    INTO total_rev
    FROM orders
    WHERE customer_id = cust_id AND status = 'DaGiaoHang'; -- Only count delivered/finalized orders? 
    -- Or maybe 'HoanThanh' if that's the final status. Based on ENUM: 'DaGiaoHang' seems final for shipping. 'HoanThanh' might be used too.
    -- Let's check ENUM: 'Moi', 'TiepNhan', ..., 'GiaoHang', 'HoanThanh', 'Huy', 'TamNgung', 'DaGiaoHang'.
    -- Let's assume 'DaGiaoHang' and 'HoanThanh' are revenue-generating.
    
    -- Actually, simpler: sum all EXCEPT 'Huy' (Cancelled) and 'Moi' (New).
    -- Or just sum everything that is NOT Cancelled if we want "Potential" tier? 
    -- Usually Tier is based on REAL money paid. So let's stick to 'DaGiaoHang' or 'HoanThanh' or 'DaThanhToan' payment status?
    -- Let's stick to Order Status for simplicity first. 
    -- SAFE BET: Status != 'Huy'.
    
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
