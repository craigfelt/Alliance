import express from 'express';
import multer from 'multer';
import {
  getStats,
  importProperties,
  importTenants,
  importLeases,
  importInvoices,
} from '../controllers/migrationController.js';
import { protect } from '../middleware/auth.js';
import { uploadLimiter, apiLimiter } from '../middleware/rateLimiter.js';

const router = express.Router();

// Configure multer for file uploads
const upload = multer({
  dest: '/tmp/uploads/',
  fileFilter: (req, file, cb) => {
    if (file.mimetype === 'text/csv' || file.originalname.endsWith('.csv')) {
      cb(null, true);
    } else {
      cb(new Error('Only CSV files are allowed'));
    }
  },
  limits: {
    fileSize: 10 * 1024 * 1024, // 10MB limit
  },
});

// Apply rate limiting to all migration routes
router.use(uploadLimiter);

// All migration routes require authentication
router.use(protect);

// Get migration statistics
router.get('/stats', getStats);

// Import endpoints
router.post('/properties', upload.single('file'), importProperties);
router.post('/tenants', upload.single('file'), importTenants);
router.post('/leases', upload.single('file'), importLeases);
router.post('/invoices', upload.single('file'), importInvoices);

export default router;
