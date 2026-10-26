-- ==============================================================================
-- Cờ "Đang chờ khách duyệt mẫu" ở công đoạn In
-- Chạy tay trong Supabase Dashboard -> SQL Editor, TRƯỚC khi deploy frontend.
-- Chạy lại nhiều lần an toàn (IF NOT EXISTS).
--
-- Chỉ thêm cột vào bảng orders có sẵn nên không cần GRANT riêng (quyền bảng giữ nguyên).
-- Trigger chặn cột của nhóm sản xuất là danh sách chặn (description, total_amount,
-- customer_id...) nên cột mới nhân viên In vẫn cập nhật được. Nhật ký hoạt động
-- (audit_orders) tự ghi mọi thay đổi của 2 cột này.
-- ==============================================================================

ALTER TABLE orders
    ADD COLUMN IF NOT EXISTS awaiting_customer_approval BOOLEAN NOT NULL DEFAULT FALSE,
    ADD COLUMN IF NOT EXISTS awaiting_approval_at TIMESTAMPTZ,
    -- Thêm sau (tab "Đã duyệt mẫu"): phân biệt đơn ĐÃ duyệt với đơn chưa từng chờ duyệt.
    -- Chạy lại file này là đủ nếu bản đầu đã chạy rồi.
    ADD COLUMN IF NOT EXISTS sample_approved_at TIMESTAMPTZ;

COMMENT ON COLUMN orders.awaiting_customer_approval IS 'TRUE = đang chờ khách duyệt mẫu/test in (công đoạn In)';
COMMENT ON COLUMN orders.awaiting_approval_at IS 'Thời điểm bắt đầu chờ khách duyệt mẫu; NULL khi không chờ';
COMMENT ON COLUMN orders.sample_approved_at IS 'Thời điểm khách duyệt mẫu (bấm Đã duyệt); NULL = chưa duyệt hoặc đang chờ duyệt lại';

-- Reload PostgREST schema cache
NOTIFY pgrst, 'reload schema';
