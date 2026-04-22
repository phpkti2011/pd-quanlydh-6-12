
import React, { useState, useEffect } from 'react';
import { commissionService } from '../../services/commissionService';
import { StaffCommissionResult, ProductionTierSummary } from '../../types';

interface DetailItem {
    order_code: string;
    stage: string;
    started_at: string;
    finished_at: string;
    score: number;
    participant_count: number;
    process_comm: number;
    stage_comm: number;
    total_comm: number;
}

interface Props {
    isOpen: boolean;
    onClose: () => void;
    currentUserRole?: string;
    currentUserName?: string;
}

const STAGE_NAMES: Record<string, string> = {
    'Moi': 'Mới tạo',
    'TiepNhan': 'Tiếp nhận',
    'NhanFile': 'Nhận File',
    'XuLyFile': 'Xử lý File',
    'BinhFile': 'Bình File',
    'In': 'In ấn',
    'ThanhPham': 'Thành phẩm',
    'DongGoi': 'Đóng gói',
    'ChoGiaoHang': 'Chờ giao hàng',
    'GiaoHang': 'Giao hàng',
    'HoanThanh': 'Hoàn thành',
    'ThietKe': 'Thiết kế',
    'InKhoLon': 'In khổ lớn',
    'BeDemi': 'Bế Demi',
    'GiaCongNgoai': 'Gia công ngoài',
    'EpKim': 'Ép kim',
    'CanMang': 'Cán màng'
};

import { StageCommissionConfig } from './StageCommissionConfig'; // Import Config Component

