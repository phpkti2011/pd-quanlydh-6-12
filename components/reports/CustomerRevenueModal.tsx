import React, { useState, useEffect, useMemo } from 'react';
import { supabase } from '../../services/supabaseClient';
import { getMonthRange, formatDate } from '../../utils/dateFormatter';

interface Props {
    isOpen: boolean;
    onClose: () => void;
}

const ROW_LIMIT = 5000;
const NO_CUSTOMER = 'NO_CUSTOMER';

const fmt = (n: number) => (n || 0).toLocaleString('vi-VN') + 'đ';

// Nhãn hiển thị cho payment_status (types.ts: PaymentStatus)
const PAYMENT_LABELS: Record<string, string> = {
    ChuaThanhToan: 'Chưa thanh toán',
    DaCoc: 'Đã cọc',
    DaThanhToan: 'Đã thanh toán',
    CongNo: 'Công nợ',
};

const PAYMENT_STYLES: Record<string, string> = {
    ChuaThanhToan: 'bg-gray-100 text-gray-700',
    DaCoc: 'bg-yellow-100 text-yellow-800',
    DaThanhToan: 'bg-green-100 text-green-700',
    CongNo: 'bg-red-100 text-red-700',
};

interface RevenueOrder {
    id: string;
    order_code: string;
    description?: string;
    created_at: string;
    status: string;
    payment_status: string;
    customerId: string;
    customerCode: string;
    customerName: string;
    salesRepName: string;
    total: number;
    totalPreVat: number;
    collected: number;
    debt: number;
}

/**
 * Quy đổi tiền của 1 đơn.
 * KHÔNG dùng cột orders.remaining_amount — cột này từng bị lưu sai = 0 dù đơn còn nợ
 * (xem fix_debt_remaining_calc.sql). Tính lại từ payment_status + deposit_amount,
 * giống hệt RPC get_debt_orders.
 */
const computeMoney = (o: any) => {
    const total = Number(o.total_amount) || 0;
    const deposit = Number(o.deposit_amount) || 0;
    const collected =
        o.payment_status === 'DaThanhToan' ? total :
            o.payment_status === 'DaCoc' ? Math.min(deposit, total) : 0;
    return { total, collected, debt: Math.max(total - collected, 0) };
};

