-- DEBUG: Find ALL activities for Ngô Thanh Vân to see why they are missing from the report
-- Check: Order Status, Dates, etc.

SELECT 
    p.full_name,
    o.order_code,
    part.stage,
    part.started_at,
    part.finished_at,
    o.status as order_status,
    o.created_at as order_created_at,
    o.delivery_date as order_delivery_date,
    COALESCE(o.delivery_date, o.created_at)::DATE as report_date,
    -- Check if it matches the report filter (Jan 2026 + Completed)
    CASE 
        WHEN o.status NOT IN ('HoanThanh', 'DaGiaoHang') THEN 'Excluded: Order Not Completed'
        WHEN COALESCE(o.delivery_date, o.created_at)::DATE < '2026-01-01' THEN 'Excluded: Too Old'
        WHEN COALESCE(o.delivery_date, o.created_at)::DATE > '2026-01-31' THEN 'Excluded: Future Date'
        ELSE 'Should Appear'
    END as status_check
FROM order_process_participants part
JOIN profiles p ON part.user_id = p.id
JOIN orders o ON part.order_id = o.id
WHERE p.full_name ILIKE '%Thanh Vân%'
ORDER BY part.started_at DESC;
