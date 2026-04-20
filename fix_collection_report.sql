
DROP FUNCTION IF EXISTS get_collection_orders();

CREATE OR REPLACE FUNCTION get_collection_orders()
RETURNS TABLE (
    id uuid,
    order_code text,
    customer_id uuid,
    customer_name text,
    sales_rep_id uuid,
    sales_rep_name text,
    total_amount numeric,
    deposit_amount numeric,
    remaining_amount numeric,
    payment_status text,
    payment_confirmed boolean,
    created_at timestamptz
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RETURN QUERY
  SELECT 
    o.id,
    o.order_code,
    o.customer_id,
    COALESCE(c.name, 'Vãng lai')::text as customer_name,
    o.sales_rep_id,
    COALESCE(p.full_name, 'N/A')::text as sales_rep_name,
    o.total_amount::numeric,
    COALESCE(o.deposit_amount, 0)::numeric,
    (o.total_amount - COALESCE(o.deposit_amount, 0))::numeric as remaining_amount,
    o.payment_status::text,
    COALESCE(o.payment_confirmed, false)::boolean,
    o.created_at
  FROM orders o
  LEFT JOIN customers c ON o.customer_id = c.id
  LEFT JOIN profiles p ON o.sales_rep_id = p.id
  WHERE 
    o.status != 'Huy' 
    AND o.payment_status != 'DaThanhToan' 
    AND o.payment_status != 'CongNo' 
    AND (o.total_amount - COALESCE(o.deposit_amount, 0)) > 0
  ORDER BY o.created_at DESC;
END;
$$;

GRANT EXECUTE ON FUNCTION get_collection_orders TO authenticated;
GRANT EXECUTE ON FUNCTION get_collection_orders TO service_role;
