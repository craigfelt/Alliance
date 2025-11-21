@echo off
echo ========================================
echo Alliance Property Management
echo Starting Backend and Frontend Servers
echo ========================================
echo.
echo This will open TWO terminal windows:
echo   - Backend (Port 5000)
echo   - Frontend (Port 5173)
echo.
echo Press Ctrl+C in each window to stop the servers
echo.
pause

start "Alliance Backend" cmd /k "cd backend && npm run dev"
timeout /t 2 /nobreak > nul
start "Alliance Frontend" cmd /k "cd frontend && npm run dev"

echo.
echo ========================================
echo Servers are starting...
echo ========================================
echo.
echo Backend will run on:  http://localhost:5000
echo Frontend will run on: http://localhost:5173
echo.
echo Default Login:
echo   Email:    admin@alliance.co.za
echo   Password: admin123
echo.
echo Press any key to close this window (servers will keep running)
pause > nul
