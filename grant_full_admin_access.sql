
-- 1. PROFILES
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Admin full access profiles" ON profiles;
CREATE POLICY "Admin full access profiles" ON profiles
    FOR ALL
    USING (get_current_user_role() = 'Admin')
    WITH CHECK (get_current_user_role() = 'Admin');

-- 2. CUSTOMERS
ALTER TABLE customers ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Admin full access customers" ON customers;
CREATE POLICY "Admin full access customers" ON customers
    FOR ALL
    USING (get_current_user_role() = 'Admin')
    WITH CHECK (get_current_user_role() = 'Admin');

-- 3. ORDERS
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Admin full access orders" ON orders;
CREATE POLICY "Admin full access orders" ON orders
    FOR ALL
    USING (get_current_user_role() = 'Admin')
    WITH CHECK (get_current_user_role() = 'Admin');

-- 4. COMMISSION POLICIES
ALTER TABLE commission_policies ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Admin full access commission_policies" ON commission_policies;
CREATE POLICY "Admin full access commission_policies" ON commission_policies
    FOR ALL
    USING (get_current_user_role() = 'Admin')
    WITH CHECK (get_current_user_role() = 'Admin');

-- 5. CUSTOMER LOGS
-- (Assuming table exists, if not this might fail, but usually ok in idempotent scripts)
CREATE TABLE IF NOT EXISTS customer_logs (id UUID PRIMARY KEY DEFAULT uuid_generate_v4()); -- Stub ensure exists
ALTER TABLE customer_logs ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Admin full access customer_logs" ON customer_logs;
CREATE POLICY "Admin full access customer_logs" ON customer_logs
    FOR ALL
    USING (get_current_user_role() = 'Admin')
    WITH CHECK (get_current_user_role() = 'Admin');

-- 6. SALES TARGETS
-- (Assuming table exists)
CREATE TABLE IF NOT EXISTS sales_targets (id UUID PRIMARY KEY DEFAULT uuid_generate_v4()); -- Stub ensure exists
ALTER TABLE sales_targets ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Admin full access sales_targets" ON sales_targets;
CREATE POLICY "Admin full access sales_targets" ON sales_targets
    FOR ALL
    USING (get_current_user_role() = 'Admin')
    WITH CHECK (get_current_user_role() = 'Admin');

-- 7. ORDER PROCESS PARTICIPANTS
ALTER TABLE order_process_participants ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Admin full access order_process_participants" ON order_process_participants;
CREATE POLICY "Admin full access order_process_participants" ON order_process_participants
    FOR ALL
    USING (get_current_user_role() = 'Admin')
    WITH CHECK (get_current_user_role() = 'Admin');

-- 8. AUDIT LOGS
ALTER TABLE audit_logs ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Admin full access audit_logs" ON audit_logs;
CREATE POLICY "Admin full access audit_logs" ON audit_logs
    FOR ALL
    USING (get_current_user_role() = 'Admin')
    WITH CHECK (get_current_user_role() = 'Admin');

-- 9. ENSURE ENUMS (Just in case)
ALTER TYPE user_role ADD VALUE IF NOT EXISTS 'QuanLySanXuat';
ALTER TYPE user_role ADD VALUE IF NOT EXISTS 'NhanVienBinhFile';
ALTER TYPE user_role ADD VALUE IF NOT EXISTS 'NhanVienThietKe';
