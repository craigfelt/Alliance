# Visual Installation Guide

## 📸 What to Expect During Installation

This guide shows you what you'll see when running the installer.

## Step-by-Step Visual Flow

### Step 1: Prerequisites Check ✅
```
======================================================
  Alliance Property Management System - Installer
======================================================

Step 1: Checking Prerequisites...

  Checking Node.js... Found: v20.10.0 ✓
  Checking npm... Found: v10.2.3 ✓
  Checking PostgreSQL... Found: psql (PostgreSQL) 14.10 ✓
  Checking Git... Found: git version 2.42.0 ✓

All required prerequisites are installed! ✓
```

### Step 2: Installing Dependencies 📦
```
Step 2: Installing Dependencies...

  Installing root dependencies... ⏳
  [Progress bar or npm output]
  ✓ Done!

  Installing backend dependencies... ⏳
  [Progress bar or npm output]
  ✓ Done!

  Installing frontend dependencies... ⏳
  [Progress bar or npm output]
  ✓ Done!

Dependencies installed successfully! ✓
```

### Step 3: Environment Setup ⚙️
```
Step 3: Setting up Environment Files...

  Creating backend .env file...
  Please enter your PostgreSQL password for user 'postgres':
  Password: ********

  Backend .env created! ✓
  Frontend .env created! ✓
```

### Step 4: Database Setup 🗄️
```
Step 4: Setting up Database...

  Database Name: alliance_property
  Database User: postgres

  Checking if database exists...
  Creating database... ✓
  Database created successfully!

  Applying database schema... ✓
  Schema applied successfully!
```

### Step 5: Installation Complete 🎉
```
======================================================
  Installation Completed Successfully! ✓
======================================================

Next Steps:

1. Start the Backend Server:
   - Open a new terminal window
   - Navigate to: /path/to/Alliance/backend
   - Run: npm run dev
   - Backend will start at: http://localhost:5000

2. Start the Frontend Application:
   - Open another terminal window
   - Navigate to: /path/to/Alliance/frontend
   - Run: npm run dev
   - Frontend will start at: http://localhost:5173

3. Access the Application:
   - Open your browser to: http://localhost:5173
   - Login with:
     Email: admin@alliance.co.za
     Password: admin123

IMPORTANT: Change the default credentials after first login!

Would you like to start the application now? (y/N):
```

### If You Choose "Yes" to Auto-Start 🚀
```
Starting backend server in a new window... ✓
Starting frontend application in a new window... ✓

Servers starting in new windows...
The application will be available at http://localhost:5173 in a few seconds.

[Browser opens automatically to http://localhost:5173]
```

## What the Application Looks Like

### Login Screen
```
┌─────────────────────────────────────────┐
│                                         │
│    Alliance Property Management         │
│                                         │
│    Email:    [admin@alliance.co.za ]   │
│    Password: [●●●●●●●●●]               │
│                                         │
│           [  Login  ]                   │
│                                         │
└─────────────────────────────────────────┘
```

### Dashboard (After Login)
```
┌────────────────────────────────────────────────────────┐
│  Alliance Property Management    [Dashboard] [Logout]   │
├────────────────────────────────────────────────────────┤
│                                                         │
│  📊 Portfolio Overview                                  │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐ │
│  │Properties│ │ Tenants  │ │  Leases  │ │ Revenue  │ │
│  │    2     │ │    2     │ │    2     │ │ R45,000  │ │
│  └──────────┘ └──────────┘ └──────────┘ └──────────┘ │
│                                                         │
│  📈 Occupancy Rate: 66.67%                             │
│  [████████░░] 2 of 3 units occupied                    │
│                                                         │
│  Recent Activity:                                       │
│  • New lease created for ABC Corporation               │
│  • Payment received from XYZ Enterprises               │
│  • Maintenance request opened                          │
│                                                         │
└────────────────────────────────────────────────────────┘
```

## Terminal Windows After Auto-Start

### Backend Terminal
```
> alliance-property-backend@1.0.0 dev
> nodemon src/server.js

[nodemon] 3.1.11
[nodemon] to restart at any time, enter `rs`
[nodemon] watching path(s): *.*
[nodemon] watching extensions: js,mjs,json
[nodemon] starting `node src/server.js`

🏢 Alliance Property Management System - Backend
================================================
✓ Database connected successfully
✓ Server running on port 5000
✓ API available at http://localhost:5000/api
```

### Frontend Terminal
```
> frontend@0.0.0 dev
> vite

  VITE v7.2.2  ready in 423 ms

  ➜  Local:   http://localhost:5173/
  ➜  Network: use --host to expose
  ➜  press h to show help
```

## Common Error Messages and Solutions

### Error: "Node.js NOT FOUND"
```
  Checking Node.js... ✗ NOT FOUND

  Please install Node.js 18+ from https://nodejs.org/
  After installation, run this script again.
```
**Solution**: Install Node.js from https://nodejs.org/

### Error: "Failed to create database"
```
  Creating database... ✗ FAILED

  Make sure PostgreSQL is running and credentials are correct.
```
**Solution**: 
- Check PostgreSQL is running
- Verify password is correct
- Try running: `sudo service postgresql start` (Linux) or check Windows Services

### Error: "Port already in use"
```
Error: listen EADDRINUSE: address already in use :::5000
```
**Solution**: Another application is using port 5000. Close it or change the port in `backend/.env`

## Timeline Estimate

```
Total Installation Time: ~10-15 minutes

[▓▓░░░░░░░░] Downloading installer        (1 min)
[▓▓▓▓░░░░░░] Prerequisites check          (1 min)
[▓▓▓▓▓▓▓░░░] Installing dependencies      (5-7 min)
[▓▓▓▓▓▓▓▓░░] Setting up environment       (1 min)
[▓▓▓▓▓▓▓▓▓░] Creating database            (1-2 min)
[▓▓▓▓▓▓▓▓▓▓] Starting application         (1 min)
```

## Success Indicators

You'll know installation was successful when you see:

1. ✅ All prerequisites checks pass
2. ✅ "Dependencies installed successfully!"
3. ✅ "Database created successfully!"
4. ✅ "Schema applied successfully!"
5. ✅ "Installation Completed Successfully!"
6. ✅ Backend server shows "Server running on port 5000"
7. ✅ Frontend shows Vite dev server ready
8. ✅ Browser opens to login page
9. ✅ You can login with admin credentials

## Need Help?

If something doesn't look right:
- Check [INSTALL.md](INSTALL.md) for troubleshooting
- Verify all prerequisites are installed
- Make sure no other services are using ports 5000 or 5173
- Check PostgreSQL is running
- Review error messages carefully

---

This visual guide should help you understand what to expect during the installation process!
