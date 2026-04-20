DROP FUNCTION IF EXISTS get_debt_orders();

CREATE OR REPLACE FUNCTION get_debt_orders()
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
LANGUAGE sql
SECURITY DEFINER
AS $$
  SELECT 
    o.id,
    o.order_code,
    o.customer_id,
    c.name as customer_name,
    o.sales_rep_id,
    u.full_name as sales_rep_name,
    o.total_amount,
    COALESCE(o.deposit_amount, 0) as deposit_amount,
    CASE 
        WHEN o.payment_status = 'CongNo' THEN o.total_amount
        ELSE COALESCE(o.remaining_amount, o.total_amount - COALESCE(o.deposit_amount, 0))
    END as remaining_amount,
    o.payment_status,
    o.payment_confirmed,
    o.created_at
  FROM orders o
  LEFT JOIN customers c ON o.customer_id = c.id
  LEFT JOIN profiles u ON o.sales_rep_id = u.id
  WHERE 
    -- Include 'CongNo' regardless of confirmation
    o.payment_status = 'CongNo'
    OR 
    -- Include 'DaCoc' only if explicit remaining debt exists and is positive
    (o.payment_status = 'DaCoc' AND (o.remaining_amount > 0 OR (o.total_amount - COALESCE(o.deposit_amount,0)) > 0))
  ORDER BY o.created_at DESC;
$$;
