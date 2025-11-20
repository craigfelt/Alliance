# PostgreSQL Password Setup and Reset Guide

This guide helps you create, reset, or recover your PostgreSQL password for the Alliance Property Management System.

## Table of Contents
- [Initial Setup](#initial-setup)
- [Reset Password (Windows)](#reset-password-windows)
- [Reset Password (Linux/Mac)](#reset-password-linuxmac)
- [Change Password from Command Line](#change-password-from-command-line)
- [Troubleshooting](#troubleshooting)

---

## Initial Setup

When you first install PostgreSQL, you set a password for the `postgres` superuser. This password is needed to:
- Create databases
- Run the Alliance installer
- Manage the Alliance database

**Remember this password!** Write it down in a secure location.

### Setting Password During PostgreSQL Installation

**Windows:**
- During PostgreSQL installation, you'll be prompted to set a password for `postgres`
- The installer requires this password and will ask you to confirm it
- Common default: `postgres` (but you should choose something more secure)

**Linux:**
- After installation, set the password with:
  ```bash
  sudo -u postgres psql -c "ALTER USER postgres PASSWORD 'your-password-here';"
  ```

**Mac (Homebrew):**
- PostgreSQL installed via Homebrew may not have a password set initially
- The `postgres` user typically uses peer authentication (no password needed locally)

---

## Reset Password (Windows)

If you forgot your PostgreSQL password on Windows, follow these steps:

### Method 1: Using pg_hba.conf (Recommended)

1. **Stop PostgreSQL Service**
   - Press `Win + R`, type `services.msc`, press Enter
   - Find "postgresql-x64-XX" (where XX is version number, like 14, 15, 16)
   - Right-click → Stop

2. **Edit pg_hba.conf**
   - Navigate to PostgreSQL data directory (typically):
     ```
     C:\Program Files\PostgreSQL\14\data\
     ```
   - Open `pg_hba.conf` in a text editor (as Administrator)
   - Find this line:
     ```
     host    all             all             127.0.0.1/32            scram-sha-256
     ```
   - Change it to:
     ```
     host    all             all             127.0.0.1/32            trust
     ```
   - Save the file

3. **Start PostgreSQL Service**
   - Go back to services.msc
   - Right-click "postgresql-x64-XX" → Start

4. **Reset the Password**
   - Open Command Prompt
   - Run:
     ```cmd
     psql -U postgres
     ```
   - At the `postgres=#` prompt, enter:
     ```sql
     ALTER USER postgres PASSWORD 'your-new-password';
     \q
     ```

5. **Restore Security**
   - Edit `pg_hba.conf` again
   - Change `trust` back to `scram-sha-256`
   - Restart PostgreSQL service

### Method 2: Using pgAdmin (If Installed)

1. Open pgAdmin
2. If it asks for password, try common defaults: `postgres`, `admin`, or leave blank
3. Right-click on "PostgreSQL XX" → Properties
4. Go to "Definition" tab
5. Enter new password
6. Click "Save"

### Method 3: Reinstall PostgreSQL (Last Resort)

If all else fails:
1. Backup your Alliance database (if it exists):
   ```cmd
   pg_dump -U postgres alliance_property > backup.sql
   ```
2. Uninstall PostgreSQL completely
3. Delete data directory: `C:\Program Files\PostgreSQL\`
4. Reinstall PostgreSQL and set a new password
5. Restore your database:
   ```cmd
   createdb -U postgres alliance_property
   psql -U postgres -d alliance_property -f backup.sql
   ```

---

## Reset Password (Linux/Mac)

### Linux (Ubuntu/Debian)

1. **Edit pg_hba.conf**
   ```bash
   sudo nano /etc/postgresql/14/main/pg_hba.conf
   ```

2. **Change authentication method**
   Find line like:
   ```
   local   all             postgres                                peer
   ```
   Change to:
   ```
   local   all             postgres                                trust
   ```

3. **Restart PostgreSQL**
   ```bash
   sudo systemctl restart postgresql
   ```

4. **Reset password**
   ```bash
   psql -U postgres -c "ALTER USER postgres PASSWORD 'your-new-password';"
   ```

5. **Restore security**
   ```bash
   sudo nano /etc/postgresql/14/main/pg_hba.conf
   ```
   Change `trust` back to `peer` or `scram-sha-256`
   ```bash
   sudo systemctl restart postgresql
   ```

### Mac (Homebrew)

Mac installations typically use peer authentication, so password may not be required:

1. **Check current setup**
   ```bash
   psql postgres
   ```
   If this works without a password, you can set one:
   ```sql
   ALTER USER postgres PASSWORD 'your-new-password';
   \q
   ```

2. **If password is required but forgotten**
   ```bash
   # Find pg_hba.conf location
   psql -U postgres -c "SHOW hba_file;"
   
   # Edit the file
   nano $(psql -U postgres -tc "SHOW hba_file;")
   
   # Change method to 'trust' temporarily
   # Restart PostgreSQL
   brew services restart postgresql@14
   
   # Reset password
   psql -U postgres -c "ALTER USER postgres PASSWORD 'your-new-password';"
   
   # Restore security in pg_hba.conf
   # Restart again
   brew services restart postgresql@14
   ```

---

## Change Password from Command Line

If you know your current password and want to change it:

### Using psql

```bash
# Connect to PostgreSQL
psql -U postgres

# Change password
ALTER USER postgres PASSWORD 'your-new-password';

# Exit
\q
```

### Using ALTER USER (One Command)

**Windows:**
```cmd
psql -U postgres -c "ALTER USER postgres PASSWORD 'your-new-password';"
```

**Linux/Mac:**
```bash
psql -U postgres -c "ALTER USER postgres PASSWORD 'your-new-password';"
```

### Using Environment Variable

Set password temporarily for a command:

**Windows (PowerShell):**
```powershell
$env:PGPASSWORD="your-current-password"
psql -U postgres -c "ALTER USER postgres PASSWORD 'your-new-password';"
$env:PGPASSWORD=$null
```

**Linux/Mac:**
```bash
PGPASSWORD='your-current-password' psql -U postgres -c "ALTER USER postgres PASSWORD 'your-new-password';"
```

---

## Updating Alliance Configuration

After resetting your PostgreSQL password, update the Alliance configuration:

1. **Edit backend/.env**
   ```bash
   # Open the file
   nano backend/.env  # Linux/Mac
   notepad backend\.env  # Windows
   ```

2. **Update the password**
   ```env
   DB_PASSWORD=your-new-password
   ```

3. **Save and restart**
   - Save the file
   - Restart the backend server

---

## Troubleshooting

### "psql: FATAL: password authentication failed"

**Cause:** Wrong password or authentication method doesn't match pg_hba.conf

**Solutions:**
1. Double-check you're typing the password correctly
2. Try resetting password using pg_hba.conf method above
3. Check if pg_hba.conf allows password authentication

### "psql: could not connect to server"

**Cause:** PostgreSQL service is not running

**Solutions:**
- **Windows:** Start service via services.msc
- **Linux:** `sudo systemctl start postgresql`
- **Mac:** `brew services start postgresql@14`

### "role 'postgres' does not exist"

**Cause:** PostgreSQL installation is incomplete or corrupted

**Solutions:**
1. Reinstall PostgreSQL
2. Or create the postgres user:
   ```bash
   createuser -s postgres
   ```

### "pg_hba.conf: Permission denied"

**Cause:** You need administrator/root privileges

**Solutions:**
- **Windows:** Run text editor as Administrator
- **Linux:** Use `sudo` before commands
- **Mac:** Use `sudo` before commands

### Password works in psql but not in Alliance

**Cause:** Backend .env file has incorrect password

**Solutions:**
1. Check `backend/.env` file exists
2. Verify `DB_PASSWORD=` matches your PostgreSQL password
3. No quotes needed around password in .env file
4. Restart the backend server after changing .env

### Special Characters in Password

If your password contains special characters:

**In psql/SQL commands:** Use single quotes
```sql
ALTER USER postgres PASSWORD 'my@pass#word$123';
```

**In .env file:** No quotes needed
```env
DB_PASSWORD=my@pass#word$123
```

**In command line:** Escape or quote appropriately
```bash
# Linux/Mac
PGPASSWORD='my@pass#word$123' psql -U postgres

# Windows PowerShell
$env:PGPASSWORD='my@pass#word$123'
```

---

## Security Best Practices

1. **Use strong passwords**
   - At least 12 characters
   - Mix of uppercase, lowercase, numbers, symbols
   - Avoid common words or patterns

2. **Don't commit passwords to Git**
   - The `.env` file is in `.gitignore`
   - Never add passwords to code or documentation

3. **Use different passwords**
   - PostgreSQL password ≠ Alliance admin password
   - PostgreSQL password ≠ system passwords

4. **Document your passwords securely**
   - Use a password manager
   - Store in encrypted file
   - Don't store in plain text

5. **Change default passwords**
   - Don't use `postgres` as the password
   - Change Alliance admin password (admin123) after first login

6. **Regular backups**
   - Backup your database regularly
   - Test restore procedures
   - Store backups securely

---

## Quick Reference Commands

```bash
# Test connection
psql -U postgres -c "SELECT version();"

# Change password (if you know current one)
psql -U postgres -c "ALTER USER postgres PASSWORD 'new-password';"

# List databases
psql -U postgres -l

# Connect to Alliance database
psql -U postgres -d alliance_property

# Check if Alliance database exists
psql -U postgres -l | grep alliance_property

# Backup Alliance database
pg_dump -U postgres alliance_property > alliance_backup.sql

# Restore Alliance database
psql -U postgres -d alliance_property -f alliance_backup.sql
```

---

## Additional Resources

- [PostgreSQL Documentation: User Management](https://www.postgresql.org/docs/current/user-manag.html)
- [PostgreSQL Documentation: Client Authentication](https://www.postgresql.org/docs/current/client-authentication.html)
- [Alliance Installation Guide](INSTALL.md)
- [Alliance Troubleshooting](INSTALL.md#troubleshooting)

---

## Need Help?

If you're still having issues:
1. Check the [INSTALL.md](INSTALL.md) troubleshooting section
2. Review the database [README.md](database/README.md)
3. Open an issue on GitHub with error details
4. Contact support: support@alliance.co.za

---

**Remember:** Keep your PostgreSQL password secure and update `backend/.env` after any password changes!
