#!/bin/bash
# Sync GitHub Copilot Agent PR changes to local repository
# Usage: ./sync-pr.sh <branch-name>
# Example: ./sync-pr.sh copilot/find-cloning-repository-location

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

if [ -z "$1" ]; then
    echo -e "${RED}Error: Branch name required${NC}"
    echo ""
    echo "Usage: ./sync-pr.sh <branch-name>"
    echo ""
    echo "Example:"
    echo "  ./sync-pr.sh copilot/find-cloning-repository-location"
    echo ""
    echo "To see all remote branches:"
    echo "  git fetch origin && git branch -r"
    exit 1
fi

BRANCH=$1

echo ""
echo -e "${CYAN}======================================================${NC}"
echo -e "${CYAN}  Syncing PR Branch from GitHub${NC}"
echo -e "${CYAN}======================================================${NC}"
echo ""

# Check if git repo
if [ ! -d ".git" ]; then
    echo -e "${RED}Error: Not a git repository${NC}"
    echo "Please run this script from the root of your git repository."
    exit 1
fi

# Save current branch
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
echo -e "${YELLOW}Current branch: $CURRENT_BRANCH${NC}"
echo ""

# Fetch latest changes
echo -e "${CYAN}Fetching latest changes from GitHub...${NC}"
git fetch origin

# Check if branch exists on remote
if ! git ls-remote --heads origin "$BRANCH" | grep -q "$BRANCH"; then
    echo -e "${RED}Error: Branch '$BRANCH' does not exist on remote${NC}"
    echo ""
    echo "Available branches:"
    git branch -r | grep -v HEAD
    exit 1
fi

# Check if we have local changes
if ! git diff-index --quiet HEAD --; then
    echo -e "${YELLOW}Warning: You have uncommitted local changes${NC}"
    echo ""
    read -p "Stash changes before switching branches? (y/n): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${CYAN}Stashing local changes...${NC}"
        git stash push -m "Auto-stash before syncing $BRANCH"
        STASHED=1
    else
        echo -e "${YELLOW}Proceeding without stashing...${NC}"
        STASHED=0
    fi
else
    STASHED=0
fi

# Checkout the branch
echo -e "${CYAN}Checking out branch: $BRANCH${NC}"
if git show-ref --verify --quiet "refs/heads/$BRANCH"; then
    # Branch exists locally
    git checkout "$BRANCH"
else
    # Branch doesn't exist locally, create it
    git checkout -b "$BRANCH" "origin/$BRANCH"
fi

# Pull latest changes
echo -e "${CYAN}Pulling latest changes...${NC}"
git pull origin "$BRANCH"

echo ""
echo -e "${GREEN}======================================================${NC}"
echo -e "${GREEN}  ✅ Successfully synced branch: $BRANCH${NC}"
echo -e "${GREEN}======================================================${NC}"
echo ""

# Show recent commits
echo -e "${CYAN}Recent commits:${NC}"
git log --oneline -5
echo ""

# Show what changed
echo -e "${CYAN}Files changed in this branch (vs main):${NC}"
git diff --name-status main...HEAD | head -20
echo ""

if [ "$STASHED" -eq 1 ]; then
    echo -e "${YELLOW}Note: Your previous changes were stashed${NC}"
    echo "To restore them, run: git stash pop"
    echo ""
fi

echo -e "${GREEN}You are now on branch: $BRANCH${NC}"
echo ""
echo "Next steps:"
echo "  - Test the changes locally"
echo "  - To return to main: git checkout main"
echo "  - To merge this branch: git checkout main && git merge $BRANCH"
echo ""
