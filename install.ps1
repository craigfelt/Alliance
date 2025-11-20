# Alliance Property Management System - Windows Installer (PowerShell)
# Run this script to install and setup the application
# Usage: Run PowerShell as Administrator and execute: .\install.ps1

param(
    [switch]$SkipDatabaseSetup = $false
)

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "  Alliance Property Management System - Installer" -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host ""

# Function to check if a command exists
function Test-Command {
    param($Command)
    try {
        if (Get-Command $Command -ErrorAction Stop) {
            return $true
        }
    }
    catch {
        return $false
    }
}

# Check if we're in a cloned repository or need to clone
$REPO_URL = "https://github.com/craigfelt/Alliance.git"
$needsClone = $false
$originalLocation = Get-Location

# Check if we're in the Alliance repository
if (!(Test-Path "package.json") -or !(Test-Path "backend") -or !(Test-Path "frontend")) {
    Write-Host "Repository files not found in current directory." -ForegroundColor Yellow
    Write-Host "This installer will clone the repository from GitHub." -ForegroundColor Yellow
    Write-Host ""
    $needsClone = $true
}

# Step 1: Check Prerequisites
Write-Host "Step 1: Checking Prerequisites..." -ForegroundColor Yellow
Write-Host ""

# Check Node.js
Write-Host "  Checking Node.js..." -NoNewline
if (Test-Command "node") {
    $nodeVersion = node --version
    Write-Host " Found: $nodeVersion" -ForegroundColor Green
    
    # Check if version is 18 or higher
    $versionNumber = [int]($nodeVersion -replace 'v(\d+)\..*', '$1')
    if ($versionNumber -lt 18) {
        Write-Host "    WARNING: Node.js 18+ is recommended. Current: $nodeVersion" -ForegroundColor Red
    }
} else {
    Write-Host " NOT FOUND" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please install Node.js 18+ from https://nodejs.org/" -ForegroundColor Red
    Write-Host "After installation, run this script again." -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit"
    exit 1
}

# Check npm
Write-Host "  Checking npm..." -NoNewline
if (Test-Command "npm") {
    $npmVersion = npm --version
    Write-Host " Found: v$npmVersion" -ForegroundColor Green
} else {
    Write-Host " NOT FOUND" -ForegroundColor Red
    Write-Host "npm should be installed with Node.js. Please reinstall Node.js." -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit"
    exit 1
}

# Check PostgreSQL
Write-Host "  Checking PostgreSQL..." -NoNewline
if (Test-Command "psql") {
    $pgVersion = psql --version
    Write-Host " Found: $pgVersion" -ForegroundColor Green
} else {
    Write-Host " NOT FOUND" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please install PostgreSQL 14+ from https://www.postgresql.org/download/windows/" -ForegroundColor Red
    Write-Host "After installation, make sure to add PostgreSQL to your PATH and run this script again." -ForegroundColor Red
    Write-Host ""
    Write-Host "TIP: During PostgreSQL installation, remember your password for the 'postgres' user." -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Press Enter to exit"
    exit 1
}

