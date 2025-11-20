@echo off
REM Alliance Property Management System - PowerShell Installer Launcher
REM This launcher ensures PowerShell runs with the right settings
REM It bypasses execution policy restrictions for the installer script only

echo.
echo ========================================================================
echo   Alliance Property Management System - PowerShell Installer Launcher
echo ========================================================================
echo.
echo This launcher will run the PowerShell installer with correct settings.
echo.
echo Benefits of using this launcher:
echo   - Automatically bypasses PowerShell execution policy restrictions
echo   - No "script cannot be loaded" or "not digitally signed" errors
echo   - Keeps the window open so you can see all output
echo.
echo Starting installer...
echo.

REM Run PowerShell script with ExecutionPolicy Bypass for this session only
REM -NoExit keeps the window open after execution
powershell.exe -ExecutionPolicy Bypass -NoExit -File "%~dp0install.ps1"

REM If PowerShell exits with error, pause here
if %errorlevel% neq 0 (
    echo.
    echo PowerShell installer exited with an error.
    pause
)
