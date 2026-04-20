-- DEBUG: Check Ngô Thanh Vân's commission for 'Đóng gói' (DongGoi)
-- Order: 26PD3001.0703

-- 1. Check Profile Configuration
SELECT 
    id, 
    full_name, 
    competency_score,
    commission_stages,
    commission_stages->>'DongGoi' as donggoi_rate_json,
    commission_stages ? 'DongGoi' as has_donggoi_key
FROM profiles 
WHERE full_name ILIKE '%Thanh Vân%';

-- 2. Check Order Details
SELECT id, order_code, total_amount_pre_vat 
FROM orders 
WHERE order_code = '26PD3001.0703';

-- 3. Check Stage Contribution Ratio for DongGoi
SELECT * FROM commission_policies 
WHERE apply_to IN ('DongGoi', 'Đóng gói');

-- 4. Trace Calculation for this specific row
SELECT 
    order_code,
    stage,
    participant_count,
    stage_ratio as "Stage Ratio (%)",
    personal_rate as "Personal Rate (%)",
    process_comm as "Calculated Commission",
    total_comm
FROM get_staff_activity_details('2026-01-01', '2026-02-01', NULL)
WHERE user_name ILIKE '%Thanh Vân%'
AND order_code = '26PD3001.0703'
AND stage = 'DongGoi';
