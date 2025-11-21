@echo off
echo ========================================
echo   Quick Restart: Backend Only
echo ========================================
echo.
echo Use this after agent changes to backend code
echo or .env file changes.
echo Auto-restart enabled with nodemon.
echo.

echo Stopping all backend processes...
echo Killing processes on port 5000...
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :5000 ^| findstr LISTENING') do (
    taskkill /F /PID %%a >nul 2>&1
)
echo Killing any nodemon processes...
taskkill /F /IM nodemon.exe >nul 2>&1
taskkill /F /FI "WINDOWTITLE eq *Backend*" /IM node.exe >nul 2>&1
timeout /t 2 /nobreak >nul

echo Starting backend with auto-restart (nodemon)...
cd /d "%~dp0backend"
start "Alliance Backend - Auto Restart" cmd /k "cd /d %~dp0backend && echo Backend starting with auto-restart enabled... && echo. && npm run dev"

echo.
echo Backend is restarting in a new window!
echo Nodemon will auto-restart on file changes.
echo.
timeout /t 2 /nobreak >nul

