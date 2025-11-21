@echo off
echo ========================================
echo   Restarting Both Servers
echo ========================================
echo.
echo Auto-restart/reload enabled for both servers.
echo.

echo Stopping all running processes...
echo Killing backend processes (port 5000)...
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :5000 ^| findstr LISTENING') do (
    taskkill /F /PID %%a >nul 2>&1
)
echo Killing frontend processes (ports 5173, 5174)...
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :5173 ^| findstr LISTENING') do (
    taskkill /F /PID %%a >nul 2>&1
)
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :5174 ^| findstr LISTENING') do (
    taskkill /F /PID %%a >nul 2>&1
)
echo Killing Node processes...
taskkill /F /IM nodemon.exe >nul 2>&1
taskkill /F /FI "WINDOWTITLE eq *Backend*" /IM node.exe >nul 2>&1
taskkill /F /FI "WINDOWTITLE eq *Frontend*" /IM node.exe >nul 2>&1
timeout /t 2 /nobreak >nul

echo.
echo Starting Backend Server (with auto-restart)...
start "Alliance Backend - Auto Restart" cmd /k "cd /d %~dp0backend && echo Backend starting with nodemon auto-restart... && echo. && npm run dev"

timeout /t 3 /nobreak >nul

echo Starting Frontend Server (with auto-reload)...
start "Alliance Frontend - Auto Reload" cmd /k "cd /d %~dp0frontend && echo Frontend starting with Vite auto-reload... && echo. && npm run dev"

echo.
echo ========================================
echo   Both servers are starting!
echo ========================================
echo.
echo Backend:  http://localhost:5000 (nodemon auto-restart)
echo Frontend: http://localhost:5173 (Vite auto-reload)
echo.
echo Both servers will auto-restart/reload on file changes.
echo Close the windows to stop the servers.
echo.
pause

