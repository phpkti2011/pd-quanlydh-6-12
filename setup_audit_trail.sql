-- ============================================================================
-- NHẬT KÝ HOẠT ĐỘNG ĐẦY ĐỦ (AUDIT TRAIL)
-- Ngày: 2026-07-29
--
-- Mục tiêu: ghi lại MỌI thay đổi dữ liệu ở tầng CSDL, kèm giá trị CŨ -> MỚI
-- của từng trường, và người thực hiện lấy từ phía server (không tin client).
--
-- Trước đây: log ghi ở phía ứng dụng, chỉ lưu giá trị mới, và bỏ sót hoàn
-- toàn các thay đổi đi qua RPC hoặc sửa trực tiếp trên Supabase.
--
-- Bảng dùng: public.user_logs (KHÔNG phải audit_logs — bảng đó đã bị DROP
-- trong fix_security_final.sql).
--
-- CHẠY NGUYÊN FILE NÀY TRONG SUPABASE SQL EDITOR.
-- ============================================================================


-- ----------------------------------------------------------------------------
-- 1. BỔ SUNG CỘT + INDEX CHO user_logs
-- ----------------------------------------------------------------------------

ALTER TABLE public.user_logs
    ADD COLUMN IF NOT EXISTS entity_uuid uuid,          -- id thật, sống sót khi order_code đổi
    ADD COLUMN IF NOT EXISTS source text DEFAULT 'app'; -- 'app' | 'trigger'

