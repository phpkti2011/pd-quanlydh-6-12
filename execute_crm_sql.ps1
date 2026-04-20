# Execute CRM Setup SQL on Supabase
# Project: vbdgokdnsttqobsapwms

$sqlFile = "update_sales_commission_v2.sql"
$projectRef = "vbdgokdnsttqobsapwms"

# Construct command (using npx to avoid global install requirement)
# Note: Requires 'supabase' CLI to be available via npx or path.
# If not, user might need to install it: npm install -g supabase
$cmd = "npx"
$cliArgs = @("supabase", "db", "execute", "-f", $sqlFile, "--project-ref", $projectRef)

Write-Host "Executing SQL: $sqlFile on project $projectRef..."

# Execute
& $cmd $cliArgs 1> sql_output.log 2> sql_error.log

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ SQL execution successful!" -ForegroundColor Green
}
else {
    Write-Host "❌ SQL execution failed." -ForegroundColor Red
}
