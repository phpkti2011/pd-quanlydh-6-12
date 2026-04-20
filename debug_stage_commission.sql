-- DEBUG: Check why Bùi Văn Nghĩa gets commission for "In" stage when rate is 0%
-- Run this in Supabase SQL Editor

-- 1. Check profile settings
SELECT 
    id, 
    full_name, 
    commission_stages,
    commission_stages->>'In' as in_rate_from_stages,
    commission_subtasks,
    commission_subtasks->>'In' as in_rate_from_subtasks
FROM profiles 
WHERE full_name ILIKE '%Nghĩa%';

-- 2. Check order 26PD0701.0095
SELECT id, order_code, total_amount_pre_vat, status
FROM orders 
WHERE order_code = '26PD0701.0095';

-- 3. Check participants for this order's "In" stage
SELECT 
    opp.*,
    p.full_name,
    p.commission_stages->>'In' as personal_in_rate
FROM order_process_participants opp
JOIN orders o ON opp.order_id = o.id
JOIN profiles p ON opp.user_id = p.id
WHERE o.order_code = '26PD0701.0095'
AND opp.stage = 'In';

-- 4. Check global commission policies for "In"
SELECT * FROM commission_policies WHERE apply_to = 'In';

-- 5. Full calculation trace for this specific case
WITH order_data AS (
    SELECT id, order_code, total_amount_pre_vat 
    FROM orders WHERE order_code = '26PD0701.0095'
),
participation AS (
    SELECT 
        p.id as user_id,
        p.full_name,
        p.commission_stages,
        p.commission_stages->>'In' as personal_in_rate,
        opp.stage,
        o.total_amount_pre_vat,
        COUNT(*) OVER (PARTITION BY opp.order_id, opp.stage) as participant_count
    FROM order_process_participants opp
    JOIN order_data o ON opp.order_id = o.id
    JOIN profiles p ON opp.user_id = p.id
    WHERE opp.stage = 'In'
),
policies AS (
    SELECT rate FROM commission_policies 
    WHERE policy_type = 'MAINTASK_RATE' AND apply_to = 'In'
    LIMIT 1
)
SELECT 
    pt.full_name,
    pt.personal_in_rate,
    pol.rate as global_rate,
    COALESCE(pt.personal_in_rate::NUMERIC, pol.rate, 0) as effective_rate,
    pt.total_amount_pre_vat,
    pt.participant_count,
    -- Calculation
    (pt.total_amount_pre_vat / pt.participant_count) 
        * (COALESCE(pt.personal_in_rate::NUMERIC, pol.rate, 0) / 100.0) 
        * 1.0 as calculated_commission
FROM participation pt
CROSS JOIN policies pol;

-- 6. Key insight: Check what the actual keys in commission_stages are
SELECT 
    full_name,
    jsonb_object_keys(commission_stages) as stage_key
FROM profiles 
WHERE full_name ILIKE '%Nghĩa%'
AND commission_stages IS NOT NULL;
