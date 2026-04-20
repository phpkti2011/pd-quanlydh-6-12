@echo off
echo Executing V2 update...
call npx -y supabase db execute -f "update_sales_commission_v2.sql"
if %errorlevel% neq 0 (
    echo [RETRY] Executing failed. Trying with project ref connection string is not possible directly.
    echo Please ensure you are linked.
    exit /b %errorlevel%
)
echo Success.
