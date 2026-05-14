import React, { useState, useEffect, useMemo } from 'react';
import {
    LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer,
    BarChart, Bar
} from 'recharts';
import { dailyReportService, DailyReportData, RevenueTrendPoint } from '../../services/dailyReportService';

interface Props {
    isOpen: boolean;
    onClose: () => void;
}

const STATUS_LABELS: Record<string, string> = {
    'Moi': 'Mới',
    'TiepNhan': 'Tiếp nhận',
    'NhanFile': 'Nhận File',
    'XuLyFile': 'Xử lý File',
    'BinhFile': 'Bình File',
    'In': 'In',
    'ThanhPham': 'Thành Phẩm',
    'DongGoi': 'Đóng gói',
    'ChoGiaoHang': 'Chờ giao hàng',
    'DaGiaoHang': 'Đã giao hàng',
    'HoanThanh': 'Hoàn thành',
    'Huy': 'Hủy',
    'TamNgung': 'Tạm ngưng',
};

const fmtMoney = (n: number) => (n || 0).toLocaleString('vi-VN') + 'đ';
const fmtMoneyShort = (n: number) => {
    if (!n) return '0đ';
    if (n >= 1_000_000_000) return (n / 1_000_000_000).toFixed(1) + 'tỷ';
    if (n >= 1_000_000) return (n / 1_000_000).toFixed(1) + 'tr';
    if (n >= 1_000) return (n / 1_000).toFixed(0) + 'k';
    return n.toString();
};

const toDateInput = (d: Date) => {
    const yr = d.getFullYear();
    const mo = String(d.getMonth() + 1).padStart(2, '0');
    const dy = String(d.getDate()).padStart(2, '0');
    return `${yr}-${mo}-${dy}`;
};

interface KpiCardProps {
    label: string;
    value: string | number;
    color: 'red' | 'blue' | 'green' | 'orange' | 'purple' | 'teal' | 'gray' | 'indigo';
    icon?: string;
    sub?: string;
}

const KpiCard: React.FC<KpiCardProps> = ({ label, value, color, icon, sub }) => {
    const palette: Record<string, { bg: string; border: string; text: string; label: string }> = {
        red: { bg: 'bg-red-50', border: 'border-red-100', text: 'text-red-600', label: 'text-red-800' },
        blue: { bg: 'bg-blue-50', border: 'border-blue-100', text: 'text-blue-600', label: 'text-blue-800' },
        green: { bg: 'bg-green-50', border: 'border-green-100', text: 'text-green-600', label: 'text-green-800' },
        orange: { bg: 'bg-orange-50', border: 'border-orange-100', text: 'text-orange-600', label: 'text-orange-800' },
        purple: { bg: 'bg-purple-50', border: 'border-purple-100', text: 'text-purple-700', label: 'text-purple-800' },
        teal: { bg: 'bg-teal-50', border: 'border-teal-100', text: 'text-teal-700', label: 'text-teal-800' },
        gray: { bg: 'bg-gray-50', border: 'border-gray-200', text: 'text-gray-700', label: 'text-gray-800' },
        indigo: { bg: 'bg-indigo-50', border: 'border-indigo-100', text: 'text-indigo-600', label: 'text-indigo-800' },
    };
    const p = palette[color];
    return (
        <div className={`${p.bg} p-4 rounded-lg border ${p.border} flex flex-col justify-center items-center shadow-sm min-w-0`}>
            <span className={`${p.label} font-medium text-xs uppercase tracking-wider text-center`}>
                {icon && <i className={`fa-solid ${icon} mr-1`}></i>}
                {label}
            </span>
            <span className={`text-2xl md:text-3xl font-bold ${p.text} mt-1 break-all text-center`}>{value}</span>
            {sub && <span className="text-xs text-gray-500 mt-0.5">{sub}</span>}
        </div>
    );
};

const SectionHeader: React.FC<{ icon: string; title: string; color: string }> = ({ icon, title, color }) => (
    <h3 className={`text-lg font-bold ${color} mb-3 flex items-center`}>
        <i className={`fa-solid ${icon} mr-2`}></i>
        {title}
    </h3>
);

