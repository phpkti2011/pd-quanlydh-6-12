
-- 1. Table: commission_policies
DROP TABLE IF EXISTS commission_policies CASCADE;
CREATE TABLE IF NOT EXISTS commission_policies (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    policy_type TEXT NOT NULL, -- 'SALES_TIER', 'GROUP_TIER', 'SUBTASK_RATE', 'MAINTASK_WEIGHT'
    apply_to TEXT, -- User name (for SALES_TIER) or Task Name (for RATES)
    threshold_min NUMERIC DEFAULT 0,
    threshold_max NUMERIC, -- NULL means infinity
    rate NUMERIC NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE commission_policies ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public read policies" ON commission_policies FOR SELECT USING (true); -- Or restrict to Admin

-- 2. Seed Data (Using DO block to avoid duplicates)
DO $$
BEGIN
    -- Clear existing policies to avoid duplicates during re-runs
    DELETE FROM commission_policies;

    -- A. Sales Tiers (Personalized)
    -- Nguyen Thi Cam Ly
    INSERT INTO commission_policies (policy_type, apply_to, threshold_min, threshold_max, rate) VALUES
    ('SALES_TIER', 'Nguyễn Thị Cẩm Ly', 0, 230000000, 0.005),
    ('SALES_TIER', 'Nguyễn Thị Cẩm Ly', 230000000, 280000000, 0.012),
    ('SALES_TIER', 'Nguyễn Thị Cẩm Ly', 280000000, NULL, 0.02);

    -- Cai Thi Ngoc Lan
    INSERT INTO commission_policies (policy_type, apply_to, threshold_min, threshold_max, rate) VALUES
    ('SALES_TIER', 'Cai Thị Ngọc Lan', 0, 150000000, 0.005),
    ('SALES_TIER', 'Cai Thị Ngọc Lan', 150000000, 200000000, 0.012),
    ('SALES_TIER', 'Cai Thị Ngọc Lan', 200000000, NULL, 0.02);

    -- Le Thi Thuy
    INSERT INTO commission_policies (policy_type, apply_to, threshold_min, threshold_max, rate) VALUES
    ('SALES_TIER', 'Lê Thị Thủy', 0, 200000000, 0.005),
    ('SALES_TIER', 'Lê Thị Thủy', 200000000, 260000000, 0.012),
    ('SALES_TIER', 'Lê Thị Thủy', 260000000, NULL, 0.02);

    -- B. Group Tiers
    INSERT INTO commission_policies (policy_type, threshold_min, rate) VALUES
    ('GROUP_TIER', 700000000, 0.01),
    ('GROUP_TIER', 770000000, 0.015);

    -- C. Subtask Rates
    INSERT INTO commission_policies (policy_type, apply_to, rate) VALUES
    ('SUBTASK_RATE', 'Thiết kế', 0.12),
    ('SUBTASK_RATE', 'In Khổ Lớn', 0.01);

    -- D. Main Task Weights (Used for 'In', 'ThanhPham', etc. logic might vary but storing weights here)
    INSERT INTO commission_policies (policy_type, apply_to, rate) VALUES
    ('MAINTASK_WEIGHT', 'Bình File', 0.2),
    ('MAINTASK_WEIGHT', 'In', 0.2),
    ('MAINTASK_WEIGHT', 'Thành Phẩm', 0.2),
    ('MAINTASK_WEIGHT', 'Đóng gói', 0.1),
    ('MAINTASK_WEIGHT', 'Ép Kim', 0.2),
    ('MAINTASK_WEIGHT', 'Hoàn thành', 0.05);

END $$;

-- 3. Function: calculate_sales_commission
CREATE OR REPLACE FUNCTION calculate_sales_commission(
    p_start_date DATE,
    p_end_date DATE,
    p_sales_rep_name TEXT DEFAULT NULL -- Optional filter
)
RETURNS TABLE (
    sales_rep_name TEXT,
    personal_sales NUMERIC,
    personal_comm NUMERIC,
    group_sales_total NUMERIC,
    group_comm NUMERIC,
    total_comm NUMERIC
) AS $$
DECLARE
    v_group_sales NUMERIC;
    v_group_rate NUMERIC := 0;
    v_group_fund NUMERIC;
BEGIN
    -- 1. Calculate Group Sales (Total 'Da thanh toán' or 'Cong no' within period)
    -- Assuming Date uses created_at or delivery_date. Using created_at for simplicity now.
    SELECT COALESCE(SUM(total_amount), 0)
    INTO v_group_sales
    FROM orders
    WHERE created_at::DATE >= p_start_date AND created_at::DATE <= p_end_date
    AND status != 'Huy';

    -- 2. Determine Group Rate
    SELECT rate INTO v_group_rate
    FROM commission_policies
    WHERE policy_type = 'GROUP_TIER'
    AND v_group_sales >= threshold_min
    ORDER BY threshold_min DESC
    LIMIT 1;

    -- COALESCE(v_group_rate, 0); -- Removed dangling line
    v_group_fund := v_group_sales * COALESCE(v_group_rate, 0);

    RETURN QUERY
    WITH rep_sales AS (
        SELECT 
            p.full_name,
            COALESCE(SUM(o.total_amount), 0) as total_sales
        FROM orders o
        JOIN profiles p ON o.sales_rep_id = p.id
        WHERE o.created_at::DATE >= p_start_date AND o.created_at::DATE <= p_end_date
        AND o.status != 'Huy'
        AND (p_sales_rep_name IS NULL OR p.full_name = p_sales_rep_name)
        GROUP BY p.full_name
    )
    SELECT 
        rs.full_name,
        rs.total_sales,
        -- Calculate Personal Comm based on Tiers
        (
            SELECT COALESCE(rate, 0)
            FROM commission_policies cp
            WHERE cp.policy_type = 'SALES_TIER' 
            AND cp.apply_to = rs.full_name
            AND rs.total_sales > cp.threshold_min -- Simplified lookup
            ORDER BY cp.threshold_min DESC
            LIMIT 1
        ) * rs.total_sales as personal_comm_val, -- Estimated. Real progressive needs loop.
        
        v_group_sales,
        
        -- Group Comm Contribution: (Individual Sales / Group Sales) * Group Fund
        CASE WHEN v_group_sales > 0 THEN (rs.total_sales / v_group_sales) * v_group_fund 
             ELSE 0 END as group_comm_val,
             
        0::NUMERIC -- Total placeholder
    FROM rep_sales rs;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 4. Function: calculate_staff_commission
-- Returns commission for Non-Sales staff (Designs, Production)
CREATE OR REPLACE FUNCTION calculate_staff_commission(
    p_start_date DATE,
    p_end_date DATE,
    p_user_name TEXT DEFAULT NULL
)
RETURNS TABLE (
    participant_name TEXT,
    main_task_comm NUMERIC,
    sub_task_comm NUMERIC,
    total_comm NUMERIC
) AS $$
BEGIN
    RETURN QUERY
    WITH task_commissions AS (
        SELECT 
            p.full_name,
            -- Main Task Commission (Simplified: Fixed weight * Order Value? No, usually (OrderVal * Rate)/Count)
            -- For MVP, let's leave Main Task as 0 or simple placeholder until formula clarified.
            0::NUMERIC as main_comm,
            
            -- Sub Task Commission: Fee * Rate (from policies)
            COALESCE(SUM(
                CASE WHEN o.has_design AND part.stage = 'ThietKe' THEN 
                    o.design_fee * (SELECT rate FROM commission_policies WHERE key='Thiết kế' LIMIT 1)
                WHEN o.has_large_print AND part.stage = 'In' THEN -- 'In Khổ Lớn' mapped to 'In'? No, need 'InKhoLon'.
                    -- Assuming stage names map to keys.
                     0 -- Placeholder
                ELSE 0 END
            ), 0) as sub_comm
        FROM order_process_participants part
        JOIN orders o ON part.order_id = o.id
        JOIN profiles p ON part.user_id = p.id
        WHERE part.started_at::DATE >= p_start_date AND part.started_at::DATE <= p_end_date
        AND (p_user_name IS NULL OR p.full_name = p_user_name)
        GROUP BY p.full_name
    )
    SELECT 
        tc.full_name,
        tc.main_comm,
        tc.sub_comm,
        (tc.main_comm + tc.sub_comm)
    FROM task_commissions tc;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
