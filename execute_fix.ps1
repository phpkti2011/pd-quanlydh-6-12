$projectRef = "vqedjnefqrjhcthvzmtg"
$sqlFile = "fix_revenue_final_v3.sql"

Write-Host "Executing $sqlFile on Supabase project: $projectRef" -ForegroundColor Green

# Use supabase CLI to execute
npx -y supabase db execute -f $sqlFile --project-ref $projectRef

Write-Host "`nDone! Check for any errors above." -ForegroundColor Cyan
