@echo off
echo ========================================
echo   Restarting Frontend Server
echo ========================================
echo.

cd frontend

echo Stopping any running frontend processes...
taskkill /F /IM node.exe /FI "WINDOWTITLE eq *frontend*" 2>nul
timeout /t 2 /nobreak >nul

echo.
echo Starting frontend server...
echo Frontend will run on http://localhost:5173
echo.
echo Press Ctrl+C to stop the server
echo.

npm run dev

pause

