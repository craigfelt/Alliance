/**
 * MDA Property Manager Data Migration Service
 * 
 * This service provides utilities for migrating data from MDA Property Manager
 * to the Alliance Property Management System.
 */

import pool from '../config/database.js';
import fs from 'fs';
import { parse } from 'csv-parse';

/**
 * Map MDA property type to Alliance property type
 */
const mapPropertyType = (mdaType) => {
  const typeMap = {
    'Office': 'office',
    'Retail': 'retail',
    'Industrial': 'industrial',
    'Warehouse': 'warehouse',
    'Mixed Use': 'mixed-use',
    'Mixed-Use': 'mixed-use',
  };
  return typeMap[mdaType] || 'office';
};

/**
 * Map MDA lease status to Alliance lease status
 */
const mapLeaseStatus = (mdaStatus) => {
  const statusMap = {
    'Active': 'active',
    'Expired': 'expired',
    'Terminated': 'terminated',
    'Renewed': 'renewed',
  };
  return statusMap[mdaStatus] || 'active';
};

/**
 * Map MDA transaction type to Alliance invoice type
 */
const mapTransactionType = (mdaType) => {
  const typeMap = {
    'Rent': 'rent',
    'Rental': 'rent',
    'Utilities': 'utilities',
    'Maintenance': 'maintenance',
    'Other': 'other',
  };
  return typeMap[mdaType] || 'other';
};

/**
 * Validate property data before import
 */
export const validatePropertyData = (property) => {
  const errors = [];
  
  if (!property.name) errors.push('Name is required');
  if (!property.address) errors.push('Address is required');
  if (!property.city) errors.push('City is required');
  if (!property.province) errors.push('Province is required');
  if (property.total_area && property.total_area <= 0) {
    errors.push('Total area must be positive');
  }
  
  const validTypes = ['office', 'retail', 'industrial', 'warehouse', 'mixed-use'];
  if (!validTypes.includes(property.type)) {
    errors.push(`Invalid property type: ${property.type}`);
  }
  
  return errors;
};

/**
 * Validate tenant data before import
 */
export const validateTenantData = (tenant) => {
  const errors = [];
  
  if (!tenant.company_name) errors.push('Company name is required');
  if (!tenant.contact_name) errors.push('Contact name is required');
  if (tenant.email && !tenant.email.includes('@')) {
    errors.push('Invalid email format');
  }
  
  return errors;
};

/**
 * Validate lease data before import
 */
export const validateLeaseData = (lease) => {
  const errors = [];
  
  if (!lease.tenant_id) errors.push('Tenant ID is required');
  if (!lease.unit_id) errors.push('Unit ID is required');
  if (!lease.start_date) errors.push('Start date is required');
  if (!lease.end_date) errors.push('End date is required');
  if (!lease.monthly_rent || lease.monthly_rent <= 0) {
    errors.push('Monthly rent must be positive');
  }
  
  const validStatuses = ['active', 'expired', 'terminated', 'renewed'];
  if (!validStatuses.includes(lease.status)) {
    errors.push(`Invalid lease status: ${lease.status}`);
  }
  
  return errors;
};

/**
 * Migrate properties from CSV file
 */
