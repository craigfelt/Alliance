#!/bin/bash
# PostgreSQL Password Reset Helper for Linux/Mac
# This script helps you reset your PostgreSQL password

set -e

echo ""
echo "================================================================"
echo "  PostgreSQL Password Reset Helper"
echo "================================================================"
echo ""
echo "This script will help you reset the PostgreSQL 'postgres' user password."
echo ""
echo "PREREQUISITES:"
echo "  - PostgreSQL must be installed"
echo "  - You may need sudo/root privileges"
echo ""
echo "WARNING: This script will temporarily make PostgreSQL less secure."
echo "         Follow all steps carefully and restore security at the end."
echo ""
read -p "Press Enter to continue or Ctrl+C to cancel..."

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="mac"
    echo "Detected: macOS"
elif [[ -f /etc/debian_version ]]; then
    OS="debian"
    echo "Detected: Debian/Ubuntu Linux"
elif [[ -f /etc/redhat-release ]]; then
    OS="redhat"
    echo "Detected: RedHat/CentOS/Fedora Linux"
else
    OS="unknown"
    echo "Detected: Unknown OS"
fi

echo ""

# Find PostgreSQL version and paths
echo "Step 1: Finding PostgreSQL installation..."
echo ""

if command -v psql >/dev/null 2>&1; then
    PG_VERSION=$(psql --version | grep -oP '\d+' | head -1)
    echo "Found PostgreSQL version: $PG_VERSION"
else
    echo "ERROR: psql command not found. Is PostgreSQL installed?"
    exit 1
fi

# Find pg_hba.conf location
if [[ "$OS" == "mac" ]]; then
    # Mac (Homebrew)
    if [[ -f "/opt/homebrew/var/postgresql@$PG_VERSION/pg_hba.conf" ]]; then
        PG_HBA="/opt/homebrew/var/postgresql@$PG_VERSION/pg_hba.conf"
        PG_SERVICE="postgresql@$PG_VERSION"
    elif [[ -f "/usr/local/var/postgresql@$PG_VERSION/pg_hba.conf" ]]; then
        PG_HBA="/usr/local/var/postgresql@$PG_VERSION/pg_hba.conf"
        PG_SERVICE="postgresql@$PG_VERSION"
    else
        echo "WARNING: Could not find pg_hba.conf in standard Homebrew locations"
        PG_HBA=$(psql postgres -tc "SHOW hba_file;" 2>/dev/null | tr -d ' ')
    fi
elif [[ "$OS" == "debian" ]]; then
    PG_HBA="/etc/postgresql/$PG_VERSION/main/pg_hba.conf"
    PG_SERVICE="postgresql"
elif [[ "$OS" == "redhat" ]]; then
    PG_HBA="/var/lib/pgsql/$PG_VERSION/data/pg_hba.conf"
    PG_SERVICE="postgresql-$PG_VERSION"
else
    # Try to detect automatically
    PG_HBA=$(sudo -u postgres psql -tc "SHOW hba_file;" 2>/dev/null | tr -d ' ')
    PG_SERVICE="postgresql"
fi

if [[ ! -f "$PG_HBA" ]]; then
    echo "ERROR: Could not find pg_hba.conf"
    echo "Please edit this script to set PG_HBA manually, or use the manual"
    echo "method described in POSTGRESQL_PASSWORD_SETUP.md"
    exit 1
fi

echo "Found pg_hba.conf at: $PG_HBA"
echo ""

# Check if we need sudo
NEED_SUDO=false
if [[ ! -w "$PG_HBA" ]]; then
    NEED_SUDO=true
    echo "Note: sudo required to modify pg_hba.conf"
    echo ""
fi

# Function to run command with sudo if needed
run_cmd() {
    if [[ "$NEED_SUDO" == "true" ]]; then
        sudo "$@"
    else
        "$@"
    fi
}

echo "Step 2: Stopping PostgreSQL service..."
echo ""

if [[ "$OS" == "mac" ]]; then
    if command -v brew >/dev/null 2>&1; then
        brew services stop "$PG_SERVICE" || true
    else
        run_cmd pg_ctl stop -D "$(dirname "$PG_HBA")"
    fi
elif [[ "$OS" == "debian" ]] || [[ "$OS" == "redhat" ]]; then
    run_cmd systemctl stop "$PG_SERVICE"
else
    run_cmd pg_ctl stop -D "$(dirname "$PG_HBA")"
fi

echo "PostgreSQL service stopped."
echo ""

echo "Step 3: Backing up pg_hba.conf..."
echo ""

