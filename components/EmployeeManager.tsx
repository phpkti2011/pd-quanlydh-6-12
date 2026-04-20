
import React, { useState, useEffect } from 'react';
import { supabase } from '../services/supabaseClient';
import { createClient } from '@supabase/supabase-js';
import { SUPABASE_URL, SUPABASE_ANON_KEY } from '../constants';
import { Profile, UserRole } from '../types';
import { COLORS } from '../constants';

interface EmployeeManagerProps {
    isOpen: boolean;
    onClose: () => void;
}


const ROLE_LABELS: Record<string, string> = {
    'Admin': 'Admin',
    'NhanVienKinhDoanh': 'Nhân viên Kinh doanh',
    'NhanVienSanXuat': 'Nhân viên Sản xuất (Chung)',
    'QuanLySanXuat': 'Quản lý Sản xuất',
    'KeToan': 'Kế toán',
    'Khach': 'Khách',
    'NhanVienThietKe': 'Nhân viên Thiết kế',
    'NhanVienBinhFile': 'Nhân viên Bình file',
};

const EmployeeManager: React.FC<EmployeeManagerProps> = ({ isOpen, onClose }) => {
    const [employees, setEmployees] = useState<Profile[]>([]);
    const [loading, setLoading] = useState(false);
    const [editingEmployee, setEditingEmployee] = useState<Profile | null>(null);

    const [showEditModal, setShowEditModal] = useState(false);
    const [showAddModal, setShowAddModal] = useState(false); // Add Modal State

    // Filter/Search (Simple)
    const [searchTerm, setSearchTerm] = useState('');

    useEffect(() => {
        if (isOpen) {
            fetchEmployees();
        }
    }, [isOpen]);

    const fetchEmployees = async () => {
        setLoading(true);
        const { data, error } = await supabase
            .from('profiles')
            .select('*')
            .is('deleted_at', null) // Soft delete filter
            .order('full_name', { ascending: true });

        if (error) {
            console.error('Error fetching employees:', error);
            alert('Lỗi tải danh sách nhân viên');
        } else {
            setEmployees(data || []);
        }
        setLoading(false);
    };

    const handleSave = async (formData: Partial<Profile>) => {
        if (!editingEmployee) return;

        const { error } = await supabase
            .from('profiles')
            .update({
                ...formData,
            })
            .eq('id', editingEmployee.id);

        if (error) {
            console.error('Error updating profile:', error);
            alert('Lỗi cập nhật: ' + error.message);
        } else {
            setShowEditModal(false);
            setEditingEmployee(null);
            fetchEmployees();
        }
    };

    const handleToggleLock = async (emp: Profile) => {
        const newStatus = !emp.is_locked;
        const action = newStatus ? "KHÓA" : "MỞ KHÓA";

        if (!window.confirm(`Bạn có chắc muốn ${action} tài khoản của "${emp.full_name}" không?\n(Tài khoản bị khóa sẽ không thể đăng nhập và thao tác hệ thống)`)) {
            return;
        }

        try {
            const { error } = await supabase.rpc('admin_toggle_lock_user', {
                target_user_id: emp.id,
                p_is_locked: newStatus
            });

            if (error) throw error;
            fetchEmployees();
        } catch (err: any) {
            alert(`Lỗi khi ${action}: ` + err.message);
        }
    };

    const handleDeleteUser = async (emp: Profile) => {
        if (!window.confirm(`CẢNH BÁO!\n\nBạn đang yêu cầu XÓA NV "${emp.full_name}".\n\nHành động này sẽ:\n- Vô hiệu hóa tài khoản (Soft Delete).\n- Tài khoản sẽ bị khóa và ẩn khỏi danh sách.\n- Lịch sử làm việc được GIỮ LẠI.\n\nBạn có chắc chắn không?`)) {
            return;
        }

        const confirmCode = Math.floor(1000 + Math.random() * 9000);
        const input = prompt(`Để xác nhận xóa, vui lòng nhập mã: ${confirmCode}`);

        if (input !== String(confirmCode)) {
            alert("Mã xác nhận không đúng. Hủy thao tác.");
            return;
        }

        try {
            const { error } = await supabase.rpc('admin_delete_user', {
                target_user_id: emp.id
            });

            if (error) throw error;
            alert(`Đã xóa thành công nhân viên "${emp.full_name}".`);
            fetchEmployees();
        } catch (err: any) {
            alert("Lỗi khi xóa tài khoản: " + err.message);
        }
    };

    const handleAddUser = async (formData: any) => {
        try {
            // 0. Pre-check: Does this email already exist in Profiles?
            const { data: existingUsers } = await supabase
                .from('profiles')
                .select('*')
                .eq('email', formData.email);

            const existingUser = existingUsers?.[0];

            if (existingUser) {
                if (existingUser.deleted_at || existingUser.is_locked) {
                    if (window.confirm(`Email "${formData.email}" đã tồn tại nhưng đang bị KHÓA/XÓA.\n\nBạn có muốn KHÔI PHỤC lại nhân viên "${existingUser.full_name}" không?`)) {
                        const { error: restoreError } = await supabase
                            .from('profiles')
                            .update({
                                deleted_at: null,
                                is_locked: false,
                                full_name: formData.full_name, // Update info
                                role: formData.role
                            })
                            .eq('id', existingUser.id);

                        if (restoreError) throw restoreError;
                        alert("Đã khôi phục nhân viên thành công!");
                        setShowAddModal(false);
                        fetchEmployees();
                        return;
                    }
                    return; // Cancelled restore
                } else {
                    alert("Nhân viên với email này đã tồn tại và đang hoạt động!");
                    return;
                }
            }

            // 1. Create temporary client to avoid logging out Admin
            const tempSupabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY, {
                auth: {
                    persistSession: false,
                    autoRefreshToken: false,
                    detectSessionInUrl: false
                }
            });

            // 2. Sign Up (Create Auth User)
            const { data: authData, error: authError } = await tempSupabase.auth.signUp({
                email: formData.email,
                password: formData.password,
                options: {
                    data: {
                        full_name: formData.full_name,
                        role: formData.role
                    }
                }
            });

            if (authError) {
                if (authError.message.includes("User already registered")) {
                    alert("Lỗi: Email này đã được đăng ký tài khoản (Auth) nhưng không tìm thấy Hồ sơ (Profile).\nVui lòng liên hệ kỹ thuật viên để xử lý tài khoản rác.");
                } else {
                    throw authError;
                }
                return;
            }

            if (authData.user) {
                // 3. Update Profile (using Admin client)

                // Allow a brief moment for trigger to fire
                await new Promise(r => setTimeout(r, 1500));

                const { error: profileError } = await supabase.from('profiles').update({
                    full_name: formData.full_name,
                    role: formData.role,
                    competency_score: formData.competency_score || 0,
                    commission_rate: formData.commission_rate || 0,
                    employee_code: formData.employee_code // Add employee code update
                }).eq('id', authData.user.id);

                if (profileError) {
                    console.warn("Profile update warning:", profileError);
                    alert("User created but profile sync warning: " + profileError.message);
                } else {
                    alert("Tạo nhân viên thành công!");
                }

                setShowAddModal(false);
                fetchEmployees();
            }

        } catch (err: any) {
            alert("Lỗi khi tạo nhân viên: " + err.message);
        }
    };

    const filteredEmployees = employees.filter(emp =>
        emp.full_name?.toLowerCase().includes(searchTerm.toLowerCase()) ||
        emp.employee_code?.toLowerCase().includes(searchTerm.toLowerCase())
    );

    if (!isOpen) return null;

    return (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-50">
            <div className="bg-white rounded-lg w-full max-w-6xl h-[90vh] flex flex-col shadow-2xl animate-fade-in-up">
                {/* Header */}
                <div className="px-6 py-4 border-b border-gray-200 flex justify-between items-center bg-gray-50">
                    <div>
                        <h2 className="text-xl font-bold text-gray-800">Quản lý Nhân Viên</h2>
                        <p className="text-sm text-gray-500">Danh sách và thông tin chi tiết nhân sự</p>
                    </div>
                    <button onClick={onClose} className="text-gray-400 hover:text-gray-600">
                        <i className="fa-solid fa-xmark text-2xl"></i>
                    </button>
                </div>

                {/* Toolbar */}
                <div className="px-6 py-3 border-b border-gray-100 flex gap-4 bg-white">
                    <div className="relative flex-1 max-w-md">
                        <i className="fa-solid fa-search absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
                        <input
                            type="text"
                            className="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none"
                            placeholder="Tìm theo tên, mã NV..."
                            value={searchTerm}
                            onChange={(e) => setSearchTerm(e.target.value)}
                        />
                    </div>
                    <button
                        className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 font-medium flex items-center gap-2"
                        onClick={() => setShowAddModal(true)}
                    >
                        <i className="fa-solid fa-plus"></i> Thêm NV
                    </button>
                </div>

                {/* Table */}
                <div className="flex-1 overflow-auto p-4 bg-gray-50">
                    <div className="bg-white rounded-lg shadow border border-gray-200 overflow-hidden">
                        <table className="w-full text-sm text-left">
                            <thead className="bg-[#f8f9fa] text-gray-700 font-semibold border-b border-gray-200">
                                <tr>
                                    <th className="px-4 py-3 w-20">Mã NV</th>
                                    <th className="px-4 py-3">Họ và tên</th>
                                    <th className="px-4 py-3">Vai trò</th>
                                    <th className="px-4 py-3 text-center">Điểm NL</th>
                                    <th className="px-4 py-3">Email</th>
                                    <th className="px-4 py-3 text-center">HH Công đoạn</th>
                                    <th className="px-4 py-3 text-right">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody className="divide-y divide-gray-100">
                                {loading ? (
                                    <tr><td colSpan={7} className="p-8 text-center text-gray-500">Đang tải...</td></tr>
                                ) : filteredEmployees.length === 0 ? (
                                    <tr><td colSpan={7} className="p-8 text-center text-gray-500">Không tìm thấy dữ liệu</td></tr>
                                ) : filteredEmployees.map(emp => (
                                    <tr key={emp.id} className="hover:bg-blue-50 transition-colors">
                                        <td className="px-4 py-3 font-medium text-gray-600">{emp.employee_code || '-'}</td>
                                        <td className="px-4 py-3 text-gray-800">
                                            <div className="font-bold">{emp.full_name}</div>
                                            {emp.is_locked && (
                                                <span className="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-red-100 text-red-800">
                                                    <i className="fa-solid fa-lock mr-1"></i> Đã khóa
                                                </span>
                                            )}
                                        </td>
                                        <td className="px-4 py-3 text-gray-600">{ROLE_LABELS[emp.role || ''] || emp.role}</td>
                                        <td className="px-4 py-3 text-center">
                                            <span className="px-2 py-1 bg-green-100 text-green-700 rounded-md font-bold">{emp.competency_score || 0}</span>
                                        </td>
                                        <td className="px-4 py-3 text-gray-600">{emp.email}</td>
                                        <td className="px-4 py-3 text-center text-gray-600">
                                            <span
                                                className="cursor-pointer text-blue-600 border-b border-dashed border-blue-400 hover:text-blue-800"
                                                onClick={() => { setEditingEmployee(emp); setShowEditModal(true); }}
                                            >
                                                Chi tiết
                                            </span>
                                        </td>
                                        <td className="px-4 py-3 text-right flex justify-end gap-2">
                                            {/* Lock Button */}
                                            <button
                                                onClick={() => handleToggleLock(emp)}
                                                className={`w-8 h-8 rounded-full border inline-flex items-center justify-center transition-colors ${emp.is_locked
                                                    ? 'bg-red-50 text-red-600 border-red-200 hover:bg-red-100'
                                                    : 'bg-gray-50 text-gray-500 border-gray-200 hover:bg-gray-100'
                                                    }`}
                                                title={emp.is_locked ? "Mở khóa tài khoản" : "Khóa tài khoản"}
                                            >
                                                <i className={`fa-solid ${emp.is_locked ? 'fa-lock' : 'fa-lock-open'}`}></i>
                                            </button>

                                            {/* Edit Button */}
                                            <button
                                                onClick={() => { setEditingEmployee(emp); setShowEditModal(true); }}
                                                className="w-8 h-8 rounded-full bg-blue-50 text-blue-600 border border-blue-200 hover:bg-blue-100 inline-flex items-center justify-center transition-colors"
                                                title="Chỉnh sửa"
                                            >
                                                <i className="fa-solid fa-pen"></i>
                                            </button>

                                            {/* Delete Button */}
                                            <button
                                                onClick={() => handleDeleteUser(emp)}
                                                className="w-8 h-8 rounded-full bg-red-50 text-red-600 border border-red-200 hover:bg-red-600 hover:text-white inline-flex items-center justify-center transition-colors"
                                                title="Xóa vĩnh viễn"
                                            >
                                                <i className="fa-solid fa-trash"></i>
                                            </button>
                                        </td>
                                    </tr>
                                ))}
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            {/* Edit Modal */}
            {showEditModal && editingEmployee && (
                <EditEmployeeModal
                    employee={editingEmployee}
                    onClose={() => setShowEditModal(false)}
                    onSave={handleSave}
                />
            )}

            {/* Add Modal */}
            {showAddModal && (
                <AddEmployeeModal
                    onClose={() => setShowAddModal(false)}
                    onSave={handleAddUser}
                />
            )}
        </div>
    );
};

