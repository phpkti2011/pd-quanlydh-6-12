
-- Table to store Sales Targets (KPI)
CREATE TABLE IF NOT EXISTS sales_targets (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    entity_type TEXT NOT NULL CHECK (entity_type IN ('user', 'department', 'company')),
    entity_id UUID REFERENCES profiles(id), -- Nullable for company/department
    department_name TEXT, -- For entity_type = 'department'
    period_month INT NOT NULL CHECK (period_month BETWEEN 1 AND 12),
    period_year INT NOT NULL,
    target_amount NUMERIC DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    -- Ensure unique target per entity per period
    UNIQUE (entity_type, entity_id, department_name, period_month, period_year)
);

-- Enable RLS
ALTER TABLE sales_targets ENABLE ROW LEVEL SECURITY;

-- Policies
-- Admin / Manager can view and edit all
CREATE POLICY "Admins manage targets" ON sales_targets
    FOR ALL USING (get_current_user_role() = 'Admin')
    WITH CHECK (get_current_user_role() = 'Admin');

-- Employees can view their own targets
CREATE POLICY "Employees view own targets" ON sales_targets
    FOR SELECT USING (
        (entity_type = 'user' AND entity_id = auth.uid()) OR
        (entity_type = 'company') OR 
        (entity_type = 'department') -- Everyone can see Dept/Company targets? Usually yes.
    );

NOTIFY pgrst, 'reload schema';
