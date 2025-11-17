# Quick Start Guide - Alliance Property Management System

## 🚀 5-Minute Setup

### Prerequisites
- Node.js 18+ installed
- PostgreSQL 14+ installed and running
- Git

### Step 1: Clone the Repository
```bash
git clone https://github.com/craigfelt/Alliance.git
cd Alliance
```

### Step 2: Install Dependencies
```bash
# Install all dependencies (frontend and backend)
npm run install:all
```

### Step 3: Setup Database
```bash
# Option A: Using the setup script (recommended)
npm run setup

# Option B: Manual setup
createdb alliance_property
psql alliance_property < database/schema.sql
```

### Step 4: Configure Environment

**Backend** (already configured):
```bash
cd backend
# .env file is already set up with default values
```

**Frontend** (already configured):
```bash
cd frontend
# .env file is already set up
```

### Step 5: Start the Application

**Terminal 1 - Backend:**
```bash
cd backend
npm run dev
# Server will start on http://localhost:5000
```

**Terminal 2 - Frontend:**
```bash
cd frontend
npm run dev
# App will start on http://localhost:5173
```

### Step 6: Login

1. Open browser to http://localhost:5173
2. Login with:
   - **Email:** admin@alliance.co.za
   - **Password:** admin123

## ✅ That's it! You're ready to use Alliance Property Management System

## 🎯 What You Can Do Now

### Dashboard
- View portfolio overview
- Check occupancy rates (66.67% with sample data)
- Monitor financial metrics
- Track maintenance requests

### Sample Data Included
- 2 Properties (Alliance Office Park, Durban Retail Centre)
- 2 Tenants (ABC Corporation, XYZ Enterprises)
- 3 Units (2 occupied, 1 vacant)
- 2 Active Leases

### API Endpoints Available
All endpoints are documented in the main README.md

Test the API:
```bash
# Health check
curl http://localhost:5000/api/health

# Login
curl -X POST http://localhost:5000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email": "admin@alliance.co.za", "password": "admin123"}'

# Get dashboard stats (requires token)
curl -H "Authorization: Bearer YOUR_TOKEN" \
  http://localhost:5000/api/dashboard/stats
```

## 📱 Available Modules

Currently accessible via navigation:
- ✅ Dashboard (fully functional)
- 🔨 Properties (coming soon)
- 🔨 Tenants (coming soon)
- 🔨 Leases (coming soon)
- 🔨 Financial (coming soon)
- 🔨 Maintenance (coming soon)
- 🔨 Reports (coming soon)

## 🔧 Troubleshooting

### Backend won't start
```bash
# Check PostgreSQL is running
sudo service postgresql start

# Verify database exists
psql -l | grep alliance_property
```

### Frontend won't start
```bash
# Clear node_modules and reinstall
cd frontend
rm -rf node_modules package-lock.json
npm install
```

### Can't login
```bash
# Reset admin password in database
sudo -u postgres psql alliance_property -c "UPDATE users SET password = '\$2b\$10\$VzkbDjEDrKw4VNJjDbWxdOvaHapEomMgGVZsrc2kmLFbMouSihxBa' WHERE email = 'admin@alliance.co.za';"
```

## 📚 Next Steps

1. **Read the Documentation**
   - `/README.md` - Main documentation
   - `/docs/DEVELOPMENT.md` - Developer guide
   - `/docs/MDA_MIGRATION.md` - Migration guide

2. **Explore the Code**
   - Backend: `/backend/src/`
   - Frontend: `/frontend/src/`
   - Database: `/database/schema.sql`

3. **Start Development**
   - Add property management forms
   - Build tenant management UI
   - Create lease management interface
   - Implement financial tracking

## 🆘 Get Help

- Check documentation in `/docs`
- Review code examples
- Contact: support@alliance.co.za

## 🎉 Welcome to Alliance Property Management!

You now have a modern, professional property management system ready for development and customization.
