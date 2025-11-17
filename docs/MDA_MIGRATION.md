# MDA Property Manager Data Migration Guide

This guide explains how to migrate data from MDA Property Manager to the Alliance Property Management System.

## Overview

The migration process involves:
1. Exporting data from MDA
2. Mapping MDA data structure to Alliance schema
3. Transforming and validating data
4. Importing into Alliance system

## Step 1: Export from MDA

### Option A: SQL Server Export
If MDA uses SQL Server, you can export using SQL Server Management Studio:

```sql
-- Export Properties
SELECT * FROM Properties
-- Save as CSV or SQL INSERT statements

-- Export Tenants
SELECT * FROM Tenants

-- Export Leases
SELECT * FROM Leases

-- Export Financial Transactions
SELECT * FROM Transactions
```

### Option B: Use MDA Export Tools
MDA Property Manager may have built-in export functionality. Check:
- File > Export
- Tools > Data Export
- Reports > Export to Excel/CSV

## Step 2: Data Mapping

### Properties
| MDA Field | Alliance Field | Notes |
|-----------|---------------|-------|
| PropertyID | id | Auto-generated in Alliance |
| PropertyName | name | Direct mapping |
| PropertyType | type | Map to: office, retail, industrial, warehouse, mixed-use |
| Address1 | address | Combine address fields |
| City | city | Direct mapping |
| Province | province | Direct mapping |
| PostalCode | postal_code | Direct mapping |
| Description | description | Direct mapping |
| TotalSQM | total_area | Area in square meters |

### Tenants
| MDA Field | Alliance Field | Notes |
|-----------|---------------|-------|
| TenantID | id | Auto-generated |
| CompanyName | company_name | Direct mapping |
| ContactPerson | contact_name | Direct mapping |
| Email | email | Direct mapping |
| Phone | phone | Format: 031-XXX-XXXX |
| VATNumber | vat_number | South African VAT format |
| RegNumber | registration_number | Company registration |

### Leases
| MDA Field | Alliance Field | Notes |
|-----------|---------------|-------|
| LeaseID | id | Auto-generated |
| TenantID | tenant_id | Foreign key |
| UnitID | unit_id | Must create units first |
| StartDate | start_date | Format: YYYY-MM-DD |
| EndDate | end_date | Format: YYYY-MM-DD |
| MonthlyRental | monthly_rent | Decimal(10,2) |
| Deposit | deposit | Decimal(10,2) |
| EscalationRate | escalation_rate | Percentage (e.g., 8.0) |
| Status | status | Map to: active, expired, terminated, renewed |

### Financial Transactions
| MDA Field | Alliance Field | Notes |
|-----------|---------------|-------|
| TransactionID | invoice_id or payment_id | Depends on type |
| LeaseID | lease_id | Foreign key |
| Amount | amount | Decimal(10,2) |
| TransactionDate | due_date or payment_date | Depends on type |
| Type | type | Map to: rent, utilities, maintenance, other |
| Status | status | Map to: pending, paid, partial, overdue |

## Step 3: Data Transformation Scripts

### Example Node.js Migration Script

```javascript
// backend/src/services/migration.js
import pool from '../config/database.js';
import fs from 'fs';
import csv from 'csv-parser';

export const migrateProperties = async (csvFilePath) => {
  const properties = [];
  
  // Read CSV file
  fs.createReadStream(csvFilePath)
    .pipe(csv())
    .on('data', (row) => {
      properties.push({
        name: row.PropertyName,
        type: mapPropertyType(row.PropertyType),
        address: row.Address1,
        city: row.City,
        province: row.Province,
        postal_code: row.PostalCode,
        description: row.Description,
        total_area: parseFloat(row.TotalSQM),
      });
    })
    .on('end', async () => {
      // Import into database
      for (const prop of properties) {
        try {
          await pool.query(
            `INSERT INTO properties (name, type, address, city, province, postal_code, description, total_area)
             VALUES ($1, $2, $3, $4, $5, $6, $7, $8)`,
            [prop.name, prop.type, prop.address, prop.city, prop.province, 
             prop.postal_code, prop.description, prop.total_area]
          );
        } catch (error) {
          console.error(`Error importing property ${prop.name}:`, error);
        }
      }
      console.log(`Imported ${properties.length} properties`);
    });
};

const mapPropertyType = (mdaType) => {
  const typeMap = {
    'Office': 'office',
    'Retail': 'retail',
    'Industrial': 'industrial',
    'Warehouse': 'warehouse',
    'Mixed Use': 'mixed-use',
  };
  return typeMap[mdaType] || 'office';
};
```

## Step 4: Validation Checks

Before importing, validate:
- All required fields are present
- Data types are correct
- Foreign key relationships exist
- No duplicate entries
- Date formats are valid
- Currency amounts are positive

### Validation Script Example

```javascript
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
```

## Step 5: Import Process

### Recommended Import Order

1. **Users** - Create admin and manager accounts first
2. **Properties** - Import all properties
3. **Units** - Create units within properties
4. **Tenants** - Import all tenant data
5. **Leases** - Create lease agreements
6. **Invoices** - Import billing data
7. **Payments** - Import payment history
8. **Trust Accounts** - Import trust account transactions
9. **Maintenance** - Import maintenance history

### Using the API

```bash
# Example: Import properties via API
curl -X POST http://localhost:5000/api/migration/properties \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d @properties.json
```

## Step 6: Post-Migration Verification

After migration, verify:
- [ ] All properties imported correctly
- [ ] All tenants exist
- [ ] All leases are assigned
- [ ] Financial balances match
- [ ] Trust account balances are correct
- [ ] No orphaned records
- [ ] All relationships intact

### Verification Queries

```sql
-- Check property count
SELECT COUNT(*) FROM properties;

-- Check tenant-lease relationships
SELECT t.company_name, COUNT(l.id) as lease_count
FROM tenants t
LEFT JOIN leases l ON t.id = l.tenant_id
GROUP BY t.id, t.company_name;

-- Check financial totals
SELECT 
  SUM(amount) as total_invoiced,
  SUM(CASE WHEN status = 'paid' THEN amount ELSE 0 END) as total_paid
FROM invoices;
```

## Troubleshooting

### Common Issues

1. **Duplicate Keys**: Ensure no duplicate IDs in source data
2. **Missing Foreign Keys**: Import parent tables before child tables
3. **Date Format Issues**: Convert all dates to ISO format (YYYY-MM-DD)
4. **Currency Precision**: Use DECIMAL(10,2) for all amounts
5. **Character Encoding**: Ensure UTF-8 encoding for special characters

### Rollback Plan

Before starting migration:
```sql
-- Create backup
pg_dump alliance_property > backup_before_migration.sql

-- If needed to rollback
dropdb alliance_property
createdb alliance_property
psql alliance_property < backup_before_migration.sql
```

## Support

For migration assistance:
- Check logs in `/backend/logs/migration.log`
- Contact: migration-support@alliance.co.za
- Schedule migration with support team for large datasets

## Best Practices

- Test migration on staging environment first
- Keep backup of MDA data
- Document any custom mappings
- Verify data integrity at each step
- Maintain audit trail of all migrations
- Schedule migration during off-hours

---

Last Updated: November 2024
