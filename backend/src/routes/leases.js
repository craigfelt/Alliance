import express from 'express';
import {
  getLeases,
  getLease,
  createLease,
  updateLease,
  deleteLease,
  renewLease,
} from '../controllers/leaseController.js';
import { protect } from '../middleware/auth.js';

const router = express.Router();

router.use(protect);

router.route('/')
  .get(getLeases)
  .post(createLease);

router.route('/:id')
  .get(getLease)
  .put(updateLease)
  .delete(deleteLease);

router.post('/:id/renew', renewLease);

export default router;
