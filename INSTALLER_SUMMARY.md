# Alliance Property Management System - Installer Package Summary

## 📦 What You've Received

This package includes automated installer scripts that make it easy to install and set up the Alliance Property Management System on your PC with just a few clicks.

## 🎯 Quick Start

### For Windows Users (Most Common)

**Option 1 - PowerShell (Recommended):**
1. Download: `install.ps1`
2. Right-click → "Run with PowerShell"
3. Follow the prompts
4. Done! 🎉

**Option 2 - Batch File:**
1. Download: `install.bat`
2. Double-click to run
3. Follow the prompts
4. Done! 🎉

**Option 3 - One Command (PowerShell):**
```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/craigfelt/Alliance/main/install.ps1" -OutFile "install.ps1"; .\install.ps1
```

### For Mac/Linux Users

**Download and run:**
```bash
curl -o install.sh https://raw.githubusercontent.com/craigfelt/Alliance/main/install.sh && chmod +x install.sh && ./install.sh
```

## 📁 Included Files

### Installer Scripts
- **install.ps1** - PowerShell installer for Windows (advanced features)
- **install.bat** - Batch file installer for Windows (simple, compatible)
- **install.sh** - Shell script installer for Linux/Mac (full-featured)

### Documentation
- **INSTALL.md** - Complete installation guide with troubleshooting
- **DOWNLOAD.md** - How to download installer files
- **QUICK_DOWNLOAD.md** - One-line download commands
- **README.md** - Updated with installer information

## ✨ What the Installer Does

The installer automates everything:

1. ✅ **Checks Prerequisites** - Verifies Node.js, PostgreSQL, npm are installed
2. ✅ **Installs Dependencies** - Downloads and installs all required packages
3. ✅ **Configures Environment** - Sets up configuration files
4. ✅ **Creates Database** - Sets up PostgreSQL database with schema
5. ✅ **Provides Instructions** - Shows you how to start the application
6. ✅ **Auto-Start Option** - Can optionally start servers for you
7. ✅ **Opens Browser** - Can automatically open the application

**Total Time: About 10-15 minutes** (mostly automated)

## 📋 Before You Start

Make sure you have:

1. **Node.js 18+** - Download from https://nodejs.org/
2. **PostgreSQL 14+** - Download from https://www.postgresql.org/download/
3. **Your PostgreSQL password** - You'll need this during setup

## 🎬 What Happens After Installation

After the installer completes:

1. **Backend Server** starts on: http://localhost:5000
2. **Frontend Application** opens at: http://localhost:5173
3. **Login** with:
   - Email: `admin@alliance.co.za`
   - Password: `admin123`

⚠️ **Remember to change the password after first login!**

## 📊 System Features

Your installed system includes:

### Core Features
- 📊 **Dashboard** - Real-time overview of properties and financials
- 🏢 **Property Management** - Manage commercial properties
- 👥 **Tenant Management** - Complete tenant profiles
- 📝 **Lease Management** - Automated lease tracking
- 💰 **Financial Management** - Invoicing and payments
- 🔧 **Maintenance Management** - Work order tracking
- 📈 **Reports & Analytics** - Comprehensive reporting

### South African Compliance
- Trust account management (SA compliance)
- VAT handling
- ZAR currency formatting
- Lease escalation calculations

## 🛠️ Technical Details

### Technology Stack
- **Frontend**: React + Vite + TailwindCSS
- **Backend**: Node.js + Express
- **Database**: PostgreSQL
- **Authentication**: JWT + bcrypt

### Ports Used
- Backend API: `5000`
- Frontend App: `5173`
- PostgreSQL: `5432`

## 📚 Need Help?

### Documentation
1. **INSTALL.md** - Detailed installation guide
2. **DOWNLOAD.md** - Download instructions
3. **README.md** - Complete system documentation
4. **QUICKSTART.md** - Quick start guide

### Common Issues

**"Can't find Node.js"**
→ Install from https://nodejs.org/ and restart terminal

**"Can't connect to database"**
→ Make sure PostgreSQL is running and password is correct

**"Port already in use"**
→ Another application is using port 5000 or 5173

**"Script won't run on Windows"**
→ Use PowerShell as Administrator and run:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

See **INSTALL.md** for complete troubleshooting guide.

## 🎯 Next Steps

1. **Install Prerequisites** - Node.js and PostgreSQL
2. **Download Installer** - Choose your platform
3. **Run Installer** - Follow the prompts
4. **Start Using** - Login and explore the system
5. **Customize** - Add your properties, tenants, and leases

## 🌟 Support

- **Email**: support@alliance.co.za
- **Documentation**: See `/docs` folder after installation
- **GitHub**: https://github.com/craigfelt/Alliance

## 🔒 Security

The installer:
- ✅ Downloads only from official npm registry
- ✅ Uses secure PostgreSQL connections
- ✅ Implements password hashing (bcrypt)
- ✅ JWT authentication
- ✅ No hardcoded secrets in installers

## 💡 Pro Tips

1. **Run as Administrator** - On Windows, for best results
2. **Stable Internet** - Required for downloading dependencies
3. **Close Other Apps** - Free up system resources during install
4. **Read INSTALL.md** - Has detailed troubleshooting
5. **Use PowerShell on Windows** - Better features than batch file

## 🎉 Welcome to Alliance!

You now have everything you need to install and run a professional property management system designed specifically for South African commercial property leasing.

The installer takes care of all the technical setup so you can focus on managing your properties!

---

**Installation Time**: ~10-15 minutes
**Difficulty**: Easy (fully automated)
**Platforms**: Windows, Mac, Linux
**Cost**: Free and open source

Built with ❤️ for Alliance Property Group, Durban, South Africa
