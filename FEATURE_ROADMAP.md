# Alliance Property Management System - Feature Roadmap

## 🎯 Goal
Match and exceed all functionality currently available in MDA Property Manager, specifically for **commercial property management in South Africa (ZAR-based)**.

---

## 📊 Current Features (Already Implemented)

### ✅ Core Modules
- [x] User Authentication & Authorization
- [x] Property Management (CRUD)
- [x] Tenant Management (CRUD)
- [x] Lease Management (CRUD + Renewal)
- [x] Basic Invoicing
- [x] Payment Recording
- [x] Maintenance Requests
- [x] Dashboard Statistics
- [x] Trust Account Tables
- [x] Basic Reports

---

## 🚀 Required Features to Add (Commercial Property Management - South Africa)

### 1. **Financial Management** 💰

#### 1.1 Advanced Invoicing
- [ ] **Recurring Invoice Generation**
  - Auto-generate monthly rent invoices
  - Scheduled invoice creation (1st of month)
  - Bulk invoice generation for all active leases
  - Invoice templates (Rent, Utilities, Service Charges, etc.)
  
- [ ] **VAT Calculations (15% SA Standard)**
  - VAT-inclusive vs VAT-exclusive amounts
  - VAT breakdown on invoices
  - VAT number validation (SA format)
  - VAT reporting (VAT 201 returns)
  
- [ ] **Invoice Types**
  - Rent invoices
  - Service charge invoices
  - Utility invoices (water, electricity)
  - Deposit invoices
  - Credit notes
  - Debit notes
  - Interest charges (on arrears)

#### 1.2 Payment Management
- [ ] **Payment Allocation**
  - Allocate partial payments across multiple invoices
  - Payment priority (oldest first, highest first)
  - Manual payment allocation
  - Automatic allocation rules
  
- [ ] **Payment Methods**
  - EFT (Electronic Funds Transfer)
  - Debit Order
  - Cash
  - Cheque
  - Credit Card
  - Bank Deposit
  
- [ ] **Payment Reconciliation**
  - Bank statement import (CSV/Excel)
  - Match payments to invoices automatically
  - Unallocated payments tracking
  - Reconciliation reports

#### 1.3 Arrears Management
- [ ] **Arrears Tracking**
  - Age analysis (30, 60, 90+ days)
  - Automatic arrears calculation
  - Arrears interest calculation
  - Arrears notifications
  
- [ ] **Collection Management**
  - Collection letters (automated)
  - Handover to attorneys tracking
  - Payment plans
  - Write-off management

#### 1.4 Deposit Management
- [ ] **Deposit Tracking**
  - Deposit receipt on lease start
  - Deposit interest calculation (if applicable)
  - Deposit deductions (damages, outstanding)
  - Deposit refund processing
  - Deposit reconciliation

#### 1.5 Trust Account Management (FPSA Compliance)
- [ ] **Multiple Trust Accounts**
  - Create multiple trust accounts
  - Allocate payments to specific trust accounts
  - Trust account reconciliation
  - Trust account statements
  - Compliance reporting

#### 1.6 Expenses & Costs
- [ ] **Property Expenses**
  - Record property expenses (maintenance, rates, insurance)
  - Expense categories
  - Expense allocation to properties/units
  - Expense approval workflow
  - Expense reporting

- [ ] **Service Charges**
  - Calculate service charges per unit
  - Service charge budgets
  - Service charge recovery
  - Service charge statements

---

### 2. **Lease Management** 📋

#### 2.1 Lease Escalation
- [ ] **Automatic Escalation**
  - Annual escalation calculation
  - Escalation date tracking
  - Escalation percentage/amount
  - Escalation history
  - Escalation notifications (30 days before)
  
- [ ] **Escalation Types**
  - Percentage-based (e.g., 8% per annum)
  - Fixed amount increase
  - CPI-linked escalation
  - Custom escalation formulas

#### 2.2 Lease Renewal
- [ ] **Renewal Management**
  - Renewal reminders (60, 30, 14 days before expiry)
  - Renewal negotiation tracking
  - Renewal document generation
  - Renewal history

#### 2.3 Lease Terms & Conditions
- [ ] **Lease Details**
  - Lease period (start/end dates)
  - Notice periods
  - Break clauses
  - Renewal options
  - Special conditions
  - Lease document storage

#### 2.4 Lease Variations
- [ ] **Lease Amendments**
  - Rent increases/decreases
  - Term extensions/reductions
  - Additional space
  - Variation history

---

### 3. **Reporting & Analytics** 📊

#### 3.1 Financial Reports
- [ ] **Income Reports**
  - Monthly income statement
  - Annual income statement
  - Income by property
  - Income by tenant
  - Income trends
  
