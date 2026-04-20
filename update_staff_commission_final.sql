
-- ==============================================================================
-- 0. SCHEMA REPAIR & UPDATES
-- ==============================================================================

-- 1. Add Competency Score (if missing)
ALTER TABLE profiles 
ADD COLUMN IF NOT EXISTS competency_score NUMERIC DEFAULT 1.0;

-- 2. Ensure order_process_participants table exists AND has required columns
CREATE TABLE IF NOT EXISTS order_process_participants (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_id UUID REFERENCES orders(id) ON DELETE CASCADE,
    user_id UUID REFERENCES profiles(id),
    stage TEXT NOT NULL, 
    started_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(order_id, user_id, stage)
);

-- AGGRESSIVE UPDATE: Ensure all needed columns exist (Fix 'action' missing error)
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='order_process_participants' AND column_name='action') THEN
        ALTER TABLE order_process_participants ADD COLUMN action TEXT;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='order_process_participants' AND column_name='finished_at') THEN
        ALTER TABLE order_process_participants ADD COLUMN finished_at TIMESTAMPTZ;
    END IF;
    
    -- Sync with potential existing schema which might use 'completed_at'
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='order_process_participants' AND column_name='completed_at') THEN
        ALTER TABLE order_process_participants ADD COLUMN completed_at TIMESTAMPTZ;
    END IF;
END $$;


-- 3. AGGRESSIVE SCHEMA REPAIR for commission_policies
DO $$
BEGIN
    -- Add missing columns
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='commission_policies' AND column_name='rate') THEN
        ALTER TABLE commission_policies ADD COLUMN rate NUMERIC DEFAULT 0;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='commission_policies' AND column_name='apply_to') THEN
        ALTER TABLE commission_policies ADD COLUMN apply_to TEXT;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='commission_policies' AND column_name='policy_type') THEN
        ALTER TABLE commission_policies ADD COLUMN policy_type TEXT;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='commission_policies' AND column_name='threshold_min') THEN
        ALTER TABLE commission_policies ADD COLUMN threshold_min NUMERIC DEFAULT 0;
    END IF;

    -- Relax constraints
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='commission_policies' AND column_name='policy_name') THEN
        ALTER TABLE commission_policies ALTER COLUMN policy_name DROP NOT NULL;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='commission_policies' AND column_name='role_type') THEN
        ALTER TABLE commission_policies ALTER COLUMN role_type DROP NOT NULL;
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='commission_policies' AND column_name='config_data') THEN
        ALTER TABLE commission_policies ALTER COLUMN config_data DROP NOT NULL;
    END IF;
END $$;


-- ==============================================================================
-- 1. SEED DATA (Default Policies)
-- ==============================================================================
DO $$
BEGIN
    DELETE FROM commission_policies WHERE policy_type IN ('MAINTASK_RATE', 'SUBTASK_RATE');

    -- Main Tasks (Percentages now: 0.2 means 0.2%)
    INSERT INTO commission_policies (policy_type, apply_to, rate) VALUES
    ('MAINTASK_RATE', 'In', 0.2),          
    ('MAINTASK_RATE', 'BinhFile', 0.1),    
    ('MAINTASK_RATE', 'ThanhPham', 0.2),   
    ('MAINTASK_RATE', 'DongGoi', 0.1),     
    ('MAINTASK_RATE', 'EpKim', 0.2);       

    -- Sub Tasks
    INSERT INTO commission_policies (policy_type, apply_to, rate) VALUES
    ('SUBTASK_RATE', 'ThietKe', 10.0),       
    ('SUBTASK_RATE', 'InKhoLon', 5.0);      
END $$;


-- ==============================================================================
-- 2. DATA MIGRATION (CSV -> Participants)
-- ==============================================================================
DO $$
DECLARE
    r_order RECORD;
    v_user_name TEXT;
    v_user_id UUID;
    v_col_exists BOOLEAN;
