import api from './api';

export const authService = {
  login: async (email, password) => {
    const response = await api.post('/auth/login', { email, password });
    if (response.data.token) {
      localStorage.setItem('token', response.data.token);
    }
    return response.data;
  },

  register: async (userData) => {
    const response = await api.post('/auth/register', userData);
    if (response.data.token) {
      localStorage.setItem('token', response.data.token);
    }
    return response.data;
  },

  logout: () => {
    localStorage.removeItem('token');
  },

  getCurrentUser: async () => {
    const response = await api.get('/auth/me');
    return response.data;
  },
};

export const propertyService = {
  getAll: async (params) => {
    const response = await api.get('/properties', { params });
    return response.data;
  },

  getOne: async (id) => {
    const response = await api.get(`/properties/${id}`);
    return response.data;
  },

  create: async (data) => {
    const response = await api.post('/properties', data);
    return response.data;
  },

  update: async (id, data) => {
    const response = await api.put(`/properties/${id}`, data);
    return response.data;
  },

  delete: async (id) => {
    const response = await api.delete(`/properties/${id}`);
    return response.data;
  },
};

export const tenantService = {
  getAll: async (params) => {
    const response = await api.get('/tenants', { params });
    return response.data;
  },

  getOne: async (id) => {
    const response = await api.get(`/tenants/${id}`);
    return response.data;
  },

  create: async (data) => {
    const response = await api.post('/tenants', data);
    return response.data;
  },

  update: async (id, data) => {
    const response = await api.put(`/tenants/${id}`, data);
    return response.data;
  },

  delete: async (id) => {
    const response = await api.delete(`/tenants/${id}`);
    return response.data;
  },
};

export const leaseService = {
  getAll: async () => {
    const response = await api.get('/leases');
    return response.data;
  },

  getOne: async (id) => {
    const response = await api.get(`/leases/${id}`);
    return response.data;
  },

  create: async (data) => {
    const response = await api.post('/leases', data);
    return response.data;
  },

  update: async (id, data) => {
    const response = await api.put(`/leases/${id}`, data);
    return response.data;
  },

  delete: async (id) => {
    const response = await api.delete(`/leases/${id}`);
    return response.data;
  },

  renew: async (id, data) => {
    const response = await api.post(`/leases/${id}/renew`, data);
    return response.data;
  },
};

export const financialService = {
  getInvoices: async () => {
    const response = await api.get('/financial/invoices');
    return response.data;
  },

  createInvoice: async (data) => {
    const response = await api.post('/financial/invoices', data);
    return response.data;
  },

  getPayments: async () => {
    const response = await api.get('/financial/payments');
    return response.data;
  },

  recordPayment: async (data) => {
    const response = await api.post('/financial/payments', data);
    return response.data;
  },

  getTrustAccounts: async () => {
    const response = await api.get('/financial/trust-accounts');
    return response.data;
  },
};

export const maintenanceService = {
  getAll: async () => {
    const response = await api.get('/maintenance');
    return response.data;
  },

  create: async (data) => {
    const response = await api.post('/maintenance', data);
    return response.data;
  },

  update: async (id, data) => {
    const response = await api.put(`/maintenance/${id}`, data);
    return response.data;
  },
};

export const dashboardService = {
  getStats: async () => {
    const response = await api.get('/dashboard/stats');
    return response.data;
  },
};

export const reportService = {
  getFinancialReport: async (params) => {
    const response = await api.get('/reports/financial', { params });
    return response.data;
  },

  getOccupancyReport: async () => {
    const response = await api.get('/reports/occupancy');
    return response.data;
  },

  getArrearsReport: async () => {
    const response = await api.get('/reports/arrears');
    return response.data;
  },
};
