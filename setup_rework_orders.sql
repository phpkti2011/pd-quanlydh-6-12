-- ============================================================================
-- ĐƠN SẢN XUẤT LẠI (làm lại đơn bị lỗi) — chạy MỘT LẦN trong Supabase SQL Editor
-- ============================================================================
-- THỨ TỰ BẮT BUỘC: chạy file này TRƯỚC, deploy frontend SAU.
--   Frontend mới lọc theo cột rework_of_order_id; deploy trước khi chạy file
--   này thì các tab đơn hàng báo "column does not exist" và không tải được.
--
-- NGHIỆP VỤ (quyết định của Admin, 10/2026)
--   * Từ thẻ đơn bị lỗi bấm "Sản xuất lại" -> tạo đơn mới chép nội dung đơn cũ,
--     hỏi nguyên nhân + chi phí làm lại, liên kết hai chiều với đơn gốc.
--   * Đơn làm lại luôn trỏ về đơn GỐC tận cùng (làm lại lần 2 vẫn trỏ về gốc).
--   * Mã đơn: <mã gốc>-L1, -L2, ... Mã đơn thường KHÔNG nhảy số vì đơn làm lại.
--   * Khách không trả tiền: total = 0, payment_status = DaThanhToan
--     (để không lọt vào Công nợ / Cần thu).
--   * Chi phí làm lại TRỪ vào doanh số tính mốc thưởng sản xuất và doanh thu
--     công ty, tính vào tháng đơn làm lại HOÀN THÀNH. KHÔNG trừ doanh số NVKD.
--   * KHÔNG tính vào "số đơn" ở các báo cáo (giống đơn Hủy).
--   * Không qua công đoạn, không ghi người tham gia -> không ai có hoa hồng
--     trên đơn làm lại. Thẻ đơn chỉ còn nút Hoàn thành / Hủy.
--
-- NỘI DUNG FILE
--   1. Ba cột mới trên orders (bảng có sẵn -> không cần GRANT)
--   2. generate_order_code / set_order_code: sinh mã -L{n}, không đếm đơn làm lại
--   3. production_revenue_in_period(): MỘT hàm doanh số tháng dùng chung (đã
--      trừ chi phí làm lại); get_production_commission_summary và
--      get_staff_commission_rows gọi hàm này thay cho đoạn SUM chép tay
--   4. get_daily_report: doanh thu trừ chi phí làm lại, số đơn bỏ đơn làm lại,
--      thêm 2 trường rework_count_month / rework_cost_month
--   5. notify_new_order: thông báo riêng "Đơn SẢN XUẤT LẠI"
--
-- KHÔNG đụng calculate_sales_commission: bản đang chạy thật (7 cột, kiểm tra
-- qua RPC ngày 01/10/2026, khớp update_sales_commission_completed_at.sql)
-- không trả về số đơn, và doanh số NVKD không bị trừ -> không có gì phải sửa.
--
-- Cùng thân hàm đã được vá vào các file gốc đang định nghĩa chúng (quy tắc
-- CLAUDE.md "bẫy file fix_ mới đè hàm đúng"):
--   db_order_code_generator.sql, fix_missing_insert_trigger.sql,
--   update_production_tiers_per_month.sql, setup_production_defect_deduction.sql,
--   fix_stage_rate_no_fallback.sql, setup_daily_report.sql, setup_notifications_v2.sql
-- ============================================================================


-- ----------------------------------------------------------------------------
-- 1. Cột mới trên orders
-- ----------------------------------------------------------------------------
ALTER TABLE orders
    ADD COLUMN IF NOT EXISTS rework_of_order_id UUID REFERENCES orders(id) ON DELETE SET NULL,
    ADD COLUMN IF NOT EXISTS rework_reason      TEXT,
    ADD COLUMN IF NOT EXISTS rework_cost        NUMERIC DEFAULT 0 CHECK (rework_cost >= 0);

COMMENT ON COLUMN orders.rework_of_order_id IS 'Đơn GỐC tận cùng mà đơn này làm lại. Có giá trị = đây là đơn sản xuất lại.';
COMMENT ON COLUMN orders.rework_reason      IS 'Nguyên nhân phải sản xuất lại (gõ tự do).';
COMMENT ON COLUMN orders.rework_cost        IS 'Chi phí làm lại; trừ vào doanh số tháng khi đơn hoàn thành. Không trừ doanh số NVKD.';

