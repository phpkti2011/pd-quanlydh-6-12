-- Add commission_tiers JSONB column to sales_targets for per-month tiers
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'sales_targets' AND column_name = 'commission_tiers') THEN
        ALTER TABLE sales_targets ADD COLUMN commission_tiers JSONB DEFAULT NULL;
        RAISE NOTICE 'Added commission_tiers column to sales_targets';
    ELSE
        RAISE NOTICE 'commission_tiers column already exists';
    END IF;
END $$;

-- Verify
SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'sales_targets' ORDER BY ordinal_position;

NOTIFY pgrst, 'reload schema';
