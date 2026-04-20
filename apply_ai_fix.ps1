# Execute AI Permissions SQL
$sqlFile = "update_ai_permissions.sql"
$projectRef = "vbdgokdnsttqobsapwms"
$cmd = "npx"
$args = @("supabase", "db", "execute", "-f", $sqlFile, "--project-ref", $projectRef)
Write-Host "Executing SQL: $sqlFile on project $projectRef..."
& $cmd $args
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ SQL execution successful!" -ForegroundColor Green
}
else {
    Write-Host "❌ SQL execution failed." -ForegroundColor Red
}
