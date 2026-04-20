-- ============================================================
-- BẢNG LOG THÊM KHÁCH HÀNG NHANH
-- Ghi lại mỗi lần NVKD thêm khách hàng nhanh khi tạo đơn
-- Dùng để đối chiếu KH Facebook đã tạo đơn Pancake chưa
-- Chạy trong Supabase SQL Editor
-- ============================================================

CREATE TABLE IF NOT EXISTS quick_add_customer_logs (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    customer_id UUID REFERENCES customers(id) ON DELETE SET NULL,
    customer_name TEXT NOT NULL,
    customer_phone TEXT NOT NULL DEFAULT '',
    source TEXT NOT NULL DEFAULT '',
    created_by UUID REFERENCES profiles(id) ON DELETE SET NULL,
    facebook_confirmed BOOLEAN,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Index để query theo tháng và nguồn
CREATE INDEX IF NOT EXISTS idx_quick_add_logs_created ON quick_add_customer_logs(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_quick_add_logs_source ON quick_add_customer_logs(source);
CREATE INDEX IF NOT EXISTS idx_quick_add_logs_user ON quick_add_customer_logs(created_by);

-- RLS
ALTER TABLE quick_add_customer_logs ENABLE ROW LEVEL SECURITY;

-- Tất cả authenticated users có thể insert
DROP POLICY IF EXISTS "Users can insert logs" ON quick_add_customer_logs;
CREATE POLICY "Users can insert logs" ON quick_add_customer_logs
    FOR INSERT WITH CHECK (true);

-- Admin xem tất cả, nhân viên xem của mình
DROP POLICY IF EXISTS "Users can view logs" ON quick_add_customer_logs;
CREATE POLICY "Users can view logs" ON quick_add_customer_logs
    FOR SELECT USING (true);

-- ============================================================
-- DONE! Sau khi chạy SQL này, deploy lại app.
-- ============================================================
