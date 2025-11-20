#!/bin/bash

# Alliance Property Management System - Universal Installer (Linux/Mac)
# Run this script to install and setup the application
# Usage: chmod +x install.sh && ./install.sh

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo ""
echo -e "${CYAN}======================================================${NC}"
echo -e "${CYAN}  Alliance Property Management System - Installer${NC}"
echo -e "${CYAN}======================================================${NC}"
echo ""

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if we're in a cloned repository or need to clone
REPO_URL="https://github.com/craigfelt/Alliance.git"
NEEDS_CLONE=0
ORIGINAL_DIR=$(pwd)

# Check if we're in the Alliance repository
if [ ! -f "package.json" ] || [ ! -d "backend" ] || [ ! -d "frontend" ]; then
    echo -e "${YELLOW}Repository files not found in current directory.${NC}"
    echo -e "${YELLOW}This installer will clone the repository from GitHub.${NC}"
    echo ""
    NEEDS_CLONE=1
fi

# Step 1: Check Prerequisites
echo -e "${YELLOW}Step 1: Checking Prerequisites...${NC}"
echo ""

# Check Node.js
echo -n "  Checking Node.js..."
if command_exists node; then
    NODE_VERSION=$(node --version)
    echo -e " ${GREEN}Found: $NODE_VERSION${NC}"
    
    # Check if version is 18 or higher
    VERSION_NUM=$(echo $NODE_VERSION | sed 's/v\([0-9]*\).*/\1/')
    if [ "$VERSION_NUM" -lt 18 ]; then
        echo -e "    ${RED}WARNING: Node.js 18+ is recommended. Current: $NODE_VERSION${NC}"
    fi
else
    echo -e " ${RED}NOT FOUND${NC}"
    echo ""
    echo -e "${RED}Please install Node.js 18+ from https://nodejs.org/${NC}"
    echo -e "${RED}After installation, run this script again.${NC}"
    exit 1
fi

# Check npm
echo -n "  Checking npm..."
if command_exists npm; then
    NPM_VERSION=$(npm --version)
    echo -e " ${GREEN}Found: v$NPM_VERSION${NC}"
else
    echo -e " ${RED}NOT FOUND${NC}"
    echo -e "${RED}npm should be installed with Node.js. Please reinstall Node.js.${NC}"
    exit 1
fi

# Check PostgreSQL
echo -n "  Checking PostgreSQL..."
if command_exists psql; then
    PG_VERSION=$(psql --version)
    echo -e " ${GREEN}Found: $PG_VERSION${NC}"
else
    echo -e " ${RED}NOT FOUND${NC}"
    echo ""
    echo -e "${RED}Please install PostgreSQL 14+:${NC}"
    echo -e "${RED}  - Ubuntu/Debian: sudo apt-get install postgresql${NC}"
    echo -e "${RED}  - macOS: brew install postgresql@14${NC}"
    echo -e "${RED}  - Or visit: https://www.postgresql.org/download/${NC}"
    echo ""
    echo -e "${YELLOW}TIP: Remember your PostgreSQL password!${NC}"
    exit 1
fi

# Check Git (optional)
echo -n "  Checking Git..."
if command_exists git; then
    GIT_VERSION=$(git --version)
    echo -e " ${GREEN}Found: $GIT_VERSION${NC}"
else
    if [ $NEEDS_CLONE -eq 1 ]; then
        echo -e " ${RED}NOT FOUND${NC}"
        echo ""
        echo -e "${RED}Git is required to clone the repository.${NC}"
        echo -e "${RED}Please install Git:${NC}"
        echo -e "${RED}  - Ubuntu/Debian: sudo apt-get install git${NC}"
        echo -e "${RED}  - macOS: brew install git${NC}"
        echo -e "${RED}  - Or visit: https://git-scm.com/${NC}"
        echo -e "${RED}After installation, run this script again.${NC}"
        exit 1
    else
        echo -e " ${YELLOW}NOT FOUND (Optional)${NC}"
        echo -e "    ${YELLOW}Git is optional but recommended for updates.${NC}"
    fi
fi

echo ""
echo -e "${GREEN}All required prerequisites are installed!${NC}"
echo ""

