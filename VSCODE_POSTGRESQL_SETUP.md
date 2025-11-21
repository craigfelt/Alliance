# VS Code / Local Development PostgreSQL Connection Guide

This guide helps you troubleshoot PostgreSQL connection issues when working on the Alliance app locally in VS Code.

## Quick Checklist

Before diving into detailed troubleshooting, check these common issues:

- [ ] PostgreSQL service is running
- [ ] `backend/.env` file exists (not just `.env.example`)
- [ ] Password in `backend/.env` matches your actual PostgreSQL password
- [ ] Database `alliance_property` exists
- [ ] You can connect manually: `psql -U postgres -d alliance_property`

---

## Step 1: Verify PostgreSQL is Running

### Windows
```cmd
# Check if service is running
sc query postgresql-x64-14

# Or use services.msc
# Press Win+R, type services.msc, look for postgresql-x64-XX
```

### Linux
```bash
sudo systemctl status postgresql
# If not running:
sudo systemctl start postgresql
```

### Mac
```bash
brew services list | grep postgresql
# If not running:
brew services start postgresql@14
```

---

## Step 2: Create/Check backend/.env File

The backend needs a `.env` file with your PostgreSQL credentials.

### Check if it exists:
```bash
# From project root
ls -la backend/.env
```

### If it doesn't exist, create it:
```bash
# Copy the example file
cp backend/.env.example backend/.env
```

### Edit backend/.env with correct password:
```env
PORT=5000
NODE_ENV=development
JWT_SECRET=your-secret-key-change-in-production
JWT_EXPIRE=7d

# Database - UPDATE DB_PASSWORD with YOUR PostgreSQL password
DB_HOST=localhost
DB_PORT=5432
DB_NAME=alliance_property
DB_USER=postgres
DB_PASSWORD=YOUR_ACTUAL_PASSWORD_HERE

# CORS
CORS_ORIGIN=http://localhost:5173
```

**Important:** Replace `YOUR_ACTUAL_PASSWORD_HERE` with your actual PostgreSQL password!

---

## Step 3: Test PostgreSQL Connection

Before running the app, verify you can connect to PostgreSQL:

```bash
# Try to connect
psql -U postgres -d alliance_property

# If it asks for password, enter it
# If successful, you'll see: alliance_property=#

# Test query
alliance_property=# SELECT version();

# Exit
\q
```

### Common Issues:

**"psql: command not found"**
- PostgreSQL bin directory not in PATH
- **Windows:** Add `C:\Program Files\PostgreSQL\14\bin` to PATH
- **Linux:** Install postgresql-client: `sudo apt-get install postgresql-client`
- **Mac:** `brew install postgresql@14`

**"psql: FATAL: password authentication failed"**
- Your password is incorrect
- See [POSTGRESQL_PASSWORD_SETUP.md](POSTGRESQL_PASSWORD_SETUP.md) to reset it

**"psql: FATAL: database 'alliance_property' does not exist"**
- Database hasn't been created yet
- Run: `createdb -U postgres alliance_property`
- Then apply schema: `psql -U postgres -d alliance_property -f database/schema.sql`

---

## Step 4: Verify Database Schema

Make sure the database has tables:

```bash
# Connect to database
psql -U postgres -d alliance_property

# List tables
\dt

# You should see tables like: users, properties, tenants, leases, etc.
# If no tables, apply the schema:
\q

# Apply schema
psql -U postgres -d alliance_property -f database/schema.sql
```

---

## Step 5: Start Backend in VS Code

### Option A: Using VS Code Terminal

1. Open VS Code terminal (Ctrl+` or Cmd+`)
2. Navigate to backend:
   ```bash
   cd backend
   ```
3. Install dependencies (if not done):
   ```bash
   npm install
   ```
4. Start development server:
   ```bash
   npm run dev
   ```

### Option B: Using VS Code Debug

