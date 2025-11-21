# Quick Start Guide - SQLite Setup

Your Alliance app has been configured to use SQLite instead of PostgreSQL. This means **no database installation is required** - everything works out of the box!

## ✅ What's Been Done

1. ✅ SQLite database package installed (`better-sqlite3`)
2. ✅ Database configuration updated to use SQLite by default
3. ✅ Database schema converted to SQLite format
4. ✅ Database created with all tables
5. ✅ Admin user created with hashed password

## 🚀 Starting the App

### 1. Start the Backend Server

```bash
cd backend
npm run dev
```

The backend will start on `http://localhost:5000`

### 2. Start the Frontend (in a new terminal)

```bash
cd frontend
npm run dev
```

The frontend will start on `http://localhost:5173`

## 🔐 Login Credentials

- **Email:** `admin@alliance.co.za`
- **Password:** `admin123`

## 📁 Database Location

The SQLite database file is located at:
```
alliance_property.db
```

This file contains all your data. You can:
- **Backup:** Simply copy this file
- **Reset:** Delete this file and run `node db-setup-sqlite.js` again
- **View:** Use any SQLite browser tool (like DB Browser for SQLite)

## 🔄 Switching Back to PostgreSQL (Optional)

If you want to use PostgreSQL in the future:

1. Install PostgreSQL on your system
2. Set environment variable: `DB_TYPE=postgresql`
3. Configure PostgreSQL connection in `.env` file

The app will automatically detect and use PostgreSQL when `DB_TYPE=postgresql` is set.

## 🛠️ Troubleshooting

### Database not found?
Run the setup script again:
```bash
node db-setup-sqlite.js
```

### Need to reset the database?
Delete `alliance_property.db` and run:
```bash
node db-setup-sqlite.js
```

### Admin password not working?
The password is hashed. If you need to reset it, run:
```bash
node setup-admin-password.js
```

## 📝 Notes

- SQLite is perfect for development and small to medium deployments
- All your data is stored in a single file (`alliance_property.db`)
- No database server needed - everything runs locally
- The app automatically converts PostgreSQL queries to SQLite-compatible syntax

Enjoy your app! 🎉

