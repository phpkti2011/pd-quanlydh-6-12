import React, { useState, useEffect, useMemo } from 'react';
import { supabase } from '../../services/supabaseClient';
import { getMonthRange, formatDate } from '../../utils/dateFormatter';

/**
 * Báo cáo đơn SẢN XUẤT LẠI theo tháng (xem setup_rework_orders.sql).
 * Tab "🔁 Sản xuất lại" dùng để làm việc hằng ngày; báo cáo này để Admin /
 * Kế toán / QLSX nhìn lại cả tháng: làm lại bao nhiêu đơn, vì sao, tốn bao nhiêu,
 * chiếm bao nhiêu % so với số đơn hoàn thành.
 */
interface Props {
    isOpen: boolean;
    onClose: () => void;
    /** Mở đơn (gốc hoặc làm lại) ở màn chính */
    onOpenOrder?: (ref: { id: string; order_code: string }) => void;
}

const fmt = (n: number) => (n || 0).toLocaleString('vi-VN') + 'đ';

interface ReworkRow {
    id: string;
    order_code: string;
    rootId: string;
    rootCode: string;
    customerName: string;
    customerCode: string;
    salesRepName: string;
    reason: string;
    cost: number;
    status: string;
    created_at: string;
    completed_at?: string | null;
}

const STATUS_STYLE: Record<string, { label: string; cls: string }> = {
    HoanThanh: { label: 'Đã xong', cls: 'bg-green-100 text-green-700' },
    Huy: { label: 'Đã hủy', cls: 'bg-gray-200 text-gray-600' },
};
const statusOf = (s: string) => STATUS_STYLE[s] || { label: 'Đang làm', cls: 'bg-orange-100 text-orange-800' };

