@echo off
echo ========================================
echo   Quick Restart: Frontend Only
echo ========================================
echo.
echo Use this after agent changes to frontend code.
echo Auto-reload enabled with Vite HMR.
echo.

echo Stopping all frontend processes...
echo Killing processes on port 5173...
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :5173 ^| findstr LISTENING') do (
    taskkill /F /PID %%a >nul 2>&1
)
echo Killing processes on port 5174...
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :5174 ^| findstr LISTENING') do (
    taskkill /F /PID %%a >nul 2>&1
)
echo Killing any Vite processes...
taskkill /F /FI "WINDOWTITLE eq *Frontend*" /IM node.exe >nul 2>&1
timeout /t 2 /nobreak >nul

echo Starting frontend with auto-reload (Vite HMR)...
cd /d "%~dp0frontend"
start "Alliance Frontend - Auto Reload" cmd /k "cd /d %~dp0frontend && echo Frontend starting with auto-reload enabled... && echo. && npm run dev"

echo.
echo Frontend is restarting in a new window!
echo Vite will auto-reload on file changes.
echo.
timeout /t 2 /nobreak >nul

