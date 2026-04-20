
import React, { useState, useEffect } from 'react';
import { commissionService } from '../../services/commissionService';
import { supabase } from '../../services/supabaseClient';

interface Props {
    isOpen: boolean;
    onClose: () => void;
    currentUserRole?: string;
    currentUserName?: string;
}

interface ActivityDetail {
    user_name: string;
    order_code: string;
    stage: string;
    started_at: string;
    finished_at?: string;
    score: number;
    participant_count: number;
    process_comm: number;
    stage_comm: number;
    total_comm: number;
}

// Stage name translations
const STAGE_NAMES: Record<string, string> = {
    'Moi': 'Mới tạo',
    'TiepNhan': 'Tiếp nhận',
    'NhanFile': 'Nhận file',
    'XuLyFile': 'Xử lý file',
    'BinhFile': 'Bình file',
    'In': 'In',
    'ThanhPham': 'Thành phẩm',
    'DongGoi': 'Đóng gói',
    'ChoGiaoHang': 'Chờ giao hàng',
    'GiaoHang': 'Giao hàng',
    'HoanThanh': 'Hoàn thành',
    'ThietKe': 'Thiết kế',
    'InKhoLon': 'In khổ lớn',
    'BeDemi': 'Bế Demi',
    'GiaCongNgoai': 'Gia công ngoài',
    'EpKim': 'Ép kim'
};

