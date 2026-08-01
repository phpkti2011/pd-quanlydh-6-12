-- ============================================================================
-- TRỪ SAI HỎNG CHO THƯỞNG HOA HỒNG SẢN XUẤT
-- Ngày: 2026-08-01
--
-- Admin nhập một khoản tiền trừ cho tháng (do sản xuất làm hư hỏng), khoản này
-- được chia ĐỀU cho các nhân viên sản xuất có thưởng.
--
-- Quy tắc:
--   - Chia đều cho số NGƯỜI có tổng thưởng > 0 (trùng tên chỉ tính 1 người)
--   - Trừ vượt quá thưởng thì chặn ở 0, KHÔNG chia lại phần dư cho người khác
--   - Phần trừ ăn dần vào hoa hồng TỪNG ĐƠN, từ đơn MỚI NHẤT lùi về trước
--   - Đơn bị ăn hết thì biến mất khỏi bảng chi tiết
--   - Chỉ Admin xem/sửa được khoản trừ; nhân viên chỉ thấy số đã trừ và mọi
--     con số vẫn tự khớp với nhau (cộng chi tiết = tổng)
--
-- ⚠ FILE NÀY THAY THẾ 2 HÀM TRONG:
--      update_manager_commission.sql  (calculate_staff_commission)
--      sync_details_function.sql      (get_staff_activity_details)
--   ĐỪNG chạy lại 2 file cũ đó, sẽ mất tính năng trừ sai hỏng.
--
-- CHẠY NGUYÊN FILE NÀY TRONG SUPABASE SQL EDITOR.
-- ============================================================================