CREATE INDEX IF NOT EXISTS idx_orders_rework_of ON orders(rework_of_order_id);


-- ----------------------------------------------------------------------------
-- 2. Mã đơn
-- ----------------------------------------------------------------------------
-- 2a. Số thứ tự tháng KHÔNG đếm đơn làm lại (chúng có mã -L riêng).
CREATE OR REPLACE FUNCTION generate_order_code()
RETURNS TEXT
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    date_part TEXT;
    seq_part INT;
    new_code TEXT;
    start_of_month TIMESTAMP WITH TIME ZONE;
BEGIN
    -- Format: YYPDDDMM.NNNN
    -- Example: 25PD2212.0021 (22nd Dec 2025, 21st order of month)

    -- 1. Generate Date Part: YY + PD + DDMM
    date_part := to_char(NOW() AT TIME ZONE 'Asia/Ho_Chi_Minh', 'YY') || 'PD' || to_char(NOW() AT TIME ZONE 'Asia/Ho_Chi_Minh', 'DDMM');

    -- 2. Calculate Monthly Sequence
    -- Count existing orders in the current month (Asia/Ho_Chi_Minh)
    start_of_month := date_trunc('month', NOW() AT TIME ZONE 'Asia/Ho_Chi_Minh');

    SELECT COUNT(*) + 1
    INTO seq_part
    FROM orders
    WHERE created_at >= start_of_month
      -- Đơn sản xuất lại mang mã <gốc>-L{n}, không chiếm số thứ tự tháng
      -- (xem setup_rework_orders.sql). Đếm cả chúng thì mã đơn thường bị nhảy số.
      AND rework_of_order_id IS NULL;

    -- 3. Combine
    new_code := date_part || '.' || lpad(seq_part::TEXT, 4, '0');

    RETURN new_code;
END;
$$;

-- 2b. Trigger sinh mã khi tạo đơn.
--     Đơn làm lại: <mã gốc>-L<số đơn làm lại hiện có của gốc + 1>. Luôn quy về
--     đơn gốc tận cùng, kể cả khi client gửi id của một đơn -L. SECURITY DEFINER
--     để đọc đơn gốc / đếm đơn -L bất kể RLS của người tạo. Hai người tạo cùng
--     lúc trùng mã -> UNIQUE(order_code) chặn, bấm Lưu lại là xong.
CREATE OR REPLACE FUNCTION set_order_code()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    v_root_id     UUID;
    v_root_code   TEXT;
    v_root_parent UUID;
    v_seq         INT;
BEGIN
    -- Đơn sản xuất lại: quy về đơn gốc tận cùng (làm lại của -L1 vẫn treo vào gốc)
    IF NEW.rework_of_order_id IS NOT NULL THEN
        SELECT id, order_code, rework_of_order_id
        INTO v_root_id, v_root_code, v_root_parent
        FROM orders WHERE id = NEW.rework_of_order_id;

        IF v_root_id IS NULL THEN
            RAISE EXCEPTION 'Không tìm thấy đơn gốc (%) để tạo đơn sản xuất lại', NEW.rework_of_order_id;
        END IF;

        IF v_root_parent IS NOT NULL THEN
            NEW.rework_of_order_id := v_root_parent;
            SELECT order_code INTO v_root_code FROM orders WHERE id = v_root_parent;
        END IF;
    END IF;

    -- Only generate if order_code is not provided or empty
    IF NEW.order_code IS NULL OR NEW.order_code = '' THEN
        IF NEW.rework_of_order_id IS NOT NULL THEN
            SELECT COUNT(*) + 1 INTO v_seq
            FROM orders WHERE rework_of_order_id = NEW.rework_of_order_id;
            NEW.order_code := v_root_code || '-L' || v_seq;
        ELSE
            NEW.order_code := generate_order_code();
        END IF;
    END IF;
    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS before_insert_order_code ON orders;
CREATE TRIGGER before_insert_order_code
BEFORE INSERT ON orders
FOR EACH ROW
EXECUTE FUNCTION set_order_code();


