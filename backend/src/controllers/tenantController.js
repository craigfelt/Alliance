import pool from '../config/database.js';

export const getTenants = async (req, res, next) => {
  try {
    const { page = 1, limit = 10, search = '' } = req.query;
    const offset = (page - 1) * limit;

    let query = 'SELECT * FROM tenants';
    const params = [];

    if (search) {
      query += ' WHERE company_name ILIKE $1 OR contact_name ILIKE $1';
      params.push(`%${search}%`);
    }

    query += ` ORDER BY created_at DESC LIMIT $${params.length + 1} OFFSET $${params.length + 2}`;
    params.push(limit, offset);

    const result = await pool.query(query, params);
    const countResult = await pool.query(
      search ? 'SELECT COUNT(*) FROM tenants WHERE company_name ILIKE $1 OR contact_name ILIKE $1' : 'SELECT COUNT(*) FROM tenants',
      search ? [`%${search}%`] : []
    );

    res.json({
      success: true,
      data: result.rows,
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        total: parseInt(countResult.rows[0].count),
        pages: Math.ceil(countResult.rows[0].count / limit),
      },
    });
  } catch (error) {
    next(error);
  }
};

export const getTenant = async (req, res, next) => {
  try {
    const result = await pool.query('SELECT * FROM tenants WHERE id = $1', [req.params.id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ success: false, message: 'Tenant not found' });
    }
    res.json({ success: true, data: result.rows[0] });
  } catch (error) {
    next(error);
  }
};

export const createTenant = async (req, res, next) => {
  try {
    const { companyName, contactName, email, phone, address, city, province, postalCode } = req.body;
    const result = await pool.query(
      `INSERT INTO tenants (company_name, contact_name, email, phone, address, city, province, postal_code, created_at, updated_at)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, NOW(), NOW()) RETURNING *`,
      [companyName, contactName, email, phone, address, city, province, postalCode]
    );
    res.status(201).json({ success: true, data: result.rows[0] });
  } catch (error) {
    next(error);
  }
};

export const updateTenant = async (req, res, next) => {
  try {
    const { companyName, contactName, email, phone, address, city, province, postalCode } = req.body;
    const result = await pool.query(
      `UPDATE tenants SET company_name = $1, contact_name = $2, email = $3, phone = $4,
       address = $5, city = $6, province = $7, postal_code = $8, updated_at = NOW()
       WHERE id = $9 RETURNING *`,
      [companyName, contactName, email, phone, address, city, province, postalCode, req.params.id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ success: false, message: 'Tenant not found' });
    }
    res.json({ success: true, data: result.rows[0] });
  } catch (error) {
    next(error);
  }
};

export const deleteTenant = async (req, res, next) => {
  try {
    const result = await pool.query('DELETE FROM tenants WHERE id = $1 RETURNING id', [req.params.id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ success: false, message: 'Tenant not found' });
    }
    res.json({ success: true, message: 'Tenant deleted successfully' });
  } catch (error) {
    next(error);
  }
};
