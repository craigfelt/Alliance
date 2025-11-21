@echo off
echo ========================================
echo   Quick Restart: Frontend Only
echo ========================================
echo.
echo Use this after agent changes to frontend code.
echo.

cd frontend

echo Stopping frontend...
for /f "tokens=2" %%a in ('netstat -ano ^| findstr :5173 ^| findstr LISTENING') do (
    taskkill /F /PID %%a >nul 2>&1
)
timeout /t 1 /nobreak >nul

echo Starting frontend...
start "Frontend" cmd /k "npm run dev"

echo.
echo Frontend is restarting in a new window!
echo.
timeout /t 2 /nobreak >nul

