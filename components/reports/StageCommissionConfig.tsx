
import React, { useState, useEffect } from 'react';
import { commissionService } from '../../services/commissionService';
import { CommissionPolicy } from '../../types';

export const StageCommissionConfig: React.FC = () => {
    const [policies, setPolicies] = useState<CommissionPolicy[]>([]);
    const [loading, setLoading] = useState(false);
    const [updating, setUpdating] = useState(false);

    // Map DB codes to VN display names
    const STAGE_NAMES: Record<string, string> = {
        'NhanFile': 'Nhận File',
        'XuLyFile': 'Xử lý File',
        'BinhFile': 'Bình File',
        'In': 'In ấn',
        'ThanhPham': 'Thành phẩm',
        'DongGoi': 'Đóng gói',
        'GiaoHang': 'Giao hàng (Chung)',
        'DaGiaoHang': 'Đã giao hàng (Hoàn tất)',
        'EpKim': 'Ép kim',
        'BeDemi': 'Bế Demi',
        'InKhoLon': 'In Khổ Lớn',
        'ThietKe': 'Thiết Kế',
        'CanMang': 'Cán Màng',
        'GiaCongNgoai': 'Gia Công Ngoài'
    };

    useEffect(() => {
        loadPolicies();
    }, []);

    const loadPolicies = async () => {
        setLoading(true);
        try {
            // Load both Main Tasks and Sub Tasks
            const [mainTasks, subTasks] = await Promise.all([
                commissionService.getCommissionPolicies('MAINTASK_RATE'),
                commissionService.getCommissionPolicies('SUBTASK_RATE')
            ]);
            // Merge and Sort
            setPolicies([...mainTasks, ...subTasks]);
        } catch (error) {
            console.error("Failed to load policies", error);
        } finally {
            setLoading(false);
        }
    };

    const handleRateChange = (id: string, newRate: string) => {
        setPolicies(prev => prev.map(p =>
            p.id === id ? { ...p, rate: parseFloat(newRate) } : p
        ));
    };

    const handleSave = async () => {
        setUpdating(true);
        try {
            const updatePromises = policies.map(p =>
                commissionService.updateCommissionPolicy(p.id, { rate: p.rate })
            );
            await Promise.all(updatePromises);
            alert("Cập nhật cấu hình thành công!");
        } catch (error) {
            console.error("Update failed", error);
            alert("Lỗi khi cập nhật. Vui lòng thử lại.");
        } finally {
            setUpdating(false);
        }
    };

    const mainTaskPolicies = policies.filter(p => p.policy_type === 'MAINTASK_RATE');
    const subTaskPolicies = policies.filter(p => p.policy_type === 'SUBTASK_RATE');

    const ConfigTable = ({ title, items, note }: { title: string, items: CommissionPolicy[], note: string }) => (
        <div className="mb-6">
            <h4 className="font-bold text-gray-700 mb-2 border-b pb-1">{title}</h4>
            <div className="overflow-x-auto border rounded-lg">
                <table className="min-w-full text-sm text-left text-gray-500">
                    <thead className="text-xs text-gray-700 uppercase bg-gray-50">
                        <tr>
                            <th className="px-6 py-3 w-1/3">Công Đoạn / Khâu</th>
                            <th className="px-6 py-3 w-1/3">Tỷ lệ Đóng Góp (%)</th>
                            <th className="px-6 py-3 w-1/3">Ghi chú</th>
                        </tr>
                    </thead>
                    <tbody>
                        {items.map(policy => (
                            <tr key={policy.id} className="bg-white border-b hover:bg-gray-50">
                                <td className="px-6 py-4 font-medium text-gray-900 whitespace-nowrap">
                                    {STAGE_NAMES[policy.apply_to || ''] || policy.apply_to}
                                </td>
                                <td className="px-6 py-4">
                                    <div className="flex items-center gap-2">
                                        <input
                                            type="number"
                                            step="1"
                                            min="0"
                                            max="100"
                                            value={policy.rate}
                                            onChange={(e) => handleRateChange(policy.id, e.target.value)}
                                            className="w-20 border border-gray-300 rounded px-2 py-1 text-right focus:ring-blue-500 focus:border-blue-500 font-mono font-bold"
                                        />
                                        <span className="font-bold text-gray-600">%</span>
                                    </div>
                                </td>
                                <td className="px-6 py-4 text-xs text-gray-400">
                                    {note}
                                </td>
                            </tr>
                        ))}
                        {items.length === 0 && (
                            <tr><td colSpan={3} className="p-4 text-center italic text-gray-400">Chưa có dữ liệu</td></tr>
                        )}
                    </tbody>
                </table>
            </div>
        </div>
    );

    if (loading) return <div className="p-4 text-center">Đang tải cấu hình...</div>;

    return (
        <div className="p-4 bg-white rounded shadow-sm border border-gray-200">
            <h3 className="font-bold text-purple-700 mb-4 text-lg">Cấu hình % Hoa hồng</h3>

            <ConfigTable
                title="1. Quy Trình Sản Xuất Chính (Gồm nhiều người)"
                items={mainTaskPolicies}
                note="Tính trên Tổng Giá Trị Đơn hàng (Trước VAT)"
            />

            <ConfigTable
                title="2. Dịch Vụ & Công Đoạn Tính Phí Riêng"
                items={subTaskPolicies}
                note="Tính trên Phí Dịch Vụ (Design Fee, Large Print Fee...)"
            />

            <div className="mt-4 flex justify-end">
                <button
                    onClick={handleSave}
                    disabled={updating}
                    className="px-6 py-2 bg-blue-600 text-white rounded hover:bg-blue-700 disabled:opacity-50 font-medium flex items-center gap-2 shadow-sm"
                >
                    {updating && <i className="fa-solid fa-spinner fa-spin"></i>}
                    <i className="fa-solid fa-save"></i> Lưu Thay Đổi
                </button>
            </div>

            <div className="mt-4 p-3 bg-blue-50 text-blue-700 text-xs rounded border border-blue-100">
                <i className="fa-solid fa-info-circle mr-1"></i>
                Lưu ý: Thay đổi sẽ áp dụng ngay cho các lần tính toán tiếp theo.
            </div>
        </div>
    );
};
