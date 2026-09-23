# Hướng dẫn cho AI làm việc trong repo này

Đọc hết trước khi sửa bất cứ thứ gì. Mỗi quy tắc dưới đây đều đúc từ một lỗi đã xảy ra thật.

## CSDL: Supabase, SQL chạy tay

- **Không dùng migrations.** Mọi file `*.sql` ở thư mục gốc được **chạy tay** trong Supabase Dashboard → SQL Editor. Code không tự chạy chúng.
- Mỗi lần sửa SQL phải nói rõ với người dùng **file nào cần chạy, theo thứ tự nào**, và phần frontend phụ thuộc vào nó **chỉ được deploy sau khi SQL đã chạy**.

## BẮT BUỘC: bảng mới phải có GRANT (Supabase từ 30/10/2026)

Từ 30/10/2026 Supabase **không tự cấp quyền Data API** cho bảng mới trong schema `public`. Tạo bảng thiếu GRANT → phần mềm báo `permission denied` ngay khi gọi `supabase.from('ten_bang')`.

- **Mọi `CREATE TABLE` phải theo mẫu `_TEMPLATE_tao_bang_moi.sql`**: CREATE → GRANT → RLS + policy → `NOTIFY pgrst`.
- Cấp `SELECT, INSERT, UPDATE, DELETE` cho **`authenticated`** và **`service_role`**.
- **Không cấp `anon`.** Dự án không có chỗ nào chưa đăng nhập đọc thẳng bảng (trang tra cứu công khai đi qua RPC).
- Ngoại lệ duy nhất: bảng **chỉ trigger / hàm `SECURITY DEFINER`** đọc ghi (vd `production_tier_notify_state`) thì không GRANT — nhưng **phải** ghi comment `-- CỐ Ý KHÔNG GRANT: <lý do>` ngay dưới `CREATE TABLE`.
- 18/19 file SQL cũ có `CREATE TABLE` **không có GRANT** vì tạo trước ngày đó. **Đừng sao chép chúng làm mẫu.** Bảng của chúng đã có quyền, không cần sửa lại.
- Hook trong `.claude/settings.json` tự chạy `scripts/check_sql_grants.mjs` sau mỗi lần ghi file `.sql` và **chặn** nếu thiếu GRANT. Thấy cảnh báo thì sửa, không bỏ qua.

## Bẫy tái phát: file SQL mới đè lên hàm đúng

Repo có nhiều file `fix_*.sql` cùng định nghĩa một hàm. Ai chạy file mới hơn là hàm bị ghi đè. Đã xảy ra 3 lần (`admin_delete_user`, `get_staff_commission_rows`, `get_production_tier_rate`).

- Khi sửa một hàm: **sửa cả file gốc đang định nghĩa nó**, không chỉ tạo file `fix_` mới.
- **Không giữ 2 bản logic song song** (SQL và TypeScript) cho cùng một việc.

## File SQL KHÔNG được chạy lại

- `db_schema.sql`, `db_commission.sql` — có `DROP TABLE ... CASCADE`, **xoá sạch dữ liệu**.
- `setup_production_commission_tiers.sql` — dòng 12 xoá mốc thưởng sản xuất của **mọi tháng**.
- `fix_stage_rate_lookup.sql`, `disable_notification_triggers.sql` — bản cũ, chạy sẽ làm mất tính năng mới hơn.

## Sau khi sửa xong

- Deploy chạy từ GitHub (`origin/master` → Vercel). **Chưa commit + push thì bản deploy không có gì.** Mỗi khi để việc treo chưa commit, phải nói rõ điều này với người dùng.
- Push ngay sau khi commit.
