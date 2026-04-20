# Execute Debug SQL on Supabase
$sqlFile = "debug_kpi.sql"
$projectRef = "vbdgokdnsttqobsapwms"

$cmd = "npx"
$args = @("supabase", "db", "execute", "-f", $sqlFile, "--project-ref", $projectRef)

Write-Host "Executing SQL: $sqlFile..."
& $cmd $args
