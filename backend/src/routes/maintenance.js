import express from 'express';
import {
  getMaintenanceRequests,
  createMaintenanceRequest,
  updateMaintenanceRequest,
} from '../controllers/maintenanceController.js';
import { protect } from '../middleware/auth.js';

const router = express.Router();

router.use(protect);

router.route('/')
  .get(getMaintenanceRequests)
  .post(createMaintenanceRequest);

router.put('/:id', updateMaintenanceRequest);

export default router;
