@echo off
echo ========================================
echo   Restarting Backend Server
echo ========================================
echo.

cd backend

echo Stopping any running backend processes...
taskkill /F /IM node.exe /FI "WINDOWTITLE eq *backend*" 2>nul
timeout /t 2 /nobreak >nul

echo.
echo Starting backend server...
echo Backend will run on http://localhost:5000
echo.
echo Press Ctrl+C to stop the server
echo.

npm run dev

pause