BEGIN
    -- 1. ThietKe
    SELECT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='orders' AND column_name='thiet_ke_participants') INTO v_col_exists;
    IF v_col_exists THEN
        FOR r_order IN EXECUTE 'SELECT id, thiet_ke_participants FROM orders WHERE thiet_ke_participants IS NOT NULL AND thiet_ke_participants <> ''''' LOOP
            FOREACH v_user_name IN ARRAY string_to_array(r_order.thiet_ke_participants, ',') LOOP
                v_user_name := TRIM(v_user_name);
                IF length(v_user_name) > 0 THEN
                    SELECT id INTO v_user_id FROM profiles WHERE full_name = v_user_name LIMIT 1;
                    IF v_user_id IS NOT NULL THEN
                        INSERT INTO order_process_participants (order_id, user_id, stage, action) values (r_order.id, v_user_id, 'ThietKe', 'Migration') ON CONFLICT DO NOTHING;
                    END IF;
                END IF;
            END LOOP;
        END LOOP;
    END IF;

    -- 2. In
    SELECT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='orders' AND column_name='in_participants') INTO v_col_exists;
    IF v_col_exists THEN
        FOR r_order IN EXECUTE 'SELECT id, in_participants FROM orders WHERE in_participants IS NOT NULL AND in_participants <> ''''' LOOP
            FOREACH v_user_name IN ARRAY string_to_array(r_order.in_participants, ',') LOOP
                v_user_name := TRIM(v_user_name);
                IF length(v_user_name) > 0 THEN
                    SELECT id INTO v_user_id FROM profiles WHERE full_name = v_user_name LIMIT 1;
                    IF v_user_id IS NOT NULL THEN
                        INSERT INTO order_process_participants (order_id, user_id, stage, action) values (r_order.id, v_user_id, 'In', 'Migration') ON CONFLICT DO NOTHING;
                    END IF;
                END IF;
            END LOOP;
        END LOOP;
    END IF;
    
    -- 3. BinhFile
    SELECT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='orders' AND column_name='binh_file_participants') INTO v_col_exists;
    IF v_col_exists THEN
        FOR r_order IN EXECUTE 'SELECT id, binh_file_participants FROM orders WHERE binh_file_participants IS NOT NULL AND binh_file_participants <> ''''' LOOP
            FOREACH v_user_name IN ARRAY string_to_array(r_order.binh_file_participants, ',') LOOP
                v_user_name := TRIM(v_user_name);
                IF length(v_user_name) > 0 THEN
                    SELECT id INTO v_user_id FROM profiles WHERE full_name = v_user_name LIMIT 1;
                    IF v_user_id IS NOT NULL THEN
                        INSERT INTO order_process_participants (order_id, user_id, stage, action) values (r_order.id, v_user_id, 'BinhFile', 'Migration') ON CONFLICT DO NOTHING;
                    END IF;
                END IF;
            END LOOP;
        END LOOP;
    END IF;

    -- 4. ThanhPham
    SELECT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='orders' AND column_name='thanh_pham_participants') INTO v_col_exists;
    IF v_col_exists THEN
        FOR r_order IN EXECUTE 'SELECT id, thanh_pham_participants FROM orders WHERE thanh_pham_participants IS NOT NULL AND thanh_pham_participants <> ''''' LOOP
            FOREACH v_user_name IN ARRAY string_to_array(r_order.thanh_pham_participants, ',') LOOP
                v_user_name := TRIM(v_user_name);
                IF length(v_user_name) > 0 THEN
                    SELECT id INTO v_user_id FROM profiles WHERE full_name = v_user_name LIMIT 1;
                    IF v_user_id IS NOT NULL THEN
                        INSERT INTO order_process_participants (order_id, user_id, stage, action) values (r_order.id, v_user_id, 'ThanhPham', 'Migration') ON CONFLICT DO NOTHING;
                    END IF;
                END IF;
            END LOOP;
        END LOOP;
    END IF;

    -- 5. DongGoi
    SELECT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='orders' AND column_name='dong_goi_participants') INTO v_col_exists;
    IF v_col_exists THEN
        FOR r_order IN EXECUTE 'SELECT id, dong_goi_participants FROM orders WHERE dong_goi_participants IS NOT NULL AND dong_goi_participants <> ''''' LOOP
            FOREACH v_user_name IN ARRAY string_to_array(r_order.dong_goi_participants, ',') LOOP
                v_user_name := TRIM(v_user_name);
                IF length(v_user_name) > 0 THEN
                    SELECT id INTO v_user_id FROM profiles WHERE full_name = v_user_name LIMIT 1;
                    IF v_user_id IS NOT NULL THEN
                        INSERT INTO order_process_participants (order_id, user_id, stage, action) values (r_order.id, v_user_id, 'DongGoi', 'Migration') ON CONFLICT DO NOTHING;
                    END IF;
                END IF;
            END LOOP;
        END LOOP;
    END IF;
END $$;


-- ==============================================================================
-- 3. FUNCTION IMPLEMENTATION (UPDATED WITH PERSONAL RATES & COMPETENCY)
-- ==============================================================================
DROP FUNCTION IF EXISTS calculate_staff_commission(DATE, DATE, TEXT);

CREATE OR REPLACE FUNCTION calculate_staff_commission(
    p_start_date DATE,
    p_end_date DATE,
    p_user_name TEXT DEFAULT NULL
)
RETURNS TABLE (
    participant_name TEXT,
    competency_score NUMERIC,
    main_task_comm NUMERIC,
    sub_task_comm NUMERIC,
    total_comm NUMERIC
) AS $$
BEGIN
    RETURN QUERY
    WITH participated_tasks AS (
        SELECT 
            p.id as user_id,
            p.full_name,
            COALESCE(p.competency_score, 1.0) as score,
            
            -- Fetch Rates (Personal -> Global -> 0)
            -- IMPORTANT: Rates are stored as PERCENTAGES (e.g. 10 for 10%, 0.2 for 0.2%)
            COALESCE((p.commission_stages->>part.stage)::NUMERIC, cp_proc.rate, 0) as process_rate,
            COALESCE((p.commission_subtasks->>part.stage)::NUMERIC, cp_sub.rate, 0) as subtask_rate,
            
            part.stage,
            o.id as order_id,
            o.total_amount_pre_vat, 
            -- Calculate number of participants in this stage for this order
            COUNT(*) OVER (PARTITION BY part.order_id, part.stage) as participant_count,
            
            -- Map Stage to Specific Fee (Sub-tasks)
            CASE 
                WHEN part.stage = 'ThietKe' THEN COALESCE(o.design_fee, 0)
                WHEN part.stage = 'InKhoLon' THEN COALESCE(o.large_print_fee, 0)
                WHEN part.stage = 'EpKim' THEN COALESCE(o.ep_kim_fee, 0)
                WHEN part.stage = 'BeDemi' THEN COALESCE(o.be_demi_fee, 0)
                WHEN part.stage = 'GiaCongNgoai' THEN COALESCE(o.gia_cong_ngoai_fee, 0)
                WHEN part.stage = 'CanMang' THEN COALESCE(o.can_mang_fee, 0)
                ELSE 0
            END as stage_value
        FROM order_process_participants part
        JOIN orders o ON part.order_id = o.id
        JOIN profiles p ON part.user_id = p.id
        LEFT JOIN commission_policies cp_proc ON cp_proc.policy_type = 'MAINTASK_RATE' AND cp_proc.apply_to = part.stage
        LEFT JOIN commission_policies cp_sub ON cp_sub.policy_type = 'SUBTASK_RATE' AND cp_sub.apply_to = part.stage
        WHERE COALESCE(o.delivery_date, o.created_at)::DATE >= p_start_date 
        AND COALESCE(o.delivery_date, o.created_at)::DATE <= p_end_date
        AND o.status IN ('HoanThanh', 'DaGiaoHang')
    ),
    
    calc_per_task AS (
        SELECT 
            pt.user_id,
            pt.full_name,
            pt.score,
            pt.stage,
            
            -- A. Process Commission (Quy Trình): Bình File, In, Thành Phẩm, ...
            -- Formula: (OrderValue / ParticipantCount) * (Rate/100) * CompetencyScore
            -- Applied when stage_value is 0 (meaning it's a Process, not a Sub-task with Fee)
            CASE 
                WHEN pt.stage_value = 0 THEN 
                    (pt.total_amount_pre_vat / pt.participant_count) * (pt.process_rate / 100.0) * pt.score 
                ELSE 0 
            END as process_comm_val,
            
            -- B. Sub-task Commission (Công Đoạn Phụ): Thiết Kế, In Khổ Lớn, ...
            -- Formula: Fee * (Rate/100)
            -- Applied when stage_value > 0
            -- Note: User didn't request split or competency for these, just "Rate * Fee".
            CASE 
                WHEN pt.stage_value > 0 THEN 
                    pt.stage_value * (pt.subtask_rate / 100.0)
                ELSE 0 
            END as stage_comm_val

        FROM participated_tasks pt
        WHERE (p_user_name IS NULL OR pt.full_name = p_user_name)
    )
    
    SELECT 
        cpt.full_name,
        cpt.score,
        ROUND(SUM(cpt.process_comm_val), 0) as main_comm,
        ROUND(SUM(cpt.stage_comm_val), 0) as sub_comm,
        ROUND(SUM(cpt.process_comm_val + cpt.stage_comm_val), 0) as total_comm
    FROM calc_per_task cpt
    GROUP BY cpt.full_name, cpt.score;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- New Function: Detailed Activity Report (UPDATED)
DROP FUNCTION IF EXISTS get_staff_activity_details(DATE, DATE, TEXT);

CREATE OR REPLACE FUNCTION get_staff_activity_details(
    p_start_date DATE,
    p_end_date DATE,
    p_user_name TEXT DEFAULT NULL
)
RETURNS TABLE (
    user_name TEXT,
    order_code TEXT,
    stage TEXT,
    started_at TIMESTAMPTZ,
    finished_at TIMESTAMPTZ,
    score NUMERIC,
    participant_count BIGINT,
    process_comm NUMERIC, -- Commission from Process flow
    stage_comm NUMERIC,   -- Commission from Sub-task Fee
    total_comm NUMERIC
) AS $$
BEGIN
    RETURN QUERY
    WITH participated_tasks AS (
        SELECT 
            p.id as user_id,
            p.full_name,
            COALESCE(p.competency_score, 1.0) as score,
            -- Fetch Rates (Personal -> Global -> 0)
            COALESCE((p.commission_stages->>part.stage)::NUMERIC, cp_proc.rate, 0) as process_rate,
            COALESCE((p.commission_subtasks->>part.stage)::NUMERIC, cp_sub.rate, 0) as subtask_rate,

            part.stage,
            part.started_at,
            part.finished_at,
            o.id as order_id,
            o.order_code,
            o.total_amount_pre_vat, 
            COUNT(*) OVER (PARTITION BY part.order_id, part.stage) as participant_count,
            
            CASE 
                WHEN part.stage = 'ThietKe' THEN COALESCE(o.design_fee, 0)
                WHEN part.stage = 'InKhoLon' THEN COALESCE(o.large_print_fee, 0)
                WHEN part.stage = 'EpKim' THEN COALESCE(o.ep_kim_fee, 0)
                WHEN part.stage = 'BeDemi' THEN COALESCE(o.be_demi_fee, 0)
                WHEN part.stage = 'GiaCongNgoai' THEN COALESCE(o.gia_cong_ngoai_fee, 0)
                WHEN part.stage = 'CanMang' THEN COALESCE(o.can_mang_fee, 0)
                ELSE 0
            END as stage_value
        FROM order_process_participants part
        JOIN orders o ON part.order_id = o.id
        JOIN profiles p ON part.user_id = p.id
        LEFT JOIN commission_policies cp_proc ON cp_proc.policy_type = 'MAINTASK_RATE' AND cp_proc.apply_to = part.stage
        LEFT JOIN commission_policies cp_sub ON cp_sub.policy_type = 'SUBTASK_RATE' AND cp_sub.apply_to = part.stage
        WHERE COALESCE(o.delivery_date, o.created_at)::DATE >= p_start_date 
        AND COALESCE(o.delivery_date, o.created_at)::DATE <= p_end_date
        AND o.status IN ('HoanThanh', 'DaGiaoHang')
    ),
    
    calc_per_task AS (
        SELECT 
            pt.full_name,
            pt.order_code,
            pt.stage,
            pt.started_at,
            pt.finished_at,
            pt.score,
            pt.participant_count,
            
            -- Process Commission
            CASE 
                WHEN pt.stage_value = 0 THEN 
                    (pt.total_amount_pre_vat / pt.participant_count) * pt.process_rate * pt.score 
                ELSE 0 
            END as process_comm_val,
            
            -- Sub-task Commission
            CASE 
                WHEN pt.stage_value > 0 THEN 
                    pt.stage_value * pt.subtask_rate
                ELSE 0 
            END as stage_comm_val
        FROM participated_tasks pt
        WHERE (p_user_name IS NULL OR pt.full_name = p_user_name)
    )
    
    SELECT 
        cpt.full_name,
        cpt.order_code,
        cpt.stage,
        cpt.started_at,
        cpt.finished_at,
        cpt.score,
        cpt.participant_count,
        ROUND(cpt.process_comm_val, 0),
        ROUND(cpt.stage_comm_val, 0),
        ROUND(cpt.process_comm_val + cpt.stage_comm_val, 0)
    FROM calc_per_task cpt
    ORDER BY cpt.started_at DESC;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Re-apply notification to ensure it takes effect
NOTIFY pgrst, 'reload schema';
