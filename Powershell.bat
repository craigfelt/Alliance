@echo off
REM Launcher for PowerShell installer
REM This ensures PowerShell runs with the right settings and keeps window open

echo.
echo Starting Alliance Property Management System Installer (PowerShell)...
echo.
echo If you see a security warning, you may need to allow script execution.
echo.

REM Run PowerShell script with ExecutionPolicy Bypass for this session only
powershell.exe -ExecutionPolicy Bypass -NoExit -File "%~dp0install.ps1"

REM If PowerShell exits with error, pause here
if %errorlevel% neq 0 (
    echo.
    echo PowerShell installer exited with an error.
    pause
)