import { useEffect, useState } from 'react';
import { dashboardService } from '../services';
import { formatCurrency } from '../utils/helpers';
import {
  Building2,
  Users,
  FileText,
  DollarSign,
  TrendingUp,
  AlertCircle,
  Wrench,
  Home,
} from 'lucide-react';

export default function Dashboard() {
  const [stats, setStats] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    loadStats();
  }, []);

  const loadStats = async () => {
    try {
      const data = await dashboardService.getStats();
      setStats(data.data);
    } catch (error) {
      console.error('Failed to load stats:', error);
    } finally {
      setLoading(false);
    }
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center h-96">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
      </div>
    );
  }

  if (!stats) {
    return (
      <div className="text-center py-12">
        <p className="text-gray-500">Failed to load dashboard data</p>
      </div>
    );
  }

  // eslint-disable-next-line no-unused-vars
  const StatCard = ({ title, value, subtitle, icon: Icon, color, trend }) => (
    <div className="bg-white rounded-xl shadow-sm border border-gray-100 p-6 hover:shadow-md transition">
      <div className="flex items-start justify-between">
        <div className="flex-1">
          <p className="text-sm font-medium text-gray-600">{title}</p>
          <p className="text-3xl font-bold text-gray-900 mt-2">{value}</p>
          {subtitle && <p className="text-sm text-gray-500 mt-1">{subtitle}</p>}
          {trend && (
            <div className="flex items-center mt-2">
              <TrendingUp className="w-4 h-4 text-green-500 mr-1" />
              <span className="text-sm text-green-600">{trend}</span>
            </div>
          )}
        </div>
        <div className={`${color} p-3 rounded-lg`}>
          <Icon className="w-6 h-6 text-white" />
        </div>
      </div>
    </div>
  );

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Dashboard</h1>
          <p className="text-gray-600 mt-1">Welcome to Alliance Property Management</p>
        </div>
      </div>

      {/* Key Metrics */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        <StatCard
          title="Total Properties"
          value={stats.overview.totalProperties}
          icon={Building2}
          color="bg-blue-500"
        />
        <StatCard
          title="Active Tenants"
          value={stats.overview.totalTenants}
          icon={Users}
          color="bg-green-500"
        />
        <StatCard
          title="Active Leases"
          value={stats.overview.activeLeases}
          icon={FileText}
          color="bg-purple-500"
        />
        <StatCard
          title="Occupancy Rate"
          value={`${stats.overview.occupancyRate}%`}
          subtitle={`${stats.overview.occupiedUnits}/${stats.overview.totalUnits} units`}
          icon={Home}
          color="bg-indigo-500"
        />
      </div>

      {/* Financial Overview */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <StatCard
          title="Monthly Revenue"
          value={formatCurrency(stats.financial.monthlyRevenue)}
          subtitle="This month"
          icon={DollarSign}
          color="bg-green-600"
        />
        <StatCard
          title="Outstanding Payments"
          value={formatCurrency(stats.financial.outstandingAmount)}
          subtitle={`${stats.financial.outstandingCount} invoices`}
          icon={AlertCircle}
          color="bg-orange-500"
        />
        <StatCard
          title="Pending Maintenance"
          value={stats.maintenance.pendingRequests}
          subtitle="Requests"
          icon={Wrench}
          color="bg-red-500"
        />
      </div>

      {/* Recent Activity */}
      <div className="bg-white rounded-xl shadow-sm border border-gray-100">
        <div className="p-6 border-b border-gray-100">
          <h2 className="text-xl font-semibold text-gray-900">Recent Payments</h2>
        </div>
        <div className="divide-y divide-gray-100">
          {stats.recentActivity.length > 0 ? (
            stats.recentActivity.map((payment) => (
              <div key={payment.id} className="p-6 hover:bg-gray-50 transition">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="font-medium text-gray-900">{payment.tenant_name}</p>
                    <p className="text-sm text-gray-500 mt-1">
                      {new Date(payment.payment_date).toLocaleDateString('en-ZA')}
                    </p>
                  </div>
                  <div className="text-right">
                    <p className="font-semibold text-green-600">
                      {formatCurrency(payment.amount)}
                    </p>
                    <p className="text-sm text-gray-500 mt-1 capitalize">
                      {payment.payment_method?.replace('_', ' ')}
                    </p>
                  </div>
                </div>
              </div>
            ))
          ) : (
            <div className="p-6 text-center text-gray-500">No recent payments</div>
          )}
        </div>
      </div>

      {/* Quick Stats Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div className="bg-white rounded-xl shadow-sm border border-gray-100 p-6">
          <h3 className="text-lg font-semibold text-gray-900 mb-4">Unit Status</h3>
          <div className="space-y-3">
            <div className="flex items-center justify-between">
              <span className="text-gray-600">Occupied Units</span>
              <span className="font-semibold text-green-600">{stats.overview.occupiedUnits}</span>
            </div>
            <div className="flex items-center justify-between">
              <span className="text-gray-600">Vacant Units</span>
              <span className="font-semibold text-orange-600">{stats.overview.vacantUnits}</span>
            </div>
            <div className="flex items-center justify-between">
              <span className="text-gray-600">Total Units</span>
              <span className="font-semibold text-gray-900">{stats.overview.totalUnits}</span>
            </div>
          </div>
        </div>

        <div className="bg-white rounded-xl shadow-sm border border-gray-100 p-6">
          <h3 className="text-lg font-semibold text-gray-900 mb-4">Financial Summary</h3>
          <div className="space-y-3">
            <div className="flex items-center justify-between">
              <span className="text-gray-600">This Month</span>
              <span className="font-semibold text-green-600">
                {formatCurrency(stats.financial.monthlyRevenue)}
              </span>
            </div>
            <div className="flex items-center justify-between">
              <span className="text-gray-600">Outstanding</span>
              <span className="font-semibold text-orange-600">
                {formatCurrency(stats.financial.outstandingAmount)}
              </span>
            </div>
            <div className="flex items-center justify-between">
              <span className="text-gray-600">Collection Rate</span>
              <span className="font-semibold text-blue-600">
                {stats.financial.monthlyRevenue > 0
                  ? ((stats.financial.monthlyRevenue / (stats.financial.monthlyRevenue + stats.financial.outstandingAmount)) * 100).toFixed(1)
                  : 0}
                %
              </span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
