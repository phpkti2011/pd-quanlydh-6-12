-- Create table for storing global application settings
CREATE TABLE IF NOT EXISTS app_settings (
    key TEXT PRIMARY KEY, -- e.g., 'bank_config'
    value JSONB NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    updated_by UUID REFERENCES auth.users(id)
);

-- Enable RLS
ALTER TABLE app_settings ENABLE ROW LEVEL SECURITY;

-- Policy: Authenticated users can read settings (needed for generating QRs)
DROP POLICY IF EXISTS "Enable read access for authenticated users" ON app_settings;
CREATE POLICY "Enable read access for authenticated users" ON app_settings
    FOR SELECT TO authenticated USING (true);

-- Policy: Only Admins and Accountants can modify settings
DROP POLICY IF EXISTS "Enable write access for admins and accountants" ON app_settings;
CREATE POLICY "Enable write access for admins and accountants" ON app_settings
    FOR ALL TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM profiles
            WHERE profiles.id = auth.uid()
            AND profiles.role IN ('Admin', 'KeToan')
        )
    );

-- Grant permissions
GRANT SELECT, INSERT, UPDATE, DELETE ON app_settings TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON app_settings TO service_role;
