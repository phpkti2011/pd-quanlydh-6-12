-- ============================================================
-- SETUP NOTIFICATIONS V2
-- Hệ thống thông báo đầy đủ cho PD Order Manager
-- Chạy trong Supabase SQL Editor
-- ============================================================

-- 1. Đảm bảo bảng notifications tồn tại
CREATE TABLE IF NOT EXISTS notifications (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    message TEXT,
    type TEXT DEFAULT 'system',
    reference_id UUID,
    link TEXT,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Thêm columns nếu chưa có (idempotent)
DO $$ BEGIN
    ALTER TABLE notifications ADD COLUMN IF NOT EXISTS type TEXT DEFAULT 'system';
    ALTER TABLE notifications ADD COLUMN IF NOT EXISTS reference_id UUID;
    ALTER TABLE notifications ADD COLUMN IF NOT EXISTS link TEXT;
EXCEPTION WHEN OTHERS THEN NULL;
END $$;

-- 2. Index cho performance
CREATE INDEX IF NOT EXISTS idx_notifications_user_unread
ON notifications (user_id, is_read) WHERE is_read = false;

CREATE INDEX IF NOT EXISTS idx_notifications_user_created
ON notifications (user_id, created_at DESC);

-- 3. Enable RLS với policies đúng
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

-- Drop policies cũ nếu có
DROP POLICY IF EXISTS "Users can view own notifications" ON notifications;
DROP POLICY IF EXISTS "Users can update own notifications" ON notifications;
DROP POLICY IF EXISTS "Users can delete own notifications" ON notifications;
DROP POLICY IF EXISTS "System can insert notifications" ON notifications;

-- SELECT: chỉ xem notification của mình
CREATE POLICY "Users can view own notifications" ON notifications
    FOR SELECT USING (user_id = auth.uid());

-- UPDATE: chỉ sửa notification của mình (mark as read)
CREATE POLICY "Users can update own notifications" ON notifications
    FOR UPDATE USING (user_id = auth.uid());

-- DELETE: chỉ xóa notification của mình
CREATE POLICY "Users can delete own notifications" ON notifications
    FOR DELETE USING (user_id = auth.uid());

-- INSERT: cho phép tất cả insert (triggers chạy qua SECURITY DEFINER)
CREATE POLICY "System can insert notifications" ON notifications
    FOR INSERT WITH CHECK (true);

-- 4. Hàm tạo notification (SECURITY DEFINER để bypass RLS)
CREATE OR REPLACE FUNCTION create_notification(
    p_user_id UUID,
    p_title TEXT,
    p_message TEXT,
    p_type TEXT DEFAULT 'system',
    p_ref_id UUID DEFAULT NULL,
    p_link TEXT DEFAULT NULL
) RETURNS VOID AS $$
BEGIN
    INSERT INTO notifications (user_id, title, message, type, reference_id, link)
    VALUES (p_user_id, p_title, p_message, p_type, p_ref_id, p_link);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================
-- 5. TRIGGER FUNCTIONS
-- Khắc phục lỗi cũ: IS DISTINCT FROM, COALESCE, role::text
-- ============================================================

-- Drop triggers cũ
DROP TRIGGER IF EXISTS trigger_notify_new_order ON orders;
DROP TRIGGER IF EXISTS trigger_notify_status_change ON orders;
DROP TRIGGER IF EXISTS trigger_notify_payment_update ON orders;
DROP TRIGGER IF EXISTS trigger_notify_design_request ON orders;
DROP TRIGGER IF EXISTS trigger_notify_comment_added ON order_comments;

-- Drop old triggers (tên cũ)
DROP TRIGGER IF EXISTS check_payment_approval ON orders;
DROP TRIGGER IF EXISTS check_design_status ON orders;
DROP TRIGGER IF EXISTS check_production_start ON orders;
DROP TRIGGER IF EXISTS check_sales_completed ON orders;

-- Drop functions cũ
DROP FUNCTION IF EXISTS notify_new_order() CASCADE;
DROP FUNCTION IF EXISTS notify_status_change() CASCADE;
DROP FUNCTION IF EXISTS notify_payment_update() CASCADE;
DROP FUNCTION IF EXISTS notify_design_request() CASCADE;
DROP FUNCTION IF EXISTS notify_comment_added() CASCADE;
DROP FUNCTION IF EXISTS notify_payment_approval() CASCADE;
DROP FUNCTION IF EXISTS notify_design_status() CASCADE;
DROP FUNCTION IF EXISTS notify_production_start() CASCADE;
DROP FUNCTION IF EXISTS notify_sales_completed() CASCADE;

-- ----------------------------------------
-- 5a. Đơn hàng mới được tạo
-- ----------------------------------------
CREATE OR REPLACE FUNCTION notify_new_order()
RETURNS TRIGGER AS $$
DECLARE
    recipient_id UUID;
    v_order_code TEXT;
BEGIN
    v_order_code := COALESCE(NEW.order_code, 'N/A');

    -- Gửi cho Admin và QuanLySanXuat
    FOR recipient_id IN
        SELECT id FROM profiles
        WHERE role::text IN ('Admin', 'QuanLySanXuat')
        AND (is_locked IS NULL OR is_locked = false)
    LOOP
        PERFORM create_notification(
            recipient_id,
            'Đơn hàng mới',
            'Đơn hàng ' || v_order_code || ' vừa được tạo.',
            'order',
            NEW.id,
            NULL
        );
    END LOOP;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER trigger_notify_new_order
    AFTER INSERT ON orders
    FOR EACH ROW
    EXECUTE FUNCTION notify_new_order();

-- ----------------------------------------
-- 5b. Thay đổi trạng thái đơn hàng
-- ----------------------------------------
CREATE OR REPLACE FUNCTION notify_status_change()
RETURNS TRIGGER AS $$
DECLARE
    recipient_id UUID;
    v_order_code TEXT;
    v_status_label TEXT;
BEGIN
    -- Chỉ chạy khi status thực sự thay đổi
    IF NOT (OLD.status IS DISTINCT FROM NEW.status) THEN
        RETURN NEW;
    END IF;

    v_order_code := COALESCE(NEW.order_code, 'N/A');

    -- Map status sang label tiếng Việt
    v_status_label := CASE NEW.status::text
        WHEN 'Moi' THEN 'Mới'
        WHEN 'TiepNhan' THEN 'Tiếp nhận'
        WHEN 'NhanFile' THEN 'Nhận File'
        WHEN 'XuLyFile' THEN 'Xử lý File'
        WHEN 'BinhFile' THEN 'Bình File'
        WHEN 'In' THEN 'In'
        WHEN 'ThanhPham' THEN 'Thành Phẩm'
        WHEN 'DongGoi' THEN 'Đóng gói'
        WHEN 'ChoGiaoHang' THEN 'Chờ giao hàng'
        WHEN 'DaGiaoHang' THEN 'Đã giao hàng'
        WHEN 'HoanThanh' THEN 'Hoàn thành'
        WHEN 'Huy' THEN 'Hủy'
        WHEN 'TamNgung' THEN 'Tạm ngưng'
        ELSE NEW.status::text
    END;

    -- Gửi cho NVKD (sales_rep) nếu có
    IF NEW.sales_rep_id IS NOT NULL THEN
        PERFORM create_notification(
            NEW.sales_rep_id,
            'Cập nhật trạng thái',
            'Đơn hàng ' || v_order_code || ' chuyển sang: ' || v_status_label,
            'order',
            NEW.id,
            NULL
        );
    END IF;

    -- Gửi cho bộ phận sản xuất khi vào công đoạn sản xuất
    IF NEW.status::text IN ('BinhFile', 'In', 'ThanhPham', 'DongGoi') THEN
        FOR recipient_id IN
            SELECT id FROM profiles
            WHERE role::text IN ('NhanVienSanXuat', 'QuanLySanXuat', 'NhanVienBinhFile')
            AND (is_locked IS NULL OR is_locked = false)
            AND id IS DISTINCT FROM NEW.sales_rep_id
        LOOP
            PERFORM create_notification(
                recipient_id,
                'Cập nhật sản xuất',
                'Đơn hàng ' || v_order_code || ' chuyển sang: ' || v_status_label,
                'order',
                NEW.id,
                NULL
            );
        END LOOP;
    END IF;

    -- Gửi cho Admin + KeToan khi hoàn thành
    IF NEW.status::text = 'HoanThanh' THEN
        FOR recipient_id IN
            SELECT id FROM profiles
            WHERE role::text IN ('Admin', 'KeToan')
            AND (is_locked IS NULL OR is_locked = false)
            AND id IS DISTINCT FROM NEW.sales_rep_id
        LOOP
            PERFORM create_notification(
                recipient_id,
                'Đơn hàng hoàn thành',
                'Đơn hàng ' || v_order_code || ' đã hoàn thành.',
                'order',
                NEW.id,
                NULL
            );
        END LOOP;
    END IF;

    -- Gửi cho Admin + QuanLySanXuat khi hủy/tạm ngưng
    IF NEW.status::text IN ('Huy', 'TamNgung') THEN
        FOR recipient_id IN
            SELECT id FROM profiles
            WHERE role::text IN ('Admin', 'QuanLySanXuat')
            AND (is_locked IS NULL OR is_locked = false)
            AND id IS DISTINCT FROM NEW.sales_rep_id
        LOOP
            PERFORM create_notification(
                recipient_id,
                CASE WHEN NEW.status::text = 'Huy' THEN 'Đơn hàng bị hủy' ELSE 'Đơn hàng tạm ngưng' END,
                'Đơn hàng ' || v_order_code || ' đã ' || LOWER(v_status_label) || '.',
                'order',
                NEW.id,
                NULL
            );
        END LOOP;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER trigger_notify_status_change
    AFTER UPDATE ON orders
    FOR EACH ROW
    EXECUTE FUNCTION notify_status_change();

-- ----------------------------------------
-- 5c. Cập nhật thanh toán
-- ----------------------------------------
CREATE OR REPLACE FUNCTION notify_payment_update()
RETURNS TRIGGER AS $$
DECLARE
    recipient_id UUID;
    v_order_code TEXT;
    v_payment_label TEXT;
BEGIN
    -- Chỉ chạy khi payment_status thực sự thay đổi
    IF NOT (OLD.payment_status IS DISTINCT FROM NEW.payment_status) THEN
        RETURN NEW;
    END IF;

    v_order_code := COALESCE(NEW.order_code, 'N/A');

    v_payment_label := CASE NEW.payment_status::text
        WHEN 'ChuaThanhToan' THEN 'Chưa thanh toán'
        WHEN 'DaCoc' THEN 'Đã đặt cọc'
        WHEN 'DaThanhToan' THEN 'Đã thanh toán'
        WHEN 'CongNo' THEN 'Công nợ'
        ELSE NEW.payment_status::text
    END;

    -- Gửi cho NVKD
    IF NEW.sales_rep_id IS NOT NULL THEN
        PERFORM create_notification(
            NEW.sales_rep_id,
            'Cập nhật thanh toán',
            'Đơn hàng ' || v_order_code || ': ' || v_payment_label,
            'payment',
            NEW.id,
            NULL
        );
    END IF;

    -- Gửi cho Admin + KeToan
    FOR recipient_id IN
        SELECT id FROM profiles
        WHERE role::text IN ('Admin', 'KeToan')
        AND (is_locked IS NULL OR is_locked = false)
        AND id IS DISTINCT FROM NEW.sales_rep_id
    LOOP
        PERFORM create_notification(
            recipient_id,
            'Cập nhật thanh toán',
            'Đơn hàng ' || v_order_code || ': ' || v_payment_label,
            'payment',
            NEW.id,
            NULL
        );
    END LOOP;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER trigger_notify_payment_update
    AFTER UPDATE ON orders
    FOR EACH ROW
    EXECUTE FUNCTION notify_payment_update();

-- ----------------------------------------
-- 5d. Yêu cầu thiết kế
-- ----------------------------------------
CREATE OR REPLACE FUNCTION notify_design_request()
RETURNS TRIGGER AS $$
DECLARE
    recipient_id UUID;
    v_order_code TEXT;
BEGIN
    -- Chỉ chạy khi has_design thay đổi thành true hoặc design_status thay đổi
    IF NOT (
        (OLD.has_design IS DISTINCT FROM NEW.has_design AND NEW.has_design = true)
        OR (NEW.has_design = true AND OLD.design_status IS DISTINCT FROM NEW.design_status)
    ) THEN
        RETURN NEW;
    END IF;

    v_order_code := COALESCE(NEW.order_code, 'N/A');

    -- Gửi cho NhanVienThietKe
    FOR recipient_id IN
        SELECT id FROM profiles
        WHERE role::text = 'NhanVienThietKe'
        AND (is_locked IS NULL OR is_locked = false)
    LOOP
        PERFORM create_notification(
            recipient_id,
            'Yêu cầu thiết kế',
            'Đơn hàng ' || v_order_code || ' cần thiết kế.',
            'order',
            NEW.id,
            NULL
        );
    END LOOP;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER trigger_notify_design_request
    AFTER UPDATE ON orders
    FOR EACH ROW
    EXECUTE FUNCTION notify_design_request();

-- ----------------------------------------
-- 5e. Bình luận mới
-- ----------------------------------------
CREATE OR REPLACE FUNCTION notify_comment_added()
RETURNS TRIGGER AS $$
DECLARE
    v_order RECORD;
    v_commenter_name TEXT;
BEGIN
    -- Lấy thông tin đơn hàng
    SELECT id, order_code, sales_rep_id INTO v_order
    FROM orders WHERE id = NEW.order_id;

    IF v_order IS NULL THEN
        RETURN NEW;
    END IF;

    -- Lấy tên người comment
    SELECT COALESCE(full_name, email) INTO v_commenter_name
    FROM profiles WHERE id = NEW.user_id;

    -- Gửi cho sales_rep nếu không phải người comment
    IF v_order.sales_rep_id IS NOT NULL AND v_order.sales_rep_id IS DISTINCT FROM NEW.user_id THEN
        PERFORM create_notification(
            v_order.sales_rep_id,
            'Bình luận mới',
            COALESCE(v_commenter_name, 'Ai đó') || ' đã bình luận trên đơn ' || COALESCE(v_order.order_code, 'N/A'),
            'comment',
            v_order.id,
            NULL
        );
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER trigger_notify_comment_added
    AFTER INSERT ON order_comments
    FOR EACH ROW
    EXECUTE FUNCTION notify_comment_added();

-- ============================================================
-- 6. Enable Realtime cho bảng notifications
-- ============================================================
DO $$
BEGIN
    ALTER PUBLICATION supabase_realtime ADD TABLE notifications;
EXCEPTION
    WHEN duplicate_object THEN NULL;
END $$;

-- ============================================================
-- DONE! Verify:
-- SELECT tgname FROM pg_trigger WHERE tgrelid = 'orders'::regclass;
-- SELECT proname FROM pg_proc WHERE proname = 'create_notification';
-- ============================================================
