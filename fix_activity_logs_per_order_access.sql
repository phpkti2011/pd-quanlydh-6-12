-- ==============================================================================
-- Mọi nhân viên (trừ 'Khach') được xem LỊCH SỬ TỪNG ĐƠN  (+ sửa lỗi "statement timeout")
-- Chạy tay trong Supabase Dashboard -> SQL Editor, TRƯỚC khi deploy frontend.
-- Chạy lại nhiều lần an toàn (IF NOT EXISTS / CREATE OR REPLACE).
--
-- Chỉ thay thân hàm get_activity_logs (cùng chữ ký) và thêm 1 index. Bản gốc cũng đã
-- sửa trong setup_audit_trail.sql mục 10, hai bản GIỐNG NHAU. Không đụng bảng/policy/
-- trigger, không có CREATE TABLE nên không cần GRANT mới.
--
-- Quyền sau khi chạy:
--   * Admin / KeToan / QuanLySanXuat : xem toàn bộ nhật ký (như cũ).
--   * Nhân viên khác (không phải 'Khach'): chỉ xem nhật ký đơn hàng khi truyền
--     p_entity_id khớp CHÍNH XÁC mã đơn. Bỏ trống hoặc gõ tiền tố -> 0 dòng.
--
-- VÌ SAO TIMEOUT: điều kiện "entity_id = X OR entity_id LIKE X%" viết trong hàm SQL
-- thì Postgres không dùng được index nào (LIKE cần index text_pattern_ops, và hàm SQL
-- không biết trước giá trị tham số) nên quét cả bảng user_logs. Bảng càng lớn càng chậm
-- cho tới khi vượt giới hạn thời gian. Bản mới: hàm plpgsql (kế hoạch được lập theo giá
-- trị thật) + index tiền tố, nên tra 1 đơn chỉ chạm vài dòng.
-- ==============================================================================

-- Index cho tìm tiền tố mã đơn (LIKE 'abc%'). Index (entity_id, created_at) có sẵn vẫn
-- phục vụ khớp chính xác.
CREATE INDEX IF NOT EXISTS idx_user_logs_entity_prefix
    ON public.user_logs (entity_id text_pattern_ops);

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
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
#variable_conflict use_column
DECLARE
    v_priv  boolean;  -- Admin / KeToan / QuanLySanXuat: xem toàn bộ nhật ký
    v_staff boolean;  -- nhân viên khác (không phải 'Khach'): chỉ xem 1 đơn
BEGIN
    -- SECURITY DEFINER bỏ qua RLS nên phải tự kiểm tra quyền ở đây
    SELECT COALESCE(bool_or(me.role::text IN ('Admin', 'KeToan', 'QuanLySanXuat')), false),
           COALESCE(bool_or(me.role::text <> 'Khach'), false)
      INTO v_priv, v_staff
      FROM public.profiles me
     WHERE me.id = auth.uid();

    IF NOT v_priv THEN
        -- Nhân viên thường: bắt buộc truyền mã đơn (khớp CHÍNH XÁC, không tiền tố) để
        -- không dò được nhật ký toàn hệ thống. Khách / người lạ: không có gì.
        IF NOT v_staff OR p_entity_id IS NULL THEN
            RETURN;
        END IF;
    END IF;

    RETURN QUERY
    WITH filtered AS (
        SELECT
            ul.id, ul.created_at, ul.user_id,
            COALESCE(p.full_name, p.email, ul.user_name, 'Không rõ') AS actor_name,
            p.role::text AS actor_role,
            ul.action_type, ul.entity_type, ul.entity_id, ul.entity_uuid,
            ul.details, ul.source
        FROM public.user_logs ul
        LEFT JOIN public.profiles p ON p.id = ul.user_id
        WHERE (v_priv OR ul.entity_type = 'order')
          AND (p_user_id     IS NULL OR ul.user_id     = p_user_id)
          AND (p_action_type IS NULL OR ul.action_type = p_action_type)
          AND (p_entity_type IS NULL OR ul.entity_type = p_entity_type)
          AND (p_entity_id   IS NULL OR ul.entity_id   = p_entity_id
                                     OR (v_priv AND ul.entity_id LIKE p_entity_id || '%'))
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
END;
$$;

GRANT EXECUTE ON FUNCTION public.get_activity_logs(uuid, text, text, text, timestamptz, timestamptz, int, int) TO authenticated;

NOTIFY pgrst, 'reload schema';
