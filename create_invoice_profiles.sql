-- Create Customer Invoice Profiles table
-- Stores multiple invoice (tax) profiles for a single customer

CREATE TABLE IF NOT EXISTS customer_invoice_profiles (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  customer_id UUID NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
  company_name TEXT NOT NULL,
  tax_code TEXT NOT NULL, -- MST
  address TEXT,
  email TEXT,
  is_default BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE customer_invoice_profiles ENABLE ROW LEVEL SECURITY;

-- Policies
-- Admin/Sales/Accountant can view all profiles
DROP POLICY IF EXISTS "View invoice profiles" ON customer_invoice_profiles;
CREATE POLICY "View invoice profiles" ON customer_invoice_profiles
  FOR SELECT USING (
    get_current_user_role() IN ('Admin', 'NhanVienKinhDoanh', 'KeToan', 'NhanVienSanXuat', 'QuanLySanXuat')
  );

-- Admin/Sales/Accountant can insert/update/delete
DROP POLICY IF EXISTS "Manage invoice profiles" ON customer_invoice_profiles;
CREATE POLICY "Manage invoice profiles" ON customer_invoice_profiles
  FOR ALL USING (
    get_current_user_role() IN ('Admin', 'NhanVienKinhDoanh', 'KeToan')
  );
