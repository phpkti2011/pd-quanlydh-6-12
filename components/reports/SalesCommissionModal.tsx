import React, { useState, useEffect } from 'react';
import { commissionService } from '../../services/commissionService';
import { SalesCommissionResult } from '../../types';

interface Props {
    isOpen: boolean;
    onClose: () => void;
    currentUserRole?: string;
    currentUserName?: string;
}

const SalesCommissionModal: React.FC<Props> = ({ isOpen, onClose, currentUserRole, currentUserName }) => {
    const [selectedMonth, setSelectedMonth] = useState(new Date().getMonth() + 1);
    const [selectedYear, setSelectedYear] = useState(new Date().getFullYear());

    const [results, setResults] = useState<SalesCommissionResult[]>([]);
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState<string | null>(null);

    const [selectedItem, setSelectedItem] = useState<SalesCommissionResult | null>(null);
    const [detailTab, setDetailTab] = useState<'commission' | 'orders'>('commission');
    const [repOrders, setRepOrders] = useState<any[]>([]);
    const [ordersLoading, setOrdersLoading] = useState(false);

    // Initial load
    useEffect(() => {
        if (isOpen) {
            // Reset or Auto Load? Let's auto load for convenience
            handleCalculate();
        }
    }, [isOpen]);

    const handleCalculate = async () => {
        setLoading(true);
        setError(null);
        try {
            // Construct YYYY-MM-DD format
            // Start Date: 1st of the month
            const startDate = `${selectedYear}-${String(selectedMonth).padStart(2, '0')}-01`;

            // End Date: Last day of the month
            const lastDay = new Date(selectedYear, selectedMonth, 0).getDate();
            const endDate = `${selectedYear}-${String(selectedMonth).padStart(2, '0')}-${lastDay}`;

            // Restriction Logic: Only Admin can see ALL. Others see OWN only.
            // User requested: "chỉ admin được xem toàn bộ, kế toán không được xem"
            const isViewAllAllowed = currentUserRole === 'Admin';
            const filterName = isViewAllAllowed ? undefined : currentUserName;

            // If not Admin and no name, return empty or handle error?
            // Usually currentUserName should be present.

            const data = await commissionService.calculateSalesCommission(startDate, endDate, filterName);
            console.log("Comm Data:", data);
            setResults(data);
        } catch (err: any) {
            setError(err.message || 'Lỗi khi tính toán.');
        } finally {
            setLoading(false);
        }
    };

    if (!isOpen) return null;

    return (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-50">
            <div className="bg-white rounded-lg shadow-xl w-full max-w-4xl p-6 relative max-h-[90vh] overflow-y-auto animate-fade-in-up">
                <button
                    onClick={onClose}
                    className="absolute top-4 right-4 text-gray-400 hover:text-gray-600"
                >
                    <i className="fa-solid fa-times text-xl"></i>
                </button>

                <h2 className="text-xl font-bold mb-4 text-pink-700">
                    <i className="fa-solid fa-percent mr-2"></i>
                    Thưởng Nhân Viên Kinh Doanh
                </h2>

                <div className="flex flex-wrap gap-4 mb-6 items-end border-b pb-4 bg-gray-50 p-4 rounded-lg">
                    <div>
                        <label className="block text-sm font-medium text-gray-700 mb-1">Tháng</label>
                        <select
                            value={selectedMonth}
                            onChange={(e) => setSelectedMonth(parseInt(e.target.value))}
                            className="bg-white border rounded px-3 py-2 outline-none focus:ring-2 focus:ring-pink-500 font-bold text-gray-700 w-32"
                        >
                            {Array.from({ length: 12 }, (_, i) => i + 1).map(m => (
                                <option key={m} value={m}>Tháng {m}</option>
                            ))}
                        </select>
                    </div>
                    <div>
                        <label className="block text-sm font-medium text-gray-700 mb-1">Năm</label>
                        <select
                            value={selectedYear}
                            onChange={(e) => setSelectedYear(parseInt(e.target.value))}
                            className="bg-white border rounded px-3 py-2 outline-none focus:ring-2 focus:ring-pink-500 font-bold text-gray-700 w-24"
                        >
                            {[2024, 2025, 2026, 2027, 2028, 2029, 2030].map(y => (
                                <option key={y} value={y}>{y}</option>
                            ))}
                        </select>
                    </div>

                    <button
                        onClick={handleCalculate}
                        disabled={loading}
                        className={`px-6 py-2 rounded-md text-white font-bold shadow-sm transition-all ${loading ? 'bg-gray-400' : 'bg-pink-600 hover:bg-pink-700 hover:shadow-md'
                            } flex items-center gap-2`}
                    >
                        {loading ? <i className="fa-solid fa-spinner fa-spin"></i> : <i className="fa-solid fa-calculator"></i>}
                        Tính toán
                    </button>
                </div>

                {error && (
                    <div className="mb-4 p-3 bg-red-100 text-red-700 rounded text-sm border border-red-200 flex items-center gap-2">
                        <i className="fa-solid fa-triangle-exclamation"></i> {error}
                    </div>
                )}

                <div className="overflow-x-auto border rounded-lg">
                    <table className="min-w-full divide-y divide-gray-200">
                        <thead className="bg-gray-100">
                            <tr>
                                <th className="px-6 py-3 text-left text-xs font-bold text-gray-600 uppercase tracking-wider">Tên NV</th>
                                <th className="px-6 py-3 text-right text-xs font-bold text-gray-600 uppercase tracking-wider">DS Hoàn thành</th>
                                <th className="px-6 py-3 text-right text-xs font-bold text-gray-600 uppercase tracking-wider">Số đơn</th>
                                <th className="px-6 py-3 text-right text-xs font-bold text-green-600 uppercase tracking-wider">Hoa hồng CN</th>
                                <th className="px-6 py-3 text-right text-xs font-bold text-blue-600 uppercase tracking-wider">Thưởng Nhóm</th>
                                <th className="px-6 py-3 text-right text-xs font-bold text-pink-700 uppercase tracking-wider">Tổng Thưởng</th>
                            </tr>
                        </thead>
                        <tbody className="bg-white divide-y divide-gray-200">
                            {results.length > 0 ? (
                                results.map((item, index) => (
                                    <tr
                                        key={index}
                                        onClick={() => {
                                            setSelectedItem(item);
                                            setDetailTab('commission');
                                            setRepOrders([]);
                                        }}
                                        className="hover:bg-pink-50 transition-colors cursor-pointer group"
                                    >
                                        <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900 group-hover:text-pink-700">
                                            {item.sales_rep_name} <i className="fa-solid fa-circle-info text-gray-300 group-hover:text-pink-400 ml-2 text-xs"></i>
                                        </td>
                                        <td className="px-6 py-4 whitespace-nowrap text-sm text-right text-gray-700 font-medium">{(item.completed_sales || item.personal_sales)?.toLocaleString('vi-VN')} đ</td>
                                        <td className="px-6 py-4 whitespace-nowrap text-sm text-right text-gray-500">{item.completed_order_count || '-'}</td>
                                        <td className="px-6 py-4 whitespace-nowrap text-sm text-right text-green-600 font-medium">{item.personal_comm?.toLocaleString('vi-VN')} đ</td>
                                        <td className="px-6 py-4 whitespace-nowrap text-sm text-right text-blue-600">{item.group_comm?.toLocaleString('vi-VN')} đ</td>
                                        <td className="px-6 py-4 whitespace-nowrap text-sm text-right text-pink-700 font-bold text-base">{((item.personal_comm || 0) + (item.group_comm || 0)).toLocaleString('vi-VN')} đ</td>
                                    </tr>
                                ))
                            ) : (
                                <tr>
                                    <td colSpan={6} className="px-6 py-12 text-center text-gray-400 italic">
                                        {loading ? 'Đang tính toán...' : 'Chưa có dữ liệu tính thưởng cho tháng này.'}
                                    </td>
                                </tr>
                            )}
                        </tbody>
                        {results.length > 0 && (
                            <tfoot className="bg-gray-50 font-bold border-t">
                                <tr>
                                    <td className="px-6 py-3 text-gray-700">Tổng cộng</td>
                                    <td className="px-6 py-3 text-right text-gray-700">{results.reduce((sum, i) => sum + (i.completed_sales || i.personal_sales || 0), 0).toLocaleString('vi-VN')} đ</td>
                                    <td className="px-6 py-3 text-right text-gray-500">{results.reduce((sum, i) => sum + (i.completed_order_count || 0), 0)}</td>
                                    <td className="px-6 py-3 text-right text-green-700">{results.reduce((sum, i) => sum + (i.personal_comm || 0), 0).toLocaleString('vi-VN')} đ</td>
                                    <td className="px-6 py-3 text-right text-blue-700">{results.reduce((sum, i) => sum + (i.group_comm || 0), 0).toLocaleString('vi-VN')} đ</td>
                                    <td className="px-6 py-3 text-right text-pink-700 text-lg">{results.reduce((sum, i) => sum + (i.personal_comm || 0) + (i.group_comm || 0), 0).toLocaleString('vi-VN')} đ</td>
                                </tr>
                            </tfoot>
                        )}
                    </table>
                </div>

                {results.length > 0 && <div className="mt-4 text-xs text-gray-500 italic flex gap-4">
                    <div>* Doanh số nhóm: <span className="font-bold text-gray-700">{results[0]?.group_sales_total?.toLocaleString('vi-VN')} đ</span></div>
                    <div>* Quỹ thưởng nhóm: <span className="font-bold text-gray-700">{results[0]?.group_bonus_fund?.toLocaleString('vi-VN')} đ</span></div>
                </div>}

                <div className="mt-6 border-t border-gray-100 pt-4 text-xs text-gray-500">
                    <div className="bg-yellow-50 border border-yellow-200 rounded-lg p-3 mb-4">
                        <div className="flex items-center gap-2 text-yellow-700 font-bold mb-1">
                            <i className="fa-solid fa-circle-info"></i> Lưu ý quan trọng
                        </div>
                        <p className="text-yellow-800">
                            Thưởng tháng <strong>{selectedMonth}</strong> được tính dựa trên đơn hàng <strong>tạo trong tháng {selectedMonth === 1 ? 12 : selectedMonth - 1}</strong> và đã <strong>hoàn thành</strong>.
                        </p>
                    </div>
                    <h4 className="font-bold text-gray-700 mb-2 uppercase">Công thức tính thưởng:</h4>
                    <div className="space-y-1">
                        <p><strong className="text-gray-900">1. Hoa hồng Cá nhân:</strong> Doanh số hoàn thành × % Hoa hồng (Theo bậc thang cá nhân)</p>
                        <p><strong className="text-gray-900">2. Thưởng Nhóm:</strong> (Doanh số cá nhân / Tổng DS nhóm) × Quỹ thưởng nhóm</p>
                    </div>
                </div>

                {selectedItem && (
                    <div className="fixed inset-0 z-[60] flex items-center justify-center bg-black bg-opacity-50">
                        <div className="bg-white rounded-lg shadow-2xl w-full max-w-5xl p-6 relative animate-fade-in-up max-h-[90vh] overflow-y-auto">
                            <button
                                onClick={() => setSelectedItem(null)}
                                className="absolute top-4 right-4 text-gray-400 hover:text-gray-600"
                            >
                                <i className="fa-solid fa-times text-xl"></i>
                            </button>

                            <h3 className="text-lg font-bold text-gray-800 mb-1">
                                Chi tiết thưởng: <span className="text-pink-700">{selectedItem.sales_rep_name}</span>
                            </h3>
                            <div className="text-sm text-gray-500 mb-4">
                                Doanh số cá nhân: <span className="font-bold text-gray-800">{selectedItem.personal_sales?.toLocaleString('vi-VN')} đ</span>
                                {' · '}{selectedItem.completed_order_count || 0} đơn
                            </div>

                            {/* Tabs */}
                            <div className="flex gap-1 mb-4 border-b">
                                <button
                                    onClick={() => setDetailTab('commission')}
                                    className={`px-4 py-2 text-sm font-medium border-b-2 transition-colors ${detailTab === 'commission' ? 'border-pink-600 text-pink-700' : 'border-transparent text-gray-500 hover:text-gray-700'}`}
                                >
                                    <i className="fa-solid fa-calculator mr-1.5"></i>Chi tiết hoa hồng
                                </button>
                                <button
                                    onClick={async () => {
                                        setDetailTab('orders');
                                        if (repOrders.length === 0) {
                                            setOrdersLoading(true);
                                            try {
                                                const startDate = `${selectedYear}-${String(selectedMonth).padStart(2, '0')}-01`;
                                                const lastDay = new Date(selectedYear, selectedMonth, 0).getDate();
                                                const endDate = `${selectedYear}-${String(selectedMonth).padStart(2, '0')}-${lastDay}`;
                                                const orders = await commissionService.getSalesRepOrders(startDate, endDate, selectedItem.sales_rep_name);
                                                setRepOrders(orders);
                                            } catch (e) {
                                                console.error('Load orders error:', e);
                                            } finally {
                                                setOrdersLoading(false);
                                            }
                                        }
                                    }}
                                    className={`px-4 py-2 text-sm font-medium border-b-2 transition-colors ${detailTab === 'orders' ? 'border-pink-600 text-pink-700' : 'border-transparent text-gray-500 hover:text-gray-700'}`}
                                >
                                    <i className="fa-solid fa-list-ol mr-1.5"></i>Danh sách đơn hàng
                                </button>
                            </div>

                            {detailTab === 'commission' && <div className="space-y-6">
                                {/* 1. Personal Commission Detail */}
                                <div>
                                    <h4 className="font-bold text-green-700 mb-2 flex items-center gap-2">
                                        <i className="fa-solid fa-user-tag"></i> 1. Hoa hồng Cá nhân
                                    </h4>
                                    <div className="bg-gray-50 rounded border p-1 text-sm overflow-hidden">
                                        <table className="w-full text-left border-collapse">
                                            <thead>
                                                <tr className="bg-gray-100 text-gray-600 border-b text-xs uppercase font-bold">
                                                    <th className="p-3 border-r">Mốc doanh số</th>
                                                    <th className="p-3 text-right border-r">DS nằm trong mốc</th>
                                                    <th className="p-3 text-center border-r">% Hoa hồng</th>
                                                    <th className="p-3 text-right">Thành tiền</th>
                                                </tr>
                                            </thead>
                                            <tbody className="divide-y divide-gray-200">
                                                {(() => {
                                                    // Hybrid Logic: Flat for Finite, Marginal for Infinite
                                                    let tiers = (selectedItem.commission_tiers || (selectedItem as any).commission_tier || [])
                                                        .map((t: any) => ({ ...t, min: Number(t.min), max: Number(t.max) || Infinity, rate: Number(t.rate) }))
                                                        .sort((a: any, b: any) => a.min - b.min);

                                                    const sales = Number(selectedItem.personal_sales || 0);

                                                    // Find Active Tier
                                                    let activeTierIndex = -1;
                                                    for (let i = 0; i < tiers.length; i++) {
                                                        if (sales > tiers[i].min) {
                                                            activeTierIndex = i;
                                                            if (sales <= tiers[i].max) break;
                                                        }
                                                    }

                                                    return tiers.map((tier: any, idx: number) => {
                                                        const min = tier.min;
                                                        const max = tier.max;

                                                        // Hybrid Logic Implementation
                                                        const activeTier = tiers[activeTierIndex];
                                                        const isMarginal = activeTier && activeTier.max === Infinity;

                                                        let amountInTier = 0;
                                                        let note = "";
                                                        let isActive = false;

                                                        if (idx === activeTierIndex) {
                                                            isActive = true;
                                                            if (isMarginal) {
                                                                amountInTier = sales - (idx > 0 ? tiers[idx - 1].max : 0);
                                                                note = "Phần vượt mức";
                                                            } else {
                                                                amountInTier = sales;
                                                                note = "Toàn bộ doanh số (Đạt mốc)";
                                                            }
                                                        } else if (isMarginal && idx === activeTierIndex - 1) {
                                                            isActive = true;
                                                            amountInTier = tier.max;
                                                            note = "Doanh số cơ sở (Tối đa)";
                                                        } else {
                                                            amountInTier = 0;
                                                            note = idx < activeTierIndex ? "Đã đạt mốc cao hơn" : "Chưa đạt";
                                                        }

                                                        const commission = amountInTier > 0 ? amountInTier * (tier.rate / 100) : 0;

                                                        return (
                                                            <tr key={idx} className={amountInTier > 0 ? "bg-white" : "bg-gray-50 opacity-40 grayscale"}>
                                                                <td className="p-3 border-r text-gray-700">
                                                                    <div className="font-medium">
                                                                        {min.toLocaleString()} - {max === Infinity || max === 0 ? '∞' : max.toLocaleString()}
                                                                    </div>
                                                                    <div className="text-xs text-gray-400 mt-0.5">
                                                                        {note}
                                                                    </div>
                                                                </td>
                                                                <td className="p-3 text-right border-r font-medium text-blue-600">
                                                                    {amountInTier > 0 ? amountInTier.toLocaleString() : '-'}
                                                                </td>
                                                                <td className="p-3 text-center border-r">
                                                                    <span className={`px-2 py-1 rounded text-xs font-bold ${isActive ? 'bg-green-100 text-green-700' : 'bg-gray-100 text-gray-400'}`}>
                                                                        {tier.rate}%
                                                                    </span>
                                                                </td>
                                                                <td className="p-3 text-right font-bold text-green-700">
                                                                    {commission > 0 ? commission.toLocaleString() : '-'}
                                                                </td>
                                                            </tr>
                                                        );
                                                    });
                                                })()}
                                                <tr className="bg-green-50/50 border-t-2 border-green-100">
                                                    <td colSpan={3} className="p-3 text-right font-bold text-gray-600 uppercase text-xs">Tổng cộng</td>
                                                    <td className="p-3 text-right font-bold text-lg text-green-700">
                                                        {selectedItem.personal_comm?.toLocaleString('vi-VN')}
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>

                                {/* 2. Group Commission Detail */}
                                <div>
                                    <h4 className="font-bold text-blue-700 mb-2 flex items-center gap-2">
                                        <i className="fa-solid fa-users"></i> 2. Thưởng Nhóm
                                    </h4>
                                    <div className="bg-blue-50 rounded border border-blue-100 p-4 text-sm space-y-2">
                                        <div className="flex justify-between">
                                            <span className="text-gray-600">Tổng doanh số nhóm:</span>
                                            <span className="font-bold">{selectedItem.group_sales_total?.toLocaleString()} đ</span>
                                        </div>
                                        <div className="flex justify-between">
                                            <span className="text-gray-600">Quỹ thưởng nhóm ({(selectedItem as any).group_rate || 0}%):</span>
                                            <span className="font-bold text-blue-600">
                                                {((selectedItem as any).group_bonus_fund || 0).toLocaleString()} đ
                                            </span>
                                        </div>
                                        <div className="border-t border-blue-200 my-2 pt-2">
                                            <div className="text-gray-600 mb-1">Công thức chia sẻ:</div>
                                            <div className="font-mono text-xs bg-white p-2 rounded border text-center text-gray-700">
                                                ({selectedItem.personal_sales?.toLocaleString()} / {selectedItem.group_sales_total?.toLocaleString()}) × {(selectedItem as any).group_bonus_fund?.toLocaleString()}
                                            </div>
                                            <div className="flex justify-between mt-2 font-bold text-base text-blue-700">
                                                <span>Thực nhận:</span>
                                                <span>{selectedItem.group_comm?.toLocaleString()} đ</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>}

                            {detailTab === 'orders' && (
                                <div>
                                    {ordersLoading ? (
                                        <div className="text-center py-8 text-gray-400">
                                            <i className="fa-solid fa-spinner fa-spin text-2xl"></i>
                                            <p className="mt-2 text-sm">Đang tải danh sách đơn...</p>
                                        </div>
                                    ) : repOrders.length === 0 ? (
                                        <div className="text-center py-8 text-gray-400 italic text-sm">Không có đơn hàng nào.</div>
                                    ) : (
                                        <div className="overflow-x-auto border rounded-lg max-h-[50vh] overflow-y-auto">
                                            <table className="min-w-full divide-y divide-gray-200 text-sm">
                                                <thead className="bg-gray-100 sticky top-0">
                                                    <tr>
                                                        <th className="px-3 py-2 text-left text-xs font-bold text-gray-600">#</th>
                                                        <th className="px-3 py-2 text-left text-xs font-bold text-gray-600">Mã đơn</th>
                                                        <th className="px-3 py-2 text-left text-xs font-bold text-gray-600">Khách hàng</th>
                                                        <th className="px-3 py-2 text-right text-xs font-bold text-gray-600">Doanh số</th>
                                                        <th className="px-3 py-2 text-center text-xs font-bold text-gray-600">Trạng thái</th>
                                                        <th className="px-3 py-2 text-center text-xs font-bold text-gray-600">Ngày tạo</th>
                                                        <th className="px-3 py-2 text-center text-xs font-bold text-gray-600">Hoàn thành</th>
                                                    </tr>
                                                </thead>
                                                <tbody className="divide-y divide-gray-100">
                                                    {repOrders.map((order: any, idx: number) => (
                                                        <tr key={order.id} className="hover:bg-gray-50">
                                                            <td className="px-3 py-2 text-gray-400">{idx + 1}</td>
                                                            <td className="px-3 py-2 font-medium text-gray-800">{order.order_code}</td>
                                                            <td className="px-3 py-2 text-gray-600">{order.customer?.name || '-'}</td>
                                                            <td className="px-3 py-2 text-right font-medium text-gray-800">{order.total_amount_pre_vat?.toLocaleString('vi-VN')} đ</td>
                                                            <td className="px-3 py-2 text-center">
                                                                <span className={`px-2 py-0.5 rounded-full text-xs font-medium ${
                                                                    order.status === 'Đã hoàn thành' ? 'bg-green-100 text-green-700' :
                                                                    order.status === 'Đang xử lý' ? 'bg-blue-100 text-blue-700' :
                                                                    'bg-gray-100 text-gray-600'
                                                                }`}>
                                                                    {order.status}
                                                                </span>
                                                            </td>
                                                            <td className="px-3 py-2 text-center text-gray-500">
                                                                {new Date(order.created_at).toLocaleDateString('vi-VN')}
                                                            </td>
                                                            <td className="px-3 py-2 text-center text-gray-500">
                                                                {order.completed_at ? new Date(order.completed_at).toLocaleDateString('vi-VN') : <span className="text-gray-300">-</span>}
                                                            </td>
                                                        </tr>
                                                    ))}
                                                </tbody>
                                                <tfoot className="bg-gray-50 border-t-2">
                                                    <tr className="font-bold">
                                                        <td colSpan={3} className="px-3 py-2 text-right text-gray-600">Tổng ({repOrders.length} đơn):</td>
                                                        <td className="px-3 py-2 text-right text-pink-700">
                                                            {repOrders.reduce((sum: number, o: any) => sum + (o.total_amount_pre_vat || 0), 0).toLocaleString('vi-VN')} đ
                                                        </td>
                                                        <td colSpan={3}></td>
                                                    </tr>
                                                </tfoot>
                                            </table>
                                        </div>
                                    )}
                                </div>
                            )}

                            <div className="mt-6 pt-4 border-t flex justify-end">
                                <button
                                    onClick={() => setSelectedItem(null)}
                                    className="px-4 py-2 bg-gray-100 hover:bg-gray-200 text-gray-700 rounded font-medium"
                                >
                                    Đóng
                                </button>
                            </div>

                        </div>
                    </div>
                )}
            </div>
        </div >
    );
};

export default SalesCommissionModal;
