# How to Clone Alliance Repository to Your PC

This guide walks you through cloning the Alliance Property Management System repository to your local computer.

## 📋 Prerequisites

Before cloning, ensure you have:

1. **Git installed on your computer**
   - Windows: Download from https://git-scm.com/download/win
   - Mac: Install via Xcode Command Line Tools or Homebrew (`brew install git`)
   - Linux: `sudo apt-get install git` (Ubuntu/Debian) or `sudo yum install git` (RedHat/CentOS)
   - Verify installation: `git --version`

2. **A GitHub account** (optional, but recommended for contributing)

3. **Basic command-line knowledge**

## 🚀 Method 1: Clone Using Git Command Line (Recommended)

This is the most common and recommended method for developers.

### Step-by-Step Instructions

**1. Open your terminal/command prompt:**
   - **Windows**: Git Bash, PowerShell, or Command Prompt
   - **Mac**: Terminal (Applications → Utilities → Terminal)
   - **Linux**: Terminal (Ctrl+Alt+T)

**2. Navigate to where you want to store the project:**
```bash
# Example: Navigate to your projects folder
cd ~/Documents/Projects

# Or on Windows:
cd C:\Users\YourUsername\Documents\Projects
```

**3. Clone the repository:**
```bash
git clone https://github.com/craigfelt/Alliance.git
```

**4. Navigate into the cloned directory:**
```bash
cd Alliance
```

**5. Verify the clone was successful:**
```bash
ls -la          # On Mac/Linux
dir             # On Windows
git status      # Check Git status
```

You should see all project files including:
- `README.md`
- `package.json`
- `backend/` folder
- `frontend/` folder
- `database/` folder
- Installation scripts (`install.sh`, `install.ps1`, `install.bat`)

### What This Does

The `git clone` command:
- Creates a new folder named `Alliance`
- Downloads all files from the GitHub repository
- Sets up Git tracking (allows you to pull updates)
- Creates a local copy you can modify

## 🔐 Method 2: Clone with SSH (For Contributors)

If you plan to contribute to the project, use SSH for better security.

### Setup SSH Key (One-time setup)

**1. Check if you already have an SSH key:**
```bash
ls -la ~/.ssh
```

**2. If you don't have one, generate it:**
```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
```
Press Enter to accept the default location. Optionally set a passphrase.

**3. Add SSH key to ssh-agent:**
```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

**4. Copy your public key:**
```bash
cat ~/.ssh/id_ed25519.pub
```

**5. Add to GitHub:**
- Go to GitHub.com → Settings → SSH and GPG keys
- Click "New SSH key"
- Paste your public key
- Click "Add SSH key"

### Clone Using SSH

```bash
git clone git@github.com:craigfelt/Alliance.git
cd Alliance
```

## 📦 Method 3: Download ZIP (No Git Required)

If you don't have Git or don't need version control:

**1. Go to the repository:**
   - Visit: https://github.com/craigfelt/Alliance

**2. Download the ZIP:**
   - Click the green **"Code"** button
   - Select **"Download ZIP"**

**3. Extract the archive:**
   - Windows: Right-click → Extract All
   - Mac: Double-click the .zip file
   - Linux: `unzip Alliance-main.zip`

**4. Navigate to the extracted folder:**
```bash
cd Alliance-main
```

> **Note:** This method doesn't include Git history. You won't be able to use `git pull` to get updates.

## 🔄 Method 4: Clone a Specific Branch

To clone a specific branch instead of main:

```bash
git clone -b branch-name https://github.com/craigfelt/Alliance.git
```

For example, to clone a development branch:
```bash
git clone -b develop https://github.com/craigfelt/Alliance.git
```

## 📂 Recommended Directory Structure

We recommend organizing your projects like this:

```
Documents/
  └── Projects/
      └── Alliance/          ← Clone here
          ├── backend/
          ├── frontend/
          ├── database/
          └── ...
```

Or for Windows:
```
C:\Users\YourUsername\
  └── Projects\
      └── Alliance\         ← Clone here
          ├── backend\
          ├── frontend\
          ├── database\
          └── ...
