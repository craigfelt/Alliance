@echo off
REM Alliance Property Management System - Windows Installer (Batch)
REM Run this script to install and setup the application
REM Usage: Double-click this file or run from Command Prompt

setlocal enabledelayedexpansion

echo.
echo ======================================================
echo   Alliance Property Management System - Installer
echo ======================================================
echo.

REM Check if we're in a cloned repository or need to clone
set REPO_URL=https://github.com/craigfelt/Alliance.git
set NEEDS_CLONE=0
set ORIGINAL_DIR=%CD%

REM Check if we're in the Alliance repository (need ALL files to exist)
if not exist "package.json" set NEEDS_CLONE=1
if not exist "backend" (
    set NEEDS_CLONE=1
)
if not exist "frontend" (
    set NEEDS_CLONE=1
)

if %NEEDS_CLONE% equ 1 (
    echo Repository files not found in current directory.
    echo This installer will clone the repository from GitHub.
    echo.
)

REM Step 1: Check Prerequisites
echo Step 1: Checking Prerequisites...
echo.

REM Check Node.js
echo   Checking Node.js...
where node >nul 2>&1
if %errorlevel% neq 0 (
    echo   [ERROR] Node.js NOT FOUND
    echo.
    echo   Please install Node.js 18+ from https://nodejs.org/
    echo   After installation, run this script again.
    echo.
    pause
    exit /b 1
)
for /f "tokens=*" %%i in ('node --version') do set NODE_VERSION=%%i
echo   Found: %NODE_VERSION%

REM Check npm
echo   Checking npm...
where npm >nul 2>&1
if %errorlevel% neq 0 (
    echo   [ERROR] npm NOT FOUND
    echo   npm should be installed with Node.js. Please reinstall Node.js.
    pause
    exit /b 1
)
for /f "tokens=*" %%i in ('npm --version') do set NPM_VERSION=%%i
echo   Found: v%NPM_VERSION%

REM Check PostgreSQL
echo   Checking PostgreSQL...
where psql >nul 2>&1
if %errorlevel% neq 0 (
    echo   [ERROR] PostgreSQL NOT FOUND
    echo.
    echo   Please install PostgreSQL 14+ from:
    echo   https://www.postgresql.org/download/windows/
    echo.
    echo   After installation, make sure to add PostgreSQL to your PATH
    echo   and run this script again.
    echo.
    echo   TIP: During installation, remember the password for 'postgres' user.
    echo.
    pause
    exit /b 1
)
for /f "tokens=*" %%i in ('psql --version') do set PG_VERSION=%%i
echo   Found: %PG_VERSION%

REM Check Git
echo   Checking Git...
where git >nul 2>&1
if %errorlevel% neq 0 (
    if %NEEDS_CLONE% equ 1 (
        echo   [ERROR] Git NOT FOUND
        echo.
        echo   Git is required to clone the repository.
        echo   Please install Git from https://git-scm.com/download/windows
        echo   After installation, run this script again.
        echo.
        pause
        exit /b 1
    ) else (
        echo   NOT FOUND (Optional - Git is recommended for updates)
    )
) else (
    for /f "tokens=*" %%i in ('git --version') do set GIT_VERSION=%%i
    echo   Found: !GIT_VERSION!
)

echo.
echo All required prerequisites are installed!
echo.

REM Step 1.5: Clone Repository if needed
if %NEEDS_CLONE% equ 1 (
    echo Step 1.5: Cloning Repository from GitHub...
    echo.
    
    set CLONE_DIR=Alliance
    set COUNTER=1
    
    REM Find available directory name
    :find_dir
    if exist "!CLONE_DIR!" (
        set CLONE_DIR=Alliance_!COUNTER!
        set /a COUNTER=!COUNTER!+1
        goto find_dir
    )
    
    echo   Cloning into directory: !CLONE_DIR!
    echo   Full path: %CD%\!CLONE_DIR!
    echo   Repository: %REPO_URL%
    echo.
    echo   This may take a few minutes depending on your connection...
    echo.
    
    git clone %REPO_URL% !CLONE_DIR!
    if %errorlevel% neq 0 (
        echo [ERROR] Failed to clone repository
        echo Please check your internet connection and try again.
        pause
        exit /b 1
    )
    
    echo.
    echo   Repository cloned successfully!
    echo   Location: %CD%\!CLONE_DIR!
    echo   Changing to repository directory...
    echo.
    
    cd !CLONE_DIR!
)


REM Step 2: Install Dependencies
echo Step 2: Installing Dependencies...
echo.

echo   Installing root dependencies...
call npm install
if %errorlevel% neq 0 (
    echo [ERROR] Failed to install root dependencies
    pause
    exit /b 1
)

