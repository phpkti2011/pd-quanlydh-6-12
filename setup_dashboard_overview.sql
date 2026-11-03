-- ==============================================================================
-- get_dashboard_overview — NGUỒN DUY NHẤT của số liệu màn "Tổng quan"
--
-- Vì sao có hàm này:
--   Trước đây dashboardService.ts kéo TỪNG DÒNG đơn về trình duyệt rồi cộng ở đó.
--   Supabase cắt ở 1.000 dòng/truy vấn nên xem nhiều tháng (vd 01/06 -> 31/10 có
--   3.803 đơn) thì chỉ cộng được 1.000 đơn đầu: mọi số đều thiếu, không báo lỗi.
--   Giờ Postgres tự cộng rồi chỉ trả về một JSON nhỏ, nên xem 1 tháng hay 12
--   tháng đều nhanh như nhau và không bị giới hạn 1.000 dòng.
--
-- Quy tắc (chuyển nguyên từ dashboardService.ts, đây là bản logic DUY NHẤT):
--   * Loại đơn Huy khỏi mọi con số.
--   * Đơn sản xuất lại (rework_of_order_id IS NOT NULL): KHÔNG đếm số đơn, chỉ TRỪ
--     rework_cost khỏi doanh thu (CLAUDE.md).
--   * Doanh số hoàn thành / doanh số NVKD: cùng quy tắc mốc 01/03/2026 với
--     calculate_sales_commission() và production_revenue_in_period():
--       đơn tạo trước 01/03/2026 tính theo created_at,
--       đơn tạo từ 01/03/2026 tính theo completed_at.
--   * Ngày trong biểu đồ gom theo GIỜ VIỆT NAM (bản TypeScript cũ gom theo UTC
--     nên đơn tạo 0h-7h sáng bị nhảy sang ngày hôm trước).
--
-- SECURITY INVOKER (mặc định) CỐ Ý: hàm đọc bảng orders / customers / profiles
-- bằng quyền của người đang đăng nhập, nên RLS giữ nguyên như khi giao diện tự
-- truy vấn. Đừng đổi thành SECURITY DEFINER, sẽ lộ doanh thu toàn công ty cho
-- mọi vai trò.
--
-- Lưu ý: db_dashboard.sql, db_dashboard_v2.sql, fix_dashboard_revenue_function.sql,
-- fix_revenue_final_v3.sql có hàm get_dashboard_stats* cũ. Giao diện không gọi
-- chúng nữa; ĐỪNG chạy lại.
--
-- Chạy trong Supabase SQL Editor. Chỉ file này. Chạy XONG rồi mới deploy giao
-- diện Tổng quan (dashboardService.ts gọi hàm này).
-- ==============================================================================

-- Tìm "đơn đầu tiên từ trước tới nay của khách" (khách mới / quay lại)
CREATE INDEX IF NOT EXISTS idx_orders_customer_created ON orders(customer_id, created_at);
CREATE INDEX IF NOT EXISTS idx_orders_completed_at ON orders(completed_at);

CREATE OR REPLACE FUNCTION get_dashboard_overview(
    p_start TIMESTAMPTZ,
    p_end   TIMESTAMPTZ
)
RETURNS JSONB
LANGUAGE plpgsql
STABLE
SET search_path = public
AS $$
DECLARE
    v_cutoff CONSTANT DATE := DATE '2026-03-01';
    v_d1     DATE := (p_start AT TIME ZONE 'Asia/Ho_Chi_Minh')::DATE;
    v_d2     DATE := (p_end   AT TIME ZONE 'Asia/Ho_Chi_Minh')::DATE;
    v_result JSONB;
