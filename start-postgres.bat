@echo off
echo Starting PostgreSQL service...
net start postgresql-x64-17
if %errorlevel% == 0 (
    echo PostgreSQL service started successfully!
) else (
    echo Failed to start PostgreSQL service.
    echo Please run this file as Administrator.
)
pause
