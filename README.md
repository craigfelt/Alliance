# Alliance Property Management System

A modern, cloud-based property management system for Alliance Property Group in Durban, South Africa. This system replaces the legacy MDA Property Manager with a comprehensive web-based solution designed for commercial property leasing.

## 📦 Easy Installation Available!

**New!** Download and run our automated installer to get up and running in minutes:
- **Windows**: `install.ps1` (PowerShell) or `install.bat`
- **Mac/Linux**: `install.sh`

See [INSTALLER_SUMMARY.md](INSTALLER_SUMMARY.md) for a quick overview, or jump directly to [INSTALL.md](INSTALL.md) for complete installation instructions.

## 🌟 Features

### Core Functionality
- **Dashboard** - Real-time overview of properties, tenants, leases, and financial metrics
- **Property Management** - Manage commercial properties (office, retail, industrial, warehouse)
- **Tenant Management** - Complete tenant profiles and relationship management
- **Lease Management** - Automated lease creation, renewals, and escalation tracking
- **Financial Management** - Invoicing, payments, and South African trust account compliance
- **Maintenance Management** - Track and manage maintenance requests and work orders
- **Reporting & Analytics** - Financial reports, occupancy reports, and arrears tracking

### South African Specific Features
- Trust account management (SA compliance)
- VAT handling
- ZAR currency formatting
- Lease escalation calculations (standard SA formulas)
- Commercial property lease templates

### MDA Migration Support
- Data import utilities for MDA Property Manager
- Database mapping and transformation tools
- Validation and error handling

## 🛠️ Technology Stack

### Frontend
- **React** - Modern UI framework
- **Vite** - Fast build tool
- **React Router** - Client-side routing
- **TailwindCSS** - Utility-first styling
- **Lucide React** - Beautiful icons
- **Axios** - HTTP client

### Backend
- **Node.js** - Runtime environment
- **Express** - Web framework
- **PostgreSQL** - Relational database
- **JWT** - Authentication
- **bcryptjs** - Password hashing

## 📋 Prerequisites

- Node.js 18+ and npm
- PostgreSQL 14+
- Git

## 🚀 Installation

### Easy Installation (Recommended)

We provide automated installer scripts that will download and set up everything for you:

**Windows:**
- **⭐ EASIEST (Recommended):** Download and double-click `install-powershell.bat` 
  - This launcher automatically handles PowerShell execution policy and runs the installer
  - No security warnings or permission issues!
- **Alternative 1:** Download and run `install.bat` (Command Prompt version)
- **Alternative 2:** Download `install.ps1` and run with: `powershell.exe -ExecutionPolicy Bypass -File .\install.ps1`
- The installer will automatically clone the repository if needed

**Linux/Mac:**
- Download and run `install.sh`
- The installer will automatically clone the repository if needed

**Quick Download & Install (One Command):**
```bash
# Linux/Mac
curl -o install.sh https://raw.githubusercontent.com/craigfelt/Alliance/main/install.sh && chmod +x install.sh && ./install.sh

# Windows PowerShell (Downloads and runs launcher - no execution policy issues!)
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/craigfelt/Alliance/main/install-powershell.bat" -OutFile "install-powershell.bat"; .\install-powershell.bat

# Windows PowerShell (Alternative - Direct script with bypass)
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/craigfelt/Alliance/main/install.ps1" -OutFile "install.ps1"; powershell.exe -ExecutionPolicy Bypass -File .\install.ps1
```

**The installer will automatically:**
- Clone the repository from GitHub (if not already cloned)
- Check all prerequisites
- Install all dependencies
- Set up the database
- Configure environment files

### 🔑 PostgreSQL Password Issues?

If the installer fails with password authentication errors:

