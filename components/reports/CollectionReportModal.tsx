
import React, { useState, useEffect, useMemo } from 'react';
import { orderService } from '../../services/orderService';

interface Props {
    isOpen: boolean;
    onClose: () => void;
}

const CollectionReportModal: React.FC<Props> = ({ isOpen, onClose }) => {
    const [orders, setOrders] = useState<any[]>([]);
    const [loading, setLoading] = useState(false);
    const [selectedCustomer, setSelectedCustomer] = useState<string>('ALL');
    const [selectedOrderIds, setSelectedOrderIds] = useState<Set<string>>(new Set());

    const fetchData = async () => {
        setLoading(true);
        setSelectedOrderIds(new Set()); // Reset selection on reload
        try {
            const data = await orderService.getCollectionOrders();
            if (data) {
                setOrders(data);
            }
        } catch (error) {
            console.error(error);
            alert("Lỗi tải danh sách cần thu: " + (error as Error).message);
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        if (isOpen) {
            fetchData();
        }
    }, [isOpen]);

    // Derived State
    const filteredOrders = useMemo(() => {
        if (selectedCustomer === 'ALL') return orders;
        return orders.filter(o => o.customer_name === selectedCustomer);
    }, [orders, selectedCustomer]);

    const stats = useMemo(() => {
        const totalCollect = filteredOrders.reduce((sum, item) => sum + (parseFloat(item.remaining_amount) || 0), 0);
        const uniqueCustomers = new Set(filteredOrders.map(o => o.customer_name)).size;
        return { totalCollect, uniqueCustomers, count: filteredOrders.length };
    }, [filteredOrders]);

    const uniqueCustomersList = useMemo(() => {
        return Array.from(new Set(orders.map(o => o.customer_name))).filter(Boolean).sort();
    }, [orders]);

    // Selection Logic
    const toggleSelectAll = () => {
        if (selectedOrderIds.size === filteredOrders.length) {
            setSelectedOrderIds(new Set());
        } else {
            setSelectedOrderIds(new Set(filteredOrders.map(o => o.id)));
        }
    };

    const toggleSelectOrder = (id: string) => {
        const newSet = new Set(selectedOrderIds);
        if (newSet.has(id)) {
            newSet.delete(id);
        } else {
            newSet.add(id);
        }
        setSelectedOrderIds(newSet);
    };

    const handleConfirmPayment = async (order?: any) => {
        const targets = order ? [order] : orders.filter(o => selectedOrderIds.has(o.id));
        if (targets.length === 0) return;

        const totalAmountToSettle = targets.reduce((sum, o) => sum + (parseFloat(o.remaining_amount) || 0), 0);
        const confirmMsg = order
            ? `Xác nhận đã thu đủ ${order.remaining_amount?.toLocaleString('vi-VN')}đ cho đơn ${order.order_code}?`
            : `Xác nhận đã thu đủ tổng cộng ${totalAmountToSettle.toLocaleString('vi-VN')}đ cho ${targets.length} đơn hàng đã chọn?`;

        if (!confirm(confirmMsg)) return;

        try {
            // Process all updates in parallel
            await Promise.all(targets.map(o =>
                orderService.updateOrder(o.id, {
                    payment_status: 'DaThanhToan',
                    remaining_amount: 0,
                    deposit_amount: o.total_amount
                })
            ));

            alert("Đã cập nhật trạng thái đã thanh toán!");
            fetchData();
        } catch (err) {
            console.error(err);
            alert("Lỗi cập nhật đơn hàng");
        }
    };

    const handleExportExcel = () => {
        try {
            // CSV Header
            const headers = ["Mã Đơn", "Khách Hàng", "NV Kinh Doanh", "Tổng Tiền", "Đã TT", "Còn Lại", "Ngày Tạo"];

            // CSV Rows
            const rows = filteredOrders.map(order => [
                order.order_code,
                order.customer_name || 'Vãng lai',
                order.sales_rep_name,
                order.total_amount,
                order.deposit_amount,
                order.remaining_amount,
                new Date(order.created_at).toLocaleDateString('vi-VN')
            ]);

            // Combine with BOM for Excel UTF-8 support
            const csvContent = "\uFEFF" + [
                headers.join(","),
                ...rows.map(r => r.map(c => typeof c === 'string' ? `"${c.replace(/"/g, '""')}"` : c).join(","))
            ].join("\n");

            // Create Blob and Download
            const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
            const url = URL.createObjectURL(blob);
            const link = document.createElement("a");
            link.setAttribute("href", url);
            const fileName = selectedCustomer !== 'ALL'
                ? `CanThu_${selectedCustomer.replace(/\s+/g, '_')}_${new Date().toISOString().slice(0, 10)}.csv`
                : `BaoCaoCanThu_${new Date().toISOString().slice(0, 10)}.csv`;

            link.setAttribute("download", fileName);
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        } catch (error) {
            console.error("Export Error:", error);
            alert("Lỗi xuất file Excel (CSV).");
        }
    };

    if (!isOpen) return null;

    return (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-50">
            <div className="bg-white rounded-lg shadow-xl w-full max-w-7xl p-6 relative max-h-[95vh] overflow-y-auto flex flex-col">
                <button
                    onClick={onClose}
                    className="absolute top-4 right-4 text-gray-400 hover:text-gray-600"
                >
                    <i className="fa-solid fa-times text-xl"></i>
                </button>

                <h2 className="text-2xl font-bold mb-6 text-orange-700 flex items-center">
                    <i className="fa-solid fa-hand-holding-dollar mr-3"></i>
                    Quản Lý Đơn Cần Thu
                </h2>

                {/* Dashboard Stats */}
                <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
                    <div className="bg-orange-50 p-4 rounded-lg border border-orange-100 flex flex-col justify-center items-center shadow-sm">
                        <span className="text-orange-800 font-medium text-sm uppercase tracking-wider">Tổng Cần Thu</span>
                        <span className="text-3xl font-bold text-orange-600 mt-1">{stats.totalCollect.toLocaleString('vi-VN')} đ</span>
                    </div>
                    <div className="bg-blue-50 p-4 rounded-lg border border-blue-100 flex flex-col justify-center items-center shadow-sm">
                        <span className="text-blue-800 font-medium text-sm uppercase tracking-wider">Số Khách Hàng</span>
                        <span className="text-3xl font-bold text-blue-600 mt-1">{stats.uniqueCustomers}</span>
                    </div>
                    <div className="bg-gray-50 p-4 rounded-lg border border-gray-100 flex flex-col justify-center items-center shadow-sm">
                        <span className="text-gray-800 font-medium text-sm uppercase tracking-wider">Số Đơn Hàng</span>
                        <span className="text-3xl font-bold text-gray-700 mt-1">{stats.count}</span>
                    </div>
                </div>

                {/* Filters & Actions */}
                <div className="flex flex-col md:flex-row justify-between items-center mb-4 gap-4 bg-gray-50 p-3 rounded">
                    <div className="flex items-center gap-3 w-full md:w-auto">
                        <label className="font-semibold text-gray-700 whitespace-nowrap"><i className="fa-solid fa-filter mr-1"></i> Lọc Khách:</label>
                        <select
                            className="border border-gray-300 rounded px-3 py-2 w-full md:w-64 focus:outline-none focus:ring-2 focus:ring-blue-500"
                            value={selectedCustomer}
                            onChange={(e) => {
                                setSelectedCustomer(e.target.value);
                                setSelectedOrderIds(new Set());
                            }}
                        >
                            <option value="ALL">-- Tất cả khách hàng --</option>
                            {uniqueCustomersList.map((cust, idx) => (
                                <option key={idx} value={cust}>{cust}</option>
                            ))}
                        </select>
                    </div>
                    <div className="flex gap-2 items-center">
                        {selectedOrderIds.size > 0 && (
                            <button
                                onClick={() => handleConfirmPayment()}
                                className="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700 transition shadow-sm animate-pulse font-bold"
                            >
                                <i className="fa-solid fa-check-double mr-2"></i>
                                Chốt TT ({selectedOrderIds.size})
                            </button>
                        )}
                        <div className="h-6 w-px bg-gray-300 mx-2 hidden md:block"></div>
                        <button onClick={fetchData} className="px-4 py-2 bg-gray-200 text-gray-700 rounded hover:bg-gray-300 transition">
                            <i className="fa-solid fa-sync mr-1"></i> Làm mới
                        </button>
                        <button onClick={handleExportExcel} className="px-4 py-2 bg-green-600 text-white rounded hover:bg-green-700 transition shadow-sm">
                            <i className="fa-solid fa-file-excel mr-2"></i> Xuất Excel
                        </button>
                    </div>
                </div>

                {/* Table */}
                <div className="overflow-x-auto flex-grow rounded border border-gray-200">
                    <table className="min-w-full divide-y divide-gray-200 border-collapse text-sm">
                        <thead className="bg-gray-100 sticky top-0 z-10">
                            <tr>
                                <th className="px-4 py-3 text-center w-12">
                                    <input
                                        type="checkbox"
                                        className="h-4 w-4 text-orange-600 focus:ring-orange-500 border-gray-300 rounded"
                                        checked={filteredOrders.length > 0 && selectedOrderIds.size === filteredOrders.length}
                                        onChange={toggleSelectAll}
                                    />
                                </th>
                                <th className="px-4 py-3 text-left font-bold text-gray-700">Mã Đơn</th>
                                <th className="px-4 py-3 text-left font-bold text-gray-700">Khách Hàng</th>
                                <th className="px-4 py-3 text-left font-bold text-gray-700">PT Kinh Doanh</th>
                                <th className="px-4 py-3 text-right font-bold text-gray-700">Tổng Tiền</th>
                                <th className="px-4 py-3 text-right font-bold text-gray-700">Đã TT</th>
                                <th className="px-4 py-3 text-right font-bold text-orange-600">Phải Thu</th>
                                <th className="px-4 py-3 text-left font-bold text-gray-700">Ngày Tạo</th>
                                <th className="px-4 py-3 text-center font-bold text-gray-700">Thao Tác</th>
                            </tr>
                        </thead>
                        <tbody className="bg-white divide-y divide-gray-200">
                            {loading ? (
                                <tr><td colSpan={9} className="px-6 py-8 text-center text-gray-500 italic">Đang tải dữ liệu cần thu...</td></tr>
                            ) : filteredOrders.length === 0 ? (
                                <tr><td colSpan={9} className="px-6 py-8 text-center text-gray-500">Không tìm thấy đơn hàng cần thu phù hợp.</td></tr>
                            ) : (
                                filteredOrders.map((order, idx) => (
                                    <tr
                                        key={idx}
                                        className={`hover:bg-orange-50 transition-colors ${selectedOrderIds.has(order.id) ? 'bg-orange-50' : ''}`}
                                        onClick={(e) => {
                                            if ((e.target as HTMLElement).tagName !== 'BUTTON' && (e.target as HTMLElement).tagName !== 'INPUT') {
                                                toggleSelectOrder(order.id);
                                            }
                                        }}
                                    >
                                        <td className="px-4 py-3 text-center">
                                            <input
                                                type="checkbox"
                                                className="h-4 w-4 text-orange-600 focus:ring-orange-500 border-gray-300 rounded"
                                                checked={selectedOrderIds.has(order.id)}
                                                onChange={() => toggleSelectOrder(order.id)}
                                            />
                                        </td>
                                        <td className="px-4 py-3 font-medium text-blue-600">{order.order_code}</td>
                                        <td className="px-4 py-3">{order.customer_name || 'Vãng lai'}</td>
                                        <td className="px-4 py-3 text-gray-600">{order.sales_rep_name}</td>
                                        <td className="px-4 py-3 text-right">{order.total_amount?.toLocaleString('vi-VN')}</td>
                                        <td className="px-4 py-3 text-right text-gray-500">{order.deposit_amount?.toLocaleString('vi-VN')}</td>
                                        <td className="px-4 py-3 text-right font-bold text-orange-600">
                                            {order.remaining_amount?.toLocaleString('vi-VN')}
                                        </td>
                                        <td className="px-4 py-3 text-gray-500">
                                            {new Date(order.created_at).toLocaleDateString('vi-VN')}
                                        </td>
                                        <td className="px-4 py-3 text-center">
                                            <button
                                                onClick={(e) => {
                                                    e.stopPropagation();
                                                    handleConfirmPayment(order);
                                                }}
                                                className="bg-blue-100 text-blue-700 px-3 py-1 rounded-full text-xs hover:bg-blue-200 font-semibold border border-blue-200 transition"
                                                title="Xác nhận đã thanh toán hết"
                                            >
                                                <i className="fa-solid fa-check mr-1"></i> Chốt TT
                                            </button>
                                        </td>
                                    </tr>
                                ))
                            )}
                        </tbody>
                        {filteredOrders.length > 0 && (
                            <tfoot className="bg-gray-50 font-bold text-gray-900">
                                <tr>
                                    <td colSpan={6} className="px-4 py-3 text-right">Tổng cộng:</td>
                                    <td className="px-4 py-3 text-right text-orange-700 text-base">{stats.totalCollect.toLocaleString('vi-VN')} đ</td>
                                    <td colSpan={2}></td>
                                </tr>
                            </tfoot>
                        )}
                    </table>
                </div>
            </div>
        </div>
    );
};

export default CollectionReportModal;