export const migrateProperties = async (csvFilePath) => {
  return new Promise((resolve, reject) => {
    const properties = [];
    const errors = [];
    let successCount = 0;
    let errorCount = 0;

    fs.createReadStream(csvFilePath)
      .pipe(parse({ columns: true, skip_empty_lines: true }))
      .on('data', (row) => {
        const property = {
          name: row.PropertyName || row.name,
          type: mapPropertyType(row.PropertyType || row.type),
          address: row.Address1 || row.address,
          city: row.City || row.city,
          province: row.Province || row.province,
          postal_code: row.PostalCode || row.postal_code,
          description: row.Description || row.description,
          total_area: parseFloat(row.TotalSQM || row.total_area || 0),
        };

        // Validate property data
        const validationErrors = validatePropertyData(property);
        if (validationErrors.length > 0) {
          errors.push({ property: property.name, errors: validationErrors });
        } else {
          properties.push(property);
        }
      })
      .on('end', async () => {
        // Import validated properties into database
        for (const prop of properties) {
          try {
            await pool.query(
              `INSERT INTO properties (name, type, address, city, province, postal_code, description, total_area)
               VALUES ($1, $2, $3, $4, $5, $6, $7, $8)`,
              [prop.name, prop.type, prop.address, prop.city, prop.province, 
               prop.postal_code, prop.description, prop.total_area]
            );
            successCount++;
          } catch (error) {
            errorCount++;
            errors.push({ property: prop.name, errors: [error.message] });
          }
        }

        const result = {
          success: successCount,
          failed: errorCount,
          total: properties.length,
          errors: errors,
        };

        console.log(`Migration completed: ${successCount} succeeded, ${errorCount} failed`);
        resolve(result);
      })
      .on('error', (error) => {
        reject(error);
      });
  });
};

/**
 * Migrate tenants from CSV file
 */
export const migrateTenants = async (csvFilePath) => {
  return new Promise((resolve, reject) => {
    const tenants = [];
    const errors = [];
    let successCount = 0;
    let errorCount = 0;

    fs.createReadStream(csvFilePath)
      .pipe(parse({ columns: true, skip_empty_lines: true }))
      .on('data', (row) => {
        const tenant = {
          company_name: row.CompanyName || row.company_name,
          contact_name: row.ContactPerson || row.contact_name,
          email: row.Email || row.email,
          phone: row.Phone || row.phone,
          address: row.Address || row.address,
          city: row.City || row.city,
          province: row.Province || row.province,
          postal_code: row.PostalCode || row.postal_code,
          vat_number: row.VATNumber || row.vat_number,
          registration_number: row.RegNumber || row.registration_number,
        };

        // Validate tenant data
        const validationErrors = validateTenantData(tenant);
        if (validationErrors.length > 0) {
          errors.push({ tenant: tenant.company_name, errors: validationErrors });
        } else {
          tenants.push(tenant);
        }
      })
      .on('end', async () => {
        // Import validated tenants into database
        for (const tenant of tenants) {
          try {
            await pool.query(
              `INSERT INTO tenants (company_name, contact_name, email, phone, address, city, province, postal_code, vat_number, registration_number)
               VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)`,
              [tenant.company_name, tenant.contact_name, tenant.email, tenant.phone, 
               tenant.address, tenant.city, tenant.province, tenant.postal_code,
               tenant.vat_number, tenant.registration_number]
            );
            successCount++;
          } catch (error) {
            errorCount++;
            errors.push({ tenant: tenant.company_name, errors: [error.message] });
          }
        }

        const result = {
          success: successCount,
          failed: errorCount,
          total: tenants.length,
          errors: errors,
        };

        console.log(`Migration completed: ${successCount} succeeded, ${errorCount} failed`);
        resolve(result);
      })
      .on('error', (error) => {
        reject(error);
      });
  });
};

/**
 * Migrate leases from CSV file
 */
