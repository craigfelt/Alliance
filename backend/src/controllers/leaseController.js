import pool from '../config/database.js';

export const getLeases = async (req, res, next) => {
  try {
    const result = await pool.query(
      `SELECT l.*, t.company_name as tenant_name, p.name as property_name, u.unit_number
       FROM leases l
       JOIN tenants t ON l.tenant_id = t.id
       JOIN units u ON l.unit_id = u.id
       JOIN properties p ON u.property_id = p.id
       ORDER BY l.start_date DESC`
    );
    res.json({ success: true, data: result.rows });
  } catch (error) {
    next(error);
  }
};

export const getLease = async (req, res, next) => {
  try {
    const result = await pool.query(
      `SELECT l.*, t.company_name as tenant_name, p.name as property_name, u.unit_number
       FROM leases l
       JOIN tenants t ON l.tenant_id = t.id
       JOIN units u ON l.unit_id = u.id
       JOIN properties p ON u.property_id = p.id
       WHERE l.id = $1`,
      [req.params.id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ success: false, message: 'Lease not found' });
    }
    res.json({ success: true, data: result.rows[0] });
  } catch (error) {
    next(error);
  }
};

export const createLease = async (req, res, next) => {
  try {
    const { tenantId, unitId, startDate, endDate, monthlyRent, deposit, escalationRate } = req.body;
    const result = await pool.query(
      `INSERT INTO leases (tenant_id, unit_id, start_date, end_date, monthly_rent, deposit, escalation_rate, status, created_at, updated_at)
       VALUES ($1, $2, $3, $4, $5, $6, $7, 'active', NOW(), NOW()) RETURNING *`,
      [tenantId, unitId, startDate, endDate, monthlyRent, deposit, escalationRate || 0]
    );
    
    // Update unit status to occupied
    await pool.query('UPDATE units SET status = $1 WHERE id = $2', ['occupied', unitId]);
    
    res.status(201).json({ success: true, data: result.rows[0] });
  } catch (error) {
    next(error);
  }
};

export const updateLease = async (req, res, next) => {
  try {
    const { startDate, endDate, monthlyRent, deposit, escalationRate, status } = req.body;
    const result = await pool.query(
      `UPDATE leases SET start_date = $1, end_date = $2, monthly_rent = $3, deposit = $4,
       escalation_rate = $5, status = $6, updated_at = NOW()
       WHERE id = $7 RETURNING *`,
      [startDate, endDate, monthlyRent, deposit, escalationRate, status, req.params.id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ success: false, message: 'Lease not found' });
    }
    res.json({ success: true, data: result.rows[0] });
  } catch (error) {
    next(error);
  }
};

export const deleteLease = async (req, res, next) => {
  try {
    const lease = await pool.query('SELECT unit_id FROM leases WHERE id = $1', [req.params.id]);
    if (lease.rows.length === 0) {
      return res.status(404).json({ success: false, message: 'Lease not found' });
    }
    
    await pool.query('DELETE FROM leases WHERE id = $1', [req.params.id]);
    await pool.query('UPDATE units SET status = $1 WHERE id = $2', ['vacant', lease.rows[0].unit_id]);
    
    res.json({ success: true, message: 'Lease deleted successfully' });
  } catch (error) {
    next(error);
  }
};

export const renewLease = async (req, res, next) => {
  try {
    const { newEndDate, newMonthlyRent } = req.body;
    const result = await pool.query(
      'UPDATE leases SET end_date = $1, monthly_rent = $2, updated_at = NOW() WHERE id = $3 RETURNING *',
      [newEndDate, newMonthlyRent, req.params.id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ success: false, message: 'Lease not found' });
    }
    res.json({ success: true, data: result.rows[0] });
  } catch (error) {
    next(error);
  }
};