run_cmd cp "$PG_HBA" "$PG_HBA.backup"
echo "Backup created: $PG_HBA.backup"
echo ""

echo "Step 4: Modifying pg_hba.conf to allow password reset..."
echo ""

# Replace authentication methods with 'trust'
run_cmd sed -i.tmp 's/scram-sha-256/trust/g; s/md5/trust/g; s/peer/trust/g' "$PG_HBA"
echo "pg_hba.conf modified (authentication set to 'trust')"
echo ""

echo "Step 5: Starting PostgreSQL service..."
echo ""

if [[ "$OS" == "mac" ]]; then
    if command -v brew >/dev/null 2>&1; then
        brew services start "$PG_SERVICE"
    else
        run_cmd pg_ctl start -D "$(dirname "$PG_HBA")"
    fi
elif [[ "$OS" == "debian" ]] || [[ "$OS" == "redhat" ]]; then
    run_cmd systemctl start "$PG_SERVICE"
else
    run_cmd pg_ctl start -D "$(dirname "$PG_HBA")"
fi

echo "PostgreSQL service started."
echo ""
sleep 3

echo "Step 6: Resetting password..."
echo ""
echo "Please enter your new password for the 'postgres' user."
echo "IMPORTANT: Remember this password! You'll need it to use Alliance."
echo ""

# Read password securely
read -s -p "Enter new password: " NEW_PASSWORD
echo ""

if [[ -z "$NEW_PASSWORD" ]]; then
    echo "ERROR: Password cannot be empty."
    echo "Restoring configuration..."
    run_cmd cp "$PG_HBA.backup" "$PG_HBA"
    if [[ "$OS" == "mac" ]]; then
        brew services restart "$PG_SERVICE" 2>/dev/null || run_cmd pg_ctl restart -D "$(dirname "$PG_HBA")"
    else
        run_cmd systemctl restart "$PG_SERVICE"
    fi
    exit 1
fi

# Reset the password
psql -U postgres -c "ALTER USER postgres PASSWORD '$NEW_PASSWORD';" 2>/dev/null
if [[ $? -ne 0 ]]; then
    echo "ERROR: Failed to reset password."
    echo "Restoring configuration..."
    run_cmd cp "$PG_HBA.backup" "$PG_HBA"
    if [[ "$OS" == "mac" ]]; then
        brew services restart "$PG_SERVICE" 2>/dev/null || run_cmd pg_ctl restart -D "$(dirname "$PG_HBA")"
    else
        run_cmd systemctl restart "$PG_SERVICE"
    fi
    exit 1
fi

echo ""
echo "Password reset successfully!"
echo ""

echo "Step 7: Restoring security settings..."
echo ""

# Stop service
if [[ "$OS" == "mac" ]]; then
    brew services stop "$PG_SERVICE" 2>/dev/null || run_cmd pg_ctl stop -D "$(dirname "$PG_HBA")"
else
    run_cmd systemctl stop "$PG_SERVICE"
fi

# Restore original pg_hba.conf
run_cmd cp "$PG_HBA.backup" "$PG_HBA"

# Start service
if [[ "$OS" == "mac" ]]; then
    brew services start "$PG_SERVICE" 2>/dev/null || run_cmd pg_ctl start -D "$(dirname "$PG_HBA")"
else
    run_cmd systemctl start "$PG_SERVICE"
fi

echo "Security settings restored."
echo ""

echo "Step 8: Testing new password..."
echo ""
sleep 2

PGPASSWORD="$NEW_PASSWORD" psql -U postgres -c "SELECT version();" >/dev/null 2>&1
if [[ $? -ne 0 ]]; then
    echo "WARNING: Password test failed. There may be an issue."
    echo "Please try connecting manually: psql -U postgres"
else
    echo "Password test successful!"
fi

echo ""
echo "================================================================"
echo "  Password Reset Complete!"
echo "================================================================"
echo ""
echo "Your new PostgreSQL password has been set."
echo ""
echo "IMPORTANT NEXT STEPS:"
echo ""
echo "1. Write down your password in a secure location"
echo ""
echo "2. Update Alliance configuration (if already installed):"
echo "   - Open: backend/.env"
echo "   - Change: DB_PASSWORD=your-new-password"
echo "   - Save and restart the backend server"
echo ""
echo "3. Test the connection:"
echo "   psql -U postgres"
echo ""
echo "Backup file saved at: $PG_HBA.backup"
echo "You can delete this file once you've verified everything works."
echo ""
