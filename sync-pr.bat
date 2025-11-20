@echo off
REM Sync GitHub Copilot Agent PR changes to local repository
REM Usage: sync-pr.bat <branch-name>
REM Example: sync-pr.bat copilot/find-cloning-repository-location

setlocal enabledelayedexpansion

if "%1"=="" (
    echo Error: Branch name required
    echo.
    echo Usage: sync-pr.bat ^<branch-name^>
    echo.
    echo Example:
    echo   sync-pr.bat copilot/find-cloning-repository-location
    echo.
    echo To see all remote branches:
    echo   git fetch origin ^&^& git branch -r
    exit /b 1
)

set BRANCH=%1

echo.
echo ======================================================
echo   Syncing PR Branch from GitHub
echo ======================================================
echo.

REM Check if git repo
if not exist ".git" (
    echo Error: Not a git repository
    echo Please run this script from the root of your git repository.
    exit /b 1
)

REM Save current branch
for /f "tokens=*" %%i in ('git rev-parse --abbrev-ref HEAD') do set CURRENT_BRANCH=%%i
echo Current branch: %CURRENT_BRANCH%
echo.

REM Fetch latest changes
echo Fetching latest changes from GitHub...
git fetch origin
if %errorlevel% neq 0 (
    echo Error: Failed to fetch from GitHub
    exit /b 1
)

REM Check if branch exists on remote
git ls-remote --heads origin %BRANCH% | findstr "%BRANCH%" >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Branch '%BRANCH%' does not exist on remote
    echo.
    echo Available branches:
    git branch -r | findstr /v "HEAD"
    exit /b 1
)

REM Check if we have local changes
git diff-index --quiet HEAD --
if %errorlevel% neq 0 (
    echo Warning: You have uncommitted local changes
    echo.
    set /p STASH="Stash changes before switching branches? (y/N): "
    if /i "!STASH!"=="y" (
        echo Stashing local changes...
        git stash push -m "Auto-stash before syncing %BRANCH%"
        set STASHED=1
    ) else (
        echo Proceeding without stashing...
        set STASHED=0
    )
) else (
    set STASHED=0
)

REM Checkout the branch
echo Checking out branch: %BRANCH%
git show-ref --verify --quiet refs/heads/%BRANCH%
if %errorlevel% equ 0 (
    REM Branch exists locally
    git checkout %BRANCH%
) else (
    REM Branch doesn't exist locally, create it
    git checkout -b %BRANCH% origin/%BRANCH%
)

if %errorlevel% neq 0 (
    echo Error: Failed to checkout branch
    exit /b 1
)

REM Pull latest changes
echo Pulling latest changes...
git pull origin %BRANCH%
if %errorlevel% neq 0 (
    echo Error: Failed to pull changes
    exit /b 1
)

echo.
echo ======================================================
echo   ✅ Successfully synced branch: %BRANCH%
echo ======================================================
echo.

REM Show recent commits
echo Recent commits:
git log --oneline -5
echo.

REM Show what changed
echo Files changed in this branch (vs main):
git diff --name-status main...HEAD | findstr /v "^$" | more +0 /e +20
echo.

if %STASHED% equ 1 (
    echo Note: Your previous changes were stashed
    echo To restore them, run: git stash pop
    echo.
)

echo You are now on branch: %BRANCH%
echo.
echo Next steps:
echo   - Test the changes locally
echo   - To return to main: git checkout main
echo   - To merge this branch: git checkout main ^&^& git merge %BRANCH%
echo.

endlocal
