-- DEBUG V2: Find out why Total Commission is 5,648,178
-- Using ILIKE to ignore case sensitivity (Bùi Văn Nghĩa vs Bùi văn Nghĩa)

SELECT 
    order_code,
    stage,
    rate_val as "Rate (%)",
    debug_stage_val as "Stage Value",
    process_comm as "Thưởng Main",
    stage_comm as "Thưởng Sub",
    total_comm as "Tổng dòng"
FROM get_staff_activity_details('2026-01-01', '2026-02-01', NULL) -- Pass NULL name first
WHERE user_name ILIKE '%Bùi văn Nghĩa%' -- Filter manually to be safe
ORDER BY total_comm DESC;
