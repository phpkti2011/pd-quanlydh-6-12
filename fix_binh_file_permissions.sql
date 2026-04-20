-- ===========================================
-- FIX: NhanVienBinhFile Permissions
-- Date: 2026-01-28
-- ===========================================
-- Issue: Production staff (specifically NhanVienBinhFile) cannot update order status.
-- Root Cause: RLS Policy "Update orders" might be too restrictive or Permission Trigger blocking.
-- Fix: Clearly update RLS to allow Production roles to update Active orders.
-- ===========================================

-- 1. Helper Function (ensure it exists)
CREATE OR REPLACE FUNCTION public.get_my_role() RETURNS text LANGUAGE sql SECURITY DEFINER SET search_path = public AS $$
  SELECT role::text FROM profiles WHERE id = auth.uid();
$$;

-- 2. UPDATE ORDERS RLS POLICY
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Update orders" ON orders;

CREATE POLICY "Update orders" ON orders FOR UPDATE USING (
    -- Admin/Sales/Accountant/Director can update anything
    public.get_my_role() IN ('Admin', 'NhanVienKinhDoanh', 'KeToan', 'GiamDoc')
    OR
    -- Sales Rep can update their own orders
    auth.uid() = sales_rep_id
    OR
    -- Production Roles can update ACTIVE orders (Not New/Cancelled)
    (
        status::text NOT IN ('Moi', 'Huy')
        AND public.get_my_role() IN ('NhanVienSanXuat', 'QuanLySanXuat', 'NhanVienThietKe', 'NhanVienBinhFile', 'NhanVienIn', 'NhanVienGiaCong')
    )
);

-- 3. UPDATE PERMISSION CHECK TRIGGER (Allow Status Updates)
CREATE OR REPLACE FUNCTION check_order_permissions() RETURNS TRIGGER AS $$
DECLARE
    v_role text;
BEGIN
    v_role := public.get_my_role();
    
    -- Full Access Roles
    IF v_role IN ('Admin', 'NhanVienKinhDoanh', 'KeToan', 'GiamDoc') THEN 
        RETURN NEW;
    END IF;

    -- Production Roles: RESTRICTED COLUMNS ONLY
    -- They ARE ALLOWED to update 'status', 'design_status', etc.
    -- They are ONLY BLOCKED from changing Financials & Customer Info.
    IF v_role IN ('NhanVienSanXuat', 'QuanLySanXuat', 'NhanVienThietKe', 'NhanVienBinhFile', 'NhanVienIn', 'NhanVienGiaCong') THEN
        
        -- Prevent editing Descriptions (Quy cách)
        IF NEW.description IS DISTINCT FROM OLD.description THEN 
            RAISE EXCEPTION 'Bạn không có quyền chỉnh sửa Quy cách đơn hàng. Vui lòng liên hệ NVKD.'; 
        END IF;

        -- Prevent editing Financials
        IF NEW.total_amount IS DISTINCT FROM OLD.total_amount OR 
           NEW.total_amount_pre_vat IS DISTINCT FROM OLD.total_amount_pre_vat THEN 
            RAISE EXCEPTION 'Bạn không có quyền chỉnh sửa Giá tiền.'; 
        END IF;

        -- Prevent editing Customer
        IF NEW.customer_id IS DISTINCT FROM OLD.customer_id THEN 
            RAISE EXCEPTION 'Bạn không có quyền đổi Khách hàng.'; 
        END IF;

        -- ALLOW everything else (Status, Notes, Sub-tasks)
        RETURN NEW;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Rebind Trigger (Safety)
DROP TRIGGER IF EXISTS check_permissions_trigger ON orders;
CREATE TRIGGER check_permissions_trigger BEFORE UPDATE ON orders FOR EACH ROW EXECUTE FUNCTION check_order_permissions();

-- 4. VERIFY
SELECT 'SUCCESS: Permissions updated for NhanVienBinhFile and Production team.' AS result;
