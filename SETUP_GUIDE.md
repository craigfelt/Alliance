# Quick Setup Guide - Alliance Property Management

## Step 1: Start PostgreSQL

You need to start the PostgreSQL service with administrator privileges.

**Option A - Using the batch file:**
1. Right-click on `start-postgres.bat` in this folder
2. Select "Run as administrator"
3. The service should start successfully

**Option B - Manual start:**
1. Press Windows key
2. Type "Services"
3. Right-click "Services" and select "Run as administrator"
4. Find "postgresql-x64-17" in the list
5. Right-click and select "Start"

## Step 2: Set PostgreSQL Password

Open a NEW terminal as administrator and run:

```powershell
# Connect to PostgreSQL (will prompt for password - press Enter if no password set)
psql -U postgres

# Once connected, set a password for postgres user
ALTER USER postgres WITH PASSWORD 'admin123';

# Exit psql
\q
```

## Step 3: Update Backend .env File

Edit `backend\.env` and update the database password:

```
DB_PASSWORD=admin123
```

(Or use whatever password you set in Step 2)

## Step 4: Create and Setup Database

In a regular terminal (not as admin), run:

```powershell
# Create the database
createdb -U postgres alliance_property

# Load the schema (will prompt for password)
psql -U postgres -d alliance_property -f database\schema.sql
```

## Step 5: Start the Application

Open TWO terminal windows:

**Terminal 1 - Backend:**
```powershell
cd backend
npm run dev
```

You should see:
```
🚀 Alliance Property Management Server running on port 5000
Database connected successfully
```

**Terminal 2 - Frontend:**
```powershell
cd frontend
npm run dev
```

You should see:
```
VITE v7.x.x  ready in xxx ms
➜  Local:   http://localhost:5173/
```

## Step 6: Access the Application

1. Open your browser
2. Go to: http://localhost:5173
3. Login with:
   - **Email:** admin@alliance.co.za
   - **Password:** admin123

## Troubleshooting

### PostgreSQL won't start
- Make sure you're running as administrator
- Check if port 5432 is already in use
- Check PostgreSQL logs in `C:\Program Files\PostgreSQL\17\data\log`

### Database connection failed
- Verify PostgreSQL is running: `psql -U postgres -c "SELECT version();"`
- Check the password in `backend\.env` matches your PostgreSQL password
- Verify database exists: `psql -U postgres -l`

### Frontend can't connect to backend
- Make sure backend is running on port 5000
- Check `frontend\.env` has `VITE_API_URL=http://localhost:5000/api`
- Clear browser cache and reload

### Port already in use
- Backend (5000): Check if another app is using port 5000
- Frontend (5173): Vite will automatically use next available port

## Quick Commands Reference

```powershell
# Check if PostgreSQL is running
Get-Service postgresql-x64-17

# Start PostgreSQL (as admin)
Start-Service postgresql-x64-17

# Create database
createdb -U postgres alliance_property

# Connect to database
psql -U postgres -d alliance_property

# Check database tables
psql -U postgres -d alliance_property -c "\dt"

# Reset database (drops all data!)
psql -U postgres -d alliance_property -f database\schema.sql
```

## Next Steps After Setup

1. Change default admin password in the app
2. Update `JWT_SECRET` in `backend\.env` to a secure random string
3. Explore the dashboard and features
4. Read `docs/DEVELOPMENT.md` for API details
5. See `README.md` for full feature list
