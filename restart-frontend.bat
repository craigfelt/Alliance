@echo off
echo ========================================
echo   Restarting Frontend Server
echo ========================================
echo.
echo Auto-reload enabled with Vite HMR.
echo.

cd /d "%~dp0frontend"

echo Stopping any running frontend processes...
echo Killing processes on ports 5173 and 5174...
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :5173 ^| findstr LISTENING') do (
    taskkill /F /PID %%a >nul 2>&1
)
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :5174 ^| findstr LISTENING') do (
    taskkill /F /PID %%a >nul 2>&1
)
taskkill /F /FI "WINDOWTITLE eq *Frontend*" /IM node.exe >nul 2>&1
timeout /t 2 /nobreak >nul

echo.
echo Starting frontend server with auto-reload...
echo Frontend will run on http://localhost:5173
echo Vite will auto-reload on file changes.
echo.
echo Press Ctrl+C to stop the server
echo.

npm run dev

pause

