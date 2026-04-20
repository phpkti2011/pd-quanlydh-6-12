-- Fix customer_logs table schema (Repair missing columns/FKs caused by stub creation)

-- 1. Ensure Columns Exist
ALTER TABLE customer_logs 
ADD COLUMN IF NOT EXISTS customer_id UUID,
ADD COLUMN IF NOT EXISTS type TEXT,
ADD COLUMN IF NOT EXISTS content TEXT,
ADD COLUMN IF NOT EXISTS created_by UUID,
ADD COLUMN IF NOT EXISTS created_at TIMESTAMPTZ DEFAULT NOW();

-- 2. Ensure Foreign Keys Exist
DO $$ 
BEGIN 
    -- Link customer_id to customers
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE table_name = 'customer_logs' AND constraint_name = 'customer_logs_customer_id_fkey') THEN 
        ALTER TABLE customer_logs ADD CONSTRAINT customer_logs_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE; 
    END IF; 

    -- Link created_by to profiles (This fixes the "Relation not found" error)
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE table_name = 'customer_logs' AND constraint_name = 'customer_logs_created_by_fkey') THEN 
        ALTER TABLE customer_logs ADD CONSTRAINT customer_logs_created_by_fkey FOREIGN KEY (created_by) REFERENCES profiles(id); 
    END IF; 
END $$;
