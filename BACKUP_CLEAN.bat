@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo ========================================
echo   BACKUP CODE - Loại bỏ file nhạy cảm
echo ========================================
echo.

:: Tạo tên file theo ngày giờ
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /format:list') do set datetime=%%I
set TIMESTAMP=%datetime:~0,8%_%datetime:~8,6%
set BACKUP_NAME=PD_QuanLyDH_CLEAN_%TIMESTAMP%

:: Thư mục tạm để copy code
set TEMP_DIR=%TEMP%\%BACKUP_NAME%
set OUTPUT_ZIP=D:\%BACKUP_NAME%.zip

echo [1/4] Tạo thư mục tạm...
if exist "%TEMP_DIR%" rmdir /s /q "%TEMP_DIR%"
mkdir "%TEMP_DIR%"

echo [2/4] Copy code (loại bỏ file nhạy cảm)...
:: Copy tất cả trừ các thư mục/file không cần
robocopy "%~dp0" "%TEMP_DIR%" /E /XD node_modules dist .vercel backups .git /XF .env.local *.zip *.log output.txt temp_*.txt sql_output.log >nul

echo [3/4] Nén thành file ZIP...
powershell -Command "Compress-Archive -Path '%TEMP_DIR%\*' -DestinationPath '%OUTPUT_ZIP%' -Force"

echo [4/4] Dọn dẹp thư mục tạm...
rmdir /s /q "%TEMP_DIR%"

echo.
echo ========================================
echo   HOÀN THÀNH!
echo   File backup: %OUTPUT_ZIP%
echo ========================================
echo.
echo Các file đã loại bỏ:
echo   - .env.local (chứa API keys)
echo   - node_modules/ (cài lại bằng npm install)
echo   - dist/ (build output)
echo   - backups/ (backup cũ)
echo   - *.zip, *.log (file không cần thiết)
echo.

:: Mở thư mục chứa file backup
explorer /select,"%OUTPUT_ZIP%"

pause
