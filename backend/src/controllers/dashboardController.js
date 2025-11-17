import pool from '../config/database.js';

export const getDashboardStats = async (req, res, next) => {
  try {
    // Total properties
    const properties = await pool.query('SELECT COUNT(*) as count FROM properties');
    
    // Total units and occupancy
    const units = await pool.query(
      `SELECT 
        COUNT(*) as total,
        COUNT(*) FILTER (WHERE status = 'occupied') as occupied,
        COUNT(*) FILTER (WHERE status = 'vacant') as vacant
       FROM units`
    );
    
    // Active leases
    const leases = await pool.query(
      "SELECT COUNT(*) as count FROM leases WHERE status = 'active'"
    );
    
    // Total tenants
    const tenants = await pool.query('SELECT COUNT(*) as count FROM tenants');
    
    // Revenue this month
    const revenue = await pool.query(
      `SELECT COALESCE(SUM(amount), 0) as total
       FROM payments
       WHERE DATE_TRUNC('month', payment_date) = DATE_TRUNC('month', CURRENT_DATE)`
    );
    
    // Outstanding invoices
    const outstanding = await pool.query(
      `SELECT COALESCE(SUM(amount), 0) as total, COUNT(*) as count
       FROM invoices
       WHERE status IN ('pending', 'partial')`
    );
    
    // Pending maintenance
    const maintenance = await pool.query(
      "SELECT COUNT(*) as count FROM maintenance_requests WHERE status = 'pending'"
    );
    
    // Recent activity
    const recentPayments = await pool.query(
      `SELECT p.*, t.company_name as tenant_name
       FROM payments p
       JOIN invoices i ON p.invoice_id = i.id
       JOIN leases l ON i.lease_id = l.id
       JOIN tenants t ON l.tenant_id = t.id
       ORDER BY p.payment_date DESC LIMIT 5`
    );
    
    const occupancyRate = units.rows[0].total > 0 
      ? ((units.rows[0].occupied / units.rows[0].total) * 100).toFixed(2)
      : 0;
    
    res.json({
      success: true,
      data: {
        overview: {
          totalProperties: parseInt(properties.rows[0].count),
          totalUnits: parseInt(units.rows[0].total),
          occupiedUnits: parseInt(units.rows[0].occupied),
          vacantUnits: parseInt(units.rows[0].vacant),
          occupancyRate: parseFloat(occupancyRate),
          activeLeases: parseInt(leases.rows[0].count),
          totalTenants: parseInt(tenants.rows[0].count),
        },
        financial: {
          monthlyRevenue: parseFloat(revenue.rows[0].total),
          outstandingAmount: parseFloat(outstanding.rows[0].total),
          outstandingCount: parseInt(outstanding.rows[0].count),
        },
        maintenance: {
          pendingRequests: parseInt(maintenance.rows[0].count),
        },
        recentActivity: recentPayments.rows,
      },
    });
  } catch (error) {
    next(error);
  }
};
