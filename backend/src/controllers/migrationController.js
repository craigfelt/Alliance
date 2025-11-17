import {
  migrateProperties,
  migrateTenants,
  migrateLeases,
  migrateInvoices,
  getMigrationStats,
} from '../services/migration.js';
import fs from 'fs';
import path from 'path';

// @desc    Get migration statistics
// @route   GET /api/migration/stats
// @access  Private (Admin only)
export const getStats = async (req, res, next) => {
  try {
    const stats = await getMigrationStats();
    res.json({
      success: true,
      data: stats,
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Migrate properties from CSV
// @route   POST /api/migration/properties
// @access  Private (Admin only)
export const importProperties = async (req, res, next) => {
  try {
    if (!req.file) {
      return res.status(400).json({
        success: false,
        error: 'Please upload a CSV file',
      });
    }

    const result = await migrateProperties(req.file.path);

    // Clean up uploaded file
    fs.unlinkSync(req.file.path);

    res.json({
      success: true,
      message: 'Properties migration completed',
      data: result,
    });
  } catch (error) {
    // Clean up uploaded file on error
    if (req.file && fs.existsSync(req.file.path)) {
      fs.unlinkSync(req.file.path);
    }
    next(error);
  }
};

// @desc    Migrate tenants from CSV
// @route   POST /api/migration/tenants
// @access  Private (Admin only)
export const importTenants = async (req, res, next) => {
  try {
    if (!req.file) {
      return res.status(400).json({
        success: false,
        error: 'Please upload a CSV file',
      });
    }

    const result = await migrateTenants(req.file.path);

    // Clean up uploaded file
    fs.unlinkSync(req.file.path);

    res.json({
      success: true,
      message: 'Tenants migration completed',
      data: result,
    });
  } catch (error) {
    // Clean up uploaded file on error
    if (req.file && fs.existsSync(req.file.path)) {
      fs.unlinkSync(req.file.path);
    }
    next(error);
  }
};

// @desc    Migrate leases from CSV
// @route   POST /api/migration/leases
// @access  Private (Admin only)
export const importLeases = async (req, res, next) => {
  try {
    if (!req.file) {
      return res.status(400).json({
        success: false,
        error: 'Please upload a CSV file',
      });
    }

    const result = await migrateLeases(req.file.path);

    // Clean up uploaded file
    fs.unlinkSync(req.file.path);

    res.json({
      success: true,
      message: 'Leases migration completed',
      data: result,
    });
  } catch (error) {
    // Clean up uploaded file on error
    if (req.file && fs.existsSync(req.file.path)) {
      fs.unlinkSync(req.file.path);
    }
    next(error);
  }
};

// @desc    Migrate invoices from CSV
// @route   POST /api/migration/invoices
// @access  Private (Admin only)
export const importInvoices = async (req, res, next) => {
  try {
    if (!req.file) {
      return res.status(400).json({
        success: false,
        error: 'Please upload a CSV file',
      });
    }

    const result = await migrateInvoices(req.file.path);

    // Clean up uploaded file
    fs.unlinkSync(req.file.path);

    res.json({
      success: true,
      message: 'Invoices migration completed',
      data: result,
    });
  } catch (error) {
    // Clean up uploaded file on error
    if (req.file && fs.existsSync(req.file.path)) {
      fs.unlinkSync(req.file.path);
    }
    next(error);
  }
};
