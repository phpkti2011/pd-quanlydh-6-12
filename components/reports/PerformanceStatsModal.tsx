
import React, { useState, useEffect } from 'react';
import { commissionService } from '../../services/commissionService';

interface Props {
    isOpen: boolean;
    onClose: () => void;
    currentUserRole?: string;
    currentUserName?: string;
}

// ... PerformanceStat interface ...

interface PerformanceStat {
    user_name: string;
    total_participation: number; // logs count
    total_orders: number; // distinct orders
    total_process_comm: number;
    total_stage_comm: number;
    total_revenue_generated: number;
}

const PerformanceStatsModal: React.FC<Props> = ({ isOpen, onClose, currentUserRole, currentUserName }) => {
    const [startDate, setStartDate] = useState('');
    const [endDate, setEndDate] = useState('');
    const [stats, setStats] = useState<PerformanceStat[]>([]);
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState<string | null>(null);

    const isAdmin = currentUserRole === 'Admin' || currentUserRole === 'KeToan' || currentUserRole === 'QuanLySanXuat';

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
            // Server-side filtering
            const filterName = isAdmin ? undefined : currentUserName;
            const data = await commissionService.getPerformanceStats(start, end, filterName);

            // Client-side filtering as backup (or removed if server side is enough)
            // But let's keep it consistent with server data.
            setStats(data as PerformanceStat[]);
        } catch (err: any) {
            setError(err.message || 'Lỗi khi tải thống kê.');
        } finally {
            setLoading(false);
        }
    };

    if (!isOpen) return null;

    // Totals for top cards
    const totalOrdersProcessed = stats.reduce((sum, s) => sum + s.total_orders, 0); // Note: This might double count if 2 people on same order
    // Better metric: Sum of revenues (as it's split adjusted)
    const totalRevenueGenerated = stats.reduce((sum, s) => sum + s.total_revenue_generated, 0);

    return (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-50">
            <div className="bg-white rounded-lg shadow-xl w-full max-w-5xl p-6 relative max-h-[90vh] overflow-y-auto">
                <button
                    onClick={onClose}
                    className="absolute top-4 right-4 text-gray-400 hover:text-gray-600"
                >
                    <i className="fa-solid fa-times text-xl"></i>
                </button>

                <h2 className="text-xl font-bold mb-4 text-orange-700">
                    <i className="fa-solid fa-person-digging mr-2"></i>
                    Thống Kê Hiệu Suất Sản Xuất
                </h2>

                {/* Filter */}
                <div className="flex flex-wrap gap-4 mb-6 items-end border-b pb-4 bg-gray-50 p-4 rounded">
                    <div>
                        <label className="block text-sm font-medium text-gray-700 mb-1">Từ ngày</label>
                        <input
                            type="date"
                            value={startDate}
                            onChange={e => setStartDate(e.target.value)}
                            className="px-3 py-2 border rounded-md focus:ring-orange-500 focus:border-orange-500"
                        />
                    </div>
                    <div>
                        <label className="block text-sm font-medium text-gray-700 mb-1">Đến ngày</label>
                        <input
                            type="date"
                            value={endDate}
                            onChange={e => setEndDate(e.target.value)}
                            className="px-3 py-2 border rounded-md focus:ring-orange-500 focus:border-orange-500"
                        />
                    </div>
                    <button
                        onClick={() => handleCalculate()}
                        disabled={loading}
                        className={`px-4 py-2 rounded-md text-white font-medium ${loading ? 'bg-gray-400' : 'bg-orange-600 hover:bg-orange-700'
                            }`}
                    >
                        {loading ? <i className="fa-solid fa-spinner fa-spin"></i> : <><i className="fa-solid fa-filter mr-1"></i> Xem Thống Kê</>}
                    </button>
                </div>

                {error && (
                    <div className="mb-4 p-3 bg-red-100 text-red-700 rounded text-sm">
                        {error}
                    </div>
                )}

                {/* Summary Cards */}
                <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
                    <div className="bg-orange-50 p-4 rounded-lg border border-orange-100">
                        <div className="text-orange-800 text-sm font-medium">Tổng Giá Trị Đóng Góp</div>
                        <div className="text-2xl font-bold text-orange-900 mt-1">
                            {totalRevenueGenerated.toLocaleString('vi-VN')} đ
                        </div>
                        <div className="text-xs text-orange-600 mt-1">(Đã chia sẻ theo số người tham gia)</div>
                    </div>
                    <div className="bg-blue-50 p-4 rounded-lg border border-blue-100">
                        <div className="text-blue-800 text-sm font-medium">Tổng Lượt Tham Gia</div>
                        <div className="text-2xl font-bold text-blue-900 mt-1">
                            {stats.reduce((sum, s) => sum + s.total_participation, 0)}
                        </div>
                        <div className="text-xs text-blue-600 mt-1">lượt / công đoạn</div>
                    </div>
                    <div className="bg-green-50 p-4 rounded-lg border border-green-100">
                        <div className="text-green-800 text-sm font-medium">Nhân Sự Dẫn Đầu</div>
                        <div className="text-xl font-bold text-green-900 mt-1 truncate">
                            {stats.length > 0 ? stats[0].user_name : '---'}
                        </div>
                        <div className="text-xs text-green-600 mt-1">
                            {stats.length > 0 ? `${stats[0].total_revenue_generated.toLocaleString('vi-VN')} đ` : ''}
                        </div>
                    </div>
                </div>

                {/* Table */}
                <div className="overflow-x-auto">
                    <table className="min-w-full divide-y divide-gray-200 border text-sm">
                        <thead className="bg-gray-50">
                            <tr>
                                <th className="px-4 py-3 text-left font-bold text-gray-700">Hạng</th>
                                <th className="px-4 py-3 text-left font-bold text-gray-700">Nhân viên</th>
                                <th className="px-4 py-3 text-center font-bold text-gray-700">Số đơn</th>
                                <th className="px-4 py-3 text-center font-bold text-gray-700">Tổng lượt làm</th>
                                <th className="px-4 py-3 text-right font-bold text-gray-700">Giá trị đóng góp</th>
                                <th className="px-4 py-3 text-right font-bold text-gray-700">Hiệu suất / Đơn</th>
                            </tr>
                        </thead>
                        <tbody className="bg-white divide-y divide-gray-200">
                            {stats.length > 0 ? (
                                stats.map((item, index) => (
                                    <tr key={index} className="hover:bg-gray-50">
                                        <td className="px-4 py-3 text-gray-500 w-12 text-center">
                                            {index + 1}
                                        </td>
                                        <td className="px-4 py-3 font-bold text-gray-800">{item.user_name}</td>
                                        <td className="px-4 py-3 text-center text-gray-600">{item.total_orders}</td>
                                        <td className="px-4 py-3 text-center text-gray-600">{item.total_participation}</td>
                                        <td className="px-4 py-3 text-right font-bold text-teal-700">{item.total_revenue_generated.toLocaleString('vi-VN')} đ</td>
                                        <td className="px-4 py-3 text-right text-gray-500">
                                            {item.total_orders > 0
                                                ? Math.round(item.total_revenue_generated / item.total_orders).toLocaleString('vi-VN')
                                                : 0} đ/đơn
                                        </td>
                                    </tr>
                                ))
                            ) : (
                                <tr>
                                    <td colSpan={6} className="px-6 py-8 text-center text-gray-500">
                                        {loading ? 'Đang tính toán...' : 'Chưa có dữ liệu thống kê.'}
                                    </td>
                                </tr>
                            )}
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    );
};

export default PerformanceStatsModal;
