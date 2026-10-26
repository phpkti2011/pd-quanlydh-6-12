import { Order } from '../types';

// Nguồn DUY NHẤT cho 2 trạng thái duyệt mẫu ở công đoạn In (xem
// alter_orders_add_awaiting_approval.sql). Dùng chung cho thẻ/bảng đơn, số đếm tab
// (utils/tabCounts.ts) và bộ lọc tab (App.tsx). Bộ lọc phía máy chủ trong
// orderService.getOrders phải khớp 2 công thức này.

type SampleFields = Pick<Partial<Order>, 'awaiting_customer_approval' | 'sample_approved_at' | 'status'>;

/** Đang chờ khách duyệt mẫu (và đơn chưa kết thúc) — ở bất kỳ trạng thái nào. */
export const isAwaitingApproval = (o: SampleFields) =>
    !!o.awaiting_customer_approval && o.status !== 'Huy' && o.status !== 'HoanThanh';

/** Đã duyệt mẫu và đơn đang ở công đoạn In (sẵn sàng in). Sang công đoạn khác thì rời tab. */
export const isSampleApprovedAtPrint = (o: SampleFields) =>
    o.status === 'In' && !o.awaiting_customer_approval && !!o.sample_approved_at;
