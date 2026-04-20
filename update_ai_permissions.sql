-- Allow ALL authenticated users to READ settings (to get AI Key)
-- But only Admin/KeToan can WRITE (already set in create_app_settings.sql, but we ensure READ is open)

DROP POLICY IF EXISTS "Enable read access for authenticated users" ON app_settings;

CREATE POLICY "Enable read access for authenticated users" ON app_settings
    FOR SELECT
    TO authenticated
    USING (true);

-- Ensure Grant
GRANT SELECT ON app_settings TO authenticated;
