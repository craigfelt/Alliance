import express from 'express';
import {
  generateFinancialReport,
  generateOccupancyReport,
  generateArrearsReport,
} from '../controllers/reportController.js';
import { protect } from '../middleware/auth.js';

const router = express.Router();

router.use(protect);

router.get('/financial', generateFinancialReport);
router.get('/occupancy', generateOccupancyReport);
router.get('/arrears', generateArrearsReport);

export default router;
