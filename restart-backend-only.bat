@echo off
echo ========================================
echo   Quick Restart: Backend Only
echo ========================================
echo.
echo Use this after agent changes to backend code
echo or .env file changes.
echo.

cd backend

echo Stopping backend...
for /f "tokens=2" %%a in ('netstat -ano ^| findstr :5000 ^| findstr LISTENING') do (
    taskkill /F /PID %%a >nul 2>&1
)
timeout /t 1 /nobreak >nul

echo Starting backend...
start "Backend" cmd /k "npm run dev"

echo.
echo Backend is restarting in a new window!
echo.
timeout /t 2 /nobreak >nul

