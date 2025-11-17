-- Alliance Property Management System Database Schema

-- Drop existing tables if they exist
DROP TABLE IF EXISTS payments CASCADE;
DROP TABLE IF EXISTS invoices CASCADE;
DROP TABLE IF EXISTS trust_accounts CASCADE;
DROP TABLE IF EXISTS expenses CASCADE;
DROP TABLE IF EXISTS maintenance_requests CASCADE;
DROP TABLE IF EXISTS leases CASCADE;
DROP TABLE IF EXISTS units CASCADE;
DROP TABLE IF EXISTS tenants CASCADE;
DROP TABLE IF EXISTS properties CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- Users table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    role VARCHAR(50) DEFAULT 'user' CHECK (role IN ('admin', 'manager', 'user')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Properties table
CREATE TABLE properties (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    type VARCHAR(100) NOT NULL CHECK (type IN ('office', 'retail', 'industrial', 'warehouse', 'mixed-use')),
    address VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    province VARCHAR(100) NOT NULL,
    postal_code VARCHAR(20),
    description TEXT,
    total_area DECIMAL(10, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tenants table
CREATE TABLE tenants (
    id SERIAL PRIMARY KEY,
    company_name VARCHAR(255) NOT NULL,
    contact_name VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    phone VARCHAR(50),
    address VARCHAR(255),
    city VARCHAR(100),
    province VARCHAR(100),
    postal_code VARCHAR(20),
    vat_number VARCHAR(50),
    registration_number VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Units table (individual rentable spaces within properties)
CREATE TABLE units (
    id SERIAL PRIMARY KEY,
    property_id INTEGER REFERENCES properties(id) ON DELETE CASCADE,
    unit_number VARCHAR(50) NOT NULL,
    floor_number INTEGER,
    area DECIMAL(10, 2) NOT NULL,
    type VARCHAR(100) CHECK (type IN ('office', 'retail', 'storage', 'warehouse')),
    status VARCHAR(50) DEFAULT 'vacant' CHECK (status IN ('vacant', 'occupied', 'maintenance')),
    monthly_rent DECIMAL(10, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(property_id, unit_number)
);

-- Leases table
CREATE TABLE leases (
    id SERIAL PRIMARY KEY,
    tenant_id INTEGER REFERENCES tenants(id) ON DELETE CASCADE,
    unit_id INTEGER REFERENCES units(id) ON DELETE CASCADE,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    monthly_rent DECIMAL(10, 2) NOT NULL,
    deposit DECIMAL(10, 2),
    escalation_rate DECIMAL(5, 2) DEFAULT 0,
    status VARCHAR(50) DEFAULT 'active' CHECK (status IN ('active', 'expired', 'terminated', 'renewed')),
    terms TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Invoices table
CREATE TABLE invoices (
    id SERIAL PRIMARY KEY,
    lease_id INTEGER REFERENCES leases(id) ON DELETE CASCADE,
    amount DECIMAL(10, 2) NOT NULL,
    due_date DATE NOT NULL,
    description TEXT,
    type VARCHAR(50) CHECK (type IN ('rent', 'utilities', 'maintenance', 'other')),
    status VARCHAR(50) DEFAULT 'pending' CHECK (status IN ('pending', 'partial', 'paid', 'overdue')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Payments table
CREATE TABLE payments (
    id SERIAL PRIMARY KEY,
    invoice_id INTEGER REFERENCES invoices(id) ON DELETE CASCADE,
    amount DECIMAL(10, 2) NOT NULL,
    payment_date DATE NOT NULL,
    payment_method VARCHAR(50) CHECK (payment_method IN ('cash', 'eft', 'cheque', 'debit_order', 'credit_card')),
    reference VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Trust Accounts table (South African compliance)
CREATE TABLE trust_accounts (
    id SERIAL PRIMARY KEY,
    lease_id INTEGER REFERENCES leases(id) ON DELETE CASCADE,
    transaction_type VARCHAR(50) CHECK (transaction_type IN ('deposit', 'withdrawal', 'interest')),
    amount DECIMAL(10, 2) NOT NULL,
    balance DECIMAL(10, 2) NOT NULL,
    transaction_date DATE NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Expenses table
CREATE TABLE expenses (
    id SERIAL PRIMARY KEY,
    property_id INTEGER REFERENCES properties(id) ON DELETE CASCADE,
    category VARCHAR(100),
    amount DECIMAL(10, 2) NOT NULL,
    expense_date DATE NOT NULL,
    description TEXT,
    vendor VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Maintenance Requests table
CREATE TABLE maintenance_requests (
    id SERIAL PRIMARY KEY,
    unit_id INTEGER REFERENCES units(id) ON DELETE CASCADE,
    description TEXT NOT NULL,
    priority VARCHAR(50) CHECK (priority IN ('low', 'medium', 'high', 'urgent')),
    category VARCHAR(100),
    status VARCHAR(50) DEFAULT 'pending' CHECK (status IN ('pending', 'in_progress', 'completed', 'cancelled')),
    assigned_to VARCHAR(255),
    completed_date DATE,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for performance
CREATE INDEX idx_properties_city ON properties(city);
CREATE INDEX idx_units_property_id ON units(property_id);
CREATE INDEX idx_units_status ON units(status);
CREATE INDEX idx_leases_tenant_id ON leases(tenant_id);
CREATE INDEX idx_leases_unit_id ON leases(unit_id);
CREATE INDEX idx_leases_status ON leases(status);
CREATE INDEX idx_invoices_lease_id ON invoices(lease_id);
CREATE INDEX idx_invoices_status ON invoices(status);
CREATE INDEX idx_payments_invoice_id ON payments(invoice_id);
CREATE INDEX idx_maintenance_unit_id ON maintenance_requests(unit_id);
CREATE INDEX idx_maintenance_status ON maintenance_requests(status);

-- Insert sample admin user (password: admin123)
INSERT INTO users (email, password, first_name, last_name, role)
VALUES ('admin@alliance.co.za', '$2a$10$YQhE3r0Z9h8GvVJKxNqXM.WkHxNfXqYgL5bXz9X2xrMQ8XzxX0X0K', 'Admin', 'User', 'admin');

-- Insert sample data for demonstration
INSERT INTO properties (name, type, address, city, province, total_area)
VALUES 
    ('Alliance Office Park', 'office', '123 Business Street', 'Durban', 'KwaZulu-Natal', 5000.00),
    ('Durban Retail Centre', 'retail', '456 Commerce Road', 'Durban', 'KwaZulu-Natal', 3000.00);

INSERT INTO tenants (company_name, contact_name, email, phone)
VALUES 
    ('ABC Corporation', 'John Smith', 'john@abc.co.za', '031-123-4567'),
    ('XYZ Enterprises', 'Jane Doe', 'jane@xyz.co.za', '031-987-6543');

INSERT INTO units (property_id, unit_number, floor_number, area, type, status, monthly_rent)
VALUES 
    (1, 'A101', 1, 250.00, 'office', 'occupied', 15000.00),
    (1, 'A102', 1, 200.00, 'office', 'vacant', 12000.00),
    (2, 'R01', 1, 300.00, 'retail', 'occupied', 25000.00);

INSERT INTO leases (tenant_id, unit_id, start_date, end_date, monthly_rent, deposit, escalation_rate, status)
VALUES 
    (1, 1, '2024-01-01', '2026-12-31', 15000.00, 30000.00, 8.00, 'active'),
    (2, 3, '2024-06-01', '2027-05-31', 25000.00, 50000.00, 7.50, 'active');
