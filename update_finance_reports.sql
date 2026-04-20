
-- ==============================================================================
-- 1. RPC: Get Debt Orders (Cong No)
-- ==============================================================================
CREATE OR REPLACE FUNCTION get_debt_orders()
RETURNS TABLE (
    id UUID,
    order_code TEXT,
    created_at TIMESTAMPTZ,
    customer_name TEXT,
    sales_rep_name TEXT,
    total_amount NUMERIC,
    deposit_amount NUMERIC,
    remaining_amount NUMERIC,
    payment_status payment_status,
    status order_status,
    description TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        o.id,
        o.order_code,
        o.created_at,
        c.name as customer_name,
        p.full_name as sales_rep_name,
        o.total_amount,
        o.deposit_amount,
        o.remaining_amount,
        o.payment_status,
        o.status,
        o.description
    FROM orders o
    LEFT JOIN customers c ON o.customer_id = c.id
    LEFT JOIN profiles p ON o.sales_rep_id = p.id
    WHERE o.payment_status = 'CongNo' 
      AND o.remaining_amount > 0
      AND o.status != 'Huy'
    ORDER BY o.created_at ASC; -- Oldest debt first
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- ==============================================================================
-- 2. RPC: Get Collection Orders (Don Can Thu)
-- ==============================================================================
CREATE OR REPLACE FUNCTION get_collection_orders()
RETURNS TABLE (
    id UUID,
    order_code TEXT,
    created_at TIMESTAMPTZ,
    customer_name TEXT,
    sales_rep_name TEXT,
    total_amount NUMERIC,
    deposit_amount NUMERIC,
    remaining_amount NUMERIC,
    payment_status payment_status,
    status order_status,
    delivery_date TIMESTAMPTZ,
    description TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        o.id,
        o.order_code,
        o.created_at,
        c.name as customer_name,
        p.full_name as sales_rep_name,
        o.total_amount,
        o.deposit_amount,
        o.remaining_amount,
        o.payment_status,
        o.status,
        o.delivery_date,
        o.description
    FROM orders o
    LEFT JOIN customers c ON o.customer_id = c.id
    LEFT JOIN profiles p ON o.sales_rep_id = p.id
    WHERE o.payment_status IN ('ChuaThanhToan', 'DaCoc')
      AND o.remaining_amount > 0
      AND o.status != 'Huy'
    ORDER BY o.delivery_date ASC NULLS LAST; -- Deliveries due soonest first
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
