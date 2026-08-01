import React, { useState, useEffect, useMemo } from 'react';
import { commissionService } from '../../services/commissionService';
import { DefectDeduction, StaffCommissionResult } from '../../types';

interface Props {
    /** Tháng đang xem ở tab Báo cáo — chỉ dùng làm giá trị mặc định */
    defaultMonth: number;
    defaultYear: number;
    /** Kết quả vừa tính ở tab Báo cáo, để biết có bao nhiêu người được chia */
    results: StaffCommissionResult[];
    /** Tháng/năm ứng với `results` — nếu khác tháng đang chọn thì không tính phần chia */
    resultsMonth: number;
    resultsYear: number;
}

const fmt = (n: number) => (n || 0).toLocaleString('vi-VN');

export const DefectDeductionTab: React.FC<Props> = ({
    defaultMonth, defaultYear, results, resultsMonth, resultsYear
}) => {
    const [month, setMonth] = useState(defaultMonth);
    const [year, setYear] = useState(defaultYear);

    const [items, setItems] = useState<DefectDeduction[]>([]);
    const [loading, setLoading] = useState(false);
    const [saving, setSaving] = useState(false);
    const [error, setError] = useState<string | null>(null);

    const [amount, setAmount] = useState('');
    const [reason, setReason] = useState('');
    const [orderCode, setOrderCode] = useState('');

    const loadData = async (m: number, y: number) => {
        setLoading(true);
        setError(null);
        try {
            setItems(await commissionService.getDefectDeductions(m, y));
        } catch (e: any) {
            console.error('Load defect deductions failed', e);
            setError(e?.message || 'Không tải được danh sách khoản trừ');
            setItems([]);
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        loadData(month, year);
    }, [month, year]);

    const totalDeduct = useMemo(
        () => items.reduce((s, i) => s + (Number(i.amount) || 0), 0),
        [items]
    );

    // Chỉ tính được phần chia khi tháng đang chọn trùng tháng vừa bấm Tính toán
    const sameMonthAsReport = month === resultsMonth && year === resultsYear && results.length > 0;

    const split = useMemo(() => {
        if (!sameMonthAsReport) return null;
        // Trùng tên chỉ tính là 1 nhân viên, gộp cả dòng công đoạn lẫn dòng Quản lý SX
        const byPerson = new Map<string, number>();
        for (const r of results) {
            const gross = (Number(r.total_comm) || 0) + (Number(r.deduction_amount) || 0);
            byPerson.set(r.participant_name, (byPerson.get(r.participant_name) || 0) + gross);
        }
        const earners = Array.from(byPerson.values()).filter(v => v > 0);
        const n = earners.length;
        if (n === 0) return { n: 0, perPerson: 0, actual: 0 };
        const perPerson = Math.floor(totalDeduct / n);
        // Chặn ở 0, không chia lại: mỗi người chỉ trừ được tối đa bằng thưởng của họ
        const actual = earners.reduce((s, v) => s + Math.min(perPerson, v), 0);
        return { n, perPerson, actual };
    }, [sameMonthAsReport, results, totalDeduct]);

    const handleAdd = async () => {
        const value = Number(String(amount).replace(/[^\d]/g, ''));
        if (!value || value <= 0) {
            alert('Vui lòng nhập số tiền trừ lớn hơn 0.');
            return;
        }
        setSaving(true);
        setError(null);
        try {
            await commissionService.addDefectDeduction({
                month, year, amount: value,
                reason: reason.trim(),
                orderCode: orderCode.trim()
            });
            setAmount(''); setReason(''); setOrderCode('');
            await loadData(month, year);
        } catch (e: any) {
            console.error('Add defect deduction failed', e);
            setError(e?.message || 'Không thêm được khoản trừ');
        } finally {
            setSaving(false);
        }
    };

    const handleDelete = async (item: DefectDeduction) => {
        if (!confirm(`Xoá khoản trừ ${fmt(Number(item.amount))}đ${item.reason ? ` (${item.reason})` : ''}?`)) return;
        try {
            await commissionService.deleteDefectDeduction(item.id);
            await loadData(month, year);
        } catch (e: any) {
            console.error('Delete defect deduction failed', e);
            alert('Không xoá được: ' + (e?.message || 'lỗi không xác định'));
        }
    };

    return (
        <div>
            <div className="mb-4 p-3 bg-amber-50 border border-amber-200 rounded text-sm text-amber-900">
                <div className="font-bold">
                    <i className="fa-solid fa-lock mr-1"></i> Chỉ Admin nhìn thấy mục này
                </div>
                <div className="text-xs mt-1">
                    Khoản trừ được chia <b>đều</b> cho các nhân viên sản xuất có thưởng trong tháng, và
                    ăn dần vào hoa hồng từng đơn tính từ đơn mới nhất. Nhân viên chỉ thấy số tiền sau khi
                    trừ, không thấy khoản trừ này.
                </div>
            </div>

            {/* Chọn tháng áp dụng */}
            <div className="flex flex-wrap gap-4 items-end mb-4 pb-4 border-b border-gray-200">
                <div>
                    <label className="block text-sm font-medium text-gray-700 mb-1">Trừ cho tháng</label>
                    <select
                        value={month}
                        onChange={e => setMonth(parseInt(e.target.value))}
                        className="px-3 py-2 border rounded-md bg-white focus:ring-purple-500 focus:border-purple-500"
                    >
                        {[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12].map(m => (
                            <option key={m} value={m}>Tháng {m}</option>
                        ))}
                    </select>
                </div>
                <div>
                    <label className="block text-sm font-medium text-gray-700 mb-1">Năm</label>
                    <select
                        value={year}
                        onChange={e => setYear(parseInt(e.target.value))}
                        className="px-3 py-2 border rounded-md bg-white focus:ring-purple-500 focus:border-purple-500"
                    >
                        {[2024, 2025, 2026, 2027, 2028, 2029, 2030].map(y => (
                            <option key={y} value={y}>{y}</option>
                        ))}
                    </select>
                </div>
            </div>

            {error && (
                <div className="mb-4 p-3 bg-red-100 text-red-700 rounded text-sm">
                    <i className="fa-solid fa-triangle-exclamation mr-1"></i> {error}
                </div>
            )}

            {/* Form thêm khoản trừ */}
            <div className="flex flex-wrap gap-3 items-end mb-4">
                <div>
                    <label className="block text-xs font-bold text-gray-500 mb-1">Số tiền trừ</label>
                    <input
                        type="text"
                        inputMode="numeric"
                        value={amount}
                        onChange={e => setAmount(e.target.value.replace(/[^\d]/g, ''))}
                        placeholder="1000000"
                        className="px-3 py-2 border rounded-md w-36 text-right focus:ring-purple-500 focus:border-purple-500"
                    />
                </div>
                <div className="flex-1 min-w-[220px]">
                    <label className="block text-xs font-bold text-gray-500 mb-1">Lý do</label>
                    <input
                        type="text"
                        value={reason}
                        onChange={e => setReason(e.target.value)}
                        placeholder="VD: In sai màu, hư giấy couche..."
                        className="px-3 py-2 border rounded-md w-full focus:ring-purple-500 focus:border-purple-500"
                    />
                </div>
                <div>
                    <label className="block text-xs font-bold text-gray-500 mb-1">Mã đơn (nếu có)</label>
                    <input
                        type="text"
                        value={orderCode}
                        onChange={e => setOrderCode(e.target.value)}
                        placeholder="26PD2907.0664"
                        className="px-3 py-2 border rounded-md w-40 focus:ring-purple-500 focus:border-purple-500"
                    />
                </div>
                <button
                    onClick={handleAdd}
                    disabled={saving}
                    className={`px-4 py-2 rounded-md text-white font-medium ${saving ? 'bg-gray-400' : 'bg-purple-600 hover:bg-purple-700'}`}
                >
                    {saving ? <i className="fa-solid fa-spinner fa-spin"></i> : <><i className="fa-solid fa-plus mr-1"></i> Thêm</>}
                </button>
            </div>

            {/* Danh sách khoản trừ trong tháng */}
            <div className="overflow-x-auto border border-gray-200 rounded">
                <table className="min-w-full divide-y divide-gray-200 text-sm">
                    <thead className="bg-gray-50">
                        <tr>
                            <th className="px-4 py-2 text-left text-[11px] font-bold text-gray-500 uppercase">Ngày nhập</th>
                            <th className="px-4 py-2 text-left text-[11px] font-bold text-gray-500 uppercase">Lý do</th>
                            <th className="px-4 py-2 text-left text-[11px] font-bold text-gray-500 uppercase">Mã đơn</th>
                            <th className="px-4 py-2 text-left text-[11px] font-bold text-gray-500 uppercase">Người nhập</th>
                            <th className="px-4 py-2 text-right text-[11px] font-bold text-gray-500 uppercase">Số tiền</th>
                            <th className="px-4 py-2 w-12"></th>
                        </tr>
                    </thead>
                    <tbody className="bg-white divide-y divide-gray-100">
                        {loading ? (
                            <tr><td colSpan={6} className="px-4 py-6 text-center text-gray-500">
                                <i className="fa-solid fa-spinner fa-spin mr-2"></i> Đang tải...
                            </td></tr>
                        ) : items.length > 0 ? (
                            items.map(item => (
                                <tr key={item.id} className="hover:bg-gray-50">
                                    <td className="px-4 py-2 text-xs text-gray-500 whitespace-nowrap">
                                        {new Date(item.created_at).toLocaleDateString('vi-VN')}
                                    </td>
                                    <td className="px-4 py-2 text-gray-700">{item.reason || <span className="text-gray-400 italic">Không ghi lý do</span>}</td>
                                    <td className="px-4 py-2 text-xs font-mono text-gray-600">{item.order_code || '—'}</td>
                                    <td className="px-4 py-2 text-xs text-gray-600">{item.created_by_user?.full_name || '—'}</td>
                                    <td className="px-4 py-2 text-right font-bold text-red-600 whitespace-nowrap">{fmt(Number(item.amount))} đ</td>
                                    <td className="px-4 py-2 text-center">
                                        <button
                                            onClick={() => handleDelete(item)}
                                            className="text-gray-400 hover:text-red-600 transition-colors"
                                            title="Xoá khoản trừ"
                                        >
                                            <i className="fa-solid fa-trash text-xs"></i>
                                        </button>
                                    </td>
                                </tr>
                            ))
                        ) : (
                            <tr><td colSpan={6} className="px-4 py-6 text-center text-gray-400 italic">
                                Chưa có khoản trừ nào cho tháng {month}/{year}.
                            </td></tr>
                        )}
                    </tbody>
                    {items.length > 0 && (
                        <tfoot className="bg-gray-100 font-bold">
                            <tr>
                                <td className="px-4 py-2" colSpan={4}>Tổng trừ tháng {month}/{year}</td>
                                <td className="px-4 py-2 text-right text-red-700">{fmt(totalDeduct)} đ</td>
                                <td></td>
                            </tr>
                        </tfoot>
                    )}
                </table>
            </div>

            {/* Tổng kết phần chia */}
            {items.length > 0 && (
                <div className="mt-4 p-3 rounded border bg-purple-50 border-purple-200 text-sm">
                    {split && split.n > 0 ? (
                        <>
                            <div className="text-purple-900">
                                Tổng trừ <b>{fmt(totalDeduct)}đ</b>
                                {' · '}<b>{split.n}</b> người có thưởng
                                {' · '}mỗi người <b>{fmt(split.perPerson)}đ</b>
                                {' · '}thực trừ được <b>{fmt(split.actual)}đ</b>
                            </div>
                            {split.actual < totalDeduct && (
                                <div className="text-xs text-orange-700 mt-1">
                                    <i className="fa-solid fa-circle-info mr-1"></i>
                                    Thiếu {fmt(totalDeduct - split.actual)}đ vì có người thưởng thấp hơn phần trừ —
                                    theo quy tắc đã chọn, những người đó chỉ bị trừ về 0 và phần dư không chia lại cho ai.
                                </div>
                            )}
                        </>
                    ) : (
                        <div className="text-purple-900">
                            Tổng trừ <b>{fmt(totalDeduct)}đ</b>.
                            <span className="text-xs text-gray-600 ml-1">
                                Sang tab <b>Báo cáo</b>, chọn tháng {month}/{year} rồi bấm <b>Tính toán</b> để xem phần chia cho từng người.
                            </span>
                        </div>
                    )}
                </div>
            )}
        </div>
    );
};

export default DefectDeductionTab;
