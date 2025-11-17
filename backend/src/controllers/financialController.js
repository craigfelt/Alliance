import pool from '../config/database.js';

export const getInvoices = async (req, res, next) => {
  try {
    const result = await pool.query(
      `SELECT i.*, t.company_name as tenant_name, l.unit_id
       FROM invoices i
       JOIN leases l ON i.lease_id = l.id
       JOIN tenants t ON l.tenant_id = t.id
       ORDER BY i.due_date DESC`
    );
    res.json({ success: true, data: result.rows });
  } catch (error) {
    next(error);
  }
};

export const createInvoice = async (req, res, next) => {
  try {
    const { leaseId, amount, dueDate, description, type } = req.body;
    const result = await pool.query(
      `INSERT INTO invoices (lease_id, amount, due_date, description, type, status, created_at)
       VALUES ($1, $2, $3, $4, $5, 'pending', NOW()) RETURNING *`,
      [leaseId, amount, dueDate, description, type]
    );
    res.status(201).json({ success: true, data: result.rows[0] });
  } catch (error) {
    next(error);
  }
};

export const getPayments = async (req, res, next) => {
  try {
    const result = await pool.query(
      `SELECT p.*, i.lease_id, t.company_name as tenant_name
       FROM payments p
       JOIN invoices i ON p.invoice_id = i.id
       JOIN leases l ON i.lease_id = l.id
       JOIN tenants t ON l.tenant_id = t.id
       ORDER BY p.payment_date DESC`
    );
    res.json({ success: true, data: result.rows });
  } catch (error) {
    next(error);
  }
};

export const recordPayment = async (req, res, next) => {
  try {
    const { invoiceId, amount, paymentDate, paymentMethod, reference } = req.body;
    
    const result = await pool.query(
      `INSERT INTO payments (invoice_id, amount, payment_date, payment_method, reference, created_at)
       VALUES ($1, $2, $3, $4, $5, NOW()) RETURNING *`,
      [invoiceId, amount, paymentDate, paymentMethod, reference]
    );
    
    // Update invoice status if fully paid
    const invoice = await pool.query('SELECT amount FROM invoices WHERE id = $1', [invoiceId]);
    const totalPaid = await pool.query(
      'SELECT COALESCE(SUM(amount), 0) as total FROM payments WHERE invoice_id = $1',
      [invoiceId]
    );
    
    if (parseFloat(totalPaid.rows[0].total) + parseFloat(amount) >= parseFloat(invoice.rows[0].amount)) {
      await pool.query('UPDATE invoices SET status = $1 WHERE id = $2', ['paid', invoiceId]);
    } else {
      await pool.query('UPDATE invoices SET status = $1 WHERE id = $2', ['partial', invoiceId]);
    }
    
    res.status(201).json({ success: true, data: result.rows[0] });
  } catch (error) {
    next(error);
  }
};

export const getTrustAccounts = async (req, res, next) => {
  try {
    const result = await pool.query(
      `SELECT * FROM trust_accounts ORDER BY transaction_date DESC`
    );
    res.json({ success: true, data: result.rows });
  } catch (error) {
    next(error);
  }
};
