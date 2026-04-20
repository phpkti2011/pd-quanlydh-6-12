-- Add CRM fields to customers table
ALTER TABLE customers ADD COLUMN IF NOT EXISTS tier TEXT DEFAULT 'Đồng';
ALTER TABLE customers ADD COLUMN IF NOT EXISTS tags TEXT[] DEFAULT '{}';
ALTER TABLE customers ADD COLUMN IF NOT EXISTS loyalty_points INT DEFAULT 0;

-- Create Customer Interaction Logs table
CREATE TABLE IF NOT EXISTS customer_logs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  customer_id UUID REFERENCES customers(id) ON DELETE CASCADE,
  type TEXT NOT NULL, -- 'Call', 'Visit', 'Note', 'Complaint'
  content TEXT,
  created_by UUID REFERENCES profiles(id), -- Nullable if system gen? Better keep references.
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS for logs
ALTER TABLE customer_logs ENABLE ROW LEVEL SECURITY;

-- Policy: Admin/Sales/Accountant can view all logs
DROP POLICY IF EXISTS "View customer logs" ON customer_logs;
CREATE POLICY "View customer logs" ON customer_logs
  FOR SELECT USING (
    get_current_user_role() IN ('Admin', 'NhanVienKinhDoanh', 'KeToan')
  );

-- Policy: Admin/Sales/Accountant can insert logs
DROP POLICY IF EXISTS "Insert customer logs" ON customer_logs;
CREATE POLICY "Insert customer logs" ON customer_logs
  FOR INSERT WITH CHECK (
    get_current_user_role() IN ('Admin', 'NhanVienKinhDoanh', 'KeToan')
  );
