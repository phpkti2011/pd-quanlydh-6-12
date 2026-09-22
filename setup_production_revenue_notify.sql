-- ============================================================================
-- Thông báo doanh số cho nhân viên sản xuất
-- ============================================================================
-- VÌ SAO
--   Trước đây chỉ có 1 thông báo doanh số: cron 7h sáng T2-T6
--   (vercel.json -> api/morning-commission.ts). Giữa 2 lần đó nhân viên không
--   biết doanh số đang ở đâu so với mốc thưởng.
--
--   Hai lúc quan trọng nhất lại không có thông báo:
--     - Admin sửa mốc thưởng  -> hệ số cả tháng đổi, không ai hay
--     - Doanh số vượt mốc     -> hệ số nhảy 40% -> 70%, cả xưởng đáng được biết
--
-- FILE NÀY GỒM
--   1. build_production_revenue_message()  - dựng nội dung (BẢN DUY NHẤT)
--   2. notify_production_revenue()         - gửi cho nhân viên sản xuất
--   3. production_tier_notify_state + trigger - tự báo khi doanh số vượt mốc
--
-- MỘT BẢN DUY NHẤT
--   Nội dung tin nhắn TRƯỚC ĐÂY viết bằng TypeScript trong
--   api/morning-commission.ts (hàm buildNotificationMessage). Nay chuyển hẳn
--   vào SQL và cron gọi vào đây. Để 2 bản song song chính là cách đẻ ra loại
--   lỗi đã phải đi vá 3 lần (admin_delete_user, get_staff_commission_rows,
--   get_production_tier_rate) — bản mới hơn âm thầm ghi đè bản đúng.
--
-- Chạy lại nhiều lần được, không hỏng gì.
-- ============================================================================


-- ----------------------------------------------------------------------------
-- 0. Định dạng tiền giống hệt formatMoney() của bản TS
-- ----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fmt_money_vn(p_amount NUMERIC)
RETURNS TEXT AS $$
BEGIN
    IF p_amount IS NULL THEN RETURN '0đ'; END IF;
    IF p_amount >= 1000000 THEN
        RETURN ROUND(p_amount / 1000000) || ' triệu';
    END IF;
    RETURN to_char(p_amount, 'FM999G999G999') || 'đ';
END;
$$ LANGUAGE plpgsql IMMUTABLE;


-- ----------------------------------------------------------------------------
-- 1. Dựng nội dung thông báo
--    p_headline: câu mở đầu tuỳ ngữ cảnh. NULL = đúng nội dung bản 7h sáng.
-- ----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION build_production_revenue_message(
    p_month    INT,
    p_year     INT,
    p_headline TEXT DEFAULT NULL
)
RETURNS TEXT AS $$
DECLARE
    v_sum       RECORD;
    v_msg       TEXT := '';
    v_remaining NUMERIC;
    v_tier      RECORD;
    v_active_min NUMERIC;
    v_next_min  NUMERIC;
    v_range     TEXT;
