import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import { AuthProvider } from './context/AuthContext';
import ProtectedRoute from './components/ProtectedRoute';
import Layout from './components/Layout';
import Login from './pages/Login';
import Dashboard from './pages/Dashboard';
import Properties from './pages/Properties';
import Tenants from './pages/Tenants';
import Leases from './pages/Leases';
import Financial from './pages/Financial';
import Maintenance from './pages/Maintenance';
import Reports from './pages/Reports';

function App() {
  return (
    <AuthProvider>
      <BrowserRouter>
        <Routes>
          <Route path="/login" element={<Login />} />
          <Route
            path="/"
            element={
              <ProtectedRoute>
                <Layout />
              </ProtectedRoute>
            }
          >
            <Route index element={<Dashboard />} />
            <Route path="properties" element={<Properties />} />
            <Route path="tenants" element={<Tenants />} />
            <Route path="leases" element={<Leases />} />
            <Route path="financial" element={<Financial />} />
            <Route path="maintenance" element={<Maintenance />} />
            <Route path="reports" element={<Reports />} />
          </Route>
          <Route path="*" element={<Navigate to="/" replace />} />
        </Routes>
      </BrowserRouter>
    </AuthProvider>
  );
}

export default App;
