-- Add invoice_info and invoice_status columns to orders table
ALTER TABLE orders 
ADD COLUMN IF NOT EXISTS invoice_info TEXT,
ADD COLUMN IF NOT EXISTS invoice_status TEXT DEFAULT 'Pending';

-- Optional: Add a check constraint to ensure valid status values
ALTER TABLE orders 
DROP CONSTRAINT IF EXISTS orders_invoice_status_check;

ALTER TABLE orders 
ADD CONSTRAINT orders_invoice_status_check 
CHECK (invoice_status IN ('Pending', 'Issued'));
