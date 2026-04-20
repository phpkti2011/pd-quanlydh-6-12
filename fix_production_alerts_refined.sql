-- Refined Production Alerts (Fixes Enum Error + Adds Design Specificity)

CREATE OR REPLACE FUNCTION get_production_alerts()
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    urgent_sos JSON;
    bottlenecks JSON;
BEGIN
    -- A. Urgent SOS
    SELECT json_agg(t) INTO urgent_sos
    FROM (
        SELECT id, order_code, status, delivery_date, 'ĐƠN GẤP CẦN XỬ LÝ NGAY' as alert_msg
        FROM orders
        WHERE is_urgent = true
        AND status NOT IN ('HoanThanh', 'GiaoHang', 'DaGiaoHang', 'Huy')
        AND delivery_date <= CURRENT_DATE
    ) t;

    -- B. Bottlenecks (Fix: Enum 'ThietKe' removed)
    -- Logic: If has_design is true, we call it "Chậm Thiết kế". Otherwise "Chậm Xử lý file/Bình file".
    -- We check the valid enum statuses: TiepNhan, NhanFile, XuLyFile, BinhFile
    SELECT json_agg(t) INTO bottlenecks
    FROM (
        SELECT 
            id, 
            order_code, 
            status, 
            created_at, 
            CASE 
                WHEN has_design = true THEN 'Chậm Thiết kế (> 2 ngày)'
                ELSE 'Chậm Xử lý/Bình file (> 2 ngày)'
            END as alert_msg
        FROM orders
        WHERE status IN ('TiepNhan', 'NhanFile', 'XuLyFile', 'BinhFile')
        AND created_at < NOW() - INTERVAL '2 days'
    ) t;

    RETURN json_build_object(
        'urgent', COALESCE(urgent_sos, '[]'::json),
        'bottleneck', COALESCE(bottlenecks, '[]'::json)
    );
END;
$$;
