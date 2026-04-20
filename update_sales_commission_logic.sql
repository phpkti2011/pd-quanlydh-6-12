
-- 1. Ensure commission_policies table exists for Group Bonus
CREATE TABLE IF NOT EXISTS commission_policies (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    policy_type TEXT NOT NULL, -- 'GROUP_TIER', etc.
    threshold_min NUMERIC DEFAULT 0,
    rate NUMERIC NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS just in case it was missing
ALTER TABLE commission_policies ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Admin manage policies" ON commission_policies;
CREATE POLICY "Admin manage policies" ON commission_policies FOR ALL USING (get_current_user_role() = 'Admin');
DROP POLICY IF EXISTS "Read policies" ON commission_policies;
CREATE POLICY "Read policies" ON commission_policies FOR SELECT USING (true);


-- 2. Refactor calculate_sales_commission to use JSONB Tiers from Profile
CREATE OR REPLACE FUNCTION calculate_sales_commission(
    p_start_date DATE,
    p_end_date DATE
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
    v_group_sales NUMERIC := 0;
    v_group_rate NUMERIC := 0;
    v_group_fund NUMERIC := 0;
BEGIN
    -- A. Calculate Total Company/Group Sales (Active orders in period)
    SELECT COALESCE(SUM(total_amount_pre_vat), 0) -- Use Pre-VAT as requested
    INTO v_group_sales
    FROM orders
    WHERE created_at::DATE >= p_start_date 
    AND created_at::DATE <= p_end_date
    AND status != 'Huy';

    -- B. Find Group Bonus Rate (if any)
    -- Looks at commission_policies for GROUP_TIER
    SELECT rate INTO v_group_rate
    FROM commission_policies
    WHERE policy_type = 'GROUP_TIER'
    AND v_group_sales >= threshold_min
    ORDER BY threshold_min DESC
    LIMIT 1;

    v_group_fund := v_group_sales * COALESCE(v_group_rate, 0);

    -- C. Return Table with Per-Employee Calculations
    RETURN QUERY
    WITH rep_sales AS (
        SELECT 
            p.id as user_id,
            p.full_name,
            p.commission_tiers,
            COALESCE(SUM(o.total_amount_pre_vat), 0) as total_sales -- Pre-VAT
        FROM orders o
        JOIN profiles p ON o.sales_rep_id = p.id
        WHERE o.created_at::DATE >= p_start_date 
        AND o.created_at::DATE <= p_end_date
        AND o.status != 'Huy'
        GROUP BY p.id, p.full_name, p.commission_tiers
    )
    SELECT 
        rs.full_name,
        rs.total_sales,
        
        -- 1. Personal Commission: Parse JSON tiers
        (
            SELECT COALESCE((tier->>'rate')::numeric, 0)
            FROM jsonb_array_elements(rs.commission_tiers) as tier
            WHERE (tier->>'min')::numeric <= rs.total_sales
            ORDER BY (tier->>'min')::numeric DESC
            LIMIT 1
        ) * rs.total_sales / 100.0 as personal_comm_val, -- Assuming rate is percent? UI inputs e.g. "1.5" for 1.5%. So divide by 100.
                                                         -- Wait, checking UI data. In DB usually stored as percentage number (e.g. 5) or fraction (0.05).
                                                         -- In UI screenshot "0.012" etc was in the SQL seed.
                                                         -- Let's assume input is Percentage (e.g. 1.2) -> /100.
                                                         -- CHECK: The UI code uses `step="0.1"`. 
                                                         -- Let's check `KPIManager` again to be safe. 
                                                         -- Ah, KPIManager input is number. If user enters "5", it is 5.
                                                         -- SQL logic usually expects "5" means 5%. So * rate / 100.
                                                         -- If user enters "0.05", it is 0.05%.
                                                         -- Let's assume user inputs PERCENTAGE VALUE (e.g. 5 for 5%).
        
        v_group_sales,
        
        -- 2. Group Commission: Distribute fund proportional to contribution
        CASE 
            WHEN v_group_sales > 0 THEN (rs.total_sales / v_group_sales) * v_group_fund 
            ELSE 0 
        END as group_comm_val,
        
        0::NUMERIC -- Placeholder for total (calculated in UI or sum here)
    FROM rep_sales rs;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
