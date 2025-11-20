# GitHub Copilot Agent Workflow Guide

## Understanding the Workflow

When you use **GitHub Copilot Agent** (via PR comments or issues), the agent works in an isolated sandbox environment and makes changes by:

1. ✅ Creating commits in the sandbox
2. ✅ Pushing commits to GitHub via Pull Requests
3. ❌ **Cannot** directly modify your local files (it has no access to your PC)

## How to Sync Changes to Your Local Machine

### Quick Method: Pull the PR Branch

When the Copilot Agent creates or updates a PR, you can sync those changes locally:

```bash
# 1. Fetch the latest changes from GitHub
git fetch origin

# 2. Checkout the PR branch (replace with actual branch name)
git checkout copilot/find-cloning-repository-location

# 3. Pull the latest changes
git pull origin copilot/find-cloning-repository-location
```

### One-Command Sync Script

Save this as `sync-pr.sh` (Linux/Mac) or `sync-pr.bat` (Windows):

**Linux/Mac (`sync-pr.sh`):**
```bash
#!/bin/bash
# Usage: ./sync-pr.sh <branch-name>
# Example: ./sync-pr.sh copilot/find-cloning-repository-location

if [ -z "$1" ]; then
    echo "Usage: ./sync-pr.sh <branch-name>"
    echo "Example: ./sync-pr.sh copilot/find-cloning-repository-location"
    exit 1
fi

BRANCH=$1
echo "Syncing branch: $BRANCH"
git fetch origin
git checkout $BRANCH
git pull origin $BRANCH
echo "✅ Synced successfully!"
```

**Windows (`sync-pr.bat`):**
```batch
@echo off
REM Usage: sync-pr.bat <branch-name>
REM Example: sync-pr.bat copilot/find-cloning-repository-location

if "%1"=="" (
    echo Usage: sync-pr.bat ^<branch-name^>
    echo Example: sync-pr.bat copilot/find-cloning-repository-location
    exit /b 1
)

set BRANCH=%1
echo Syncing branch: %BRANCH%
git fetch origin
git checkout %BRANCH%
git pull origin %BRANCH%
echo ✅ Synced successfully!
```

## Alternative Workflows

### Option 1: Merge PR on GitHub, Then Pull Main

1. Review the PR on GitHub
2. Click "Merge Pull Request"
3. In your local repository:
```bash
git checkout main
git pull origin main
```

### Option 2: Cherry-Pick Specific Commits

If you only want specific changes:
```bash
# Find the commit hash from the PR
git fetch origin
git log origin/copilot/find-cloning-repository-location

# Cherry-pick the commit
git cherry-pick <commit-hash>
```

### Option 3: Download and Apply Patch

1. Go to the PR on GitHub
2. Add `.patch` to the URL (e.g., `https://github.com/craigfelt/Alliance/pull/XX.patch`)
3. Apply locally:
```bash
curl https://github.com/craigfelt/Alliance/pull/XX.patch | git apply
```

## Using GitHub Copilot on Your PC

Yes! You can use GitHub Copilot locally without the agent. Here are your options:

### 1. GitHub Copilot in VS Code (Most Popular)

**Install:**
1. Install [Visual Studio Code](https://code.visualstudio.com/)
2. Install the [GitHub Copilot extension](https://marketplace.visualstudio.com/items?itemName=GitHub.copilot)
3. Sign in with your GitHub account

**Features:**
- ✅ Code suggestions as you type
- ✅ Chat interface (Copilot Chat)
- ✅ Inline code editing
- ✅ Works offline (after initial authentication)
- ✅ **Changes are made directly to your local files**

### 2. GitHub Copilot in Other IDEs

Available for:
- Visual Studio
- JetBrains IDEs (IntelliJ, PyCharm, WebStorm, etc.)
- Neovim
- Azure Data Studio

### 3. GitHub Copilot CLI

Command-line tool for terminal assistance:
```bash
# Install
npm install -g @githubnext/github-copilot-cli

# Use
gh copilot suggest "how to list files"
gh copilot explain "git rebase -i HEAD~3"
```

## Comparison: Agent vs Local Copilot

| Feature | GitHub Copilot Agent | GitHub Copilot (VS Code) |
|---------|---------------------|--------------------------|
| **Where it runs** | GitHub (sandbox) | Your PC |
| **File changes** | Via PR commits | Direct to local files |
| **Access** | Via PR comments/issues | Built into editor |
| **Autonomous** | Yes (multi-step tasks) | No (assists as you code) |
| **Best for** | Large tasks, reviews | Active development |
| **Requires internet** | Yes | Only for authentication |

## Recommended Workflow

For the best experience, use **both**:

### For Active Development (Local Copilot)
```
1. Open VS Code with GitHub Copilot extension
2. Code with real-time AI assistance
3. Commit and push changes normally
```

### For Large Tasks or Reviews (Copilot Agent)
```
1. Create an issue or comment on PR
2. Tag @copilot with your request
3. Agent creates PR with changes
4. Sync PR to local using scripts above
5. Review, test, and merge
```

## Quick Reference Card

### Get Latest Agent Changes
```bash
git fetch origin && git checkout <pr-branch> && git pull origin <pr-branch>
```

### Return to Main Branch
```bash
git checkout main && git pull origin main
```

### Check All Remote Branches
```bash
git fetch origin && git branch -r
```

### View What Changed in PR
```bash
git fetch origin
git diff main..origin/<pr-branch>
```

## Troubleshooting

### "Branch already exists" when checking out
```bash
# Delete local branch and re-fetch
git branch -D copilot/find-cloning-repository-location
git fetch origin
git checkout copilot/find-cloning-repository-location
```

### "Merge conflicts" when pulling
```bash
# Stash your local changes first
git stash
git pull origin <pr-branch>
git stash pop  # Re-apply your changes
```

### See what will be pulled before pulling
```bash
git fetch origin
git log HEAD..origin/<pr-branch>
git diff HEAD..origin/<pr-branch>
```

## Summary

**The Copilot Agent cannot push directly to your local files** because:
- It runs in a GitHub-hosted sandbox environment
- It has no access to your local filesystem
- All changes go through GitHub (via PRs)

**To sync changes:**
- Use `git pull` on the PR branch (fastest)
- Or merge the PR on GitHub and pull main
- For local development, use GitHub Copilot in VS Code

**Best of both worlds:**
- Use Copilot Agent for large tasks and code reviews
- Use GitHub Copilot (VS Code) for daily coding with direct local file access

---

Need help? Check the [GitHub Copilot documentation](https://docs.github.com/en/copilot)
