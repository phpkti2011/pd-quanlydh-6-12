
import React, { useState, useEffect } from 'react';
import { supabase } from '../services/supabaseClient';
import { commissionService } from '../services/commissionService';
import { Profile, SalesTarget, CommissionPolicy, ProductionTierSummary } from '../types';
import { COLORS } from '../constants';

interface KPIManagerProps {
    isOpen: boolean;
    onClose: () => void;
}

// ... Imports
// (Removed CommissionPolicy interface as we are moving to sales_targets)

const KPIManager: React.FC<KPIManagerProps> = ({ isOpen, onClose }) => {
    const [activeTab, setActiveTab] = useState<'employees' | 'company' | 'production'>('employees');
    const [selectedMonth, setSelectedMonth] = useState(new Date().getMonth() + 1);
    const [selectedYear, setSelectedYear] = useState(new Date().getFullYear());

    const [employees, setEmployees] = useState<Profile[]>([]);
    // targets now stores { target_amount, commission_rate }
    const [targets, setTargets] = useState<Record<string, { target: number, rate: number }>>({});
    // Per-month commission tiers: { [userId]: tiers[] }
    const [commissionTiers, setCommissionTiers] = useState<Record<string, any[]>>({});
    const [loading, setLoading] = useState(false);

    // Modal State
    const [configuringEmployee, setConfiguringEmployee] = useState<Profile | null>(null);
    const [showConfigModal, setShowConfigModal] = useState(false);

    // Load Data
    useEffect(() => {
        if (isOpen) {
            fetchEmployees();
            fetchTargets();
        }
    }, [isOpen, selectedMonth, selectedYear]);

    const fetchEmployees = async () => {
        const { data } = await supabase.from('profiles').select('*').order('full_name', { ascending: true });
        setEmployees(data || []);
    };

    const fetchTargets = async () => {
        setLoading(true);
        const { data, error } = await supabase
            .from('sales_targets')
            .select('*')
            .eq('period_month', selectedMonth)
            .eq('period_year', selectedYear);

        if (error) {
            console.error(error);
        } else if (data) {
            const map: Record<string, { target: number, rate: number }> = {};
            const tiersMap: Record<string, any[]> = {};
            data.forEach((t: any) => {
                const key = t.entity_type === 'user' ? t.entity_id : t.department_name;
                if (key) {
                    map[key] = { target: t.target_amount, rate: t.commission_rate || 0 };
                    // Load per-month commission_tiers if available
                    if (t.entity_type === 'user' && t.commission_tiers) {
                        tiersMap[t.entity_id] = t.commission_tiers;
                    }
                }
            });
            setTargets(map);
            setCommissionTiers(tiersMap);
        }
        setLoading(false);
    };

    const handleTargetChange = (key: string, field: 'target' | 'rate', value: number) => {
        setTargets(prev => ({
            ...prev,
            [key]: {
                ...prev[key] || { target: 0, rate: 0 },
                [field]: value
            }
        }));
    };

    const saveTargets = async () => {
        setLoading(true);
        const upsertData: any[] = []; // Use any for new column

        // 1. Employee Targets
        if (activeTab === 'employees') {
            employees.forEach(emp => {
                const data = targets[emp.id];
                if (data && data.target !== undefined) {
                    const upsertRow: any = {
                        entity_type: 'user',
                        entity_id: emp.id,
                        period_month: selectedMonth,
                        period_year: selectedYear,
                        target_amount: data.target,
                        commission_rate: 0
                    };
                    // Include per-month commission_tiers if set
                    if (commissionTiers[emp.id]) {
                        upsertRow.commission_tiers = commissionTiers[emp.id];
                    }
                    upsertData.push(upsertRow);
                }
            });
        } else {
            // Company & Dept
            ['Company', 'Sales'].forEach(dept => {
                const data = targets[dept];
                if (data) {
                    upsertData.push({
                        entity_type: dept === 'Company' ? 'company' : 'department',
                        department_name: dept,
                        period_month: selectedMonth,
                        period_year: selectedYear,
                        target_amount: data.target,
                        commission_rate: data.rate // Save the rate!
                    });
                }
            });
        }

        if (upsertData.length > 0) {
            // Delete existing records for this month/year first, then insert
            for (const row of upsertData) {
                let q = supabase.from('sales_targets').delete()
                    .eq('entity_type', row.entity_type)
                    .eq('period_month', row.period_month)
                    .eq('period_year', row.period_year);
                if (row.entity_id) q = q.eq('entity_id', row.entity_id);
                if (row.department_name) q = q.eq('department_name', row.department_name);
                await q;
            }
            const { error } = await supabase.from('sales_targets').insert(upsertData);
            if (error) alert('Lỗi lưu KPI: ' + error.message);
            else alert('Đã lưu KPI & Cấu hình thưởng thành công!');
        }
        setLoading(false);
    };

    const handleCopyFromPreviousMonth = async () => {
        if (!confirm(`Bạn có chắc muốn sao chép cấu hình KPI từ tháng trước (Tháng ${selectedMonth === 1 ? 12 : selectedMonth - 1}/${selectedMonth === 1 ? selectedYear - 1 : selectedYear}) sang tháng hiện tại không? Dữ liệu hiện tại sẽ bị ghi đè.`)) {
            return;
        }

        setLoading(true);

        const prevMonth = selectedMonth === 1 ? 12 : selectedMonth - 1;
        const prevYear = selectedMonth === 1 ? selectedYear - 1 : selectedYear;

        const { data, error } = await supabase
            .from('sales_targets')
            .select('*')
            .eq('period_month', prevMonth)
            .eq('period_year', prevYear);

        if (error) {
            console.error(error);
            alert('Lỗi sao chép dữ liệu: ' + error.message);
        } else if (data && data.length > 0) {
            const map: Record<string, { target: number, rate: number }> = {};
            const tiersMap: Record<string, any[]> = {};
            data.forEach((t: any) => {
                const key = t.entity_type === 'user' ? t.entity_id : t.department_name;
                if (key) map[key] = { target: t.target_amount, rate: t.commission_rate || 0 };
                // Also copy per-month commission_tiers
                if (t.entity_type === 'user' && t.commission_tiers) {
                    tiersMap[t.entity_id] = t.commission_tiers;
                }
            });
            setTargets(map);
            setCommissionTiers(tiersMap);
            alert(`Đã tải ${data.length} dòng dữ liệu KPI (bao gồm cấu hình hoa hồng) từ tháng ${prevMonth}/${prevYear}. Vui lòng kiểm tra và nhấn "Lưu Cấu Hình" để áp dụng.`);
        } else {
            alert(`Không tìm thấy dữ liệu KPI của tháng ${prevMonth}/${prevYear}.`);
        }
        setLoading(false);
    };

    const handleSaveCommissionConfig = async (updatedEmp: Profile) => {
        const tiers = updatedEmp.commission_tiers || [];

        // Save to sales_targets per month (not profiles)
        // Delete then insert to avoid conflict issues
        await supabase.from('sales_targets').delete()
            .eq('entity_type', 'user')
            .eq('entity_id', updatedEmp.id)
            .eq('period_month', selectedMonth)
            .eq('period_year', selectedYear);
        const { error } = await supabase.from('sales_targets').insert({
            entity_type: 'user',
            entity_id: updatedEmp.id,
            period_month: selectedMonth,
            period_year: selectedYear,
            target_amount: targets[updatedEmp.id]?.target || 0,
            commission_rate: 0,
            commission_tiers: tiers
        });

        if (error) {
            alert("Lỗi lưu cấu hình hoa hồng: " + error.message);
        } else {
            // Update local state
            setCommissionTiers(prev => ({ ...prev, [updatedEmp.id]: tiers }));
            setShowConfigModal(false);
            setConfiguringEmployee(null);
        }
    };

    if (!isOpen) return null;

    return (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-50">
            <div className="bg-white rounded-lg w-full max-w-5xl h-[85vh] flex flex-col shadow-2xl animate-fade-in-up">
                {/* Header */}
                <div className="px-6 py-4 border-b border-gray-200 flex justify-between items-center bg-blue-600 text-white rounded-t-lg">
                    <div>
                        <h2 className="text-xl font-bold">Thiết lập KPI & Hoa hồng</h2>
                        <p className="text-sm text-blue-100">Cấu hình chỉ tiêu và tỷ lệ thưởng nhóm (Tính theo Doanh thu CHƯA VAT)</p>
                    </div>
                    <button onClick={onClose} className="text-blue-100 hover:text-white">
                        <i className="fa-solid fa-xmark text-2xl"></i>
                    </button>
                </div>

                {/* Toolbar */}
                <div className="px-6 py-4 bg-gray-50 border-b flex justify-between items-center">
                    <div className="flex items-center gap-4">
                        <div className="flex items-center gap-2 bg-white px-3 py-1.5 rounded border">
                            <span className="text-gray-500 text-sm">Tháng:</span>
                            <select
                                value={selectedMonth}
                                onChange={e => setSelectedMonth(parseInt(e.target.value))}
                                className="font-bold text-gray-700 outline-none"
                            >
                                {Array.from({ length: 12 }, (_, i) => i + 1).map(m => (
                                    <option key={m} value={m}>Tháng {m}</option>
                                ))}
                            </select>
                        </div>
                        <div className="flex items-center gap-2 bg-white px-3 py-1.5 rounded border">
                            <span className="text-gray-500 text-sm">Năm:</span>
                            <select
                                value={selectedYear}
                                onChange={e => setSelectedYear(parseInt(e.target.value))}
                                className="font-bold text-gray-700 outline-none"
                            >
                                {[2024, 2025, 2026, 2027, 2028, 2029, 2030].map(y => (
                                    <option key={y} value={y}>{y}</option>
                                ))}
                            </select>
                        </div>
                    </div>

                    <div className="flex bg-gray-200 rounded p-1">
                        <button
                            onClick={() => setActiveTab('employees')}
                            className={`px-4 py-1.5 rounded text-sm font-medium transition-colors ${activeTab === 'employees' ? 'bg-white shadow text-blue-600' : 'text-gray-600 hover:text-gray-800'}`}
                        >
                            Nhân viên
                        </button>
                        <button
                            onClick={() => setActiveTab('company')}
                            className={`px-4 py-1.5 rounded text-sm font-medium transition-colors ${activeTab === 'company' ? 'bg-white shadow text-blue-600' : 'text-gray-600 hover:text-gray-800'}`}
                        >
                            Công ty & Phòng ban
                        </button>
                        <button
                            onClick={() => setActiveTab('production')}
                            className={`px-4 py-1.5 rounded text-sm font-medium transition-colors ${activeTab === 'production' ? 'bg-white shadow text-orange-600' : 'text-gray-600 hover:text-gray-800'}`}
                        >
                            Sản xuất
                        </button>
                    </div>

                    <button
                        onClick={handleCopyFromPreviousMonth}
                        disabled={loading}
                        className="ml-4 px-3 py-1.5 bg-orange-100 text-orange-700 rounded hover:bg-orange-200 text-sm font-medium flex items-center gap-2 border border-orange-200"
                        title="Sao chép từ tháng trước"
                    >
                        <i className="fa-solid fa-copy"></i>
                        Lấy từ tháng trước
                    </button>
                </div>

                {/* Content */}
                <div className="flex-1 overflow-auto p-6">
                    {activeTab === 'production' ? (
                        <ProductionTierTab month={selectedMonth} year={selectedYear} />
                    ) : activeTab === 'employees' ? (
                        <table className="w-full text-sm">
                            <thead className="bg-gray-100 text-gray-600 border-b">
                                <tr>
                                    <th className="px-4 py-3 text-left w-1/4">Nhân viên</th>
                                    <th className="px-4 py-3 text-left w-1/4">Chức vụ</th>
                                    <th className="px-4 py-3 text-right w-1/4">Chỉ tiêu (Chưa VAT)</th>
                                    <th className="px-4 py-3 text-center w-1/4">Cấu hình Hoa hồng</th>
                                </tr>
                            </thead>
                            <tbody className="divide-y text-gray-700">
                                {employees.map(emp => (
                                    <tr key={emp.id} className="hover:bg-blue-50">
                                        <td className="px-4 py-3 font-medium text-gray-800">{emp.full_name}</td>
                                        <td className="px-4 py-3 text-gray-500">{emp.position || emp.role}</td>
                                        <td className="px-4 py-3 text-right">
                                            <input
                                                type="number"
                                                className="w-32 px-2 py-1 border rounded text-right font-medium focus:ring-2 focus:ring-blue-500 outline-none"
                                                placeholder="0"
                                                value={targets[emp.id]?.target || ''}
                                                onChange={e => handleTargetChange(emp.id, 'target', parseFloat(e.target.value))}
                                            />
                                        </td>
                                        <td className="px-4 py-3 text-center">
                                            {/* Show Config for Sales OR Manager Production */}
                                            {(emp.role === 'NhanVienKinhDoanh' || emp.role === 'QuanLySanXuat' || emp.role === 'Admin') && (
                                                <button
                                                    onClick={() => {
                                                        // Use per-month tiers if available, fallback to profile tiers
                                                        const monthTiers = commissionTiers[emp.id];
                                                        const empWithTiers = monthTiers
                                                            ? { ...emp, commission_tiers: monthTiers }
                                                            : emp;
                                                        setConfiguringEmployee(empWithTiers);
                                                        setShowConfigModal(true);
                                                    }}
                                                    className="text-xs px-3 py-1.5 bg-indigo-50 text-indigo-600 rounded-full hover:bg-indigo-100 font-medium flex items-center justify-center gap-1 mx-auto transition-colors"
                                                    title={emp.role === 'QuanLySanXuat' ? 'Tính trên Tổng Doanh Thu' : 'Tính trên Doanh Số Cá Nhân'}
                                                >
                                                    <i className="fa-solid fa-gear"></i>
                                                    {(commissionTiers[emp.id] || emp.commission_tiers)?.length ? `${(commissionTiers[emp.id] || emp.commission_tiers).length} mốc` : 'Cấu hình'}
                                                </button>
                                            )}
                                        </td>
                                    </tr>
                                ))}
                            </tbody>
                        </table>
                    ) : (
                        <table className="w-full text-sm">
                            <thead className="bg-gray-100 text-gray-600 border-b">
                                <tr>
                                    <th className="px-4 py-3 text-left w-1/3">Đơn vị</th>
                                    <th className="px-4 py-3 text-right w-1/3">Chỉ tiêu (Chưa VAT)</th>
                                    <th className="px-4 py-3 text-right w-1/3">% Thưởng (Nếu đạt)</th>
                                </tr>
                            </thead>
                            <tbody className="divide-y relative">
                                <tr className="hover:bg-blue-50">
                                    <td className="px-4 py-4 font-bold text-gray-800 text-base">Toàn Công Ty</td>
                                    <td className="px-4 py-4 text-right">
                                        <input
                                            type="number"
                                            className="w-48 px-3 py-2 border rounded text-right font-bold text-lg focus:ring-2 focus:ring-blue-500 outline-none text-blue-600"
                                            placeholder="0"
                                            value={targets['Company']?.target || ''}
                                            onChange={e => handleTargetChange('Company', 'target', parseFloat(e.target.value))}
                                        />
                                    </td>
                                    <td className="px-4 py-4 text-right">
                                        {/* Company Global Bonus Rate - Usually unused but available */}
                                        <input
                                            type="number" step="0.1"
                                            className="w-24 px-3 py-2 border rounded text-right font-bold text-lg focus:ring-2 focus:ring-blue-500 outline-none text-orange-500"
                                            placeholder="%"
                                            value={targets['Company']?.rate || ''}
                                            onChange={e => handleTargetChange('Company', 'rate', parseFloat(e.target.value))}
                                        />
                                    </td>
                                </tr>
                                <tr className="hover:bg-blue-50">
                                    <td className="px-4 py-4 font-bold text-gray-800 text-base">Phòng Kinh Doanh</td>
                                    <td className="px-4 py-4 text-right">
                                        <input
                                            type="number"
                                            className="w-48 px-3 py-2 border rounded text-right font-bold text-lg focus:ring-2 focus:ring-blue-500 outline-none text-green-600"
                                            placeholder="0"
                                            value={targets['Sales']?.target || ''}
                                            onChange={e => handleTargetChange('Sales', 'target', parseFloat(e.target.value))}
                                        />
                                    </td>
                                    <td className="px-4 py-4 text-right">
                                        <div className="flex items-center justify-end gap-2">
                                            <input
                                                type="number" step="0.1"
                                                className="w-24 px-3 py-2 border rounded text-right font-bold text-lg focus:ring-2 focus:ring-blue-500 outline-none text-red-600"
                                                placeholder="%"
                                                value={targets['Sales']?.rate || ''}
                                                onChange={e => handleTargetChange('Sales', 'rate', parseFloat(e.target.value))}
                                            />
                                            <span className="font-bold text-gray-500">%</span>
                                        </div>
                                        <div className="text-xs text-gray-400 mt-1">Thưởng khi đạt chỉ tiêu nhóm</div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    )}
                </div>

                {/* Footer */}
                <div className="px-6 py-4 border-t bg-gray-50 flex justify-end gap-3">
                    <button onClick={onClose} className="px-4 py-2 text-gray-600 hover:bg-gray-200 rounded font-medium">Đóng</button>
                    <button
                        onClick={saveTargets}
                        disabled={loading}
                        className="px-6 py-2 bg-blue-600 text-white rounded font-bold hover:bg-blue-700 shadow-sm disabled:bg-gray-400 flex items-center gap-2"
                    >
                        {loading && <i className="fa-solid fa-spinner fa-spin"></i>}
                        Lưu Cấu Hình
                    </button>
                </div>
            </div>

            {/* COMMISSION CONFIG MODAL */}
            {showConfigModal && configuringEmployee && (
                <CommissionConfigModal
                    employee={configuringEmployee}
                    onClose={() => setShowConfigModal(false)}
                    onSave={handleSaveCommissionConfig}
                    initialMonth={selectedMonth}
                    initialYear={selectedYear}
                />
            )}
        </div>
    );
};