const StaffCommissionModal: React.FC<Props> = ({ isOpen, onClose, currentUserRole, currentUserName }) => {
    const [activeTab, setActiveTab] = useState<'report' | 'config'>('report'); // Tab State
    const [startDate, setStartDate] = useState('');
    const [endDate, setEndDate] = useState('');
    const [selectedMonth, setSelectedMonth] = useState(new Date().getMonth() + 1);
    const [selectedYear, setSelectedYear] = useState(new Date().getFullYear());
    const [results, setResults] = useState<StaffCommissionResult[]>([]);
    const [tierSummary, setTierSummary] = useState<ProductionTierSummary | null>(null);
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState<string | null>(null);

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

    // Expansion State
    const [expandedUser, setExpandedUser] = useState<string | null>(null);
    const [details, setDetails] = useState<DetailItem[]>([]);
    const [loadingDetails, setLoadingDetails] = useState(false);

    // Props from parent: currentUserRole, currentUserName
    const isAdmin = currentUserRole === 'Admin' || currentUserRole === 'KeToan' || currentUserRole === 'QuanLySanXuat';
    // Only Admin can configure
    const canConfigure = currentUserRole === 'Admin' || currentUserRole === 'KeToan';

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
            setExpandedUser(null);
            setDetails([]);
            setActiveTab('report');
        }
    }, [isOpen]);

    const handleCalculate = async () => {
        setLoading(true);
        setError(null);
        try {
            // If not admin, force userName filter
            const filterName = isAdmin ? undefined : currentUserName;

            const [data, summary] = await Promise.all([
                commissionService.calculateStaffCommission(startDate, endDate, filterName),
                commissionService.getProductionCommissionSummary(selectedMonth, selectedYear)
            ]);
            setResults(data);
            setTierSummary(summary);
        } catch (err: any) {
            setError(err.message || 'Lỗi khi tính toán.');
        } finally {
            setLoading(false);
        }
    };

    const handleExpand = async (userName: string) => {
        if (expandedUser === userName) {
            setExpandedUser(null);
            setDetails([]);
            return;
        }

        setExpandedUser(userName);
        setLoadingDetails(true);
        try {
            const data = await commissionService.getStaffActivityDetails(startDate, endDate, userName);
            setDetails(data);
        } catch (err) {
            console.error("Error loading details:", err);
            setDetails([]);
        } finally {
            setLoadingDetails(false);
        }
    };

    if (!isOpen) return null;

    return (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-50">
            <div className="bg-white rounded-lg shadow-xl w-full max-w-4xl p-6 relative max-h-[90vh] overflow-y-auto">
                <button
                    onClick={onClose}
                    className="absolute top-4 right-4 text-gray-400 hover:text-gray-600"
                >
                    <i className="fa-solid fa-times text-xl"></i>
                </button>

                <h2 className="text-xl font-bold mb-4 text-purple-700 flex items-center justify-between">
                    <span>
                        <i className="fa-solid fa-gift mr-2"></i>
                        Thưởng Nhân Viên Sản Xuất
                    </span>
                </h2>

                {/* Tabs */}
                {canConfigure && (
                    <div className="flex border-b border-gray-200 mb-4">
                        <button
                            className={`py-2 px-4 font-medium text-sm border-b-2 transition-colors ${activeTab === 'report' ? 'border-purple-600 text-purple-700' : 'border-transparent text-gray-500 hover:text-gray-700'}`}
                            onClick={() => setActiveTab('report')}
                        >
                            Báo cáo
                        </button>
                        <button
                            className={`py-2 px-4 font-medium text-sm border-b-2 transition-colors ${activeTab === 'config' ? 'border-purple-600 text-purple-700' : 'border-transparent text-gray-500 hover:text-gray-700'}`}
                            onClick={() => setActiveTab('config')}
                        >
                            Cấu hình
                        </button>
                    </div>
                )}

                {/* Tab Content: CONFIG */}
                {activeTab === 'config' && (
                    <StageCommissionConfig />
                )}

                {/* Tab Content: REPORT */}
                {activeTab === 'report' && (
                    <>
                        <div className="flex flex-wrap gap-4 mb-6 items-end border-b pb-4">
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
                                    className="px-3 py-2 border rounded-md focus:ring-purple-500 focus:border-purple-500 bg-white"
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
                                    className="px-3 py-2 border rounded-md focus:ring-purple-500 focus:border-purple-500 bg-white"
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
                                    className="px-3 py-2 border rounded-md focus:ring-purple-500 focus:border-purple-500"
                                />
                            </div>
                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-1">Đến ngày</label>
                                <input
                                    type="date"
                                    value={endDate}
                                    onChange={e => setEndDate(e.target.value)}
                                    className="px-3 py-2 border rounded-md focus:ring-purple-500 focus:border-purple-500"
                                />
                            </div>
                            <button
                                onClick={handleCalculate}
                                disabled={loading}
                                className={`px-4 py-2 rounded-md text-white font-medium ${loading ? 'bg-gray-400' : 'bg-purple-600 hover:bg-purple-700'
                                    }`}
                            >
                                {loading ? <i className="fa-solid fa-spinner fa-spin"></i> : <><i className="fa-solid fa-calculator mr-1"></i> Tính toán</>}
                            </button>
                        </div>

                        {error && (
                            <div className="mb-4 p-3 bg-red-100 text-red-700 rounded text-sm">
                                {error}
                            </div>
                        )}

                        {/* Production Tier Banner */}
                        {tierSummary && results.length > 0 && (
                            <div className="mb-4 rounded-lg border-2 border-purple-200 bg-purple-50 overflow-hidden">
                                {/* Header: Revenue & Current Tier */}
                                <div className={`p-3 flex items-center justify-between ${
                                    tierSummary.current_tier_pct >= 150 ? 'bg-green-50 border-b border-green-200 text-green-700' :
                                    tierSummary.current_tier_pct >= 100 ? 'bg-blue-50 border-b border-blue-200 text-blue-700' :
                                    tierSummary.current_tier_pct >= 70 ? 'bg-orange-50 border-b border-orange-200 text-orange-700' :
                                    'bg-red-50 border-b border-red-200 text-red-700'
                                }`}>
                                    <div className="flex items-center gap-3">
                                        <i className="fa-solid fa-chart-line text-lg"></i>
                                        <div>
                                            <p className="text-sm font-medium">
                                                Doanh số đơn hoàn thành tháng {selectedMonth}: <strong>{(tierSummary.total_revenue / 1000000).toFixed(0)} triệu</strong> (chưa VAT)
                                            </p>
                                            {tierSummary.next_tier_threshold && (
                                                <p className="text-xs opacity-75 mt-0.5">
                                                    Mốc tiếp: {(tierSummary.next_tier_threshold / 1000000).toFixed(0)} triệu → {tierSummary.next_tier_pct}%
                                                    {' '}(còn thiếu {((tierSummary.next_tier_threshold - tierSummary.total_revenue) / 1000000).toFixed(0)} triệu)
                                                </p>
                                            )}
                                        </div>
                                    </div>
                                    <div className="text-right">
                                        <span className="text-2xl font-bold">×{tierSummary.current_tier_pct}%</span>
                                        {tierSummary.current_tier_pct === 0 && (
                                            <p className="text-xs font-medium">Chưa đạt mốc</p>
                                        )}
                                    </div>
                                </div>
                                {/* All Tiers */}
                                {tierSummary.all_tiers && tierSummary.all_tiers.length > 0 && (
                                    <div className="px-3 py-2">
                                        <p className="text-xs font-bold text-purple-700 mb-1.5">Các mốc thưởng hoa hồng sản xuất:</p>
                                        <div className="flex flex-wrap gap-2">
                                            {/* Below min = 0% */}
                                            <span className={`text-xs px-2 py-1 rounded-full border ${
                                                tierSummary.current_tier_pct === 0
                                                    ? 'bg-red-100 border-red-300 text-red-700 font-bold ring-2 ring-red-300'
                                                    : 'bg-gray-100 border-gray-200 text-gray-500'
                                            }`}>
                                                &lt;{(Math.min(...tierSummary.all_tiers.map((t: any) => t.min)) / 1000000).toFixed(0)}tr: 0%
                                            </span>
                                            {tierSummary.all_tiers.map((tier: any, idx: number) => {
                                                const isActive = tierSummary.total_revenue >= tier.min && (tier.max === null || tierSummary.total_revenue < tier.max);
                                                const maxLabel = tier.max ? `${(tier.max / 1000000).toFixed(0)}tr` : '∞';
                                                return (
                                                    <span key={idx} className={`text-xs px-2 py-1 rounded-full border ${
                                                        isActive
                                                            ? tier.rate >= 150 ? 'bg-green-100 border-green-300 text-green-700 font-bold ring-2 ring-green-300'
                                                            : tier.rate >= 100 ? 'bg-blue-100 border-blue-300 text-blue-700 font-bold ring-2 ring-blue-300'
                                                            : 'bg-orange-100 border-orange-300 text-orange-700 font-bold ring-2 ring-orange-300'
                                                            : 'bg-gray-100 border-gray-200 text-gray-500'
                                                    }`}>
                                                        {(tier.min / 1000000).toFixed(0)}tr - {maxLabel}: {tier.rate}%
                                                        {isActive && ' ✓'}
                                                    </span>
                                                );
                                            })}
                                        </div>
                                    </div>
                                )}
                            </div>
                        )}

                        <div className="overflow-x-auto">
                            <table className="min-w-full divide-y divide-gray-200">
                                <thead className="bg-gray-50">
                                    <tr>
                                        <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Tên NV</th>
                                        <th className="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">Thưởng CV Chính</th>
                                        <th className="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">Thưởng CV Phụ</th>
                                        <th className="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider">Hệ số</th>
                                        <th className="px-6 py-3 text-right text-xs font-bold text-gray-700 uppercase tracking-wider">Tổng Thưởng</th>
                                    </tr>
                                </thead>
                                <tbody className="bg-white divide-y divide-gray-200">
                                    {results.length > 0 ? (
                                        results.map((item, index) => (
                                            <React.Fragment key={index}>
                                                <tr
                                                    className={`hover:bg-gray-50 cursor-pointer transition-colors ${expandedUser === item.participant_name ? 'bg-purple-50' : ''}`}
                                                    onClick={() => handleExpand(item.participant_name)}
                                                >
                                                    <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900 flex items-center gap-2">
                                                        <i className={`fa-solid fa-chevron-${expandedUser === item.participant_name ? 'down' : 'right'} text-gray-400 text-xs`}></i>
                                                        {item.participant_name}
                                                    </td>
                                                    <td className="px-6 py-4 whitespace-nowrap text-sm text-right text-gray-500">{item.main_task_comm?.toLocaleString('vi-VN')} đ</td>
                                                    <td className="px-6 py-4 whitespace-nowrap text-sm text-right text-blue-600">{item.sub_task_comm?.toLocaleString('vi-VN')} đ</td>
                                                    <td className="px-6 py-4 whitespace-nowrap text-sm text-center">
                                                        {item.tier_percentage != null ? (
                                                            <span className={`inline-block px-2 py-0.5 rounded-full text-xs font-bold ${
                                                                item.tier_percentage >= 150 ? 'bg-green-100 text-green-700' :
                                                                item.tier_percentage >= 100 ? 'bg-blue-100 text-blue-700' :
                                                                item.tier_percentage >= 70 ? 'bg-orange-100 text-orange-700' :
                                                                'bg-red-100 text-red-700'
                                                            }`}>
                                                                ×{item.tier_percentage}%
                                                            </span>
                                                        ) : (
                                                            <span className="text-xs text-gray-400">—</span>
                                                        )}
                                                    </td>
                                                    <td className="px-6 py-4 whitespace-nowrap text-sm text-right text-purple-700 font-bold">{(item.total_comm || 0).toLocaleString('vi-VN')} đ</td>
                                                </tr>
                                                {expandedUser === item.participant_name && (
                                                    <tr>
                                                        <td colSpan={5} className="px-4 py-4 bg-gray-50 border-b border-gray-200">
                                                            <div className="bg-white rounded border border-gray-200 overflow-hidden">
                                                                {loadingDetails ? (
                                                                    <div className="p-4 text-center text-gray-500 text-sm">
                                                                        <i className="fa-solid fa-spinner fa-spin mr-2"></i> Đang tải chi tiết...
                                                                    </div>
                                                                ) : details.length > 0 ? (
                                                                    <table className="min-w-full divide-y divide-gray-100">
                                                                        <thead className="bg-gray-100">
                                                                            <tr>
                                                                                <th className="px-4 py-2 text-left text-[11px] font-bold text-gray-500 uppercase">Mã Đơn</th>
                                                                                <th className="px-4 py-2 text-left text-[11px] font-bold text-gray-500 uppercase">Công Đoạn</th>
                                                                                <th className="px-4 py-2 text-left text-[11px] font-bold text-gray-500 uppercase">Ngày Làm</th>
                                                                                <th className="px-4 py-2 text-center text-[11px] font-bold text-gray-500 uppercase">Số Lượng</th>
                                                                                <th className="px-4 py-2 text-right text-[11px] font-bold text-gray-500 uppercase">Thưởng CV Chính</th>
                                                                                <th className="px-4 py-2 text-right text-[11px] font-bold text-gray-500 uppercase">Thưởng CV Phụ</th>
                                                                                <th className="px-4 py-2 text-right text-[11px] font-bold text-gray-500 uppercase">Tổng</th>
                                                                            </tr>
                                                                        </thead>
                                                                        <tbody className="divide-y divide-gray-100">
                                                                            {details.filter(d => d.stage !== 'Moi').map((d, i) => (
                                                                                <tr key={i} className="hover:bg-gray-50">
                                                                                    <td className="px-4 py-2 text-xs font-medium text-gray-900">{d.order_code}</td>
                                                                                    <td className="px-4 py-2 text-xs text-gray-600">
                                                                                        <span className={`inline-block px-2 py-0.5 rounded text-[10px] font-medium 
                                                                                            ${['ThietKe', 'InKhoLon'].includes(d.stage) ? 'bg-blue-100 text-blue-700' : 'bg-green-100 text-green-700'}`}>
                                                                                            {STAGE_NAMES[d.stage] || d.stage}
                                                                                        </span>
                                                                                    </td>
                                                                                    <td className="px-4 py-2 text-xs text-gray-500">
                                                                                        {new Date(d.started_at).toLocaleDateString('vi-VN')}
                                                                                    </td>
                                                                                    <td className="px-4 py-2 text-center text-xs text-gray-500">{d.participant_count} người</td>
                                                                                    <td className="px-4 py-2 text-right text-xs text-gray-600">{d.process_comm?.toLocaleString()}</td>
                                                                                    <td className="px-4 py-2 text-right text-xs text-blue-600">{d.stage_comm?.toLocaleString()}</td>
                                                                                    <td className="px-4 py-2 text-right text-xs font-bold text-purple-700">{(d.process_comm + d.stage_comm).toLocaleString()}</td>
                                                                                </tr>
                                                                            ))}
                                                                        </tbody>
                                                                    </table>
                                                                ) : (
                                                                    <div className="p-4 text-center text-gray-500 text-xs italic">
                                                                        Không tìm thấy dữ liệu chi tiết.
                                                                    </div>
                                                                )}
                                                            </div>
                                                        </td>
                                                    </tr>
                                                )}
                                            </React.Fragment>
                                        ))
                                    ) : (
                                        <tr>
                                            <td colSpan={5} className="px-6 py-8 text-center text-gray-500">
                                                {loading ? 'Đang tính toán...' : 'Chưa có dữ liệu. Vui lòng chọn thời gian và bấm "Tính toán".'}
                                            </td>
                                        </tr>
                                    )}
                                </tbody>
                                {results.length > 0 && (
                                    <tfoot className="bg-gray-100 font-bold">
                                        <tr>
                                            <td className="px-6 py-3">Tổng cộng</td>
                                            <td className="px-6 py-3 text-right">{results.reduce((sum, i) => sum + (i.main_task_comm || 0), 0).toLocaleString('vi-VN')} đ</td>
                                            <td className="px-6 py-3 text-right">{results.reduce((sum, i) => sum + (i.sub_task_comm || 0), 0).toLocaleString('vi-VN')} đ</td>
                                            <td className="px-6 py-3"></td>
                                            <td className="px-6 py-3 text-right text-purple-700">{results.reduce((sum, i) => sum + (i.total_comm || 0), 0).toLocaleString('vi-VN')} đ</td>
                                        </tr>
                                    </tfoot>
                                )}
                            </table>
                        </div>

                        <div className="mt-6 border-t border-gray-100 pt-4 text-xs text-gray-500">
                            <h4 className="font-bold text-gray-700 mb-2 uppercase">Ghi chú tính thưởng:</h4>
                            <div className="space-y-1">
                                <p><strong className="text-gray-900">1. Thưởng Quy Trình Chính (Bình File, In, Thành Phẩm...):</strong></p>
                                <p className="pl-3 font-mono text-gray-600 bg-gray-50 inline-block rounded px-1 py-0.5 mb-1">
                                    (Doanh thu đơn hàng / Số người làm) × Tỉ lệ Commission (từ Cấu hình) × Điểm năng lực
                                </p>
                                <p><strong className="text-gray-900">2. Thưởng Công Đoạn Phụ (Thiết kế, In khổ lớn, Ép kim...):</strong></p>
                                <p className="pl-3 font-mono text-gray-600 bg-gray-50 inline-block rounded px-1 py-0.5">
                                    Phí dịch vụ (hoặc Doanh thu) × Tỉ lệ Commission
                                </p>
                                <p><strong className="text-gray-900">3. Hoa Hồng Sản Xuất (Hệ số mốc doanh số):</strong></p>
                                <p className="pl-3 font-mono text-gray-600 bg-gray-50 inline-block rounded px-1 py-0.5 mb-1">
                                    Thưởng thực nhận = (Thưởng CV Chính + Thưởng CV Phụ) × Hệ số mốc doanh số công ty
                                </p>
                                <p className="mt-2 text-[10px] italic">* Tỉ lệ Commission được ưu tiên lấy theo cấu hình Cá Nhân, nếu không có sẽ lấy theo cấu hình Chung.</p>
                            </div>
                        </div>
                    </>
                )}
            </div>
        </div>
    );
};

export default StaffCommissionModal;
