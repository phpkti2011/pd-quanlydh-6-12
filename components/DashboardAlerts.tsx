import React, { useState, useEffect } from 'react';
import { alertService, SalesAlerts, ProductionAlerts } from '../services/alertService';

interface DashboardAlertsProps {
    userRole: string;
}

export const DashboardAlerts: React.FC<DashboardAlertsProps> = ({ userRole }) => {
    const [salesAlerts, setSalesAlerts] = useState<SalesAlerts | null>(null);
    const [prodAlerts, setProdAlerts] = useState<ProductionAlerts | null>(null);
    const [loading, setLoading] = useState(true);
    const [expanded, setExpanded] = useState(true);

    useEffect(() => {
        fetchAlerts();
    }, [userRole]);

    const fetchAlerts = async () => {
        setLoading(true);
        if (userRole === 'NhanVienKinhDoanh') {
            const data = await alertService.getSalesAlerts();
            setSalesAlerts(data);
        } else if (['QuanLySanXuat', 'NhanVienSanXuat', 'NhanVienThietKe'].includes(userRole)) {
            const data = await alertService.getProductionAlerts();
            setProdAlerts(data);
        }
        setLoading(false);
    };

    if (loading) return null;

    const hasSalesAlerts = salesAlerts && (salesAlerts.debt.length > 0 || salesAlerts.deadline.length > 0 || salesAlerts.approval.length > 0);
    const hasProdAlerts = prodAlerts && (prodAlerts.urgent.length > 0 || prodAlerts.bottleneck.length > 0);

    if (!hasSalesAlerts && !hasProdAlerts) return null;

    return (
        <div className="bg-white border text-left border-red-100 rounded-lg shadow-sm mb-4 overflow-hidden">
            <div className="bg-gradient-to-r from-red-50 to-white px-4 py-2 border-b border-red-100 flex justify-between items-center cursor-pointer" onClick={() => setExpanded(!expanded)}>
                <div className="flex items-center gap-2">
                    <span className="w-2 h-2 rounded-full bg-red-500 animate-pulse"></span>
                    <h3 className="font-bold text-red-800 text-sm">
                        <i className="fa-solid fa-bell mr-1"></i> Thông Báo Quan Trọng
                    </h3>
                </div>
                <i className={`fa-solid fa-chevron-${expanded ? 'up' : 'down'} text-gray-400 text-xs`}></i>
            </div>

            {expanded && (
                <div className="p-3 grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-3">
                    {/* Sales Alerts */}
                    {salesAlerts?.debt.length ? (
                        <div className="bg-red-50 rounded p-2 border border-red-100">
                            <h4 className="font-bold text-red-700 text-xs mb-1">🔴 Khách nợ quá hạn ({salesAlerts.debt.length})</h4>
                            <ul className="text-xs text-red-600 space-y-1 pl-4 list-disc">
                                {salesAlerts.debt.map((a, i) => (
                                    <li key={i}>{a.order_code} (Còn {new Intl.NumberFormat('vi-VN').format(a.remaining_amount)}đ)</li>
                                ))}
                            </ul>
                        </div>
                    ) : null}

                    {salesAlerts?.deadline.length ? (
                        <div className="bg-orange-50 rounded p-2 border border-orange-100">
                            <h4 className="font-bold text-orange-700 text-xs mb-1">🟠 Cần giao gấp ({salesAlerts.deadline.length})</h4>
                            <ul className="text-xs text-orange-600 space-y-1 pl-4 list-disc">
                                {salesAlerts.deadline.map((a, i) => (
                                    <li key={i}>{a.order_code} (Hạn: {new Date(a.delivery_date).toLocaleDateString()})</li>
                                ))}
                            </ul>
                        </div>
                    ) : null}

                    {salesAlerts?.approval.length ? (
                        <div className="bg-yellow-50 rounded p-2 border border-yellow-100">
                            <h4 className="font-bold text-yellow-700 text-xs mb-1">🟡 Chờ duyệt tiền ({salesAlerts.approval.length})</h4>
                            <ul className="text-xs text-yellow-600 space-y-1 pl-4 list-disc">
                                {salesAlerts.approval.map((a, i) => (
                                    <li key={i}>{a.order_code}</li>
                                ))}
                            </ul>
                        </div>
                    ) : null}

                    {/* Production Alerts */}
                    {prodAlerts?.urgent.length ? (
                        <div className="bg-red-50 rounded p-2 border border-red-100">
                            <h4 className="font-bold text-red-700 text-xs mb-1">🔥 Đơn GẤP hôm nay ({prodAlerts.urgent.length})</h4>
                            <ul className="text-xs text-red-600 space-y-1 pl-4 list-disc">
                                {prodAlerts.urgent.map((a, i) => (
                                    <li key={i}>{a.order_code} ({a.status})</li>
                                ))}
                            </ul>
                        </div>
                    ) : null}

                    {prodAlerts?.bottleneck.length ? (
                        <div className="bg-purple-50 rounded p-2 border border-purple-100">
                            <h4 className="font-bold text-purple-700 text-xs mb-1">🐢 Đơn bị kẹt ({prodAlerts.bottleneck.length})</h4>
                            <ul className="text-xs text-purple-600 space-y-1 pl-4 list-disc">
                                {prodAlerts.bottleneck.map((a, i) => (
                                    <li key={i}>{a.order_code} ({a.status})</li>
                                ))}
                            </ul>
                        </div>
                    ) : null}
                </div>
            )}
        </div>
    );
};
