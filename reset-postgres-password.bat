@echo off
REM PostgreSQL Password Reset Helper for Windows
REM This script helps you reset your PostgreSQL password

echo.
echo ================================================================
echo   PostgreSQL Password Reset Helper
echo ================================================================
echo.
echo This script will help you reset the PostgreSQL 'postgres' user password.
echo.
echo PREREQUISITES:
echo   - PostgreSQL must be installed
echo   - You need Administrator privileges
echo.
echo WARNING: This script will temporarily make PostgreSQL less secure.
echo          Follow all steps carefully and restore security at the end.
echo.
pause

REM Check if running as Administrator
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: This script requires Administrator privileges.
    echo.
    echo Please right-click this file and select "Run as Administrator"
    echo.
    pause
    exit /b 1
)

echo.
echo Step 1: Finding PostgreSQL installation...
echo.

REM Try to find PostgreSQL installation
set PG_PATH=
for %%v in (16 15 14 13 12) do (
    if exist "C:\Program Files\PostgreSQL\%%v\bin\psql.exe" (
        set PG_PATH=C:\Program Files\PostgreSQL\%%v
        set PG_VERSION=%%v
        goto :found
    )
)

:found
if "%PG_PATH%"=="" (
    echo ERROR: PostgreSQL installation not found in default location.
    echo.
    echo Please check your PostgreSQL installation path and edit this script
    echo to set PG_PATH manually, or use the manual method described in:
    echo POSTGRESQL_PASSWORD_SETUP.md
    echo.
    pause
    exit /b 1
)

echo Found PostgreSQL %PG_VERSION% at: %PG_PATH%
echo.

REM Set paths
set PG_BIN=%PG_PATH%\bin
set PG_DATA=%PG_PATH%\data
set PG_HBA=%PG_DATA%\pg_hba.conf

echo Step 2: Stopping PostgreSQL service...
echo.

REM Find and stop the service
for /f "tokens=*" %%s in ('sc query ^| findstr /i "postgresql"') do set SERVICE_LINE=%%s
for /f "tokens=2" %%s in ('sc query ^| findstr /i "SERVICE_NAME.*postgresql"') do set PG_SERVICE=%%s

if "%PG_SERVICE%"=="" (
    echo ERROR: Could not find PostgreSQL service.
    echo Please stop the service manually via services.msc
    echo.
    pause
    exit /b 1
)

echo Found service: %PG_SERVICE%
net stop %PG_SERVICE%
if %errorlevel% neq 0 (
    echo ERROR: Failed to stop PostgreSQL service.
    echo Please stop it manually via services.msc
    echo.
    pause
    exit /b 1
)

echo PostgreSQL service stopped successfully.
echo.

echo Step 3: Backing up pg_hba.conf...
echo.

copy "%PG_HBA%" "%PG_HBA%.backup" >nul
if %errorlevel% neq 0 (
    echo ERROR: Failed to backup pg_hba.conf
    echo Starting PostgreSQL service...
    net start %PG_SERVICE%
    pause
    exit /b 1
)

echo Backup created: %PG_HBA%.backup
echo.

echo Step 4: Modifying pg_hba.conf to allow password reset...
echo.

REM Create a temporary version with trust authentication
powershell -Command "(Get-Content '%PG_HBA%') -replace 'scram-sha-256', 'trust' -replace 'md5', 'trust' | Set-Content '%PG_HBA%'"

echo pg_hba.conf modified (authentication set to 'trust')
echo.

echo Step 5: Starting PostgreSQL service...
echo.

net start %PG_SERVICE%
if %errorlevel% neq 0 (
    echo ERROR: Failed to start PostgreSQL service.
    echo Restoring backup...
    copy "%PG_HBA%.backup" "%PG_HBA%" >nul
    pause
    exit /b 1
)

echo PostgreSQL service started.
echo.
timeout /t 3 /nobreak >nul

echo Step 6: Resetting password...
echo.
echo Please enter your new password for the 'postgres' user.
echo IMPORTANT: Remember this password! You'll need it to use Alliance.
echo.
set /p NEW_PASSWORD="Enter new password: "

if "%NEW_PASSWORD%"=="" (
    echo ERROR: Password cannot be empty.
    echo Restoring configuration...
    copy "%PG_HBA%.backup" "%PG_HBA%" >nul
    net stop %PG_SERVICE%
    net start %PG_SERVICE%
    pause
    exit /b 1
)

REM Reset the password
"%PG_BIN%\psql.exe" -U postgres -c "ALTER USER postgres PASSWORD '%NEW_PASSWORD%';"
if %errorlevel% neq 0 (
    echo ERROR: Failed to reset password.
    echo Restoring configuration...
    copy "%PG_HBA%.backup" "%PG_HBA%" >nul
    net stop %PG_SERVICE%
    net start %PG_SERVICE%
    pause
    exit /b 1
)

echo.
echo Password reset successfully!
echo.

echo Step 7: Restoring security settings...
echo.

REM Stop service
net stop %PG_SERVICE% >nul

REM Restore original pg_hba.conf
copy "%PG_HBA%.backup" "%PG_HBA%" >nul

REM Start service
net start %PG_SERVICE% >nul

echo Security settings restored.
echo.

echo Step 8: Testing new password...
echo.

set PGPASSWORD=%NEW_PASSWORD%
"%PG_BIN%\psql.exe" -U postgres -c "SELECT version();" >nul 2>&1
if %errorlevel% neq 0 (
    echo WARNING: Password test failed. There may be an issue.
    echo Please try connecting manually: psql -U postgres
    set PGPASSWORD=
) else (
    echo Password test successful!
    set PGPASSWORD=
)

echo.
echo ================================================================
echo   Password Reset Complete!
echo ================================================================
echo.
echo Your new PostgreSQL password is: %NEW_PASSWORD%
echo.
echo IMPORTANT NEXT STEPS:
echo.
echo 1. Write down your password in a secure location
echo.
echo 2. Update Alliance configuration (if already installed):
echo    - Open: backend\.env
echo    - Change: DB_PASSWORD=%NEW_PASSWORD%
echo    - Save and restart the backend server
echo.
echo 3. Test the connection:
echo    psql -U postgres
echo.
echo Backup file saved at: %PG_HBA%.backup
echo You can delete this file once you've verified everything works.
echo.
pause
