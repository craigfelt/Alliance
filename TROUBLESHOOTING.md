# Installation Troubleshooting - Quick Reference

## Common Installation Issues & Solutions

### 🔴 Issue 1: PowerShell Execution Policy Error

**Error Message:**
```
File ... cannot be loaded. The file ... is not digitally signed.
```

**✅ Solution (EASIEST):**
1. Use `install-powershell.bat` instead
2. Double-click the file
3. Done! No configuration needed

**📖 Full Guide:** [POWERSHELL_EXECUTION_POLICY.md](POWERSHELL_EXECUTION_POLICY.md)

---

### 🔴 Issue 2: PostgreSQL Password Authentication Failed

**Error Message:**
```
Failed to connect to PostgreSQL
password authentication failed for user "postgres"
```

**✅ Solution (QUICK):**

**If you know your password but typed it wrong:**
- The installer now lets you retry
- Just type it again when prompted

**If you forgot your password:**
1. Cancel the installer (press `n` when asked to retry)
2. Reset your password:
   - **Windows:** Run `reset-postgres-password.bat` as Administrator
   - **Linux/Mac:** Run `./reset-postgres-password.sh`
3. Re-run the installer with your new password

**📖 Full Guide:** [POSTGRESQL_PASSWORD_SETUP.md](POSTGRESQL_PASSWORD_SETUP.md)

---

### 🔴 Issue 3: PostgreSQL Service Not Running

**Error Message:**
```
could not connect to server
```

**✅ Solution:**

**Windows:**
1. Press `Win + R`
2. Type `services.msc` and press Enter
3. Find "postgresql-x64-XX" (where XX is version number)
4. Right-click → Start
5. Re-run installer

**Linux:**
```bash
sudo systemctl start postgresql
sudo systemctl status postgresql
```

**Mac:**
```bash
brew services start postgresql@14
brew services list | grep postgresql
```

---

### 🔴 Issue 4: Node.js or npm Not Found

**Error Message:**
```
Node.js NOT FOUND
```

**✅ Solution:**
1. Install Node.js 18+ from https://nodejs.org/
2. **Important:** Restart your terminal/command prompt
3. Verify: `node --version`
4. Re-run installer

---

### 🔴 Issue 5: Database Already Exists

**Installer Prompt:**
```
Database 'alliance_property' already exists.
Do you want to drop and recreate it? (y/N):
```

**✅ Options:**

**Keep existing (press `N` or just Enter):**
- Your data is safe
- Installer skips database setup
- Use this if you're reinstalling or updating

**Recreate (press `y`):**
- ⚠️ **WARNING:** All data will be lost!
- Database will be dropped and recreated
- Fresh installation with default admin user
- Use this if you want a clean slate

---

## Installation Flow Diagram

```
Start Install
     ↓
Prerequisites Check
     ↓
   ✓ Pass → Continue
   ✗ Fail → Show missing requirement → Exit
     ↓
Clone Repository (if needed)
     ↓
Install Dependencies
     ↓
Setup Environment Files
     ↓
PostgreSQL Password Prompt ←──────┐
     ↓                             │
Test Connection                    │
     ↓                             │
   ✓ Success → Continue             │
   ✗ Fail → Show Error              │
            → Retry? (Y/n) ─ Yes ──┘
                      │
                      No
                      ↓
                    Exit
     ↓
Database Setup
     ↓
✅ Installation Complete!
```

---

## Quick Command Reference

### Test PostgreSQL Connection
```bash
# Test if PostgreSQL is accessible
psql -U postgres -c "SELECT version();"
```

### Reset PostgreSQL Password
```bash
# Windows (Command Prompt as Administrator)
reset-postgres-password.bat

# Linux/Mac (Terminal)
./reset-postgres-password.sh
```

### Run Installer with Bypass (if execution policy issue)
```powershell
# Windows PowerShell
powershell.exe -ExecutionPolicy Bypass -File .\install.ps1

# Or just use the launcher:
.\install-powershell.bat
```

### Check PostgreSQL Service Status
```bash
# Windows (PowerShell)
Get-Service *postgresql*

# Linux
sudo systemctl status postgresql

# Mac
brew services list | grep postgresql
```

### Manual Database Reset
```bash
# Drop and recreate database
dropdb -U postgres alliance_property
createdb -U postgres alliance_property
psql -U postgres -d alliance_property -f database/schema.sql
```

---

## Decision Tree: Which Installer Should I Use?

```
Are you on Windows?
├─ Yes
│  └─ Do you want to use PowerShell?
│     ├─ Yes → Use install-powershell.bat ⭐ RECOMMENDED
│     └─ No  → Use install.bat
│
└─ No
   └─ Are you on Linux or Mac?
      └─ Yes → Use install.sh
```

---

## After Installation

### Start the Application

**Terminal/Command Prompt 1 - Backend:**
```bash
cd backend
npm run dev
# Backend runs at http://localhost:5000
```

**Terminal/Command Prompt 2 - Frontend:**
```bash
cd frontend
npm run dev
# Frontend runs at http://localhost:5173
```

### Default Login
- **URL:** http://localhost:5173
- **Email:** admin@alliance.co.za
- **Password:** admin123

⚠️ **Change these credentials after first login!**

---

## Still Having Issues?

### 📚 Documentation
- [INSTALL.md](INSTALL.md) - Complete installation guide
- [POSTGRESQL_PASSWORD_SETUP.md](POSTGRESQL_PASSWORD_SETUP.md) - PostgreSQL password help
- [POWERSHELL_EXECUTION_POLICY.md](POWERSHELL_EXECUTION_POLICY.md) - PowerShell issues
- [QUICKSTART.md](QUICKSTART.md) - Manual installation
- [README.md](README.md) - Project overview

### 💬 Get Help
1. Review the documentation above
2. Check GitHub Issues for similar problems
3. Contact support: support@alliance.co.za

---

**Pro Tip:** Before seeking help, try:
1. Verifying all prerequisites are installed
2. Restarting your computer (seriously, this fixes many issues)
3. Running the installer as Administrator (Windows)
4. Checking if antivirus/firewall is blocking the installer
