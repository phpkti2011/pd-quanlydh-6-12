-- CRM Phase 3: Sales Pipeline
-- Add pipeline_stage column to customers table

-- Create ENUM for pipeline stages (optional, but text is more flexible for now)
-- Stages: 
-- 1. 'NEW' (Mới tiếp cận - Lead)
-- 2. 'QUOTED' (Đã báo giá)
-- 3. 'NEGOTIATING' (Đang thương lượng)
-- 4. 'WON' (Đã chốt / Khách hàng)
-- 5. 'LOST' (Đã rớt / Hủy)

ALTER TABLE customers 
ADD COLUMN IF NOT EXISTS pipeline_stage TEXT DEFAULT 'NEW';

COMMENT ON COLUMN customers.pipeline_stage IS 'Sales Pipeline Stage: NEW, QUOTED, NEGOTIATING, WON, LOST';

-- Index for faster filtering by stage
CREATE INDEX IF NOT EXISTS idx_customers_pipeline_stage ON customers(pipeline_stage);
