
import React, { useState, useEffect } from 'react';
import { logService, ActivityLog, isAuditTrailMissing } from '../../services/logService';
import { supabase } from '../../services/supabaseClient';
import { Profile } from '../../types';

interface Props {
    isOpen: boolean;
    onClose: () => void;
    initialOrderCode?: string;
}

const PAGE_SIZE = 50;

const ACTION_OPTIONS: { value: string; label: string }[] = [
    { value: 'ORDER_CREATE', label: 'Tạo đơn hàng' },
    { value: 'ORDER_UPDATE_INFO', label: 'Sửa thông tin đơn' },
    { value: 'ORDER_UPDATE_STATUS', label: 'Đổi trạng thái đơn' },
    { value: 'PAYMENT_UPDATE', label: 'Cập nhật thanh toán' },
    { value: 'ORDER_DELETE', label: 'Xóa đơn hàng' },
    { value: 'STAGE_JOIN', label: 'Nhận công đoạn' },
    { value: 'STAGE_LEAVE', label: 'Rời công đoạn' },
    { value: 'CUSTOMER_CREATE', label: 'Thêm khách hàng' },
    { value: 'CUSTOMER_UPDATE', label: 'Sửa khách hàng' },
    { value: 'CUSTOMER_DELETE', label: 'Xóa khách hàng' },
    { value: 'EMPLOYEE_CREATE', label: 'Thêm nhân viên' },
    { value: 'EMPLOYEE_UPDATE', label: 'Sửa nhân viên' },
    { value: 'EMPLOYEE_DELETE', label: 'Xóa nhân viên' },
    { value: 'LOGIN', label: 'Đăng nhập' },
    { value: 'LOGOUT', label: 'Đăng xuất' },
];

const ENTITY_OPTIONS: { value: string; label: string }[] = [
    { value: 'order', label: 'Đơn hàng' },
    { value: 'customer', label: 'Khách hàng' },
    { value: 'employee', label: 'Nhân viên' },
    { value: 'system', label: 'Hệ thống' },
];