// Production Tier Configuration Tab
const ProductionTierTab: React.FC<{ month: number; year: number }> = ({ month, year }) => {
    const [tiers, setTiers] = useState<CommissionPolicy[]>([]);
    const [summary, setSummary] = useState<ProductionTierSummary | null>(null);
    const [loading, setLoading] = useState(false);
    const [saving, setSaving] = useState(false);
    const [editTiers, setEditTiers] = useState<{ id: string | null; threshold_min: number; threshold_max: number | null; rate: number }[]>([]);

    useEffect(() => {
        loadData();
    }, [month, year]);

    const loadData = async () => {
        setLoading(true);
        try {
            const [tiersData, summaryData] = await Promise.all([
                commissionService.getProductionTiers(),
                commissionService.getProductionCommissionSummary(month, year)
            ]);
            setTiers(tiersData);
            setEditTiers(tiersData.map(t => ({
                id: t.id,
                threshold_min: t.threshold_min || 0,
                threshold_max: t.threshold_max || null,
                rate: t.rate
            })));
            setSummary(summaryData);
        } catch (err) {
            console.error('Load production tiers error:', err);
        }
        setLoading(false);
    };

    const formatMoney = (amount: number) => {
        if (amount >= 1000000) return `${(amount / 1000000).toFixed(0)} triệu`;
        return new Intl.NumberFormat('vi-VN').format(amount) + 'đ';
    };

    const addTier = () => {
        setEditTiers(prev => [...prev, { id: null, threshold_min: 0, threshold_max: null, rate: 0 }]);
    };

    const removeTier = (index: number) => {
        setEditTiers(prev => prev.filter((_, i) => i !== index));
    };

    const updateTier = (index: number, field: string, value: number | null) => {
        setEditTiers(prev => prev.map((t, i) => i === index ? { ...t, [field]: value } : t));
    };

    const handleSave = async () => {
        setSaving(true);
        try {
            await commissionService.saveProductionTiers(
                editTiers.map(t => ({
                    threshold_min: t.threshold_min || 0,
                    threshold_max: t.threshold_max,
                    rate: t.rate || 0
                }))
            );
            alert('Đã lưu cấu hình mốc thưởng sản xuất!');
            await loadData();
        } catch (err: any) {
            console.error('Save production tiers error:', err);
            alert('Lỗi lưu: ' + err.message);
        }
        setSaving(false);
    };

    const getTierColor = (pct: number) => {
        if (pct >= 150) return 'text-green-600 bg-green-50 border-green-200';
        if (pct >= 100) return 'text-blue-600 bg-blue-50 border-blue-200';
        if (pct >= 70) return 'text-orange-600 bg-orange-50 border-orange-200';
        return 'text-red-600 bg-red-50 border-red-200';
    };

    if (loading) return <div className="flex justify-center py-12"><i className="fa-solid fa-spinner fa-spin text-2xl text-gray-400"></i></div>;

    return (
        <div className="space-y-6">
            {/* Current Status Banner */}
            {summary && (
                <div className={`rounded-lg border-2 p-4 ${getTierColor(summary.current_tier_pct)}`}>
                    <div className="flex items-center justify-between">
                        <div>
                            <h3 className="font-bold text-lg">Doanh số tháng {month}/{year}</h3>
                            <p className="text-2xl font-bold mt-1">{formatMoney(summary.total_revenue)}</p>
                        </div>
                        <div className="text-right">
                            <p className="text-sm font-medium opacity-75">Mốc thưởng hiện tại</p>
                            <p className="text-3xl font-bold">{summary.current_tier_pct}%</p>
                            {summary.current_tier_pct === 0 && (
                                <p className="text-xs mt-1 font-medium">Chưa đạt mốc thưởng</p>
                            )}
                        </div>
                    </div>
                    {summary.next_tier_threshold && (
                        <div className="mt-3 pt-3 border-t border-current opacity-60">
                            <p className="text-sm">
                                Mốc tiếp theo: <strong>{formatMoney(summary.next_tier_threshold)}</strong> → <strong>{summary.next_tier_pct}%</strong>
                                {' '}(còn thiếu <strong>{formatMoney(summary.next_tier_threshold - summary.total_revenue)}</strong>)
                            </p>
                        </div>
                    )}
                </div>
            )}

            {/* Info */}
            <div className="bg-amber-50 border border-amber-200 rounded-lg p-3 text-sm text-amber-800">
                <i className="fa-solid fa-circle-info mr-2"></i>
                <strong>Thưởng Hoa Hồng Sản Xuất:</strong> Hệ số này nhân với tổng thưởng (CV chính + CV phụ) của nhân viên sản xuất.
                Doanh số tính theo tổng đơn hoàn thành toàn công ty (chưa VAT).
            </div>

            {/* Tier Configuration Table */}
            <div className="flex justify-between items-center">
                <h3 className="font-bold text-gray-700">Cấu hình mốc thưởng</h3>
                <button onClick={addTier} className="px-3 py-1.5 bg-green-600 text-white rounded hover:bg-green-700 text-sm font-medium">
                    <i className="fa-solid fa-plus mr-1"></i> Thêm mốc
                </button>
            </div>

            <div className="border rounded-lg overflow-hidden">
                <table className="w-full text-sm">
                    <thead className="bg-gray-100 border-b">
                        <tr>
                            <th className="px-4 py-3 text-right">Từ (Chưa VAT)</th>
                            <th className="px-2 py-3 text-center">→</th>
                            <th className="px-4 py-3 text-right">Đến (Chưa VAT)</th>
                            <th className="px-4 py-3 text-center">% Hoa hồng SX</th>
                            <th className="px-4 py-3 text-center w-16">Xóa</th>
                        </tr>
                    </thead>
                    <tbody className="divide-y">
                        {editTiers.map((tier, index) => (
                            <tr key={index} className="hover:bg-gray-50">
                                <td className="px-4 py-2">
                                    <input
                                        type="number"
                                        className="w-full border rounded px-2 py-1.5 text-right focus:ring-2 focus:ring-orange-500 outline-none"
                                        value={tier.threshold_min}
                                        onChange={e => updateTier(index, 'threshold_min', parseFloat(e.target.value) || 0)}
                                    />
                                </td>
                                <td className="px-2 py-2 text-center text-gray-400"><i className="fa-solid fa-arrow-right"></i></td>
                                <td className="px-4 py-2">
                                    <input
                                        type="number"
                                        className="w-full border rounded px-2 py-1.5 text-right focus:ring-2 focus:ring-orange-500 outline-none"
                                        placeholder="∞ (không giới hạn)"
                                        value={tier.threshold_max ?? ''}
                                        onChange={e => updateTier(index, 'threshold_max', e.target.value ? parseFloat(e.target.value) : null)}
                                    />
                                </td>
                                <td className="px-4 py-2">
                                    <div className="flex items-center justify-center gap-1">
                                        <input
                                            type="number" step="1"
                                            className="w-20 border rounded px-2 py-1.5 text-center font-bold text-orange-600 focus:ring-2 focus:ring-orange-500 outline-none"
                                            value={tier.rate}
                                            onChange={e => updateTier(index, 'rate', parseFloat(e.target.value) || 0)}
                                        />
                                        <span className="text-gray-500 font-bold">%</span>
                                    </div>
                                </td>
                                <td className="px-4 py-2 text-center">
                                    <button onClick={() => removeTier(index)} className="text-red-400 hover:text-red-600">
                                        <i className="fa-solid fa-trash"></i>
                                    </button>
                                </td>
                            </tr>
                        ))}
                        {editTiers.length === 0 && (
                            <tr>
                                <td colSpan={5} className="py-8 text-center text-gray-400 italic">Chưa có mốc thưởng nào. Nhấn "Thêm mốc" để bắt đầu.</td>
                            </tr>
                        )}
                    </tbody>
                </table>
            </div>

            {/* Note about below min threshold */}
            <p className="text-xs text-gray-500 italic">
                * Doanh số dưới mốc thấp nhất ({editTiers.length > 0 ? formatMoney(Math.min(...editTiers.map(t => t.threshold_min))) : '—'}) sẽ nhận 0% thưởng hoa hồng sản xuất.
            </p>

            {/* Save Button */}
            <div className="flex justify-end">
                <button
                    onClick={handleSave}
                    disabled={saving}
                    className="px-6 py-2 bg-orange-600 text-white rounded font-bold hover:bg-orange-700 shadow-sm disabled:bg-gray-400 flex items-center gap-2"
                >
                    {saving && <i className="fa-solid fa-spinner fa-spin"></i>}
                    Lưu Mốc Thưởng Sản Xuất
                </button>
            </div>
        </div>
    );
};

