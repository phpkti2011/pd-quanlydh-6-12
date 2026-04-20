# Execute SQL for Status Tabs Feature
$projectRef = "your-project-id" # Replace if known, otherwise user will input or CLI uses linked
# Assuming local dev or linked project. CLI assumes linked if not specified? 
# Using file argument.

Write-Host "Adding status columns to orders table..."
npx supabase db execute --file "db_add_status_columns.sql"

Write-Host "Updating dashboard stats function..."
npx supabase db execute --file "db_dashboard_v2.sql"

Write-Host "Done! Please refresh the web page."