-- ----------------------------------------------------------------------------
-- 3. Doanh số tháng cho mốc thưởng sản xuất — MỘT nơi duy nhất
-- ----------------------------------------------------------------------------
-- Trước đây đoạn SUM(total_amount_pre_vat) + quy tắc chuyển đổi 01/03/2026 được
-- chép tay ở 2 hàm; sửa một chỗ quên chỗ kia là lệch số. Giờ cả hai gọi hàm này.
--   * Đơn thường: rework_cost = 0 -> không đổi gì.
--   * Đơn làm lại: total_amount_pre_vat = 0 -> đóng góp ÂM đúng bằng chi phí,
--     tính vào tháng nó hoàn thành (completed_at, cùng quy tắc như đơn thường).
--     Đơn làm lại bị Hủy hoặc chưa hoàn thành thì chưa trừ.
CREATE OR REPLACE FUNCTION public.production_revenue_in_period(
    p_start_date DATE,
    p_end_date   DATE
)
RETURNS NUMERIC
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
    SELECT COALESCE(SUM(total_amount_pre_vat - COALESCE(rework_cost, 0)), 0)
    FROM orders
    WHERE status = 'HoanThanh'
    AND (
        -- Đơn tạo trước 01/03/2026: tính theo created_at
        (created_at::DATE < DATE '2026-03-01'
         AND created_at::DATE >= p_start_date
         AND created_at::DATE <= p_end_date)
        OR
        -- Đơn tạo từ 01/03/2026: tính theo completed_at
        (created_at::DATE >= DATE '2026-03-01'
         AND completed_at IS NOT NULL
         AND completed_at::DATE >= p_start_date
         AND completed_at::DATE <= p_end_date)
    );
$$;

-- 3a. Summary cho thông báo/UI (nguồn: update_production_tiers_per_month.sql)
CREATE OR REPLACE FUNCTION get_production_commission_summary(
    p_month INT,
    p_year INT
)
RETURNS TABLE (
    total_revenue NUMERIC,
    current_tier_pct NUMERIC,
    next_tier_threshold NUMERIC,
    next_tier_pct NUMERIC,
    all_tiers JSONB
) AS $$
DECLARE
    v_start DATE;
    v_end DATE;
    v_revenue NUMERIC := 0;
    v_current_pct NUMERIC := 0;
    v_next_threshold NUMERIC;
    v_next_pct NUMERIC;
    v_has_month BOOLEAN;
