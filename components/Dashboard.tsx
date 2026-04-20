
import React, { useState, useEffect } from 'react';
import { dashboardService, DashboardStats } from '../services/dashboardService';
import { orderService } from '../services/orderService';
import { customerService } from '../services/customerService';
import { STATUS_LABEL_MAP } from '../constants';

import {
  LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer,
  PieChart, Pie, Cell, BarChart, Bar, Sector
} from 'recharts';

const COLORS = {
  primary: '#00796b',
  secondary: '#005a4f',
  danger: '#F44336',
  design: '#0288D1',
  largeFormat: '#6A1B9A',
  success: '#4CAF50',
  warning: '#f57c00',
  info: '#2196F3',
  purple: '#8884d8',
  pink: '#e91e63',
  orange: '#FF9800'
};

const PIE_COLORS = ['#0088FE', '#00C49F', '#FFBB28', '#FF8042', '#8884d8', '#e91e63', '#607d8b'];

const Dashboard: React.FC = () => {
  const [stats, setStats] = useState<DashboardStats | null>(null);
  const [debtStats, setDebtStats] = useState({ totalAmount: 0, count: 0 });
  const [collectionStats, setCollectionStats] = useState({ totalAmount: 0, count: 0 });
  const [loading, setLoading] = useState(false);
  const [period, setPeriod] = useState<'today' | 'month' | 'month_picker' | 'custom'>('month');
  const [startDate, setStartDate] = useState('');
  const [endDate, setEndDate] = useState('');
  const [activeIndex, setActiveIndex] = useState(0);
  const [atRiskVIP, setAtRiskVIP] = useState<{ id: string; name: string; code: string; phone?: string; total_revenue: number; total_orders: number; days_since_last_order: number | null }[]>([]);
  const [showNewCustomers, setShowNewCustomers] = useState(false);

  const loadStats = async () => {
    setLoading(true);
    try {
      // Map UI period to Service period
      const servicePeriod = period === 'month_picker' ? 'custom' : period;
      const data = await dashboardService.getStats(servicePeriod, startDate, endDate);
      setStats(data);
    } catch (error) {
      console.error("Failed to load dashboard stats", error);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    // Initial load or when period changes (except custom/month_picker which needs manual trigger or specific handling)
    if (period !== 'custom' && period !== 'month_picker') {
      loadStats();
    }
  }, [period]);

  // Fetch Debt & Collection Overview (Always Global/All Time)
  useEffect(() => {
    const fetchOutstanding = async () => {
      try {
        const debtOrders = await orderService.getDebtOrders();
        if (debtOrders) {
          const total = debtOrders.reduce((sum: number, o: any) => sum + (parseFloat(o.remaining_amount) || 0), 0);
          setDebtStats({ totalAmount: total, count: debtOrders.length });
        }

        const collectionOrders = await orderService.getCollectionOrders();
        if (collectionOrders) {
          const total = collectionOrders.reduce((sum: number, o: any) => sum + (parseFloat(o.remaining_amount) || 0), 0);
          setCollectionStats({ totalAmount: total, count: collectionOrders.length });
        }
      } catch (error) {
        console.error("Failed to load outstanding stats", error);
      }
    };
    fetchOutstanding();
  }, []);

  // Fetch At-Risk VIP Customers (global, once on mount)
  useEffect(() => {
    const fetchAtRisk = async () => {
      try {
        const data = await customerService.getCustomerReportData();
        const risky = data
          .filter(c => c.total_revenue >= 10_000_000 && c.days_since_last_order !== null && c.days_since_last_order >= 30)
          .sort((a, b) => {
            const aDays = a.days_since_last_order || 0;
            const bDays = b.days_since_last_order || 0;
            const aTier = aDays >= 90 ? 3 : aDays >= 60 ? 2 : 1;
            const bTier = bDays >= 90 ? 3 : bDays >= 60 ? 2 : 1;
            if (bTier !== aTier) return bTier - aTier;
            return b.total_revenue - a.total_revenue;
          })
          .slice(0, 5);
        setAtRiskVIP(risky);
      } catch (err) {
        console.error('Failed to fetch at-risk VIP', err);
      }
    };
    fetchAtRisk();
  }, []);

  const handleMonthChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const val = e.target.value; // YYYY-MM
    if (!val) return;

    const [year, month] = val.split('-').map(Number);
    const start = new Date(year, month - 1, 1);
    const end = new Date(year, month, 0); // Last day of month

    // Format to YYYY-MM-DD for local input state (though service might handle ISO, let's correspond)
    // Actually dashboardService expects string inputs, typically YYYY-MM-DD
    const startStr = start.toLocaleDateString('en-CA'); // YYYY-MM-DD
    const endStr = end.toLocaleDateString('en-CA');

    setStartDate(startStr);
    setEndDate(endStr);

    // We can trigger load immediately for month picker
    // Need to use the values directly because state updates are async
    setLoading(true);
    dashboardService.getStats('custom', startStr, endStr)
      .then(data => setStats(data))
      .catch(err => console.error(err))
      .finally(() => setLoading(false));
  };

  const handleCustomSearch = () => {
    if (startDate && endDate) {
      loadStats();
    }
  };

  const onPieEnter = (_: any, index: number) => {
    setActiveIndex(index);
  };

  const renderActiveShape = (props: any) => {
    const RADIAN = Math.PI / 180;
    const { cx, cy, midAngle, innerRadius, outerRadius, startAngle, endAngle, fill, payload, percent, value } = props;
    const sin = Math.sin(-RADIAN * midAngle);
    const cos = Math.cos(-RADIAN * midAngle);
    const sx = cx + (outerRadius + 10) * cos;
    const sy = cy + (outerRadius + 10) * sin;
    const mx = cx + (outerRadius + 30) * cos;
    const my = cy + (outerRadius + 30) * sin;
    const ex = mx + (cos >= 0 ? 1 : -1) * 22;
    const ey = my;
    const textAnchor = cos >= 0 ? 'start' : 'end';

    return (
      <g>
        <text x={cx} y={cy} dy={8} textAnchor="middle" fill={fill}>
          {payload.name}
        </text>
        <Sector
          cx={cx}
          cy={cy}
          innerRadius={innerRadius}
          outerRadius={outerRadius}
          startAngle={startAngle}
          endAngle={endAngle}
          fill={fill}
        />
        <Sector
          cx={cx}
          cy={cy}
          startAngle={startAngle}
          endAngle={endAngle}
          innerRadius={outerRadius + 6}
          outerRadius={outerRadius + 10}
          fill={fill}
        />
        <path d={`M${sx},${sy}L${mx},${my}L${ex},${ey}`} stroke={fill} fill="none" />
        <circle cx={ex} cy={ey} r={2} fill={fill} stroke="none" />
        <text x={ex + (cos >= 0 ? 1 : -1) * 12} y={ey} textAnchor={textAnchor} fill="#333">{`${value}`}</text>
        <text x={ex + (cos >= 0 ? 1 : -1) * 12} y={ey} dy={18} textAnchor={textAnchor} fill="#999">
          {`(Rate ${(percent * 100).toFixed(2)}%)`}
        </text>
      </g>
    );
  };

  // Non-blocking loader: show stale data while fetching
  // if (loading && !stats) return <div className="p-8 text-center text-gray-500"><i className="fa-solid fa-spinner fa-spin text-3xl"></i> Đang tải dữ liệu...</div>;

  const metrics = stats?.metrics;

  // Helper to format currency
  const fmt = (n?: number) => n ? n.toLocaleString('vi-VN') : '0';

  return (
    <div className="pb-10">
      {/* 1. Header Controls */}
      <div className="flex flex-wrap items-center justify-between mb-6 bg-white p-4 rounded-lg shadow-sm">
        <h2 className="text-xl font-bold text-gray-800"><i className="fa-solid fa-chart-line mr-2 text-teal-600"></i>Tổng Quan</h2>

        <div className="flex items-center gap-4">
          <div className="bg-gray-100 p-1 rounded-lg flex text-sm font-medium">
            <button
              onClick={() => setPeriod('today')}
              className={`px-4 py-1.5 rounded-md transition-all ${period === 'today' ? 'bg-white text-teal-700 shadow-sm' : 'text-gray-500 hover:bg-gray-200'}`}
            >
              Hôm nay
            </button>
            <button
              onClick={() => setPeriod('month')}
              className={`px-4 py-1.5 rounded-md transition-all ${period === 'month' ? 'bg-white text-teal-700 shadow-sm' : 'text-gray-500 hover:bg-gray-200'}`}
            >
              Tháng này
            </button>
            <button
              onClick={() => setPeriod('custom')}
              className={`px-4 py-1.5 rounded-md transition-all ${period === 'custom' ? 'bg-white text-teal-700 shadow-sm' : 'text-gray-500 hover:bg-gray-200'}`}
            >
              Tùy chọn
            </button>
            <button
              onClick={() => setPeriod('month_picker')}
              className={`px-4 py-1.5 rounded-md transition-all ${period === 'month_picker' ? 'bg-white text-teal-700 shadow-sm' : 'text-gray-500 hover:bg-gray-200'}`}
            >
              Chọn tháng
            </button>
          </div>

          {period === 'month_picker' && (
            <div className="flex items-center gap-2 animate-fade-in-down">
              <span className="text-sm text-gray-600">Tháng:</span>
              <input
                type="month"
                onChange={handleMonthChange}
                className="border border-gray-300 rounded px-2 py-1.5 text-sm"
              />
            </div>
          )}

          {period === 'custom' && (
            <div className="flex items-center gap-2 animate-fade-in-down">
              <input
                type="date"
                value={startDate}
                onChange={(e) => setStartDate(e.target.value)}
                className="border border-gray-300 rounded px-2 py-1.5 text-sm"
              />
              <span className="text-gray-400">-</span>
              <input
                type="date"
                value={endDate}
                onChange={(e) => setEndDate(e.target.value)}
                className="border border-gray-300 rounded px-2 py-1.5 text-sm"
              />
              <button
                onClick={handleCustomSearch}
                className="bg-teal-600 text-white px-3 py-1.5 rounded text-sm hover:bg-teal-700"
              >
                <i className="fa-solid fa-eye mr-1"></i> Xem
              </button>
            </div>
          )}
        </div>
      </div>

      {/* 2. Metrics Cards */}
      {metrics && (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4 mb-6">
          <StatsCard
            title="Tổng Công Nợ"
            value={fmt(debtStats.totalAmount) + ' đ'}
            icon="fa-file-invoice-dollar"
            color="text-red-600"
            bg="bg-red-50"
            desc={`${debtStats.count} hóa đơn`}
          />
          <StatsCard
            title="Tổng Cần Thu"
            value={fmt(collectionStats.totalAmount) + ' đ'}
            icon="fa-hand-holding-dollar"
            color="text-orange-600"
            bg="bg-orange-50"
            desc={`${collectionStats.count} đơn hàng`}
          />
          <StatsCard
            title="Đơn hàng"
            value={metrics.ordersCount}
            icon="fa-box-open"
            color="text-blue-600"
            bg="bg-blue-50"
          />
          <StatsCard
            title="Doanh thu (VAT)"
            value={fmt(metrics.revenueWithVAT) + ' đ'}
            icon="fa-dollar-sign"
            color="text-green-600"
            bg="bg-green-50"
          />
          <StatsCard
            title="Doanh thu (Chưa VAT)"
            value={fmt(metrics.revenueNoVAT) + ' đ'}
            icon="fa-file-invoice"
            color="text-emerald-600"
            bg="bg-emerald-50"
          />
          <StatsCard
            title="DS Hoàn Thành (Chưa VAT)"
            value={fmt(metrics.completedRevenueNoVAT) + ' đ'}
            icon="fa-check-double"
            color="text-teal-600"
            bg="bg-teal-50"
            desc="Dùng để tính thưởng"
          />
          <StatsCard
            title="Doanh thu Thiết kế"
            value={fmt(metrics.designRevenue) + ' đ'}
            icon="fa-palette"
            color="text-cyan-600"
            bg="bg-cyan-50"
          />
          <StatsCard
            title="Doanh thu Khổ Lớn"
            value={fmt(metrics.largePrintRevenue) + ' đ'}
            icon="fa-print"
            color="text-purple-600"
            bg="bg-purple-50"
          />
          <StatsCard
            title="Khách hàng mới"
            value={metrics.newCustomersCount}
            icon="fa-user-plus"
            color="text-violet-600"
            bg="bg-violet-50"
            onClick={() => metrics.newCustomersCount > 0 && setShowNewCustomers(true)}
          />
          <StatsCard
            title="Khách quay lại"
            value={metrics.returningCustomersCount}
            icon="fa-user-check"
            color="text-orange-600"
            bg="bg-orange-50"
          />
        </div>
      )}

      {/* At-Risk VIP Alert */}
      {atRiskVIP.length > 0 && (
        <div className="bg-white rounded-lg shadow-sm border border-red-100 overflow-hidden mb-6">
          <div className="px-5 py-3 bg-gradient-to-r from-red-50 to-orange-50 border-b border-red-100 flex items-center justify-between">
            <h3 className="font-bold text-red-800 text-sm flex items-center gap-2">
              <i className="fa-solid fa-heart-pulse text-red-500 animate-pulse"></i>
              KH VIP cần chăm sóc ({atRiskVIP.length})
            </h3>
            <span className="text-[10px] text-red-600 font-medium">Doanh số ≥10M • Lâu không đặt đơn</span>
          </div>
          <div className="divide-y divide-gray-100">
            {atRiskVIP.map(c => {
              const days = c.days_since_last_order || 0;
              const urgency = days >= 90 ? 'critical' : days >= 60 ? 'warning' : 'notice';
              const borderColor = urgency === 'critical' ? 'border-l-red-500' : urgency === 'warning' ? 'border-l-orange-400' : 'border-l-yellow-400';
              const badgeStyle = urgency === 'critical' ? 'bg-red-100 text-red-700' : urgency === 'warning' ? 'bg-orange-100 text-orange-700' : 'bg-yellow-100 text-yellow-700';
              return (
                <div key={c.id} className={`flex items-center gap-3 px-5 py-2.5 border-l-4 ${borderColor} hover:bg-gray-50 transition-colors`}>
                  <div className="flex-1 min-w-0">
                    <div className="font-bold text-gray-800 text-sm truncate">{c.name}</div>
                    <div className="text-[10px] text-gray-500">{c.code}{c.phone ? ` • ${c.phone}` : ''}</div>
                  </div>
                  <div className="text-right text-xs flex-shrink-0">
                    <div className="font-bold text-emerald-700">{fmt(c.total_revenue)}đ</div>
                    <div className="text-gray-400">{c.total_orders} đơn</div>
                  </div>
                  <span className={`text-[10px] font-bold px-2 py-0.5 rounded flex-shrink-0 ${badgeStyle}`}>
                    {days}d
                  </span>
                  {c.phone && (
                    <a href={`tel:${c.phone}`} className="w-7 h-7 rounded-full bg-green-500 text-white flex items-center justify-center hover:bg-green-600 transition-colors flex-shrink-0" title="Gọi">
                      <i className="fa-solid fa-phone text-[10px]"></i>
                    </a>
                  )}
                </div>
              );
            })}
          </div>
        </div>
      )}

      {/* 3. Charts Area */}
      {stats && (
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-6">
          {/* Revenue Line Chart */}
          <div className="bg-white p-4 rounded-lg shadow-sm border border-gray-100 lg:col-span-2">
            <h3 className="font-bold text-gray-700 mb-4"><i className="fa-solid fa-chart-area mr-2"></i>Doanh thu theo thời gian</h3>
            <div className="h-80 w-full">
              <ResponsiveContainer width="100%" height="100%">
                <LineChart data={stats.dailyRevenue || []}>
                  <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#eee" />
                  <XAxis dataKey="date" axisLine={false} tickLine={false} />
                  <YAxis axisLine={false} tickLine={false} tickFormatter={(val) => val >= 1000000 ? `${val / 1000000}M` : `${val / 1000}k`} />
                  <Tooltip formatter={(value: number) => fmt(value) + ' đ'} />
                  <Legend />
                  <Line type="monotone" dataKey="revenue" name="Doanh thu" stroke="#00796b" strokeWidth={3} dot={{ r: 4 }} activeDot={{ r: 6 }} />
                </LineChart>
              </ResponsiveContainer>
            </div>
          </div>
          {/* Status Doughnut Chart */}
          <div className="bg-white p-4 rounded-lg shadow-sm border border-gray-100">
            <h3 className="font-bold text-gray-700 mb-4"><i className="fa-solid fa-chart-pie mr-2"></i>Tỷ lệ Trạng thái</h3>
            <div className="h-64 w-full flex justify-center">
              <ResponsiveContainer width="100%" height="100%">
                <PieChart>
                  <Pie
                    data={Object.entries(stats.statusCounts || {}).map(([k, v]) => ({ name: k, value: v }))}
                    cx="50%"
                    cy="50%"
                    innerRadius={60}
                    outerRadius={80}
                    paddingAngle={5}
                    dataKey="value"
                  >
                    {Object.entries(stats.statusCounts || {}).map((entry, index) => (
                      <Cell key={`cell-${index}`} fill={PIE_COLORS[index % PIE_COLORS.length]} />
                    ))}
                  </Pie>
                  <Tooltip />
                  <Legend verticalAlign="bottom" height={36} />
                </PieChart>
              </ResponsiveContainer>
            </div>
          </div>

          {/* Source Pie Chart */}
          <div className="bg-white p-4 rounded-lg shadow-sm border border-gray-100">
            <h3 className="font-bold text-gray-700 mb-4"><i className="fa-solid fa-users-rays mr-2"></i>Nguồn Khách hàng</h3>
            <div className="h-64 w-full flex justify-center">
              <ResponsiveContainer width="100%" height="100%">
                <PieChart>
                  <Pie
                    data={Object.entries(stats.sourceCounts || {}).map(([k, v]) => ({ name: k, value: v }))}
                    cx="50%"
                    cy="50%"
                    outerRadius={80}
                    dataKey="value"
                    label={({ name, percent }) => `${name} ${(percent * 100).toFixed(0)}%`}
                  >
                    {Object.entries(stats.sourceCounts || {}).map((entry, index) => (
                      <Cell key={`cell-${index}`} fill={COLORS.info} opacity={1 - (index * 0.1)} />
                    ))}
                  </Pie>
                  <Tooltip />
                </PieChart>
              </ResponsiveContainer>
            </div>
          </div>

          {/* Lifecycle Pie Chart */}
          <div className="bg-white p-4 rounded-lg shadow-sm border border-gray-100">
            <h3 className="font-bold text-gray-700 mb-4"><i className="fa-solid fa-rotate mr-2"></i>Vòng đời Khách hàng</h3>
            <div className="h-64 w-full flex justify-center">
              <ResponsiveContainer width="100%" height="100%">
                <PieChart>
                  <Pie
                    data={[
                      { name: 'Khách mới', value: metrics.newCustomersCount },
                      { name: 'Khách quay lại', value: metrics.returningCustomersCount }
                    ]}
                    cx="50%"
                    cy="50%"
                    innerRadius={40}
                    outerRadius={80}
                    dataKey="value"
                  >
                    <Cell fill={COLORS.purple} />
                    <Cell fill={COLORS.orange} />
                  </Pie>
                  <Tooltip />
                  <Legend verticalAlign="bottom" />
                </PieChart>
              </ResponsiveContainer>
            </div>
          </div>

          {/* Sales By Employee Bar Chart */}
          <div className="bg-white p-4 rounded-lg shadow-sm border border-gray-100 lg:col-span-2">
            <h3 className="font-bold text-gray-700 mb-4"><i className="fa-solid fa-ranking-star mr-2"></i>Top Doanh số Nhân viên</h3>
            <div className="h-64 w-full">
              <ResponsiveContainer width="100%" height="100%">
                <BarChart layout="vertical" data={stats.salesByEmployee || []} margin={{ top: 5, right: 30, left: 40, bottom: 5 }}>
                  <CartesianGrid strokeDasharray="3 3" horizontal={false} stroke="#eee" />
                  <XAxis type="number" hide />
                  <YAxis dataKey="name" type="category" width={120} tick={{ fontSize: 12 }} />
                  <Tooltip formatter={(value: number) => fmt(value) + ' đ'} />
                  <Bar dataKey="sales" name="Doanh số" fill="#8884d8" radius={[0, 4, 4, 0]}>
                    {(stats.salesByEmployee || []).map((entry, index) => (
                      <Cell key={`cell-${index}`} fill={index < 3 ? '#FF8042' : '#8884d8'} />
                    ))}
                  </Bar>
                </BarChart>
              </ResponsiveContainer>
            </div>
          </div>
        </div>
      )}

      {/* 4. Incomplete Orders Report */}
      {stats?.incompleteOrders && stats.incompleteOrders.length > 0 && (
        <div className="bg-white rounded-lg shadow-sm border border-gray-100 overflow-hidden mb-6">
          <div className="px-6 py-4 border-b border-gray-100 flex justify-between items-center bg-gray-50">
            <h3 className="font-bold text-gray-700">
              <i className="fa-solid fa-hourglass-half mr-2 text-orange-500"></i>
              Đơn hàng chưa hoàn thành ({stats.incompleteOrders.length})
            </h3>
          </div>
          <div className="overflow-x-auto max-h-[500px] overflow-y-auto">
            <table className="w-full text-sm text-left">
              <thead className="bg-gray-50 text-gray-600 font-medium sticky top-0 z-10">
                <tr>
                  <th className="px-4 py-3">Trạng thái</th>
                  <th className="px-4 py-3">Mã ĐH</th>
                  <th className="px-4 py-3">Khách hàng</th>
                  <th className="px-4 py-3">NV Kinh doanh</th>
                  <th className="px-4 py-3">Ngày tạo</th>
                  <th className="px-4 py-3 text-right">Tổng tiền</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-100">
                {stats.incompleteOrders.map((order) => (
                  <tr key={order.id} className="hover:bg-gray-50 transition-colors">
                    <td className="px-4 py-3">
                      <span className={`inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium border ${order.is_urgent ? 'bg-red-50 text-red-700 border-red-100' : 'bg-gray-100 text-gray-800 border-gray-200'}`}>
                        {order.is_urgent && <i className="fa-solid fa-bolt mr-1"></i>}
                        {STATUS_LABEL_MAP[order.status] || order.status}
                      </span>
                    </td>
                    <td className="px-4 py-3 font-medium text-blue-600">
                      {order.order_code || '---'}
                    </td>
                    <td className="px-4 py-3 text-gray-900">
                      {order.customer?.name || 'Khách lẻ'}
                    </td>
                    <td className="px-4 py-3 text-gray-500">
                      {order.sales_rep?.full_name || '-'}
                    </td>
                    <td className="px-4 py-3 text-gray-500">
                      {new Date(order.created_at).toLocaleDateString('vi-VN')}
                    </td>
                    <td className="px-4 py-3 text-right font-medium text-gray-900">
                      {fmt(order.total_amount) + ' đ'}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      )}

      {/* Modal Khách hàng mới */}
      {showNewCustomers && stats?.newCustomersList && (
        <div className="fixed inset-0 bg-black/40 z-[9999] flex items-center justify-center p-4" onClick={() => setShowNewCustomers(false)}>
          <div className="bg-white rounded-xl shadow-2xl w-full max-w-3xl max-h-[80vh] flex flex-col" onClick={e => e.stopPropagation()}>
            <div className="flex items-center justify-between px-5 py-4 border-b">
              <h3 className="font-semibold text-gray-800">
                <i className="fa-solid fa-user-plus text-violet-600 mr-2"></i>
                Khách hàng mới ({stats.newCustomersList.length})
                <span className="text-sm font-normal text-gray-400 ml-2">{stats.period}</span>
              </h3>
              <div className="flex items-center gap-2">
                <button
                  onClick={() => {
                    const list = stats.newCustomersList;
                    const bom = '\uFEFF';
                    const header = 'STT,Tên khách hàng,SĐT,Nguồn,Mã đơn đầu tiên,Ngày tạo,NVKD\n';
                    const rows = list.map((c, i) =>
                      `${i + 1},"${c.customer_name}","${c.customer_phone}","${c.customer_source}","${c.first_order_code}","${new Date(c.first_order_date).toLocaleDateString('vi-VN')}","${c.sales_rep}"`
                    ).join('\n');
                    const blob = new Blob([bom + header + rows], { type: 'text/csv;charset=utf-8;' });
                    const url = URL.createObjectURL(blob);
                    const a = document.createElement('a');
                    a.href = url;
                    a.download = `khach-hang-moi_${stats.startDate}_${stats.endDate}.csv`;
                    a.click();
                    URL.revokeObjectURL(url);
                  }}
                  className="px-3 py-1.5 bg-green-600 text-white text-xs rounded-lg hover:bg-green-700 flex items-center gap-1.5"
                >
                  <i className="fa-solid fa-file-csv"></i> Xuất CSV
                </button>
                <button onClick={() => setShowNewCustomers(false)} className="text-gray-400 hover:text-gray-600 text-lg px-1">
                  <i className="fa-solid fa-xmark"></i>
                </button>
              </div>
            </div>
            <div className="overflow-auto flex-1">
              <table className="w-full text-sm">
                <thead className="bg-gray-50 sticky top-0">
                  <tr>
                    <th className="px-4 py-2.5 text-left text-xs font-medium text-gray-500">STT</th>
                    <th className="px-4 py-2.5 text-left text-xs font-medium text-gray-500">Tên khách hàng</th>
                    <th className="px-4 py-2.5 text-left text-xs font-medium text-gray-500">SĐT</th>
                    <th className="px-4 py-2.5 text-left text-xs font-medium text-gray-500">Nguồn</th>
                    <th className="px-4 py-2.5 text-left text-xs font-medium text-gray-500">Đơn đầu tiên</th>
                    <th className="px-4 py-2.5 text-left text-xs font-medium text-gray-500">Ngày</th>
                    <th className="px-4 py-2.5 text-left text-xs font-medium text-gray-500">NVKD</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-gray-100">
                  {stats.newCustomersList.map((c, i) => (
                    <tr key={c.customer_id} className="hover:bg-gray-50">
                      <td className="px-4 py-2.5 text-gray-400">{i + 1}</td>
                      <td className="px-4 py-2.5 font-medium text-gray-800">{c.customer_name}</td>
                      <td className="px-4 py-2.5 text-gray-600">{c.customer_phone || '-'}</td>
                      <td className="px-4 py-2.5 text-gray-600">{c.customer_source || '-'}</td>
                      <td className="px-4 py-2.5 text-blue-600 font-mono text-xs">{c.first_order_code}</td>
                      <td className="px-4 py-2.5 text-gray-500 text-xs">{new Date(c.first_order_date).toLocaleDateString('vi-VN')}</td>
                      <td className="px-4 py-2.5 text-gray-600">{c.sales_rep || '-'}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

// Mini Component for Stats Card
const StatsCard = ({ title, value, icon, color, bg, desc, onClick }: any) => (
  <div
    className={`bg-white p-4 rounded-lg shadow-sm border border-gray-100 flex items-start justify-between hover:shadow-md transition-shadow ${onClick ? 'cursor-pointer' : ''}`}
    onClick={onClick}
  >
    <div>
      <p className="text-sm font-medium text-gray-500 mb-1">{title}</p>
      <h4 className="text-xl font-bold text-gray-800">{value}</h4>
      {desc && <p className="text-xs text-gray-400 mt-1">{desc}</p>}
    </div>
    <div className={`p-3 rounded-full ${bg} ${color}`}>
      <i className={`fa-solid ${icon} text-lg`}></i>
    </div>
  </div>
);

export default Dashboard;