- [ ] **Expense Reports**
  - Monthly expense report
  - Annual expense report
  - Expense by category
  - Expense by property
  - Budget vs Actual
  
- [ ] **Profit & Loss**
  - Property P&L
  - Portfolio P&L
  - Year-to-date P&L
  - Comparative P&L

#### 3.2 Occupancy Reports
- [ ] **Occupancy Analysis**
  - Occupancy rate by property
  - Occupancy rate by property type
  - Vacancy analysis
  - Lease expiry calendar
  - Renewal probability

#### 3.3 Arrears Reports
- [ ] **Arrears Analysis**
  - Age analysis report
  - Arrears by tenant
  - Arrears by property
  - Collection efficiency
  - Bad debt analysis

#### 3.4 Tenant Reports
- [ ] **Tenant Analysis**
  - Tenant payment history
  - Tenant lease history
  - Tenant communication log
  - Tenant satisfaction metrics

#### 3.5 Property Reports
- [ ] **Property Performance**
  - Property ROI
  - Property yield
  - Property expenses vs income
  - Property valuation tracking

#### 3.6 Compliance Reports
- [ ] **Regulatory Reports**
  - VAT returns (VAT 201)
  - Trust account reconciliation
  - FPSA compliance reports
  - Tax certificates (IRP5/IT3)

---

### 4. **Document Management** 📄

- [ ] **Document Storage**
  - Lease agreements (PDF upload)
  - Invoices (PDF generation)
  - Statements (PDF generation)
  - Receipts
  - Compliance certificates
  - Maintenance records
  - Communication records
  
- [ ] **Document Templates**
  - Lease agreement templates
  - Invoice templates
  - Statement templates
  - Letter templates (collection, renewal, etc.)

---

### 5. **Communication & Notifications** 📧

- [ ] **Email Notifications**
  - Invoice emails (auto-send)
  - Statement emails
  - Payment confirmations
  - Arrears reminders
  - Lease renewal reminders
  - Escalation notifications
  
- [ ] **SMS Notifications** (Optional)
  - Payment reminders
  - Arrears alerts
  - Maintenance updates

- [ ] **Communication Log**
  - Track all tenant communications
  - Email history
  - Phone call logs
  - Meeting notes

---

### 6. **Advanced Features** ⚡

#### 6.1 Automation
- [ ] **Automated Tasks**
  - Auto-generate monthly invoices
  - Auto-calculate escalations
  - Auto-send statements
  - Auto-apply late fees
  - Auto-update arrears

#### 6.2 Integration
- [ ] **Bank Integration** (Future)
  - Bank statement import
  - Payment gateway integration
  
- [ ] **Accounting Integration** (Future)
  - Export to Xero/QuickBooks
  - General ledger export

#### 6.3 Advanced Search & Filtering
- [ ] **Global Search**
  - Search across all entities
  - Advanced filters
  - Saved searches

---

### 7. **South African Specific Features** 🇿🇦

- [ ] **ZAR Currency**
  - All amounts in ZAR
  - Proper ZAR formatting (R 1,234.56)
  - Currency conversion (if needed)
  
- [ ] **SA Tax Compliance**
  - VAT calculations (15%)
  - Tax certificates
  - SARS compliance
  
- [ ] **SA Banking**
  - SA bank account formats
  - EFT reference formats
  - Debit order support
  
- [ ] **SA Address Formats**
  - SA postal codes
  - SA provinces
  - SA cities

---

## 📋 Implementation Priority

### Phase 1: Critical (Match MDA Core Features)
1. Recurring Invoice Generation
2. VAT Calculations
3. Payment Allocation
4. Arrears Management
5. Lease Escalation
6. Basic Financial Reports

### Phase 2: Important (Enhance MDA Features)
1. Bank Reconciliation
2. Deposit Management
3. Document Management
4. Email Notifications
5. Advanced Reports

### Phase 3: Advanced (Exceed MDA)
1. Automation
2. Integration
3. Advanced Analytics
4. Mobile App

---

## 🔍 Where to Find Standard Features

### Research Sources:
1. **PayProp** (https://www.payprop.com/za) - Leading SA property management software
2. **PropData** - Commercial property management features
3. **MDA Property Manager** - Your current system (reference)
4. **FPSA Guidelines** - Trust account requirements
5. **SARS Guidelines** - VAT and tax requirements

### Standard Commercial Property Management Features:
- Recurring billing (monthly rent)
- Escalation management
- Service charge recovery
- Arrears tracking
- Trust account management
- Financial reporting
- Document management
- Tenant communication

---

## 📝 Next Steps

1. **Review MDA System** - List all features currently used
2. **Prioritize Features** - Which features are used most?
3. **Start Implementation** - Begin with Phase 1 features
4. **Test & Iterate** - Match MDA functionality exactly

---

**Ready to start implementing?** Let me know which features to prioritize first!

