
import React, { useState } from 'react';
import { formatDate, formatDateTime } from '../utils/dateFormatter';
import { Order } from '../types';
import { COLORS, STATUS_LABEL_MAP, WORKFLOW_STATUS_KEYS } from '../constants';
import StageControl from './StageControl';
import TaskControl from './TaskControl';
import { orderService } from '../services/orderService';
import { generatePrintHTML } from '../utils/printGenerator';
import { LOGO_BASE64 } from '../utils/logoData';
import QuickEditModal from './QuickEditModal';
import PaymentConfirmationModal from './PaymentConfirmationModal';
import InvoiceInfoModal from './InvoiceInfoModal';
import { PaymentQRModal } from './PaymentQRModal';
import CommentSection from './CommentSection';
import { commentService, Comment } from '../services/commentService';

interface OrderCardProps {
    order: Order;
    onEdit: (order: Order) => void;
    onRefresh: () => void;
    currentUser: any;
    onViewHistory?: (orderCode: string) => void; // NEW
}

const OrderCard: React.FC<OrderCardProps> = ({ order, onEdit, onRefresh, currentUser, onViewHistory }) => {
    const [showInvoiceInfo, setShowInvoiceInfo] = useState(false);
    const [showInvoiceModal, setShowInvoiceModal] = useState(false);
    const [showQRModal, setShowQRModal] = useState(false);
    const isUrgent = order.is_urgent;
    const borderColor = isUrgent ? COLORS.warning : COLORS.primary;

    // Role Barriers (Strict)
    const canEditDetails = ['Admin', 'NhanVienKinhDoanh'].includes(currentUser?.role); // Removed 'KeToan'
    const canManagePayment = ['Admin', 'admin', 'NhanVienKinhDoanh', 'KeToan'].includes(currentUser?.role); // General Payment View/Dropdown
    const canManageInvoice = ['Admin', 'admin', 'NhanVienKinhDoanh', 'KeToan'].includes(currentUser?.role); // NEW: Allow Accountant to export Invoice
    // Strict confirm for the green button per user request
    const canConfirmPayment = ['Admin', 'admin'].includes(currentUser?.role);
    // Restore cancelled order
    const canRestoreOrder = ['Admin', 'NhanVienKinhDoanh'].includes(currentUser?.role);

    const [editingField, setEditingField] = React.useState<{ field: keyof Order | 'payment_note', title: string, value: string } | null>(null);
    const [showPaymentConfirmModal, setShowPaymentConfirmModal] = React.useState(false);
    const [pendingPaymentStatus, setPendingPaymentStatus] = React.useState<any>(null); // To hold status change while confirming

    // OPTIMISTIC UI STATE
    const [optimisticStatus, setOptimisticStatus] = useState(order.status);
    const [statusComments, setStatusComments] = useState<Comment[]>([]);
    const [noteComments, setNoteComments] = useState<Comment[]>([]);

    // Fetch Rich Comments (Metadata)
    // Fetch Rich Comments (Metadata)
    React.useEffect(() => {
        if (order.id) {
            // Helper to process recent comments
            const processComments = (events: Comment[]) => {
                if (events.length === 0) return [];
                return events;
            };

            // Fetch Status Note Comment
            commentService.getComments(order.id, 'status_note')
                .then(events => {
                    const display = processComments(events);
                    if (display) setStatusComments(display);
                })
                .catch(console.error);

            // Fetch Order Note Comment
            commentService.getComments(order.id, 'notes')
                .then(events => {
                    const display = processComments(events);
                    if (display) setNoteComments(display);
                })
                .catch(console.error);
        }
    }, [order.id]);

    // Sync optimistic status when prop changes (e.g. background refresh)
    React.useEffect(() => {
        setOptimisticStatus(order.status);
    }, [order.status]);

    const handleQuickSave = async (newValue: string, keepOpen = false) => {
        if (!editingField) return;

        // Map UI fields to DB fields if necessary
        const updates: any = {};
        updates[editingField.field] = newValue;

        // Optimistic Update
        const plainUpdates: any = {};
        plainUpdates[editingField.field] = newValue;

        const optimisticComment: Comment = {
            id: 'temp-' + Date.now(),
            order_id: order.id,
            user_id: currentUser?.id,
            user: currentUser, // Profile
            content: newValue,
            created_at: new Date().toISOString(),
            context_key: editingField.field
        };

        if (editingField.field === 'status_note') setStatusComments(prev => [...prev, optimisticComment]);
        if (editingField.field === 'notes') setNoteComments(prev => [...prev, optimisticComment]);

        await orderService.updateOrder(order.id, plainUpdates);
        onRefresh();
        if (!keepOpen) {
            setEditingField(null);
        }
    };

    // ... (keep handleSaveInvoiceInfo and handleAction same) ...

    const handleSaveInvoiceInfo = async (infoString: string) => {
        try {
            await orderService.updateOrder(order.id, { invoice_info: infoString });
            onRefresh();
            setShowInvoiceModal(false);
        } catch (error) {
            console.error(error);
            alert("Lỗi khi cập nhật thông tin xuất hóa đơn: " + (error as Error).message);
        }
    };

    // Helper to handle button clicks
    const handleAction = async (action: string) => {
        // Skip confirmation for non-destructive actions like History or Print or Resume
        if (action !== 'Lịch sử' && action !== 'In phiếu' && action !== 'In phiếu giao hàng' && action !== 'Tiếp tục' && !confirm(`Bạn có chắc chắn muốn ${action} đơn hàng này ? `)) return;

        try {
            switch (action) {
                // ... (Cases kept same logically but using handleStatusChange wrapper if we wanted, but handleAction buttons are complex. 
                // Let's keep them as is. Optimistic UI is critical for the Uncontrolled Select mostly.)
                case "Hoàn thành":
                    await orderService.updateStatus(order.id, 'HoanThanh');
                    break;
                case "Hoàn tác": // NEW: Undo Complete
                    await orderService.updateStatus(order.id, 'DaGiaoHang');
                    break;
                case "Tạm ngưng":
                    await orderService.updateStatus(order.id, 'TamNgung');
                    break;
                case "Tiếp tục":
                    await orderService.updateStatus(order.id, 'BinhFile');
                    break;
                case "Xóa": // Cancel
                    await orderService.updateStatus(order.id, 'Huy');
                    break;

                case "In phiếu":
                case "In phiếu giao hàng":
                    const type = action === "In phiếu" ? 'receipt' : 'delivery';
                    const html = generatePrintHTML(order, type, LOGO_BASE64, undefined);
                    const win = window.open('', '_blank');
                    if (win) {
                        win.document.write(html);
                        win.document.close();
                    }
                    break;

                case "Lịch sử":
                    if (onViewHistory) {
                        onViewHistory(order.order_code);
                    } else {
                        alert("Chức năng Lịch sử đang phát triển");
                    }
                    return;
                default:
                    alert(`Chức năng ${action} chưa được liên kết.`);
                    return;
            }
            // Success
            onRefresh();
        } catch (error) {
            console.error(error);
            alert("Có lỗi xảy ra: " + (error as Error).message);
        }
    };

    const handleJoinStage = async (stageKey: string) => {
        if (!currentUser?.id) {
            alert("Vui lòng đăng nhập lại.");
            return;
        }
        try {
            await orderService.joinStage(order.id, stageKey, currentUser.id);
            onRefresh();
        } catch (e) {
            alert("Lỗi khi tham gia: " + (e as Error).message);
        }
    };

    const handleLeaveStage = async (stageKey: string) => {
        if (!currentUser?.id) return;
        try {
            await orderService.leaveStage(order.id, stageKey, currentUser.id);
            onRefresh();
        } catch (e) {
            alert("Lỗi khi hoàn tác: " + (e as Error).message);
        }
    };

    const checkIsJoined = (stageKey: string) => {
        return order.participants?.some(p => p.stage === stageKey && p.user_id === currentUser?.id);
    };

    const renderStageControl = () => {
        switch (order.status) {
            case 'BinhFile':
                return (
                    <div className="p-3 bg-white border-b border-gray-100">
                        <StageControl
                            stageKey="BinhFile"
                            stageLabel="Bình File"
                            orderId={order.id}
                            participants={order.participants?.filter(p => p.stage === 'BinhFile') || []}
                            color={COLORS.stageBinhFile}
                            isProminent={true}
                            onJoin={() => handleJoinStage('BinhFile')}
                            onLeave={() => handleLeaveStage('BinhFile')}
                            isJoined={checkIsJoined('BinhFile')}
                            readOnly={isLocked}
                        />
                    </div>
                );
            case 'In':
                return (
                    <div className="p-3 bg-white border-b border-gray-100">
                        <StageControl
                            stageKey="In"
                            stageLabel="In"
                            orderId={order.id}
                            participants={order.participants?.filter(p => p.stage === 'In') || []}
                            color={COLORS.stageIn}
                            isProminent={true}
                            onJoin={() => handleJoinStage('In')}
                            onLeave={() => handleLeaveStage('In')}
                            isJoined={checkIsJoined('In')}
                            readOnly={isLocked}
                        />
                    </div>
                );
            case 'ThanhPham':
                return (
                    <div className="p-3 bg-white border-b border-gray-100">
                        <StageControl
                            stageKey="ThanhPham"
                            stageLabel="Thành Phẩm"
                            orderId={order.id}
                            participants={order.participants?.filter(p => p.stage === 'ThanhPham') || []}
                            color={COLORS.stageThanhPham}
                            isProminent={true}
                            onJoin={() => handleJoinStage('ThanhPham')}
                            onLeave={() => handleLeaveStage('ThanhPham')}
                            isJoined={checkIsJoined('ThanhPham')}
                            readOnly={isLocked}
                        />
                    </div>
                );
            default:
                return null;
        }
    };

    // ... (Body Details and Payment Sections can remain mostly same, focusing on status logic) ... 
    // Simplified rendering for brevity in this replacement block, but keep the structure

    const isPaused = order.status === 'TamNgung';
    const isCompleted = order.status === 'HoanThanh';
    const isCancelled = order.status === 'Huy'; // NEW
    const isLocked = isPaused || isCompleted || isCancelled; // Locked if Cancelled too

    return (
        <div
            className={`bg-white rounded-lg shadow-sm hover:shadow-md transition-all duration-200 overflow-hidden border-l-[6px] flex flex-col h-full 
                ${isPaused ? 'bg-gray-50' : ''}
                ${isUrgent && !isCancelled && !isCompleted ? 'bg-red-50 border-red-500 ring-1 ring-red-200 shadow-red-100' : ''} 
                ${isCancelled ? 'bg-gray-100 border-gray-400 opacity-75' : ''}
`}
            style={{ borderLeftColor: isPaused ? '#9ca3af' : (isCancelled ? '#9ca3af' : (isUrgent ? '#ef4444' : borderColor)) }}
        >
            <div className={`flex-1 flex flex-col ${isPaused ? 'opacity-50 pointer-events-none grayscale' : ''} ${isCancelled ? 'grayscale' : ''} `}>
                {/* Header */}
                <div className="p-3 border-b border-gray-100 flex justify-between items-start">
                    <div className="overflow-hidden">
                        <div className="flex items-center gap-2 max-w-full">
                            <h4 className="font-bold text-[#333] text-base md:text-xl leading-tight break-all">{order.order_code}</h4>
                        </div>
                        <div className="flex items-center gap-2 mt-1">
                            {isUrgent && !isCancelled && !isCompleted && (
                                <span className="animate-pulse px-2 py-0.5 rounded text-[10px] font-black bg-red-600 text-white uppercase tracking-wider shadow-sm shrink-0">
                                    GẤP
                                </span>
                            )}
                            <span className="text-sm font-bold text-[#00796b] block break-words">{order.customer?.name || 'Vãng lai'}</span>
                        </div>
                    </div>
                    <div className="shrink-0 flex items-center gap-2">
                        {canEditDetails && !isCompleted && (
                            <button
                                onClick={(e) => { e.stopPropagation(); onEdit(order); }}
                                className="w-8 h-8 flex items-center justify-center rounded-full text-gray-400 hover:text-[#00796b] hover:bg-teal-50 transition-colors"
                                title="Chỉnh sửa Chi tiết"
                            >
                                <i className="fa-solid fa-pen"></i>
                            </button>
                        )}
                        <button
                            onClick={async (e) => {
                                e.stopPropagation();
                                try {
                                    const text = [
                                        `Mã đơn: ${order.order_code} `,
                                        `Khách hàng: ${order.customer?.name || 'Vãng lai'} `,
                                        `Quy cách: \n${order.description || ''} `,
                                        `Tổng tiền: ${order.total_amount?.toLocaleString('vi-VN')} đ`
                                    ].join('\n\n');

                                    await navigator.clipboard.writeText(text);
                                    alert('✅ Đã sao chép nội dung (Text) thành công!');
                                } catch (err) {
                                    console.error('Failed to copy:', err);
                                    // Fallback for older browsers
                                    const text = [
                                        `Mã đơn: ${order.order_code} `,
                                        `Khách hàng: ${order.customer?.name || 'Vãng lai'} `,
                                        `Quy cách: \n${order.description || ''} `,
                                        `Tổng tiền: ${order.total_amount?.toLocaleString('vi-VN')} đ`
                                    ].join('\n\n');

                                    const textArea = document.createElement("textarea");
                                    textArea.value = text;
                                    document.body.appendChild(textArea);
                                    textArea.focus();
                                    textArea.select();
                                    try {
                                        document.execCommand('copy');
                                        alert('✅ Đã sao chép nội dung (Text) thành công!');
                                    } catch (err) {
                                        alert('Không thể sao chép tự động. Vui lòng chọn thủ công.');
                                    }
                                    document.body.removeChild(textArea);
                                }
                            }}
                            className="w-8 h-8 flex items-center justify-center rounded-full text-gray-400 hover:text-[#00796b] hover:bg-teal-50 transition-colors"
                            title="Sao chép nội dung (Text)"
                        >
                            <i className="fa-regular fa-copy"></i>
                        </button>
                        <select
                            className="text-sm bg-white border border-gray-300 rounded px-3 py-1.5 font-bold text-gray-800 focus:outline-none shadow-sm"
                            value={optimisticStatus}
                            onChange={async (e) => {
                                const newStatus = e.target.value as any;
                                const oldStatus = optimisticStatus;

                                // Optimistic Update (Instant)
                                setOptimisticStatus(newStatus);

                                try {
                                    await orderService.updateStatus(order.id, newStatus);
                                    onRefresh();
                                } catch (error) {
                                    console.error("Status update failed:", error);
                                    setOptimisticStatus(oldStatus); // Revert on failure
                                    alert("Lỗi cập nhật trạng thái: " + (error as Error).message);
                                }
                            }}
                            disabled={isPaused}
                        >
                            {WORKFLOW_STATUS_KEYS.map(key => (
                                <option key={key} value={key}>{STATUS_LABEL_MAP[key]}</option>
                            ))}
                            {!WORKFLOW_STATUS_KEYS.includes(order.status) && order.status !== 'Moi' && (
                                <option value={order.status}>{STATUS_LABEL_MAP[order.status] || order.status}</option>
                            )}
                        </select>
                    </div>
                </div>

                {/* Dynamic Stage Button */}
                {renderStageControl()}

                {/* Body Details - Grid Layout matches Screenshot */}
                <div className="p-4 space-y-3 flex-1 text-[14px]">

                    {/* Row: Quy cách */}
                    <div className="grid grid-cols-[85px_1fr] gap-2 items-start">
                        <span className="text-gray-600 font-medium pt-1">Quy cách:</span>
                        <div className="relative group">
                            {canEditDetails && !isLocked && (
                                <button
                                    className="absolute top-0 right-0 p-1 text-gray-400 hover:text-gray-600 hover:bg-gray-100 rounded-full transition-colors"
                                    onClick={(e) => {
                                        e.stopPropagation();
                                        setEditingField({ field: 'description', title: 'Sửa Quy cách', value: order.description || '' });
                                    }}
                                    title="Sửa quy cách"
                                >
                                    <i className="fa-solid fa-pen text-xs"></i>
                                </button>
                            )}
                            <p className="text-gray-800 whitespace-pre-line mb-2 pr-6">{order.description}</p>
                            <div className="bg-gray-50 border border-gray-200 rounded px-2 py-1.5 text-right text-xs mt-1">
                                <span className="text-gray-600">{order.total_amount_pre_vat?.toLocaleString('vi-VN')} + {order.vat_amount?.toLocaleString('vi-VN')} (VAT) = </span>
                                <span className="text-red-600 font-bold text-sm">{order.total_amount?.toLocaleString('vi-VN')}</span>
                            </div>

                            {/* Invoice Confirmation Button with Popover - NEW PLACEMENT */}
                            {order.vat_amount > 0 && canManageInvoice && (
                                <div className="mt-2 text-right relative">
                                    {!order.invoice_info ? (
                                        <div className="flex justify-end gap-2 items-center">
                                            {!isLocked && (
                                                <button
                                                    className="px-2 py-1 text-[10px] font-bold bg-yellow-100 text-yellow-700 hover:bg-yellow-200 rounded transition-colors whitespace-nowrap"
                                                    onClick={(e) => {
                                                        e.stopPropagation();
                                                        setShowInvoiceModal(true);
                                                    }}
                                                    title="Mở đơn hàng để bổ sung thông tin VAT"
                                                >
                                                    <i className="fa-solid fa-pen-to-square mr-1"></i>Bổ sung TT
                                                </button>
                                            )}
                                            <div className="relative group">
                                                <button
                                                    className="px-3 py-1 text-xs font-bold rounded-full bg-gray-200 text-gray-400 cursor-not-allowed inline-flex items-center gap-1"
                                                    onClick={(e) => {
                                                        e.stopPropagation();
                                                        alert("Vui lòng nhập thông tin xuất hóa đơn trước. Yêu cầu Nhân viên kinh doanh bổ sung.");
                                                    }}
                                                >
                                                    <i className="fa-solid fa-file-invoice-dollar"></i> Xuất HĐ
                                                </button>
                                                {/* Warning Tooltip */}
                                                <div className="absolute bottom-full right-0 mb-2 w-48 bg-black text-white text-xs rounded p-2 hidden group-hover:block z-50 text-center animate-fadeIn">
                                                    Chưa có thông tin xuất HĐ.<br />Vui lòng bổ sung trước.
                                                    <div className="absolute top-full right-4 border-4 border-transparent border-t-black"></div>
                                                </div>
                                            </div>
                                        </div>
                                    ) : (
                                        <div className="flex justify-end gap-2 items-center">
                                            {!isLocked && (
                                                <button
                                                    className="px-2 py-1 text-[10px] font-bold bg-blue-50 text-blue-600 hover:bg-blue-100 rounded transition-colors whitespace-nowrap"
                                                    onClick={(e) => {
                                                        e.stopPropagation();
                                                        setShowInvoiceModal(true);
                                                    }}
                                                    title="Sửa thông tin xuất hóa đơn"
                                                >
                                                    <i className="fa-solid fa-pen mr-1"></i>Sửa TT
                                                </button>
                                            )}
                                            <button
                                                className={`px-3 py-1 text-xs font-bold rounded-full transition-colors inline-flex items-center gap-1 ${order.invoice_status === 'Issued'
                                                    ? 'bg-green-100 text-green-700 hover:bg-green-200'
                                                    : 'bg-red-100 text-red-600 hover:bg-red-200'
                                                    } `}
                                                onClick={(e) => {
                                                    e.stopPropagation();
                                                    setShowInvoiceInfo(!showInvoiceInfo);
                                                }}
                                            >
                                                {order.invoice_status === 'Issued' ? <i className="fa-solid fa-check"></i> : <i className="fa-solid fa-file-invoice-dollar"></i>}
                                                {order.invoice_status === 'Issued' ? 'Đã xuất HĐ' : 'Xuất HĐ'}
                                            </button>

                                            {/* Info Popover */}
                                            {showInvoiceInfo && (
                                                <div className="absolute right-0 bottom-full mb-2 w-72 bg-white border border-gray-200 shadow-xl rounded-lg p-4 z-50 text-left animate-fadeIn">
                                                    <div className="flex justify-between items-center mb-2 border-b pb-2">
                                                        <span className="text-xs font-bold text-gray-700 uppercase">Thông tin xuất HĐ</span>
                                                        <div className="flex gap-2">
                                                            <button
                                                                onClick={(e) => {
                                                                    e.stopPropagation();
                                                                    setShowInvoiceInfo(false);
                                                                    setShowInvoiceModal(true);
                                                                }}
                                                                disabled={isLocked}
                                                                className={`text-blue-600 hover:text-blue-800 text-xs font-bold flex items-center gap-1 ${isLocked ? 'opacity-50 cursor-not-allowed' : ''} `}
                                                                title="Sửa thông tin"
                                                            >
                                                                <i className="fa-solid fa-pen"></i> Sửa
                                                            </button>
                                                            <button onClick={(e) => { e.stopPropagation(); setShowInvoiceInfo(false); }} className="text-gray-400 hover:text-gray-600"><i className="fa-solid fa-times"></i></button>
                                                        </div>
                                                    </div>
                                                    <div className="text-sm text-gray-800 whitespace-pre-line leading-relaxed mb-3 bg-gray-50 p-2 rounded border border-gray-100">
                                                        {order.invoice_info || <span className="italic text-gray-400">Chưa có thông tin xuất hóa đơn</span>}
                                                    </div>

                                                    <div className="text-right">
                                                        <button
                                                            disabled={order.status === 'Huy'}
                                                            className={`px-3 py-1.5 text-xs font-bold text-white rounded shadow-sm flex items-center gap-2 ml-auto ${order.invoice_status === 'Issued' ? 'bg-orange-500 hover:bg-orange-600' : 'bg-blue-600 hover:bg-blue-700'
                                                                } ${order.status === 'Huy' ? 'opacity-50 cursor-not-allowed' : ''} `}
                                                            onClick={async (e) => {
                                                                e.stopPropagation();
                                                                const newStatus = order.invoice_status === 'Issued' ? 'Pending' : 'Issued';
                                                                if (confirm(newStatus === 'Issued' ? 'Xác nhận ĐÃ XUẤT hóa đơn?' : 'Hoàn tác trạng thái Xuất hóa đơn?')) {
                                                                    await orderService.updateOrder(order.id, { invoice_status: newStatus });
                                                                    setShowInvoiceInfo(false);
                                                                    onRefresh();
                                                                }
                                                            }}
                                                        >
                                                            {order.invoice_status === 'Issued' ? <><i className="fa-solid fa-rotate-left"></i> Hoàn tác</> : <><i className="fa-solid fa-check"></i> Xác nhận đã xuất</>}
                                                        </button>
                                                    </div>

                                                    {/* Arrow */}
                                                    <div className="absolute top-full right-4 border-8 border-transparent border-t-white filters drop-shadow-sm"></div>
                                                </div>
                                            )}
                                        </div>
                                    )}
                                </div>
                            )}
                        </div>
                    </div>

                    {/* Row: Ghi chú ĐH */}
                    <div className="grid grid-cols-[85px_1fr] gap-2 items-start">
                        <span className="text-gray-600 font-medium leading-tight pt-1">Ghi chú<br />Đơn Hàng:</span>
                        <div className="flex items-start justify-between">
                            {/* Display latest note logic - implied that Order.notes is latest */}
                            {/* Display Order Note with Metadata */}
                            <div className="flex flex-col w-full gap-2 border-l-2 border-gray-100 pl-2">
                                {noteComments.length > 0 ? (
                                    noteComments.map((comment, idx) => (
                                        <div key={comment.id || idx} className="border-b last:border-0 border-dashed border-gray-200 pb-1 last:pb-0">
                                            <div className="text-red-600 font-bold whitespace-pre-wrap break-words text-[13px]">
                                                {comment.content}
                                            </div>
                                            <div className="text-[10px] text-gray-400 mt-0.5 italic flex gap-2">
                                                <span className="font-semibold">{comment.user?.full_name || 'N/A'}</span>
                                                <span>{formatDateTime(comment.created_at)}</span>
                                            </div>
                                        </div>
                                    ))
                                ) : (
                                    <div className="text-red-600 font-bold whitespace-pre-wrap break-words">
                                        {order.notes || "Không có"}
                                    </div>
                                )}
                            </div>
                            <button
                                onClick={(e) => {
                                    e.stopPropagation();
                                    // Open Comment Section for 'notes'
                                    setEditingField({ field: 'notes', title: 'Ghi chú Đơn hàng (Hội thoại)', value: order.notes || '' });
                                }}
                                title="Xem/Sửa hội thoại ghi chú"
                                disabled={isLocked}
                                className={`p-1 text-gray-400 hover:text-gray-600 hover:bg-gray-100 rounded-full transition-colors -mt-1 ${isLocked ? 'hidden' : ''} `}
                            >
                                <i className="fa-solid fa-comments text-xs"></i>
                            </button>
                        </div>
                    </div>

                    {/* Row: Ghi chú TT */}
                    <div className="grid grid-cols-[85px_1fr] gap-2 items-start">
                        <span className="text-gray-600 font-medium leading-tight pt-1">Ghi chú<br />Trạng Thái:</span>
                        <div className="flex items-start justify-between">
                            <div className="flex flex-col w-full gap-2 border-l-2 border-gray-100 pl-2">
                                {statusComments.length > 0 ? (
                                    statusComments.map((comment, idx) => (
                                        <div key={comment.id || idx} className="border-b last:border-0 border-dashed border-gray-200 pb-1 last:pb-0">
                                            <div className="text-gray-700 whitespace-pre-wrap break-words text-[13px]">
                                                {comment.content}
                                            </div>
                                            <div className="text-[10px] text-gray-400 mt-0.5 italic flex gap-2">
                                                <span className="font-semibold">{comment.user?.full_name || 'N/A'}</span>
                                                <span>{formatDateTime(comment.created_at)}</span>
                                            </div>
                                        </div>
                                    ))
                                ) : (
                                    <div className="text-gray-700 whitespace-pre-wrap break-words">
                                        {order.status_note || "Không có"}
                                    </div>
                                )}
                            </div>
                            <button
                                onClick={(e) => {
                                    e.stopPropagation();
                                    setEditingField({ field: 'status_note', title: 'Sửa Ghi chú Trạng thái', value: statusComments.length > 0 ? statusComments[statusComments.length - 1].content : (order.status_note || '') });
                                }}
                                title="Sửa ghi chú trạng thái"
                                disabled={isLocked}
                                className={`p-1 text-gray-400 hover:text-gray-600 hover:bg-gray-100 rounded-full transition-colors -mt-1 ${isLocked ? 'hidden' : ''} `}
                            >
                                <i className="fa-solid fa-pen text-xs"></i>
                            </button>
                        </div>
                    </div>

                    {/* Row: Thanh toán (Complex UI) */}
                    <div className="grid grid-cols-[85px_1fr] gap-2 items-start">
                        <div className="flex flex-col gap-2">
                            <span className="text-gray-600 font-medium mt-1.5 leading-tight">Thanh toán:</span>
                            {canManagePayment && order.status !== 'Huy' && (
                                <button
                                    onClick={(e) => {
                                        e.stopPropagation();
                                        setShowQRModal(true);
                                    }}
                                    className={`w-full py-1.5 px-1 rounded shadow-sm flex flex-col items-center justify-center gap-0.5 transition-colors h-auto bg-[#00796b] text-white hover:bg-teal-700`}
                                    title="Tạo mã QR thanh toán"
                                >
                                    <i className="fa-solid fa-qrcode text-xs"></i>
                                    <span className="text-[9px] font-bold leading-tight text-center">Tạo QR<br />Thanh toán</span>
                                </button>
                            )}
                        </div>
                        <div className="w-full">
                            <select
                                className="w-full text-sm border border-gray-300 rounded px-2 py-1.5 mb-2 focus:outline-none focus:border-[#00796b]"
                                value={order.payment_status}
                                disabled={!canManagePayment || isPaused} // Only lock on Pause, not Complete
                                onChange={async (e) => {
                                    const newStatus = e.target.value as any;

                                    // If changing to Deposit/Paid, open confirmation modal FIRST
                                    if (newStatus === 'DaCoc' || newStatus === 'DaThanhToan') {
                                        setPendingPaymentStatus(newStatus);
                                        setShowPaymentConfirmModal(true);
                                    } else {
                                        // Otherwise update immediately
                                        await orderService.updateOrder(order.id, { payment_status: newStatus });
                                        onRefresh();
                                    }
                                }}
                            >
                                <option value="ChuaThanhToan">Chưa thanh toán</option>
                                <option value="DaCoc">Đã cọc</option>
                                <option value="DaThanhToan">Đã thanh toán</option>
                                <option value="CongNo">Công nợ</option>
                            </select>

                            {/* Payment Confirmation Logic */}
                            <div className="mt-1">
                                {order.payment_confirmed ? (
                                    <div className={`border px-3 py-2 rounded text-xs relative overflow-hidden ${order.payment_status === 'DaCoc' ? 'bg-blue-50 border-blue-200 text-blue-800' : 'bg-green-50 border-green-200 text-green-800'} `}>
                                        <div className="flex justify-between items-start gap-2">
                                            <div className="flex-1">
                                                <div className="font-bold flex items-center gap-1 mb-1 text-sm">
                                                    {order.payment_status === 'DaCoc' ? (
                                                        <><i className="fa-solid fa-file-invoice-dollar text-blue-600"></i> ĐÃ XÁC NHẬN CỌC</>
                                                    ) : (
                                                        <><i className="fa-solid fa-check-double text-green-600"></i> ĐÃ THANH TOÁN</>
                                                    )}
                                                </div>
                                                <div className="text-[11px] text-gray-600 mb-2">
                                                    <div>Bởi: <strong className="text-gray-800">{order.payment_confirmed_by_user?.full_name || order.payment_confirmed_by || 'N/A'}</strong></div>
                                                    <div className="text-gray-500">{order.payment_confirmed_at ? formatDateTime(order.payment_confirmed_at) : ''}</div>
                                                </div>
                                            </div>
                                            <div className="flex flex-col gap-1 items-end">
                                                <button
                                                    disabled={isPaused} // Only lock on Pause
                                                    className={`bg-white border border-red-200 text-red-500 hover:bg-red-50 hover:border-red-300 px-2.5 py-1.5 rounded shadow-sm text-[11px] font-bold transition-colors flex items-center gap-1 ${isPaused ? 'opacity-50 cursor-not-allowed' : ''} `}
                                                    onClick={async () => {
                                                        const isPartialUndo = order.payment_status === 'DaThanhToan' && (order.deposit_amount || 0) > 0;
                                                        // Execute Undo immediately without confirmation dialog
                                                        if (isPartialUndo) {
                                                            // Revert to Deposit Confirmed
                                                            await orderService.updateOrder(order.id, {
                                                                payment_status: 'DaCoc',
                                                                payment_method_remaining: null as any,
                                                                remaining_amount: (order.total_amount - (order.deposit_amount || 0))
                                                            });
                                                        } else {
                                                            // Full Revert to Unpaid
                                                            await orderService.updateOrder(order.id, {
                                                                payment_status: 'ChuaThanhToan',
                                                                payment_confirmed: false,
                                                                payment_confirmed_at: null as any,
                                                                payment_confirmed_by: null as any,
                                                                payment_method_deposit: null as any,
                                                                payment_method_remaining: null as any,
                                                                deposit_amount: 0,
                                                                remaining_amount: order.total_amount
                                                            });
                                                        }
                                                        onRefresh();
                                                    }}
                                                    title="Hoàn tác xác nhận"
                                                >
                                                    <i className="fa-solid fa-rotate-left"></i> Hoàn tác
                                                </button>

                                                {order.payment_status === 'DaCoc' && (
                                                    <button
                                                        className="bg-white border border-green-200 text-green-600 hover:bg-green-50 hover:border-green-300 px-2.5 py-1.5 rounded shadow-sm text-[11px] font-bold transition-colors flex items-center gap-1"
                                                        onClick={() => {
                                                            setPendingPaymentStatus('DaThanhToan');
                                                            setShowPaymentConfirmModal(true);
                                                        }}
                                                        title="Thanh toán phần còn lại"
                                                    >
                                                        <i className="fa-solid fa-coins"></i> Thanh toán phần còn lại
                                                    </button>
                                                )}
                                            </div>
                                        </div>

                                        <div className="space-y-0.5 border-t border-green-200 pt-2 mt-1">
                                            {order.payment_method_deposit && <div>Cọc: <span className="font-semibold">{order.payment_method_deposit}</span></div>}
                                            {order.payment_method_remaining && <div>Còn lại: <span className="font-semibold">{order.payment_method_remaining}</span></div>}
                                            {order.payment_note && <div className="italic text-gray-500 mt-1">{order.payment_note}</div>}
                                        </div>
                                        <div className="text-gray-500 mt-1">
                                            Đã TT: <span className="font-semibold text-gray-700">
                                                {order.payment_status === 'DaThanhToan'
                                                    ? order.total_amount?.toLocaleString('vi-VN')
                                                    : (order.deposit_amount?.toLocaleString('vi-VN') || 0)} đ
                                            </span>
                                        </div>
                                    </div>
                                ) : (
                                    (order.payment_status === 'DaCoc' || order.payment_status === 'DaThanhToan') ? (
                                        <>
                                            <div className="text-xs text-gray-600 mb-2">
                                                <div><strong className="text-gray-700">Đã TT:</strong> {order.payment_status === 'DaThanhToan' ? order.total_amount?.toLocaleString('vi-VN') : (order.deposit_amount?.toLocaleString('vi-VN') || 0)} đ</div>
                                            </div>
                                            <button
                                                onClick={() => setShowPaymentConfirmModal(true)}
                                                disabled={isPaused} // Only lock on Pause
                                                // Only Admin can see/click the Confirm Payment Button
                                                className={`w-full bg-[#28a745] hover:bg-[#218838] text-white font-bold py-1.5 px-3 rounded shadow-sm transition-colors text-sm flex items-center justify-center gap-2 ${isPaused ? 'opacity-50 cursor-not-allowed' : ''} ${!canConfirmPayment ? 'hidden' : ''} `}
                                            >
                                                Xác nhận thanh toán
                                            </button>
                                        </>
                                    ) : (
                                        // Show "Waiting" only if NOT CongNo (Debt doesn't need confirmation of receipt)
                                        order.payment_status !== 'CongNo' && (
                                            <div className="bg-yellow-50 border border-yellow-200 text-yellow-800 px-3 py-1.5 rounded text-xs text-center">
                                                Chờ xác nhận
                                            </div>
                                        )
                                    )
                                )}
                            </div>
                        </div>
                    </div>

                    {/* Row: NV KD */}
                    <div className="grid grid-cols-[85px_1fr] gap-2 items-center pt-2 border-t border-gray-50 mt-1">
                        <span className="text-gray-600 font-medium">NV KD:</span>
                        <div className="text-gray-700">
                            {order.sales_rep?.full_name || 'N/A'} <span className="text-gray-400 mx-1">|</span> <strong>Giao:</strong> {formatDate(order.delivery_date) || 'N/A'}
                        </div>
                    </div>

                    {/* Tasks List */}
                    <div className="pt-4 mt-2 border-t border-gray-100">
                        <h4 className="font-bold text-gray-800 text-base mb-3">Công đoạn phụ</h4>
                        <div className="space-y-1">
                            {(() => {
                                const getParticipantInfo = (stageKey: string) => {
                                    // Find usage of 'started_at' as completion time because 'joinStage' sets 'started_at'
                                    const p = order.participants?.find(p => p.stage === stageKey);

                                    // Helper to format name: if it's an email (contains @), split it.
                                    // Also prioritize current user's name if IDs match and current user has a better name.
                                    let rawName = p?.user?.full_name;

                                    // 1. Fallback for self:
                                    if (p?.user_id && currentUser?.id === p.user_id && currentUser?.full_name && !currentUser.full_name.includes('@')) {
                                        rawName = currentUser.full_name;
                                    }

                                    const displayName = rawName && rawName.includes('@') ? rawName.split('@')[0] : rawName;

                                    return {
                                        completedBy: displayName,
                                        completedAt: p?.started_at,
                                        completedByUserId: p?.user_id
                                    };
                                };

                                return (
                                    <>
                                        <TaskControl
                                            orderId={order.id} taskKey="design_status" taskNoteKey="design_note" taskLabel="Thiết kế"
                                            hasTask={order.has_design}
                                            isCompleted={order.design_status === 'Completed' || order.status === 'HoanThanh' || order.status === 'DaGiaoHang'}
                                            color={COLORS.design} note={order.design_note}
                                            onEditNote={(key, val, label) => setEditingField({ field: key as keyof Order, title: `Ghi chú cho ${label} `, value: val })}
                                            currentUserId={currentUser?.id}
                                            userRole={currentUser?.role}
                                            onRefresh={onRefresh}
                                            readOnly={isLocked}
                                            {...getParticipantInfo('ThietKe')}
                                        />
                                        <TaskControl
                                            orderId={order.id} taskKey="large_print_status" taskNoteKey="large_print_note" taskLabel="In Khổ Lớn"
                                            hasTask={order.has_large_print}
                                            isCompleted={order.large_print_status === 'Completed' || order.status === 'HoanThanh' || order.status === 'DaGiaoHang'}
                                            color={COLORS.largeFormat} note={order.large_print_note}
                                            onEditNote={(key, val, label) => setEditingField({ field: key as keyof Order, title: `Ghi chú cho ${label} `, value: val })}
                                            currentUserId={currentUser?.id}
                                            userRole={currentUser?.role}
                                            onRefresh={onRefresh}
                                            readOnly={isLocked}
                                            {...getParticipantInfo('InKhoLon')}
                                        />
                                        <TaskControl
                                            orderId={order.id} taskKey="be_demi_status" taskNoteKey="be_demi_note" taskLabel="Bế Demi"
                                            hasTask={order.has_be_demi}
                                            isCompleted={order.be_demi_status === 'Completed' || order.status === 'HoanThanh' || order.status === 'DaGiaoHang'}
                                            color={COLORS.demiCut} note={order.be_demi_note}
                                            onEditNote={(key, val, label) => setEditingField({ field: key as keyof Order, title: `Ghi chú cho ${label} `, value: val })}
                                            currentUserId={currentUser?.id}
                                            userRole={currentUser?.role}
                                            onRefresh={onRefresh}
                                            readOnly={isLocked}
                                            {...getParticipantInfo('BeDemi')}
                                        />
                                        <TaskControl
                                            orderId={order.id} taskKey="outsource_status" taskNoteKey="outsource_note" taskLabel="Gia Công Ngoài"
                                            hasTask={order.has_gia_cong_ngoai}
                                            isCompleted={order.outsource_status === 'Completed' || order.status === 'HoanThanh' || order.status === 'DaGiaoHang'}
                                            color={COLORS.outsource} note={order.outsource_note}
                                            onEditNote={(key, val, label) => setEditingField({ field: key as keyof Order, title: `Ghi chú cho ${label} `, value: val })}
                                            currentUserId={currentUser?.id}
                                            userRole={currentUser?.role}
                                            onRefresh={onRefresh}
                                            readOnly={isLocked}
                                            {...getParticipantInfo('GiaCongNgoai')}
                                        />
                                        <TaskControl
                                            orderId={order.id} taskKey="ep_kim_status" taskNoteKey="ep_kim_note" taskLabel="Ép Kim"
                                            hasTask={order.has_ep_kim}
                                            isCompleted={order.ep_kim_status === 'Completed' || order.status === 'HoanThanh' || order.status === 'DaGiaoHang'}
                                            color={COLORS.hotFoil} note={order.ep_kim_note}
                                            onEditNote={(key, val, label) => setEditingField({ field: key as keyof Order, title: `Ghi chú cho ${label} `, value: val })}
                                            currentUserId={currentUser?.id}
                                            userRole={currentUser?.role}
                                            onRefresh={onRefresh}
                                            readOnly={isLocked}
                                            {...getParticipantInfo('EpKim')}
                                        />
                                    </>
                                );
                            })()}
                        </div>
                    </div>
                </div>
            </div >

            {/* Footer Actions */}
            <div className="px-2 py-2 bg-white border-t border-gray-100 flex flex-wrap items-center justify-end gap-1">
                {/* Special Case: Cancelled Order */}
                {isCancelled ? (
                    <>
                        <ActionButton
                            icon="fa-rotate-left"
                            color={COLORS.actionComplete} // Keep color
                            onClick={async () => {
                                if (confirm("Bạn có chắc muốn khôi phục đơn hàng này không?")) {
                                    await orderService.updateStatus(order.id, 'Moi'); // Restore to New
                                    onRefresh();
                                }
                            }}
                            title="Khôi phục đơn hàng"
                            label="Khôi phục"
                            disabled={!canRestoreOrder} // Disable if not allowed
                        // Or Hide completely: style={{ display: canRestoreOrder ? 'flex' : 'none' }}
                        />
                        <ActionButton icon="fa-clock-rotate-left" color={COLORS.actionHistory} onClick={() => handleAction("Lịch sử")} title="Lịch sử" label="Lịch sử" />
                    </>
                ) : (
                    <>
                        {/* 1. Standard Actions (Disabled when Paused) */}
                        <ActionButton
                            icon="fa-link"
                            color="#607d8b"
                            onClick={() => {
                                if (order.tracking_token) {
                                    const url = `${window.location.origin}/?tracking_code=${order.tracking_token}`;
                                    navigator.clipboard.writeText(url);
                                    alert('Đã sao chép link theo dõi đơn hàng!');
                                } else {
                                    alert('Đơn hàng này chưa có mã theo dõi.');
                                }
                            }}
                            title="Lấy link theo dõi"
                            disabled={isPaused}
                            label="Lấy Link"
                        />



                        <ActionButton icon="fa-clock-rotate-left" color={COLORS.actionHistory} onClick={() => handleAction("Lịch sử")} title="Lịch sử" disabled={isPaused} label="Lịch sử" />
                        <ActionButton icon="fa-print" color={COLORS.actionPrint} onClick={() => handleAction("In phiếu")} title="In phiếu" disabled={isPaused} label="In phiếu" />
                        <ActionButton icon="fa-truck" color={COLORS.actionShip} onClick={() => handleAction("In phiếu giao hàng")} title="In phiếu giao hàng" disabled={isPaused} label="Phiếu GH" />

                        {
                            isCompleted ? (
                                <ActionButton icon="fa-rotate-left" color={COLORS.warning} onClick={() => handleAction("Hoàn tác")} title="Hoàn tác (Trở lại Đã Giao Hàng)" disabled={isPaused} label="Hoàn tác" />
                            ) : (
                                <ActionButton icon="fa-check" color={COLORS.actionComplete} onClick={() => handleAction("Hoàn thành")} title="Hoàn thành" disabled={isPaused} label="Hoàn thành" />
                            )
                        }

                        {/* 2. Pause/Resume (Always Active) */}
                        {
                            (order.status !== 'Huy' && order.status !== 'HoanThanh') && (
                                isPaused ? (
                                    <ActionButton
                                        icon="fa-play"
                                        color={COLORS.actionComplete}
                                        onClick={() => handleAction("Tiếp tục")}
                                        title="Tiếp tục"
                                        label="Tiếp tục"
                                    />
                                ) : (
                                    <ActionButton
                                        icon="fa-pause"
                                        color={COLORS.actionPause}
                                        onClick={() => handleAction("Tạm ngưng")}
                                        title="Tạm ngưng"
                                        label="Tạm ngưng"
                                    />
                                )
                            )
                        }

                        {/* 3. Cancel (Disabled when Paused or Completed) */}
                        {
                            (order.status !== 'Huy' && order.status !== 'HoanThanh') && (
                                <ActionButton icon="fa-xmark" color={COLORS.actionCancel} onClick={() => handleAction("Xóa")} title="Hủy đơn" disabled={isPaused || isCompleted} label="Hủy đơn" />
                            )
                        }
                    </>
                )}
            </div >
            {/* Modal Logic: Comment Section OR Quick Edit */}
            {
                editingField && (
                    ['notes', 'status_note', 'design_note', 'large_print_note', 'be_demi_note', 'outsource_note', 'ep_kim_note'].includes(editingField.field) ? (
                        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 backdrop-blur-sm p-4 animate-fadeIn">
                            <div className="bg-white rounded-xl shadow-2xl w-full max-w-lg flex flex-col max-h-[85vh] overflow-hidden animate-scaleIn">
                                <div className="px-6 py-4 border-b border-gray-100 flex justify-between items-center bg-gray-50">
                                    <h3 className="font-bold text-gray-800 text-lg flex items-center gap-2">
                                        <i className="fa-solid fa-comments text-blue-600"></i>
                                        {editingField.title}
                                    </h3>
                                    <button
                                        onClick={() => setEditingField(null)}
                                        className="w-8 h-8 flex items-center justify-center rounded-full hover:bg-gray-200 text-gray-500 transition-colors"
                                    >
                                        <i className="fa-solid fa-xmark"></i>
                                    </button>
                                </div>
                                <div className="p-6 overflow-y-auto flex-1 bg-gray-50/50">
                                    <CommentSection
                                        orderId={order.id}
                                        contextKey={editingField.field}
                                        initialContent={editingField.value}
                                        onLegacyUpdate={(val) => handleQuickSave(val, true)}
                                        placeholder="Nhập nội dung ghi chú / trao đổi..."
                                    />
                                </div>
                            </div>
                        </div>
                    ) : (
                        <QuickEditModal
                            isOpen={!!editingField}
                            title={editingField?.title || ''}
                            initialValue={editingField?.value || ''}
                            onSave={handleQuickSave}
                            onClose={() => setEditingField(null)}
                        />
                    )
                )
            }

            {
                showPaymentConfirmModal && (
                    <PaymentConfirmationModal
                        isOpen={showPaymentConfirmModal}
                        order={order}
                        pendingStatus={pendingPaymentStatus} // Pass the status user intends to switch to
                        onClose={() => {
                            setShowPaymentConfirmModal(false);
                            setPendingPaymentStatus(null);
                        }}
                        onSuccess={() => {
                            onRefresh();
                            setPendingPaymentStatus(null);
                        }}
                    />
                )
            }

            {/* Invoice Info Modal */}
            <InvoiceInfoModal
                isOpen={showInvoiceModal}
                onClose={() => setShowInvoiceModal(false)}
                onSave={handleSaveInvoiceInfo}
                initialInfo={order.invoice_info || ''}
            />

            {/* Payment QR Modal */}
            <PaymentQRModal
                isOpen={showQRModal}
                onClose={() => setShowQRModal(false)}
                order={order}
            />
        </div >
    );
};

// ... ActionButton helper ...
// ... ActionButton helper ...
// ... ActionButton helper ...
const ActionButton = ({ icon, color, onClick, title, disabled, label }: { icon: string, color: string, onClick: () => void, title: string, disabled?: boolean, label?: string }) => {
    const words = label ? label.split(' ') : [];
    return (
        <button
            onClick={onClick}
            disabled={disabled}
            className={`w-[42px] py-1 rounded-md flex flex-col items-center justify-center text-white shadow-sm transition-all ${disabled ? 'opacity-50 cursor-not-allowed' : 'hover:opacity-90'}`}
            style={{ backgroundColor: color }}
            title={title}
        >
            <i className={`fa-solid ${icon} text-[10px] mb-0.5`}></i>
            {words.map((word, idx) => (
                <span key={idx} className="text-[9px] font-medium leading-[1]">{word}</span>
            ))}
        </button>
    );
};

export default OrderCard;
