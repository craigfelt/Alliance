import pool from '../config/database.js';

export const generateFinancialReport = async (req, res, next) => {
  try {
    const { startDate, endDate } = req.query;
    
    const revenue = await pool.query(
      `SELECT COALESCE(SUM(amount), 0) as total
       FROM payments
       WHERE payment_date BETWEEN $1 AND $2`,
      [startDate, endDate]
    );
    
    const expenses = await pool.query(
      `SELECT COALESCE(SUM(amount), 0) as total
       FROM expenses
       WHERE expense_date BETWEEN $1 AND $2`,
      [startDate, endDate]
    );
    
    res.json({
      success: true,
      data: {
        revenue: revenue.rows[0].total,
        expenses: expenses.rows[0].total,
        netIncome: parseFloat(revenue.rows[0].total) - parseFloat(expenses.rows[0].total),
        period: { startDate, endDate },
      },
    });
  } catch (error) {
    next(error);
  }
};

export const generateOccupancyReport = async (req, res, next) => {
  try {
    const result = await pool.query(
      `SELECT p.name as property_name,
        COUNT(u.id) as total_units,
        COUNT(u.id) FILTER (WHERE u.status = 'occupied') as occupied_units,
        COUNT(u.id) FILTER (WHERE u.status = 'vacant') as vacant_units,
        ROUND((COUNT(u.id) FILTER (WHERE u.status = 'occupied')::numeric / COUNT(u.id) * 100), 2) as occupancy_rate
       FROM properties p
       LEFT JOIN units u ON p.id = u.property_id
       GROUP BY p.id, p.name`
    );
    
    res.json({ success: true, data: result.rows });
  } catch (error) {
    next(error);
  }
};

export const generateArrearsReport = async (req, res, next) => {
  try {
    const result = await pool.query(
      `SELECT t.company_name as tenant_name, t.contact_name,
        SUM(i.amount) as total_owed,
        MIN(i.due_date) as oldest_due_date,
        COUNT(i.id) as outstanding_invoices
       FROM invoices i
       JOIN leases l ON i.lease_id = l.id
       JOIN tenants t ON l.tenant_id = t.id
       WHERE i.status IN ('pending', 'partial') AND i.due_date < CURRENT_DATE
       GROUP BY t.id, t.company_name, t.contact_name
       ORDER BY total_owed DESC`
    );
    
    res.json({ success: true, data: result.rows });
  } catch (error) {
    next(error);
  }
};
