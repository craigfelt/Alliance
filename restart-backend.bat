@echo off
echo ========================================
echo   Restarting Backend Server
echo ========================================
echo.
echo Auto-restart enabled with nodemon.
echo.

cd /d "%~dp0backend"

echo Stopping any running backend processes...
echo Killing processes on port 5000...
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :5000 ^| findstr LISTENING') do (
    taskkill /F /PID %%a >nul 2>&1
)
taskkill /F /IM nodemon.exe >nul 2>&1
taskkill /F /FI "WINDOWTITLE eq *Backend*" /IM node.exe >nul 2>&1
timeout /t 2 /nobreak >nul

echo.
echo Starting backend server with auto-restart...
echo Backend will run on http://localhost:5000
echo Nodemon will auto-restart on file changes.
echo.
echo Press Ctrl+C to stop the server
echo.

npm run dev

pause