const ActivityReportModal: React.FC<Props> = ({ isOpen, onClose, currentUserRole, currentUserName }) => {
    const [startDate, setStartDate] = useState('');
    const [endDate, setEndDate] = useState('');
    const [selectedMonth, setSelectedMonth] = useState(new Date().getMonth() + 1);
    const [selectedYear, setSelectedYear] = useState(new Date().getFullYear());
    const [results, setResults] = useState<ActivityDetail[]>([]);
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState<string | null>(null);
    const [users, setUsers] = useState<any[]>([]);
    const [selectedUser, setSelectedUser] = useState<string>('');

    const isAdmin = currentUserRole === 'Admin' || currentUserRole === 'KeToan' || currentUserRole === 'QuanLySanXuat';

    // Helper to update dates from Month/Year selection
    const toLocalISO = (d: Date) => {
        const year = d.getFullYear();
        const month = String(d.getMonth() + 1).padStart(2, '0');
        const day = String(d.getDate()).padStart(2, '0');
        return `${year}-${month}-${day}`;
    };

    const updateDatesFromMonthYear = (month: number, year: number) => {
        const firstDay = new Date(year, month - 1, 1);
        const lastDay = new Date(year, month, 0);
        setStartDate(toLocalISO(firstDay));
        setEndDate(toLocalISO(lastDay));
    };


    useEffect(() => {
        if (isOpen) {
            const date = new Date();
            const currentMonth = date.getMonth() + 1;
            const currentYear = date.getFullYear();

            setSelectedMonth(currentMonth);
            setSelectedYear(currentYear);
            updateDatesFromMonthYear(currentMonth, currentYear);

            setResults([]);
            setError(null);

            // If not admin, force selectedUser to current user
            if (!isAdmin && currentUserName) {
                setSelectedUser(currentUserName);
            } else {
                // Fetch users for filter (only if admin)
                const fetchUsers = async () => {
                    const { data } = await supabase.from('profiles').select('full_name').order('full_name');
                    if (data) setUsers(data);
                };
                fetchUsers();
            }
        }
    }, [isOpen, isAdmin, currentUserName]);

    const handleCalculate = async () => {
        setLoading(true);
        setError(null);
        try {
            // For non-admin, selectedUser is already set in effect, but ensure uniqueness
            const userToQuery = isAdmin ? selectedUser : currentUserName;

            const data = await commissionService.getStaffActivityDetails(startDate, endDate, userToQuery || undefined);
            setResults(data as ActivityDetail[]);
        } catch (err: any) {
            setError(err.message || 'Lỗi khi tải báo cáo.');
        } finally {
            setLoading(false);
        }
    };

    if (!isOpen) return null;

    return (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-50">
            <div className="bg-white rounded-lg shadow-xl w-full max-w-6xl p-6 relative max-h-[90vh] overflow-y-auto">
                <button
                    onClick={onClose}
                    className="absolute top-4 right-4 text-gray-400 hover:text-gray-600"
                >
                    <i className="fa-solid fa-times text-xl"></i>
                </button>

                <h2 className="text-xl font-bold mb-4 text-teal-700">
                    <i className="fa-solid fa-chart-pie mr-2"></i>
                    Báo Cáo Hoạt Động Sản Xuất (Chi tiết)
                </h2>

                <div className="flex flex-wrap gap-4 mb-6 items-end border-b pb-4 bg-gray-50 p-4 rounded">
                    {/* Month/Year Quick Select */}
                    <div>
                        <label className="block text-sm font-medium text-gray-700 mb-1">Tháng</label>
                        <select
                            value={selectedMonth}
                            onChange={e => {
                                const m = parseInt(e.target.value);
                                setSelectedMonth(m);
                                updateDatesFromMonthYear(m, selectedYear);
                            }}
                            className="px-3 py-2 border rounded-md focus:ring-teal-500 focus:border-teal-500 bg-white"
                        >
                            {[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12].map(m => (
                                <option key={m} value={m}>Tháng {m}</option>
                            ))}
                        </select>
                    </div>
                    <div>
                        <label className="block text-sm font-medium text-gray-700 mb-1">Năm</label>
                        <select
                            value={selectedYear}
                            onChange={e => {
                                const y = parseInt(e.target.value);
                                setSelectedYear(y);
                                updateDatesFromMonthYear(selectedMonth, y);
                            }}
                            className="px-3 py-2 border rounded-md focus:ring-teal-500 focus:border-teal-500 bg-white"
                        >
                            {[2024, 2025, 2026, 2027, 2028, 2029, 2030].map(y => (
                                <option key={y} value={y}>{y}</option>
                            ))}
                        </select>
                    </div>
                    <div>
                        <label className="block text-sm font-medium text-gray-700 mb-1">Từ ngày</label>
                        <input
                            type="date"
                            value={startDate}
                            onChange={e => setStartDate(e.target.value)}
                            className="px-3 py-2 border rounded-md focus:ring-teal-500 focus:border-teal-500"
                        />
                    </div>
                    <div>
                        <label className="block text-sm font-medium text-gray-700 mb-1">Đến ngày</label>
                        <input
                            type="date"
                            value={endDate}
                            onChange={e => setEndDate(e.target.value)}
                            className="px-3 py-2 border rounded-md focus:ring-teal-500 focus:border-teal-500"
                        />
                    </div>
                    <div>
                        <label className="block text-sm font-medium text-gray-700 mb-1">Nhân viên</label>
                        {isAdmin ? (
                            <select
                                value={selectedUser}
                                onChange={e => setSelectedUser(e.target.value)}
                                className="px-3 py-2 border rounded-md focus:ring-teal-500 focus:border-teal-500 min-w-[200px]"
                            >
                                <option value="">-- Tất cả --</option>
                                {users.map((u, idx) => (
                                    <option key={idx} value={u.full_name}>{u.full_name}</option>
                                ))}
                            </select>
                        ) : (
                            <input
                                type="text"
                                value={currentUserName || ''}
                                disabled
                                className="px-3 py-2 border rounded-md bg-gray-100 text-gray-500 min-w-[200px]"
                            />
                        )}
                    </div>
                    <button
                        onClick={handleCalculate}
                        disabled={loading}
                        className={`px-4 py-2 rounded-md text-white font-medium ${loading ? 'bg-gray-400' : 'bg-teal-600 hover:bg-teal-700'
                            }`}
                    >
                        {loading ? <i className="fa-solid fa-spinner fa-spin"></i> : <><i className="fa-solid fa-filter mr-1"></i> Xem Báo Cáo</>}
                    </button>
                </div>

                {error && (
                    <div className="mb-4 p-3 bg-red-100 text-red-700 rounded text-sm">
                        {error}
                    </div>
                )}

                {/* Summary Statistics by Stage */}
                {results.filter(item => item.stage !== 'Moi').length > 0 && (
                    <div className="mb-6 p-4 bg-gradient-to-r from-teal-50 to-green-50 rounded-lg border border-teal-200">
                        <h3 className="text-lg font-bold text-teal-800 mb-3">
                            <i className="fa-solid fa-chart-bar mr-2"></i>
                            Thống kê theo công đoạn
                        </h3>
                        <div className="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-6 gap-3">
                            {(() => {
                                const filteredResults = results.filter(item => item.stage !== 'Moi');
                                const stageStats = filteredResults.reduce((acc, item) => {
                                    const stageName = STAGE_NAMES[item.stage] || item.stage;
                                    if (!acc[stageName]) {
                                        acc[stageName] = { count: 0, orders: new Set() };
                                    }
                                    acc[stageName].count++;
                                    acc[stageName].orders.add(item.order_code);
                                    return acc;
                                }, {} as Record<string, { count: number; orders: Set<string> }>);

                                return Object.entries(stageStats)
                                    .sort((a, b) => (b[1] as { count: number }).count - (a[1] as { count: number }).count)
                                    .map(([stage, s]) => {
                                        const stats = s as { count: number; orders: Set<string> };
                                        return (
                                            <div key={stage} className="bg-white p-3 rounded-lg shadow-sm border border-gray-100 hover:shadow-md transition-shadow">
                                                <div className="text-xs text-gray-500 font-medium uppercase tracking-wide">{stage}</div>
                                                <div className="flex items-baseline gap-2 mt-1">
                                                    <span className="text-2xl font-bold text-teal-700">{stats.orders.size}</span>
                                                    <span className="text-xs text-gray-400">đơn</span>
                                                </div>
                                                <div className="text-xs text-gray-500 mt-1">
                                                    {stats.count} lần thực hiện
                                                </div>
                                            </div>
                                        );
                                    });
                            })()}
                        </div>

                        {/* Total Summary */}
                        <div className="mt-4 pt-3 border-t border-teal-200 flex flex-wrap gap-6 text-sm">
                            <div className="flex items-center gap-2">
                                <span className="text-gray-600">Tổng số đơn:</span>
                                <span className="font-bold text-teal-800">
                                    {new Set(results.filter(item => item.stage !== 'Moi').map(r => r.order_code)).size}
                                </span>
                            </div>
                            <div className="flex items-center gap-2">
                                <span className="text-gray-600">Tổng lần thực hiện:</span>
                                <span className="font-bold text-teal-800">
                                    {results.filter(item => item.stage !== 'Moi').length}
                                </span>
                            </div>
                        </div>
                    </div>
                )}

                <div className="overflow-x-auto">
                    <table className="min-w-full divide-y divide-gray-200 border text-sm">
                        <thead className="bg-teal-50">
                            <tr>
                                <th className="px-4 py-3 text-left font-bold text-teal-800">Thời gian</th>
                                <th className="px-4 py-3 text-left font-bold text-teal-800">Mã Đơn</th>
                                <th className="px-4 py-3 text-left font-bold text-teal-800">Công đoạn</th>
                                <th className="px-4 py-3 text-left font-bold text-teal-800">Nhân viên</th>
                                <th className="px-4 py-3 text-center font-bold text-teal-800" title="Số người cùng làm">Số người</th>
                                <th className="px-4 py-3 text-center font-bold text-teal-800">Điểm NL</th>
                                <th className="px-4 py-3 text-right font-bold text-teal-800">Thưởng QT</th>
                                <th className="px-4 py-3 text-right font-bold text-teal-800">Thưởng CĐ</th>
                                <th className="px-4 py-3 text-right font-bold text-teal-800">Tổng</th>
                            </tr>
                        </thead>
                        <tbody className="bg-white divide-y divide-gray-200">
                            {results.length > 0 ? (
                                results
                                    .filter(item => item.stage !== 'Moi') // Filter out technical "Moi" stage
                                    .map((item, index) => (
                                        <tr key={index} className="hover:bg-gray-50">
                                            <td className="px-4 py-2 text-gray-600">
                                                {new Date(item.started_at).toLocaleString('vi-VN')}
                                            </td>
                                            <td className="px-4 py-2 font-medium text-gray-900">{item.order_code}</td>
                                            <td className="px-4 py-2 text-gray-700">
                                                <span className={`px-2 py-0.5 rounded text-xs font-bold ${item.stage === 'ThietKe' ? 'bg-purple-100 text-purple-700' :
                                                    item.stage === 'In' ? 'bg-blue-100 text-blue-700' :
                                                        item.stage === 'BinhFile' ? 'bg-indigo-100 text-indigo-700' :
                                                            'bg-gray-100 text-gray-700'
                                                    }`}>
                                                    {STAGE_NAMES[item.stage] || item.stage}
                                                </span>
                                            </td>
                                            <td className="px-4 py-2 font-bold text-gray-800">{item.user_name}</td>
                                            <td className="px-4 py-2 text-center text-gray-600">{item.participant_count}</td>
                                            <td className="px-4 py-2 text-center text-gray-600">{item.score}</td>
                                            <td className="px-4 py-2 text-right text-gray-500">{item.process_comm?.toLocaleString('vi-VN')}</td>
                                            <td className="px-4 py-2 text-right text-blue-600">{item.stage_comm?.toLocaleString('vi-VN')}</td>
                                            <td className="px-4 py-2 text-right font-bold text-teal-700">{item.total_comm?.toLocaleString('vi-VN')}</td>
                                        </tr>
                                    ))
                            ) : (
                                <tr>
                                    <td colSpan={9} className="px-6 py-8 text-center text-gray-500">
                                        {loading ? 'Đang tải dữ liệu...' : 'Không có dữ liệu trong khoảng thời gian này.'}
                                    </td>
                                </tr>
                            )}
                        </tbody>
                        {results.filter(item => item.stage !== 'Moi').length > 0 && (
                            <tfoot className="bg-gray-50 font-bold">
                                <tr>
                                    <td colSpan={6} className="px-4 py-3 text-right">Tổng cộng:</td>
                                    <td className="px-4 py-3 text-right">{results.filter(item => item.stage !== 'Moi').reduce((s, i) => s + (i.process_comm || 0), 0).toLocaleString('vi-VN')}</td>
                                    <td className="px-4 py-3 text-right">{results.filter(item => item.stage !== 'Moi').reduce((s, i) => s + (i.stage_comm || 0), 0).toLocaleString('vi-VN')}</td>
                                    <td className="px-4 py-3 text-right text-teal-700">{results.filter(item => item.stage !== 'Moi').reduce((s, i) => s + (i.total_comm || 0), 0).toLocaleString('vi-VN')}</td>
                                </tr>
                            </tfoot>
                        )}
                    </table>
                </div>
            </div>
        </div>
    );
};

export default ActivityReportModal;
