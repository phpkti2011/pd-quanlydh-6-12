import React, { useState, useEffect } from 'react';
import { Customer, Order } from '../../types';
import { customerService } from '../../services/customerService';
import { orderService } from '../../services/orderService';
import { COLORS } from '../../constants';

interface CustomerTimelineProps {
    customer: Customer;
    onAddLog: () => void; // Trigger parent to show add log modal maybe? Or handle internally
}

type TimelineItem = {
    id: string;
    type: 'ORDER' | 'LOG' | 'ALERT';
    date: Date;
    content: any;
};

export const CustomerTimeline: React.FC<CustomerTimelineProps> = ({ customer, onAddLog }) => {
    const [items, setItems] = useState<TimelineItem[]>([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        loadData();
    }, [customer.id]);

    const loadData = async () => {
        setLoading(true);
        try {
            // 1. Fetch Orders
            const orders = await orderService.getOrdersByCustomer(customer.id);
            const orderItems: TimelineItem[] = orders.map(o => ({
                id: o.id,
                type: 'ORDER',
                date: new Date(o.created_at),
                content: o
            }));

            // 2. Fetch Logs
            const logs = await customerService.getCustomerLogs(customer.id);
            const logItems: TimelineItem[] = logs.map(l => ({
                id: l.id,
                type: 'LOG',
                date: new Date(l.created_at),
                content: l
            }));

            // 3. Generate Alerts (Virtual Items)
            const alertItems: TimelineItem[] = [];
            if (customer.is_urgent_entry && !customer.phone) {
                alertItems.push({
                    id: 'alert_phone',
                    type: 'ALERT',
                    date: new Date(), // Always top
                    content: { title: 'Thiếu Số Điện Thoại', msg: 'Khách hàng "Gấp" đang nợ SĐT. Vui lòng cập nhật ngay.' }
                });
            }

            // Merge and Sort
            const all = [...orderItems, ...logItems, ...alertItems].sort((a, b) => b.date.getTime() - a.date.getTime());
            setItems(all);
        } catch (e) {
            console.error("Failed to load timeline", e);
        } finally {
            setLoading(false);
        }
    };

    const renderItem = (item: TimelineItem) => {
        switch (item.type) {
            case 'ALERT':
                return (
                    <div key={item.id} className="mb-4 ml-4">
                        <div className="absolute w-3 h-3 bg-red-500 rounded-full mt-1.5 -left-1.5 border border-white dark:border-gray-900 dark:bg-gray-700"></div>
                        <div className="p-3 bg-red-50 border border-red-200 rounded-lg shadow-sm">
                            <h4 className="font-bold text-red-700 flex items-center gap-2">
                                <i className="fa-solid fa-triangle-exclamation"></i> {item.content.title}
                            </h4>
                            <p className="text-sm text-red-600 mt-1">{item.content.msg}</p>
                        </div>
                    </div>
                );
            case 'ORDER':
                const order = item.content as Order;
                return (
                    <div key={item.id} className="mb-6 ml-4">
                        <div className="absolute w-3 h-3 bg-blue-500 rounded-full mt-1.5 -left-1.5 border border-white"></div>
                        <time className="mb-1 text-xs font-normal text-gray-400">{item.date.toLocaleString('vi-VN')}</time>
                        <div className="p-4 bg-white border border-gray-200 rounded-lg shadow-sm hover:shadow-md transition-shadow">
                            <div className="flex justify-between items-start">
                                <h3 className="text-sm font-bold text-gray-900 group-hover:text-blue-600">
                                    Đơn hàng #{order.order_code || order.id.slice(0, 8)}
                                </h3>
                                <span className={`px-2 py-0.5 rounded text-xs font-bold ${order.status === 'HoanThanh' || order.status === 'DaGiaoHang' ? 'bg-green-100 text-green-700' :
                                    order.status === 'Huy' ? 'bg-red-100 text-red-700' :
                                        'bg-blue-100 text-blue-700'
                                    }`}>
                                    {order.status}
                                </span>
                            </div>
                            <p className="text-sm font-medium text-gray-500 mt-1">
                                {new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(order.total_amount)}
                            </p>
                            <p className="text-xs text-gray-400 mt-2 line-clamp-2 italic">
                                "{order.description || 'Không có mô tả'}"
                            </p>
                        </div>
                    </div>
                );
            case 'LOG':
                const log = item.content;
                const isVisit = log.type === 'Visit';
                const isCall = log.type === 'Call';
                const icon = isVisit ? 'fa-handshake' : isCall ? 'fa-phone' : 'fa-note-sticky';
                const color = isVisit ? 'text-purple-600 bg-purple-100' : isCall ? 'text-green-600 bg-green-100' : 'text-gray-600 bg-gray-100';

                return (
                    <div key={item.id} className="mb-6 ml-4">
                        <div className={`absolute w-3 h-3 rounded-full mt-1.5 -left-1.5 border border-white ${isVisit ? 'bg-purple-500' : isCall ? 'bg-green-500' : 'bg-gray-400'}`}></div>
                        <time className="mb-1 text-xs font-normal text-gray-400">{item.date.toLocaleString('vi-VN')}</time>
                        <div className="p-3 bg-gray-50 border border-gray-100 rounded-lg">
                            <h4 className="flex items-center gap-2 font-bold text-gray-700 text-sm">
                                <span className={`w-6 h-6 rounded-full flex items-center justify-center text-xs ${color}`}>
                                    <i className={`fa-solid ${icon}`}></i>
                                </span>
                                {log.type === 'Note' ? 'Ghi chú' : log.type === 'Call' ? 'Cuộc gọi' : 'Gặp mặt'}
                                {log.created_by_user && <span className="text-xs font-normal text-gray-400">- bởi {log.created_by_user.full_name}</span>}
                            </h4>
                            <p className="text-sm text-gray-600 mt-2 whitespace-pre-wrap">{log.content}</p>
                        </div>
                    </div>
                );
            default: return null;
        }
    };

    if (loading) return <div className="p-4 text-center text-gray-400">Đang tải lịch sử...</div>;

    return (
        <div className="relative border-l border-gray-200 dark:border-gray-700 ml-3 space-y-2 h-full overflow-y-auto pr-2 pb-10">
            {items.length === 0 ? (
                <div className="ml-4 text-gray-400 italic text-sm">Chưa có lịch sử hoạt động.</div>
            ) : (
                items.map(renderItem)
            )}
        </div>
    );
};