const DailyReportModal: React.FC<Props> = ({ isOpen, onClose }) => {
    const [date, setDate] = useState<string>(toDateInput(new Date()));
    const [data, setData] = useState<DailyReportData | null>(null);
    const [trend, setTrend] = useState<RevenueTrendPoint[]>([]);
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState<string | null>(null);
    const [loadedAt, setLoadedAt] = useState<string>('');

    const fetchData = async () => {
        setLoading(true);
        setError(null);
        try {
            const [report, trendData] = await Promise.all([
                dailyReportService.getDailyReport(date),
                dailyReportService.getRevenueTrend(7, date),
            ]);
            setData(report);
            setTrend(trendData);
            setLoadedAt(new Date().toLocaleTimeString('vi-VN'));
        } catch (e: any) {
            console.error(e);
            setError(e.message || 'Lỗi tải báo cáo');
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        if (isOpen) fetchData();
    }, [isOpen, date]);

    // Bar chart top NVKD (đã sort DESC từ RPC)
    const nvkdChartData = useMemo(() => {
        if (!data?.sales_by_employee) return [];
        return data.sales_by_employee
            .filter(e => e.revenue > 0)
            .slice(0, 10)
            .map(e => ({ name: e.employee_name || 'N/A', revenue: Number(e.revenue) }));
    }, [data]);

    // Format trend data cho Line chart
    const trendChartData = useMemo(() => {
        return trend.map(p => ({
            date: new Date(p.date).toLocaleDateString('vi-VN', { day: '2-digit', month: '2-digit' }),
            'Chưa VAT': Number(p.revenue_pre_vat),
            'Có VAT': Number(p.revenue_total),
        }));
    }, [trend]);

    if (!isOpen) return null;

    return (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-50 p-4">
            <div className="bg-white rounded-lg shadow-xl w-full max-w-7xl relative max-h-[95vh] overflow-y-auto">
                {/* Header */}
                <div className="sticky top-0 bg-white border-b border-gray-200 px-6 py-4 z-10 flex flex-col md:flex-row md:items-center md:justify-between gap-3">
                    <h2 className="text-2xl font-bold text-blue-700 flex items-center">
                        <i className="fa-solid fa-chart-line mr-3"></i>
                        Báo Cáo Ngày
                    </h2>
                    <div className="flex items-center gap-3 flex-wrap">
                        <label className="text-sm font-medium text-gray-700 flex items-center gap-2">
                            <i className="fa-solid fa-calendar-days text-gray-500"></i>
                            <input
                                type="date"
                                value={date}
                                max={toDateInput(new Date())}
                                onChange={(e) => setDate(e.target.value)}
                                className="border border-gray-300 rounded px-3 py-1.5 focus:outline-none focus:ring-2 focus:ring-blue-500"
                            />
                        </label>
                        <button
                            onClick={fetchData}
                            disabled={loading}
                            className="px-4 py-1.5 bg-gray-100 text-gray-700 rounded hover:bg-gray-200 transition disabled:opacity-50"
                        >
                            <i className={`fa-solid fa-sync mr-1 ${loading ? 'fa-spin' : ''}`}></i> Làm mới
                        </button>
                        {loadedAt && (
                            <span className="text-xs text-gray-500">Cập nhật: {loadedAt}</span>
                        )}
                        <button onClick={onClose} className="text-gray-400 hover:text-gray-600">
                            <i className="fa-solid fa-times text-xl"></i>
                        </button>
                    </div>
                </div>

                {/* Body */}
                <div className="p-6 space-y-6">
                    {error && (
                        <div className="p-4 bg-red-50 border border-red-200 rounded text-red-700">
                            <i className="fa-solid fa-triangle-exclamation mr-2"></i> {error}
                        </div>
                    )}

                    {loading && !data && (
                        <div className="p-8 text-center text-gray-500">
                            <i className="fa-solid fa-spinner fa-spin text-2xl"></i>
                            <div className="mt-2">Đang tải báo cáo...</div>
                        </div>
                    )}

                    {data && (
                        <>
                            {/* Tổng quan đơn hàng */}
                            <section>
                                <SectionHeader icon="fa-clipboard-list" title="TỔNG QUAN ĐƠN HÀNG" color="text-gray-800" />
                                <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
                                    <KpiCard label="Tạo mới" value={data.orders_created_today} color="blue" icon="fa-plus-circle" />
                                    <KpiCard label="Hoàn thành" value={data.orders_completed_today} color="green" icon="fa-check-circle" />
                                    <KpiCard label="Hủy" value={data.orders_cancelled_today} color="red" icon="fa-ban" />
                                    <KpiCard label="Đang xử lý" value={data.pending_orders_count} color="orange" icon="fa-gears" />
                                </div>
                            </section>

                            {/* Doanh thu */}
                            <section>
                                <SectionHeader icon="fa-sack-dollar" title="DOANH THU" color="text-green-700" />
                                <div className="grid grid-cols-1 md:grid-cols-3 gap-3 mb-4">
                                    <KpiCard label="Đơn mới (chưa VAT)" value={fmtMoneyShort(data.revenue_today_pre_vat)} color="teal" sub={fmtMoney(data.revenue_today_pre_vat)} />
                                    <KpiCard label="Đơn mới (có VAT)" value={fmtMoneyShort(data.revenue_today)} color="green" sub={fmtMoney(data.revenue_today)} />
                                    <KpiCard label="Hoàn thành (chưa VAT)" value={fmtMoneyShort(data.revenue_completed_today)} color="indigo" sub={fmtMoney(data.revenue_completed_today)} />
                                </div>
                                <div className="grid grid-cols-1 md:grid-cols-2 gap-3 mb-4">
                                    <KpiCard label="Doanh thu tháng (có VAT)" value={fmtMoneyShort(data.revenue_month_total)} color="purple" sub={fmtMoney(data.revenue_month_total)} />
                                    <KpiCard label="Doanh thu tháng (chưa VAT)" value={fmtMoneyShort(data.revenue_month_pre_vat)} color="orange" sub={fmtMoney(data.revenue_month_pre_vat)} />
                                </div>

                                {/* Line chart 7 ngày */}
                                {trendChartData.length > 0 && (
                                    <div className="bg-gray-50 p-4 rounded-lg border border-gray-200">
                                        <h4 className="text-sm font-semibold text-gray-700 mb-2">
                                            <i className="fa-solid fa-chart-line mr-1 text-blue-500"></i>
                                            Doanh thu 7 ngày qua
                                        </h4>
                                        <ResponsiveContainer width="100%" height={250}>
                                            <LineChart data={trendChartData}>
                                                <CartesianGrid strokeDasharray="3 3" />
                                                <XAxis dataKey="date" />
                                                <YAxis tickFormatter={(v) => fmtMoneyShort(v)} />
                                                <Tooltip formatter={(v: number) => fmtMoney(v)} />
                                                <Legend />
                                                <Line type="monotone" dataKey="Chưa VAT" stroke="#0d9488" strokeWidth={2} dot={{ r: 3 }} />
                                                <Line type="monotone" dataKey="Có VAT" stroke="#16a34a" strokeWidth={2} dot={{ r: 3 }} />
                                            </LineChart>
                                        </ResponsiveContainer>
                                    </div>
                                )}
                            </section>

                            {/* Thanh toán */}
                            <section>
                                <SectionHeader icon="fa-coins" title="THANH TOÁN" color="text-yellow-700" />
                                <div className="grid grid-cols-1 md:grid-cols-3 gap-3">
                                    <KpiCard label="Thu trong ngày" value={fmtMoneyShort(data.payment_stats?.total_collected || 0)} color="green" sub={fmtMoney(data.payment_stats?.total_collected || 0)} />
                                    <KpiCard label="Chưa thanh toán" value={data.payment_stats?.unpaid_orders || 0} color="orange" icon="fa-clock" />
                                    <KpiCard label="Đơn công nợ" value={data.payment_stats?.debt_orders || 0} color="red" icon="fa-file-invoice-dollar" />
                                </div>
                            </section>

                            {/* Doanh số NVKD */}
                            {data.sales_by_employee && data.sales_by_employee.length > 0 && (
                                <section>
                                    <SectionHeader icon="fa-people-group" title="DOANH SỐ NVKD" color="text-blue-700" />
                                    <div className="grid grid-cols-1 lg:grid-cols-2 gap-4">
                                        {/* Bar chart */}
                                        <div className="bg-gray-50 p-4 rounded-lg border border-gray-200">
                                            {nvkdChartData.length > 0 ? (
                                                <ResponsiveContainer width="100%" height={Math.max(220, nvkdChartData.length * 36)}>
                                                    <BarChart data={nvkdChartData} layout="vertical" margin={{ left: 20 }}>
                                                        <CartesianGrid strokeDasharray="3 3" />
                                                        <XAxis type="number" tickFormatter={(v) => fmtMoneyShort(v)} />
                                                        <YAxis type="category" dataKey="name" width={110} tick={{ fontSize: 12 }} />
                                                        <Tooltip formatter={(v: number) => fmtMoney(v)} />
                                                        <Bar dataKey="revenue" fill="#3b82f6" name="Doanh số" />
                                                    </BarChart>
                                                </ResponsiveContainer>
                                            ) : (
                                                <div className="text-center text-gray-400 py-8 text-sm italic">
                                                    Không có NVKD nào phát sinh doanh số
                                                </div>
                                            )}
                                        </div>

                                        {/* Bảng chi tiết */}
                                        <div className="overflow-x-auto bg-white border border-gray-200 rounded-lg">
                                            <table className="min-w-full divide-y divide-gray-200 text-sm">
                                                <thead className="bg-gray-100">
                                                    <tr>
                                                        <th className="px-3 py-2 text-left font-bold text-gray-700">Hạng</th>
                                                        <th className="px-3 py-2 text-left font-bold text-gray-700">Tên NV</th>
                                                        <th className="px-3 py-2 text-right font-bold text-gray-700">Doanh số</th>
                                                        <th className="px-3 py-2 text-center font-bold text-gray-700">Tạo</th>
                                                        <th className="px-3 py-2 text-center font-bold text-gray-700">HT</th>
                                                    </tr>
                                                </thead>
                                                <tbody className="divide-y divide-gray-200">
                                                    {data.sales_by_employee.map((e, idx) => {
                                                        const medal = idx === 0 ? '🥇' : idx === 1 ? '🥈' : idx === 2 ? '🥉' : `#${idx + 1}`;
                                                        return (
                                                            <tr key={idx} className="hover:bg-blue-50">
                                                                <td className="px-3 py-2">{medal}</td>
                                                                <td className="px-3 py-2 font-medium text-gray-900">{e.employee_name || 'N/A'}</td>
                                                                <td className="px-3 py-2 text-right font-bold text-blue-700">{fmtMoney(Number(e.revenue) || 0)}</td>
                                                                <td className="px-3 py-2 text-center text-gray-600">{e.orders_created}</td>
                                                                <td className="px-3 py-2 text-center text-green-600">{e.orders_completed}</td>
                                                            </tr>
                                                        );
                                                    })}
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </section>
                            )}

                            {/* Chuyển đổi trạng thái */}
                            {data.status_transitions_today && data.status_transitions_today.length > 0 && (
                                <section>
                                    <SectionHeader icon="fa-arrows-rotate" title="CHUYỂN ĐỔI TRẠNG THÁI" color="text-purple-700" />
                                    <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-2">
                                        {data.status_transitions_today.map((t, idx) => (
                                            <div key={idx} className="bg-purple-50 border border-purple-100 rounded p-3 flex justify-between items-center">
                                                <span className="text-sm text-purple-800">→ {STATUS_LABELS[t.to_status] || t.to_status}</span>
                                                <span className="font-bold text-purple-700">{t.count}</span>
                                            </div>
                                        ))}
                                    </div>
                                </section>
                            )}

                            {/* Hoạt động nhân viên */}
                            {data.employee_activity && data.employee_activity.length > 0 && (
                                <section>
                                    <SectionHeader icon="fa-chart-simple" title="HOẠT ĐỘNG NHÂN VIÊN" color="text-indigo-700" />
                                    <div className="overflow-x-auto bg-white border border-gray-200 rounded-lg">
                                        <table className="min-w-full divide-y divide-gray-200 text-sm">
                                            <thead className="bg-gray-100">
                                                <tr>
                                                    <th className="px-3 py-2 text-left font-bold text-gray-700">Nhân viên</th>
                                                    <th className="px-3 py-2 text-right font-bold text-gray-700">Tổng</th>
                                                    <th className="px-3 py-2 text-right font-bold text-gray-700">Tạo đơn</th>
                                                    <th className="px-3 py-2 text-right font-bold text-gray-700">Cập nhật</th>
                                                    <th className="px-3 py-2 text-right font-bold text-gray-700">Công đoạn</th>
                                                    <th className="px-3 py-2 text-right font-bold text-gray-700">Thanh toán</th>
                                                </tr>
                                            </thead>
                                            <tbody className="divide-y divide-gray-200">
                                                {data.employee_activity.map((a, idx) => (
                                                    <tr key={idx} className="hover:bg-indigo-50">
                                                        <td className="px-3 py-2 font-medium text-gray-900">{a.employee_name}</td>
                                                        <td className="px-3 py-2 text-right font-bold text-indigo-700">{a.total_actions}</td>
                                                        <td className="px-3 py-2 text-right text-gray-600">{a.orders_created}</td>
                                                        <td className="px-3 py-2 text-right text-gray-600">{a.status_updates}</td>
                                                        <td className="px-3 py-2 text-right text-gray-600">{a.stage_actions}</td>
                                                        <td className="px-3 py-2 text-right text-gray-600">{a.payment_updates}</td>
                                                    </tr>
                                                ))}
                                            </tbody>
                                        </table>
                                    </div>
                                </section>
                            )}
                        </>
                    )}
                </div>
            </div>
        </div>
    );
};

export default DailyReportModal;