const ReworkReportModal: React.FC<Props> = ({ isOpen, onClose, onOpenOrder }) => {
    const now = new Date();
    const [month, setMonth] = useState<number>(now.getMonth() + 1);
    const [year, setYear] = useState<number>(now.getFullYear());
    const [rows, setRows] = useState<ReworkRow[]>([]);
    const [completedNormal, setCompletedNormal] = useState(0);
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState<string | null>(null);

    const fetchData = async () => {
        setLoading(true);
        setError(null);
        try {
            const { start, end } = getMonthRange(month, year);

            // 1. Đơn làm lại TẠO trong tháng ("tháng này làm lại bao nhiêu đơn").
            //    Chi phí thì trừ doanh số theo tháng hoàn thành — xem cột Ngày xong.
            const { data, error: err } = await supabase
                .from('orders')
                .select('id, order_code, rework_of_order_id, rework_reason, rework_cost, status, created_at, completed_at, customer:customer_id(id, code, name), sales_rep:sales_rep_id(full_name)')
                .not('rework_of_order_id', 'is', null)
                .gte('created_at', start.toISOString())
                .lte('created_at', end.toISOString())
                .order('created_at', { ascending: false });
            if (err) throw err;
            const list = (data || []) as any[];

            // 2. Mã đơn gốc — truy vấn riêng, không embed tự tham chiếu
            //    (lý do: xem orderService.attachReworkLinks)
            const rootIds = [...new Set(list.map(o => o.rework_of_order_id).filter(Boolean))] as string[];
            const rootMap = new Map<string, string>();
            if (rootIds.length) {
                const { data: roots } = await supabase.from('orders').select('id, order_code').in('id', rootIds);
                (roots || []).forEach((r: any) => rootMap.set(r.id, r.order_code));
            }

            // 3. Số đơn thường hoàn thành trong tháng để tính tỉ lệ
            //    (cùng quy tắc chuyển đổi 01/03/2026 như Thưởng HHSX)
            const isNewMethod = year > 2026 || (year === 2026 && month >= 3);
            let q = supabase
                .from('orders')
                .select('id', { count: 'exact', head: true })
                .eq('status', 'HoanThanh')
                .is('rework_of_order_id', null);
            q = isNewMethod
                ? q.gte('completed_at', start.toISOString()).lte('completed_at', end.toISOString()).gte('created_at', '2026-03-01T00:00:00.000Z')
                : q.gte('created_at', start.toISOString()).lte('created_at', end.toISOString());
            const { count } = await q;
            setCompletedNormal(count || 0);

            setRows(list.map(o => ({
                id: o.id,
                order_code: o.order_code,
                rootId: o.rework_of_order_id,
                rootCode: rootMap.get(o.rework_of_order_id) || '(đã xoá)',
                customerName: o.customer?.name || 'Vãng lai',
                customerCode: o.customer?.code || '',
                salesRepName: o.sales_rep?.full_name || '',
                reason: o.rework_reason || '',
                cost: Number(o.rework_cost) || 0,
                status: o.status,
                created_at: o.created_at,
                completed_at: o.completed_at,
            })));
        } catch (e: any) {
            console.error('Load rework report failed', e);
            setError(e?.message || 'Không tải được dữ liệu sản xuất lại');
            setRows([]);
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        if (!isOpen) return;
        fetchData();
    }, [isOpen, month, year]);

    const stats = useMemo(() => {
        const active = rows.filter(r => r.status !== 'Huy');
        const totalCost = active.reduce((s, r) => s + r.cost, 0);
        const done = active.filter(r => r.status === 'HoanThanh').length;
        const ratio = completedNormal > 0 ? (active.length / completedNormal) * 100 : 0;
        return { count: active.length, cancelled: rows.length - active.length, totalCost, done, ratio };
    }, [rows, completedNormal]);

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

                <h2 className="text-2xl font-bold mb-6 text-[#e65100] flex items-center">
                    <i className="fa-solid fa-rotate mr-3"></i>
                    Đơn Sản Xuất Lại
                </h2>

                {/* Bộ lọc */}
                <div className="flex flex-col md:flex-row justify-between items-center mb-4 gap-4 bg-gray-50 p-3 rounded">
                    <div className="flex items-center gap-2">
                        <label className="font-semibold text-gray-700 whitespace-nowrap"><i className="fa-solid fa-calendar-days mr-1"></i> Tháng:</label>
                        <select
                            className="border border-gray-300 rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-orange-500"
                            value={month}
                            onChange={(e) => setMonth(Number(e.target.value))}
                        >
                            {Array.from({ length: 12 }, (_, i) => i + 1).map(m => (
                                <option key={m} value={m}>Tháng {m}</option>
                            ))}
                        </select>
                        <select
                            className="border border-gray-300 rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-orange-500"
                            value={year}
                            onChange={(e) => setYear(Number(e.target.value))}
                        >
                            {Array.from({ length: 5 }, (_, i) => new Date().getFullYear() - 2 + i).map(y => (
                                <option key={y} value={y}>{y}</option>
                            ))}
                        </select>
                    </div>
                    <button onClick={fetchData} className="px-4 py-2 bg-gray-200 text-gray-700 rounded hover:bg-gray-300 transition">
                        <i className={`fa-solid fa-sync mr-1 ${loading ? 'fa-spin' : ''}`}></i> Làm mới
                    </button>
                </div>

                {error && (
                    <div className="mb-4 p-3 rounded bg-red-50 border border-red-200 text-red-700 text-sm">
                        <i className="fa-solid fa-triangle-exclamation mr-1"></i> {error}
                    </div>
                )}

                {/* Thẻ số liệu */}
                <div className="grid grid-cols-1 md:grid-cols-4 gap-4 mb-2">
                    <div className="bg-orange-50 p-4 rounded-lg border border-orange-100 flex flex-col justify-center items-center shadow-sm">
                        <span className="text-orange-800 font-medium text-sm uppercase tracking-wider">Đơn làm lại</span>
                        <span className="text-3xl font-bold text-orange-600 mt-1">{stats.count}</span>
                        <span className="text-xs text-orange-700/70 mt-1">{stats.done} đã xong · {stats.count - stats.done} đang làm</span>
                    </div>
                    <div className="bg-red-50 p-4 rounded-lg border border-red-100 flex flex-col justify-center items-center shadow-sm">
                        <span className="text-red-800 font-medium text-sm uppercase tracking-wider">Tổng chi phí</span>
                        <span className="text-3xl font-bold text-red-600 mt-1">{stats.totalCost.toLocaleString('vi-VN')} đ</span>
                        <span className="text-xs text-red-700/70 mt-1">trừ doanh số tháng khi đơn hoàn thành</span>
                    </div>
                    <div className="bg-blue-50 p-4 rounded-lg border border-blue-100 flex flex-col justify-center items-center shadow-sm">
                        <span className="text-blue-800 font-medium text-sm uppercase tracking-wider">Tỉ lệ làm lại</span>
                        <span className="text-3xl font-bold text-blue-600 mt-1">{stats.ratio.toFixed(1)}%</span>
                        <span className="text-xs text-blue-700/70 mt-1">so với {completedNormal} đơn hoàn thành trong tháng</span>
                    </div>
                    <div className="bg-gray-50 p-4 rounded-lg border border-gray-200 flex flex-col justify-center items-center shadow-sm">
                        <span className="text-gray-700 font-medium text-sm uppercase tracking-wider">Đã hủy</span>
                        <span className="text-3xl font-bold text-gray-500 mt-1">{stats.cancelled}</span>
                        <span className="text-xs text-gray-500 mt-1">không tính vào chi phí</span>
                    </div>
                </div>

                <div className="text-xs text-gray-500 mb-4">
                    <i className="fa-solid fa-circle-info mr-1"></i>
                    Tháng {month}/{year} · tính theo ngày tạo đơn làm lại · bấm mã đơn để mở ở màn chính
                </div>

                {/* Bảng */}
                {loading ? (
                    <div className="flex flex-col items-center justify-center py-16 text-gray-400">
                        <i className="fa-solid fa-spinner fa-spin text-3xl mb-3"></i>
                        <div>Đang tải dữ liệu...</div>
                    </div>
                ) : (
                    <div className="overflow-x-auto border border-gray-200 rounded-lg">
                        <table className="w-full text-sm">
                            <thead className="bg-gray-50 border-b border-gray-200">
                                <tr>
                                    <th className="px-3 py-2.5 text-left text-xs font-bold text-gray-500 uppercase">Mã đơn</th>
                                    <th className="px-3 py-2.5 text-left text-xs font-bold text-gray-500 uppercase">Đơn gốc</th>
                                    <th className="px-3 py-2.5 text-left text-xs font-bold text-gray-500 uppercase">Khách hàng</th>
                                    <th className="px-3 py-2.5 text-left text-xs font-bold text-gray-500 uppercase">Nguyên nhân</th>
                                    <th className="px-3 py-2.5 text-right text-xs font-bold text-gray-500 uppercase">Chi phí</th>
                                    <th className="px-3 py-2.5 text-center text-xs font-bold text-gray-500 uppercase">Trạng thái</th>
                                    <th className="px-3 py-2.5 text-left text-xs font-bold text-gray-500 uppercase">NVKD</th>
                                    <th className="px-3 py-2.5 text-left text-xs font-bold text-gray-500 uppercase">Ngày tạo</th>
                                    <th className="px-3 py-2.5 text-left text-xs font-bold text-gray-500 uppercase">Ngày xong</th>
                                </tr>
                            </thead>
                            <tbody>
                                {rows.map(r => {
                                    const st = statusOf(r.status);
                                    return (
                                        <tr key={r.id} className={`border-b border-gray-100 hover:bg-gray-50 transition-colors ${r.status === 'Huy' ? 'opacity-60' : ''}`}>
                                            <td className="px-3 py-2.5 font-mono font-bold">
                                                <button
                                                    type="button"
                                                    onClick={() => onOpenOrder?.({ id: r.id, order_code: r.order_code })}
                                                    className="text-orange-700 hover:underline"
                                                    title="Mở đơn làm lại"
                                                >
                                                    {r.order_code}
                                                </button>
                                            </td>
                                            <td className="px-3 py-2.5 font-mono">
                                                <button
                                                    type="button"
                                                    onClick={() => onOpenOrder?.({ id: r.rootId, order_code: r.rootCode })}
                                                    className="text-blue-700 hover:underline"
                                                    title="Mở đơn gốc"
                                                >
                                                    {r.rootCode}
                                                </button>
                                            </td>
                                            <td className="px-3 py-2.5">
                                                <div className="font-medium text-gray-800">{r.customerName}</div>
                                                {r.customerCode && <div className="text-xs text-gray-500 font-mono">{r.customerCode}</div>}
                                            </td>
                                            <td className="px-3 py-2.5 text-gray-700 max-w-xs whitespace-pre-wrap" title={r.reason}>{r.reason || '---'}</td>
                                            <td className="px-3 py-2.5 text-right font-bold text-red-600">{fmt(r.cost)}</td>
                                            <td className="px-3 py-2.5 text-center">
                                                <span className={`text-[10px] font-bold px-2 py-0.5 rounded whitespace-nowrap ${st.cls}`}>{st.label}</span>
                                            </td>
                                            <td className="px-3 py-2.5 text-gray-600">{r.salesRepName || '-'}</td>
                                            <td className="px-3 py-2.5 text-gray-600 whitespace-nowrap">{formatDate(r.created_at)}</td>
                                            <td className="px-3 py-2.5 text-gray-600 whitespace-nowrap">{r.completed_at ? formatDate(r.completed_at) : '-'}</td>
                                        </tr>
                                    );
                                })}
                                {rows.length === 0 && (
                                    <tr><td colSpan={9} className="text-center py-10 text-gray-400">Tháng {month}/{year} không có đơn sản xuất lại nào</td></tr>
                                )}
                            </tbody>
                            {rows.length > 0 && (
                                <tfoot className="bg-gray-50 border-t-2 border-gray-300">
                                    <tr className="font-bold text-gray-800">
                                        <td className="px-3 py-2.5" colSpan={4}>TỔNG ({stats.count} đơn chưa hủy)</td>
                                        <td className="px-3 py-2.5 text-right text-red-600">{fmt(stats.totalCost)}</td>
                                        <td colSpan={4}></td>
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

export default ReworkReportModal;
