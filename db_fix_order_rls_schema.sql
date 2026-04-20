-- Add missing columns for finishing options if they don't exist
ALTER TABLE orders ADD COLUMN IF NOT EXISTS has_be_demi BOOLEAN DEFAULT FALSE;
ALTER TABLE orders ADD COLUMN IF NOT EXISTS be_demi_fee NUMERIC DEFAULT 0;
ALTER TABLE orders ADD COLUMN IF NOT EXISTS has_ep_kim BOOLEAN DEFAULT FALSE;
ALTER TABLE orders ADD COLUMN IF NOT EXISTS ep_kim_fee NUMERIC DEFAULT 0;

-- Ensure outsource_note exists (checked previously, but safety first)
ALTER TABLE orders ADD COLUMN IF NOT EXISTS outsource_note TEXT;

-- =========================================================
-- FIX RLS FOR ORDERS
-- =========================================================

-- Enable RLS (Should be already enabled, but safe to re-run)
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;

-- 1. INSERT Policy
-- Admin, Sales, Accountant can create orders
DROP POLICY IF EXISTS "Insert orders" ON orders;
CREATE POLICY "Insert orders" ON orders
  FOR INSERT WITH CHECK (
    get_current_user_role() IN ('Admin', 'NhanVienKinhDoanh', 'KeToan')
  );

-- 2. UPDATE Policy
-- Admin, Accountant can update everything
-- Sales can update their own orders (or all? usually all for collaboration, let's stick to Sales can update)
-- Production can update status (usually handled by specific RPC or if they have update rights)
-- For now, allow Admin/Sales/KeToan full update on orders.
DROP POLICY IF EXISTS "Update orders" ON orders;
CREATE POLICY "Update orders" ON orders
  FOR UPDATE USING (
    get_current_user_role() IN ('Admin', 'NhanVienKinhDoanh', 'KeToan')
  );

-- 3. DELETE Policy (Optional, maybe only Admin)
DROP POLICY IF EXISTS "Delete orders" ON orders;
CREATE POLICY "Delete orders" ON orders
  FOR DELETE USING (
    get_current_user_role() = 'Admin'
  );