// Internal Component for Commission Config
const CommissionConfigModal: React.FC<{
    employee: Profile,
    onClose: () => void,
    onSave: (updatedEmp: Profile) => void,
    initialMonth?: number,
    initialYear?: number
}> = ({ employee, onClose, onSave, initialMonth, initialYear }) => {
    const [tiers, setTiers] = useState<{ min: number; max: number; rate: number; note?: string }[]>(
        employee.commission_tiers || []
    );
    const [viewMonth, setViewMonth] = useState(initialMonth || new Date().getMonth() + 1);
    const [viewYear, setViewYear] = useState(initialYear || new Date().getFullYear());
    const [loadingMonth, setLoadingMonth] = useState(false);

    const isProductionManager = employee.role === 'QuanLySanXuat';

    // Load tiers cho tháng được chọn
    const loadMonthTiers = async (month: number, year: number) => {
        setLoadingMonth(true);
        try {
            const { data } = await supabase
                .from('sales_targets')
                .select('commission_tiers')
                .eq('entity_type', 'user')
                .eq('entity_id', employee.id)
                .eq('period_month', month)
                .eq('period_year', year)
                .order('created_at', { ascending: false })
                .limit(1)
                .maybeSingle();

            if (data?.commission_tiers) {
                setTiers(data.commission_tiers);
            } else {
                // Fallback: dùng tiers từ profiles
                setTiers(employee.commission_tiers || []);
            }
        } catch {
            setTiers(employee.commission_tiers || []);
        }
        setLoadingMonth(false);
    };

    const handleMonthChange = (month: number) => {
        setViewMonth(month);
        loadMonthTiers(month, viewYear);
    };

    const handleYearChange = (year: number) => {
        setViewYear(year);
        loadMonthTiers(viewMonth, year);
    };

    const addTier = () => {
        setTiers(prev => [...prev, { min: 0, max: 0, rate: 0, note: '' }]);
    };

    const removeTier = (index: number) => {
        setTiers(prev => prev.filter((_, i) => i !== index));
    };

    const updateTier = (index: number, field: keyof typeof tiers[0], value: any) => {
        setTiers(prev => prev.map((t, i) => i === index ? { ...t, [field]: value } : t));
    };

    const handleSave = async () => {
        const sortedTiers = [...tiers].sort((a, b) => a.min - b.min);

        // Lưu trực tiếp vào sales_targets cho tháng đang xem
        // Delete then insert
        await supabase.from('sales_targets').delete()
            .eq('entity_type', 'user')
            .eq('entity_id', employee.id)
            .eq('period_month', viewMonth)
            .eq('period_year', viewYear);
        const { error } = await supabase.from('sales_targets').insert({
            entity_type: 'user',
            entity_id: employee.id,
            period_month: viewMonth,
            period_year: viewYear,
            target_amount: 0,
            commission_rate: 0,
            commission_tiers: sortedTiers
        });

        if (error) {
            alert('Lỗi lưu: ' + error.message);
            return;
        }

        alert(`Đã lưu cấu hình hoa hồng tháng ${viewMonth}/${viewYear} cho ${employee.full_name}`);

        // Nếu đang lưu cho tháng hiện tại của KPI Manager, cập nhật state cha
        if (viewMonth === initialMonth && viewYear === initialYear) {
            onSave({ ...employee, commission_tiers: sortedTiers });
        }
    };

    return (
        <div className="fixed inset-0 z-[60] flex items-center justify-center bg-black bg-opacity-40">
            <div className="bg-white rounded-lg w-full max-w-2xl shadow-xl animate-fade-in-up flex flex-col max-h-[80vh]">
                <div className="bg-indigo-600 text-white px-6 py-3 flex justify-between items-center rounded-t-lg">
                    <div>
                        <h3 className="text-lg font-bold">Cấu hình Hoa hồng: {employee.full_name}</h3>
                        {isProductionManager && <span className="text-xs bg-indigo-500 rounded px-2 py-0.5 text-indigo-100">Quản lý Sản xuất (Tính trên Tổng doanh thu)</span>}
                    </div>
                    <button onClick={onClose} className="hover:text-indigo-200"><i className="fa-solid fa-xmark"></i></button>
                </div>

                <div className="p-6 overflow-y-auto">
                    {/* Chọn tháng xem */}
                    <div className="flex items-center gap-3 mb-4 bg-gray-50 rounded-lg p-3 border">
                        <span className="text-sm text-gray-600 font-medium">Xem tháng:</span>
                        <div className="flex gap-1 flex-wrap">
                            {Array.from({ length: 12 }, (_, i) => i + 1).map(m => (
                                <button
                                    key={m}
                                    onClick={() => handleMonthChange(m)}
                                    className={`px-2.5 py-1 rounded text-xs font-medium transition-colors ${
                                        viewMonth === m
                                            ? 'bg-indigo-600 text-white shadow-sm'
                                            : 'bg-white text-gray-600 hover:bg-indigo-50 border'
                                    }`}
                                >
                                    T{m}
                                </button>
                            ))}
                        </div>
                        <select
                            value={viewYear}
                            onChange={e => handleYearChange(parseInt(e.target.value))}
                            className="text-sm border rounded px-2 py-1 font-bold text-gray-700 outline-none"
                        >
                            {[2024, 2025, 2026, 2027, 2028, 2029, 2030].map(y => (
                                <option key={y} value={y}>{y}</option>
                            ))}
                        </select>
                        {loadingMonth && <i className="fa-solid fa-spinner fa-spin text-indigo-500 text-sm"></i>}
                    </div>

                    <div className="flex justify-between items-center mb-4">
                        <p className="text-sm text-gray-500 italic">Nhập các mốc Doanh số (Chưa VAT) và % thưởng.</p>
                        <button onClick={addTier} className="px-3 py-1.5 bg-green-600 text-white rounded hover:bg-green-700 text-sm font-medium">
                            <i className="fa-solid fa-plus"></i> Thêm mốc
                        </button>
                    </div>

                    <div className="border rounded-lg overflow-hidden">
                        <table className="w-full text-sm">
                            <thead className="bg-gray-100 border-b">
                                <tr>
                                    <th className="px-3 py-2 text-right">Từ (Chưa VAT)</th>
                                    <th className="px-3 py-2 center">-</th>
                                    <th className="px-3 py-2 text-right">Đến (Chưa VAT)</th>
                                    <th className="px-3 py-2 text-center">% Hoa hồng</th>
                                    <th className="px-3 py-2 text-center">Xóa</th>
                                </tr>
                            </thead>
                            <tbody className="divide-y">
                                {tiers.map((tier, index) => (
                                    <tr key={index} className="hover:bg-gray-50">
                                        <td className="px-3 py-2">
                                            <input
                                                type="number"
                                                className="w-full border rounded px-2 py-1 text-right focus:ring-indigo-500 outline-none"
                                                value={tier.min}
                                                onChange={e => updateTier(index, 'min', parseFloat(e.target.value))}
                                            />
                                        </td>
                                        <td className="px-3 py-2 text-center text-gray-400"><i className="fa-solid fa-arrow-right"></i></td>
                                        <td className="px-3 py-2">
                                            <input
                                                type="number"
                                                className="w-full border rounded px-2 py-1 text-right focus:ring-indigo-500 outline-none"
                                                placeholder="∞"
                                                value={tier.max || ''}
                                                onChange={e => updateTier(index, 'max', e.target.value ? parseFloat(e.target.value) : 0)}
                                            />
                                        </td>
                                        <td className="px-3 py-2">
                                            <input
                                                type="number" step="0.1"
                                                className="w-full border rounded px-2 py-1 text-center font-bold text-indigo-600 focus:ring-indigo-500 outline-none"
                                                value={tier.rate}
                                                onChange={e => updateTier(index, 'rate', parseFloat(e.target.value))}
                                            />
                                        </td>
                                        <td className="px-3 py-2 text-center">
                                            <button onClick={() => removeTier(index)} className="text-red-400 hover:text-red-600">
                                                <i className="fa-solid fa-trash"></i>
                                            </button>
                                        </td>
                                    </tr>
                                ))}
                                {tiers.length === 0 && (
                                    <tr>
                                        <td colSpan={5} className="py-8 text-center text-gray-400 italic">Chưa có cấu hình nào.</td>
                                    </tr>
                                )}
                            </tbody>
                        </table>
                    </div>
                </div>

                <div className="p-4 bg-gray-50 flex justify-end gap-3 border-t rounded-b-lg">
                    <button onClick={onClose} className="px-4 py-2 text-gray-600 hover:bg-gray-200 rounded font-medium">Hủy</button>
                    <button onClick={handleSave} className="px-6 py-2 bg-indigo-600 text-white rounded font-bold hover:bg-indigo-700 shadow-sm">
                        Lưu Cấu Hình
                    </button>
                </div>
            </div>
        </div>
    );
};

export default KPIManager;