export const migrateLeases = async (csvFilePath) => {
  return new Promise((resolve, reject) => {
    const leases = [];
    const errors = [];
    let successCount = 0;
    let errorCount = 0;

    fs.createReadStream(csvFilePath)
      .pipe(parse({ columns: true, skip_empty_lines: true }))
      .on('data', (row) => {
        const lease = {
          tenant_id: parseInt(row.TenantID || row.tenant_id),
          unit_id: parseInt(row.UnitID || row.unit_id),
          start_date: row.StartDate || row.start_date,
          end_date: row.EndDate || row.end_date,
          monthly_rent: parseFloat(row.MonthlyRental || row.monthly_rent || 0),
          deposit: parseFloat(row.Deposit || row.deposit || 0),
          escalation_rate: parseFloat(row.EscalationRate || row.escalation_rate || 0),
          status: mapLeaseStatus(row.Status || row.status || 'active'),
          terms: row.Terms || row.terms,
        };

        // Validate lease data
        const validationErrors = validateLeaseData(lease);
        if (validationErrors.length > 0) {
          errors.push({ lease: `Tenant ${lease.tenant_id} - Unit ${lease.unit_id}`, errors: validationErrors });
        } else {
          leases.push(lease);
        }
      })
      .on('end', async () => {
        // Import validated leases into database
        for (const lease of leases) {
          try {
            await pool.query(
              `INSERT INTO leases (tenant_id, unit_id, start_date, end_date, monthly_rent, deposit, escalation_rate, status, terms)
               VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)`,
              [lease.tenant_id, lease.unit_id, lease.start_date, lease.end_date,
               lease.monthly_rent, lease.deposit, lease.escalation_rate, lease.status, lease.terms]
            );
            successCount++;
          } catch (error) {
            errorCount++;
            errors.push({ lease: `Tenant ${lease.tenant_id} - Unit ${lease.unit_id}`, errors: [error.message] });
          }
        }

        const result = {
          success: successCount,
          failed: errorCount,
          total: leases.length,
          errors: errors,
        };

        console.log(`Migration completed: ${successCount} succeeded, ${errorCount} failed`);
        resolve(result);
      })
      .on('error', (error) => {
        reject(error);
      });
  });
};

/**
 * Migrate invoices from CSV file
 */
export const migrateInvoices = async (csvFilePath) => {
  return new Promise((resolve, reject) => {
    const invoices = [];
    const errors = [];
    let successCount = 0;
    let errorCount = 0;

    fs.createReadStream(csvFilePath)
      .pipe(parse({ columns: true, skip_empty_lines: true }))
      .on('data', (row) => {
        const invoice = {
          lease_id: parseInt(row.LeaseID || row.lease_id),
          amount: parseFloat(row.Amount || row.amount || 0),
          due_date: row.DueDate || row.due_date,
          description: row.Description || row.description,
          type: mapTransactionType(row.Type || row.type || 'other'),
          status: (row.Status || row.status || 'pending').toLowerCase(),
        };

        if (!invoice.lease_id || invoice.amount <= 0) {
          errors.push({ invoice: `Lease ${invoice.lease_id}`, errors: ['Invalid lease ID or amount'] });
        } else {
          invoices.push(invoice);
        }
      })
      .on('end', async () => {
        // Import validated invoices into database
        for (const invoice of invoices) {
          try {
            await pool.query(
              `INSERT INTO invoices (lease_id, amount, due_date, description, type, status)
               VALUES ($1, $2, $3, $4, $5, $6)`,
              [invoice.lease_id, invoice.amount, invoice.due_date, invoice.description,
               invoice.type, invoice.status]
            );
            successCount++;
          } catch (error) {
            errorCount++;
            errors.push({ invoice: `Lease ${invoice.lease_id}`, errors: [error.message] });
          }
        }

        const result = {
          success: successCount,
          failed: errorCount,
          total: invoices.length,
          errors: errors,
        };

        console.log(`Migration completed: ${successCount} succeeded, ${errorCount} failed`);
        resolve(result);
      })
      .on('error', (error) => {
        reject(error);
      });
  });
};

/**
 * Get migration statistics
 */
export const getMigrationStats = async () => {
  try {
    const result = await pool.query(`
      SELECT 
        (SELECT COUNT(*) FROM properties) as properties,
        (SELECT COUNT(*) FROM tenants) as tenants,
        (SELECT COUNT(*) FROM units) as units,
        (SELECT COUNT(*) FROM leases) as leases,
        (SELECT COUNT(*) FROM invoices) as invoices,
        (SELECT COUNT(*) FROM payments) as payments
    `);
    
    return result.rows[0];
  } catch (error) {
    throw new Error(`Failed to get migration stats: ${error.message}`);
  }
};

export default {
  migrateProperties,
  migrateTenants,
  migrateLeases,
  migrateInvoices,
  getMigrationStats,
  validatePropertyData,
  validateTenantData,
  validateLeaseData,
};