BEGIN
    IF p_start IS NULL OR p_end IS NULL OR p_end < p_start THEN
        RAISE EXCEPTION 'Khoảng thời gian không hợp lệ';
    END IF;

    WITH
    -- Mọi đơn tạo trong kỳ
    period_orders AS (
        SELECT
            o.id, o.customer_id, o.sales_rep_id, o.order_code, o.created_at,
            o.status::TEXT AS status,
            COALESCE(o.is_urgent, FALSE) AS is_urgent,
            COALESCE(o.total_amount, 0) AS total_amount,
            COALESCE(o.vat_amount, 0) AS vat_amount,
            COALESCE(o.design_fee, 0) AS design_fee,
            COALESCE(o.large_print_fee, 0) AS large_print_fee,
            COALESCE(o.has_design, FALSE) AS has_design,
            COALESCE(o.has_large_print, FALSE) AS has_large_print,
            o.rework_of_order_id,
            COALESCE(o.rework_cost, 0) AS rework_cost
        FROM orders o
        WHERE o.created_at >= p_start AND o.created_at <= p_end
    ),
    -- Đơn thường còn hiệu lực: đếm số đơn, doanh thu, biểu đồ, khách hàng
    normal AS (
        SELECT * FROM period_orders
        WHERE rework_of_order_id IS NULL AND status <> 'Huy'
    ),
    -- Chi phí làm lại của đơn sản xuất lại (trừ vào doanh thu)
    rework AS (
        SELECT COALESCE(SUM(rework_cost), 0) AS cost
        FROM period_orders
        WHERE rework_of_order_id IS NOT NULL AND status <> 'Huy'
    ),
    daily AS (
        SELECT d::DATE AS day, COALESCE(SUM(n.total_amount), 0) AS revenue
        FROM generate_series(v_d1::TIMESTAMP, v_d2::TIMESTAMP, INTERVAL '1 day') AS d
        LEFT JOIN normal n ON (n.created_at AT TIME ZONE 'Asia/Ho_Chi_Minh')::DATE = d::DATE
        GROUP BY d
    ),
    -- Đơn đầu tiên từ trước tới nay (không tính Huy) của các khách có đơn trong kỳ
    first_orders AS (
        SELECT DISTINCT ON (o.customer_id) o.customer_id, o.id AS first_id
        FROM orders o
        WHERE o.customer_id IN (SELECT DISTINCT customer_id FROM normal WHERE customer_id IS NOT NULL)
          AND o.status <> 'Huy'
        ORDER BY o.customer_id, o.created_at ASC, o.id
    ),
    -- Khách mới: đơn đầu tiên của khách nằm trong kỳ
    new_orders AS (
        SELECT n.* FROM normal n JOIN first_orders f ON f.first_id = n.id
    ),
    -- Khách quay lại: có đơn trong kỳ không phải đơn đầu tiên (mỗi khách tính một lần)
    returning_customers AS (
        SELECT DISTINCT n.customer_id
        FROM normal n JOIN first_orders f ON f.customer_id = n.customer_id
        WHERE n.id <> f.first_id
    ),
    -- Doanh số hoàn thành chưa VAT, trừ chi phí làm lại (quy tắc mốc 01/03/2026)
    completed AS (
        SELECT COALESCE(SUM(COALESCE(o.total_amount_pre_vat, 0) - COALESCE(o.rework_cost, 0)), 0) AS amount
        FROM orders o
        WHERE o.status = 'HoanThanh'
          AND (
              (o.created_at::DATE < v_cutoff AND o.created_at::DATE >= v_d1 AND o.created_at::DATE <= v_d2)
              OR
              (o.created_at::DATE >= v_cutoff AND o.completed_at IS NOT NULL
               AND o.completed_at::DATE >= v_d1 AND o.completed_at::DATE <= v_d2)
          )
    ),
    -- Doanh số chưa VAT theo NVKD (cùng quy tắc với calculate_sales_commission)
    by_employee AS (
        SELECT p.full_name AS name, SUM(COALESCE(o.total_amount_pre_vat, 0)) AS sales
        FROM orders o
        JOIN profiles p ON p.id = o.sales_rep_id
        WHERE o.status = 'HoanThanh'
          AND o.rework_of_order_id IS NULL
          AND (
              (o.created_at::DATE < v_cutoff AND o.created_at::DATE >= v_d1 AND o.created_at::DATE <= v_d2)
              OR
              (o.created_at::DATE >= v_cutoff AND o.completed_at IS NOT NULL
               AND o.completed_at::DATE >= v_d1 AND o.completed_at::DATE <= v_d2)
          )
        GROUP BY p.full_name
    )
    SELECT jsonb_build_object(
        'metrics', jsonb_build_object(
            'ordersCount', (SELECT COUNT(*) FROM normal),
            'revenueWithVAT', (SELECT COALESCE(SUM(total_amount), 0) FROM normal) - (SELECT cost FROM rework),
            'revenueNoVAT', (SELECT COALESCE(SUM(total_amount - vat_amount), 0) FROM normal) - (SELECT cost FROM rework),
            'designRevenue', (SELECT COALESCE(SUM(design_fee) FILTER (WHERE has_design), 0) FROM normal),
            'largePrintRevenue', (SELECT COALESCE(SUM(large_print_fee) FILTER (WHERE has_large_print), 0) FROM normal),
            'newCustomersCount', (SELECT COUNT(*) FROM new_orders),
            'returningCustomersCount', (SELECT COUNT(*) FROM returning_customers),
            'completedRevenueNoVAT', (SELECT amount FROM completed)
        ),
        'dailyRevenue', COALESCE(
            (SELECT jsonb_agg(jsonb_build_object('date', to_char(day, 'YYYY-MM-DD'), 'revenue', revenue) ORDER BY day) FROM daily),
            '[]'::JSONB),
        'statusCounts', COALESCE(
            (SELECT jsonb_object_agg(status, cnt) FROM (SELECT status, COUNT(*) AS cnt FROM normal GROUP BY status) s),
            '{}'::JSONB),
        'sourceCounts', COALESCE(
            (SELECT jsonb_object_agg(source, cnt)
             FROM (SELECT c.source, COUNT(*) AS cnt
                   FROM normal n JOIN customers c ON c.id = n.customer_id
                   WHERE c.source IS NOT NULL AND c.source <> ''
                   GROUP BY c.source) s),
            '{}'::JSONB),
        'salesByEmployee', COALESCE(
            (SELECT jsonb_agg(jsonb_build_object('name', name, 'sales', sales) ORDER BY sales DESC) FROM by_employee),
            '[]'::JSONB),
        'newCustomersList', COALESCE(
            (SELECT jsonb_agg(jsonb_build_object(
                        'customer_id', n.customer_id,
                        'customer_name', COALESCE(c.name, 'N/A'),
                        'customer_phone', COALESCE(c.phone, ''),
                        'customer_source', COALESCE(c.source, ''),
                        'first_order_code', COALESCE(n.order_code, ''),
                        'first_order_date', n.created_at,
                        'sales_rep', COALESCE(p.full_name, '')
                    ) ORDER BY n.created_at DESC)
             FROM new_orders n
             LEFT JOIN customers c ON c.id = n.customer_id
             LEFT JOIN profiles p ON p.id = n.sales_rep_id),
            '[]'::JSONB),
        -- Đơn chưa hoàn thành: chỉ các cột bảng cần. Gồm cả đơn sản xuất lại.
        'incompleteOrders', COALESCE(
            (SELECT jsonb_agg(jsonb_build_object(
                        'id', po.id,
                        'status', po.status,
                        'is_urgent', po.is_urgent,
                        'rework_of_order_id', po.rework_of_order_id,
                        'order_code', po.order_code,
                        'total_amount', po.total_amount,
                        'created_at', po.created_at,
                        'customer', CASE WHEN c.id IS NULL THEN NULL
                                         ELSE jsonb_build_object('id', c.id, 'name', c.name) END,
                        'sales_rep', CASE WHEN p.id IS NULL THEN NULL
                                          ELSE jsonb_build_object('full_name', p.full_name) END
                    ) ORDER BY po.is_urgent DESC, po.created_at DESC)
             FROM period_orders po
             LEFT JOIN customers c ON c.id = po.customer_id
             LEFT JOIN profiles p ON p.id = po.sales_rep_id
             WHERE po.status NOT IN ('HoanThanh', 'Huy', 'TamNgung')),
            '[]'::JSONB)
    ) INTO v_result;

    RETURN v_result;
END;
$$;

GRANT EXECUTE ON FUNCTION get_dashboard_overview(TIMESTAMPTZ, TIMESTAMPTZ) TO authenticated;

NOTIFY pgrst, 'reload schema';

-- ==============================================================================
-- KIỂM TRA SAU KHI CHẠY (chạy riêng):
--   SELECT get_dashboard_overview('2026-05-31 17:00+00', '2026-10-31 16:59:59.999+00')->'metrics';
-- Kỳ 01/06 -> 31/10/2026 có 3.803 đơn tạo (gồm cả đơn Huy/làm lại), nên 'ordersCount'
-- phải gần con số đó (nhỏ hơn đúng bằng số đơn Huy + đơn làm lại), không bị dừng ở 1.000.
-- ==============================================================================
