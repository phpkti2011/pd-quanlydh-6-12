import React, { useState, useEffect, useRef } from 'react';
import { orderService, TransferLookupRow } from '../../services/orderService';
import { formatDate } from '../../utils/dateFormatter';

/**
 * Tra đơn theo nội dung chuyển khoản (mã "Nội dung" dưới QR, vd MMVXU4).
 * Kế toán nhận ảnh chuyển khoản của khách → nhập/dán nội dung → ra đơn tương ứng.
 * Một mã dùng chung cho cả cọc / còn lại / đủ, nên modal chỉ chỉ ra ĐƠN và
 * hiện số tiền để đối chiếu với số khách đã chuyển.
 */
interface Props {
    isOpen: boolean;
    onClose: () => void;
    /** Mở đơn ở màn chính */
    onOpenOrder: (order: TransferLookupRow) => void;
}

const fmt = (n: number) => (n || 0).toLocaleString('vi-VN') + 'đ';

const PAYMENT_LABEL: Record<string, { label: string; cls: string }> = {
    ChuaThanhToan: { label: 'Chưa thanh toán', cls: 'bg-red-100 text-red-700' },
    DaCoc: { label: 'Đã cọc', cls: 'bg-yellow-100 text-yellow-800' },
    DaThanhToan: { label: 'Đã thanh toán', cls: 'bg-green-100 text-green-700' },
    CongNo: { label: 'Công nợ', cls: 'bg-purple-100 text-purple-700' },
};
const paymentOf = (s: string) => PAYMENT_LABEL[s] || { label: s, cls: 'bg-gray-100 text-gray-600' };

const TransferCodeLookupModal: React.FC<Props> = ({ isOpen, onClose, onOpenOrder }) => {
    const [text, setText] = useState('');
    const [rows, setRows] = useState<TransferLookupRow[] | null>(null); // null = chưa tra
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState<string | null>(null);
    const inputRef = useRef<HTMLInputElement>(null);

    useEffect(() => {
        if (isOpen) {
            setText('');
            setRows(null);
            setError(null);
            setTimeout(() => inputRef.current?.focus(), 50);
        }
    }, [isOpen]);

    const handleSearch = async () => {
        if (!text.trim()) return;
        setLoading(true);
        setError(null);
        try {
            setRows(await orderService.findByTransferContent(text));
        } catch (err: any) {
            setRows(null);
            setError(err.message || 'Lỗi khi tra cứu.');
        } finally {
            setLoading(false);
        }
    };

    if (!isOpen) return null;

    return (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-50 p-4">
            <div className="bg-white rounded-lg shadow-xl w-full max-w-2xl p-6 relative max-h-[90vh] overflow-y-auto">
                <button onClick={onClose} className="absolute top-4 right-4 text-gray-400 hover:text-gray-600">
                    <i className="fa-solid fa-times text-xl"></i>
                </button>

                <h2 className="text-xl font-bold mb-1 text-teal-700 flex items-center">
                    <i className="fa-solid fa-magnifying-glass-dollar mr-2"></i>
                    Tra mã chuyển khoản
                </h2>
                <p className="text-sm text-gray-500 mb-4">
                    Nhập mã "Nội dung" khách chuyển (vd <b>MMVXU4</b>), hoặc dán nguyên nội dung sao kê / <b>TT DH &lt;mã đơn&gt;</b>.
                </p>

                <div className="flex gap-2 mb-4">
                    <input
                        ref={inputRef}
                        type="text"
                        value={text}
                        onChange={(e) => setText(e.target.value)}
                        onKeyDown={(e) => { if (e.key === 'Enter') handleSearch(); }}
                        placeholder="Mã nội dung chuyển khoản..."
                        className="flex-1 border border-gray-300 rounded px-3 py-2 uppercase focus:outline-none focus:ring-2 focus:ring-teal-500"
                    />
                    <button
                        onClick={handleSearch}
                        disabled={loading || !text.trim()}
                        className="px-4 py-2 bg-teal-600 text-white rounded font-semibold hover:bg-teal-700 disabled:opacity-50"
                    >
                        <i className={`fa-solid ${loading ? 'fa-spinner fa-spin' : 'fa-search'} mr-1`}></i> Tra cứu
                    </button>
                </div>

                {error && (
                    <div className="mb-4 p-3 rounded bg-red-50 border border-red-200 text-red-700 text-sm">
                        <i className="fa-solid fa-triangle-exclamation mr-1"></i> {error}
                    </div>
                )}

                {rows && rows.length === 0 && (
                    <div className="p-4 rounded bg-yellow-50 border border-yellow-200 text-yellow-800 text-sm">
                        Không tìm thấy đơn nào khớp. Có thể khách ghi sai nội dung, hoặc đơn chưa từng mở
                        "Tạo QR Thanh toán" nên chưa có mã.
                    </div>
                )}

                <div className="space-y-3">
                    {(rows || []).map(o => {
                        const pay = paymentOf(o.payment_status);
                        const remaining = Math.max(0, (o.total_amount || 0) - (o.deposit_amount || 0));
                        return (
                            <div key={o.id} className="border border-gray-200 rounded-lg p-4 shadow-sm">
                                <div className="flex flex-wrap items-center justify-between gap-2 mb-2">
                                    <div className="flex items-center gap-2">
                                        <span className="text-lg font-bold text-gray-800">{o.order_code}</span>
                                        {o.status === 'Huy' && (
                                            <span className="px-2 py-0.5 rounded text-xs font-semibold bg-gray-200 text-gray-600">Đã hủy</span>
                                        )}
                                        <span className={`px-2 py-0.5 rounded text-xs font-semibold ${pay.cls}`}>{pay.label}</span>
                                    </div>
                                    <button
                                        onClick={() => onOpenOrder(o)}
                                        className="px-3 py-1.5 bg-teal-600 text-white text-sm rounded hover:bg-teal-700"
                                    >
                                        <i className="fa-solid fa-arrow-up-right-from-square mr-1"></i> Mở đơn
                                    </button>
                                </div>
                                <div className="text-sm text-gray-700">
                                    <div>
                                        <span className="text-gray-500">Khách:</span>{' '}
                                        <b>{o.customer?.name || '—'}</b>
                                        {o.customer?.code ? <span className="text-gray-400"> ({o.customer.code})</span> : null}
                                    </div>
                                    <div>
                                        <span className="text-gray-500">NVKD:</span> {o.sales_rep?.full_name || '—'}
                                        <span className="text-gray-300 mx-2">|</span>
                                        <span className="text-gray-500">Ngày tạo:</span> {formatDate(o.created_at)}
                                    </div>
                                </div>
                                <div className="grid grid-cols-3 gap-2 mt-3 text-center">
                                    <div className="bg-gray-50 rounded p-2">
                                        <div className="text-xs text-gray-500">Tổng đơn</div>
                                        <div className="font-bold text-gray-800">{fmt(o.total_amount)}</div>
                                    </div>
                                    <div className="bg-gray-50 rounded p-2">
                                        <div className="text-xs text-gray-500">Đã cọc</div>
                                        <div className="font-bold text-gray-800">{fmt(o.deposit_amount)}</div>
                                    </div>
                                    <div className="bg-teal-50 rounded p-2">
                                        <div className="text-xs text-teal-700">Còn lại (sau cọc)</div>
                                        <div className="font-bold text-teal-800">{fmt(remaining)}</div>
                                    </div>
                                </div>
                            </div>
                        );
                    })}
                </div>
            </div>
        </div>
    );
};

export default TransferCodeLookupModal;