BEGIN
    v_start := make_date(p_year, p_month, 1);
    v_end := (v_start + interval '1 month' - interval '1 day')::DATE;

    -- Doanh thu tháng (chưa VAT, đã trừ chi phí sản xuất lại) — một hàm dùng chung
    -- với get_staff_commission_rows, xem setup_rework_orders.sql. ĐỪNG chép lại
    -- đoạn SUM ở đây: hai nơi tự tính là hai nơi lệch số.
    v_revenue := production_revenue_in_period(v_start, v_end);

    -- Có mốc riêng cho tháng này không?
    SELECT EXISTS(
        SELECT 1 FROM commission_policies
        WHERE policy_type = 'PRODUCTION_TIER'
          AND period_month = p_month AND period_year = p_year
    ) INTO v_has_month;

    -- % hiện tại theo tháng (hàm đã tự fallback global)
    v_current_pct := get_production_tier_rate(v_revenue, p_month, p_year);

    -- Mốc kế tiếp (ngưỡng nhỏ nhất > doanh thu) trong tập mốc hiệu lực của tháng
    SELECT cp.threshold_min, cp.rate
    INTO v_next_threshold, v_next_pct
    FROM commission_policies cp
    WHERE cp.policy_type = 'PRODUCTION_TIER'
      AND (
            (v_has_month AND cp.period_month = p_month AND cp.period_year = p_year)
         OR (NOT v_has_month AND cp.period_month IS NULL)
          )
      AND cp.threshold_min > v_revenue
    ORDER BY cp.threshold_min ASC
    LIMIT 1;

    RETURN QUERY
    SELECT
        v_revenue,
        v_current_pct,
        v_next_threshold,
        v_next_pct,
        (SELECT jsonb_agg(
            jsonb_build_object(
                'min', cp.threshold_min,
                'max', cp.threshold_max,
                'rate', cp.rate
            ) ORDER BY cp.threshold_min
        )
         FROM commission_policies cp
         WHERE cp.policy_type = 'PRODUCTION_TIER'
           AND (
                 (v_has_month AND cp.period_month = p_month AND cp.period_year = p_year)
              OR (NOT v_has_month AND cp.period_month IS NULL)
               ));
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 3b. Hàm nền của Thưởng HHSX (nguồn: fix_stage_rate_no_fallback.sql).
--     Chữ ký không đổi nên CREATE OR REPLACE giữ nguyên REVOKE/GRANT đã có.
CREATE OR REPLACE FUNCTION public.get_staff_commission_rows(
    p_start_date DATE,
    p_end_date   DATE
)
RETURNS TABLE (
    full_name         TEXT,
    order_code        TEXT,
    stage             TEXT,
    started_at        TIMESTAMPTZ,
    finished_at       TIMESTAMPTZ,
    score             NUMERIC,
    participant_count BIGINT,
    process_comm      NUMERIC,   -- đã co lại theo phần trừ
    stage_comm        NUMERIC,   -- đã co lại theo phần trừ
    row_total         NUMERIC,   -- đã trừ (sau hệ số)
    row_deduct        NUMERIC,   -- phần bị trừ trên dòng này
    tier_percentage   NUMERIC,
    is_manager        BOOLEAN
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
-- Tên cột trả về (stage, score, full_name...) trùng tên cột trong bảng.
-- Chỉ thị này bảo plpgsql ưu tiên hiểu là CỘT, tránh lỗi "ambiguous".
#variable_conflict use_column
DECLARE
    v_total_month_sales NUMERIC := 0;
    v_tier_pct          NUMERIC := 0;
    v_transition_date   DATE := '2026-03-01';
    v_deduct_total      NUMERIC := 0;
BEGIN
    -- Doanh số tháng (trước VAT, đã trừ chi phí sản xuất lại) — một hàm dùng chung
    -- với get_production_commission_summary, xem setup_rework_orders.sql.
    -- Quy tắc chuyển đổi 01/03/2026 nằm trong hàm đó.
    v_total_month_sales := production_revenue_in_period(p_start_date, p_end_date);

    v_tier_pct := get_production_tier_rate(
        v_total_month_sales,
        EXTRACT(MONTH FROM p_start_date)::INT,
        EXTRACT(YEAR FROM p_start_date)::INT
    );

    -- Tổng khoản trừ sai hỏng của tháng (lấy tháng từ ngày bắt đầu, cùng cách
    -- đang lấy hệ số ở trên)
    SELECT COALESCE(SUM(d.amount), 0)
    INTO v_deduct_total
    FROM production_defect_deductions d
    WHERE d.period_month = EXTRACT(MONTH FROM p_start_date)::INT
      AND d.period_year  = EXTRACT(YEAR  FROM p_start_date)::INT;

    RETURN QUERY
    WITH participated_tasks AS (
        SELECT
            p.full_name,
            COALESCE(p.competency_score, 1.0) AS score,
            -- Không có key trong JSON  =>  0. KHÔNG lấy mức chung (commission_policies) nữa.
            -- Lỗi cũ: COALESCE(..., cp_proc.rate, 0) khiến khâu "chưa cấu hình" âm thầm
            -- ăn mức chung (VD: In = 20%) trong khi giao diện hiển thị 0.
            -- ĐỪNG đưa fallback về mức chung trở lại — xem fix_stage_rate_no_fallback.sql.
            COALESCE((p.commission_stages   ->> part.stage)::NUMERIC, 0) AS process_rate,
            COALESCE((p.commission_subtasks ->> part.stage)::NUMERIC, 0) AS subtask_rate,
            part.stage,
            part.started_at,
            part.finished_at,
            o.order_code,
            o.total_amount_pre_vat,
            COUNT(*) OVER (PARTITION BY part.order_id, part.stage) AS participant_count,
            CASE
                WHEN part.stage = 'ThietKe'      THEN COALESCE(o.design_fee, 0)
                WHEN part.stage = 'InKhoLon'     THEN COALESCE(o.large_print_fee, 0)
                WHEN part.stage = 'EpKim'        THEN COALESCE(o.ep_kim_fee, 0)
                WHEN part.stage = 'BeDemi'       THEN COALESCE(o.be_demi_fee, 0)
                WHEN part.stage = 'GiaCongNgoai' THEN COALESCE(o.gia_cong_ngoai_fee, 0)
                WHEN part.stage = 'CanMang'      THEN COALESCE(o.can_mang_fee, 0)
                ELSE 0
            END AS stage_value
        FROM order_process_participants part
        JOIN orders   o ON part.order_id = o.id
        JOIN profiles p ON part.user_id  = p.id
        -- Đã bỏ 2 LEFT JOIN commission_policies (cp_proc / cp_sub): mức hoa hồng
        -- nay chỉ lấy từ cấu hình riêng của từng nhân viên.
        WHERE o.status = 'HoanThanh'
        AND (
            (o.created_at::DATE < v_transition_date
             AND o.created_at::DATE >= p_start_date
             AND o.created_at::DATE <= p_end_date)
            OR
            (o.created_at::DATE >= v_transition_date
             AND o.completed_at IS NOT NULL
             AND o.completed_at::DATE >= p_start_date
             AND o.completed_at::DATE <= p_end_date)
        )
        -- Đơn sản xuất lại: 0đ, không công đoạn -> không có hoa hồng (setup_rework_orders.sql)
        AND o.rework_of_order_id IS NULL
        AND p.role != 'NhanVienKinhDoanh'
    ),

    -- Mọi dòng chi tiết trước khi trừ (nhân viên + quản lý sản xuất)
    base_rows AS (
        SELECT
            pt.full_name,
            pt.order_code,
            pt.stage,
            pt.started_at,
            pt.finished_at,
            pt.score,
            pt.participant_count,
            CASE WHEN pt.stage_value = 0
                 THEN (pt.total_amount_pre_vat / pt.participant_count) * (pt.process_rate / 100.0) * pt.score
                 ELSE 0 END AS raw_process,
            CASE
                WHEN pt.stage_value > 0
                    THEN pt.stage_value * (pt.subtask_rate / 100.0)
                WHEN pt.subtask_rate > 0
                     AND pt.stage IN ('ThietKe','InKhoLon','BeDemi','GiaCongNgoai','EpKim','CanMang')
                    THEN (pt.total_amount_pre_vat / pt.participant_count) * (pt.subtask_rate / 100.0)
                ELSE 0
            END AS raw_stage,
            FALSE AS is_manager
        FROM participated_tasks pt

        UNION ALL

        SELECT
            p.full_name,
            o.order_code,
            'DoanhSo'          AS stage,
            o.created_at       AS started_at,
            o.delivery_date    AS finished_at,
            1.0                AS score,
            1::BIGINT          AS participant_count,
            o.total_amount_pre_vat * (p.product_manager_commission_rate / 100.0) AS raw_process,
            0::NUMERIC         AS raw_stage,
            TRUE               AS is_manager
        FROM orders o
        CROSS JOIN profiles p
        WHERE o.status = 'HoanThanh'
        AND (
            (o.created_at::DATE < v_transition_date
             AND o.created_at::DATE >= p_start_date
             AND o.created_at::DATE <= p_end_date)
            OR
            (o.created_at::DATE >= v_transition_date
             AND o.completed_at IS NOT NULL
             AND o.completed_at::DATE >= p_start_date
             AND o.completed_at::DATE <= p_end_date)
        )
        -- Đơn sản xuất lại không tính cho quản lý sản xuất (setup_rework_orders.sql)
        AND o.rework_of_order_id IS NULL
        AND p.role = 'QuanLySanXuat'
        AND p.product_manager_commission_rate IS NOT NULL
        AND p.product_manager_commission_rate > 0
    ),

    -- Tổng thưởng từng dòng sau hệ số (chưa trừ)
    rows_gross AS (
        SELECT
            b.*,
            (b.raw_process + b.raw_stage) * v_tier_pct / 100.0 AS gross_total
        FROM base_rows b
    ),

    -- Gộp theo NGƯỜI: trùng tên chỉ tính 1, gộp cả dòng công đoạn lẫn dòng quản lý
    per_person AS (
        SELECT rg.full_name, SUM(rg.gross_total) AS person_total
        FROM rows_gross rg
        GROUP BY rg.full_name
    ),

    -- Số người có thưởng và phần trừ mỗi người
    share AS (
        SELECT
            CASE WHEN COUNT(*) FILTER (WHERE pp.person_total > 0) > 0
                 THEN FLOOR(v_deduct_total / COUNT(*) FILTER (WHERE pp.person_total > 0))
                 ELSE 0
            END AS per_share
        FROM per_person pp
    ),

    -- Ăn dần từ đơn MỚI NHẤT lùi về trước, dùng tổng luỹ kế của các dòng trước đó
    consumed AS (
        SELECT
            rg.*,
            s.per_share,
            COALESCE(SUM(rg.gross_total) OVER (
                PARTITION BY rg.full_name
                ORDER BY rg.started_at DESC, rg.order_code DESC, rg.stage DESC
                ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
            ), 0) AS cum_before
        FROM rows_gross rg
        CROSS JOIN share s
    ),

    applied AS (
        SELECT
            c.*,
            -- Chặn ở 0: không bao giờ trừ quá phần thưởng của chính dòng đó
            GREATEST(0, LEAST(c.gross_total, c.per_share - c.cum_before)) AS deduct_val
        FROM consumed c
    )

    SELECT
        a.full_name::TEXT,
        a.order_code::TEXT,
        a.stage::TEXT,
        a.started_at,
        a.finished_at,
        a.score,
        a.participant_count,
        -- Co lại CV chính / CV phụ theo cùng tỉ lệ, để (chính + phụ) x hệ số
        -- vẫn đúng bằng tổng — nhân viên tính lại không thấy bất thường
        ROUND(a.raw_process * CASE WHEN a.gross_total > 0
                                   THEN (a.gross_total - a.deduct_val) / a.gross_total
                                   ELSE 1 END, 0),
        ROUND(a.raw_stage   * CASE WHEN a.gross_total > 0
                                   THEN (a.gross_total - a.deduct_val) / a.gross_total
                                   ELSE 1 END, 0),
        ROUND(a.gross_total - a.deduct_val, 0),
        ROUND(a.deduct_val, 0),
        v_tier_pct,
        a.is_manager
    FROM applied a;
END;
$$;


-- ----------------------------------------------------------------------------
-- 4. Báo cáo ngày (nguồn: setup_daily_report.sql)
-- ----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION get_daily_report(p_date DATE DEFAULT CURRENT_DATE)
RETURNS JSON AS $$
DECLARE
    v_result JSON;
    v_start TIMESTAMPTZ;
    v_end TIMESTAMPTZ;
    v_month_start TIMESTAMPTZ;
    v_month_end TIMESTAMPTZ;
BEGIN
    v_start := p_date::timestamptz;
    v_end := (p_date + 1)::timestamptz;
    v_month_start := date_trunc('month', p_date)::timestamptz;
    v_month_end := (date_trunc('month', p_date) + interval '1 month')::timestamptz;

    -- Đơn sản xuất lại (rework_of_order_id IS NOT NULL, xem setup_rework_orders.sql):
    --   * KHÔNG tính vào số đơn (giống đơn Hủy)
    --   * chi phí làm lại (rework_cost) TRỪ khỏi doanh thu; đơn thường có
    --     rework_cost = 0 nên total_amount - rework_cost không đổi gì
    --   * doanh số theo NVKD KHÔNG trừ (quyết định của Admin)
    SELECT json_build_object(
        'report_date', p_date,
        'orders_created_today', (
            SELECT COUNT(*) FROM orders
            WHERE created_at >= v_start AND created_at < v_end
            AND rework_of_order_id IS NULL
        ),
        'orders_completed_today', (
            SELECT COUNT(*) FROM orders
            WHERE status::text = 'HoanThanh'
            AND rework_of_order_id IS NULL
            AND CASE
                WHEN completed_at IS NOT NULL THEN completed_at >= v_start AND completed_at < v_end
                ELSE updated_at >= v_start AND updated_at < v_end
            END
        ),
        'orders_cancelled_today', (
            SELECT COUNT(*) FROM orders
            WHERE status::text = 'Huy'
            AND rework_of_order_id IS NULL
            AND updated_at >= v_start AND updated_at < v_end
        ),
        'revenue_today', (
            SELECT COALESCE(SUM(total_amount - COALESCE(rework_cost, 0)), 0) FROM orders
            WHERE created_at >= v_start AND created_at < v_end
            AND status::text NOT IN ('Huy')
        ),
        'revenue_today_pre_vat', (
            SELECT COALESCE(SUM(total_amount_pre_vat - COALESCE(rework_cost, 0)), 0) FROM orders
            WHERE created_at >= v_start AND created_at < v_end
            AND status::text NOT IN ('Huy')
        ),
        'revenue_completed_today', (
            SELECT COALESCE(SUM(total_amount_pre_vat - COALESCE(rework_cost, 0)), 0) FROM orders
            WHERE status::text = 'HoanThanh'
            AND CASE
                WHEN completed_at IS NOT NULL THEN completed_at >= v_start AND completed_at < v_end
                ELSE updated_at >= v_start AND updated_at < v_end
            END
        ),
        'revenue_month_total', (
            SELECT COALESCE(SUM(total_amount - COALESCE(rework_cost, 0)), 0) FROM orders
            WHERE created_at >= v_month_start AND created_at < v_month_end
            AND status::text NOT IN ('Huy')
        ),
        'revenue_month_pre_vat', (
            SELECT COALESCE(SUM(total_amount_pre_vat - COALESCE(rework_cost, 0)), 0) FROM orders
            WHERE created_at >= v_month_start AND created_at < v_month_end
            AND status::text NOT IN ('Huy')
        ),
        -- Đơn sản xuất lại tạo trong tháng (chưa hủy) và tổng chi phí của chúng
        'rework_count_month', (
            SELECT COUNT(*) FROM orders
            WHERE rework_of_order_id IS NOT NULL
            AND created_at >= v_month_start AND created_at < v_month_end
            AND status::text NOT IN ('Huy')
        ),
        'rework_cost_month', (
            SELECT COALESCE(SUM(COALESCE(rework_cost, 0)), 0) FROM orders
            WHERE rework_of_order_id IS NOT NULL
            AND created_at >= v_month_start AND created_at < v_month_end
            AND status::text NOT IN ('Huy')
        ),
        'sales_by_employee', (
            SELECT COALESCE(json_agg(emp_stats ORDER BY emp_stats.revenue DESC), '[]'::json)
            FROM (
                SELECT
                    p.full_name AS employee_name,
                    p.role::text AS role,
                    COUNT(o.id) FILTER (WHERE o.rework_of_order_id IS NULL) AS orders_created,
                    COALESCE(SUM(o.total_amount), 0) AS revenue,
                    COUNT(CASE WHEN o.rework_of_order_id IS NULL
                        AND o.status::text = 'HoanThanh'
                        AND CASE
                            WHEN o.completed_at IS NOT NULL THEN o.completed_at >= v_start AND o.completed_at < v_end
                            ELSE o.updated_at >= v_start AND o.updated_at < v_end
                        END
                    THEN 1 END) AS orders_completed
                FROM profiles p
                LEFT JOIN orders o ON o.sales_rep_id = p.id
                    AND o.created_at >= v_start AND o.created_at < v_end
                    AND o.status::text != 'Huy'
                WHERE p.role::text = 'NhanVienKinhDoanh'
                AND (p.is_locked IS NULL OR p.is_locked = false)
                GROUP BY p.id, p.full_name, p.role
            ) emp_stats
        ),
        'status_transitions_today', (
            SELECT COALESCE(json_agg(trans ORDER BY trans.count DESC), '[]'::json)
            FROM (
                SELECT
                    details->>'new_status' AS to_status,
                    COUNT(*) AS count
                FROM user_logs
                WHERE action_type = 'ORDER_UPDATE_STATUS'
                AND created_at >= v_start AND created_at < v_end
                AND details->>'new_status' IS NOT NULL
                GROUP BY details->>'new_status'
            ) trans
        ),
        'employee_activity', (
            SELECT COALESCE(json_agg(act ORDER BY act.total_actions DESC), '[]'::json)
            FROM (
                SELECT
                    ul.user_name AS employee_name,
                    COUNT(*) AS total_actions,
                    COUNT(CASE WHEN ul.action_type = 'ORDER_CREATE' THEN 1 END) AS orders_created,
                    COUNT(CASE WHEN ul.action_type = 'ORDER_UPDATE_STATUS' THEN 1 END) AS status_updates,
                    COUNT(CASE WHEN ul.action_type IN ('STAGE_JOIN', 'STAGE_LEAVE') THEN 1 END) AS stage_actions,
                    COUNT(CASE WHEN ul.action_type = 'PAYMENT_UPDATE' THEN 1 END) AS payment_updates
                FROM user_logs ul
                WHERE ul.created_at >= v_start AND ul.created_at < v_end
                GROUP BY ul.user_name
            ) act
        ),
        'pending_orders_count', (
            SELECT COUNT(*) FROM orders
            WHERE status::text NOT IN ('HoanThanh', 'Huy')
        ),
        'payment_stats', json_build_object(
            'total_collected', (
                SELECT COALESCE(SUM(deposit_amount + COALESCE(remaining_amount, 0)), 0)
                FROM orders
                WHERE payment_confirmed = true
                AND payment_confirmed_at >= v_start AND payment_confirmed_at < v_end
            ),
            'unpaid_orders', (
                SELECT COUNT(*) FROM orders
                WHERE payment_status::text = 'ChuaThanhToan'
                AND status::text NOT IN ('Huy', 'Moi')
            ),
            'debt_orders', (
                SELECT COUNT(*) FROM orders
                WHERE payment_status::text = 'CongNo'
            )
        )
    ) INTO v_result;

    RETURN v_result;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- ----------------------------------------------------------------------------
-- 5. Thông báo đơn mới (nguồn: setup_notifications_v2.sql)
-- ----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION notify_new_order()
RETURNS TRIGGER AS $$
DECLARE
    recipient_id UUID;
    v_order_code TEXT;
    v_root_code  TEXT;
    v_title      TEXT;
    v_message    TEXT;
BEGIN
    v_order_code := COALESCE(NEW.order_code, 'N/A');

    IF NEW.rework_of_order_id IS NOT NULL THEN
        -- Đơn sản xuất lại (setup_rework_orders.sql): nói rõ làm lại đơn nào,
        -- vì sao, tốn bao nhiêu. Mã -L đứng TRƯỚC mã gốc trong câu để chuông
        -- thông báo (NotificationBell) bắt đúng đơn làm lại khi bấm mở.
        SELECT order_code INTO v_root_code FROM orders WHERE id = NEW.rework_of_order_id;
        v_title   := 'Đơn SẢN XUẤT LẠI';
        v_message := 'Đơn ' || v_order_code || ' làm lại đơn ' || COALESCE(v_root_code, 'N/A')
                  || '. Lý do: ' || COALESCE(NULLIF(TRIM(NEW.rework_reason), ''), 'không ghi')
                  || '. Chi phí: ' || replace(to_char(COALESCE(NEW.rework_cost, 0), 'FM999,999,999,999'), ',', '.') || 'đ.';
    ELSE
        v_title   := 'Đơn hàng mới';
        v_message := 'Đơn hàng ' || v_order_code || ' vừa được tạo.';
    END IF;

    -- Gửi cho Admin và QuanLySanXuat
    FOR recipient_id IN
        SELECT id FROM profiles
        WHERE role::text IN ('Admin', 'QuanLySanXuat')
        AND (is_locked IS NULL OR is_locked = false)
    LOOP
        PERFORM create_notification(
            recipient_id,
            v_title,
            v_message,
            'order',
            NEW.id,
            NULL
        );
    END LOOP;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


NOTIFY pgrst, 'reload schema';

SELECT 'Đã cài đặt Đơn sản xuất lại. Giờ mới deploy frontend.' AS ket_qua;

-- ============================================================================
-- KIỂM TRA SAU KHI CHẠY
-- ============================================================================
-- 1. Cột đã có:
--    SELECT column_name FROM information_schema.columns
--    WHERE table_name = 'orders' AND column_name LIKE 'rework%';
--    -> rework_of_order_id, rework_reason, rework_cost
--
-- 2. Doanh số tháng không đổi khi chưa có đơn làm lại (thay tháng/năm):
--    SELECT production_revenue_in_period('2026-09-01', '2026-09-30');
--    SELECT total_revenue FROM get_production_commission_summary(9, 2026);
--    -> hai số bằng nhau và bằng số đang hiện ở Thưởng HHSX
--
-- 3. Sau khi tạo + hoàn thành một đơn làm lại chi phí 300.000 trong tháng:
--    total_revenue ở trên phải GIẢM đúng 300.000; doanh số NVKD
--    (calculate_sales_commission) KHÔNG đổi.
--
-- 4. Mã đơn thường không nhảy số: tạo 1 đơn làm lại rồi 1 đơn thường,
--    số thứ tự đơn thường vẫn liền với đơn thường trước đó.
-- ============================================================================
