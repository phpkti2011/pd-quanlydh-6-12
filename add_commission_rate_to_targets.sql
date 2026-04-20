-- Add commission_rate column to sales_targets if it doesn't exist
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'sales_targets' AND column_name = 'commission_rate') THEN
        ALTER TABLE sales_targets ADD COLUMN commission_rate NUMERIC DEFAULT 0;
    END IF;
END $$;

-- Verify
SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'sales_targets';
