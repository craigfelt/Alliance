import pool from '../config/database.js';

// @desc    Get all properties
// @route   GET /api/properties
// @access  Private
export const getProperties = async (req, res, next) => {
  try {
    const { page = 1, limit = 10, search = '' } = req.query;
    const offset = (page - 1) * limit;

    let query = `
      SELECT p.*, 
        COUNT(u.id) FILTER (WHERE u.status = 'occupied') as occupied_units,
        COUNT(u.id) as total_units
      FROM properties p
      LEFT JOIN units u ON u.property_id = p.id
    `;

    const params = [];
    if (search) {
      query += ` WHERE p.name ILIKE $1 OR p.address ILIKE $1`;
      params.push(`%${search}%`);
    }

    query += ` GROUP BY p.id ORDER BY p.created_at DESC LIMIT $${params.length + 1} OFFSET $${params.length + 2}`;
    params.push(limit, offset);

    const result = await pool.query(query, params);

    // Get total count
    const countQuery = search 
      ? 'SELECT COUNT(*) FROM properties WHERE name ILIKE $1 OR address ILIKE $1'
      : 'SELECT COUNT(*) FROM properties';
    const countParams = search ? [`%${search}%`] : [];
    const countResult = await pool.query(countQuery, countParams);
    const total = parseInt(countResult.rows[0].count);

    res.json({
      success: true,
      data: result.rows,
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        total,
        pages: Math.ceil(total / limit),
      },
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Get single property
// @route   GET /api/properties/:id
// @access  Private
export const getProperty = async (req, res, next) => {
  try {
    const { id } = req.params;

    const result = await pool.query(
      `SELECT p.*, 
        COUNT(u.id) FILTER (WHERE u.status = 'occupied') as occupied_units,
        COUNT(u.id) as total_units
       FROM properties p
       LEFT JOIN units u ON u.property_id = p.id
       WHERE p.id = $1
       GROUP BY p.id`,
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Property not found',
      });
    }

    res.json({
      success: true,
      data: result.rows[0],
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Create new property
// @route   POST /api/properties
// @access  Private
export const createProperty = async (req, res, next) => {
  try {
    const {
      name,
      type,
      address,
      city,
      province,
      postalCode,
      description,
      totalArea,
    } = req.body;

    const result = await pool.query(
      `INSERT INTO properties (name, type, address, city, province, postal_code, description, total_area, created_at, updated_at)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, NOW(), NOW())
       RETURNING *`,
      [name, type, address, city, province, postalCode, description, totalArea]
    );

    res.status(201).json({
      success: true,
      data: result.rows[0],
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Update property
// @route   PUT /api/properties/:id
// @access  Private
export const updateProperty = async (req, res, next) => {
  try {
    const { id } = req.params;
    const {
      name,
      type,
      address,
      city,
      province,
      postalCode,
      description,
      totalArea,
    } = req.body;

    const result = await pool.query(
      `UPDATE properties 
       SET name = $1, type = $2, address = $3, city = $4, province = $5, 
           postal_code = $6, description = $7, total_area = $8, updated_at = NOW()
       WHERE id = $9
       RETURNING *`,
      [name, type, address, city, province, postalCode, description, totalArea, id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Property not found',
      });
    }

    res.json({
      success: true,
      data: result.rows[0],
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Delete property
// @route   DELETE /api/properties/:id
// @access  Private
export const deleteProperty = async (req, res, next) => {
  try {
    const { id } = req.params;

    const result = await pool.query(
      'DELETE FROM properties WHERE id = $1 RETURNING id',
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Property not found',
      });
    }

    res.json({
      success: true,
      message: 'Property deleted successfully',
    });
  } catch (error) {
    next(error);
  }
};
