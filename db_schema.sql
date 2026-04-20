-- Clean up previous schema if exists (Optional - helpful for fresh start)
DROP TABLE IF EXISTS audit_logs CASCADE;
DROP TABLE IF EXISTS order_process_participants CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS customers CASCADE;
DROP TABLE IF EXISTS commission_policies CASCADE;
DROP TABLE IF EXISTS profiles CASCADE;
DROP TYPE IF EXISTS payment_status;
DROP TYPE IF EXISTS order_status;
DROP FUNCTION IF EXISTS get_current_user_role() CASCADE;
DROP TYPE IF EXISTS user_role;

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ENUMS
CREATE TYPE user_role AS ENUM ('Admin', 'NhanVienKinhDoanh', 'NhanVienSanXuat', 'KeToan', 'Khach');
CREATE TYPE order_status AS ENUM ('Moi', 'TiepNhan', 'NhanFile', 'XuLyFile', 'BinhFile', 'In', 'ThanhPham', 'DongGoi', 'ChoGiaoHang', 'GiaoHang', 'HoanThanh', 'Huy', 'TamNgung', 'DaGiaoHang');
CREATE TYPE payment_status AS ENUM ('ChuaThanhToan', 'DaCoc', 'DaThanhToan', 'CongNo');

-- PROFILES (Extends auth.users)
CREATE TABLE profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT UNIQUE NOT NULL,
  full_name TEXT,
  role user_role DEFAULT 'Khach',
  phone_number TEXT,
  base_salary_config JSONB DEFAULT '{}'::jsonb, -- Stores salary config like KPI targets
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- CUSTOMERS
CREATE TABLE customers (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  code TEXT UNIQUE NOT NULL, -- e.g., KH240001
  name TEXT NOT NULL,
  phone TEXT,
  email TEXT,
  address TEXT,
  source TEXT,
  crm_notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- COMMISSION POLICIES (Dynamic Config)
CREATE TABLE commission_policies (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  policy_name TEXT NOT NULL,
  role_type TEXT NOT NULL, -- 'SALES' or 'STAFF'
  config_data JSONB NOT NULL, -- Flexible structure for different policy types
  effective_from TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  effective_to TIMESTAMPTZ, -- NULL means currently active
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ORDERS
CREATE TABLE orders (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  order_code TEXT UNIQUE NOT NULL, -- e.g., 25PD1206.0001
  customer_id UUID REFERENCES customers(id),
  sales_rep_id UUID REFERENCES profiles(id),
  
  -- Order Details
  description TEXT, -- Quy cach
  notes TEXT,
  
  -- Design & Specs
  has_design BOOLEAN DEFAULT FALSE,
  design_fee NUMERIC DEFAULT 0,
  has_large_print BOOLEAN DEFAULT FALSE,
  large_print_fee NUMERIC DEFAULT 0,
  outsource_note TEXT, -- Ghi chu gia cong ngoai
  
  -- Finishing Options (Added)
  has_be_demi BOOLEAN DEFAULT FALSE,
  be_demi_fee NUMERIC DEFAULT 0,
  has_ep_kim BOOLEAN DEFAULT FALSE,
  ep_kim_fee NUMERIC DEFAULT 0,
  
  -- Financials
  total_amount_pre_vat NUMERIC DEFAULT 0,
  vat_rate NUMERIC DEFAULT 0,
  vat_amount NUMERIC DEFAULT 0,
  total_amount NUMERIC DEFAULT 0,
  deposit_amount NUMERIC DEFAULT 0,
  remaining_amount NUMERIC DEFAULT 0,
  
  -- Status
  status order_status DEFAULT 'Moi',
  payment_status payment_status DEFAULT 'ChuaThanhToan',
  is_urgent BOOLEAN DEFAULT FALSE,
  delivery_date TIMESTAMPTZ,
  
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ORDER PROCESS PARTICIPANTS (Normalization of *_PARTICIPANTS_DATA)
CREATE TABLE order_process_participants (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  order_id UUID REFERENCES orders(id) ON DELETE CASCADE,
  user_id UUID REFERENCES profiles(id),
  
  stage TEXT NOT NULL, -- 'ThietKe', 'BinhFile', 'In', 'ThanhPham', etc.
  
  started_at TIMESTAMPTZ DEFAULT NOW(),
  completed_at TIMESTAMPTZ,
  
  -- Snapshot of specific metrics at the time of work (for Commission calc)
  contribution_weight NUMERIC DEFAULT 1.0, 
  
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- AUDIT LOGS
CREATE TABLE audit_logs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  table_name TEXT NOT NULL,
  record_id UUID NOT NULL,
  action TEXT NOT NULL, -- 'INSERT', 'UPDATE', 'DELETE'
  old_data JSONB,
  new_data JSONB,
  performed_by UUID REFERENCES profiles(id),
  performed_at TIMESTAMPTZ DEFAULT NOW()
);

-- RLS POLICIES --------------------------------------------------------

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE customers ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE commission_policies ENABLE ROW LEVEL SECURITY;

-- Helper function to get current user role safely (bypassing RLS)
CREATE OR REPLACE FUNCTION get_current_user_role()
RETURNS user_role
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT role FROM profiles WHERE id = auth.uid();
$$;

-- Profiles: Users can view their own profile. Admin/KeToan can view all.
CREATE POLICY "View own profile" ON profiles 
  FOR SELECT USING (
    auth.uid() = id OR 
    get_current_user_role() IN ('Admin', 'KeToan')
  );

-- Orders: 
-- 1. Sales Reps see their own orders.
-- 2. Production staff see orders that are NOT in 'Moi' or 'Huy' status (active orders).
-- 3. Admin/KeToan see all.
CREATE POLICY "Sales see own orders" ON orders
  FOR SELECT USING (
    auth.uid() = sales_rep_id OR 
    get_current_user_role() IN ('Admin', 'KeToan')
  );

CREATE POLICY "Production see active orders" ON orders
  FOR SELECT USING (
    (status NOT IN ('Moi', 'Huy') AND get_current_user_role() = 'NhanVienSanXuat')
  );

CREATE POLICY "Insert orders" ON orders
  FOR INSERT WITH CHECK (
    get_current_user_role() IN ('Admin', 'NhanVienKinhDoanh', 'KeToan')
  );

CREATE POLICY "Update orders" ON orders
  FOR UPDATE USING (
    get_current_user_role() IN ('Admin', 'NhanVienKinhDoanh', 'KeToan')
  );

CREATE POLICY "Delete orders" ON orders
  FOR DELETE USING (
    get_current_user_role() = 'Admin'
  );

-- Customers: viewable by Sales/Admin/KeToan
CREATE POLICY "View customers" ON customers
  FOR SELECT USING (
    get_current_user_role() IN ('Admin', 'NhanVienKinhDoanh', 'KeToan')
  );

CREATE POLICY "Insert customers" ON customers
  FOR INSERT WITH CHECK (
    get_current_user_role() IN ('Admin', 'NhanVienKinhDoanh', 'KeToan')
  );

CREATE POLICY "Update customers" ON customers
  FOR UPDATE USING (
    get_current_user_role() IN ('Admin', 'NhanVienKinhDoanh', 'KeToan')
  );

-- FUNCTIONS (Stubs) ---------------------------------------------------

-- Function to update timestamp on modification
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_profiles_modtime BEFORE UPDATE ON profiles FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();
CREATE TRIGGER update_customers_modtime BEFORE UPDATE ON customers FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();
CREATE TRIGGER update_orders_modtime BEFORE UPDATE ON orders FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();
