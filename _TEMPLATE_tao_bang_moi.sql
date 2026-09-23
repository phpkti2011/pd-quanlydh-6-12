-- ============================================================================
-- MẪU TẠO BẢNG MỚI — sao chép file này mỗi khi cần CREATE TABLE
-- ============================================================================
-- VÌ SAO CÓ FILE NÀY
--   Từ 30/10/2026 Supabase KHÔNG còn tự cấp quyền Data API cho bảng mới trong
--   schema public. Tạo bảng mà thiếu khối GRANT bên dưới thì phần mềm báo
--   "permission denied" ngay khi gọi supabase.from('ten_bang').
--
--   Bảng đã tạo trước ngày đó giữ nguyên quyền, không phải làm gì. Trong 19
--   file SQL có CREATE TABLE của dự án, chỉ create_app_settings.sql có GRANT —
--   các file còn lại dựa vào cơ chế tự cấp quyền sắp bị tắt. Đừng sao chép
--   chúng làm mẫu.
--
-- THỨ TỰ BẮT BUỘC: CREATE TABLE -> GRANT -> RLS + POLICY -> NOTIFY
--
-- NGOẠI LỆ
--   Bảng CHỈ có trigger / hàm SECURITY DEFINER đọc ghi, client không bao giờ
--   gọi tới (vd production_tier_notify_state) thì KHÔNG cấp GRANT — cấp là
--   thừa quyền. Nhưng phải ghi rõ chủ ý bằng comment ngay dưới CREATE TABLE,
--   để người sau không tưởng là quên rồi bổ sung.
-- ============================================================================


-- ----------------------------------------------------------------------------
-- 1. Tạo bảng
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.ten_bang (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    -- ... các cột ...
    created_at  TIMESTAMPTZ DEFAULT NOW()
);


-- ----------------------------------------------------------------------------
-- 2. Cấp quyền Data API — BẮT BUỘC từ 30/10/2026
-- ----------------------------------------------------------------------------
-- authenticated : người dùng đã đăng nhập, gọi từ trình duyệt (supabase-js)
-- service_role  : các API serverless trên Vercel (api/*.ts) dùng service key
GRANT SELECT, INSERT, UPDATE, DELETE ON public.ten_bang TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.ten_bang TO service_role;

-- anon = chưa đăng nhập. Dự án này KHÔNG có bảng nào cần anon đọc thẳng:
-- trang tra cứu công khai đi qua RPC get_public_order_info, không đụng bảng.
-- Chỉ mở dòng dưới khi thật sự có trang công khai cần đọc bảng này.
-- GRANT SELECT ON public.ten_bang TO anon;


-- ----------------------------------------------------------------------------
-- 3. RLS — GRANT chỉ là quyền cấp bảng, vẫn phải giới hạn theo dòng
-- ----------------------------------------------------------------------------
-- Không bật RLS = mọi người đăng nhập đọc/sửa được mọi dòng.
-- Supabase SQL Editor cũng sẽ nhắc "creates a table without RLS" nếu thiếu.
ALTER TABLE public.ten_bang ENABLE ROW LEVEL SECURITY;

-- Ví dụ policy thường gặp trong dự án (chọn 1 hoặc viết riêng):

-- (a) Ai đăng nhập cũng đọc được, chỉ Admin ghi
-- CREATE POLICY "Authenticated read" ON public.ten_bang
--     FOR SELECT USING (auth.uid() IS NOT NULL);
-- CREATE POLICY "Admin write" ON public.ten_bang
--     FOR ALL USING (public.is_admin_safe());

-- (b) Mỗi người chỉ thấy dòng của mình (như bảng notifications)
-- CREATE POLICY "Own rows" ON public.ten_bang
--     FOR ALL USING (user_id = auth.uid());

-- (c) Bảng nội bộ, chỉ SECURITY DEFINER dùng: bật RLS và KHÔNG tạo policy nào
--     -> client bị chặn hoàn toàn, hàm SECURITY DEFINER vẫn chạy bình thường.


-- ----------------------------------------------------------------------------
-- 4. Báo PostgREST nạp lại schema để bảng mới xuất hiện ngay
-- ----------------------------------------------------------------------------
NOTIFY pgrst, 'reload schema';


-- ============================================================================
-- KIỂM TRA SAU KHI CHẠY
-- ============================================================================
-- Quyền đã vào chưa:
--   SELECT grantee, privilege_type
--   FROM information_schema.role_table_grants
--   WHERE table_schema = 'public' AND table_name = 'ten_bang'
--   ORDER BY grantee;
--   -> phải thấy authenticated và service_role
--
-- Gọi thử từ phần mềm: supabase.from('ten_bang').select('*').limit(1)
--   -> không được ra "permission denied"
-- ============================================================================