# Step 1.5: Clone Repository if needed
if [ $NEEDS_CLONE -eq 1 ]; then
    echo -e "${YELLOW}Step 1.5: Cloning Repository from GitHub...${NC}"
    echo ""
    
    CLONE_DIR="Alliance"
    COUNTER=1
    
    # Find available directory name
    while [ -d "$CLONE_DIR" ]; do
        CLONE_DIR="Alliance_$COUNTER"
        COUNTER=$((COUNTER + 1))
    done
    
    echo -e "  ${CYAN}Cloning into directory: $CLONE_DIR${NC}"
    echo -e "  ${CYAN}Full path: $ORIGINAL_DIR/$CLONE_DIR${NC}"
    echo -e "  ${CYAN}Repository: $REPO_URL${NC}"
    echo ""
    echo -e "  ${YELLOW}This may take a few minutes depending on your connection...${NC}"
    echo ""
    
    git clone $REPO_URL $CLONE_DIR
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed to clone repository${NC}"
        echo -e "${RED}Please check your internet connection and try again.${NC}"
        exit 1
    fi
    
    echo ""
    echo -e "  ${GREEN}Repository cloned successfully!${NC}"
    echo -e "  ${CYAN}Location: $ORIGINAL_DIR/$CLONE_DIR${NC}"
    echo -e "  ${CYAN}Changing to repository directory...${NC}"
    echo ""
    
    cd $CLONE_DIR
fi


# Step 2: Install Dependencies
echo -e "${YELLOW}Step 2: Installing Dependencies...${NC}"
echo ""

# Install root dependencies
echo -e "  ${CYAN}Installing root dependencies...${NC}"
npm install
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to install root dependencies${NC}"
    exit 1
fi

# Install backend dependencies
echo -e "  ${CYAN}Installing backend dependencies...${NC}"
cd backend
npm install
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to install backend dependencies${NC}"
    exit 1
fi
cd ..

# Install frontend dependencies
echo -e "  ${CYAN}Installing frontend dependencies...${NC}"
cd frontend
npm install
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to install frontend dependencies${NC}"
    exit 1
fi
cd ..

echo ""
echo -e "${GREEN}Dependencies installed successfully!${NC}"
echo ""

# Step 3: Setup Environment Files
echo -e "${YELLOW}Step 3: Setting up Environment Files...${NC}"
echo ""

# Setup backend .env
if [ ! -f "backend/.env" ]; then
    echo -e "  ${CYAN}Creating backend .env file...${NC}"
    cp backend/.env.example backend/.env
    
    # Prompt for database password
    echo ""
    echo -e "  ${YELLOW}Please enter your PostgreSQL password for user 'postgres':${NC}"
    read -s -p "  Password: " DB_PASSWORD
    echo ""
    
    # Update .env file with password
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        sed -i '' "s/DB_PASSWORD=postgres/DB_PASSWORD=$DB_PASSWORD/" backend/.env
    else
        # Linux
        sed -i "s/DB_PASSWORD=postgres/DB_PASSWORD=$DB_PASSWORD/" backend/.env
    fi
    
    echo -e "  ${GREEN}Backend .env created!${NC}"
else
    echo -e "  ${YELLOW}Backend .env already exists, skipping...${NC}"
    # Read password from existing .env
    DB_PASSWORD=$(grep DB_PASSWORD backend/.env | cut -d '=' -f2)
fi

# Setup frontend .env
if [ ! -f "frontend/.env" ]; then
    echo -e "  ${CYAN}Creating frontend .env file...${NC}"
    cp frontend/.env.example frontend/.env
    echo -e "  ${GREEN}Frontend .env created!${NC}"
else
    echo -e "  ${YELLOW}Frontend .env already exists, skipping...${NC}"
fi

echo ""

# Step 4: Setup Database
echo -e "${YELLOW}Step 4: Setting up Database...${NC}"
echo ""

DB_NAME="alliance_property"
DB_USER="postgres"

echo -e "  ${CYAN}Database Name: $DB_NAME${NC}"
echo -e "  ${CYAN}Database User: $DB_USER${NC}"
echo ""

# Set PostgreSQL password for commands
export PGPASSWORD="$DB_PASSWORD"

# Check if database exists
echo -e "  ${CYAN}Checking if database exists...${NC}"
if psql -U $DB_USER -lqt 2>/dev/null | cut -d \| -f 1 | grep -qw $DB_NAME; then
    echo -e "  ${YELLOW}Database '$DB_NAME' already exists.${NC}"
    read -p "  Do you want to drop and recreate it? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "  ${CYAN}Dropping existing database...${NC}"
        dropdb -U $DB_USER $DB_NAME
        if [ $? -ne 0 ]; then
            echo -e "  ${RED}Failed to drop database${NC}"
            exit 1
        fi
        CREATE_DB=1
    else
        echo -e "  ${YELLOW}Keeping existing database. Skipping database setup...${NC}"
        CREATE_DB=0
    fi