BEGIN
    SELECT * INTO v_sum
    FROM get_production_commission_summary(p_month, p_year);

    IF v_sum IS NULL THEN
        RETURN NULL;
    END IF;

    IF p_headline IS NOT NULL AND p_headline <> '' THEN
        v_msg := p_headline || E'\n\n';
    END IF;

    v_msg := v_msg || 'Doanh số đơn hoàn thành trong tháng ' || p_month || '/' || p_year
                   || ': ' || fmt_money_vn(v_sum.total_revenue) || ' (chưa VAT).';

    v_msg := v_msg || E'\n\nMốc thưởng hiện tại: ' || v_sum.current_tier_pct
                   || '% thưởng hoa hồng sản xuất.';

    IF v_sum.current_tier_pct = 0 THEN
        v_msg := v_msg || ' (Chưa đạt mốc thưởng)';
    END IF;

    IF v_sum.next_tier_threshold IS NOT NULL AND v_sum.next_tier_pct IS NOT NULL THEN
        v_msg := v_msg || E'\nMốc tiếp theo: ' || fmt_money_vn(v_sum.next_tier_threshold)
                       || ' → ' || v_sum.next_tier_pct || '%';
        v_remaining := v_sum.next_tier_threshold - v_sum.total_revenue;
        IF v_remaining > 0 THEN
            v_msg := v_msg || ' (còn thiếu ' || fmt_money_vn(v_remaining) || ')';
        END IF;
    END IF;

    -- Danh sách mốc
    IF v_sum.all_tiers IS NOT NULL AND jsonb_array_length(v_sum.all_tiers) > 0 THEN
        v_msg := v_msg || E'\n\nCác mốc thưởng hoa hồng sản xuất:';

        -- Mốc CAO NHẤT đã vượt qua = mốc đang áp dụng.
        -- KHÔNG dùng (revenue < tier.max) như bản TS cũ: cấu hình có khoảng
        -- trống thì sẽ không mốc nào được đánh dấu. Xem fix_production_tier_gap.sql
        SELECT MAX((t->>'min')::NUMERIC) INTO v_active_min
        FROM jsonb_array_elements(v_sum.all_tiers) AS t
        WHERE v_sum.total_revenue >= (t->>'min')::NUMERIC;

        -- Chỉ có vùng "dưới mốc = 0%" khi mốc thấp nhất > 0
        SELECT MIN((t->>'min')::NUMERIC) INTO v_next_min
        FROM jsonb_array_elements(v_sum.all_tiers) AS t;
        IF v_next_min > 0 THEN
            v_msg := v_msg || E'\n• Dưới ' || fmt_money_vn(v_next_min) || ': 0%';
        END IF;

        FOR v_tier IN
            SELECT (t->>'min')::NUMERIC AS tmin, (t->>'rate')::NUMERIC AS trate
            FROM jsonb_array_elements(v_sum.all_tiers) AS t
            ORDER BY (t->>'min')::NUMERIC
        LOOP
            -- Trần thật của mốc = "Từ" của mốc kế tiếp, KHÔNG phải cột "Đến"
            SELECT MIN((t->>'min')::NUMERIC) INTO v_next_min
            FROM jsonb_array_elements(v_sum.all_tiers) AS t
            WHERE (t->>'min')::NUMERIC > v_tier.tmin;

            IF v_next_min IS NULL THEN
                v_range := fmt_money_vn(v_tier.tmin) || ' trở lên';
            ELSE
                v_range := fmt_money_vn(v_tier.tmin) || ' - ' || fmt_money_vn(v_next_min);
            END IF;

            v_msg := v_msg || E'\n• ' || v_range || ': ' || v_tier.trate || '%';
            IF v_tier.tmin = v_active_min THEN
                v_msg := v_msg || ' ← hiện tại';
            END IF;
        END LOOP;
    END IF;

    v_msg := v_msg || E'\n\nCông thức: Thưởng thực nhận = (Thưởng CV chính + CV phụ) × '
                   || v_sum.current_tier_pct || '%';

    RETURN v_msg;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- ----------------------------------------------------------------------------
-- 2. Gửi thông báo cho nhân viên sản xuất
--    p_require_admin = TRUE khi gọi từ giao diện; FALSE khi gọi từ cron/trigger.
-- ----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION notify_production_revenue(
    p_month         INT,
    p_year          INT,
    p_headline      TEXT DEFAULT NULL,
    p_require_admin BOOLEAN DEFAULT TRUE
)
RETURNS INT AS $$
DECLARE
    v_title  TEXT := 'Cập nhật Thưởng Hoa Hồng Sản Xuất';
    v_msg    TEXT;
    v_uid    UUID;
    v_count  INT := 0;
BEGIN
    IF p_require_admin THEN
        IF NOT EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'Admin') THEN
            RAISE EXCEPTION 'Access Denied: Only Admins can send this notification.';
        END IF;
    END IF;

    v_msg := build_production_revenue_message(p_month, p_year, p_headline);
    IF v_msg IS NULL THEN
        RETURN 0;
    END IF;

    -- Chống gửi trùng: bấm Lưu vài lần liên tiếp không đẻ ra vài thông báo
    IF EXISTS (
        SELECT 1 FROM notifications
        WHERE title = v_title
          AND message = v_msg
          AND created_at > NOW() - INTERVAL '10 minutes'
    ) THEN
        RETURN 0;
    END IF;

    FOR v_uid IN
        SELECT id FROM profiles
        WHERE role::text IN ('Admin', 'NhanVienSanXuat', 'QuanLySanXuat',
                             'NhanVienBinhFile', 'NhanVienThietKe')
          AND deleted_at IS NULL
          AND (is_locked IS NULL OR is_locked = FALSE)
    LOOP
        -- title phải giữ nguyên chuỗi có "Hoa Hồng": NotificationBell dựa vào đó
        -- để ghim dải đỏ và mở bảng mốc khi bấm vào.
        PERFORM create_notification(v_uid, v_title, v_msg, 'system', NULL, NULL);
        v_count := v_count + 1;
    END LOOP;

    RETURN v_count;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION notify_production_revenue(INT, INT, TEXT, BOOLEAN) TO authenticated;


-- ----------------------------------------------------------------------------
-- 3. Tự báo khi doanh số VƯỢT MỐC (hệ số đổi)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS production_tier_notify_state (
    period_month INT NOT NULL,
    period_year  INT NOT NULL,
    last_pct     NUMERIC NOT NULL,
    updated_at   TIMESTAMPTZ DEFAULT NOW(),
    PRIMARY KEY (period_month, period_year)
);

