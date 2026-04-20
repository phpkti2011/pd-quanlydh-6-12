
import React, { useState, useEffect } from 'react';
import { logService } from '../../services/logService';
import { supabase } from '../../services/supabaseClient';
import { Profile } from '../../types';

interface Props {
    isOpen: boolean;
    onClose: () => void;
    initialOrderCode?: string;
}

const ActivityLogModal: React.FC<Props> = ({ isOpen, onClose, initialOrderCode }) => {
    const [logs, setLogs] = useState<any[]>([]);
    const [loading, setLoading] = useState(false);

    // Filters
    const [users, setUsers] = useState<Profile[]>([]);
    const [selectedUser, setSelectedUser] = useState<string>('');
    const [actionType, setActionType] = useState<string>('');
    const [searchOrder, setSearchOrder] = useState<string>('');
    // Fix Timezone Issue & Default to 1st of Month
    const toLocalISO = (d: Date) => {
        const year = d.getFullYear();
        const month = String(d.getMonth() + 1).padStart(2, '0');
        const day = String(d.getDate()).padStart(2, '0');
        return `${year}-${month}-${day}`;
    };
    const today = new Date();
    const firstDay = new Date(today.getFullYear(), today.getMonth(), 1);

    const [startDate, setStartDate] = useState(toLocalISO(firstDay));
    const [endDate, setEndDate] = useState(toLocalISO(today));

    useEffect(() => {
        if (isOpen) {
            if (initialOrderCode) {
                setSearchOrder(initialOrderCode);
                // Reset date range to see all history for this order
                setStartDate('');
                setEndDate('');
                handleFetchLogs(initialOrderCode);
            } else {
                fetchUsers();
                handleFetchLogs();
            }
        }
    }, [isOpen, initialOrderCode]);

    const fetchUsers = async () => {
        const { data } = await supabase.from('profiles').select('*').order('full_name');
        setUsers(data || []);
    };

    const handleFetchLogs = async (overrideOrderCode?: string) => {
        setLoading(true);
        try {
            const data = await logService.getLogs({
                userId: selectedUser || undefined,
                actionType: actionType || undefined,
                entityId: overrideOrderCode || searchOrder || undefined,
                startDate: (overrideOrderCode || initialOrderCode) ? undefined : startDate,
                endDate: (overrideOrderCode || initialOrderCode) ? undefined : endDate
            });
            setLogs(data);
        } catch (err) {
            console.error(err);
        } finally {
            setLoading(false);
        }
    };

    const formatAction = (type: string) => {
        const map: Record<string, string> = {
            'LOGIN': 'Đăng nhập',
            'ORDER_CREATE': 'Tạo đơn hàng',
            'ORDER_UPDATE_STATUS': 'Cập nhật trạng thái',
            'ORDER_UPDATE_INFO': 'Cập nhật thông tin',
            'ORDER_DELETE': 'Xóa đơn hàng',
            'PAYMENT_ADD': 'Thêm thanh toán',
            'KPI_UPDATE': 'Cập nhật KPI',
            'STAGE_JOIN': 'Thực hiện công đoạn',
            'STAGE_LEAVE': 'Hoàn tác công đoạn'
        };
        return map[type] || type;
    };

    const fieldTranslations: Record<string, string> = {
        'design_status': 'Trạng thái Thiết kế',
        'large_print_status': 'Trạng thái In Khổ Lớn',
        'be_demi_status': 'Trạng thái Bế Demi',
        'outsource_status': 'Trạng thái Gia công ngoài',
        'ep_kim_status': 'Trạng thái Ép kim',
        'invoice_status': 'Xuất hóa đơn',
        'status': 'Trạng thái đơn hàng',
        'payment_status': 'Thanh toán',
        'deposit_amount': 'Tiền cọc',
        'remaining_amount': 'Còn lại',
        'delivery_date': 'Ngày giao hàng',
        'notes': 'Ghi chú',
        'description': 'Mô tả',
        'customer_id': 'Khách hàng',
        'sales_rep_id': 'Nhân viên sales',
        'design_fee': 'Phí thiết kế',
        'large_print_fee': 'Phí in khổ lớn',
        'be_demi_fee': 'Phí bế Demi',
        'gia_cong_ngoai_fee': 'Phí gia công ngoài',
        'ep_kim_fee': 'Phí ép kim',
        'can_mang_fee': 'Phí cán màng',
        'design_note': 'Ghi chú thiết kế',
        'large_print_note': 'Ghi chú in khổ lớn',
        'be_demi_note': 'Ghi chú bế Demi',
        'gia_cong_ngoai_note': 'Ghi chú gia công ngoài',
        'ep_kim_note': 'Ghi chú ép kim',
        'can_mang_note': 'Ghi chú cán màng',
        'status_note': 'Ghi chú trạng thái',
        'payment_note': 'Ghi chú thanh toán',
        'outsource_note': 'Ghi chú gia công ngoài',
        'tracking_code': 'Mã vận đơn',
        'delivery_address': 'Địa chỉ giao hàng',
        'invoice_info': 'Thông tin hóa đơn',
        'vat_rate': 'Thuế suất VAT',
        'order_code': 'Mã đơn hàng',
        'has_design': 'Có thiết kế',
        'has_large_print': 'Có in khổ lớn',
        'has_be_demi': 'Có bế Demi',
        'has_gia_cong_ngoai': 'Có gia công ngoài',
        'has_ep_kim': 'Có ép kim',
        'has_can_mang': 'Có cán màng',
        'is_urgent': 'Đơn gấp'
    };

    const translateValue = (val: string) => {
        const map: Record<string, string> = {
            // Statuses
            'Moi': 'Mới',
            'TiepNhan': 'Tiếp nhận',
            'NhanFile': 'Nhận File',
            'XuLyFile': 'Xử lý File',
            'BinhFile': 'Bình File',
            'In': 'In ấn',
            'ThanhPham': 'Thành phẩm',
            'DongGoi': 'Đóng gói',
            'ChoGiaoHang': 'Chờ giao hàng',
            'DaGiaoHang': 'Đã giao hàng',
            'HoanThanh': 'Hoàn thành',
            'Huy': 'Đã hủy',
            'TamNgung': 'Tạm ngưng',

            // Stages / Subtasks
            'BeDemi': 'Bế Demi',
            'ThietKe': 'Thiết Kế',
            'InKhoLon': 'In Khổ Lớn',
            'GiaCongNgoai': 'Gia công ngoài',
            'EpKim': 'Ép kim',

            // Technical Status Values
            'Completed': 'Hoàn thành',
            'Pending': 'Đang chờ',
            'In Progress': 'Đang thực hiện',
            'Canceled': 'Đã hủy',

            // Payment Methods
            'ChuyenKhoan': 'Chuyển khoản',
            'TienMat': 'Tiền mặt'
        };
        return map[val] || val;
    };

    const renderDetails = (log: any) => {
        try {
            if (!log.details) return '-';

            // STAGE ACTIONS
            if (log.action_type === 'STAGE_JOIN' || log.action_type === 'STAGE_LEAVE') {
                return (
                    <span className="text-xs font-medium">
                        Công đoạn: <b className="text-indigo-600">{translateValue(log.details.stage)}</b>
                    </span>
                )
            }

            // ORDER_UPDATE_STATUS
            if (log.action_type === 'ORDER_UPDATE_STATUS') {
                return (
                    <span className="text-xs">
                        {translateValue(log.details.old_status)} <i className="fa-solid fa-arrow-right mx-1 text-gray-400"></i>
                        <span className="font-bold text-indigo-600">{translateValue(log.details.new_status)}</span>
                    </span>
                );
            }

            // PAYMENT_ADD / UPDATE
            if (log.action_type.includes('PAYMENT')) {
                const p = log.details.payload || log.details;
                return (
                    <div className="flex flex-col text-xs">
                        {p.deposit_amount !== undefined && <span>Cọc: <b>{Number(p.deposit_amount).toLocaleString('vi-VN')}</b></span>}
                        {p.remaining_amount !== undefined && <span>Còn lại: <b>{Number(p.remaining_amount).toLocaleString('vi-VN')}</b></span>}
                        {p.payment_method_deposit && <span>PT Cọc: <b>{translateValue(p.payment_method_deposit)}</b></span>}
                        {p.payment_method_remaining && <span>PT Còn lại: <b>{translateValue(p.payment_method_remaining)}</b></span>}
                    </div>
                )
            }

            // INFO UPDATE with Values (changes)
            if (log.details.changes) {
                return (
                    <div className="flex flex-col gap-1 text-xs">
                        {Object.entries(log.details.changes).map(([key, value]) => (
                            <div key={key} className="flex gap-1 break-words">
                                <span className="font-medium text-gray-700 whitespace-nowrap">
                                    {fieldTranslations[key] || key}:
                                </span>
                                <span className="text-gray-900 truncate max-w-[200px]" title={String(value)}>
                                    {translateValue(String(value))}
                                </span>
                            </div>
                        ))}
                    </div>
                )
            }

            // Legacy Fields Array (Keep for backward compatibility)
            if (log.details.fields && Array.isArray(log.details.fields)) {
                return (
                    <div className="text-xs text-gray-700">
                        Đã cập nhật: {log.details.fields.map((f: string) => <b key={f} className="ml-1">{fieldTranslations[f] || f},</b>)}
                    </div>
                );
            }

            // Fallback object: Attempt to render key-value pairs if shallow
            if (typeof log.details === 'object') {
                // Try to render known keys if present
                const entries = Object.entries(log.details);
                if (entries.length > 0 && entries.length < 5) { // Only if small object
                    return (
                        <div className="flex flex-col text-[10px] text-gray-600">
                            {entries.map(([k, v]) => (
                                <span key={k}>{fieldTranslations[k] || k}: <b>{String(v).substring(0, 50)}</b></span>
                            ))}
                        </div>
                    );
                }
                return <pre className="text-[10px] text-gray-500 font-mono whitespace-pre-wrap">{JSON.stringify(log.details).substring(0, 100)}</pre>
            }

            return <span className="text-xs text-gray-500">{String(log.details)}</span>;
        } catch (e) {
            return <span className="text-xs text-red-400">Error rendering details</span>;
        }
    };

    if (!isOpen) return null;

    return (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-50">
            <div className="bg-white rounded-lg w-full max-w-6xl h-[90vh] flex flex-col shadow-xl animate-fade-in-up">
                {/* Header */}
                <div className="px-6 py-4 border-b flex justify-between items-center bg-gray-800 text-white rounded-t-lg">
                    <h2 className="text-xl font-bold"><i className="fa-solid fa-history mr-2"></i>Lịch Sử Hoạt Động</h2>
                    <button onClick={onClose} className="hover:text-gray-300"><i className="fa-solid fa-times text-xl"></i></button>
                </div>

                {/* Filters */}
                <div className="p-4 bg-gray-50 border-b flex flex-wrap gap-4 items-end">
                    <div>
                        <label className="text-xs font-bold text-gray-500 block mb-1">Nhân viên</label>
                        <select
                            className="border rounded px-3 py-1.5 text-sm w-48"
                            value={selectedUser}
                            onChange={e => setSelectedUser(e.target.value)}
                        >
                            <option value="">Tất cả nhân viên</option>
                            {users.map(u => <option key={u.id} value={u.id}>{u.full_name}</option>)}
                        </select>
                    </div>

                    <div>
                        <label className="text-xs font-bold text-gray-500 block mb-1">Hành động</label>
                        <select
                            className="border rounded px-3 py-1.5 text-sm w-40"
                            value={actionType}
                            onChange={e => setActionType(e.target.value)}
                        >
                            <option value="">Tất cả</option>
                            <option value="LOGIN">Đăng nhập</option>
                            <option value="ORDER_CREATE">Tạo đơn</option>
                            <option value="ORDER_UPDATE_STATUS">Sửa trạng thái</option>
                            <option value="PAYMENT_ADD">Thanh toán</option>
                            <option value="ORDER_DELETE">Xóa đơn</option>
                        </select>
                    </div>

                    <div>
                        <label className="text-xs font-bold text-gray-500 block mb-1">Mã đơn / Nội dung</label>
                        <input
                            type="text"
                            className="border rounded px-3 py-1.5 text-sm w-40"
                            placeholder="DH-..."
                            value={searchOrder}
                            onChange={e => setSearchOrder(e.target.value)}
                        />
                    </div>

                    <div>
                        <label className="text-xs font-bold text-gray-500 block mb-1">Từ ngày</label>
                        <input type="date" className="border rounded px-3 py-1.5 text-sm" value={startDate} onChange={e => setStartDate(e.target.value)} />
                    </div>

                    <div>
                        <label className="text-xs font-bold text-gray-500 block mb-1">Đến ngày</label>
                        <input type="date" className="border rounded px-3 py-1.5 text-sm" value={endDate} onChange={e => setEndDate(e.target.value)} />
                    </div>

                    <button
                        onClick={handleFetchLogs}
                        disabled={loading}
                        className="bg-indigo-600 text-white px-4 py-1.5 rounded hover:bg-indigo-700 text-sm font-bold flex items-center gap-2"
                    >
                        {loading ? <i className="fa-solid fa-spinner fa-spin"></i> : <i className="fa-solid fa-search"></i>}
                        Xem
                    </button>

                    <button
                        onClick={() => { setSelectedUser(''); setActionType(''); setSearchOrder(''); }}
                        className="text-gray-500 hover:text-gray-700 text-sm underline"
                    >
                        Xóa lọc
                    </button>
                </div>

                {/* Table */}
                <div className="flex-1 overflow-auto p-4">
                    <table className="w-full text-sm text-left border-collapse">
                        <thead className="bg-gray-100 text-gray-600 sticky top-0 z-10">
                            <tr>
                                <th className="p-3 border-b">Thời gian</th>
                                <th className="p-3 border-b">Nhân viên</th>
                                <th className="p-3 border-b">Hành động</th>
                                <th className="p-3 border-b">Đơn hàng</th>
                                <th className="p-3 border-b">Chi tiết</th>
                            </tr>
                        </thead>
                        <tbody className="divide-y">
                            {logs.map(log => (
                                <tr key={log.id} className="hover:bg-blue-50">
                                    <td className="p-3 text-gray-500 font-mono text-xs">
                                        {new Date(log.created_at).toLocaleString('vi-VN')}
                                    </td>
                                    <td className="p-3 font-medium text-gray-800">
                                        {log.user_name || 'N/A'}
                                    </td>
                                    <td className="p-3">
                                        <span className={`px-2 py-1 rounded text-xs font-bold 
                                            ${log.action_type === 'LOGIN' ? 'bg-gray-100 text-gray-600' : ''}
                                            ${log.action_type.includes('CREATE') ? 'bg-green-100 text-green-700' : ''}
                                            ${log.action_type.includes('DELETE') ? 'bg-red-100 text-red-700' : ''}
                                            ${log.action_type.includes('UPDATE') ? 'bg-blue-100 text-blue-700' : ''}
                                            ${log.action_type.includes('PAYMENT') ? 'bg-yellow-100 text-orange-700' : ''}
                                        `}>
                                            {formatAction(log.action_type)}
                                        </span>
                                    </td>
                                    <td className="p-3 font-bold text-indigo-700">
                                        {log.entity_id}
                                    </td>
                                    <td className="p-3 text-gray-600 max-w-md break-words">
                                        {renderDetails(log)}
                                    </td>
                                </tr>
                            ))}
                            {!loading && logs.length === 0 && (
                                <tr>
                                    <td colSpan={5} className="p-8 text-center text-gray-400">Không có dữ liệu nào.</td>
                                </tr>
                            )}
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    );
};

export default ActivityLogModal;
