-- ==============================================================================
-- Khôi phục ghi chú NVKD của đơn 26PD2310.0681 (bị ghi đè khi Bình file ghi chú thêm).
-- Chạy tay trong Supabase Dashboard -> SQL Editor. Chạy lại nhiều lần an toàn.
-- Nội dung lấy từ Lịch sử HĐ (dòng "Tạo đơn hàng" 15:02:07 23/10/2026).
-- Chỉ ảnh hưởng đúng 1 đơn; không tạo bảng nên không cần GRANT.
-- ==============================================================================

UPDATE orders
SET notes = 'GỬI LAYOUT SỐ NHẢY KH CHECK/ IN MẪU CHỤP KH XEM GIAO NGÀY 24.10'
WHERE order_code = '26PD2310.0681';
