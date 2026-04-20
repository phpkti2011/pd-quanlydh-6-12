-- DEBUG: Find out why Total Commission is 5,648,178
-- This query lists ALL activities for Bùi Văn Nghĩa in Jan 2026, including hidden ones.

SELECT 
    order_code,
    stage,
    rate_val as "Rate (%)",
    debug_stage_val as "Stage Value",
    process_comm as "Thưởng Main",
    stage_comm as "Thưởng Sub",
    total_comm as "Tổng dòng"
FROM get_staff_activity_details('2026-01-01', '2026-02-01', 'Bùi Văn Nghĩa')
ORDER BY total_comm DESC;
