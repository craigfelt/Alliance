@echo off
echo ========================================
echo   PostgreSQL Setup - Run as Admin
echo ========================================
echo.
echo This script will:
echo   1. Start PostgreSQL service
echo   2. Create the alliance_property database
echo   3. Load the schema with sample data
echo.
echo IMPORTANT: Right-click this file and select "Run as administrator"
echo.
pause

echo.
echo Step 1: Starting PostgreSQL service...
echo ----------------------------------------
net start postgresql-x64-17
if %errorlevel% neq 0 (
    echo.
    echo ERROR: Could not start PostgreSQL service
    echo Please make sure you ran this file as Administrator
    echo.
    pause
    exit /b 1
)

echo.
echo Step 2: Setting up database...
echo ----------------------------------------

REM Set password environment variable
set PGPASSWORD=admin123

REM Check if database exists
psql -U postgres -lqt | findstr /C:"alliance_property" >nul
if %errorlevel% equ 0 (
    echo Database already exists. Dropping and recreating...
    psql -U postgres -c "DROP DATABASE IF EXISTS alliance_property;"
)

echo Creating database...
psql -U postgres -c "CREATE DATABASE alliance_property;"
if %errorlevel% neq 0 (
    echo.
    echo ERROR: Could not create database
    echo Make sure password is set to 'admin123'
    echo Run this command as admin: psql -U postgres -c "ALTER USER postgres WITH PASSWORD 'admin123';"
    echo.
    pause
    exit /b 1
)

echo.
echo Step 3: Loading schema...
echo ----------------------------------------
psql -U postgres -d alliance_property -f database\schema.sql
if %errorlevel% neq 0 (
    echo.
    echo ERROR: Could not load schema
    pause
    exit /b 1
)

echo.
echo ========================================
echo   SUCCESS! Database is ready
echo ========================================
echo.
echo You can now use the app with:
echo   Email:    admin@alliance.co.za
echo   Password: admin123
echo.
echo Press any key to close...
pause >nul