# Check Git
Write-Host "  Checking Git..." -NoNewline
if (Test-Command "git") {
    $gitVersion = git --version
    Write-Host " Found: $gitVersion" -ForegroundColor Green
} else {
    if ($needsClone) {
        Write-Host " NOT FOUND" -ForegroundColor Red
        Write-Host ""
        Write-Host "Git is required to clone the repository." -ForegroundColor Red
        Write-Host "Please install Git from https://git-scm.com/download/windows" -ForegroundColor Red
        Write-Host "After installation, run this script again." -ForegroundColor Red
        Write-Host ""
        Read-Host "Press Enter to exit"
        exit 1
    } else {
        Write-Host " NOT FOUND (Optional)" -ForegroundColor Yellow
        Write-Host "    Git is optional but recommended for updates." -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "All required prerequisites are installed!" -ForegroundColor Green
Write-Host ""

# Step 1.5: Clone Repository if needed
if ($needsClone) {
    Write-Host "Step 1.5: Cloning Repository from GitHub..." -ForegroundColor Yellow
    Write-Host ""
    
    $cloneDir = "Alliance"
    $counter = 1
    
    # Find available directory name
    while (Test-Path $cloneDir) {
        $cloneDir = "Alliance_$counter"
        $counter++
    }
    
    Write-Host "  Cloning into: $cloneDir" -ForegroundColor Cyan
    Write-Host "  Repository: $REPO_URL" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  This may take a few minutes depending on your connection..." -ForegroundColor Yellow
    Write-Host ""
    
    git clone $REPO_URL $cloneDir
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failed to clone repository" -ForegroundColor Red
        Write-Host "Please check your internet connection and try again." -ForegroundColor Red
        Write-Host ""
        Read-Host "Press Enter to exit"
        exit 1
    }
    
    Write-Host ""
    Write-Host "  Repository cloned successfully!" -ForegroundColor Green
    Write-Host "  Changing to repository directory..." -ForegroundColor Cyan
    Write-Host ""
    
    Set-Location -Path $cloneDir
}


# Step 2: Install Dependencies
Write-Host "Step 2: Installing Dependencies..." -ForegroundColor Yellow
Write-Host ""

# Install root dependencies
Write-Host "  Installing root dependencies..." -ForegroundColor Cyan
npm install
if ($LASTEXITCODE -ne 0) {
    Write-Host "Failed to install root dependencies" -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit"
    exit 1
}

# Install backend dependencies
Write-Host "  Installing backend dependencies..." -ForegroundColor Cyan
Set-Location -Path "backend"
npm install
if ($LASTEXITCODE -ne 0) {
    Write-Host "Failed to install backend dependencies" -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit"
    exit 1
}
Set-Location -Path ".."

# Install frontend dependencies
Write-Host "  Installing frontend dependencies..." -ForegroundColor Cyan
Set-Location -Path "frontend"
npm install
if ($LASTEXITCODE -ne 0) {
    Write-Host "Failed to install frontend dependencies" -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit"
    exit 1
}
Set-Location -Path ".."

Write-Host ""
Write-Host "Dependencies installed successfully!" -ForegroundColor Green
Write-Host ""

# Step 3: Setup Environment Files
Write-Host "Step 3: Setting up Environment Files..." -ForegroundColor Yellow
Write-Host ""

# Setup backend .env
if (!(Test-Path "backend\.env")) {
    Write-Host "  Creating backend .env file..." -ForegroundColor Cyan
    Copy-Item "backend\.env.example" "backend\.env"
    
    # Prompt for database password
    Write-Host ""
    Write-Host "  Please enter your PostgreSQL password for user 'postgres':" -ForegroundColor Yellow
    $dbPassword = Read-Host "  Password" -AsSecureString
    $dbPasswordPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
        [Runtime.InteropServices.Marshal]::SecureStringToBSTR($dbPassword))
    
    # Update .env file with password
    $envContent = Get-Content "backend\.env"
    $envContent = $envContent -replace "DB_PASSWORD=postgres", "DB_PASSWORD=$dbPasswordPlain"
    $envContent | Set-Content "backend\.env"
    
    Write-Host "  Backend .env created!" -ForegroundColor Green
} else {
    Write-Host "  Backend .env already exists, skipping..." -ForegroundColor Yellow
}

# Setup frontend .env
if (!(Test-Path "frontend\.env")) {
    Write-Host "  Creating frontend .env file..." -ForegroundColor Cyan
    Copy-Item "frontend\.env.example" "frontend\.env"
    Write-Host "  Frontend .env created!" -ForegroundColor Green
} else {
    Write-Host "  Frontend .env already exists, skipping..." -ForegroundColor Yellow
}

Write-Host ""

