-- Minimal schema for Alliance Property Management

-- Users
CREATE TABLE IF NOT EXISTS users (
  id SERIAL PRIMARY KEY,
  email TEXT NOT NULL UNIQUE,
  password TEXT NOT NULL,
  role TEXT NOT NULL DEFAULT 'user',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Properties
CREATE TABLE IF NOT EXISTS properties (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  address TEXT,
  type TEXT NOT NULL DEFAULT 'office' CHECK (type IN ('office','retail','industrial','warehouse','mixed-use')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Units
CREATE TABLE IF NOT EXISTS units (
  id SERIAL PRIMARY KEY,
  property_id INTEGER NOT NULL REFERENCES properties(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'available',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Tenants
CREATE TABLE IF NOT EXISTS tenants (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  vat_number TEXT,
  contact_email TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Leases
CREATE TABLE IF NOT EXISTS leases (
  id SERIAL PRIMARY KEY,
  unit_id INTEGER NOT NULL REFERENCES units(id) ON DELETE CASCADE,
  tenant_id INTEGER REFERENCES tenants(id) ON DELETE SET NULL,
  start_date DATE NOT NULL,
  end_date DATE,
  rent_amount NUMERIC(12,2) NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Invoices
CREATE TABLE IF NOT EXISTS invoices (
  id SERIAL PRIMARY KEY,
  lease_id INTEGER REFERENCES leases(id) ON DELETE SET NULL,
  amount NUMERIC(12,2) NOT NULL,
  due_date DATE NOT NULL,
  paid BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Payments
CREATE TABLE IF NOT EXISTS payments (
  id SERIAL PRIMARY KEY,
  invoice_id INTEGER REFERENCES invoices(id) ON DELETE CASCADE,
  amount NUMERIC(12,2) NOT NULL,
  paid_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Trust accounts (FPSA compliance)
CREATE TABLE IF NOT EXISTS trust_accounts (
  id SERIAL PRIMARY KEY,
  account_name TEXT NOT NULL,
  account_number TEXT NOT NULL,
  bank TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Sample admin (development only - plaintext password; your backend may expect hashed passwords)
INSERT INTO users (email, password, role)
VALUES ('admin@alliance.co.za', 'admin123', 'admin')
ON CONFLICT (email) DO NOTHING;