const EditEmployeeModal: React.FC<{
    employee: Profile,
    onClose: () => void,
    onSave: (data: Partial<Profile>) => void
}> = ({ employee, onClose, onSave }) => {
    const [activeTab, setActiveTab] = useState<'general' | 'subtasks' | 'stages'>('general');
    const [formData, setFormData] = useState<Partial<Profile>>({
        employee_code: employee.employee_code || '',
        full_name: employee.full_name || '',
        role: employee.role || 'NhanVienSanXuat',
        position: employee.position || '',
        competency_score: employee.competency_score || 0,
        commission_rate: employee.commission_rate || 0,
        subtask_commission_policy: employee.subtask_commission_policy || 0,
        sales_commission_policy: employee.sales_commission_policy || 0,
        commission_subtasks: employee.commission_subtasks || {},
        commission_stages: employee.commission_stages || {},
        product_manager_commission_rate: employee.product_manager_commission_rate || 0,
    });

    const handleChange = (field: keyof Profile, value: any) => {
        setFormData(prev => ({ ...prev, [field]: value }));
    };

    const handleNestedChange = (parentField: 'commission_subtasks' | 'commission_stages', key: string, value: number) => {
        setFormData(prev => ({
            ...prev,
            [parentField]: {
                ...prev[parentField],
                [key]: value
            }
        }));
    };

    return (
        <div className="fixed inset-0 z-[60] flex items-center justify-center bg-black bg-opacity-50">
            <div className="bg-white rounded-lg w-full max-w-4xl shadow-xl animate-fade-in-up overflow-hidden flex flex-col max-h-[95vh]">
                <div className="bg-blue-600 text-white px-6 py-4 flex justify-between items-center flex-shrink-0">
                    <h3 className="text-lg font-bold">Chỉnh sửa nhân viên: {employee.full_name}</h3>
                    <button onClick={onClose} className="hover:text-blue-200"><i className="fa-solid fa-xmark text-xl"></i></button>
                </div>

                <div className="flex border-b border-gray-200 px-6 flex-shrink-0 bg-gray-50 flex-wrap">
                    <button
                        className={`px-4 py-3 font-medium text-sm transition-colors border-b-2 ${activeTab === 'general' ? 'border-blue-600 text-blue-600' : 'border-transparent text-gray-500 hover:text-gray-700'}`}
                        onClick={() => setActiveTab('general')}
                    >
                        Thông tin chung
                    </button>
                    <button
                        className={`px-4 py-3 font-medium text-sm transition-colors border-b-2 ${activeTab === 'subtasks' ? 'border-blue-600 text-blue-600' : 'border-transparent text-gray-500 hover:text-gray-700'}`}
                        onClick={() => setActiveTab('subtasks')}
                    >
                        Hoa hồng Công đoạn
                    </button>
                    <button
                        className={`px-4 py-3 font-medium text-sm transition-colors border-b-2 ${activeTab === 'stages' ? 'border-blue-600 text-blue-600' : 'border-transparent text-gray-500 hover:text-gray-700'}`}
                        onClick={() => setActiveTab('stages')}
                    >
                        Hoa hồng Quy trình
                    </button>
                </div>

                <div className="p-6 overflow-y-auto flex-1">
                    {activeTab === 'general' && (
                        <div className="grid grid-cols-2 gap-6">
                            <div className="col-span-1">
                                <label className="block text-sm font-medium text-gray-700 mb-1">Mã NV</label>
                                <input
                                    type="text"
                                    className="w-full border rounded px-3 py-2 bg-gray-50 focus:ring-2 focus:ring-blue-500 outline-none"
                                    value={formData.employee_code || ''}
                                    onChange={e => handleChange('employee_code', e.target.value)}
                                />
                            </div>
                            <div className="col-span-1">

                                <label className="block text-sm font-medium text-gray-700 mb-1">Họ và tên</label>
                                <input
                                    type="text"
                                    className="w-full border rounded px-3 py-2 bg-gray-50 focus:ring-2 focus:ring-blue-500 outline-none"
                                    value={formData.full_name || ''}
                                    onChange={e => handleChange('full_name', e.target.value)}
                                />
                            </div>

                            <div className="col-span-1">
                                <label className="block text-sm font-medium text-gray-700 mb-1">Email</label>
                                <input
                                    type="text"
                                    className="w-full border rounded px-3 py-2 bg-gray-100 text-gray-600 focus:outline-none cursor-not-allowed"
                                    value={employee.email || ''}
                                    readOnly
                                    disabled
                                />
                            </div>

                            <div className="col-span-1">
                                <label className="block text-sm font-medium text-gray-700 mb-1">Vai trò (Hệ thống)</label>
                                <select
                                    className="w-full border rounded px-3 py-2 focus:ring-2 focus:ring-blue-500 outline-none bg-white"
                                    value={formData.role}
                                    onChange={e => handleChange('role', e.target.value)}
                                >
                                    <option value="NhanVienKinhDoanh">Nhân viên Kinh doanh</option>
                                    <option value="NhanVienSanXuat">Nhân viên Sản xuất (Chung)</option>
                                    <option value="NhanVienThietKe">Nhân viên Thiết kế</option>
                                    <option value="NhanVienBinhFile">Nhân viên Bình file</option>
                                    <option value="QuanLySanXuat">Quản lý Sản xuất</option>
                                    <option value="KeToan">Kế toán</option>
                                    <option value="Admin">Admin</option>
                                </select>
                            </div>
                            <div className="col-span-1">
                                <label className="block text-sm font-medium text-gray-700 mb-1">Chức vụ / Vị trí</label>
                                <input
                                    type="text"
                                    className="w-full border rounded px-3 py-2 focus:ring-2 focus:ring-blue-500 outline-none"
                                    value={formData.position || ''}
                                    onChange={e => handleChange('position', e.target.value)}
                                    placeholder="VD: Trưởng phòng Marketing"
                                />
                            </div>

                            <div className="col-span-1">
                                <label className="block text-sm font-medium text-gray-700 mb-1">Điểm năng lực</label>
                                <input
                                    type="number" step="0.1"
                                    className="w-full border rounded px-3 py-2 focus:ring-2 focus:ring-blue-500 outline-none"
                                    value={formData.competency_score}
                                    onChange={e => handleChange('competency_score', parseFloat(e.target.value))}
                                />
                            </div>

                            <div className="col-span-1">
                                <label className="block text-sm font-medium text-gray-700 mb-1">Tỉ lệ lương cứng (%)</label>
                                <input
                                    type="number" step="0.1"
                                    className="w-full border rounded px-3 py-2 focus:ring-2 focus:ring-blue-500 outline-none"
                                    value={formData.commission_rate}
                                    onChange={e => handleChange('commission_rate', parseFloat(e.target.value))}
                                />
                            </div>
                            {/* Product Manager Commission Rate */}
                            {formData.role === 'QuanLySanXuat' && (
                                <div className="col-span-1">
                                    <label className="block text-sm font-medium text-purple-700 mb-1">
                                        <i className="fa-solid fa-percent mr-1"></i>
                                        Thưởng Doanh số Tổng (%)
                                    </label>
                                    <input
                                        type="number" step="0.1"
                                        className="w-full border border-purple-300 rounded px-3 py-2 focus:ring-2 focus:ring-purple-500 outline-none bg-purple-50 font-bold text-purple-700"
                                        value={formData.product_manager_commission_rate}
                                        onChange={e => handleChange('product_manager_commission_rate', parseFloat(e.target.value))}
                                        placeholder="VD: 1.0"
                                    />
                                    <p className="text-xs text-purple-600 mt-1">* Tính trên tổng doanh thu tháng (trước VAT)</p>
                                </div>
                            )}
                        </div>
                    )}

                    {activeTab === 'subtasks' && (
                        <div>
                            <p className="text-sm text-gray-500 mb-3 italic">Cấu hình % hoa hồng được hưởng khi thực hiện các công đoạn phụ (VD: Thiết kế, In bạt...)</p>
                            <table className="w-full text-sm border">
                                <thead className="bg-gray-100">
                                    <tr>
                                        <th className="px-3 py-2 text-left">Công đoạn</th>
                                        <th className="px-3 py-2 w-32">% Hoa hồng</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {[
                                        { key: 'ThietKe', label: 'Thiết Kế' },
                                        { key: 'InKhoLon', label: 'In Khổ Lớn' },
                                        { key: 'BeDemi', label: 'Bế Demi' },
                                        { key: 'GiaCongNgoai', label: 'Gia công ngoài' },
                                        { key: 'EpKim', label: 'Ép Kim' },
                                    ].map(item => (
                                        <tr key={item.key} className="border-t">
                                            <td className="px-3 py-2 font-medium">{item.label}</td>
                                            <td className="px-3 py-2">
                                                <input
                                                    type="number" step="0.1"
                                                    className="w-full border rounded px-2 py-1 text-center focus:ring-1 focus:ring-blue-500"
                                                    value={formData.commission_subtasks?.[item.key] || 0}
                                                    onChange={e => handleNestedChange('commission_subtasks', item.key, parseFloat(e.target.value))}
                                                />
                                            </td>
                                        </tr>
                                    ))}
                                </tbody>
                            </table>
                        </div>
                    )}

                    {activeTab === 'stages' && (
                        <div>
                            <p className="text-sm text-gray-500 mb-3 italic">Cấu hình % hoa hồng được hưởng khi tham gia vào quy trình xử lý đơn hàng.</p>
                            <table className="w-full text-sm border">
                                <thead className="bg-gray-100">
                                    <tr>
                                        <th className="px-3 py-2 text-left">Trạng thái / Khâu</th>
                                        <th className="px-3 py-2 w-32">% Hoa hồng</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {[
                                        { key: 'NhanFile', label: 'Nhận File' },
                                        { key: 'XuLyFile', label: 'Xử lý File' },
                                        { key: 'BinhFile', label: 'Bình File' },
                                        { key: 'In', label: 'In ấn' },
                                        { key: 'ThanhPham', label: 'Thành phẩm' },
                                        { key: 'DongGoi', label: 'Đóng gói' },
                                        { key: 'GiaoHang', label: 'Giao hàng' },
                                    ].map(item => (
                                        <tr key={item.key} className="border-t">
                                            <td className="px-3 py-2 font-medium">{item.label}</td>
                                            <td className="px-3 py-2">
                                                <input
                                                    type="number" step="0.1"
                                                    className="w-full border rounded px-2 py-1 text-center focus:ring-1 focus:ring-blue-500"
                                                    value={formData.commission_stages?.[item.key] || 0}
                                                    onChange={e => handleNestedChange('commission_stages', item.key, parseFloat(e.target.value))}
                                                />
                                            </td>
                                        </tr>
                                    ))}
                                </tbody>
                            </table>
                        </div>
                    )}
                </div>

                <div className="p-4 bg-gray-50 flex justify-end gap-3 border-t flex-shrink-0">
                    <button onClick={onClose} className="px-4 py-2 text-gray-600 hover:bg-gray-200 rounded font-medium">Hủy</button>
                    <button onClick={() => onSave(formData)} className="px-6 py-2 bg-blue-600 text-white rounded font-bold hover:bg-blue-700 shadow-sm">
                        Lưu thay đổi
                    </button>
                </div>
            </div>
        </div>
    );
};

