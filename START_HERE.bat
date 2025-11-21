@echo off
echo =========================================
echo   Alliance Property Management
echo   Quick Start Guide
echo =========================================
echo.

echo STEP 1: Make sure PostgreSQL is running
echo ----------------------------------------
echo Right-click this window's title bar and select "Run as administrator"
echo Then run: net start postgresql-x64-17
echo.
echo OR open Services (services.msc) and start "postgresql-x64-17"
echo.
pause

echo.
echo STEP 2: Starting Backend Server (Port 5000)
echo ----------------------------------------
echo Opening backend terminal window...
start "Alliance Backend Server" cmd /k "cd /d "%~dp0backend" && echo Starting backend... && npm run dev"

timeout /t 3 /nobreak > nul

echo.
echo STEP 3: Starting Frontend Server (Port 5173)
echo ----------------------------------------
echo Opening frontend terminal window...
start "Alliance Frontend Server" cmd /k "cd /d "%~dp0frontend" && echo Starting frontend... && npm run dev"

echo.
echo =========================================
echo   SERVERS STARTING!
echo =========================================
echo.
echo Backend:  http://localhost:5000
echo Frontend: http://localhost:5173
echo.
echo Login Credentials:
echo   Email:    admin@alliance.co.za
echo   Password: admin123
echo.
echo Wait for both servers to start, then open:
echo   http://localhost:5173
echo.
echo To stop the servers, close both terminal windows
echo or press Ctrl+C in each one.
echo.
pause
