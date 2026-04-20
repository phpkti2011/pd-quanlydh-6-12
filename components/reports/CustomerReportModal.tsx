import React, { useState, useEffect, useMemo } from 'react';
import { customerService } from '../../services/customerService';

// Warning tags that mark a customer as "cần chú ý"
const WARNING_TAGS = ['Khó tính', 'Cần chú ý', 'Chú ý', 'Hay hủy đơn', 'Khiếu nại nhiều'];

type TabKey = 'top_orders' | 'top_revenue' | 'top_cancelled' | 'inactive' | 'duplicates' | 'warning' | 'at_risk';

interface CustomerReportModalProps {
    isOpen: boolean;
    onClose: () => void;
}

type ReportCustomer = Awaited<ReturnType<typeof customerService.getCustomerReportData>>[number];
type DuplicateGroup = Awaited<ReturnType<typeof customerService.getDuplicateCustomers>>[number];

const TABS: { key: TabKey; label: string; icon: string }[] = [
    { key: 'top_orders', label: 'Nhiều đơn nhất', icon: 'fa-box' },
    { key: 'top_revenue', label: 'Doanh số cao nhất', icon: 'fa-sack-dollar' },
    { key: 'top_cancelled', label: 'Hủy đơn nhiều', icon: 'fa-ban' },
    { key: 'inactive', label: 'Lâu không in', icon: 'fa-clock' },
    { key: 'at_risk', label: 'Cần chăm sóc', icon: 'fa-heart-pulse' },
    { key: 'duplicates', label: 'Trùng thông tin', icon: 'fa-clone' },
    { key: 'warning', label: 'KH cần chú ý', icon: 'fa-triangle-exclamation' },
];

const fmt = (n: number) => n.toLocaleString('vi-VN') + 'đ';

