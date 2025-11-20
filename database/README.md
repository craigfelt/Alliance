# Database Setup Scripts

This directory contains SQL scripts for setting up the Alliance Property Management System database.

## Files

### `create_database.sql`
Creates the `alliance_property` database. This script should be run while connected to the `postgres` database.

**Usage:**
```bash
psql -U postgres -d postgres -f create_database.sql
```

This script will:
- Terminate any existing connections to the `alliance_property` database
- Drop the database if it already exists
- Create a new `alliance_property` database with UTF-8 encoding
- Grant all privileges to the `postgres` user

### `schema.sql`
Creates all tables, indexes, and sample data for the application. This script should be run while connected to the `alliance_property` database.

**Usage:**
```bash
psql -U postgres -d alliance_property -f schema.sql
```

This script will:
- Drop existing tables if they exist
- Create all required tables (users, properties, tenants, units, leases, etc.)
- Create indexes for performance
- Insert sample admin user and demo data

## Automated Installation

The installation scripts (`install.bat`, `install.sh`, `install.ps1`) automatically handle database creation and schema application. You only need to run these manual commands if:

1. The automated installation fails
2. You want to reset the database
3. You're setting up the database on a remote server

## Complete Setup (Manual)

To manually set up the database from scratch:

```bash
# 1. Create the database
psql -U postgres -d postgres -f create_database.sql

# 2. Apply the schema
psql -U postgres -d alliance_property -f schema.sql
```

## Reset Database

To completely reset the database:

```bash
# Option 1: Run create_database.sql (it will drop and recreate)
psql -U postgres -d postgres -f create_database.sql
psql -U postgres -d alliance_property -f schema.sql

# Option 2: Use PostgreSQL commands
dropdb -U postgres alliance_property
createdb -U postgres alliance_property
psql -U postgres -d alliance_property -f schema.sql
```

## Default Credentials

After running the schema, you can log in with:
- **Email:** admin@alliance.co.za
- **Password:** admin123

⚠️ **IMPORTANT:** Change these credentials immediately after first login!

## Troubleshooting

### PostgreSQL Password Issues

**"password authentication failed" or "FATAL: password authentication failed"**

This is the most common installation issue. Solutions:

1. **Find your password:**
   - Check password manager or installation notes
   - Try common defaults: `postgres`, or the password you set during installation
   - Look in `backend/.env` if you've installed before: `DB_PASSWORD=...`

2. **Test your password:**
   ```bash
   psql -U postgres
   # Enter password when prompted
   ```
   If this works, use the same password in the installer.

3. **Reset your password:**
   - **Windows:** Run `reset-postgres-password.bat` as Administrator
   - **Linux/Mac:** Run `./reset-postgres-password.sh`
   - **Manual:** See [POSTGRESQL_PASSWORD_SETUP.md](../POSTGRESQL_PASSWORD_SETUP.md) for detailed instructions

4. **After resetting, update Alliance:**
   ```bash
   # Edit backend/.env and update:
   DB_PASSWORD=your-new-password
   ```

### "database does not exist"
- Make sure you ran `create_database.sql` first
- Verify the database was created: `psql -U postgres -l | grep alliance_property`

### "permission denied"
- Make sure PostgreSQL is running
- Verify you're using the correct username and password
- Check that the postgres user has sufficient privileges

### "could not connect to server"
- Make sure PostgreSQL service is running
- On Windows: Check Services for "postgresql-x64-XX"
- On Mac: `brew services start postgresql@14`
- On Linux: `sudo systemctl start postgresql`

### Locale/Encoding Errors
If you get locale errors, modify the `create_database.sql` to use your system's locale:
```sql
CREATE DATABASE alliance_property
  WITH 
  ENCODING = 'UTF8'
  LC_COLLATE = 'C'
  LC_CTYPE = 'C'
  TEMPLATE = template0;
```