const ActivityLogModal: React.FC<Props> = ({ isOpen, onClose, initialOrderCode }) => {
    const [logs, setLogs] = useState<ActivityLog[]>([]);
    const [total, setTotal] = useState(0);
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState<string | null>(null);
    const [auditMissing, setAuditMissing] = useState(false);

    // Filters
    const [users, setUsers] = useState<Profile[]>([]);
    const [selectedUser, setSelectedUser] = useState<string>('');
    const [actionType, setActionType] = useState<string>('');
    const [entityType, setEntityType] = useState<string>('');
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
        if (!isOpen) return;
        // Luôn nạp danh sách nhân viên — trước đây bị bỏ qua khi mở từ 1 đơn
        // cụ thể nên dropdown "Nhân viên" rỗng.
        fetchUsers();
        if (initialOrderCode) {
            setSearchOrder(initialOrderCode);
            // Xem toàn bộ lịch sử của đơn này, không giới hạn khoảng ngày
            setStartDate('');
            setEndDate('');
            handleFetchLogs(0, initialOrderCode);
        } else {
            handleFetchLogs(0);
        }
    }, [isOpen, initialOrderCode]);

    const fetchUsers = async () => {
        const { data } = await supabase.from('profiles').select('*').order('full_name');
        setUsers(data || []);
    };

    const handleFetchLogs = async (offset = 0, overrideOrderCode?: string) => {
        setLoading(true);
        setError(null);
        try {
            const isOrderScoped = !!(overrideOrderCode || initialOrderCode);
            const data = await logService.getLogs({
                userId: selectedUser || undefined,
                actionType: actionType || undefined,
                entityType: entityType || undefined,
                entityId: overrideOrderCode || searchOrder || undefined,
                startDate: isOrderScoped ? undefined : (startDate || undefined),
                endDate: isOrderScoped ? undefined : (endDate || undefined),
                limit: PAGE_SIZE,
                offset,
            });
            if (offset === 0) {
                setTotal(data.length > 0 ? Number(data[0].total_count) : 0);
                setLogs(data);
            } else {
                if (data.length > 0) setTotal(Number(data[0].total_count));
                setLogs(prev => [...prev, ...data]);
            }
            setAuditMissing(isAuditTrailMissing());
        } catch (err: any) {
            console.error(err);
            setError(err?.message || 'Không tải được nhật ký hoạt động');
        } finally {
            setLoading(false);
        }
    };

    const formatAction = (type: string) => {
        const found = ACTION_OPTIONS.find(a => a.value === type);
        if (found) return found.label;
        const legacy: Record<string, string> = {
            'PAYMENT_SETTLED': 'Chốt thanh toán',
            'PAYMENT_UNDONE': 'Hoàn tác thanh toán',
            'PAYMENT_ADD': 'Thêm thanh toán',
            'KPI_UPDATE': 'Cập nhật KPI',
        };
        return legacy[type] || type;
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
        'total_amount': 'Tổng tiền',
        'total_amount_pre_vat': 'Tiền trước VAT',
        'vat_amount': 'Tiền VAT',
        'delivery_date': 'Ngày giao hàng',
        'completed_at': 'Thời điểm hoàn thành',
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
        'is_urgent': 'Đơn gấp',
        'payment_confirmed': 'Đã xác nhận TT',
        'payment_confirmed_by': 'Người xác nhận TT',
        'payment_method_deposit': 'PT thanh toán cọc',
        'payment_method_remaining': 'PT thanh toán còn lại',
        // Khách hàng
        'name': 'Tên',
        'phone': 'Số điện thoại',
        'email': 'Email',
        'address': 'Địa chỉ',
        'code': 'Mã',
        'crm_notes': 'Ghi chú CRM',
        'tags': 'Thẻ',
        'pipeline_stage': 'Giai đoạn CRM',
        'source': 'Nguồn',
        // Nhân viên
        'full_name': 'Họ tên',
        'role': 'Chức vụ',
        'is_locked': 'Bị khóa',
        'phone_number': 'Số điện thoại',
        'employee_code': 'Mã nhân viên',
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
            'Issued': 'Đã xuất',

            // Payment
            'ChuyenKhoan': 'Chuyển khoản',
            'TienMat': 'Tiền mặt',
            'ChuaThanhToan': 'Chưa thanh toán',
            'DaCoc': 'Đã cọc',
            'DaThanhToan': 'Đã thanh toán',
            'CongNo': 'Công nợ',
        };
        return map[val] || val;
    };

    /** Đưa một giá trị bất kỳ về chuỗi dễ đọc cho người dùng */
    const formatValue = (field: string, raw: any): string => {
        if (raw === null || raw === undefined || raw === '') return '(trống)';
        if (typeof raw === 'boolean') return raw ? 'Có' : 'Không';
        if (Array.isArray(raw)) return raw.length ? raw.join(', ') : '(trống)';
        if (typeof raw === 'object') return JSON.stringify(raw);

        if (typeof raw === 'number') {
            // Các trường tiền tệ hiển thị có dấu phân cách
            if (/_(amount|fee)$/.test(field)) return raw.toLocaleString('vi-VN') + 'đ';
            return String(raw);
        }

        const s = String(raw);
        // Ngày giờ ISO
        if (/^\d{4}-\d{2}-\d{2}([T ]|$)/.test(s)) {
            const d = new Date(s);
            if (!isNaN(d.getTime())) {
                return s.length <= 10
                    ? d.toLocaleDateString('vi-VN')
                    : d.toLocaleString('vi-VN');
            }
        }
        // Chuỗi số dạng numeric của Postgres cho cột tiền
        if (/_(amount|fee)$/.test(field) && /^-?\d+(\.\d+)?$/.test(s)) {
            return Number(s).toLocaleString('vi-VN') + 'đ';
        }
        return translateValue(s);
    };

    /** true nếu details ở định dạng mới { field: { old, new } } */
    const isDiffShape = (v: any) =>
        v && typeof v === 'object' && !Array.isArray(v) &&
        ('old' in v || 'new' in v);

    const renderChangeRows = (changes: Record<string, any>) => (
        <div className="flex flex-col gap-1 text-xs">
            {Object.entries(changes).map(([key, value]) => {
                const label = fieldTranslations[key] || key;
                if (isDiffShape(value)) {
                    const oldTxt = formatValue(key, value.old);
                    const newTxt = formatValue(key, value.new);
                    return (
                        <div key={key} className="flex flex-wrap gap-1 items-baseline">
                            <span className="font-medium text-gray-700 whitespace-nowrap">{label}:</span>
                            <span className="text-gray-500 line-through max-w-[220px] truncate" title={oldTxt}>{oldTxt}</span>
                            <i className="fa-solid fa-arrow-right text-[9px] text-gray-400"></i>
                            <span className="font-bold text-indigo-700 max-w-[220px] truncate" title={newTxt}>{newTxt}</span>
                        </div>
                    );
                }
                // Định dạng cũ: chỉ có giá trị mới
                const txt = formatValue(key, value);
                return (
                    <div key={key} className="flex gap-1 break-words">
                        <span className="font-medium text-gray-700 whitespace-nowrap">{label}:</span>
                        <span className="text-gray-900 truncate max-w-[220px]" title={txt}>{txt}</span>
                    </div>
                );
            })}
        </div>
    );

    const renderDetails = (log: ActivityLog) => {
        try {
            if (!log.details) return '-';

            // Công đoạn
            if (log.action_type === 'STAGE_JOIN' || log.action_type === 'STAGE_LEAVE') {
                return (
                    <span className="text-xs font-medium">
                        Công đoạn: <b className="text-indigo-600">{translateValue(log.details.stage)}</b>
                        {log.details.nguoi_thuc_hien && (
                            <span className="text-gray-500"> — {log.details.nguoi_thuc_hien}</span>
                        )}
                    </span>
                );
            }

            // Định dạng chuẩn: details.changes
            const changes = log.details.changes;
            if (changes && typeof changes === 'object' && Object.keys(changes).length > 0) {
                return renderChangeRows(changes);
            }

            // Định dạng cũ: old_status / new_status ở tầng gốc
            if (log.details.old_status || log.details.new_status) {
                return (
                    <span className="text-xs">
                        {translateValue(log.details.old_status)}
                        <i className="fa-solid fa-arrow-right mx-1 text-gray-400"></i>
                        <span className="font-bold text-indigo-600">{translateValue(log.details.new_status)}</span>
                    </span>
                );
            }

            // Định dạng cũ: details.fields là mảng tên trường
            if (log.details.fields && Array.isArray(log.details.fields)) {
                return (
                    <div className="text-xs text-gray-700">
                        Đã cập nhật: {log.details.fields.map((f: string) => (
                            <b key={f} className="ml-1">{fieldTranslations[f] || f},</b>
                        ))}
                    </div>
                );
            }

            // Fallback
            if (typeof log.details === 'object') {
                const entries = Object.entries(log.details);
                if (entries.length === 0) return <span className="text-xs text-gray-400">-</span>;
                return (
                    <div className="flex flex-col text-[10px] text-gray-600">
                        {entries.slice(0, 6).map(([k, v]) => (
                            <span key={k}>{fieldTranslations[k] || k}: <b>{String(v).substring(0, 60)}</b></span>
                        ))}
                    </div>
                );
            }

            return <span className="text-xs text-gray-500">{String(log.details)}</span>;
        } catch (e) {
            return <span className="text-xs text-red-400">Lỗi hiển thị chi tiết</span>;
        }
    };

    /** Chi tiết dạng văn bản thuần, dùng cho xuất CSV */
    const detailsToText = (log: ActivityLog): string => {
        try {
            if (!log.details) return '';
            if (log.action_type === 'STAGE_JOIN' || log.action_type === 'STAGE_LEAVE') {
                return `Công đoạn: ${translateValue(log.details.stage)}`;
            }
            const changes = log.details.changes;
            if (changes && typeof changes === 'object') {
                return Object.entries(changes).map(([k, v]: [string, any]) => {
                    const label = fieldTranslations[k] || k;
                    return isDiffShape(v)
                        ? `${label}: ${formatValue(k, v.old)} -> ${formatValue(k, v.new)}`
                        : `${label}: ${formatValue(k, v)}`;
                }).join(' | ');
            }
            return JSON.stringify(log.details);
        } catch {
            return '';
        }
    };

    const handleExportCSV = () => {
        try {
            const headers = ['Thời gian', 'Nhân viên', 'Chức vụ', 'Hành động', 'Loại', 'Đối tượng', 'Chi tiết', 'Nguồn'];
            const rows = logs.map(l => [
                new Date(l.created_at).toLocaleString('vi-VN'),
                l.user_name || '',
                l.user_role || '',
                formatAction(l.action_type),
                l.entity_type || '',
                l.entity_id || '',
                detailsToText(l),
                l.source === 'trigger' ? 'CSDL' : 'Ứng dụng',
            ]);

            const csvContent = '﻿' + [
                headers.join(','),
                ...rows.map(r => r.map(c => `"${String(c).replace(/"/g, '""')}"`).join(',')),
            ].join('\n');

            const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
            const url = URL.createObjectURL(blob);
            const link = document.createElement('a');
            link.setAttribute('href', url);
            link.setAttribute('download', `LichSuHoatDong_${new Date().toISOString().slice(0, 10)}.csv`);
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        } catch (e) {
            console.error('Export Error:', e);
            alert('Lỗi xuất file CSV.');
        }
    };

    if (!isOpen) return null;

    return (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-50 p-4">
            <div className="bg-white rounded-lg w-full max-w-6xl h-[90vh] flex flex-col shadow-xl animate-fade-in-up">
                {/* Header */}
                <div className="px-6 py-4 border-b flex justify-between items-center bg-gray-800 text-white rounded-t-lg">
                    <h2 className="text-xl font-bold">
                        <i className="fa-solid fa-history mr-2"></i>Lịch Sử Hoạt Động
                        {initialOrderCode && <span className="ml-2 text-sm font-normal opacity-80">— đơn {initialOrderCode}</span>}
                    </h2>
                    <button onClick={onClose} className="hover:text-gray-300"><i className="fa-solid fa-times text-xl"></i></button>
                </div>

                {/* Filters */}
                <div className="p-4 bg-gray-50 border-b flex flex-wrap gap-4 items-end">
                    <div>
                        <label className="text-xs font-bold text-gray-500 block mb-1">Nhân viên</label>
                        <select
                            className="border rounded px-3 py-1.5 text-sm w-44"
                            value={selectedUser}
                            onChange={e => setSelectedUser(e.target.value)}
                        >
                            <option value="">Tất cả nhân viên</option>
                            {users.map(u => <option key={u.id} value={u.id}>{u.full_name || u.email}</option>)}
                        </select>
                    </div>

                    <div>
                        <label className="text-xs font-bold text-gray-500 block mb-1">Hành động</label>
                        <select
                            className="border rounded px-3 py-1.5 text-sm w-44"
                            value={actionType}
                            onChange={e => setActionType(e.target.value)}
                        >
                            <option value="">Tất cả</option>
                            {ACTION_OPTIONS.map(a => <option key={a.value} value={a.value}>{a.label}</option>)}
                        </select>
                    </div>

                    <div>
                        <label className="text-xs font-bold text-gray-500 block mb-1">Loại đối tượng</label>
                        <select
                            className="border rounded px-3 py-1.5 text-sm w-36"
                            value={entityType}
                            onChange={e => setEntityType(e.target.value)}
                        >
                            <option value="">Tất cả</option>
                            {ENTITY_OPTIONS.map(t => <option key={t.value} value={t.value}>{t.label}</option>)}
                        </select>
                    </div>

                    <div>
                        <label className="text-xs font-bold text-gray-500 block mb-1">Mã đơn / Đối tượng</label>
                        <input
                            type="text"
                            className="border rounded px-3 py-1.5 text-sm w-40"
                            placeholder="Mã đơn, mã KH..."
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
                        onClick={() => handleFetchLogs(0)}
                        disabled={loading}
                        className="bg-indigo-600 text-white px-4 py-1.5 rounded hover:bg-indigo-700 text-sm font-bold flex items-center gap-2 disabled:opacity-50"
                    >
                        {loading ? <i className="fa-solid fa-spinner fa-spin"></i> : <i className="fa-solid fa-search"></i>}
                        Xem
                    </button>

                    <button
                        onClick={handleExportCSV}
                        disabled={logs.length === 0}
                        className="bg-green-600 text-white px-4 py-1.5 rounded hover:bg-green-700 text-sm font-bold disabled:opacity-50"
                    >
                        <i className="fa-solid fa-file-excel mr-1"></i> Xuất CSV
                    </button>

                    <button
                        onClick={() => { setSelectedUser(''); setActionType(''); setEntityType(''); setSearchOrder(''); }}
                        className="text-gray-500 hover:text-gray-700 text-sm underline"
                    >
                        Xóa lọc
                    </button>
                </div>

                {auditMissing && (
                    <div className="mx-4 mt-3 p-3 rounded bg-amber-50 border border-amber-300 text-amber-900 text-sm">
                        <div className="font-bold">
                            <i className="fa-solid fa-triangle-exclamation mr-1"></i>
                            Chưa cài đặt nhật ký ở tầng cơ sở dữ liệu
                        </div>
                        <div className="text-xs mt-1">
                            Đang hiển thị nhật ký cũ. <b>Các thao tác mới sẽ KHÔNG được ghi lại</b> cho tới khi
                            chạy file <code className="bg-amber-100 px-1 rounded">setup_audit_trail.sql</code> trong
                            Supabase → SQL Editor.
                        </div>
                    </div>
                )}

                {error && (
                    <div className="mx-4 mt-3 p-3 rounded bg-red-50 border border-red-200 text-red-700 text-sm">
                        <i className="fa-solid fa-triangle-exclamation mr-1"></i> {error}
                    </div>
                )}

                {/* Table */}
                <div className="flex-1 overflow-auto p-4">
                    <table className="w-full text-sm text-left border-collapse">
                        <thead className="bg-gray-100 text-gray-600 sticky top-0 z-10">
                            <tr>
                                <th className="p-3 border-b whitespace-nowrap">Thời gian</th>
                                <th className="p-3 border-b">Nhân viên</th>
                                <th className="p-3 border-b">Hành động</th>
                                <th className="p-3 border-b">Đối tượng</th>
                                <th className="p-3 border-b">Nội dung thay đổi</th>
                            </tr>
                        </thead>
                        <tbody className="divide-y">
                            {logs.map(log => (
                                <tr key={log.id} className="hover:bg-blue-50 align-top">
                                    <td className="p-3 text-gray-500 font-mono text-xs whitespace-nowrap">
                                        {new Date(log.created_at).toLocaleString('vi-VN')}
                                    </td>
                                    <td className="p-3">
                                        <div className="font-medium text-gray-800">{log.user_name || 'Không rõ'}</div>
                                        {log.user_role && <div className="text-[10px] text-gray-500">{log.user_role}</div>}
                                        {log.source === 'trigger' && (
                                            <span className="text-[9px] text-teal-700 bg-teal-50 border border-teal-200 px-1 rounded" title="Ghi bởi CSDL, không thể sửa hay bỏ qua">
                                                <i className="fa-solid fa-lock mr-0.5"></i>CSDL
                                            </span>
                                        )}
                                    </td>
                                    <td className="p-3">
                                        <span className={`px-2 py-1 rounded text-xs font-bold whitespace-nowrap
                                            ${log.action_type.includes('LOGIN') || log.action_type.includes('LOGOUT') ? 'bg-gray-100 text-gray-600' : ''}
                                            ${log.action_type.includes('CREATE') ? 'bg-green-100 text-green-700' : ''}
                                            ${log.action_type.includes('DELETE') ? 'bg-red-100 text-red-700' : ''}
                                            ${log.action_type.includes('UPDATE') ? 'bg-blue-100 text-blue-700' : ''}
                                            ${log.action_type.includes('PAYMENT') ? 'bg-yellow-100 text-orange-700' : ''}
                                            ${log.action_type.includes('STAGE') ? 'bg-indigo-100 text-indigo-700' : ''}
                                        `}>
                                            {formatAction(log.action_type)}
                                        </span>
                                    </td>
                                    <td className="p-3 font-bold text-indigo-700 whitespace-nowrap">
                                        {log.entity_id}
                                    </td>
                                    <td className="p-3 text-gray-600 max-w-lg break-words">
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

                {/* Footer / phân trang */}
                <div className="px-4 py-3 border-t bg-gray-50 flex items-center justify-between rounded-b-lg">
                    <span className="text-xs text-gray-500">
                        Hiển thị {logs.length} / {total} bản ghi
                    </span>
                    {logs.length < total && (
                        <button
                            onClick={() => handleFetchLogs(logs.length)}
                            disabled={loading}
                            className="px-4 py-1.5 bg-gray-700 text-white rounded text-sm font-bold hover:bg-gray-800 disabled:opacity-50"
                        >
                            {loading ? <i className="fa-solid fa-spinner fa-spin mr-1"></i> : <i className="fa-solid fa-chevron-down mr-1"></i>}
                            Xem thêm
                        </button>
                    )}
                </div>
            </div>
        </div>
    );
};

export default ActivityLogModal;
