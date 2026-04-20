# Hướng dẫn Cài đặt & Triển khai Vercel (Từ A-Z)

Tài liệu này hướng dẫn bạn đăng ký tài khoản và đưa web lên mạng (deploy) từ con số 0.

## Phần 1: Đăng ký Tài khoản Vercel
1. Truy cập trang đăng ký: [https://vercel.com/signup](https://vercel.com/signup)
2. Chọn **"Hobby"** (Gói miễn phí cho cá nhân).
3. Nhập tên bạn -> **Continue**.
4. Chọn phương thức đăng ký:
   - Khuyên dùng: **Continue with GitHub** (nếu bạn có GitHub).
   - Hoặc **Continue with Email** (nếu chỉ muốn dùng Email).
5. Xác thực số điện thoại (Vercel yêu cầu xác minh danh tính thật).

---

## Phần 2: Đưa Website lên mạng

### Bước 1: Khởi tạo Project (Tại máy tính của bạn)
Mở Terminal của dự án (nơi bạn đang gõ lệnh `npm run dev`), chạy lệnh sau:

```bash
npx vercel login
```
*Lệnh này dùng để đăng nhập máy tính của bạn vào tài khoản Vercel vừa tạo.*
- Chọn phương thức đăng nhập giống lúc đăng ký (GitHub hoặc Email).
- Trình duyệt sẽ hiện ra xác nhận -> Bấm **Verify**.

### Bước 2: Deploy lần đầu (Tạo dự án)
Sau khi đăng nhập xong, chạy lệnh:

```bash
npx vercel
```

Hệ thống sẽ hỏi, bạn chọn như sau (Dùng mũi tên và Enter):
1. **Set up and deploy?**: `y` (Yes)
2. **Which scope?**: Chọn tên tài khoản của bạn.
3. **Link to existing project?**: `n` (No)
4. **Project name?**: Đặt tên ngắn gọn (ví dụ: `quan-ly-don-hang`).
5. **In which directory?**: Enter (Để mặc định `./`).
6. **Want to modify these settings?**: `n` (No).

=> Đợi khoảng 1-2 phút, Vercel sẽ build xong.
*Lưu ý: Lúc này vào web có thể bị lỗi trắng trang do thiếu kết nối Database, đừng lo, làm tiếp Bước 3.*

### Bước 3: Cấu hình Kết nối (Environment Variables)
Để web kết nối được với dữ liệu Supabase, bạn cần "nạp" thông tin cấu hình lên Vercel.

1. Vào [Dashboard Vercel](https://vercel.com/dashboard).
2. Bấm vào dự án bạn vừa tạo (`quan-ly-don-hang`).
3. Chọn tab **Settings** (trên cùng) -> chọn menu trái **Environment Variables**.
4. Thêm 2 biến sau (Lấy giá trị từ file `.env` trong máy tính của bạn):
   
   | Key (Tên biến) | Value (Giá trị) |
   | :--- | :--- |
   | `VITE_SUPABASE_URL` | *Copy link Supabase của bạn (https://...)* |
   | `VITE_SUPABASE_ANON_KEY` | *Copy key Anon dài loằng ngoằng* |....................................................................................................................................................................................................

   *(Mỗi lần nhập xong 1 dòng thì ấn Save).*

### Bước 4: Cập nhật bản chính thức (Production)
Sau khi lưu xong biến môi trường, bạn cần deploy lại để web nhận cấu hình mới.
Tại Terminal, chạy lệnh:

```bash
npx vercel --prod
```
- Cứ ấn Enter nếu được hỏi.

Sau khi chạy xong, Terminal sẽ hiện 1 đường link (dạng `https://quan-ly-don-hang.vercel.app`).
**Đó là trang web chính thức của bạn!** Gửi link này cho mọi người sử dụng.