CREATE OR REPLACE FUNCTION notify_production_tier_change()
RETURNS TRIGGER AS $$
DECLARE
    v_transition_date DATE := '2026-03-01';
    v_ref_date  DATE;
    v_month     INT;
    v_year      INT;
    v_new_pct   NUMERIC;
    v_old_pct   NUMERIC;
    v_headline  TEXT;
    v_revenue   NUMERIC;
BEGIN
    -- Chỉ quan tâm khi trạng thái ĐỔI và có dính 'HoanThanh' (vào hoặc ra)
    IF NOT (OLD.status IS DISTINCT FROM NEW.status) THEN
        RETURN NEW;
    END IF;
    IF NEW.status::text <> 'HoanThanh' AND OLD.status::text <> 'HoanThanh' THEN
        RETURN NEW;
    END IF;

    -- Tháng tính doanh số: cùng quy tắc với get_production_commission_summary
    IF NEW.created_at::DATE < v_transition_date THEN
        v_ref_date := NEW.created_at::DATE;
    ELSE
        v_ref_date := COALESCE(NEW.completed_at, OLD.completed_at, NEW.created_at)::DATE;
    END IF;
    v_month := EXTRACT(MONTH FROM v_ref_date)::INT;
    v_year  := EXTRACT(YEAR  FROM v_ref_date)::INT;

    SELECT total_revenue, current_tier_pct INTO v_revenue, v_new_pct
    FROM get_production_commission_summary(v_month, v_year);

    SELECT last_pct INTO v_old_pct
    FROM production_tier_notify_state
    WHERE period_month = v_month AND period_year = v_year;

    -- Lần đầu trong tháng: chỉ ghi nhận, không báo (tránh ồn vô cớ)
    IF v_old_pct IS NULL THEN
        INSERT INTO production_tier_notify_state (period_month, period_year, last_pct)
        VALUES (v_month, v_year, v_new_pct)
        ON CONFLICT (period_month, period_year)
        DO UPDATE SET last_pct = EXCLUDED.last_pct, updated_at = NOW();
        RETURN NEW;
    END IF;

    -- Hệ số không đổi -> im lặng. Đây là trường hợp thường gặp nhất,
    -- nhờ vậy đơn hoàn thành hằng ngày không sinh thông báo nào.
    IF v_new_pct = v_old_pct THEN
        RETURN NEW;
    END IF;

    IF v_new_pct > v_old_pct THEN
        v_headline := 'Doanh số vừa vượt mốc! Hệ số thưởng tăng từ '
                   || v_old_pct || '% lên ' || v_new_pct || '%.';
    ELSE
        v_headline := 'Lưu ý: doanh số giảm, hệ số thưởng lùi từ '
                   || v_old_pct || '% về ' || v_new_pct || '%.';
    END IF;

    PERFORM notify_production_revenue(v_month, v_year, v_headline, FALSE);

    UPDATE production_tier_notify_state
    SET last_pct = v_new_pct, updated_at = NOW()
    WHERE period_month = v_month AND period_year = v_year;

    RETURN NEW;

EXCEPTION WHEN OTHERS THEN
    -- Thông báo hỏng TUYỆT ĐỐI không được làm hỏng việc cập nhật đơn hàng
    RAISE WARNING 'notify_production_tier_change failed: %', SQLERRM;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_notify_production_tier_change ON orders;
CREATE TRIGGER trigger_notify_production_tier_change
    AFTER UPDATE ON orders
    FOR EACH ROW
    EXECUTE FUNCTION notify_production_tier_change();

NOTIFY pgrst, 'reload schema';


-- ============================================================================
-- KIỂM TRA SAU KHI CHẠY
-- ============================================================================
-- 1. Xem thử nội dung (KHÔNG gửi cho ai):
--    SELECT build_production_revenue_message(8, 2026, NULL);
--    -> phần mốc phải có dòng "0 triệu - 620 triệu: 40% ← hiện tại"
--
-- 2. Xem nội dung khi vượt mốc:
--    SELECT build_production_revenue_message(8, 2026,
--        'Doanh số vừa vượt mốc! Hệ số thưởng tăng từ 40% lên 70%.');
--
-- 3. Gửi thật cho nhân viên sản xuất (trả về số người đã nhận):
--    SELECT notify_production_revenue(8, 2026, NULL, FALSE);
--
-- 4. Trigger đã gắn chưa:
--    SELECT tgname FROM pg_trigger WHERE tgrelid = 'orders'::regclass;
--
-- 5. Trạng thái hệ số đã báo của từng tháng:
--    SELECT * FROM production_tier_notify_state ORDER BY period_year, period_month;
-- ============================================================================
