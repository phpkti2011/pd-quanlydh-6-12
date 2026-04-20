
DO $$
DECLARE
    v_admin_id UUID;
    v_admin_name TEXT;
BEGIN
    -- 1. Find the first Admin user
    SELECT id, full_name INTO v_admin_id, v_admin_name
    FROM profiles
    WHERE role = 'Admin'
    LIMIT 1;

    IF v_admin_id IS NULL THEN
        RAISE NOTICE 'No Admin user found. Please create one first.';
        RETURN;
    END IF;

    RAISE NOTICE 'Linking data to Admin: % (%)', v_admin_name, v_admin_id;

    -- 2. Update Orders (Link to Sales Rep)
    UPDATE orders
    SET sales_rep_id = v_admin_id
    WHERE sales_rep_id IS NULL;

    -- 3. Update Participants (Link to Staff)
    UPDATE order_process_participants
    SET user_id = v_admin_id
    WHERE user_id IS NULL;

    -- 4. Update Policies (Link personalized policies to this Admin name for testing)
    -- Update 'Nguyễn Thị Cẩm Ly' policy to apply to this Admin so we see results
    UPDATE commission_policies
    SET apply_to = v_admin_name
    WHERE apply_to = 'Nguyễn Thị Cẩm Ly' AND policy_type = 'SALES_TIER';

    RAISE NOTICE 'Data linked successfully.';
END $$;