```

## ✅ After Cloning - Next Steps

Once you've successfully cloned the repository:

### 1. Verify the Clone

Check that you have all the necessary files:
```bash
ls -la                    # View all files
git remote -v             # Verify remote repository
git branch               # Check current branch
```

### 2. Install and Setup

Choose one of these options:

**Option A: Use Automated Installer (Easiest)**
```bash
# Windows PowerShell
.\install.ps1

# Windows Command Prompt
install.bat

# Linux/Mac
chmod +x install.sh
./install.sh
```

**Option B: Manual Setup**
Follow the instructions in [QUICKSTART.md](QUICKSTART.md) or [INSTALL.md](INSTALL.md)

### 3. Install Dependencies

If not using the automated installer:
```bash
npm install
cd backend && npm install
cd ../frontend && npm install
```

## 🔧 Common Issues and Solutions

### "git: command not found"
- **Problem**: Git is not installed or not in your PATH
- **Solution**: Install Git from https://git-scm.com/ and restart your terminal

### "Permission denied (publickey)"
- **Problem**: SSH key not set up correctly
- **Solution**: Use HTTPS method instead: `git clone https://github.com/craigfelt/Alliance.git`
- Or follow the SSH setup steps above

### "fatal: destination path 'Alliance' already exists"
- **Problem**: Folder already exists in current directory
- **Solution**: 
  - Navigate to a different directory, or
  - Remove existing folder: `rm -rf Alliance` (be careful!)
  - Or clone with a different name: `git clone https://github.com/craigfelt/Alliance.git Alliance2`

### Clone is very slow
- **Problem**: Large repository or slow internet connection
- **Solution**: 
  - Use shallow clone: `git clone --depth 1 https://github.com/craigfelt/Alliance.git`
  - Or download ZIP instead (Method 3)

### "Repository not found" or 403 error
- **Problem**: URL is incorrect or repository is private
- **Solution**: 
  - Verify the URL: https://github.com/craigfelt/Alliance
  - Make sure you have access permissions
  - Try HTTPS instead of SSH or vice versa

## 🔄 Keeping Your Clone Updated

After cloning, you can get the latest changes:

```bash
cd Alliance
git pull origin main
```

This will download and merge any new changes from GitHub.

To see what changed:
```bash
git log --oneline -10    # View last 10 commits
git diff HEAD~1          # See changes from last commit
```

## 🌿 Working with Branches

To work on a different branch:

```bash
# List all branches
git branch -a

# Switch to a branch
git checkout branch-name

# Create and switch to a new branch
git checkout -b my-new-feature

# Pull latest changes for current branch
git pull origin $(git branch --show-current)
```

## 📚 Additional Resources

After successfully cloning:
- **Installation Guide**: [INSTALL.md](INSTALL.md)
- **Quick Start**: [QUICKSTART.md](QUICKSTART.md)
- **Main Documentation**: [README.md](README.md)
- **Development Guide**: [docs/DEVELOPMENT.md](docs/DEVELOPMENT.md)
- **Download Methods**: [DOWNLOAD.md](DOWNLOAD.md)

## 🎓 Git Basics Cheat Sheet

Essential Git commands for working with your clone:

```bash
git status              # Check current status
git log                 # View commit history
git pull                # Get latest changes
git add .               # Stage all changes
git commit -m "message" # Commit changes
git push                # Push to GitHub (if you have permissions)
```

## 🆘 Need Help?

If you encounter issues:

1. **Check this guide** for common solutions
2. **Review Git documentation**: https://git-scm.com/doc
3. **GitHub Help**: https://docs.github.com/
4. **Contact support**: support@alliance.co.za

## 🎉 Success!

Once you've successfully cloned the repository, you're ready to:
- Install and run the application
- Explore the codebase
- Start development
- Contribute to the project

**Next Steps:**
1. Run the installer: See [INSTALL.md](INSTALL.md)
2. Read the documentation: See [README.md](README.md)
3. Start developing: See [docs/DEVELOPMENT.md](docs/DEVELOPMENT.md)

---

**Thank you for cloning Alliance Property Management System!**

Built with ❤️ for Alliance Property Group, Durban, South Africa
