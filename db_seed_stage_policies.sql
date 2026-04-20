
-- Ensures commission_policies table has RLS and Default Policies

-- 1. Enable RLS and Policies for commission_policies
ALTER TABLE commission_policies ENABLE ROW LEVEL SECURITY;

DO $$
BEGIN
    -- Policy for Admin/KeToan to Manage (ALL)
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'commission_policies' AND policyname = 'Admin manages policies'
    ) THEN
        CREATE POLICY "Admin manages policies" ON commission_policies 
        FOR ALL 
        USING (get_current_user_role() IN ('Admin', 'KeToan')) 
        WITH CHECK (get_current_user_role() IN ('Admin', 'KeToan'));
    END IF;

    -- Policy for Anyone to Read (For UI display or calculation checks)
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'commission_policies' AND policyname = 'Enable read access for all'
    ) THEN
        CREATE POLICY "Enable read access for all" ON commission_policies 
        FOR SELECT 
        USING (true);
    END IF;
END $$;

-- 2. Seed Default MAINTASK_RATE Policies
DO $$
DECLARE
    r_stage TEXT;
    v_rate NUMERIC;
BEGIN
    -- Define stages and default rates (0.1 = 0.1%)
    FOREACH r_stage IN ARRAY ARRAY['NhanFile', 'XuLyFile', 'BinhFile', 'In', 'ThanhPham', 'DongGoi', 'GiaoHang', 'DaGiaoHang'] LOOP
        
        -- Determine default rate based on stage (Logic from requirement/existing)
        IF r_stage = 'In' OR r_stage = 'ThanhPham' OR r_stage = 'XuLyFile' THEN
            v_rate := 0.2;
        ELSIF r_stage = 'NhanFile' THEN
            v_rate := 0.1; 
        ELSE
            v_rate := 0.1;
        END IF;

        -- Insert if Not Exists
        IF NOT EXISTS (SELECT 1 FROM commission_policies WHERE policy_type = 'MAINTASK_RATE' AND apply_to = r_stage) THEN
            INSERT INTO commission_policies (policy_type, apply_to, rate) 
            VALUES ('MAINTASK_RATE', r_stage, v_rate);
        END IF;
        
    END LOOP;
END $$;
