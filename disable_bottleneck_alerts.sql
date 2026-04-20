-- Disable Bottleneck/Delay Alerts (Keep Urgent Only)

CREATE OR REPLACE FUNCTION get_production_alerts()
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    urgent_sos JSON;
    -- bottlenecks JSON; -- Removed
BEGIN
    -- A. Urgent SOS (Keep this)
    SELECT json_agg(t) INTO urgent_sos
    FROM (
        SELECT id, order_code, status, delivery_date, 'ĐƠN GẤP CẦN XỬ LÝ NGAY' as alert_msg
        FROM orders
        WHERE is_urgent = true
        AND status NOT IN ('HoanThanh', 'GiaoHang', 'DaGiaoHang', 'Huy')
        AND delivery_date <= CURRENT_DATE
    ) t;

    -- B. Bottlenecks (DISABLED)
    -- User requested to remove "Late Design/Processing" alerts.
    -- Returning empty array.
    
    RETURN json_build_object(
        'urgent', COALESCE(urgent_sos, '[]'::json),
        'bottleneck', '[]'::json -- Always empty
    );
END;
$$;