1. **Reset your PostgreSQL password:**
   - **Windows:** Download and run [`reset-postgres-password.bat`](https://raw.githubusercontent.com/craigfelt/Alliance/main/reset-postgres-password.bat) as Administrator
   - **Linux/Mac:** Download and run [`reset-postgres-password.sh`](https://raw.githubusercontent.com/craigfelt/Alliance/main/reset-postgres-password.sh)

2. **See complete password guide:** [POSTGRESQL_PASSWORD_SETUP.md](POSTGRESQL_PASSWORD_SETUP.md)

3. **Common fixes:**
   - Verify PostgreSQL is running (services.msc on Windows)
   - Try default password: `postgres`
   - Check your installation notes for the password you set

### 💻 Local Development in VS Code?

If you're working on the Alliance app locally and can't connect to PostgreSQL:
- **See:** [VSCODE_POSTGRESQL_SETUP.md](VSCODE_POSTGRESQL_SETUP.md) for complete local development setup guide

📖 **See [INSTALL.md](INSTALL.md) for detailed installation instructions and troubleshooting.**
📥 **See [DOWNLOAD.md](DOWNLOAD.md) for various download methods.**
🔄 **See [CLONE_SETUP.md](CLONE_SETUP.md) for manual repository cloning (optional).**

### Manual Installation

#### 1. Clone the repository
```bash
git clone https://github.com/craigfelt/Alliance.git
cd Alliance
```

📖 **Need detailed cloning instructions?** See [CLONE_SETUP.md](CLONE_SETUP.md) for a comprehensive guide on cloning the repository to your PC, including multiple methods, troubleshooting, and Git basics.

#### 2. Set up the database
```bash
# Create PostgreSQL database
createdb alliance_property

# Run the schema
psql alliance_property < database/schema.sql
```

#### 3. Install backend dependencies
```bash
cd backend
npm install
cp .env.example .env
# Edit .env with your database credentials
```

#### 4. Install frontend dependencies
```bash
cd ../frontend
npm install
cp .env.example .env
```

#### 5. Start the application

**Backend (Terminal 1):**
```bash
cd backend
npm run dev
```

**Frontend (Terminal 2):**
```bash
cd frontend
npm run dev
```

The application will be available at:
- Frontend: http://localhost:5173
- Backend API: http://localhost:5000

## 🔐 Default Credentials

- **Email:** admin@alliance.co.za
- **Password:** admin123

⚠️ **Important:** Change these credentials after first login in production.

## 📊 Database Schema

The system includes comprehensive tables for:
- Users (authentication and authorization)
- Properties and Units
- Tenants
- Leases
- Invoices and Payments
- Trust Accounts (SA compliance)
- Expenses
- Maintenance Requests

See `database/schema.sql` for complete schema details.

## 🔄 MDA Data Migration

To migrate data from MDA Property Manager:

1. Export data from MDA to SQL format
2. Use the migration utilities in `/backend/src/services/migration.js`
3. Map MDA fields to Alliance schema
4. Run validation checks
5. Import data through API endpoints

Detailed migration guide available in `/docs/MDA_MIGRATION.md`

## 📱 Key Modules

### Dashboard
- Portfolio overview
- Occupancy rates
- Financial metrics
- Recent activity

### Properties
- Property listings
- Unit management
- Occupancy tracking
- Property details and documentation

### Tenants
- Tenant profiles
- Contact management
- Lease history
- Payment history

### Leases
- Lease agreements
- Renewal management
- Escalation tracking
- Terms and conditions

### Financial
- Invoice generation
- Payment recording
- Trust account management
- Arrears tracking
- VAT handling

### Maintenance
- Work order management
- Contractor tracking
- Request status updates
- Cost tracking

### Reports
- Financial reports
- Occupancy reports
- Arrears reports
- Custom analytics

## 🔒 Security

- JWT-based authentication
- Password hashing with bcrypt
- Role-based access control
- SQL injection prevention
- XSS protection
- CORS configuration

## 📄 API Documentation

API endpoints are available at `/api/*`:

- `/api/auth` - Authentication
- `/api/properties` - Property management
- `/api/tenants` - Tenant management
- `/api/leases` - Lease management
- `/api/financial` - Financial operations
- `/api/maintenance` - Maintenance requests
- `/api/reports` - Report generation
- `/api/dashboard` - Dashboard statistics

## 🤖 GitHub Copilot Workflow

This repository supports GitHub Copilot Agent for automated code changes via PRs. To sync agent changes to your local repository:

**Quick Sync:**
```bash
# Windows
sync-pr.bat <branch-name>

# Linux/Mac
./sync-pr.sh <branch-name>
```

**Example:**
```bash
./sync-pr.sh copilot/find-cloning-repository-location
```

For complete details on using GitHub Copilot (both the agent and local VS Code extension), see [COPILOT_WORKFLOW.md](COPILOT_WORKFLOW.md).

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

## 📞 Support

For support and questions:
- Email: support@alliance.co.za
- Documentation: `/docs`

## 📝 License

Copyright © 2024 Alliance Property Group. All rights reserved.

## 🎯 Roadmap

- [ ] Mobile app (iOS/Android)
- [ ] Advanced analytics and AI insights
- [ ] Document management with OCR
- [ ] Automated rent collection
- [ ] Tenant portal
- [ ] Online lease signing
- [ ] Integration with banking APIs
- [ ] WhatsApp notifications
- [ ] Multi-language support

---

Built with ❤️ for Alliance Property Group, Durban, South Africa