echo   Installing backend dependencies...
cd backend
call npm install
if %errorlevel% neq 0 (
    echo [ERROR] Failed to install backend dependencies
    pause
    exit /b 1
)
cd ..

echo   Installing frontend dependencies...
cd frontend
call npm install
if %errorlevel% neq 0 (
    echo [ERROR] Failed to install frontend dependencies
    pause
    exit /b 1
)
cd ..

echo.
echo Dependencies installed successfully!
echo.

REM Step 3: Setup Environment Files
echo Step 3: Setting up Environment Files...
echo.

REM Setup backend .env
if not exist "backend\.env" (
    echo   Creating backend .env file...
    copy "backend\.env.example" "backend\.env" >nul
    echo   Backend .env created!
    echo.
    echo   IMPORTANT: Edit backend\.env and set your PostgreSQL password
    echo   The file has been created with default settings.
    echo.
) else (
    echo   Backend .env already exists, skipping...
)

REM Setup frontend .env
if not exist "frontend\.env" (
    echo   Creating frontend .env file...
    copy "frontend\.env.example" "frontend\.env" >nul
    echo   Frontend .env created!
) else (
    echo   Frontend .env already exists, skipping...
)

echo.

REM Step 4: Setup Database
echo Step 4: Setting up Database...
echo.
echo   Database Name: alliance_property
echo   Database User: postgres
echo.
echo   Please make sure PostgreSQL is running before proceeding.
echo.
set /p DB_PASSWORD="   Enter PostgreSQL password for 'postgres' user: "

REM Set PostgreSQL password for commands
set PGPASSWORD=%DB_PASSWORD%

REM Check if database exists
echo.
echo   Checking if database exists...
psql -U postgres -lqt 2>nul | findstr /C:"alliance_property" >nul 2>&1
if %errorlevel% equ 0 (
    echo   Database 'alliance_property' already exists.
    set /p RECREATE="   Do you want to drop and recreate it? (y/N): "
    if /i "!RECREATE!"=="y" (
        echo   Dropping existing database...
        dropdb -U postgres alliance_property
        if !errorlevel! neq 0 (
            echo   [ERROR] Failed to drop database
            pause
            exit /b 1
        )
        set CREATE_DB=1
    ) else (
        echo   Keeping existing database. Skipping database setup...
        set CREATE_DB=0
    )
) else (
    set CREATE_DB=1
)

if %CREATE_DB% equ 1 (
    echo   Creating database...
    psql -U postgres -d postgres -f database\create_database.sql >nul 2>&1
    if %errorlevel% neq 0 (
        echo   [WARNING] Database creation via script had issues, trying createdb command...
        createdb -U postgres alliance_property >nul 2>&1
        if !errorlevel! neq 0 (
            echo   [ERROR] Failed to create database
            echo   Make sure PostgreSQL is running and credentials are correct.
            pause
            exit /b 1
        )
    )
    echo   Database created successfully!
    
    echo   Applying database schema...
    psql -U postgres -d alliance_property -f database\schema.sql >nul
    if %errorlevel% neq 0 (
        echo   [ERROR] Failed to apply schema
        pause
        exit /b 1
    )
    echo   Schema applied successfully!
)

REM Clear password
set PGPASSWORD=

echo.
echo ======================================================
echo   Installation Completed Successfully!
echo ======================================================
echo.

echo Next Steps:
echo.
echo 1. Start the Backend Server:
echo    - Open a new Command Prompt window
echo    - Navigate to: %CD%\backend
echo    - Run: npm run dev
echo    - Backend will start at: http://localhost:5000
echo.
echo 2. Start the Frontend Application:
echo    - Open another Command Prompt window
echo    - Navigate to: %CD%\frontend
echo    - Run: npm run dev
echo    - Frontend will start at: http://localhost:5173
echo.
echo 3. Access the Application:
echo    - Open your browser to: http://localhost:5173
echo    - Login with:
echo      Email: admin@alliance.co.za
echo      Password: admin123
echo.
echo IMPORTANT: Change the default credentials after first login!
echo.
echo For more information, see README.md and QUICKSTART.md
echo.

set /p START_NOW="Would you like to start the application now? (y/N): "
if /i "%START_NOW%"=="y" (
    echo.
    echo Starting backend server in a new window...
    start cmd /k "cd /d %CD%\backend && npm run dev"
    
    timeout /t 3 /nobreak >nul
    
    echo Starting frontend application in a new window...
    start cmd /k "cd /d %CD%\frontend && npm run dev"
    
    echo.
    echo Servers starting in new windows...
    echo The application will be available at http://localhost:5173 in a few seconds.
    
    timeout /t 5 /nobreak >nul
    
    REM Open browser
    start http://localhost:5173
)

echo.
echo Thank you for installing Alliance Property Management System!
echo.
pause