# Step 4: Setup Database
if (!$SkipDatabaseSetup) {
    Write-Host "Step 4: Setting up Database..." -ForegroundColor Yellow
    Write-Host ""
    
    $dbName = "alliance_property"
    $dbUser = "postgres"
    
    Write-Host "  Database Name: $dbName" -ForegroundColor Cyan
    Write-Host "  Database User: $dbUser" -ForegroundColor Cyan
    Write-Host ""
    
    # Check if database exists
    Write-Host "  Checking if database exists..." -ForegroundColor Cyan
    $env:PGPASSWORD = $dbPasswordPlain
    $dbExists = psql -U $dbUser -lqt 2>$null | Select-String -Pattern "\b$dbName\b" -Quiet
    
    if ($dbExists) {
        Write-Host "  Database '$dbName' already exists." -ForegroundColor Yellow
        $response = Read-Host "  Do you want to drop and recreate it? (y/N)"
        if ($response -eq 'y' -or $response -eq 'Y') {
            Write-Host "  Dropping existing database..." -ForegroundColor Cyan
            dropdb -U $dbUser $dbName
            if ($LASTEXITCODE -ne 0) {
                Write-Host "  Failed to drop database" -ForegroundColor Red
                Write-Host ""
                Read-Host "Press Enter to exit"
                exit 1
            }
        } else {
            Write-Host "  Keeping existing database. Skipping database setup..." -ForegroundColor Yellow
            $SkipDatabaseSetup = $true
        }
    }
    
    if (!$SkipDatabaseSetup) {
        # Create database
        Write-Host "  Creating database..." -ForegroundColor Cyan
        Get-Content "database\create_database.sql" | psql -U $dbUser -d postgres 2>$null
        if ($LASTEXITCODE -ne 0) {
            Write-Host "  Database creation via script had issues, trying createdb command..." -ForegroundColor Yellow
            createdb -U $dbUser $dbName 2>$null
            if ($LASTEXITCODE -ne 0) {
                Write-Host "  Failed to create database" -ForegroundColor Red
                Write-Host "  Make sure PostgreSQL is running and credentials are correct." -ForegroundColor Red
                Write-Host ""
                Read-Host "Press Enter to exit"
                exit 1
            }
        }
        Write-Host "  Database created successfully!" -ForegroundColor Green
        
        # Run schema
        Write-Host "  Applying database schema..." -ForegroundColor Cyan
        Get-Content "database\schema.sql" | psql -U $dbUser -d $dbName
        if ($LASTEXITCODE -ne 0) {
            Write-Host "  Failed to apply schema" -ForegroundColor Red
            Write-Host ""
            Read-Host "Press Enter to exit"
            exit 1
        }
        Write-Host "  Schema applied successfully!" -ForegroundColor Green
    }
    
    # Clear password from environment
    $env:PGPASSWORD = $null
    
    Write-Host ""
} else {
    Write-Host "Step 4: Skipping Database Setup (--SkipDatabaseSetup flag used)" -ForegroundColor Yellow
    Write-Host ""
}

# Installation Complete
Write-Host "======================================================" -ForegroundColor Green
Write-Host "  Installation Completed Successfully!" -ForegroundColor Green
Write-Host "======================================================" -ForegroundColor Green
Write-Host ""

Write-Host "Next Steps:" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Start the Backend Server:" -ForegroundColor Yellow
Write-Host "   - Open a new PowerShell/Command Prompt window"
Write-Host "   - Navigate to: $PWD\backend"
Write-Host "   - Run: npm run dev"
Write-Host "   - Backend will start at: http://localhost:5000"
Write-Host ""

Write-Host "2. Start the Frontend Application:" -ForegroundColor Yellow
Write-Host "   - Open another PowerShell/Command Prompt window"
Write-Host "   - Navigate to: $PWD\frontend"
Write-Host "   - Run: npm run dev"
Write-Host "   - Frontend will start at: http://localhost:5173"
Write-Host ""

Write-Host "3. Access the Application:" -ForegroundColor Yellow
Write-Host "   - Open your browser to: http://localhost:5173"
Write-Host "   - Login with:" -ForegroundColor Green
Write-Host "     Email: admin@alliance.co.za" -ForegroundColor Green
Write-Host "     Password: admin123" -ForegroundColor Green
Write-Host ""

Write-Host "IMPORTANT: Change the default credentials after first login!" -ForegroundColor Red
Write-Host ""

Write-Host "For more information, see README.md and QUICKSTART.md" -ForegroundColor Cyan
Write-Host ""

# Ask if user wants to start the servers now
Write-Host "Would you like to start the application now? (y/N)" -ForegroundColor Yellow
$startNow = Read-Host

if ($startNow -eq 'y' -or $startNow -eq 'Y') {
    Write-Host ""
    Write-Host "Starting backend server..." -ForegroundColor Cyan
    Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$PWD\backend'; npm run dev"
    
    Start-Sleep -Seconds 3
    
    Write-Host "Starting frontend application..." -ForegroundColor Cyan
    Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$PWD\frontend'; npm run dev"
    
    Write-Host ""
    Write-Host "Servers starting in new windows..." -ForegroundColor Green
    Write-Host "The application will be available at http://localhost:5173 in a few seconds." -ForegroundColor Green
    Write-Host ""
    
    Start-Sleep -Seconds 5
    
    # Open browser
    Start-Process "http://localhost:5173"
}

Write-Host ""
Write-Host "Thank you for installing Alliance Property Management System!" -ForegroundColor Cyan
Write-Host ""

# Keep window open so user can read the output
Read-Host "Press Enter to exit"
