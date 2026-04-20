-- ==============================================================================
-- DỌN DẸP SALES_TARGETS v2
-- Chạy trong Supabase SQL Editor
-- ==============================================================================

-- Bước 1: Xóa records trùng cho user (có entity_id)
DELETE FROM sales_targets a
USING sales_targets b
WHERE a.entity_type = b.entity_type
  AND a.entity_id IS NOT NULL AND b.entity_id IS NOT NULL
  AND a.entity_id = b.entity_id
  AND a.period_month = b.period_month
  AND a.period_year = b.period_year
  AND a.created_at < b.created_at;

-- Bước 2: Xóa records trùng cho company/department (dùng department_name)
DELETE FROM sales_targets a
USING sales_targets b
WHERE a.entity_type = b.entity_type
  AND a.entity_id IS NULL AND b.entity_id IS NULL
  AND COALESCE(a.department_name, '') = COALESCE(b.department_name, '')
  AND a.period_month = b.period_month
  AND a.period_year = b.period_year
  AND a.created_at < b.created_at;

-- Bước 3: Drop index/constraint cũ
DROP INDEX IF EXISTS idx_sales_targets_unique;
ALTER TABLE sales_targets DROP CONSTRAINT IF EXISTS uq_sales_targets;

-- Bước 4: Tạo 2 partial unique index
-- Index cho user records (entity_id NOT NULL)
CREATE UNIQUE INDEX idx_sales_targets_user_unique
ON sales_targets (entity_type, entity_id, period_month, period_year)
WHERE entity_id IS NOT NULL;

-- Index cho company/department records (entity_id IS NULL)
CREATE UNIQUE INDEX idx_sales_targets_dept_unique
ON sales_targets (entity_type, department_name, period_month, period_year)
WHERE entity_id IS NULL;

-- Revert any dummy entity_id back to NULL
UPDATE sales_targets SET entity_id = NULL
WHERE entity_id = '00000000-0000-0000-0000-000000000000';

-- Kiểm tra
SELECT entity_type, entity_id, department_name, period_month, period_year, COUNT(*)
FROM sales_targets
GROUP BY entity_type, entity_id, department_name, period_month, period_year
HAVING COUNT(*) > 1;