const CustomerRevenueModal: React.FC<Props> = ({ isOpen, onClose }) => {
    const now = new Date();
    const [selectedMonth, setSelectedMonth] = useState<number>(now.getMonth() + 1);
    const [selectedYear, setSelectedYear] = useState<number>(now.getFullYear());
    const [selectedCustomerId, setSelectedCustomerId] = useState<string>('ALL');
    const [searchTerm, setSearchTerm] = useState('');

    const [orders, setOrders] = useState<RevenueOrder[]>([]);
    const [cancelledCount, setCancelledCount] = useState(0);
    const [truncated, setTruncated] = useState(false);
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState<string | null>(null);

    const fetchData = async () => {
        setLoading(true);
        setError(null);
        try {
            const { start, end } = getMonthRange(selectedMonth, selectedYear);
            const { data, error: err } = await supabase
                .from('orders')
                .select('id, order_code, description, total_amount, total_amount_pre_vat, deposit_amount, payment_status, status, created_at, customer:customer_id(id, code, name), sales_rep:sales_rep_id(full_name)')
                .gte('created_at', start.toISOString())
                .lte('created_at', end.toISOString())
                .order('created_at', { ascending: false })
                .range(0, ROW_LIMIT - 1);

            if (err) throw err;

            const rows = data || [];
            setTruncated(rows.length >= ROW_LIMIT);

            // Đơn Hủy không tính vào doanh số (cùng quy ước với customerService.getCustomerReportData)
            const cancelled = rows.filter((o: any) => o.status === 'Huy');
            setCancelledCount(cancelled.length);

            const mapped: RevenueOrder[] = rows
                .filter((o: any) => o.status !== 'Huy')
                .map((o: any) => {
                    const { total, collected, debt } = computeMoney(o);
                    return {
                        id: o.id,
                        order_code: o.order_code,
                        description: o.description,
                        created_at: o.created_at,
                        status: o.status,
                        payment_status: o.payment_status,
                        customerId: o.customer?.id || NO_CUSTOMER,
                        customerCode: o.customer?.code || '',
                        customerName: o.customer?.name || 'Vãng lai',
                        salesRepName: o.sales_rep?.full_name || '',
                        total,
                        totalPreVat: Number(o.total_amount_pre_vat) || 0,
                        collected,
                        debt,
                    };
                });

            setOrders(mapped);
        } catch (e: any) {
            console.error('Load customer revenue failed', e);
            setError(e?.message || 'Không tải được dữ liệu doanh thu');
            setOrders([]);
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        if (!isOpen) return;
        fetchData();
    }, [isOpen, selectedMonth, selectedYear]);

    // Gom theo khách hàng — dùng cho dropdown và bảng tổng hợp
    const byCustomer = useMemo(() => {
        const map = new Map<string, {
            id: string; code: string; name: string;
            count: number; revenue: number; collected: number; debt: number; revenuePreVat: number;
        }>();
        for (const o of orders) {
            const entry = map.get(o.customerId) || {
                id: o.customerId, code: o.customerCode, name: o.customerName,
                count: 0, revenue: 0, collected: 0, debt: 0, revenuePreVat: 0,
            };
            entry.count++;
            entry.revenue += o.total;
            entry.revenuePreVat += o.totalPreVat;
            entry.collected += o.collected;
            entry.debt += o.debt;
            map.set(o.customerId, entry);
        }
        return Array.from(map.values()).sort((a, b) => b.revenue - a.revenue);
    }, [orders]);

    // Đơn thuộc phạm vi đang xem (đã áp bộ lọc KH + tìm kiếm)
    const filteredOrders = useMemo(() => {
        let result = orders;
        if (selectedCustomerId !== 'ALL') {
            result = result.filter(o => o.customerId === selectedCustomerId);
        }
        if (searchTerm.trim()) {
            const term = searchTerm.trim().toLowerCase();
            result = result.filter(o =>
                o.customerName.toLowerCase().includes(term) ||
                o.customerCode.toLowerCase().includes(term) ||
                (o.order_code || '').toLowerCase().includes(term) ||
                (o.description || '').toLowerCase().includes(term)
            );
        }
        return result;
    }, [orders, selectedCustomerId, searchTerm]);

    // Bảng tổng hợp cũng phải tôn trọng ô tìm kiếm
    const filteredCustomers = useMemo(() => {
        if (!searchTerm.trim()) return byCustomer;
        const visible = new Set(filteredOrders.map(o => o.customerId));
        return byCustomer.filter(c => visible.has(c.id));
    }, [byCustomer, filteredOrders, searchTerm]);

    const stats = useMemo(() => {
        return filteredOrders.reduce(
            (acc, o) => {
                acc.revenue += o.total;
                acc.revenuePreVat += o.totalPreVat;
                acc.collected += o.collected;
                acc.debt += o.debt;
                return acc;
            },
            { revenue: 0, revenuePreVat: 0, collected: 0, debt: 0 }
        );
    }, [filteredOrders]);

    const selectedCustomer = useMemo(
        () => byCustomer.find(c => c.id === selectedCustomerId) || null,
        [byCustomer, selectedCustomerId]
    );

    const maxRevenue = useMemo(
        () => Math.max(...filteredCustomers.map(c => c.revenue), 1),
        [filteredCustomers]
    );

    const handleExportExcel = () => {
        try {
            const monthLabel = `T${selectedMonth}-${selectedYear}`;
            let headers: string[];
            let rows: (string | number)[][];

            if (selectedCustomerId === 'ALL') {
                headers = ['Mã KH', 'Khách Hàng', 'Số Đơn', 'Doanh Số', 'Chưa VAT', 'Đã Thu', 'Còn Nợ'];
                rows = filteredCustomers.map(c => [
                    c.code, c.name, c.count, c.revenue, c.revenuePreVat, c.collected, c.debt,
                ]);
            } else {
                headers = ['Mã Đơn', 'Ngày Tạo', 'Khách Hàng', 'Nội Dung', 'NV Kinh Doanh', 'Thành Tiền', 'Chưa VAT', 'Đã Thu', 'Còn Nợ', 'Trạng Thái TT'];
                rows = filteredOrders.map(o => [
                    o.order_code,
                    new Date(o.created_at).toLocaleDateString('vi-VN'),
                    o.customerName,
                    (o.description || '').replace(/\r?\n/g, ' '),
                    o.salesRepName,
                    o.total, o.totalPreVat, o.collected, o.debt,
                    PAYMENT_LABELS[o.payment_status] || o.payment_status,
                ]);
            }

            // Dòng tổng cuối file — canh đúng cột theo từng chế độ
            const totalRow: (string | number)[] = new Array(headers.length).fill('');
            totalRow[0] = 'TỔNG';
            const revenueCol = headers.indexOf(selectedCustomerId === 'ALL' ? 'Doanh Số' : 'Thành Tiền');
            totalRow[revenueCol] = stats.revenue;
            totalRow[revenueCol + 1] = stats.revenuePreVat;
            totalRow[revenueCol + 2] = stats.collected;
            totalRow[revenueCol + 3] = stats.debt;
            rows.push(new Array(headers.length).fill(''));
            rows.push(totalRow);

            const csvContent = '﻿' + [
                headers.join(','),
                ...rows.map(r => r.map(c => typeof c === 'string' ? `"${c.replace(/"/g, '""')}"` : c).join(',')),
            ].join('\n');

            const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
            const url = URL.createObjectURL(blob);
            const link = document.createElement('a');
            link.setAttribute('href', url);
            const fileName = selectedCustomer
                ? `DoanhThu_${selectedCustomer.name.replace(/\s+/g, '_')}_${monthLabel}.csv`
                : `DoanhThu_TheoKH_${monthLabel}.csv`;
            link.setAttribute('download', fileName);
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        } catch (e) {
            console.error('Export Error:', e);
            alert('Lỗi xuất file Excel (CSV).');
        }
    };

    if (!isOpen) return null;

    return (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-50 p-4">
            <div className="bg-white rounded-lg shadow-xl w-full max-w-7xl p-6 relative max-h-[95vh] overflow-y-auto flex flex-col">
                <button
                    onClick={onClose}
                    className="absolute top-4 right-4 text-gray-400 hover:text-gray-600"
                >
                    <i className="fa-solid fa-times text-xl"></i>
                </button>

                <h2 className="text-2xl font-bold mb-6 text-teal-800 flex items-center">
                    <i className="fa-solid fa-coins mr-3"></i>
                    Doanh Thu Theo Khách Hàng
                </h2>

                {/* Bộ lọc */}
                <div className="flex flex-col md:flex-row justify-between items-center mb-4 gap-4 bg-gray-50 p-3 rounded">
                    <div className="flex items-center gap-3 w-full md:w-auto flex-wrap">
                        <div className="relative">
                            <span className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                <i className="fa-solid fa-search text-gray-400"></i>
                            </span>
                            <input
                                type="text"
                                className="pl-10 border border-gray-300 rounded px-3 py-2 w-full md:w-56 focus:outline-none focus:ring-2 focus:ring-teal-500"
                                placeholder="Tìm tên KH, mã đơn..."
                                value={searchTerm}
                                onChange={(e) => setSearchTerm(e.target.value)}
                            />
                        </div>

                        <label className="font-semibold text-gray-700 whitespace-nowrap"><i className="fa-solid fa-filter mr-1"></i> Khách hàng:</label>
                        <select
                            className="border border-gray-300 rounded px-3 py-2 w-full md:w-72 focus:outline-none focus:ring-2 focus:ring-teal-500"
                            value={selectedCustomerId}
                            onChange={(e) => setSelectedCustomerId(e.target.value)}
                        >
                            <option value="ALL">-- Tất cả khách hàng ({byCustomer.length}) --</option>
                            {byCustomer.map(c => (
                                <option key={c.id} value={c.id}>
                                    {c.name}{c.code ? ` (${c.code})` : ''} — {c.count} đơn
                                </option>
                            ))}
                        </select>

                        <div className="flex items-center gap-2">
                            <label className="font-semibold text-gray-700 whitespace-nowrap"><i className="fa-solid fa-calendar-days mr-1"></i> Tháng:</label>
                            <select
                                className="border border-gray-300 rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-teal-500"
                                value={selectedMonth}
                                onChange={(e) => setSelectedMonth(Number(e.target.value))}
                            >
                                {Array.from({ length: 12 }, (_, i) => i + 1).map(m => (
                                    <option key={m} value={m}>Tháng {m}</option>
                                ))}
                            </select>
                            <select
                                className="border border-gray-300 rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-teal-500"
                                value={selectedYear}
                                onChange={(e) => setSelectedYear(Number(e.target.value))}
                            >
                                {Array.from({ length: 5 }, (_, i) => new Date().getFullYear() - 2 + i).map(y => (
                                    <option key={y} value={y}>{y}</option>
                                ))}
                            </select>
                        </div>
                    </div>
                    <div className="flex gap-2 items-center">
                        <button
                            onClick={handleExportExcel}
                            disabled={loading || filteredOrders.length === 0}
                            className="px-4 py-2 bg-green-600 text-white rounded hover:bg-green-700 transition disabled:opacity-50"
                        >
                            <i className="fa-solid fa-file-excel mr-1"></i> Xuất CSV
                        </button>
                        <button onClick={fetchData} className="px-4 py-2 bg-gray-200 text-gray-700 rounded hover:bg-gray-300 transition">
                            <i className={`fa-solid fa-sync mr-1 ${loading ? 'fa-spin' : ''}`}></i> Làm mới
                        </button>
                    </div>
                </div>

                {error && (
                    <div className="mb-4 p-3 rounded bg-red-50 border border-red-200 text-red-700 text-sm">
                        <i className="fa-solid fa-triangle-exclamation mr-1"></i> {error}
                    </div>
                )}

                {truncated && (
                    <div className="mb-4 p-3 rounded bg-orange-50 border border-orange-200 text-orange-800 text-sm">
                        <i className="fa-solid fa-triangle-exclamation mr-1"></i>
                        Tháng này có hơn {ROW_LIMIT.toLocaleString('vi-VN')} đơn — dữ liệu đã bị cắt bớt, số liệu bên dưới chưa đầy đủ.
                    </div>
                )}

                {/* 3 thẻ số liệu */}
                <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-2">
                    <div className="bg-green-50 p-4 rounded-lg border border-green-100 flex flex-col justify-center items-center shadow-sm">
                        <span className="text-green-800 font-medium text-sm uppercase tracking-wider">Doanh Số</span>
                        <span className="text-3xl font-bold text-green-600 mt-1">{stats.revenue.toLocaleString('vi-VN')} đ</span>
                        <span className="text-xs text-green-700/70 mt-1">Chưa VAT: {fmt(stats.revenuePreVat)}</span>
                    </div>
                    <div className="bg-blue-50 p-4 rounded-lg border border-blue-100 flex flex-col justify-center items-center shadow-sm">
                        <span className="text-blue-800 font-medium text-sm uppercase tracking-wider">Đã Thu</span>
                        <span className="text-3xl font-bold text-blue-600 mt-1">{stats.collected.toLocaleString('vi-VN')} đ</span>
                        <span className="text-xs text-blue-700/70 mt-1">
                            {stats.revenue > 0 ? Math.round((stats.collected / stats.revenue) * 100) : 0}% doanh số
                        </span>
                    </div>
                    <div className="bg-red-50 p-4 rounded-lg border border-red-100 flex flex-col justify-center items-center shadow-sm">
                        <span className="text-red-800 font-medium text-sm uppercase tracking-wider">Còn Nợ</span>
                        <span className="text-3xl font-bold text-red-600 mt-1">{stats.debt.toLocaleString('vi-VN')} đ</span>
                        <span className="text-xs text-red-700/70 mt-1">
                            {filteredOrders.filter(o => o.debt > 0).length} đơn chưa thu đủ
                        </span>
                    </div>
                </div>

                <div className="text-xs text-gray-500 mb-4 flex items-center gap-3 flex-wrap">
                    <span>
                        <i className="fa-solid fa-circle-info mr-1"></i>
                        {filteredOrders.length} đơn · Tháng {selectedMonth}/{selectedYear} · tính theo ngày tạo đơn
                    </span>
                    {cancelledCount > 0 && (
                        <span className="text-orange-600">
                            Đã loại {cancelledCount} đơn Hủy khỏi số liệu
                        </span>
                    )}
                    {selectedCustomer && (
                        <button
                            onClick={() => setSelectedCustomerId('ALL')}
                            className="text-teal-700 font-bold hover:underline"
                        >
                            <i className="fa-solid fa-arrow-left mr-1"></i> Tất cả khách hàng
                        </button>
                    )}
                </div>

                {/* Nội dung */}
                {loading ? (
                    <div className="flex flex-col items-center justify-center py-16 text-gray-400">
                        <i className="fa-solid fa-spinner fa-spin text-3xl mb-3"></i>
                        <div>Đang tải dữ liệu...</div>
                    </div>
                ) : selectedCustomerId === 'ALL' ? (
                    /* Bảng tổng hợp theo khách hàng */
                    <div className="overflow-x-auto border border-gray-200 rounded-lg">
                        <table className="w-full text-sm">
                            <thead className="bg-gray-50 border-b border-gray-200">
                                <tr>
                                    <th className="px-3 py-2.5 text-left text-xs font-bold text-gray-500 uppercase w-10">#</th>
                                    <th className="px-3 py-2.5 text-left text-xs font-bold text-gray-500 uppercase">Khách hàng</th>
                                    <th className="px-3 py-2.5 text-right text-xs font-bold text-gray-500 uppercase">Số đơn</th>
                                    <th className="px-3 py-2.5 text-right text-xs font-bold text-gray-500 uppercase">Doanh số</th>
                                    <th className="px-3 py-2.5 text-right text-xs font-bold text-gray-500 uppercase">Đã thu</th>
                                    <th className="px-3 py-2.5 text-right text-xs font-bold text-gray-500 uppercase">Còn nợ</th>
                                </tr>
                            </thead>
                            <tbody>
                                {filteredCustomers.map((c, i) => (
                                    <tr
                                        key={c.id}
                                        onClick={() => setSelectedCustomerId(c.id)}
                                        className="border-b border-gray-100 hover:bg-teal-50 cursor-pointer transition-colors"
                                        title="Bấm để xem chi tiết đơn hàng"
                                    >
                                        <td className="px-3 py-2.5 text-gray-400 font-bold text-xs">{i + 1}</td>
                                        <td className="px-3 py-2.5">
                                            <div className="font-bold text-gray-800">{c.name}</div>
                                            {c.code && <div className="text-xs text-gray-500 font-mono">{c.code}</div>}
                                        </td>
                                        <td className="px-3 py-2.5 text-right font-medium text-gray-700">{c.count}</td>
                                        <td className="px-3 py-2.5 text-right">
                                            <div className="flex items-center justify-end gap-2">
                                                <div className="w-20 bg-gray-200 rounded-full h-1.5 overflow-hidden hidden md:block">
                                                    <div className="bg-emerald-500 h-full rounded-full" style={{ width: `${(c.revenue / maxRevenue) * 100}%` }}></div>
                                                </div>
                                                <span className="font-bold text-emerald-700">{fmt(c.revenue)}</span>
                                            </div>
                                        </td>
                                        <td className="px-3 py-2.5 text-right text-blue-700 font-medium">{fmt(c.collected)}</td>
                                        <td className={`px-3 py-2.5 text-right font-medium ${c.debt > 0 ? 'text-red-600' : 'text-gray-400'}`}>{fmt(c.debt)}</td>
                                    </tr>
                                ))}
                                {filteredCustomers.length === 0 && (
                                    <tr><td colSpan={6} className="text-center py-10 text-gray-400">Không có đơn hàng nào trong tháng {selectedMonth}/{selectedYear}</td></tr>
                                )}
                            </tbody>
                        </table>
                    </div>
                ) : (
                    /* Bảng chi tiết đơn của 1 khách hàng */
                    <div className="overflow-x-auto border border-gray-200 rounded-lg">
                        <table className="w-full text-sm">
                            <thead className="bg-gray-50 border-b border-gray-200">
                                <tr>
                                    <th className="px-3 py-2.5 text-left text-xs font-bold text-gray-500 uppercase">Mã đơn</th>
                                    <th className="px-3 py-2.5 text-left text-xs font-bold text-gray-500 uppercase">Ngày tạo</th>
                                    <th className="px-3 py-2.5 text-left text-xs font-bold text-gray-500 uppercase">Nội dung</th>
                                    <th className="px-3 py-2.5 text-right text-xs font-bold text-gray-500 uppercase">Thành tiền</th>
                                    <th className="px-3 py-2.5 text-right text-xs font-bold text-gray-500 uppercase">Đã thu</th>
                                    <th className="px-3 py-2.5 text-right text-xs font-bold text-gray-500 uppercase">Còn nợ</th>
                                    <th className="px-3 py-2.5 text-center text-xs font-bold text-gray-500 uppercase">Trạng thái TT</th>
                                </tr>
                            </thead>
                            <tbody>
                                {filteredOrders.map(o => (
                                    <tr key={o.id} className="border-b border-gray-100 hover:bg-gray-50 transition-colors">
                                        <td className="px-3 py-2.5 font-mono font-bold text-gray-800">{o.order_code}</td>
                                        <td className="px-3 py-2.5 text-gray-600 whitespace-nowrap">{formatDate(o.created_at)}</td>
                                        <td className="px-3 py-2.5 text-gray-600 max-w-xs truncate" title={o.description}>{o.description || '---'}</td>
                                        <td className="px-3 py-2.5 text-right font-bold text-emerald-700">{fmt(o.total)}</td>
                                        <td className="px-3 py-2.5 text-right text-blue-700">{fmt(o.collected)}</td>
                                        <td className={`px-3 py-2.5 text-right ${o.debt > 0 ? 'text-red-600 font-medium' : 'text-gray-400'}`}>{fmt(o.debt)}</td>
                                        <td className="px-3 py-2.5 text-center">
                                            <span className={`text-[10px] font-bold px-2 py-0.5 rounded whitespace-nowrap ${PAYMENT_STYLES[o.payment_status] || 'bg-gray-100 text-gray-700'}`}>
                                                {PAYMENT_LABELS[o.payment_status] || o.payment_status}
                                            </span>
                                        </td>
                                    </tr>
                                ))}
                                {filteredOrders.length === 0 && (
                                    <tr><td colSpan={7} className="text-center py-10 text-gray-400">Khách hàng này không có đơn nào trong tháng {selectedMonth}/{selectedYear}</td></tr>
                                )}
                            </tbody>
                            {filteredOrders.length > 0 && (
                                <tfoot className="bg-gray-50 border-t-2 border-gray-300">
                                    <tr className="font-bold text-gray-800">
                                        <td className="px-3 py-2.5" colSpan={3}>TỔNG ({filteredOrders.length} đơn)</td>
                                        <td className="px-3 py-2.5 text-right text-emerald-700">{fmt(stats.revenue)}</td>
                                        <td className="px-3 py-2.5 text-right text-blue-700">{fmt(stats.collected)}</td>
                                        <td className="px-3 py-2.5 text-right text-red-600">{fmt(stats.debt)}</td>
                                        <td></td>
                                    </tr>
                                </tfoot>
                            )}
                        </table>
                    </div>
                )}
            </div>
        </div>
    );
};

export default CustomerRevenueModal;
