import express from 'express';
import {
  getInvoices,
  createInvoice,
  recordPayment,
  getPayments,
  getTrustAccounts,
} from '../controllers/financialController.js';
import { protect } from '../middleware/auth.js';

const router = express.Router();

router.use(protect);

router.get('/invoices', getInvoices);
router.post('/invoices', createInvoice);
router.get('/payments', getPayments);
router.post('/payments', recordPayment);
router.get('/trust-accounts', getTrustAccounts);

export default router;
