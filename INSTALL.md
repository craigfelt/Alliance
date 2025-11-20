# Alliance Property Management System - Installation Guide

## 📦 Quick Install

We provide easy-to-use installer scripts that automatically download and set up everything for you. Just download and run the installer - **no need to manually clone the repository**!

### Windows Users

**Quick Install (One Command):**
```powershell
# In PowerShell, run:
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/craigfelt/Alliance/main/install.ps1" -OutFile "install.ps1"; .\install.ps1
```

**Option 1: PowerShell (Recommended)**
1. Download `install.ps1` from [here](https://raw.githubusercontent.com/craigfelt/Alliance/main/install.ps1)
2. Right-click the file and select "Run with PowerShell"
   - If you see a security warning, you may need to run: `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`
3. Follow the on-screen prompts

**Option 2: Command Prompt/Batch**
1. Download `install.bat` from [here](https://raw.githubusercontent.com/craigfelt/Alliance/main/install.bat)
2. Double-click the file to run
3. Follow the on-screen prompts

### Linux/Mac Users

**Quick Install (One Command):**
```bash
# In Terminal, run:
curl -o install.sh https://raw.githubusercontent.com/craigfelt/Alliance/main/install.sh && chmod +x install.sh && ./install.sh
```

**Step-by-Step:**
1. Download `install.sh` from [here](https://raw.githubusercontent.com/craigfelt/Alliance/main/install.sh)
2. Open Terminal in the download location
3. Make the script executable:
   ```bash
   chmod +x install.sh
   ```
4. Run the installer:
   ```bash
   ./install.sh
   ```
5. Follow the on-screen prompts

## 🎯 What the Installer Does

The installer automates the entire setup process:

1. **Checks Prerequisites**
   - Verifies Node.js 18+ is installed
   - Verifies npm is available
   - Verifies PostgreSQL 14+ is installed
   - Checks for Git (required for cloning, if repository not already present)

2. **Clones Repository (if needed)**
   - Automatically detects if running from a cloned repository
   - If not, clones the full repository from GitHub
   - Creates a new directory (Alliance, or Alliance_1 if exists)

3. **Installs Dependencies**
   - Installs root project dependencies
   - Installs backend (Node.js/Express) dependencies
   - Installs frontend (React/Vite) dependencies

4. **Configures Environment**
   - Creates `.env` files from templates
   - Prompts for PostgreSQL password
   - Configures database connection settings

5. **Sets Up Database**
   - Creates `alliance_property` PostgreSQL database
   - Applies database schema
   - Sets up initial data and admin user

6. **Provides Next Steps**
   - Shows how to start the backend server
   - Shows how to start the frontend application
   - Displays default login credentials

## 📋 Prerequisites

Before running the installer, make sure you have:

### Required Software

1. **Node.js 18 or higher**
   - Download: https://nodejs.org/
   - Verify installation: `node --version`

2. **PostgreSQL 14 or higher**
   - Windows: https://www.postgresql.org/download/windows/
   - Mac: `brew install postgresql@14` or https://postgresapp.com/
   - Linux: `sudo apt-get install postgresql` (Ubuntu/Debian)
   - Verify installation: `psql --version`

3. **Git** (Required for automatic installation)
   - Download: https://git-scm.com/
   - Verify installation: `git --version`
   - Note: Git is required for the installer to clone the repository

### System Requirements

- **Operating System**: Windows 10/11, macOS 10.15+, or Linux
- **RAM**: 4GB minimum, 8GB recommended
- **Disk Space**: 500MB for application + space for database
- **Internet**: Required for cloning repository and downloading dependencies

## 🚀 After Installation

Once the installer completes successfully:

### Starting the Application

**Backend Server (Terminal 1):**
```bash
cd backend
npm run dev
```
The backend API will start at: http://localhost:5000

**Frontend Application (Terminal 2):**
```bash
cd frontend
npm run dev
```
The frontend will start at: http://localhost:5173

### Accessing the Application

1. Open your web browser
2. Navigate to: http://localhost:5173
3. Login with default credentials:
   - **Email:** admin@alliance.co.za
   - **Password:** admin123

⚠️ **IMPORTANT:** Change these credentials immediately after first login!

## 🔧 Troubleshooting

### Installation Issues

**"Node.js not found"**
- Install Node.js from https://nodejs.org/
- Make sure to restart your terminal/command prompt after installation
- Verify with: `node --version`

**"PostgreSQL not found"**
- Install PostgreSQL for your platform (see Prerequisites above)
- On Windows, ensure PostgreSQL bin directory is added to PATH
  - Usually: `C:\Program Files\PostgreSQL\14\bin`
- Restart terminal/command prompt after installation
- Verify with: `psql --version`

**"Failed to create database"**
- Make sure PostgreSQL service is running
  - Windows: Check Services (services.msc), look for "postgresql-x64-14"
  - Mac: `brew services start postgresql@14`
  - Linux: `sudo systemctl start postgresql`
- Verify you entered the correct PostgreSQL password
- Try connecting manually: `psql -U postgres`

**"Permission denied" (Linux/Mac)**
- Make sure the install script is executable: `chmod +x install.sh`
- You may need sudo for PostgreSQL commands: `sudo ./install.sh`

**"Dependencies failed to install"**
- Check your internet connection
- Try deleting `node_modules` folders and running installer again
- Clear npm cache: `npm cache clean --force`

### Runtime Issues

**Backend won't start**
- Check if PostgreSQL is running
- Verify database was created: `psql -U postgres -l | grep alliance_property`
- Check backend/.env file has correct database credentials
- Check if port 5000 is already in use

**Frontend won't start**
- Check if port 5173 is already in use
- Try deleting `node_modules` and `package-lock.json` in frontend folder
- Run `npm install` again in frontend folder

**Can't login**
- Make sure backend server is running (http://localhost:5000)
- Check browser console for errors (F12)
- Verify database has the admin user:
  ```sql
  psql -U postgres -d alliance_property -c "SELECT email FROM users;"
  ```

**Reset admin password**
```sql
psql -U postgres alliance_property -c "UPDATE users SET password = '\$2b\$10\$VzkbDjEDrKw4VNJjDbWxdOvaHapEomMgGVZsrc2kmLFbMouSihxBa' WHERE email = 'admin@alliance.co.za';"
```
This resets the password to: `admin123`

## 📝 Manual Installation

If you prefer to install manually or the installer doesn't work, follow the steps in [QUICKSTART.md](QUICKSTART.md).

## 🔄 Updating

To update the application:

1. Pull latest changes (if using Git):
   ```bash
   git pull origin main
   ```

2. Update dependencies:
   ```bash
   npm install
   cd backend && npm install
   cd ../frontend && npm install
   ```

3. Apply any new database migrations (check release notes)

4. Restart backend and frontend servers

## 📚 Additional Resources

- **Main Documentation**: [README.md](README.md)
- **Quick Start Guide**: [QUICKSTART.md](QUICKSTART.md)
- **Project Summary**: [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md)
- **Security Information**: [SECURITY.md](SECURITY.md)

## 🆘 Getting Help

If you encounter issues:

1. Check the troubleshooting section above
2. Review the documentation files
3. Check the GitHub repository issues
4. Contact support: support@alliance.co.za

## 🎉 Welcome!

Thank you for installing Alliance Property Management System. We hope this installer made the setup process smooth and easy.

For commercial property management in Durban, South Africa, you now have a powerful, modern system ready to use!

---

Built with ❤️ for Alliance Property Group
