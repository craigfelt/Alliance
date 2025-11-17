import pool from '../config/database.js';

export const getMaintenanceRequests = async (req, res, next) => {
  try {
    const result = await pool.query(
      `SELECT m.*, p.name as property_name, u.unit_number, t.company_name as tenant_name
       FROM maintenance_requests m
       LEFT JOIN units u ON m.unit_id = u.id
       LEFT JOIN properties p ON u.property_id = p.id
       LEFT JOIN leases l ON u.id = l.unit_id AND l.status = 'active'
       LEFT JOIN tenants t ON l.tenant_id = t.id
       ORDER BY m.created_at DESC`
    );
    res.json({ success: true, data: result.rows });
  } catch (error) {
    next(error);
  }
};

export const createMaintenanceRequest = async (req, res, next) => {
  try {
    const { unitId, description, priority, category } = req.body;
    const result = await pool.query(
      `INSERT INTO maintenance_requests (unit_id, description, priority, category, status, created_at, updated_at)
       VALUES ($1, $2, $3, $4, 'pending', NOW(), NOW()) RETURNING *`,
      [unitId, description, priority, category]
    );
    res.status(201).json({ success: true, data: result.rows[0] });
  } catch (error) {
    next(error);
  }
};

export const updateMaintenanceRequest = async (req, res, next) => {
  try {
    const { status, assignedTo, completedDate, notes } = req.body;
    const result = await pool.query(
      `UPDATE maintenance_requests 
       SET status = $1, assigned_to = $2, completed_date = $3, notes = $4, updated_at = NOW()
       WHERE id = $5 RETURNING *`,
      [status, assignedTo, completedDate, notes, req.params.id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ success: false, message: 'Maintenance request not found' });
    }
    res.json({ success: true, data: result.rows[0] });
  } catch (error) {
    next(error);
  }
};
