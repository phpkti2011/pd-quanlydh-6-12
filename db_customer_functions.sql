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
