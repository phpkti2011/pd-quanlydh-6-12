-- ============================================================================
-- FIX: Khâu "chưa cấu hình" không được ăn mức hoa hồng chung nữa
-- ============================================================================
-- TRIỆU CHỨNG
--   Nhân viên Trần Trinh Y có ô "In ấn" = 0 trong tab Hoa hồng Quy trình
--   (Quản lý Nhân Viên -> Chỉnh sửa), nhưng báo cáo Thưởng HHSX vẫn tính
--   hoa hồng khâu In ấn cho cô ấy.
--
-- NGUYÊN NHÂN
--   Ô hiển thị 0 nhưng trong CSDL KHÔNG HỀ CÓ key 'In'. Giao diện dùng
--   `commission_stages?.[key] || 0` nên "chưa cấu hình" trông y hệt số 0 thật,
--   và chỉ ô nào Admin gõ tay vào mới được ghi xuống.
--
--   Hàm get_staff_commission_rows dùng COALESCE nên không phân biệt được
--   "key không tồn tại" với "chưa cấu hình", rơi thẳng xuống mức chung:
--
--       COALESCE((p.commission_stages->>part.stage)::NUMERIC, cp_proc.rate, 0)
--
--   MAINTASK_RATE/In = 20, công thức là
--       (giá trị đơn / số người) * (rate/100) * điểm năng lực
--   -> 20/100 * 3.5 = 0,7 = 70% phần đơn. Đây là lý do con số bất thường.
--
--   Ảnh hưởng nhiều người, không riêng Trần Trinh Y: mọi NV có
--   commission_stages thiếu key đều rò rỉ mức chung.
--
-- CÁCH SỬA
--   Bỏ hẳn fallback về commission_policies. Không có key trong JSON => 0.
--   Xoá luôn 2 LEFT JOIN commission_policies (chỉ dùng cho fallback đó).
--
-- LƯU Ý
--   * PHẢI chạy backfill_commission_stages_zero.sql NGAY SAU file này, trong
--     cùng một lượt. Ba khâu EpKim (mức chung 15), DaGiaoHang (5) và BeDemi (2)
--     xưa nay không có ô cấu hình trong modal nên mọi người đều ăn mức chung;
--     giữa 2 bước chúng tạm về 0, và backfill là thứ điền lại đúng mức đang
--     chạy để không ai bị giảm tiền.
--   * Modal nhân viên đã được bổ sung ô cấu hình cho EpKim và DaGiaoHang
--     (components/EmployeeManager.tsx -> STAGE_COMMISSION_FIELDS), nên từ nay
--     Admin chỉnh được trực tiếp cho từng người.
--   * ĐỪNG chạy fix_stage_rate_lookup.sql — file đó cũ, thân hàm còn dùng
--     delivery_date, status IN ('HoanThanh','DaGiaoHang'), chưa có bậc sản
--     lượng và chưa có trừ sai hỏng. Chạy nó sẽ làm mất các tính năng đó.
--
-- Chữ ký hàm không đổi (DATE, DATE) nên CREATE OR REPLACE là đủ, không cần
-- DROP. get_staff_activity_details và calculate_staff_commission gọi lại hàm
-- này nên tự động đúng theo, không phải deploy lại.
-- ============================================================================

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

NOTIFY pgrst, 'reload schema';

-- ============================================================================
-- KIỂM TRA SAU KHI CHẠY
-- ============================================================================
-- 1. Không còn tham chiếu commission_policies trong hàm (chỉ còn trong comment):
--    SELECT prosrc FROM pg_proc WHERE proname = 'get_staff_commission_rows';
--
-- 2. Các dòng khâu 'In' của Trần Trinh Y phải = 0 (thay <thang>/<nam>):
--    SELECT full_name, order_code, stage, row_total
--    FROM get_staff_commission_rows('2026-08-01', '2026-08-31')
--    WHERE full_name = 'Trần Trinh Y' AND stage = 'In';
--
-- 3. Người đã cấu hình tường minh "In": 0 (VD Trần Hải Âu) KHÔNG được đổi số.
-- ============================================================================
