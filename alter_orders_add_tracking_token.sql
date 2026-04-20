-- 1. Add tracking_token column (Safely)
ALTER TABLE orders 
ADD COLUMN IF NOT EXISTS tracking_token UUID DEFAULT gen_random_uuid();

-- 2. Make sure it's unique
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint WHERE conname = 'orders_tracking_token_key'
    ) THEN
        ALTER TABLE orders ADD CONSTRAINT orders_tracking_token_key UNIQUE (tracking_token);
    END IF;
END $$;

-- 3. Backfill existing orders
UPDATE orders SET tracking_token = gen_random_uuid() WHERE tracking_token IS NULL;

-- 4. Create Public RPC function to get order details by token
-- SECURITY DEFINER allows it to run with privileges of creator (postgres), bypassing RLS for the public user (anon)

DROP FUNCTION IF EXISTS get_public_order_info(UUID); -- Drop old version to ensure clean replace

CREATE OR REPLACE FUNCTION get_public_order_info(p_token UUID)
RETURNS TABLE (
    order_code TEXT,
    created_at TIMESTAMPTZ,
    status TEXT, -- Explicitly TEXT to match casting
    delivery_date DATE, -- Returning DATE
    customer_name TEXT,
    description TEXT,
    notes TEXT,
    items JSONB
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        o.order_code::TEXT,
        o.created_at, -- Matches TIMESTAMPTZ
        o.status::TEXT, -- Cast ENUM to TEXT
        o.delivery_date::DATE, -- Cast TIMESTAMPTZ to DATE
        c.name::TEXT as customer_name,
        o.description::TEXT,
        o.notes::TEXT,
        '[]'::JSONB as items
    FROM orders o
    LEFT JOIN customers c ON o.customer_id = c.id
    WHERE o.tracking_token = p_token;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 5. Grant access to 'anon' and 'authenticated' roles
GRANT EXECUTE ON FUNCTION get_public_order_info(UUID) TO anon, authenticated, service_role;
