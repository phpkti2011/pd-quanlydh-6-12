import React, { useState } from 'react';
import { Order } from '../types';
import { orderService } from '../services/orderService';
import { formatDateTime } from '../utils/dateFormatter';

/**
 * Cờ "Đang chờ khách duyệt mẫu" ở công đoạn In (xem alter_orders_add_awaiting_approval.sql).
 * - Đơn đang ở công đoạn In, chưa chờ  → nút vàng "Chờ khách duyệt mẫu".
 * - Đang chờ (ở bất kỳ trạng thái nào) → banner cảnh báo + nút "Đã duyệt".
 * Chỉ cảnh báo, KHÔNG chặn đổi trạng thái đơn.
 */

/** Ai được bật cảnh báo / bấm "Đã duyệt" */
export const canToggleSampleApproval = (role?: string) =>
    ['Admin', 'admin', 'QuanLySanXuat', 'NhanVienSanXuat', 'NhanVienKinhDoanh', 'KeToan'].includes(role || '');

/** Đơn đang chờ khách duyệt mẫu (và chưa kết thúc) — dùng cho chip/viền ở thẻ và bảng */
export const isAwaitingApproval = (order: Order) =>
    !!order.awaiting_customer_approval && order.status !== 'Huy' && order.status !== 'HoanThanh';

interface Props {
    order: Order;
    canToggle: boolean;
    onChanged: () => void;
    compact?: boolean;
}

const SampleApprovalControl: React.FC<Props> = ({ order, canToggle, onChanged, compact }) => {
    const [saving, setSaving] = useState(false);

    const awaiting = isAwaitingApproval(order);
    const canStart = !order.awaiting_customer_approval && order.status === 'In' && canToggle;
    if (!awaiting && !canStart) return null;

    const save = async (updates: Partial<Order>) => {
        setSaving(true);
        try {
            await orderService.updateOrder(order.id, updates);
            onChanged();
        } catch (e) {
            alert('Không cập nhật được trạng thái duyệt mẫu: ' + (e as Error).message);
        } finally {
            setSaving(false);
        }
    };

    const startWaiting = () => save({
        awaiting_customer_approval: true,
        awaiting_approval_at: new Date().toISOString(),
    });
    const approve = () => save({
        awaiting_customer_approval: false,
        awaiting_approval_at: null,
    });

    if (!awaiting) {
        return (
            <button
                type="button"
                onClick={(e) => { e.stopPropagation(); startWaiting(); }}
                disabled={saving}
                className={`w-full ${compact ? 'mt-1 py-1 text-xs' : 'mt-2 py-2 text-sm'} rounded border border-amber-300 bg-amber-50 text-amber-800 font-bold hover:bg-amber-100 transition-colors disabled:opacity-50`}
            >
                <i className={`fa-solid ${saving ? 'fa-spinner fa-spin' : 'fa-hourglass-half'} mr-1.5`}></i>
                Chờ khách duyệt mẫu
            </button>
        );
    }

    return (
        <div className={`${compact ? 'mt-1 p-1.5' : 'mt-2 p-2.5'} rounded border border-amber-300 bg-amber-50 text-amber-900`}>
            <div className="flex items-center gap-2">
                <i className="fa-solid fa-triangle-exclamation text-amber-600 animate-pulse"></i>
                <div className={`flex-1 min-w-0 ${compact ? 'text-xs' : 'text-sm'}`}>
                    <div className="font-bold">Đang chờ khách duyệt mẫu</div>
                    {order.awaiting_approval_at && (
                        <div className="text-[11px] text-amber-700">từ {formatDateTime(order.awaiting_approval_at)}</div>
                    )}
                </div>
                {canToggle && (
                    <button
                        type="button"
                        onClick={(e) => { e.stopPropagation(); approve(); }}
                        disabled={saving}
                        className={`shrink-0 ${compact ? 'px-2 py-1 text-xs' : 'px-3 py-1.5 text-sm'} rounded bg-green-600 text-white font-bold hover:bg-green-700 transition-colors disabled:opacity-50`}
                    >
                        <i className={`fa-solid ${saving ? 'fa-spinner fa-spin' : 'fa-check'} mr-1`}></i>
                        Đã duyệt
                    </button>
                )}
            </div>
        </div>
    );
};

export default SampleApprovalControl;
