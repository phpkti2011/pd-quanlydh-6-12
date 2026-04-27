
import React, { useState, useEffect, useMemo } from 'react';
import { orderService } from '../../services/orderService';
import { supabase } from '../../services/supabaseClient';

interface Props {
    isOpen: boolean;
    onClose: () => void;
}

const DebtReportModal: React.FC<Props> = ({ isOpen, onClose }) => {
    const [activeTab, setActiveTab] = useState<'debt' | 'settled'>('debt');
    const [orders, setOrders] = useState<any[]>([]);
    const [settledOrders, setSettledOrders] = useState<any[]>([]);
    const [loading, setLoading] = useState(false);
    const [selectedCustomer, setSelectedCustomer] = useState<string>('ALL');
    const [selectedOrderIds, setSelectedOrderIds] = useState<Set<string>>(new Set());
    const [selectedMonth, setSelectedMonth] = useState<number>(0); // 0 = All months
    const [selectedYear, setSelectedYear] = useState<number>(new Date().getFullYear());

    const fetchData = async () => {
        setLoading(true);
        setSelectedOrderIds(new Set()); // Reset selection on reload
        try {
            const data = await orderService.getDebtOrders();
            if (data) {
                setOrders(data);
            }
            // Fetch settled orders (DaThanhToan) for undo tab
            const { data: settled } = await supabase
                .from('orders')
                .select('id, order_code, total_amount, deposit_amount, remaining_amount, payment_status, created_at, updated_at, customer:customers(name), sales_rep:profiles!sales_rep_id(full_name)')
                .eq('payment_status', 'DaThanhToan')
                .order('updated_at', { ascending: false })
                .limit(200);
            if (settled) {
                setSettledOrders(settled.map((o: any) => ({
                    ...o,
                    customer_name: o.customer?.name || 'Vãng lai',
                    sales_rep_name: o.sales_rep?.full_name || ''
                })));
            }
        } catch (error) {
            console.error(error);
            alert("Lỗi tải báo cáo công nợ");
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        if (isOpen) {
            fetchData();
        }
    }, [isOpen]);

    const [searchTerm, setSearchTerm] = useState('');
    const [sortOrder, setSortOrder] = useState<'asc' | 'desc' | null>(null);

    // Helper for sorting
    const getSortedOrders = (list: any[]) => {
        if (!sortOrder) return list;
        return [...list].sort((a, b) => {
            const valA = a.order_code || '';
            const valB = b.order_code || '';
            return sortOrder === 'asc'
                ? valA.localeCompare(valB)
                : valB.localeCompare(valA);
        });
    };

    // Derived State
    const filteredOrders = useMemo(() => {
        let result = orders;

        // 1. Filter by Month/Year
        if (selectedMonth > 0) {
            result = result.filter(o => {
                const d = new Date(o.created_at);
                return d.getMonth() + 1 === selectedMonth && d.getFullYear() === selectedYear;
            });
        } else if (selectedYear) {
            result = result.filter(o => {
                const d = new Date(o.created_at);
                return d.getFullYear() === selectedYear;
            });
        }

        // 2. Filter by Dropdown (Exact Match)
        if (selectedCustomer !== 'ALL') {
            result = result.filter(o => o.customer_name === selectedCustomer);
        }

        // 3. Filter by Search Term (Partial Match - Name or Code)
        if (searchTerm) {
            const lowerTerm = searchTerm.toLowerCase();
            result = result.filter(o =>
                (o.customer_name?.toLowerCase().includes(lowerTerm)) ||
                (o.order_code?.toLowerCase().includes(lowerTerm))
            );
        }

        // 4. Apply Sort
        return getSortedOrders(result);
    }, [orders, selectedCustomer, searchTerm, sortOrder, selectedMonth, selectedYear]);

    const stats = useMemo(() => {
        const totalDebt = filteredOrders.reduce((sum, item) => sum + (parseFloat(item.remaining_amount) || 0), 0);
        const uniqueCustomers = new Set(filteredOrders.map(o => o.customer_name)).size;
        return { totalDebt, uniqueCustomers, count: filteredOrders.length };
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
            // Process all updates in parallel (silent - no notifications)
            await Promise.all(targets.map(o =>
                orderService.updatePaymentSilent(o.id, 'DaThanhToan', o.total_amount, 0, o.order_code)
            ));

            alert("Đã cập nhật trạng thái đã thanh toán!");
            fetchData();
        } catch (err) {
            console.error(err);
            alert("Lỗi cập nhật đơn hàng");
        }
    };

    // Filtered settled orders by month/year
    const filteredSettled = useMemo(() => {
        let result = settledOrders;
        if (selectedMonth > 0) {
            result = result.filter(o => {
                const d = new Date(o.created_at);
                return d.getMonth() + 1 === selectedMonth && d.getFullYear() === selectedYear;
            });
        } else if (selectedYear) {
            result = result.filter(o => {
                const d = new Date(o.created_at);
                return d.getFullYear() === selectedYear;
            });
        }
        if (selectedCustomer !== 'ALL') {
            result = result.filter(o => o.customer_name === selectedCustomer);
        }
        if (searchTerm) {
            const lowerTerm = searchTerm.toLowerCase();
            result = result.filter(o =>
                (o.customer_name?.toLowerCase().includes(lowerTerm)) ||
                (o.order_code?.toLowerCase().includes(lowerTerm))
            );
        }
        return getSortedOrders(result);
    }, [settledOrders, selectedMonth, selectedYear, selectedCustomer, searchTerm, sortOrder]);

    const settledStats = useMemo(() => {
        const totalAmount = filteredSettled.reduce((sum: number, item: any) => sum + (parseFloat(item.total_amount) || 0), 0);
        const uniqueCustomers = new Set(filteredSettled.map((o: any) => o.customer_name)).size;
        return { totalAmount, uniqueCustomers, count: filteredSettled.length };
    }, [filteredSettled]);

    const uniqueSettledCustomersList = useMemo(() => {
        return Array.from(new Set(settledOrders.map((o: any) => o.customer_name))).filter(Boolean).sort();
    }, [settledOrders]);

    // Selection for settled tab
    const [selectedSettledIds, setSelectedSettledIds] = useState<Set<string>>(new Set());

    const toggleSettledSelectAll = () => {
        if (selectedSettledIds.size === filteredSettled.length) {
            setSelectedSettledIds(new Set());
        } else {
            setSelectedSettledIds(new Set(filteredSettled.map((o: any) => o.id)));
        }
    };

    const toggleSettledSelect = (id: string) => {
        const newSet = new Set(selectedSettledIds);
        if (newSet.has(id)) newSet.delete(id);
        else newSet.add(id);
        setSelectedSettledIds(newSet);
    };

    const handleUndoPayment = async (order?: any) => {
        const targets = order ? [order] : settledOrders.filter(o => selectedSettledIds.has(o.id));
        if (targets.length === 0) return;

        const confirmMsg = targets.length === 1
            ? `Hoàn tác duyệt công nợ đơn ${targets[0].order_code}?\nĐơn sẽ trở về trạng thái Công Nợ.`
            : `Hoàn tác ${targets.length} đơn đã chọn về trạng thái Công Nợ?`;

        if (!confirm(confirmMsg)) return;
        try {
            await Promise.all(targets.map(o =>
                orderService.updatePaymentSilent(o.id, 'CongNo', 0, o.total_amount, o.order_code)
            ));
            alert(`Đã hoàn tác ${targets.length} đơn về trạng thái Công Nợ.`);
            setSelectedSettledIds(new Set());
            fetchData();
        } catch (err) {
            console.error(err);
            alert("Lỗi hoàn tác");
        }
    };

    const handleExportDetailed = async () => {
        try {
            // Prioritize Selected Orders, otherwise use Filtered List
            let targets = selectedOrderIds.size > 0
                ? orders.filter(o => selectedOrderIds.has(o.id))
                : filteredOrders;

            // Apply Sort to targets if using Selection (filteredOrders is already sorted)
            if (selectedOrderIds.size > 0) {
                targets = getSortedOrders(targets);
            }

            if (targets.length === 0) {
                alert("Không có dữ liệu để xuất");
                return;
            }

            // 1. Fetch Order Descriptions & Customer Codes
            const orderIds = targets.map(o => o.id);
            const customerIds = [...new Set(targets.map(o => o.customer_id).filter(Boolean))];

            const [ordersResp, custResp] = await Promise.all([
                supabase.from('orders').select('id, description').in('id', orderIds),
                supabase.from('customers').select('id, code').in('id', customerIds)
            ]);

            const invalidOrders = ordersResp.error;
            const invalidCust = custResp.error;

            if (invalidOrders || invalidCust) {
                console.error("Fetch Error", invalidOrders, invalidCust);
                alert("Lỗi tải dữ liệu chi tiết");
                return;
            }

            const ordersDetails = ordersResp.data || [];
            const customers = custResp.data || [];
            const custMap = customers.reduce((acc, c) => ({ ...acc, [c.id]: c.code }), {});

            // Map descriptions
            const descMap = ordersDetails.reduce((acc: any, o) => ({ ...acc, [o.id]: o.description }), {});

            // 2. Prepare Rows
            const headers = ["Mã Đơn", "Mã KH", "Tên Khách Hàng", "Quy cách", "Trạng thái TT", "Tiền còn lại (VND)", "Thời gian tạo", "Nhân Viên"];

            const rows = targets.map(order => {
                // Format Quy Cach
                const specs = descMap[order.id] || '';

                return [
                    order.order_code,
                    custMap[order.customer_id] || '',
                    order.customer_name || 'Vãng lai',
                    specs,
                    order.payment_status,
                    order.remaining_amount,
                    new Date(order.created_at).toLocaleString('vi-VN'),
                    order.sales_rep_name
                ];
            });

            // 3. Generate CSV
            const csvContent = "\uFEFF" + [
                headers.join(","),
                ...rows.map(r => r.map(c => {
                    const val = c === null || c === undefined ? '' : String(c);
                    // Standard CSV quoting: Replace " with "" and wrap in "
                    return `"${val.replace(/"/g, '""')}"`;
                }).join(","))
            ].join("\n");

            // Download
            const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
            const url = URL.createObjectURL(blob);
            const link = document.createElement("a");
            link.setAttribute("href", url);
            const fileName = `CongNo_ChiTiet_${new Date().toISOString().slice(0, 10)}.csv`;
            link.setAttribute("download", fileName);
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);

        } catch (error) {
            console.error("Export Error:", error);
            alert("Lỗi xuất file Excel (CSV).");
        }
    };

    const handleExportExcel = () => {
        try {
            // Prioritize Selected Orders, otherwise use Filtered List
            let targets = selectedOrderIds.size > 0
                ? orders.filter(o => selectedOrderIds.has(o.id))
                : filteredOrders;

            // Apply Sort to targets if using Selection
            if (selectedOrderIds.size > 0) {
                targets = getSortedOrders(targets);
            }

            // CSV Header
            const headers = ["Mã Đơn", "Khách Hàng", "NV Kinh Doanh", "Tổng Tiền", "Đã TT", "Còn Lại", "Ngày Tạo"];

            // CSV Rows
            const rows = targets.map(order => [
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
                ? `CongNo_${selectedCustomer.replace(/\s+/g, '_')}_${new Date().toISOString().slice(0, 10)}.csv`
                : `BaoCaoCongNo_${new Date().toISOString().slice(0, 10)}.csv`;

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

                <h2 className="text-2xl font-bold mb-6 text-red-700 flex items-center">
                    <i className="fa-solid fa-chart-line mr-3"></i>
                    Quản Lý Công Nợ
                </h2>

                {/* Tabs */}
                <div className="flex border-b border-gray-200 mb-4">
                    <button
                        className={`py-2 px-4 font-medium text-sm border-b-2 transition-colors ${activeTab === 'debt' ? 'border-red-600 text-red-700' : 'border-transparent text-gray-500 hover:text-gray-700'}`}
                        onClick={() => setActiveTab('debt')}
                    >
                        <i className="fa-solid fa-file-invoice-dollar mr-1"></i>
                        Công nợ ({orders.length})
                    </button>
                    <button
                        className={`py-2 px-4 font-medium text-sm border-b-2 transition-colors ${activeTab === 'settled' ? 'border-green-600 text-green-700' : 'border-transparent text-gray-500 hover:text-gray-700'}`}
                        onClick={() => setActiveTab('settled')}
                    >
                        <i className="fa-solid fa-check-circle mr-1"></i>
                        Đã chốt ({filteredSettled.length})
                    </button>
                </div>

                {/* Shared Filters */}
                <div className="flex flex-col md:flex-row justify-between items-center mb-4 gap-4 bg-gray-50 p-3 rounded">
                    <div className="flex items-center gap-3 w-full md:w-auto flex-wrap">
                        <div className="relative">
                            <span className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                <i className="fa-solid fa-search text-gray-400"></i>
                            </span>
                            <input
                                type="text"
                                className="pl-10 border border-gray-300 rounded px-3 py-2 w-full md:w-64 focus:outline-none focus:ring-2 focus:ring-blue-500"
                                placeholder="Tìm tên KH, Mã đơn..."
                                value={searchTerm}
                                onChange={(e) => setSearchTerm(e.target.value)}
                            />
                        </div>

                        <label className="font-semibold text-gray-700 whitespace-nowrap"><i className="fa-solid fa-filter mr-1"></i> Lọc Khách:</label>
                        <select
                            className="border border-gray-300 rounded px-3 py-2 w-full md:w-64 focus:outline-none focus:ring-2 focus:ring-blue-500"
                            value={selectedCustomer}
                            onChange={(e) => {
                                setSelectedCustomer(e.target.value);
                                setSelectedOrderIds(new Set());
                                setSelectedSettledIds(new Set());
                            }}
                        >
                            <option value="ALL">-- Tất cả khách hàng --</option>
                            {(activeTab === 'debt' ? uniqueCustomersList : uniqueSettledCustomersList).map((cust: string, idx: number) => (
                                <option key={idx} value={cust}>{cust}</option>
                            ))}
                        </select>

                        <div className="flex items-center gap-2">
                            <label className="font-semibold text-gray-700 whitespace-nowrap"><i className="fa-solid fa-calendar-days mr-1"></i> Tháng:</label>
                            <select
                                className="border border-gray-300 rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
                                value={selectedMonth}
                                onChange={(e) => {
                                    setSelectedMonth(Number(e.target.value));
                                    setSelectedOrderIds(new Set());
                                    setSelectedSettledIds(new Set());
                                }}
                            >
                                <option value={0}>Tất cả</option>
                                {Array.from({ length: 12 }, (_, i) => i + 1).map(m => (
                                    <option key={m} value={m}>Tháng {m}</option>
                                ))}
                            </select>
                            <select
                                className="border border-gray-300 rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
                                value={selectedYear}
                                onChange={(e) => {
                                    setSelectedYear(Number(e.target.value));
                                    setSelectedOrderIds(new Set());
                                    setSelectedSettledIds(new Set());
                                }}
                            >
                                {Array.from({ length: 5 }, (_, i) => new Date().getFullYear() - 2 + i).map(y => (
                                    <option key={y} value={y}>{y}</option>
                                ))}
                            </select>
                        </div>
                    </div>
                    <div className="flex gap-2 items-center">
                        <button onClick={fetchData} className="px-4 py-2 bg-gray-200 text-gray-700 rounded hover:bg-gray-300 transition">
                            <i className="fa-solid fa-sync mr-1"></i> Làm mới
                        </button>
                    </div>
                </div>

                {/* Tab: Công nợ */}
                {activeTab === 'debt' && (<>
                {/* Dashboard Stats */}
                <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-4">
                    <div className="bg-red-50 p-4 rounded-lg border border-red-100 flex flex-col justify-center items-center shadow-sm">
                        <span className="text-red-800 font-medium text-sm uppercase tracking-wider">Tổng Công Nợ</span>
                        <span className="text-3xl font-bold text-red-600 mt-1">{stats.totalDebt.toLocaleString('vi-VN')} đ</span>
                    </div>
                    <div className="bg-blue-50 p-4 rounded-lg border border-blue-100 flex flex-col justify-center items-center shadow-sm">
                        <span className="text-blue-800 font-medium text-sm uppercase tracking-wider">Số Khách Hàng Nợ</span>
                        <span className="text-3xl font-bold text-blue-600 mt-1">{stats.uniqueCustomers}</span>
                    </div>
                    <div className="bg-gray-50 p-4 rounded-lg border border-gray-100 flex flex-col justify-center items-center shadow-sm">
                        <span className="text-gray-800 font-medium text-sm uppercase tracking-wider">Số Đơn Hàng</span>
                        <span className="text-3xl font-bold text-gray-700 mt-1">{stats.count}</span>
                    </div>
                </div>

                {/* Debt Actions */}
                <div className="flex gap-2 items-center mb-4">
                    {selectedOrderIds.size > 0 && (
                        <button
                            onClick={() => handleConfirmPayment()}
                            className="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700 transition shadow-sm animate-pulse font-bold"
                        >
                            <i className="fa-solid fa-check-double mr-2"></i>
                            Chốt TT ({selectedOrderIds.size})
                        </button>
                    )}
                    <div className="flex-1"></div>
                    <div className="flex gap-1">
                        <button onClick={handleExportExcel} className="px-4 py-2 bg-green-600 text-white rounded hover:bg-green-700 transition shadow-sm text-sm">
                            <i className="fa-solid fa-file-excel mr-2"></i> Xuất Excel (Cơ bản)
                        </button>
                        <button onClick={handleExportDetailed} className="px-4 py-2 bg-teal-600 text-white rounded hover:bg-teal-700 transition shadow-sm text-sm">
                            <i className="fa-solid fa-file-lines mr-2"></i> Xuất Excel (Chi tiết)
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
                                        className="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded"
                                        checked={filteredOrders.length > 0 && selectedOrderIds.size === filteredOrders.length}
                                        onChange={toggleSelectAll}
                                    />
                                </th>
                                <th
                                    className="px-4 py-3 text-left font-bold text-gray-700 cursor-pointer hover:bg-gray-200 transition-colors select-none"
                                    onClick={() => setSortOrder(prev => prev === 'asc' ? 'desc' : 'asc')}
                                    title="Nhấn để sắp xếp tăng/giảm dần"
                                >
                                    Mã Đơn
                                    {sortOrder === 'asc' && <i className="fa-solid fa-sort-up ml-1 text-blue-600"></i>}
                                    {sortOrder === 'desc' && <i className="fa-solid fa-sort-down ml-1 text-blue-600"></i>}
                                    {!sortOrder && <i className="fa-solid fa-sort ml-1 text-gray-400 opacity-50"></i>}
                                </th>
                                <th className="px-4 py-3 text-left font-bold text-gray-700">Khách Hàng</th>
                                <th className="px-4 py-3 text-left font-bold text-gray-700">PT Kinh Doanh</th>
                                <th className="px-4 py-3 text-right font-bold text-gray-700">Tổng Tiền</th>
                                <th className="px-4 py-3 text-right font-bold text-gray-700">Đã TT</th>
                                <th className="px-4 py-3 text-right font-bold text-red-600">Còn Nợ</th>
                                <th className="px-4 py-3 text-left font-bold text-gray-700">Ngày Tạo</th>
                                <th className="px-4 py-3 text-center font-bold text-gray-700">Thao Tác</th>
                            </tr>
                        </thead>
                        <tbody className="bg-white divide-y divide-gray-200">
                            {loading ? (
                                <tr><td colSpan={9} className="px-6 py-8 text-center text-gray-500 italic">Đang tải dữ liệu công nợ...</td></tr>
                            ) : filteredOrders.length === 0 ? (
                                <tr><td colSpan={9} className="px-6 py-8 text-center text-gray-500">Không tìm thấy đơn hàng công nợ phù hợp.</td></tr>
                            ) : (
                                filteredOrders.map((order, idx) => (
                                    <tr
                                        key={idx}
                                        className={`hover:bg-blue-50 transition-colors ${selectedOrderIds.has(order.id) ? 'bg-blue-50' : ''}`}
                                        onClick={(e) => {
                                            // Toggle select on row click if not clicking button/checkbox
                                            if ((e.target as HTMLElement).tagName !== 'BUTTON' && (e.target as HTMLElement).tagName !== 'INPUT') {
                                                toggleSelectOrder(order.id);
                                            }
                                        }}
                                    >
                                        <td className="px-4 py-3 text-center">
                                            <input
                                                type="checkbox"
                                                className="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded"
                                                checked={selectedOrderIds.has(order.id)}
                                                onChange={() => toggleSelectOrder(order.id)}
                                            />
                                        </td>
                                        <td className="px-4 py-3 font-medium text-blue-600">{order.order_code}</td>
                                        <td className="px-4 py-3">{order.customer_name || 'Vãng lai'}</td>
                                        <td className="px-4 py-3 text-gray-600">{order.sales_rep_name}</td>
                                        <td className="px-4 py-3 text-right">{order.total_amount?.toLocaleString('vi-VN')}</td>
                                        <td className="px-4 py-3 text-right text-gray-500">{order.deposit_amount?.toLocaleString('vi-VN')}</td>
                                        <td className="px-4 py-3 text-right font-bold text-red-600">
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
                                    <td className="px-4 py-3 text-right text-red-700 text-base">{stats.totalDebt.toLocaleString('vi-VN')} đ</td>
                                    <td colSpan={2}></td>
                                </tr>
                            </tfoot>
                        )}
                    </table>
                </div>
                </>)}

                {/* Tab: Đã chốt */}
                {activeTab === 'settled' && (
                    <>
                    {/* Dashboard Stats */}
                    <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-4">
                        <div className="bg-green-50 p-4 rounded-lg border border-green-100 flex flex-col justify-center items-center shadow-sm">
                            <span className="text-green-800 font-medium text-sm uppercase tracking-wider">Tổng Đã Thu</span>
                            <span className="text-3xl font-bold text-green-600 mt-1">{settledStats.totalAmount.toLocaleString('vi-VN')} đ</span>
                        </div>
                        <div className="bg-blue-50 p-4 rounded-lg border border-blue-100 flex flex-col justify-center items-center shadow-sm">
                            <span className="text-blue-800 font-medium text-sm uppercase tracking-wider">Số Khách Hàng</span>
                            <span className="text-3xl font-bold text-blue-600 mt-1">{settledStats.uniqueCustomers}</span>
                        </div>
                        <div className="bg-gray-50 p-4 rounded-lg border border-gray-100 flex flex-col justify-center items-center shadow-sm">
                            <span className="text-gray-800 font-medium text-sm uppercase tracking-wider">Số Đơn Đã Chốt</span>
                            <span className="text-3xl font-bold text-gray-700 mt-1">{settledStats.count}</span>
                        </div>
                    </div>

                    {/* Bulk undo button */}
                    {selectedSettledIds.size > 0 && (
                        <div className="mb-3 flex items-center gap-3">
                            <button
                                onClick={() => handleUndoPayment()}
                                className="px-4 py-2 bg-orange-600 text-white rounded hover:bg-orange-700 transition shadow-sm font-bold animate-pulse"
                            >
                                <i className="fa-solid fa-undo mr-2"></i>
                                Hoàn tác ({selectedSettledIds.size}) đơn đã chọn
                            </button>
                            <span className="text-sm text-gray-500">Đã chọn {selectedSettledIds.size} / {filteredSettled.length} đơn</span>
                        </div>
                    )}
                    <div className="overflow-x-auto flex-grow rounded border border-gray-200">
                        <div className="p-3 bg-green-50 border-b border-green-200 text-sm text-green-700">
                            <i className="fa-solid fa-info-circle mr-1"></i>
                            Danh sách đơn đã chốt thanh toán. Chọn đơn và bấm <strong>"Hoàn tác"</strong> để đưa về trạng thái Công Nợ (nếu chốt nhầm).
                        </div>
                        <table className="min-w-full divide-y divide-gray-200 border-collapse text-sm">
                            <thead className="bg-gray-100 sticky top-0 z-10">
                                <tr>
                                    <th className="px-4 py-3 text-center w-12">
                                        <input
                                            type="checkbox"
                                            className="h-4 w-4 text-orange-600 focus:ring-orange-500 border-gray-300 rounded"
                                            checked={filteredSettled.length > 0 && selectedSettledIds.size === filteredSettled.length}
                                            onChange={toggleSettledSelectAll}
                                        />
                                    </th>
                                    <th className="px-4 py-3 text-left font-bold text-gray-700">Mã Đơn</th>
                                    <th className="px-4 py-3 text-left font-bold text-gray-700">Khách Hàng</th>
                                    <th className="px-4 py-3 text-left font-bold text-gray-700">PT Kinh Doanh</th>
                                    <th className="px-4 py-3 text-right font-bold text-gray-700">Tổng Tiền</th>
                                    <th className="px-4 py-3 text-left font-bold text-gray-700">Ngày Tạo</th>
                                    <th className="px-4 py-3 text-left font-bold text-gray-700">Ngày Chốt</th>
                                    <th className="px-4 py-3 text-center font-bold text-gray-700">Thao Tác</th>
                                </tr>
                            </thead>
                            <tbody className="bg-white divide-y divide-gray-200">
                                {loading ? (
                                    <tr><td colSpan={8} className="px-6 py-8 text-center text-gray-500 italic">Đang tải...</td></tr>
                                ) : filteredSettled.length === 0 ? (
                                    <tr><td colSpan={8} className="px-6 py-8 text-center text-gray-500">Không có đơn đã chốt trong khoảng thời gian này.</td></tr>
                                ) : (
                                    filteredSettled.map((order: any, idx: number) => (
                                        <tr
                                            key={idx}
                                            className={`hover:bg-orange-50 transition-colors cursor-pointer ${selectedSettledIds.has(order.id) ? 'bg-orange-50' : ''}`}
                                            onClick={(e) => {
                                                if ((e.target as HTMLElement).tagName !== 'BUTTON' && (e.target as HTMLElement).tagName !== 'INPUT') {
                                                    toggleSettledSelect(order.id);
                                                }
                                            }}
                                        >
                                            <td className="px-4 py-3 text-center">
                                                <input
                                                    type="checkbox"
                                                    className="h-4 w-4 text-orange-600 focus:ring-orange-500 border-gray-300 rounded"
                                                    checked={selectedSettledIds.has(order.id)}
                                                    onChange={() => toggleSettledSelect(order.id)}
                                                />
                                            </td>
                                            <td className="px-4 py-3 font-medium text-blue-600">{order.order_code}</td>
                                            <td className="px-4 py-3">{order.customer_name || 'Vãng lai'}</td>
                                            <td className="px-4 py-3 text-gray-600">{order.sales_rep_name}</td>
                                            <td className="px-4 py-3 text-right">{order.total_amount?.toLocaleString('vi-VN')}</td>
                                            <td className="px-4 py-3 text-gray-500">{new Date(order.created_at).toLocaleDateString('vi-VN')}</td>
                                            <td className="px-4 py-3 text-gray-500">{order.updated_at ? new Date(order.updated_at).toLocaleDateString('vi-VN') : '—'}</td>
                                            <td className="px-4 py-3 text-center">
                                                <button
                                                    onClick={(e) => {
                                                        e.stopPropagation();
                                                        handleUndoPayment(order);
                                                    }}
                                                    className="bg-orange-100 text-orange-700 px-3 py-1 rounded-full text-xs hover:bg-orange-200 font-semibold border border-orange-200 transition"
                                                    title="Hoàn tác về trạng thái Công Nợ"
                                                >
                                                    <i className="fa-solid fa-undo mr-1"></i> Hoàn tác
                                                </button>
                                            </td>
                                        </tr>
                                    ))
                                )}
                            </tbody>
                        </table>
                    </div>
                    </>
                )}
            </div>
        </div >
    );
};

export default DebtReportModal;
