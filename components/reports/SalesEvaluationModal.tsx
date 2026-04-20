import React, { useState, useEffect } from 'react';
import { SalesCommissionResult } from '../../types';
import { supabase } from '../../services/supabaseClient';

interface Props {
    isOpen: boolean;
    onClose: () => void;
    currentUserRole: string;
    currentUserName?: string;
}

const SalesEvaluationModal: React.FC<Props> = ({ isOpen, onClose, currentUserRole, currentUserName }) => {
    const [startDate, setStartDate] = useState('');
    const [endDate, setEndDate] = useState('');
    const [evaluations, setEvaluations] = useState<SalesCommissionResult[]>([]);
    const [deptTarget, setDeptTarget] = useState<number>(0);
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState<string | null>(null);

    const isAdmin = currentUserRole === 'Admin' || currentUserRole === 'KeToan';
    const isSales = currentUserRole === 'NhanVienKinhDoanh';

    useEffect(() => {
        if (isOpen) {
            const date = new Date();
            // Fix Timezone Issue
            const toLocalISO = (d: Date) => {
                const year = d.getFullYear();
                const month = String(d.getMonth() + 1).padStart(2, '0');
                const day = String(d.getDate()).padStart(2, '0');
                return `${year}-${month}-${day}`;
            };
            const firstDay = toLocalISO(new Date(date.getFullYear(), date.getMonth(), 1));
            const lastDay = toLocalISO(new Date(date.getFullYear(), date.getMonth() + 1, 0));
            setStartDate(firstDay);
            setEndDate(lastDay);
            handleCalculate(firstDay, lastDay);
        }
    }, [isOpen]);

    const handleCalculate = async (start = startDate, end = endDate) => {
        setLoading(true);
        setError(null);
        try {
            // 1. Fetch All Required Data (Orders, Policies, Profiles, Customers, Target)
            const ordersPromise = supabase
                .from('orders')
                .select('id, sales_rep_id, total_amount, status, created_at')
                .gte('created_at', `${start}T00:00:00`)
                .lte('created_at', `${end}T23:59:59`);

            const policiesPromise = supabase
                .from('commission_policies')
                .select('*');

            const profilesPromise = supabase
                .from('profiles')
                .select('id, full_name')
                .eq('role', 'NhanVienKinhDoanh');

            const customersPromise = supabase
                .from('customers')
                .select('id, sales_rep_id, created_at')
                .gte('created_at', `${start}T00:00:00`)
                .lte('created_at', `${end}T23:59:59`);

            // Get Department Target
            const d = new Date(start);
            const targetPromise = supabase
                .from('sales_targets')
                .select('target_amount')
                .eq('department_name', 'Sales')
                .eq('period_month', d.getMonth() + 1)
                .eq('period_year', d.getFullYear())
                .maybeSingle();

            const [ordersResp, policiesResp, profilesResp, custResp, targetResp] = await Promise.all([
                ordersPromise,
                policiesPromise,
                profilesPromise,
                customersPromise,
                targetPromise
            ]);

            if (ordersResp.error) throw ordersResp.error;
            if (policiesResp.error) console.error("Policies fetch error", policiesResp.error);
            if (profilesResp.error) throw profilesResp.error;
            if (custResp.error) throw custResp.error;

            const orders = ordersResp.data || [];
            const policies = policiesResp.data || [];
            const profiles = profilesResp.data || [];
            const newCustomers = custResp.data || [];

            setDeptTarget(targetResp.data?.target_amount || 0);

            // --- Calculation Logic ---

            // 1. Map Profiles (ID -> Name)
            // const idToName = profiles.reduce((acc: any, p) => { acc[p.id] = p.full_name; return acc; }, {});

            // 2. Aggregate Sales & Metrics per Rep
            const repStats: Record<string, {
                total_sales: number;
                valid_orders_count: number;
                max_val: number;
                active_days: Set<string>;
                new_cust_count: number;
                total_created_count: number;
            }> = {};

            // Initialize Reps
            profiles.forEach(p => {
                repStats[p.id] = { total_sales: 0, valid_orders_count: 0, max_val: 0, active_days: new Set(), new_cust_count: 0, total_created_count: 0 };
            });

            // Process Orders
            orders.forEach(o => {
                if (!o.sales_rep_id) return;
                // Init if not exists
                if (!repStats[o.sales_rep_id]) {
                    repStats[o.sales_rep_id] = { total_sales: 0, valid_orders_count: 0, max_val: 0, active_days: new Set(), new_cust_count: 0, total_created_count: 0 };
                }
                const s = repStats[o.sales_rep_id];

                s.total_created_count++;

                if (o.status !== 'Huy') {
                    s.total_sales += o.total_amount || 0;
                    s.valid_orders_count++;
                    if ((o.total_amount || 0) > s.max_val) s.max_val = o.total_amount;
                    s.active_days.add(new Date(o.created_at).toDateString());
                }
            });

            // Process New Customers
            newCustomers.forEach(c => {
                if (c.sales_rep_id && repStats[c.sales_rep_id]) {
                    repStats[c.sales_rep_id].new_cust_count++;
                }
            });

            // 3. Calculate Group Totals
            const groupSalesTotal = Object.values(repStats).reduce((sum, r) => sum + r.total_sales, 0);

            // 4. Determine Group Commission Rate & Fund
            const groupTiers = policies.filter(p => p.policy_type === 'GROUP_TIER').sort((a, b) => b.threshold_min - a.threshold_min);
            const groupPolicy = groupTiers.find(p => groupSalesTotal >= p.threshold_min);
            const groupRate = groupPolicy ? groupPolicy.rate : 0;
            const groupFund = groupSalesTotal * groupRate;

            // 5. Calculate Final Result per Rep
            const results: SalesCommissionResult[] = profiles.map(p => {
                const stats = repStats[p.id];
                if (!stats) return null;

                // Personal Commission
                const salesTiers = policies
                    .filter(pol => pol.policy_type === 'SALES_TIER' && (pol.apply_to === p.full_name || pol.apply_to === 'All' || !pol.apply_to))
                    .sort((a, b) => b.threshold_min - a.threshold_min);

                const matchTier = salesTiers.find(t => stats.total_sales >= t.threshold_min);
                const personalRate = matchTier ? matchTier.rate : 0;
                const personalComm = stats.total_sales * personalRate;

                // Group Allocation
                const groupAlloc = groupSalesTotal > 0 ? (stats.total_sales / groupSalesTotal) * groupFund : 0;

                // UI Tiers
                const uiTiers = salesTiers
                    .sort((a, b) => a.threshold_min - b.threshold_min)
                    .map(t => ({ min: t.threshold_min, max: t.threshold_max || Infinity, rate: t.rate }));

                return {
                    sales_rep_name: p.full_name,
                    personal_sales: stats.total_sales,
                    personal_comm: personalComm,
                    group_sales_total: groupSalesTotal,
                    group_comm: groupAlloc,
                    total_comm: personalComm + groupAlloc,
                    commission_tiers: uiTiers,

                    // New Metrics
                    total_orders: stats.valid_orders_count,
                    highest_order_value: stats.max_val,
                    new_customers: stats.new_cust_count,
                    active_days: stats.active_days.size,
                    success_rate: stats.total_created_count > 0
                        ? parseFloat(((stats.valid_orders_count / stats.total_created_count) * 100).toFixed(1))
                        : 0
                };
            }).filter(item => item !== null) as SalesCommissionResult[];

            // Filter if Sales Staff
            let displayedData = results;
            if (isSales && currentUserName) {
                displayedData = results.filter(item => item.sales_rep_name === currentUserName);
            }

            setDeptTotalSales(groupSalesTotal);
            setEvaluations(displayedData);

        } catch (err: any) {
            console.error("Evaluation error:", err);
            setError(err.message || 'Lỗi tải dữ liệu đánh giá.');
        } finally {
            setLoading(false);
        }
    };

    const [deptTotalSales, setDeptTotalSales] = useState(0);

    if (!isOpen) return null;

    // Helper to calculate next target
    const getTargetInfo = (currentSales: number, tiers: any[]) => {
        if (!tiers || tiers.length === 0) return { nextTarget: null, progress: 0, currentRate: 0 };

        // Find current tier
        let currentRate = 0;
        let nextTarget = null;

        // Sort tiers
        const sortedTiers = [...tiers].sort((a, b) => a.min - b.min);

        for (let i = 0; i < sortedTiers.length; i++) {
            const t = sortedTiers[i];
            if (currentSales >= t.min) {
                currentRate = t.rate;
                // If there's a next tier, that's the target
                if (i < sortedTiers.length - 1) {
                    nextTarget = sortedTiers[i + 1].min;
                } else if (t.max) {
                    // Check if there is an upper bound locally
                }
            } else {
                // We haven't reached this tier yet, so it is the target (if we are below lowest tier)
                if (nextTarget === null) nextTarget = t.min;
                break;
            }
        }

        // If below all tiers
        if (currentSales < sortedTiers[0].min) {
            nextTarget = sortedTiers[0].min;
            currentRate = 0;
        }

        const progress = nextTarget ? Math.min((currentSales / nextTarget) * 100, 100) : 100;
        return { nextTarget, progress, currentRate };
    };

    return (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-50">
            <div className="bg-white rounded-lg shadow-xl w-full max-w-4xl p-6 relative max-h-[90vh] overflow-y-auto">
                <button
                    onClick={onClose}
                    className="absolute top-4 right-4 text-gray-400 hover:text-gray-600"
                >
                    <i className="fa-solid fa-times text-xl"></i>
                </button>

                <h2 className="text-xl font-bold mb-4 text-indigo-700">
                    <i className="fa-solid fa-chart-line mr-2"></i>
                    Đánh Giá & KPI {isSales ? 'Cá Nhân' : 'Nhân Viên Kinh Doanh'}
                </h2>

                {/* Filter */}
                <div className="flex flex-wrap gap-4 mb-6 items-end border-b pb-4 bg-gray-50 p-4 rounded">
                    <div>
                        <label className="block text-sm font-medium text-gray-700 mb-1">Từ ngày</label>
                        <input
                            type="date"
                            value={startDate}
                            onChange={e => setStartDate(e.target.value)}
                            className="px-3 py-2 border rounded-md focus:ring-indigo-500 focus:border-indigo-500"
                        />
                    </div>
                    <div>
                        <label className="block text-sm font-medium text-gray-700 mb-1">Đến ngày</label>
                        <input
                            type="date"
                            value={endDate}
                            onChange={e => setEndDate(e.target.value)}
                            className="px-3 py-2 border rounded-md focus:ring-indigo-500 focus:border-indigo-500"
                        />
                    </div>
                    <button
                        onClick={() => handleCalculate()}
                        disabled={loading}
                        className={`px-4 py-2 rounded-md text-white font-medium ${loading ? 'bg-gray-400' : 'bg-indigo-600 hover:bg-indigo-700'}`}
                    >
                        {loading ? <i className="fa-solid fa-spinner fa-spin"></i> : 'Xem Đánh Giá'}
                    </button>
                </div>

                {error && <div className="text-red-600 mb-4 p-2 bg-red-50 rounded">{error}</div>}

                {/* Department KPI Card (Visible to All) */}
                <div className="mb-8 p-5 bg-gradient-to-r from-blue-50 to-indigo-50 rounded-lg border border-blue-100 shadow-sm">
                    <div className="flex justify-between items-center mb-2">
                        <h3 className="text-lg font-bold text-indigo-800"><i className="fa-solid fa-building-user mr-2"></i>KPI Phòng Kinh Doanh</h3>
                        <span className="text-sm text-gray-600 bg-white px-2 py-1 rounded border">Tháng {new Date(startDate).getMonth() + 1}/{new Date(startDate).getFullYear()}</span>
                    </div>

                    <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mt-4">
                        <div className="bg-white p-3 rounded border">
                            <div className="text-gray-500 text-sm">Chỉ tiêu (Target)</div>
                            <div className="text-xl font-bold text-gray-800">{deptTarget.toLocaleString('vi-VN')} đ</div>
                        </div>
                        <div className="bg-white p-3 rounded border">
                            <div className="text-gray-500 text-sm">Thực đạt (Actual)</div>
                            <div className={`text-xl font-bold ${deptTotalSales >= deptTarget ? 'text-green-600' : 'text-indigo-600'}`}>
                                {deptTotalSales.toLocaleString('vi-VN')} đ
                            </div>
                        </div>
                        <div className="bg-white p-3 rounded border flex flex-col justify-center">
                            <div className="text-gray-500 text-sm mb-1">Hoàn thành</div>
                            <div className="w-full bg-gray-200 rounded-full h-2.5">
                                <div className={`h-2.5 rounded-full ${deptTotalSales >= deptTarget ? 'bg-green-500' : 'bg-indigo-500'}`}
                                    style={{ width: `${Math.min((deptTotalSales / (deptTarget || 1)) * 100, 100)}%` }}></div>
                            </div>
                            <div className="text-right text-xs font-bold mt-1 text-gray-700">
                                {deptTarget > 0 ? ((deptTotalSales / deptTarget) * 100).toFixed(1) : 0}%
                            </div>
                        </div>
                    </div>
                </div>

                <h3 className="text-lg font-bold text-gray-800 mb-4 border-l-4 border-orange-500 pl-3">
                    {isSales ? 'KPI Cá Nhân' : 'Chi Tiết Nhân Viên'}
                </h3>

                <div className="space-y-6">
                    {evaluations.map((item, idx) => {
                        const { nextTarget, progress, currentRate } = getTargetInfo(item.personal_sales, item.commission_tiers || []);
                        const isMax = nextTarget === null;

                        return (
                            <div key={idx} className="border rounded-lg p-5 shadow-sm bg-white hover:shadow-md transition-shadow">
                                <div className="flex justify-between items-start mb-3">
                                    <div>
                                        <h3 className="text-lg font-bold text-gray-800 flex items-center gap-2">
                                            {item.sales_rep_name}
                                            {isMax && <span className="bg-yellow-100 text-yellow-800 text-xs px-2 py-0.5 rounded-full">Top Performer</span>}
                                        </h3>
                                        <div className="text-sm text-gray-500 mt-1">
                                            Doanh số đạt: <span className="font-bold text-indigo-700 text-lg">{item.personal_sales.toLocaleString('vi-VN')} đ</span>
                                        </div>
                                    </div>
                                    <div className="text-right">
                                        <div className="text-sm text-gray-500">Hệ số thưởng</div>
                                        <div className="text-xl font-bold text-green-600">{currentRate * 100}%</div> {/* Display as percentage */}
                                    </div>
                                </div>

                                {/* Detailed Metrics Grid */}
                                <div className="grid grid-cols-2 md:grid-cols-5 gap-3 mb-4">
                                    <div className="bg-blue-50 p-2 rounded border border-blue-100 text-center">
                                        <div className="text-xs text-blue-800 font-semibold mb-1">Số đơn hàng</div>
                                        <div className="text-lg font-bold text-blue-700">{item.total_orders || 0}</div>
                                    </div>
                                    <div className="bg-purple-50 p-2 rounded border border-purple-100 text-center">
                                        <div className="text-xs text-purple-800 font-semibold mb-1">Đơn lớn nhất</div>
                                        <div className="text-lg font-bold text-purple-700">{new Intl.NumberFormat('vi-VN', { notation: 'compact', compactDisplay: 'short' }).format(item.highest_order_value || 0)}</div>
                                    </div>
                                    <div className="bg-orange-50 p-2 rounded border border-orange-100 text-center">
                                        <div className="text-xs text-orange-800 font-semibold mb-1">Khách mới</div>
                                        <div className="text-lg font-bold text-orange-700">{item.new_customers || 0}</div>
                                    </div>
                                    <div className="bg-green-50 p-2 rounded border border-green-100 text-center">
                                        <div className="text-xs text-green-800 font-semibold mb-1">Tỷ lệ chốt</div>
                                        <div className="text-lg font-bold text-green-700">{item.success_rate || 0}%</div>
                                    </div>
                                    <div className="bg-teal-50 p-2 rounded border border-teal-100 text-center">
                                        <div className="text-xs text-teal-800 font-semibold mb-1">Ngày Active</div>
                                        <div className="text-lg font-bold text-teal-700">{item.active_days || 0}</div>
                                    </div>
                                </div>

                                {/* Progress Bar */}
                                <div className="mb-2">
                                    <div className="flex justify-between text-xs font-semibold text-gray-600 mb-1">
                                        <span>0đ</span>
                                        {nextTarget && <span>Mục tiêu tiếp: {nextTarget.toLocaleString('vi-VN')}đ</span>}
                                        {isMax && <span>Vượt mức tối đa</span>}
                                    </div>
                                    <div className="w-full bg-gray-200 rounded-full h-4 overflow-hidden relative">
                                        <div
                                            className="bg-indigo-500 h-4 rounded-full transition-all duration-1000 ease-out"
                                            style={{ width: `${progress}%` }}
                                        ></div>
                                    </div>
                                    {nextTarget && (
                                        <div className="text-xs text-center text-gray-500 mt-1">
                                            Còn thiếu <span className="font-bold text-red-500">{(nextTarget - item.personal_sales).toLocaleString('vi-VN')}đ</span> để đạt mức thưởng tiếp theo
                                        </div>
                                    )}
                                </div>

                                <div className="mt-4 pt-4 border-t flex justify-between items-center bg-gray-50 -mx-5 -mb-5 p-4 rounded-b-lg">
                                    <div className="text-sm text-gray-600">
                                        Tổng hoa hồng dự kiến:
                                    </div>
                                    <div className="font-bold text-xl text-green-700">
                                        {/* Only show commission if admin OR if it is the current user (which it is due to filtering) */}
                                        {item.total_comm.toLocaleString('vi-VN')} đ
                                    </div>
                                </div>
                            </div>
                        );
                    })}

                    {!loading && evaluations.length === 0 && (
                        <div className="text-center py-10 text-gray-500">Chưa có dữ liệu đánh giá cho giai đoạn này.</div>
                    )}
                </div>
            </div>
        </div>
    );
};

export default SalesEvaluationModal;