else
    CREATE_DB=1
fi

if [ $CREATE_DB -eq 1 ]; then
    # Create database
    echo -e "  ${CYAN}Creating database...${NC}"
    psql -U $DB_USER -d postgres -f database/create_database.sql >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo -e "  ${YELLOW}Database creation via script had issues, trying createdb command...${NC}"
        createdb -U $DB_USER $DB_NAME >/dev/null 2>&1
        if [ $? -ne 0 ]; then
            echo -e "  ${RED}Failed to create database${NC}"
            echo -e "  ${RED}Make sure PostgreSQL is running and credentials are correct.${NC}"
            exit 1
        fi
    fi
    echo -e "  ${GREEN}Database created successfully!${NC}"
    
    # Run schema
    echo -e "  ${CYAN}Applying database schema...${NC}"
    psql -U $DB_USER -d $DB_NAME -f database/schema.sql >/dev/null
    if [ $? -ne 0 ]; then
        echo -e "  ${RED}Failed to apply schema${NC}"
        exit 1
    fi
    echo -e "  ${GREEN}Schema applied successfully!${NC}"
fi

# Clear password from environment
unset PGPASSWORD

echo ""

# Installation Complete
echo -e "${GREEN}======================================================${NC}"
echo -e "${GREEN}  Installation Completed Successfully!${NC}"
echo -e "${GREEN}======================================================${NC}"
echo ""

echo -e "${CYAN}Next Steps:${NC}"
echo ""
echo -e "${YELLOW}1. Start the Backend Server:${NC}"
echo "   - Open a new terminal window"
echo "   - Navigate to: $(pwd)/backend"
echo "   - Run: npm run dev"
echo "   - Backend will start at: http://localhost:5000"
echo ""

echo -e "${YELLOW}2. Start the Frontend Application:${NC}"
echo "   - Open another terminal window"
echo "   - Navigate to: $(pwd)/frontend"
echo "   - Run: npm run dev"
echo "   - Frontend will start at: http://localhost:5173"
echo ""

echo -e "${YELLOW}3. Access the Application:${NC}"
echo "   - Open your browser to: http://localhost:5173"
echo -e "   - Login with:"
echo -e "     ${GREEN}Email: admin@alliance.co.za${NC}"
echo -e "     ${GREEN}Password: admin123${NC}"
echo ""

echo -e "${RED}IMPORTANT: Change the default credentials after first login!${NC}"
echo ""

echo -e "${CYAN}For more information, see README.md and QUICKSTART.md${NC}"
echo ""

# Ask if user wants to start the servers now
echo -e "${YELLOW}Would you like to start the application now? (y/N)${NC}"
read -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo -e "${CYAN}Starting backend server...${NC}"
    
    # Check if running on macOS
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS - use osascript to open new Terminal windows
        osascript -e "tell application \"Terminal\" to do script \"cd '$(pwd)/backend' && npm run dev\""
        sleep 3
        echo -e "${CYAN}Starting frontend application...${NC}"
        osascript -e "tell application \"Terminal\" to do script \"cd '$(pwd)/frontend' && npm run dev\""
        sleep 5
        # Open browser
        open "http://localhost:5173"
    else
        # Linux - try different terminal emulators
        if command_exists gnome-terminal; then
            gnome-terminal -- bash -c "cd $(pwd)/backend && npm run dev; exec bash"
            sleep 3
            gnome-terminal -- bash -c "cd $(pwd)/frontend && npm run dev; exec bash"
        elif command_exists xterm; then
            xterm -hold -e "cd $(pwd)/backend && npm run dev" &
            sleep 3
            xterm -hold -e "cd $(pwd)/frontend && npm run dev" &
        else
            echo -e "${YELLOW}Could not detect terminal emulator.${NC}"
            echo -e "${YELLOW}Please manually start the backend and frontend in separate terminals.${NC}"
            exit 0
        fi
        
        sleep 5
        # Open browser
        if command_exists xdg-open; then
            xdg-open "http://localhost:5173"
        elif command_exists open; then
            open "http://localhost:5173"
        fi
    fi
    
    echo ""
    echo -e "${GREEN}Servers starting in new windows...${NC}"
    echo -e "${GREEN}The application will be available at http://localhost:5173 in a few seconds.${NC}"
    echo ""
fi

echo ""
echo -e "${CYAN}Thank you for installing Alliance Property Management System!${NC}"
echo ""