-- Index phục vụ màn hình lịch sử của 1 đơn cụ thể
CREATE INDEX IF NOT EXISTS idx_user_logs_entity_created
    ON public.user_logs (entity_id, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_user_logs_entity_uuid
    ON public.user_logs (entity_uuid);


-- ----------------------------------------------------------------------------
-- 2. HÀM PHỤ: đổi UUID thành tên đọc được
--    (để log không hiện chuỗi UUID vô nghĩa cho khách hàng / nhân viên)
-- ----------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION public.audit_label(p_field text, p_value jsonb)
RETURNS jsonb
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    v_txt  text;
    v_name text;
BEGIN
    IF p_value IS NULL OR jsonb_typeof(p_value) = 'null' THEN
        RETURN p_value;
    END IF;

    v_txt := p_value #>> '{}';   -- lấy giá trị dạng text của scalar jsonb
    IF v_txt IS NULL OR v_txt = '' THEN
        RETURN p_value;
    END IF;

    IF p_field = 'customer_id' THEN
        SELECT c.name INTO v_name FROM public.customers c WHERE c.id = v_txt::uuid;
    ELSIF p_field IN ('sales_rep_id', 'payment_confirmed_by', 'user_id') THEN
        SELECT p.full_name INTO v_name FROM public.profiles p WHERE p.id = v_txt::uuid;
    ELSE
        RETURN p_value;
    END IF;

    RETURN to_jsonb(COALESCE(v_name, v_txt));
EXCEPTION WHEN OTHERS THEN
    -- Không được phép làm hỏng việc ghi log chỉ vì tra tên thất bại
    RETURN p_value;
END;
$$;


-- ----------------------------------------------------------------------------
-- 3. HÀM DIFF DÙNG CHUNG
--    So sánh 2 bản ghi dạng jsonb, trả về { "trường": {"old": .., "new": ..} }
--    Trả NULL nếu không có gì thay đổi (để không ghi log rỗng).
--    Gọi với p_old = NULL cho INSERT, p_new = NULL cho DELETE.
-- ----------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION public.audit_build_changes(
    p_old  jsonb,
    p_new  jsonb,
    p_skip text[] DEFAULT ARRAY[]::text[]
)
RETURNS jsonb
LANGUAGE plpgsql
STABLE
AS $$
DECLARE
    v_key    text;
    v_old    jsonb;
    v_new    jsonb;
    v_result jsonb := '{}'::jsonb;
BEGIN
    IF COALESCE(p_new, p_old) IS NULL THEN
        RETURN NULL;
    END IF;

    FOR v_key IN SELECT key FROM jsonb_each(COALESCE(p_new, p_old))
    LOOP
        CONTINUE WHEN v_key = ANY(p_skip);

        -- COALESCE để khoá thiếu (SQL NULL) và giá trị NULL (jsonb 'null')
        -- được coi là như nhau — nếu không, INSERT sẽ ghi cả những cột rỗng.
        v_old := COALESCE(p_old -> v_key, 'null'::jsonb);
        v_new := COALESCE(p_new -> v_key, 'null'::jsonb);

        CONTINUE WHEN v_old IS NOT DISTINCT FROM v_new;

        v_result := v_result || jsonb_build_object(
            v_key,
            jsonb_build_object(
                'old', public.audit_label(v_key, v_old),
                'new', public.audit_label(v_key, v_new)
            )
        );
    END LOOP;

    IF v_result = '{}'::jsonb THEN
        RETURN NULL;
    END IF;
    RETURN v_result;
END;
$$;


-- ----------------------------------------------------------------------------
-- 4. HÀM PHỤ: lấy tên người đang thao tác (phía SERVER, không tin client)
-- ----------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION public.audit_actor_name(p_uid uuid)
RETURNS text
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    v_name text;
BEGIN
    IF p_uid IS NULL THEN
        -- Thay đổi không đi qua ứng dụng (SQL Editor, script, cron...)
        RETURN 'Hệ thống / SQL trực tiếp';
    END IF;
    SELECT COALESCE(p.full_name, p.email) INTO v_name
      FROM public.profiles p WHERE p.id = p_uid;
    RETURN COALESCE(v_name, 'Không rõ');
END;
$$;


-- ----------------------------------------------------------------------------
-- 5. TRIGGER CHO BẢNG orders
--    Giữ nguyên các action_type cũ vì RPC get_daily_report đang phụ thuộc
--    (setup_daily_report.sql đọc 'ORDER_UPDATE_STATUS' + details->>'new_status').
-- ----------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION public.audit_orders()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    v_skip    text[] := ARRAY['updated_at', 'tracking_token', 'payment_random_code'];
    v_changes jsonb;
    v_details jsonb;
    v_action  text;
    v_uid     uuid;
    v_ent_id  text;
    v_ent_uid uuid;
BEGIN
    v_uid := auth.uid();

    -- Gán entity trong từng nhánh thay vì dùng CASE ... NEW.x / OLD.x:
    -- ở trigger DELETE thì NEW không tồn tại, tham chiếu tới nó có thể gây lỗi.
    IF TG_OP = 'INSERT' THEN
        v_changes := public.audit_build_changes(NULL, to_jsonb(NEW), v_skip);
        v_action  := 'ORDER_CREATE';
        v_ent_id  := NEW.order_code;
        v_ent_uid := NEW.id;
    ELSIF TG_OP = 'DELETE' THEN
        v_changes := public.audit_build_changes(to_jsonb(OLD), NULL, v_skip);
        v_action  := 'ORDER_DELETE';
        v_ent_id  := OLD.order_code;
        v_ent_uid := OLD.id;
    ELSE
        v_changes := public.audit_build_changes(to_jsonb(OLD), to_jsonb(NEW), v_skip);
        IF v_changes IS NULL THEN
            RETURN NEW;   -- không có gì đổi thật sự -> không ghi log
        END IF;
        v_ent_id  := NEW.order_code;
        v_ent_uid := NEW.id;

        -- Dùng jsonb_exists/_any thay cho toán tử ? và ?| : một số client SQL
        -- hiểu nhầm dấu ? là placeholder tham số.
        IF jsonb_exists(v_changes, 'status') THEN
            v_action := 'ORDER_UPDATE_STATUS';
        ELSIF jsonb_exists_any(v_changes, ARRAY['payment_status','deposit_amount','remaining_amount','payment_confirmed']) THEN
            v_action := 'PAYMENT_UPDATE';
        ELSE
            v_action := 'ORDER_UPDATE_INFO';
        END IF;
    END IF;

    v_details := jsonb_build_object('changes', COALESCE(v_changes, '{}'::jsonb));

    -- Giữ old_status/new_status ở tầng gốc cho get_daily_report
    IF v_changes IS NOT NULL AND jsonb_exists(v_changes, 'status') THEN
        v_details := v_details || jsonb_build_object(
            'old_status', v_changes -> 'status' ->> 'old',
            'new_status', v_changes -> 'status' ->> 'new'
        );
    END IF;

    INSERT INTO public.user_logs
        (user_id, user_name, action_type, entity_type, entity_id, entity_uuid, details, source)
    VALUES (
        v_uid,
        public.audit_actor_name(v_uid),
        v_action,
        'order',
        v_ent_id,
        v_ent_uid,
        v_details,
        'trigger'
    );

    IF TG_OP = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF;

EXCEPTION WHEN OTHERS THEN
    -- Ghi log hỏng thì tuyệt đối KHÔNG được làm hỏng việc lưu đơn hàng
    RAISE WARNING 'audit_orders bỏ qua do lỗi: %', SQLERRM;
    IF TG_OP = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF;
END;
$$;

DROP TRIGGER IF EXISTS trg_audit_orders ON public.orders;
CREATE TRIGGER trg_audit_orders
    AFTER INSERT OR UPDATE OR DELETE ON public.orders
    FOR EACH ROW EXECUTE FUNCTION public.audit_orders();


-- ----------------------------------------------------------------------------
-- 6. TRIGGER CHO BẢNG customers
--    Bỏ qua các cột do trigger khác tự cập nhật (tier, order_count...) để
--    không sinh log nhiễu mỗi khi có đơn mới.
-- ----------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION public.audit_customers()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    v_skip    text[] := ARRAY['updated_at','order_count','last_order_at','tier','loyalty_points'];
    v_changes jsonb;
    v_action  text;
    v_uid     uuid;
    v_ent_id  text;
    v_ent_uid uuid;
BEGIN
    v_uid := auth.uid();

    IF TG_OP = 'INSERT' THEN
        v_changes := public.audit_build_changes(NULL, to_jsonb(NEW), v_skip);
        v_action  := 'CUSTOMER_CREATE';
        v_ent_id  := COALESCE(NEW.code, NEW.name);
        v_ent_uid := NEW.id;
    ELSIF TG_OP = 'DELETE' THEN
        v_changes := public.audit_build_changes(to_jsonb(OLD), NULL, v_skip);
        v_action  := 'CUSTOMER_DELETE';
        v_ent_id  := COALESCE(OLD.code, OLD.name);
        v_ent_uid := OLD.id;
    ELSE
        v_changes := public.audit_build_changes(to_jsonb(OLD), to_jsonb(NEW), v_skip);
        IF v_changes IS NULL THEN RETURN NEW; END IF;
        v_action  := 'CUSTOMER_UPDATE';
        v_ent_id  := COALESCE(NEW.code, NEW.name);
        v_ent_uid := NEW.id;
    END IF;

    INSERT INTO public.user_logs
        (user_id, user_name, action_type, entity_type, entity_id, entity_uuid, details, source)
    VALUES (
        v_uid,
        public.audit_actor_name(v_uid),
        v_action,
        'customer',
        v_ent_id,
        v_ent_uid,
        jsonb_build_object('changes', COALESCE(v_changes, '{}'::jsonb)),
        'trigger'
    );

    IF TG_OP = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'audit_customers bỏ qua do lỗi: %', SQLERRM;
    IF TG_OP = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF;
END;
$$;

DROP TRIGGER IF EXISTS trg_audit_customers ON public.customers;
CREATE TRIGGER trg_audit_customers
    AFTER INSERT OR UPDATE OR DELETE ON public.customers
    FOR EACH ROW EXECUTE FUNCTION public.audit_customers();


-- ----------------------------------------------------------------------------
-- 7. TRIGGER CHO BẢNG profiles (nhân viên)
-- ----------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION public.audit_profiles()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    v_skip    text[] := ARRAY['updated_at'];
    v_changes jsonb;
    v_action  text;
    v_uid     uuid;
    v_ent_id  text;
    v_ent_uid uuid;
BEGIN
    v_uid := auth.uid();

    IF TG_OP = 'INSERT' THEN
        v_changes := public.audit_build_changes(NULL, to_jsonb(NEW), v_skip);
        v_action  := 'EMPLOYEE_CREATE';
        v_ent_id  := COALESCE(NEW.full_name, NEW.email);
        v_ent_uid := NEW.id;
    ELSIF TG_OP = 'DELETE' THEN
        v_changes := public.audit_build_changes(to_jsonb(OLD), NULL, v_skip);
        v_action  := 'EMPLOYEE_DELETE';
        v_ent_id  := COALESCE(OLD.full_name, OLD.email);
        v_ent_uid := OLD.id;
    ELSE
        v_changes := public.audit_build_changes(to_jsonb(OLD), to_jsonb(NEW), v_skip);
        IF v_changes IS NULL THEN RETURN NEW; END IF;
        v_action  := 'EMPLOYEE_UPDATE';
        v_ent_id  := COALESCE(NEW.full_name, NEW.email);
        v_ent_uid := NEW.id;
    END IF;

    INSERT INTO public.user_logs
        (user_id, user_name, action_type, entity_type, entity_id, entity_uuid, details, source)
    VALUES (
        v_uid,
        public.audit_actor_name(v_uid),
        v_action,
        'employee',
        v_ent_id,
        v_ent_uid,
        jsonb_build_object('changes', COALESCE(v_changes, '{}'::jsonb)),
        'trigger'
    );

    IF TG_OP = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'audit_profiles bỏ qua do lỗi: %', SQLERRM;
    IF TG_OP = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF;
END;
$$;

DROP TRIGGER IF EXISTS trg_audit_profiles ON public.profiles;
CREATE TRIGGER trg_audit_profiles
    AFTER INSERT OR UPDATE OR DELETE ON public.profiles
    FOR EACH ROW EXECUTE FUNCTION public.audit_profiles();


-- ----------------------------------------------------------------------------
-- 8. TRIGGER CHO order_process_participants (tham gia / rời công đoạn)
--    Giữ nguyên tên STAGE_JOIN / STAGE_LEAVE và details.stage để màn hình
--    Lịch sử HĐ và get_daily_report hoạt động như cũ.
-- ----------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION public.audit_stage_participants()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    v_uid      uuid;
    v_action   text;
    v_order_id uuid;
    v_stage    text;
    v_worker   uuid;
    v_code     text;
BEGIN
    v_uid := auth.uid();

    IF TG_OP = 'DELETE' THEN
        v_action := 'STAGE_LEAVE';
        v_order_id := OLD.order_id; v_stage := OLD.stage; v_worker := OLD.user_id;
    ELSIF TG_OP = 'INSERT' THEN
        v_action := 'STAGE_JOIN';
        v_order_id := NEW.order_id; v_stage := NEW.stage; v_worker := NEW.user_id;
    ELSE
        RETURN NEW;   -- không quan tâm UPDATE trên bảng này
    END IF;

    SELECT o.order_code INTO v_code FROM public.orders o WHERE o.id = v_order_id;

    INSERT INTO public.user_logs
        (user_id, user_name, action_type, entity_type, entity_id, entity_uuid, details, source)
    VALUES (
        COALESCE(v_uid, v_worker),
        public.audit_actor_name(COALESCE(v_uid, v_worker)),
        v_action,
        'order',
        COALESCE(v_code, v_order_id::text),
        v_order_id,
        jsonb_build_object(
            'stage', v_stage,
            'nguoi_thuc_hien', public.audit_actor_name(v_worker)
        ),
        'trigger'
    );

    IF TG_OP = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF;

EXCEPTION WHEN OTHERS THEN
    RAISE WARNING 'audit_stage_participants bỏ qua do lỗi: %', SQLERRM;
    IF TG_OP = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF;
END;
$$;

DROP TRIGGER IF EXISTS trg_audit_stage_participants ON public.order_process_participants;
CREATE TRIGGER trg_audit_stage_participants
    AFTER INSERT OR DELETE ON public.order_process_participants
    FOR EACH ROW EXECUTE FUNCTION public.audit_stage_participants();


-- ----------------------------------------------------------------------------
-- 9. BỊT LỖ MẠO DANH + KHOÁ CHỈ-THÊM
--    Trước đây policy INSERT là WITH CHECK (true): bất kỳ ai cũng ghi được
--    log dưới tên người khác. Đó là lý do nhật ký không dùng để đối chất được.
-- ----------------------------------------------------------------------------

DROP POLICY IF EXISTS "Authenticated users can insert logs" ON public.user_logs;
DROP POLICY IF EXISTS "Users can only insert their own logs" ON public.user_logs;
CREATE POLICY "Users can only insert their own logs"
    ON public.user_logs FOR INSERT
    TO authenticated
    WITH CHECK (user_id = auth.uid());

-- Không ai được sửa/xoá nhật ký. Trigger chạy SECURITY DEFINER (chủ sở hữu
-- bảng) nên vẫn ghi được. LƯU Ý: tuyệt đối KHÔNG bật FORCE ROW LEVEL SECURITY
-- trên bảng này, nếu bật thì trigger sẽ bị chính RLS chặn.
REVOKE UPDATE, DELETE ON public.user_logs FROM authenticated;
REVOKE UPDATE, DELETE ON public.user_logs FROM anon;

-- Policy SELECT giữ nguyên bản mới nhất (fix_final_type_error.sql):
-- chỉ Admin / KeToan / QuanLySanXuat được xem.


-- ----------------------------------------------------------------------------
-- 10. RPC ĐỌC NHẬT KÝ
--     - Join profiles để lấy TÊN HIỆN TẠI (cột user_name là ảnh chụp lúc ghi,
--       đổi tên nhân viên là log cũ hiện sai).
--     - Có phân trang (trước đây bị chặn cứng 100 dòng).
--     - Lọc entity_id bằng khớp chính xác / tiền tố thay cho ilike '%..%'
--       (ilike không dùng được index và khiến DH-1 khớp luôn DH-10).
-- ----------------------------------------------------------------------------

DROP FUNCTION IF EXISTS public.get_activity_logs(uuid, text, text, text, timestamptz, timestamptz, int, int);

CREATE OR REPLACE FUNCTION public.get_activity_logs(
    p_user_id     uuid        DEFAULT NULL,
    p_action_type text        DEFAULT NULL,
    p_entity_type text        DEFAULT NULL,
    p_entity_id   text        DEFAULT NULL,
    p_start       timestamptz DEFAULT NULL,
    p_end         timestamptz DEFAULT NULL,
    p_limit       int         DEFAULT 50,
    p_offset      int         DEFAULT 0
)
RETURNS TABLE (
    id          uuid,
    created_at  timestamptz,
    user_id     uuid,
    user_name   text,
    user_role   text,
    action_type text,
    entity_type text,
    entity_id   text,
    entity_uuid uuid,
    details     jsonb,
    source      text,
    total_count bigint
)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
    WITH filtered AS (
        SELECT
            ul.id, ul.created_at, ul.user_id,
            COALESCE(p.full_name, p.email, ul.user_name, 'Không rõ') AS actor_name,
            p.role::text AS actor_role,
            ul.action_type, ul.entity_type, ul.entity_id, ul.entity_uuid,
            ul.details, ul.source
        FROM public.user_logs ul
        LEFT JOIN public.profiles p ON p.id = ul.user_id
        WHERE
            -- SECURITY DEFINER bỏ qua RLS nên phải tự kiểm tra quyền ở đây
            EXISTS (
                SELECT 1 FROM public.profiles me
                WHERE me.id = auth.uid()
                  AND me.role::text IN ('Admin', 'KeToan', 'QuanLySanXuat')
            )
            AND (p_user_id     IS NULL OR ul.user_id     = p_user_id)
            AND (p_action_type IS NULL OR ul.action_type = p_action_type)
            AND (p_entity_type IS NULL OR ul.entity_type = p_entity_type)
            AND (p_entity_id   IS NULL OR ul.entity_id   = p_entity_id
                                       OR ul.entity_id LIKE p_entity_id || '%')
            AND (p_start       IS NULL OR ul.created_at >= p_start)
            AND (p_end         IS NULL OR ul.created_at <= p_end)
    )
    SELECT
        f.id, f.created_at, f.user_id, f.actor_name, f.actor_role,
        f.action_type, f.entity_type, f.entity_id, f.entity_uuid,
        f.details, f.source,
        COUNT(*) OVER () AS total_count
    FROM filtered f
    ORDER BY f.created_at DESC
    LIMIT GREATEST(COALESCE(p_limit, 50), 1)
    OFFSET GREATEST(COALESCE(p_offset, 0), 0);
$$;

GRANT EXECUTE ON FUNCTION public.get_activity_logs(uuid, text, text, text, timestamptz, timestamptz, int, int) TO authenticated;


-- ----------------------------------------------------------------------------
-- 11. KIỂM TRA
-- ----------------------------------------------------------------------------

SELECT 'Đã cài đặt nhật ký hoạt động. Các trigger hiện có:' AS ket_qua;

SELECT c.relname AS bang, t.tgname AS trigger_name
FROM pg_trigger t
JOIN pg_class c ON c.oid = t.tgrelid
WHERE NOT t.tgisinternal
  AND t.tgname LIKE 'trg_audit_%'
ORDER BY c.relname;

NOTIFY pgrst, 'reload schema';