const CustomerReportModal: React.FC<CustomerReportModalProps> = ({ isOpen, onClose }) => {
    const [activeTab, setActiveTab] = useState<TabKey>('top_orders');
    const [reportData, setReportData] = useState<ReportCustomer[]>([]);
    const [duplicates, setDuplicates] = useState<DuplicateGroup[]>([]);
    const [loading, setLoading] = useState(false);
    const [inactiveDays, setInactiveDays] = useState(30);
    const [expandedCustomer, setExpandedCustomer] = useState<string | null>(null);
    const [mergeSelection, setMergeSelection] = useState<Record<number, string>>({}); // groupIndex -> primaryId
    const [merging, setMerging] = useState(false);
    const [mergeResult, setMergeResult] = useState<{ success: boolean; message: string } | null>(null);
    const [riskMinRevenue, setRiskMinRevenue] = useState(10_000_000); // 10 triệu

    useEffect(() => {
        if (!isOpen) return;
        loadData();
    }, [isOpen]);

    const loadData = async () => {
        setLoading(true);
        try {
            const [report, dupes] = await Promise.all([
                customerService.getCustomerReportData(),
                customerService.getDuplicateCustomers(),
            ]);
            setReportData(report);
            setDuplicates(dupes);
        } catch (err) {
            console.error('Failed to load customer report', err);
        } finally {
            setLoading(false);
        }
    };

    // Sorted/filtered data per tab
    const topOrders = useMemo(() =>
        [...reportData].filter(c => c.total_orders > 0).sort((a, b) => b.total_orders - a.total_orders).slice(0, 50),
        [reportData]
    );

    const topRevenue = useMemo(() =>
        [...reportData].filter(c => c.total_revenue > 0).sort((a, b) => b.total_revenue - a.total_revenue).slice(0, 50),
        [reportData]
    );

    const topCancelled = useMemo(() =>
        [...reportData].filter(c => c.cancelled_orders > 0).sort((a, b) => b.cancelled_orders - a.cancelled_orders).slice(0, 50),
        [reportData]
    );

    const inactiveCustomers = useMemo(() =>
        [...reportData]
            .filter(c => c.days_since_last_order !== null && c.days_since_last_order >= inactiveDays)
            .sort((a, b) => (b.days_since_last_order || 0) - (a.days_since_last_order || 0)),
        [reportData, inactiveDays]
    );

    const warningCustomers = useMemo(() =>
        reportData.filter(c =>
            c.tags && c.tags.some(tag =>
                WARNING_TAGS.some(wt => tag.toLowerCase().includes(wt.toLowerCase()))
            )
        ),
        [reportData]
    );

    const maxRevenue = useMemo(() => Math.max(...topRevenue.map(c => c.total_revenue), 1), [topRevenue]);
    const maxOrders = useMemo(() => Math.max(...topOrders.map(c => c.total_orders), 1), [topOrders]);

    // At-risk VIP: high revenue + inactive ≥ 30 days
    const atRiskCustomers = useMemo(() =>
        [...reportData]
            .filter(c => c.total_revenue >= riskMinRevenue && c.days_since_last_order !== null && c.days_since_last_order >= 30)
            .sort((a, b) => {
                // Sort by urgency tier first (more days = more urgent), then by revenue
                const aDays = a.days_since_last_order || 0;
                const bDays = b.days_since_last_order || 0;
                const aTier = aDays >= 90 ? 3 : aDays >= 60 ? 2 : 1;
                const bTier = bDays >= 90 ? 3 : bDays >= 60 ? 2 : 1;
                if (bTier !== aTier) return bTier - aTier;
                return b.total_revenue - a.total_revenue;
            }),
        [reportData, riskMinRevenue]
    );

    if (!isOpen) return null;

    const renderRankBadge = (index: number) => {
        const colors = ['bg-yellow-400 text-yellow-900', 'bg-gray-300 text-gray-800', 'bg-orange-300 text-orange-900'];
        if (index < 3) {
            return <span className={`w-7 h-7 rounded-full ${colors[index]} flex items-center justify-center font-black text-sm shadow-sm`}>{index + 1}</span>;
        }
        return <span className="w-7 h-7 rounded-full bg-gray-100 text-gray-500 flex items-center justify-center font-bold text-xs">{index + 1}</span>;
    };

    const renderTable = (data: ReportCustomer[], columns: { label: string; render: (c: ReportCustomer, i: number) => React.ReactNode }[]) => (
        <div className="overflow-x-auto">
            <table className="w-full text-sm">
                <thead>
                    <tr className="bg-gray-50 border-b border-gray-200">
                        <th className="px-3 py-2.5 text-left text-xs font-bold text-gray-500 uppercase w-10">#</th>
                        <th className="px-3 py-2.5 text-left text-xs font-bold text-gray-500 uppercase">Khách hàng</th>
                        {columns.map((col, i) => (
                            <th key={i} className="px-3 py-2.5 text-right text-xs font-bold text-gray-500 uppercase">{col.label}</th>
                        ))}
                    </tr>
                </thead>
                <tbody>
                    {data.map((c, i) => (
                        <tr key={c.id} className={`border-b border-gray-100 hover:bg-gray-50 transition-colors ${i < 3 ? 'bg-yellow-50/30' : ''}`}>
                            <td className="px-3 py-2.5">{renderRankBadge(i)}</td>
                            <td className="px-3 py-2.5">
                                <div className="font-bold text-gray-800">{c.name}</div>
                                <div className="text-xs text-gray-500 flex gap-2">
                                    <span className="font-mono">{c.code}</span>
                                    {c.phone && <><span>•</span><span>{c.phone}</span></>}
                                </div>
                            </td>
                            {columns.map((col, ci) => (
                                <td key={ci} className="px-3 py-2.5 text-right">{col.render(c, i)}</td>
                            ))}
                        </tr>
                    ))}
                    {data.length === 0 && (
                        <tr><td colSpan={columns.length + 2} className="text-center py-8 text-gray-400">Không có dữ liệu</td></tr>
                    )}
                </tbody>
            </table>
        </div>
    );

    return (
        <div className="fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center p-4">
            <div className="bg-white rounded-xl shadow-2xl w-full max-w-7xl h-[85vh] flex flex-col overflow-hidden">
                {/* Header */}
                <div className="flex items-center justify-between px-6 py-4 border-b border-gray-200 bg-gradient-to-r from-[#4E342E] to-[#5D4037] text-white flex-shrink-0">
                    <div className="flex items-center gap-3">
                        <i className="fa-solid fa-chart-bar text-xl opacity-80"></i>
                        <h2 className="text-lg font-bold">Báo cáo Khách Hàng</h2>
                        <span className="text-xs bg-white/20 px-2 py-0.5 rounded-full">{reportData.length} KH</span>
                    </div>
                    <button onClick={onClose} className="w-9 h-9 rounded-full hover:bg-white/20 flex items-center justify-center transition-colors">
                        <i className="fa-solid fa-xmark text-lg"></i>
                    </button>
                </div>

                {/* Tabs */}
                <div className="flex border-b border-gray-200 bg-gray-50 overflow-x-auto flex-shrink-0">
                    {TABS.map(tab => (
                        <button
                            key={tab.key}
                            onClick={() => setActiveTab(tab.key)}
                            className={`flex items-center gap-1.5 px-4 py-3 text-sm font-bold border-b-2 transition-colors whitespace-nowrap
                                ${activeTab === tab.key
                                    ? 'border-[#4E342E] text-[#4E342E] bg-white'
                                    : 'border-transparent text-gray-500 hover:text-gray-700 hover:bg-gray-100'}`}
                        >
                            <i className={`fa-solid ${tab.icon} text-xs`}></i>
                            {tab.label}
                            {tab.key === 'at_risk' && atRiskCustomers.length > 0 && (
                                <span className="bg-red-500 text-white text-[10px] font-black px-1.5 py-0.5 rounded-full ml-1 animate-pulse">{atRiskCustomers.length}</span>
                            )}
                            {tab.key === 'warning' && warningCustomers.length > 0 && (
                                <span className="bg-red-500 text-white text-[10px] font-black px-1.5 py-0.5 rounded-full ml-1">{warningCustomers.length}</span>
                            )}
                            {tab.key === 'duplicates' && duplicates.length > 0 && (
                                <span className="bg-orange-500 text-white text-[10px] font-black px-1.5 py-0.5 rounded-full ml-1">{duplicates.length}</span>
                            )}
                        </button>
                    ))}
                </div>

                {/* Content */}
                <div className="flex-1 overflow-y-auto p-4">
                    {loading ? (
                        <div className="flex flex-col items-center justify-center h-full text-gray-400">
                            <i className="fa-solid fa-spinner fa-spin text-3xl mb-3"></i>
                            <div>Đang tải dữ liệu báo cáo...</div>
                        </div>
                    ) : (
                        <>
                            {/* Tab: Nhiều đơn nhất */}
                            {activeTab === 'top_orders' && (
                                <div>
                                    <div className="mb-4 bg-blue-50 border border-blue-100 rounded-lg p-3 flex items-center gap-2 text-sm text-blue-800">
                                        <i className="fa-solid fa-circle-info"></i>
                                        <span>Top 50 khách hàng đặt nhiều đơn nhất (không tính đơn hủy)</span>
                                    </div>
                                    {renderTable(topOrders, [
                                        {
                                            label: 'Số đơn',
                                            render: (c) => (
                                                <div className="flex items-center justify-end gap-2">
                                                    <div className="w-24 bg-gray-200 rounded-full h-2 overflow-hidden">
                                                        <div className="bg-[#00796b] h-full rounded-full transition-all" style={{ width: `${(c.total_orders / maxOrders) * 100}%` }}></div>
                                                    </div>
                                                    <span className="font-bold text-[#00796b] min-w-[30px]">{c.total_orders}</span>
                                                </div>
                                            )
                                        },
                                        {
                                            label: 'Doanh số',
                                            render: (c) => <span className="font-medium text-gray-700">{fmt(c.total_revenue)}</span>
                                        },
                                    ])}
                                </div>
                            )}

                            {/* Tab: Doanh số cao nhất */}
                            {activeTab === 'top_revenue' && (
                                <div>
                                    <div className="mb-4 bg-green-50 border border-green-100 rounded-lg p-3 flex items-center gap-2 text-sm text-green-800">
                                        <i className="fa-solid fa-circle-info"></i>
                                        <span>Top 50 khách hàng có tổng doanh số cao nhất</span>
                                    </div>
                                    {renderTable(topRevenue, [
                                        {
                                            label: 'Doanh số',
                                            render: (c) => (
                                                <div className="flex items-center justify-end gap-2">
                                                    <div className="w-28 bg-gray-200 rounded-full h-2 overflow-hidden">
                                                        <div className="bg-emerald-500 h-full rounded-full transition-all" style={{ width: `${(c.total_revenue / maxRevenue) * 100}%` }}></div>
                                                    </div>
                                                    <span className="font-bold text-emerald-700 min-w-[90px]">{fmt(c.total_revenue)}</span>
                                                </div>
                                            )
                                        },
                                        {
                                            label: 'Số đơn',
                                            render: (c) => <span className="font-medium text-gray-700">{c.total_orders}</span>
                                        },
                                        {
                                            label: 'Hạng',
                                            render: (c) => {
                                                const tierColors: Record<string, string> = {
                                                    'Bạch Kim': 'bg-purple-100 text-purple-800',
                                                    'Vàng': 'bg-yellow-100 text-yellow-800',
                                                    'Bạc': 'bg-gray-200 text-gray-700',
                                                    'Đồng': 'bg-orange-100 text-orange-700',
                                                };
                                                return <span className={`text-[10px] font-bold px-2 py-0.5 rounded ${tierColors[c.tier || 'Đồng'] || tierColors['Đồng']}`}>{c.tier || 'Đồng'}</span>;
                                            }
                                        },
                                    ])}
                                </div>
                            )}

                            {/* Tab: Hủy đơn nhiều nhất */}
                            {activeTab === 'top_cancelled' && (
                                <div>
                                    <div className="mb-4 bg-red-50 border border-red-100 rounded-lg p-3 flex items-center gap-2 text-sm text-red-800">
                                        <i className="fa-solid fa-triangle-exclamation"></i>
                                        <span>Khách hàng có nhiều đơn bị hủy nhất — cần xem xét nguyên nhân</span>
                                    </div>
                                    {renderTable(topCancelled, [
                                        {
                                            label: 'Đơn hủy',
                                            render: (c) => (
                                                <span className="inline-flex items-center gap-1 bg-red-100 text-red-700 px-2 py-0.5 rounded font-bold text-xs">
                                                    <i className="fa-solid fa-ban text-[10px]"></i> {c.cancelled_orders}
                                                </span>
                                            )
                                        },
                                        {
                                            label: 'Đơn thành công',
                                            render: (c) => <span className="font-medium text-gray-700">{c.total_orders}</span>
                                        },
                                        {
                                            label: 'Tỷ lệ hủy',
                                            render: (c) => {
                                                const total = c.total_orders + c.cancelled_orders;
                                                const rate = total > 0 ? Math.round((c.cancelled_orders / total) * 100) : 0;
                                                return (
                                                    <span className={`font-bold text-xs ${rate > 50 ? 'text-red-600' : rate > 30 ? 'text-orange-600' : 'text-gray-600'}`}>
                                                        {rate}%
                                                    </span>
                                                );
                                            }
                                        },
                                    ])}
                                </div>
                            )}

                            {/* Tab: Lâu không in */}
                            {activeTab === 'inactive' && (
                                <div>
                                    <div className="mb-4 flex items-center gap-3">
                                        <span className="text-sm font-bold text-gray-600">Không đặt đơn trong:</span>
                                        {[30, 60, 90, 180].map(d => (
                                            <button
                                                key={d}
                                                onClick={() => setInactiveDays(d)}
                                                className={`px-3 py-1.5 rounded-lg text-xs font-bold transition-colors border ${inactiveDays === d
                                                    ? 'bg-[#4E342E] text-white border-[#4E342E] shadow-sm'
                                                    : 'bg-white text-gray-600 border-gray-300 hover:bg-gray-50'}`}
                                            >
                                                {d} ngày
                                            </button>
                                        ))}
                                        <span className="text-sm text-gray-500 ml-2">
                                            ({inactiveCustomers.length} khách hàng)
                                        </span>
                                    </div>
                                    {renderTable(inactiveCustomers, [
                                        {
                                            label: 'Đơn cuối',
                                            render: (c) => (
                                                <span className="text-xs text-gray-600">
                                                    {c.last_order_date ? new Date(c.last_order_date).toLocaleDateString('vi-VN') : '---'}
                                                </span>
                                            )
                                        },
                                        {
                                            label: 'Số ngày',
                                            render: (c) => {
                                                const days = c.days_since_last_order || 0;
                                                return (
                                                    <span className={`font-bold text-xs px-2 py-0.5 rounded ${days > 180 ? 'bg-red-100 text-red-700' :
                                                        days > 90 ? 'bg-orange-100 text-orange-700' :
                                                            'bg-yellow-100 text-yellow-700'}`}>
                                                        {days} ngày
                                                    </span>
                                                );
                                            }
                                        },
                                        {
                                            label: 'Tổng đơn',
                                            render: (c) => <span className="font-medium text-gray-700">{c.total_orders}</span>
                                        },
                                        {
                                            label: 'Doanh số',
                                            render: (c) => <span className="font-medium text-gray-700">{fmt(c.total_revenue)}</span>
                                        },
                                    ])}
                                </div>
                            )}

                            {/* Tab: Trùng thông tin */}
                            {activeTab === 'duplicates' && (
                                <div>
                                    <div className="mb-4 bg-orange-50 border border-orange-100 rounded-lg p-3 text-sm text-orange-800">
                                        <div className="flex items-center gap-2 font-bold">
                                            <i className="fa-solid fa-triangle-exclamation"></i>
                                            <span>Phát hiện {duplicates.length} nhóm khách hàng trùng lặp</span>
                                        </div>
                                        <div className="text-xs mt-1 text-orange-600">
                                            Chọn KH <strong>giữ lại</strong> (KH chính) → nhấn <strong>"Gộp"</strong> để chuyển toàn bộ đơn hàng, lịch sử, hóa đơn sang KH chính và xóa KH trùng.
                                        </div>
                                    </div>

                                    {mergeResult && (
                                        <div className={`mb-4 p-3 rounded-lg flex items-center gap-2 text-sm ${mergeResult.success ? 'bg-green-50 border border-green-200 text-green-800' : 'bg-red-50 border border-red-200 text-red-800'}`}>
                                            <i className={`fa-solid ${mergeResult.success ? 'fa-check-circle' : 'fa-times-circle'}`}></i>
                                            <span>{mergeResult.message}</span>
                                            <button onClick={() => setMergeResult(null)} className="ml-auto text-xs underline">Đóng</button>
                                        </div>
                                    )}

                                    {duplicates.length === 0 ? (
                                        <div className="text-center py-12 text-gray-400">
                                            <i className="fa-solid fa-check-circle text-4xl mb-3 text-green-400"></i>
                                            <div className="text-green-600 font-bold">Không phát hiện khách hàng trùng thông tin</div>
                                        </div>
                                    ) : (
                                        <div className="space-y-4">
                                            {duplicates.map((group, gi) => {
                                                const selectedPrimary = mergeSelection[gi];
                                                const secondaries = group.customers.filter(c => c.id !== selectedPrimary);
                                                return (
                                                    <div key={gi} className="border border-gray-200 rounded-lg overflow-hidden">
                                                        <div className={`px-4 py-2.5 flex items-center gap-2 text-sm font-bold ${group.type === 'phone' ? 'bg-red-50 text-red-800' : 'bg-yellow-50 text-yellow-800'}`}>
                                                            <i className={`fa-solid ${group.type === 'phone' ? 'fa-phone' : 'fa-user'}`}></i>
                                                            <span>Trùng {group.type === 'phone' ? 'SĐT' : 'Tên'}:</span>
                                                            <span className="font-mono bg-white/50 px-2 py-0.5 rounded">{group.value}</span>
                                                            <span className="text-xs font-normal ml-auto">{group.customers.length} KH</span>
                                                        </div>
                                                        <table className="w-full text-sm">
                                                            <thead>
                                                                <tr className="bg-gray-50 border-t border-gray-200">
                                                                    <th className="px-4 py-1.5 text-left text-[10px] font-bold text-gray-500 uppercase w-12">Giữ</th>
                                                                    <th className="px-4 py-1.5 text-left text-[10px] font-bold text-gray-500 uppercase w-24">Mã</th>
                                                                    <th className="px-4 py-1.5 text-left text-[10px] font-bold text-gray-500 uppercase">Tên</th>
                                                                    <th className="px-4 py-1.5 text-left text-[10px] font-bold text-gray-500 uppercase">SĐT</th>
                                                                    <th className="px-4 py-1.5 text-left text-[10px] font-bold text-gray-500 uppercase">Email</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                {group.customers.map(c => (
                                                                    <tr
                                                                        key={c.id}
                                                                        onClick={() => setMergeSelection(prev => ({ ...prev, [gi]: c.id }))}
                                                                        className={`border-t border-gray-100 cursor-pointer transition-colors ${selectedPrimary === c.id
                                                                            ? 'bg-green-50 ring-1 ring-inset ring-green-300'
                                                                            : selectedPrimary
                                                                                ? 'bg-red-50/30 hover:bg-red-50'
                                                                                : 'hover:bg-gray-50'
                                                                            }`}
                                                                    >
                                                                        <td className="px-4 py-2">
                                                                            <input
                                                                                type="radio"
                                                                                name={`merge-group-${gi}`}
                                                                                checked={selectedPrimary === c.id}
                                                                                onChange={() => setMergeSelection(prev => ({ ...prev, [gi]: c.id }))}
                                                                                className="accent-green-600"
                                                                            />
                                                                        </td>
                                                                        <td className="px-4 py-2 font-mono text-xs text-gray-500">{c.code}</td>
                                                                        <td className="px-4 py-2">
                                                                            <div className="flex items-center gap-1.5">
                                                                                <span className="font-bold text-gray-800">{c.name}</span>
                                                                                {selectedPrimary === c.id && (
                                                                                    <span className="bg-green-100 text-green-700 text-[9px] font-black px-1.5 py-0.5 rounded">
                                                                                        GIỮ LẠI
                                                                                    </span>
                                                                                )}
                                                                                {selectedPrimary && selectedPrimary !== c.id && (
                                                                                    <span className="bg-red-100 text-red-600 text-[9px] font-black px-1.5 py-0.5 rounded">
                                                                                        SẼ XÓA
                                                                                    </span>
                                                                                )}
                                                                            </div>
                                                                        </td>
                                                                        <td className="px-4 py-2 text-gray-600">{c.phone || '---'}</td>
                                                                        <td className="px-4 py-2 text-gray-500 text-xs">{c.email || '---'}</td>
                                                                    </tr>
                                                                ))}
                                                            </tbody>
                                                        </table>
                                                        {/* Merge action */}
                                                        {selectedPrimary && secondaries.length > 0 && (
                                                            <div className="px-4 py-3 bg-gray-50 border-t border-gray-200 flex items-center justify-between">
                                                                <div className="text-xs text-gray-600">
                                                                    <i className="fa-solid fa-info-circle mr-1"></i>
                                                                    Sẽ chuyển đơn hàng từ <strong>{secondaries.length} KH trùng</strong> sang KH chính, rồi xóa KH trùng.
                                                                </div>
                                                                <button
                                                                    onClick={async () => {
                                                                        if (merging) return;
                                                                        setMerging(true);
                                                                        setMergeResult(null);
                                                                        try {
                                                                            let totalTransferred = 0;
                                                                            for (const sec of secondaries) {
                                                                                const result = await customerService.mergeCustomers(selectedPrimary, sec.id);
                                                                                totalTransferred += result.transferredOrders;
                                                                            }
                                                                            const msg = `Gộp thành công! Đã chuyển ${totalTransferred} đơn hàng và xóa ${secondaries.length} KH trùng.`;
                                                                            setMergeResult({ success: true, message: msg });
                                                                            alert(msg);
                                                                            // Refresh data
                                                                            setMergeSelection(prev => { const next = { ...prev }; delete next[gi]; return next; });
                                                                            await loadData();
                                                                        } catch (err: any) {
                                                                            const errMsg = `Lỗi khi gộp: ${err.message || 'Không xác định'}`;
                                                                            setMergeResult({ success: false, message: errMsg });
                                                                            alert(errMsg);
                                                                        } finally {
                                                                            setMerging(false);
                                                                        }
                                                                    }}
                                                                    disabled={merging}
                                                                    className="flex items-center gap-1.5 px-4 py-1.5 bg-red-600 text-white rounded-lg text-xs font-bold hover:bg-red-700 transition-colors disabled:opacity-50 shadow-sm"
                                                                >
                                                                    <i className={`fa-solid ${merging ? 'fa-spinner fa-spin' : 'fa-code-merge'}`}></i>
                                                                    {merging ? 'Đang gộp...' : `Gộp ${secondaries.length} KH`}
                                                                </button>
                                                            </div>
                                                        )}
                                                    </div>
                                                );
                                            })}
                                        </div>
                                    )}
                                </div>
                            )}

                            {/* Tab: KH cần chú ý */}
                            {activeTab === 'warning' && (
                                <div>
                                    <div className="mb-4 bg-red-50 border border-red-100 rounded-lg p-3 text-sm text-red-800">
                                        <div className="flex items-center gap-2 font-bold mb-1">
                                            <i className="fa-solid fa-triangle-exclamation"></i>
                                            Khách hàng được gắn thẻ cảnh báo
                                        </div>
                                        <div className="text-xs text-red-600">
                                            Các thẻ cảnh báo: {WARNING_TAGS.map(t => `"${t}"`).join(', ')}. Gắn thẻ trong <strong>Quản lý KH → chọn KH → "+ Thẻ"</strong>.
                                        </div>
                                    </div>

                                    {warningCustomers.length === 0 ? (
                                        <div className="text-center py-12 text-gray-400">
                                            <i className="fa-solid fa-check-circle text-4xl mb-3 text-green-400"></i>
                                            <div className="text-green-600 font-bold">Chưa có khách hàng nào được gắn thẻ cảnh báo</div>
                                        </div>
                                    ) : (
                                        <div className="space-y-2">
                                            {warningCustomers.map(c => (
                                                <div key={c.id} className="border border-gray-200 rounded-lg overflow-hidden">
                                                    <div
                                                        onClick={() => setExpandedCustomer(expandedCustomer === c.id ? null : c.id)}
                                                        className="flex items-center gap-3 px-4 py-3 cursor-pointer hover:bg-gray-50 transition-colors"
                                                    >
                                                        <i className={`fa-solid fa-chevron-${expandedCustomer === c.id ? 'down' : 'right'} text-xs text-gray-400 w-3`}></i>
                                                        <div className="flex-1">
                                                            <div className="font-bold text-gray-800">{c.name}</div>
                                                            <div className="text-xs text-gray-500 flex gap-2">
                                                                <span className="font-mono">{c.code}</span>
                                                                {c.phone && <><span>•</span><span>{c.phone}</span></>}
                                                            </div>
                                                        </div>
                                                        <div className="flex gap-1 flex-wrap justify-end">
                                                            {(c.tags || []).filter(tag =>
                                                                WARNING_TAGS.some(wt => tag.toLowerCase().includes(wt.toLowerCase()))
                                                            ).map(tag => (
                                                                <span key={tag} className="bg-red-100 text-red-700 text-[10px] font-bold px-2 py-0.5 rounded-full">
                                                                    <i className="fa-solid fa-tag mr-0.5"></i>{tag}
                                                                </span>
                                                            ))}
                                                        </div>
                                                        <div className="text-xs text-gray-500 text-right min-w-[80px]">
                                                            <div>{c.total_orders} đơn</div>
                                                            <div>{fmt(c.total_revenue)}</div>
                                                        </div>
                                                    </div>
                                                    {expandedCustomer === c.id && (
                                                        <div className="border-t border-gray-100 bg-yellow-50 px-5 py-4">
                                                            <div className="text-xs font-bold text-gray-600 uppercase mb-2 flex items-center gap-1">
                                                                <i className="fa-solid fa-note-sticky"></i> Ghi chú khách hàng
                                                            </div>
                                                            <div className="text-sm text-gray-700 bg-white p-3 rounded border border-gray-200 whitespace-pre-wrap min-h-[40px]">
                                                                {c.crm_notes || <span className="text-gray-400 italic">Chưa có ghi chú</span>}
                                                            </div>
                                                            {/* Show all tags */}
                                                            <div className="mt-3 flex gap-1 flex-wrap">
                                                                {(c.tags || []).map(tag => {
                                                                    const isWarning = WARNING_TAGS.some(wt => tag.toLowerCase().includes(wt.toLowerCase()));
                                                                    return (
                                                                        <span key={tag} className={`text-[10px] font-bold px-2 py-0.5 rounded-full ${isWarning
                                                                            ? 'bg-red-100 text-red-700 border border-red-200'
                                                                            : 'bg-blue-100 text-blue-700 border border-blue-200'}`}>
                                                                            {tag}
                                                                        </span>
                                                                    );
                                                                })}
                                                            </div>
                                                        </div>
                                                    )}
                                                </div>
                                            ))}
                                        </div>
                                    )}
                                </div>
                            )}

                            {/* Tab: KH cần chăm sóc (At-Risk VIP) */}
                            {activeTab === 'at_risk' && (
                                <div>
                                    <div className="mb-4 bg-gradient-to-r from-red-50 to-orange-50 border border-red-100 rounded-lg p-3 text-sm text-red-800">
                                        <div className="flex items-center gap-2 font-bold">
                                            <i className="fa-solid fa-heart-pulse"></i>
                                            Khách hàng VIP cần chăm sóc ngay
                                        </div>
                                        <div className="text-xs text-red-600 mt-1">
                                            KH có doanh số lớn nhưng lâu không đặt đơn — cần liên hệ để giữ chân khách.
                                        </div>
                                    </div>

                                    <div className="mb-4 flex items-center gap-3 flex-wrap">
                                        <span className="text-sm font-bold text-gray-600">Doanh số tối thiểu:</span>
                                        {[5_000_000, 10_000_000, 30_000_000, 50_000_000].map(v => (
                                            <button
                                                key={v}
                                                onClick={() => setRiskMinRevenue(v)}
                                                className={`px-3 py-1.5 rounded-lg text-xs font-bold transition-colors border ${riskMinRevenue === v
                                                    ? 'bg-[#4E342E] text-white border-[#4E342E] shadow-sm'
                                                    : 'bg-white text-gray-600 border-gray-300 hover:bg-gray-50'}`}
                                            >
                                                {(v / 1_000_000)}M
                                            </button>
                                        ))}
                                        <span className="text-sm text-gray-500 ml-2">
                                            ({atRiskCustomers.length} khách hàng)
                                        </span>
                                        <div className="ml-auto flex items-center gap-3 text-[10px] font-bold">
                                            <span className="flex items-center gap-1"><span className="w-2.5 h-2.5 rounded-full bg-yellow-400"></span> 30-60 ngày</span>
                                            <span className="flex items-center gap-1"><span className="w-2.5 h-2.5 rounded-full bg-orange-500"></span> 60-90 ngày</span>
                                            <span className="flex items-center gap-1"><span className="w-2.5 h-2.5 rounded-full bg-red-500"></span> &gt;90 ngày</span>
                                        </div>
                                    </div>

                                    {atRiskCustomers.length === 0 ? (
                                        <div className="text-center py-12 text-gray-400">
                                            <i className="fa-solid fa-check-circle text-4xl mb-3 text-green-400"></i>
                                            <div className="text-green-600 font-bold">Không có KH VIP nào cần chăm sóc khẩn cấp</div>
                                        </div>
                                    ) : (
                                        <div className="space-y-2">
                                            {atRiskCustomers.map((c, i) => {
                                                const days = c.days_since_last_order || 0;
                                                const urgency = days >= 90 ? 'critical' : days >= 60 ? 'warning' : 'notice';
                                                const urgencyStyles = {
                                                    critical: 'border-l-4 border-l-red-500 bg-red-50/50',
                                                    warning: 'border-l-4 border-l-orange-400 bg-orange-50/30',
                                                    notice: 'border-l-4 border-l-yellow-400 bg-yellow-50/20',
                                                };
                                                const badgeStyles = {
                                                    critical: 'bg-red-100 text-red-700',
                                                    warning: 'bg-orange-100 text-orange-700',
                                                    notice: 'bg-yellow-100 text-yellow-700',
                                                };
                                                return (
                                                    <div key={c.id} className={`rounded-lg border border-gray-200 overflow-hidden ${urgencyStyles[urgency]}`}>
                                                        <div className="flex items-center gap-3 px-4 py-3">
                                                            <div className="flex-shrink-0">
                                                                <span className={`w-8 h-8 rounded-full flex items-center justify-center text-xs font-black ${urgency === 'critical' ? 'bg-red-500 text-white' : urgency === 'warning' ? 'bg-orange-400 text-white' : 'bg-yellow-400 text-yellow-900'}`}>
                                                                    {i + 1}
                                                                </span>
                                                            </div>
                                                            <div className="flex-1 min-w-0">
                                                                <div className="font-bold text-gray-800 truncate">{c.name}</div>
                                                                <div className="text-xs text-gray-500 flex gap-2">
                                                                    <span className="font-mono">{c.code}</span>
                                                                    {c.phone && <><span>•</span><span>{c.phone}</span></>}
                                                                </div>
                                                            </div>
                                                            <div className="text-right text-xs flex-shrink-0">
                                                                <div className="font-bold text-emerald-700 text-sm">{fmt(c.total_revenue)}</div>
                                                                <div className="text-gray-500">{c.total_orders} đơn</div>
                                                            </div>
                                                            <div className="flex-shrink-0">
                                                                <span className={`text-xs font-bold px-2 py-1 rounded ${badgeStyles[urgency]}`}>
                                                                    {days} ngày
                                                                </span>
                                                            </div>
                                                            <div className="flex-shrink-0 flex gap-1">
                                                                {c.phone && (
                                                                    <a
                                                                        href={`tel:${c.phone}`}
                                                                        className="w-8 h-8 rounded-full bg-green-500 text-white flex items-center justify-center hover:bg-green-600 transition-colors shadow-sm"
                                                                        title="Gọi ngay"
                                                                    >
                                                                        <i className="fa-solid fa-phone text-xs"></i>
                                                                    </a>
                                                                )}
                                                            </div>
                                                        </div>
                                                        {c.last_order_date && (
                                                            <div className="px-4 pb-2 text-[10px] text-gray-500">
                                                                <i className="fa-solid fa-calendar mr-1"></i>
                                                                Đơn cuối: {new Date(c.last_order_date).toLocaleDateString('vi-VN')}
                                                            </div>
                                                        )}
                                                    </div>
                                                );
                                            })}
                                        </div>
                                    )}
                                </div>
                            )}
                        </>
                    )}
                </div>

                {/* Footer */}
                <div className="flex-shrink-0 border-t border-gray-200 bg-gray-50 px-6 py-3 flex items-center justify-between">
                    <div className="text-xs text-gray-500">
                        <i className="fa-solid fa-clock mr-1"></i>
                        Dữ liệu cập nhật khi mở báo cáo
                    </div>
                    <button
                        onClick={loadData}
                        disabled={loading}
                        className="flex items-center gap-1.5 px-4 py-1.5 bg-[#4E342E] text-white rounded-lg text-sm font-bold hover:opacity-90 transition-colors disabled:opacity-50 shadow-sm"
                    >
                        <i className={`fa-solid fa-rotate ${loading ? 'fa-spin' : ''}`}></i>
                        Làm mới
                    </button>
                </div>
            </div>
        </div>
    );
};

export default CustomerReportModal;
