-- Add payment_random_code column to orders table
ALTER TABLE orders 
ADD COLUMN IF NOT EXISTS payment_random_code TEXT;

-- Create index for faster lookup if needed (optional but good practice)
CREATE INDEX IF NOT EXISTS idx_orders_payment_random_code ON orders(payment_random_code);
