# Execute Sales KPI Update SQL on Supabase
$sqlFile = "update_sales_commission_details.sql"
$projectRef = "vbdgokdnsttqobsapwms"

# Construct command (using npx to avoid global install requirement)
$cmd = "npx"
$args = @("supabase", "db", "execute", "-f", $sqlFile, "--project-ref", $projectRef)

Write-Host "Executing SQL: $sqlFile on project $projectRef..."

# Execute
& $cmd $args

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ SQL execution successful!" -ForegroundColor Green
}
else {
    Write-Host "❌ SQL execution failed." -ForegroundColor Red
}