-- ----------------------------------------------------------------------------
-- 1. BẢNG LƯU KHOẢN TRỪ
-- ----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS public.production_defect_deductions (
    id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    period_month int NOT NULL CHECK (period_month BETWEEN 1 AND 12),
    period_year  int NOT NULL,
    amount       numeric NOT NULL CHECK (amount > 0),
    reason       text,
    order_code   text,          -- mã đơn bị hỏng, không bắt buộc
    created_by   uuid REFERENCES public.profiles(id),
    created_at   timestamptz DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_pdd_period
    ON public.production_defect_deductions (period_year, period_month);


-- ----------------------------------------------------------------------------
-- 2. RLS — CHỈ ADMIN
--    Đây là thứ chặn nhân viên nhìn thấy khoản trừ. Các RPC bên dưới chạy
--    SECURITY DEFINER nên vẫn đọc được bảng này để tính toán.
-- ----------------------------------------------------------------------------

ALTER TABLE public.production_defect_deductions ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Chi Admin quan ly khoan tru" ON public.production_defect_deductions;
CREATE POLICY "Chi Admin quan ly khoan tru"
    ON public.production_defect_deductions
    FOR ALL TO authenticated
    USING      (EXISTS (SELECT 1 FROM public.profiles me
                        WHERE me.id = auth.uid() AND me.role::text = 'Admin'))
    WITH CHECK (EXISTS (SELECT 1 FROM public.profiles me
                        WHERE me.id = auth.uid() AND me.role::text = 'Admin'));


-- ----------------------------------------------------------------------------
-- 3. TRIGGER GHI NHẬT KÝ (tuỳ chọn — chỉ tạo nếu đã chạy setup_audit_trail.sql)
-- ----------------------------------------------------------------------------

DO $outer$
BEGIN
    IF EXISTS (SELECT 1 FROM pg_proc WHERE proname = 'audit_build_changes')
       AND EXISTS (SELECT 1 FROM pg_proc WHERE proname = 'audit_actor_name') THEN

        EXECUTE $fn$
        CREATE OR REPLACE FUNCTION public.audit_defect_deductions()
        RETURNS trigger
        LANGUAGE plpgsql
        SECURITY DEFINER
        SET search_path = public
        AS $body$
        DECLARE
            v_uid     uuid;
            v_action  text;
            v_changes jsonb;
            v_ent_id  text;
            v_ent_uid uuid;
        BEGIN
            v_uid := auth.uid();

            IF TG_OP = 'INSERT' THEN
                v_action  := 'DEDUCTION_CREATE';
                v_changes := public.audit_build_changes(NULL, to_jsonb(NEW), ARRAY[]::text[]);
                v_ent_id  := 'Trừ sai hỏng ' || NEW.period_month || '/' || NEW.period_year;
                v_ent_uid := NEW.id;
            ELSIF TG_OP = 'DELETE' THEN
                v_action  := 'DEDUCTION_DELETE';
                v_changes := public.audit_build_changes(to_jsonb(OLD), NULL, ARRAY[]::text[]);
                v_ent_id  := 'Trừ sai hỏng ' || OLD.period_month || '/' || OLD.period_year;
                v_ent_uid := OLD.id;
            ELSE
                v_action  := 'DEDUCTION_UPDATE';
                v_changes := public.audit_build_changes(to_jsonb(OLD), to_jsonb(NEW), ARRAY[]::text[]);
                IF v_changes IS NULL THEN RETURN NEW; END IF;
                v_ent_id  := 'Trừ sai hỏng ' || NEW.period_month || '/' || NEW.period_year;
                v_ent_uid := NEW.id;
            END IF;

            INSERT INTO public.user_logs
                (user_id, user_name, action_type, entity_type, entity_id, entity_uuid, details, source)
            VALUES (
                v_uid, public.audit_actor_name(v_uid), v_action, 'deduction',
                v_ent_id, v_ent_uid,
                jsonb_build_object('changes', COALESCE(v_changes, '{}'::jsonb)),
                'trigger'
            );

            IF TG_OP = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF;
        EXCEPTION WHEN OTHERS THEN
            RAISE WARNING 'audit_defect_deductions bỏ qua do lỗi: %', SQLERRM;
            IF TG_OP = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF;
        END;
        $body$;
        $fn$;

        EXECUTE 'DROP TRIGGER IF EXISTS trg_audit_defect_deductions ON public.production_defect_deductions';
        EXECUTE 'CREATE TRIGGER trg_audit_defect_deductions
                 AFTER INSERT OR UPDATE OR DELETE ON public.production_defect_deductions
                 FOR EACH ROW EXECUTE FUNCTION public.audit_defect_deductions()';

        RAISE NOTICE 'Đã tạo trigger ghi nhật ký cho khoản trừ.';
    ELSE
        RAISE NOTICE 'Chưa chạy setup_audit_trail.sql — bỏ qua trigger ghi nhật ký.';
    END IF;
END
$outer$;


-- ----------------------------------------------------------------------------
-- 4. HÀM NỀN: tính hoa hồng TỪNG DÒNG rồi áp khoản trừ
--
--    Cả calculate_staff_commission lẫn get_staff_activity_details đều gọi hàm
--    này, nên bảng tổng và bảng chi tiết KHÔNG THỂ lệch nhau.
--
--    KHÔNG có tham số p_user_name: phải tính TOÀN BỘ nhân viên mới chia đúng
--    phần trừ. Việc lọc theo tên do hàm gọi làm ở bước cuối.
-- ----------------------------------------------------------------------------

DROP FUNCTION IF EXISTS public.get_staff_commission_rows(DATE, DATE);

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
    -- Doanh số tháng (trước VAT) — giữ nguyên quy tắc chuyển đổi 01/03/2026
    SELECT COALESCE(SUM(total_amount_pre_vat), 0)
    INTO v_total_month_sales
    FROM orders
    WHERE status = 'HoanThanh'
    AND (
        (created_at::DATE < v_transition_date
         AND created_at::DATE >= p_start_date
         AND created_at::DATE <= p_end_date)
        OR
        (created_at::DATE >= v_transition_date
         AND completed_at IS NOT NULL
         AND completed_at::DATE >= p_start_date
         AND completed_at::DATE <= p_end_date)
    );

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
            COALESCE((p.commission_stages->>part.stage)::NUMERIC, cp_proc.rate, 0) AS process_rate,
            COALESCE((p.commission_subtasks->>part.stage)::NUMERIC, cp_sub.rate, 0) AS subtask_rate,
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
        LEFT JOIN commission_policies cp_proc
               ON cp_proc.policy_type = 'MAINTASK_RATE' AND cp_proc.apply_to = part.stage
        LEFT JOIN commission_policies cp_sub
               ON cp_sub.policy_type  = 'SUBTASK_RATE'  AND cp_sub.apply_to  = part.stage
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
-- 5. get_staff_activity_details — lớp mỏng bọc hàm nền
--    Bỏ các dòng đã bị ăn hết (đơn biến mất khỏi danh sách).
--    Giữ nguyên 11 cột như cũ để frontend không phải đổi gì.
-- ----------------------------------------------------------------------------

DROP FUNCTION IF EXISTS get_staff_activity_details(DATE, DATE, TEXT);
DROP FUNCTION IF EXISTS get_staff_activity_details(TEXT, TEXT, TEXT);
DROP FUNCTION IF EXISTS get_staff_activity_details(DATE, DATE);
DROP FUNCTION IF EXISTS get_staff_activity_details(TEXT, TEXT);

CREATE OR REPLACE FUNCTION get_staff_activity_details(
    p_start_date TEXT,
    p_end_date   TEXT,
    p_user_name  TEXT DEFAULT NULL
)
RETURNS TABLE (
    user_name         TEXT,
    order_code        TEXT,
    stage             TEXT,
    started_at        TIMESTAMPTZ,
    finished_at       TIMESTAMPTZ,
    score             NUMERIC,
    participant_count BIGINT,
    process_comm      NUMERIC,
    stage_comm        NUMERIC,
    total_comm        NUMERIC,
    tier_percentage   NUMERIC
)
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
    SELECT
        r.full_name,
        r.order_code,
        r.stage,
        r.started_at,
        r.finished_at,
        r.score,
        r.participant_count,
        r.process_comm,
        r.stage_comm,
        r.row_total,
        r.tier_percentage
    FROM public.get_staff_commission_rows(p_start_date::DATE, p_end_date::DATE) r
    WHERE (p_user_name IS NULL OR r.full_name = p_user_name)
      -- Đơn bị ăn hết thì không hiện nữa. Dòng vốn đã bằng 0 từ đầu (vd hệ số
      -- tháng đó là 0%) thì vẫn giữ, để không đổi hành vi khi không có khoản trừ.
      AND (r.row_total > 0 OR r.row_deduct = 0)
    ORDER BY r.started_at DESC;
$$;


-- ----------------------------------------------------------------------------
-- 6. calculate_staff_commission — gom nhóm từ chính các dòng đã trừ
--    Cộng các giá trị ĐÃ LÀM TRÒN của từng dòng, nên cộng tay bảng chi tiết
--    ra đúng bằng số ở bảng tổng.
-- ----------------------------------------------------------------------------

DROP FUNCTION IF EXISTS calculate_staff_commission(DATE, DATE, TEXT);

CREATE OR REPLACE FUNCTION calculate_staff_commission(
    p_start_date DATE,
    p_end_date   DATE,
    p_user_name  TEXT DEFAULT NULL
)
RETURNS TABLE (
    participant_name TEXT,
    competency_score NUMERIC,
    main_task_comm   NUMERIC,
    sub_task_comm    NUMERIC,
    total_comm       NUMERIC,
    tier_percentage  NUMERIC,
    deduction_amount NUMERIC
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
#variable_conflict use_column
DECLARE
    v_is_admin BOOLEAN := FALSE;
BEGIN
    -- Chỉ Admin mới nhận được số tiền bị trừ. Gọi từ cron/service role thì
    -- auth.uid() là NULL -> không phải Admin -> nhận 0.
    SELECT COALESCE((SELECT me.role::text = 'Admin' FROM profiles me WHERE me.id = auth.uid()), FALSE)
    INTO v_is_admin;

    RETURN QUERY
    WITH grouped AS (
        SELECT
            r.full_name,
            r.is_manager,
            MAX(r.score)          AS score,
            SUM(r.process_comm)   AS main_comm,
            SUM(r.stage_comm)     AS sub_comm,
            SUM(r.row_total)      AS net_comm,
            SUM(r.row_deduct)     AS deduct_comm,
            MAX(r.tier_percentage) AS tier_pct
        FROM public.get_staff_commission_rows(p_start_date, p_end_date) r
        GROUP BY r.full_name, r.is_manager
    )
    SELECT
        g.full_name::TEXT,
        g.score,
        g.main_comm,
        g.sub_comm,
        g.net_comm,
        g.tier_pct,
        CASE WHEN v_is_admin THEN g.deduct_comm ELSE 0 END
    FROM grouped g
    -- Lọc theo tên Ở BƯỚC CUỐI: nếu lọc sớm hơn thì khi nhân viên tự xem,
    -- hệ thống chỉ thấy 1 người và họ sẽ gánh trọn cả khoản trừ.
    WHERE (p_user_name IS NULL OR g.full_name = p_user_name);
END;
$$;


-- ----------------------------------------------------------------------------
-- 7. QUYỀN GỌI
-- ----------------------------------------------------------------------------

-- Hàm nền trả về cả cột row_deduct nên TUYỆT ĐỐI không cho client gọi thẳng,
-- nếu không nhân viên gọi RPC là đọc được khoản trừ. Hai hàm bọc đều chạy
-- SECURITY DEFINER (quyền chủ sở hữu) nên vẫn gọi được hàm nền bình thường.
REVOKE ALL ON FUNCTION public.get_staff_commission_rows(DATE, DATE) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.get_staff_commission_rows(DATE, DATE) FROM authenticated;
REVOKE ALL ON FUNCTION public.get_staff_commission_rows(DATE, DATE) FROM anon;

GRANT EXECUTE ON FUNCTION get_staff_activity_details(TEXT, TEXT, TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION calculate_staff_commission(DATE, DATE, TEXT) TO authenticated;


-- ----------------------------------------------------------------------------
-- 8. KIỂM TRA
-- ----------------------------------------------------------------------------

SELECT 'Đã cài đặt Trừ sai hỏng cho Thưởng HHSX.' AS ket_qua;

NOTIFY pgrst, 'reload schema';