Create `.vscode/launch.json`:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "type": "node",
      "request": "launch",
      "name": "Backend Dev Server",
      "skipFiles": ["<node_internals>/**"],
      "program": "${workspaceFolder}/backend/src/server.js",
      "cwd": "${workspaceFolder}/backend",
      "envFile": "${workspaceFolder}/backend/.env",
      "runtimeExecutable": "npm",
      "runtimeArgs": ["run", "dev"],
      "console": "integratedTerminal"
    }
  ]
}
```

Then press F5 or use Run > Start Debugging.

---

## Step 6: Check Backend Logs

When you start the backend, you should see:

```
Server running on port 5000
Database connected successfully
```

### If you see errors:

**"Database connected successfully" is missing:**
- Connection issue - check steps 1-4 above

**"Error: connect ECONNREFUSED":**
- PostgreSQL not running
- Check Step 1

**"password authentication failed":**
- Wrong password in `backend/.env`
- Check Step 2

**"database 'alliance_property' does not exist":**
- Database not created
- See Step 3

**"relation 'users' does not exist":**
- Schema not applied
- See Step 4

---

## Step 7: Test Backend is Working

Once backend starts successfully:

```bash
# In a new terminal, test the API
curl http://localhost:5000/api/health

# Or open in browser:
# http://localhost:5000/api/health
```

You should get a response (may be JSON or "Cannot GET" for /api/health if that route doesn't exist, but it confirms server is running).

---

## Common VS Code Specific Issues

### Environment Variables Not Loading

VS Code terminal vs. integrated terminal can have different environments.

**Solution:**
1. Restart VS Code after modifying `backend/.env`
2. Or manually export in terminal:
   ```bash
   export $(cat backend/.env | xargs)  # Mac/Linux
   set -a; source backend/.env; set +a  # Alternative for Linux
   ```

### Node Version Issues

Make sure you're using Node.js 18+:

```bash
node --version
# Should show v18.x.x or higher
```

If not, install Node 18+ and restart VS Code.

### Port Already in Use

If port 5000 is already taken:

```bash
# Find what's using port 5000
# Windows
netstat -ano | findstr :5000

# Mac/Linux
lsof -i :5000

# Kill the process or change port in backend/.env
PORT=5001
```

---

## Full Local Development Workflow

Here's the complete process for running Alliance locally in VS Code:

### Terminal 1 - Backend:
```bash
cd backend
npm install          # First time only
npm run dev          # Starts on http://localhost:5000
```

### Terminal 2 - Frontend:
```bash
cd frontend
npm install          # First time only
npm run dev          # Starts on http://localhost:5173
```

### Access the app:
- Frontend: http://localhost:5173
- Backend API: http://localhost:5000
- Login: admin@alliance.co.za / admin123

---

## Still Having Issues?

### Check PostgreSQL Logs

**Windows:**
```
C:\Program Files\PostgreSQL\14\data\log\
```

**Linux:**
```
/var/log/postgresql/postgresql-14-main.log
```

**Mac:**
```
/usr/local/var/log/postgresql@14.log
```

### Use Password Reset Tool

If password is the issue:

**Windows:**
```cmd
# Run as Administrator
reset-postgres-password.bat
```

**Linux/Mac:**
```bash
./reset-postgres-password.sh
```

### Check Documentation

- [POSTGRESQL_PASSWORD_SETUP.md](POSTGRESQL_PASSWORD_SETUP.md) - Complete password guide
- [TROUBLESHOOTING.md](TROUBLESHOOTING.md) - General troubleshooting
- [INSTALL.md](INSTALL.md) - Full installation guide

### Get Help

1. Check error messages in terminal
2. Review PostgreSQL logs
3. Verify all steps above
4. Check GitHub Issues
5. Contact support: support@alliance.co.za

---

## Quick Reference: Common Commands

```bash
# Test PostgreSQL connection
psql -U postgres

# Create database
createdb -U postgres alliance_property

# Apply schema
psql -U postgres -d alliance_property -f database/schema.sql

# Check if database exists
psql -U postgres -l | grep alliance_property

# Start backend
cd backend && npm run dev

# Start frontend
cd frontend && npm run dev

# Check backend .env exists
cat backend/.env

# Test backend is running
curl http://localhost:5000
```

---

## Debugging Tips for VS Code

1. **Check Output Panel:** View > Output > Select "Node" or "Tasks"
2. **Check Terminal:** Any errors will show in the integrated terminal
3. **Use Debug Console:** When debugging, check Debug Console for logs
4. **Check Problems Panel:** Ctrl+Shift+M shows any linting/syntax issues
5. **Restart VS Code:** Sometimes needed after changing .env files

---

**Most Common Issue:** Missing or incorrect password in `backend/.env` file. Double-check this first!
