-- ============================================================
-- REVENUE TREND FUNCTION
-- Trả về doanh thu N ngày gần nhất, dùng cho Line chart trong
-- DailyReportModal. Loại Huy. Theo created_at.
-- Chạy trong Supabase SQL Editor.
-- ============================================================

DROP FUNCTION IF EXISTS get_revenue_trend(INT, DATE);

CREATE OR REPLACE FUNCTION get_revenue_trend(
    p_days INT DEFAULT 7,
    p_end_date DATE DEFAULT CURRENT_DATE
)
RETURNS JSON AS $$
DECLARE
    v_result JSON;
BEGIN
    SELECT json_agg(row_to_json(t) ORDER BY t.date ASC)
    INTO v_result
    FROM (
        SELECT
            d::DATE AS date,
            COALESCE((
                SELECT SUM(total_amount_pre_vat) FROM orders
                WHERE created_at >= d::timestamptz
                  AND created_at < (d + 1)::timestamptz
                  AND status::text NOT IN ('Huy')
            ), 0) AS revenue_pre_vat,
            COALESCE((
                SELECT SUM(total_amount) FROM orders
                WHERE created_at >= d::timestamptz
                  AND created_at < (d + 1)::timestamptz
                  AND status::text NOT IN ('Huy')
            ), 0) AS revenue_total
        FROM generate_series(
            p_end_date - (p_days - 1),
            p_end_date,
            interval '1 day'
        ) AS d
    ) t;

    RETURN COALESCE(v_result, '[]'::json);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

NOTIFY pgrst, 'reload schema';