const AddEmployeeModal: React.FC<{
    onClose: () => void;
    onSave: (data: any) => void;
}> = ({ onClose, onSave }) => {
    const [formData, setFormData] = useState({
        email: '',
        password: '',
        full_name: '',
        role: 'NhanVienSanXuat',
        competency_score: 0,
        commission_rate: 0,
        employee_code: '',
        product_manager_commission_rate: 0
    });

    const handleChange = (field: string, value: any) => {
        setFormData(prev => ({ ...prev, [field]: value }));
    };

    return (
        <div className="fixed inset-0 z-[60] flex items-center justify-center bg-black bg-opacity-50">
            <div className="bg-white rounded-lg w-full max-w-lg shadow-xl animate-fade-in-up overflow-hidden">
                <div className="bg-blue-600 text-white px-6 py-4 flex justify-between items-center">
                    <h3 className="text-lg font-bold">Thêm Nhân Viên Mới</h3>
                    <button onClick={onClose} className="hover:text-blue-200"><i className="fa-solid fa-xmark text-xl"></i></button>
                </div>

                <div className="p-6 grid grid-cols-1 gap-4">
                    <div>
                        <label className="block text-sm font-medium text-gray-700 mb-1">Mã Nhân Viên</label>
                        <input
                            type="text"
                            className="w-full border rounded px-3 py-2 focus:ring-2 focus:ring-blue-500 outline-none"
                            value={formData.employee_code}
                            onChange={e => handleChange('employee_code', e.target.value)}
                            placeholder="VD: NV001"
                        />
                    </div>
                    <div>
                        <label className="block text-sm font-medium text-gray-700 mb-1">Email (Tên đăng nhập)</label>
                        <input
                            type="email"
                            className="w-full border rounded px-3 py-2 focus:ring-2 focus:ring-blue-500 outline-none"
                            value={formData.email}
                            onChange={e => handleChange('email', e.target.value)}
                            placeholder="vd: ten.nv@example.com"
                        />
                    </div>
                    <div>
                        <label className="block text-sm font-medium text-gray-700 mb-1">Mật khẩu</label>
                        <input
                            type="password"
                            className="w-full border rounded px-3 py-2 focus:ring-2 focus:ring-blue-500 outline-none"
                            value={formData.password}
                            onChange={e => handleChange('password', e.target.value)}
                            placeholder="Mật khẩu ít nhất 6 ký tự"
                        />
                    </div>
                    <div>
                        <label className="block text-sm font-medium text-gray-700 mb-1">Họ và tên</label>
                        <input
                            type="text"
                            className="w-full border rounded px-3 py-2 focus:ring-2 focus:ring-blue-500 outline-none"
                            value={formData.full_name}
                            onChange={e => handleChange('full_name', e.target.value)}
                        />
                    </div>
                    <div>
                        <label className="block text-sm font-medium text-gray-700 mb-1">Vai trò</label>
                        <select
                            className="w-full border rounded px-3 py-2 focus:ring-2 focus:ring-blue-500 outline-none bg-white"
                            value={formData.role}
                            onChange={e => handleChange('role', e.target.value)}
                        >
                            <option value="NhanVienKinhDoanh">Nhân viên Kinh doanh</option>
                            <option value="NhanVienSanXuat">Nhân viên Sản xuất (Chung)</option>
                            <option value="NhanVienThietKe">Nhân viên Thiết kế</option>
                            <option value="NhanVienBinhFile">Nhân viên Bình file</option>
                            <option value="QuanLySanXuat">Quản lý Sản xuất</option>
                            <option value="KeToan">Kế toán</option>
                            <option value="Admin">Admin</option>
                        </select>
                    </div>
                    <div className="grid grid-cols-2 gap-4">
                        <div>
                            <label className="block text-sm font-medium text-gray-700 mb-1">Điểm năng lực</label>
                            <input
                                type="number" step="0.1"
                                className="w-full border rounded px-3 py-2 focus:ring-2 focus:ring-blue-500 outline-none"
                                value={formData.competency_score}
                                onChange={e => handleChange('competency_score', parseFloat(e.target.value))}
                            />
                        </div>
                        <div>
                            <label className="block text-sm font-medium text-gray-700 mb-1">Lương cứng (%)</label>
                            <input
                                type="number" step="0.1"
                                className="w-full border rounded px-3 py-2 focus:ring-2 focus:ring-blue-500 outline-none"
                                value={formData.commission_rate}
                                onChange={e => handleChange('commission_rate', parseFloat(e.target.value))}
                            />
                        </div>
                    </div>

                    {/* Product Manager Commission Rate for Add Modal */}
                    {formData.role === 'QuanLySanXuat' && (
                        <div>
                            <label className="block text-sm font-medium text-purple-700 mb-1">
                                <i className="fa-solid fa-percent mr-1"></i>
                                Thưởng Doanh số Tổng (%)
                            </label>
                            <input
                                type="number" step="0.1"
                                className="w-full border border-purple-300 rounded px-3 py-2 focus:ring-2 focus:ring-purple-500 outline-none bg-purple-50 font-bold text-purple-700"
                                value={(formData as any).product_manager_commission_rate || 0}
                                onChange={e => handleChange('product_manager_commission_rate', parseFloat(e.target.value))}
                                placeholder="VD: 1.0"
                            />
                            <p className="text-xs text-purple-600 mt-1">* Tính trên tổng doanh thu tháng (trước VAT)</p>
                        </div>
                    )}
                </div>

                <div className="p-4 bg-gray-50 flex justify-end gap-3 border-t">
                    <button onClick={onClose} className="px-4 py-2 text-gray-600 hover:bg-gray-200 rounded font-medium">Hủy</button>
                    <button onClick={() => onSave(formData)} className="px-6 py-2 bg-blue-600 text-white rounded font-bold hover:bg-blue-700 shadow-sm">
                        Tạo nhân viên
                    </button>
                </div>
            </div>
        </div>
    );
}

export default EmployeeManager;
