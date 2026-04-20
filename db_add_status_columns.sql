-- Add status columns for sub-tasks to track progress (Pending/Completed)
-- These columns are needed for the Status Tabs counters

ALTER TABLE orders 
ADD COLUMN IF NOT EXISTS design_status TEXT DEFAULT 'Pending',
ADD COLUMN IF NOT EXISTS large_print_status TEXT DEFAULT 'Pending',
ADD COLUMN IF NOT EXISTS be_demi_status TEXT DEFAULT 'Pending',
ADD COLUMN IF NOT EXISTS outsource_status TEXT DEFAULT 'Pending',
ADD COLUMN IF NOT EXISTS ep_kim_status TEXT DEFAULT 'Pending',
ADD COLUMN IF NOT EXISTS invoice_status TEXT DEFAULT 'Pending';

-- Create index for faster counting
CREATE INDEX IF NOT EXISTS idx_orders_design_status ON orders(design_status);
CREATE INDEX IF NOT EXISTS idx_orders_invoice_status ON orders(invoice_status);
