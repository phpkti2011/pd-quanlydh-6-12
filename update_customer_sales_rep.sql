-- Add sales_rep_id to customers table to track ownership
ALTER TABLE customers 
ADD COLUMN IF NOT EXISTS sales_rep_id UUID REFERENCES profiles(id);

-- Optional: Index for filtering "My Customers"
CREATE INDEX IF NOT EXISTS idx_customers_sales_rep_id ON customers(sales_rep_id);

COMMENT ON COLUMN customers.sales_rep_id IS 'User ID of the Sales Rep who owns/created this customer';
