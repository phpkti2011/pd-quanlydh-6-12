import React, { useState, useEffect } from 'react';
import { supabase } from '../services/supabaseClient';
import { Profile } from '../types';

interface Props {
    isOpen: boolean;
    onClose: () => void;
    userProfile: Profile | null;
    onProfileUpdate: () => void; // Trigger refresh in App
}

const AccountSettingsModal: React.FC<Props> = ({ isOpen, onClose, userProfile, onProfileUpdate }) => {
    const [activeTab, setActiveTab] = useState<'info' | 'password'>('info');
    const [loading, setLoading] = useState(false);

    // Profile State
    const [formData, setFormData] = useState({
        full_name: '',
        phone_number: '',
        position: '',
        avatar_url: '' // Not implemented yet but good to have
    });

    // Password State
    const [passData, setPassData] = useState({
        newPassword: '',
        confirmPassword: ''
    });

    useEffect(() => {
        if (isOpen && userProfile) {
            setFormData({
                full_name: userProfile.full_name || '',
                phone_number: userProfile.phone_number || '',
                position: userProfile.position || '', // New field
                avatar_url: ''
            });
            setPassData({ newPassword: '', confirmPassword: '' });
        }
    }, [isOpen, userProfile]);

    const handleSaveInfo = async () => {
        if (!userProfile) return;
        setLoading(true);
        try {
            const { error } = await supabase
                .from('profiles')
                .update({
                    full_name: formData.full_name,
                    phone_number: formData.phone_number,
                    position: formData.position
                })
                .eq('id', userProfile.id);

            if (error) throw error;

            alert('Cập nhật thông tin thành công!');
            onProfileUpdate();
            // Optional: onClose(); 
        } catch (err: any) {
            alert('Lỗi cập nhật: ' + err.message);
        } finally {
            setLoading(false);
        }
    };

    const handleChangePassword = async () => {
        if (passData.newPassword.length < 6) {
            alert('Mật khẩu mới phải có ít nhất 6 ký tự.');
            return;
        }
        if (passData.newPassword !== passData.confirmPassword) {
            alert('Mật khẩu xác nhận không khớp.');
            return;
        }

        setLoading(true);
        try {
            const { error } = await supabase.auth.updateUser({
                password: passData.newPassword
            });

            if (error) throw error;

            alert('Đổi mật khẩu thành công!');
            setPassData({ newPassword: '', confirmPassword: '' });
        } catch (err: any) {
            alert('Lỗi đổi mật khẩu: ' + err.message);
        } finally {
            setLoading(false);
        }
    };

    if (!isOpen) return null;

    return (
        <div className="fixed inset-0 z-[60] flex items-center justify-center bg-black bg-opacity-50">
            <div className="bg-white rounded-lg w-full max-w-lg shadow-xl animate-fade-in-up overflow-hidden flex flex-col">
                <div className="bg-teal-700 text-white px-6 py-4 flex justify-between items-center">
                    <h3 className="text-lg font-bold"><i className="fa-solid fa-user-gear mr-2"></i>Cài đặt tài khoản</h3>
                    <button onClick={onClose} className="hover:text-teal-200"><i className="fa-solid fa-xmark text-xl"></i></button>
                </div>

                {/* Tabs */}
                <div className="flex border-b border-gray-200 bg-gray-50">
                    <button
                        className={`flex-1 py-3 text-sm font-bold transition-colors ${activeTab === 'info' ? 'bg-white text-teal-700 border-t-2 border-teal-700' : 'text-gray-500 hover:text-gray-700'}`}
                        onClick={() => setActiveTab('info')}
                    >
                        <i className="fa-solid fa-id-card mr-2"></i>Thông tin cá nhân
                    </button>
                    <button
                        className={`flex-1 py-3 text-sm font-bold transition-colors ${activeTab === 'password' ? 'bg-white text-teal-700 border-t-2 border-teal-700' : 'text-gray-500 hover:text-gray-700'}`}
                        onClick={() => setActiveTab('password')}
                    >
                        <i className="fa-solid fa-key mr-2"></i>Đổi mật khẩu
                    </button>
                </div>

                <div className="p-6">
                    {activeTab === 'info' && (
                        <div className="flex flex-col gap-4">
                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-1">Họ và tên</label>
                                <input
                                    type="text"
                                    className="w-full border rounded px-3 py-2 outline-none focus:ring-2 focus:ring-teal-500"
                                    value={formData.full_name}
                                    onChange={e => setFormData({ ...formData, full_name: e.target.value })}
                                />
                            </div>
                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-1">Số điện thoại</label>
                                <input
                                    type="text"
                                    className="w-full border rounded px-3 py-2 outline-none focus:ring-2 focus:ring-teal-500"
                                    value={formData.phone_number}
                                    onChange={e => setFormData({ ...formData, phone_number: e.target.value })}
                                />
                            </div>
                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-1">Chức vụ / Vị trí</label>
                                <input
                                    type="text"
                                    className="w-full border rounded px-3 py-2 bg-gray-100 text-gray-600 outline-none cursor-not-allowed"
                                    value={formData.position}
                                    readOnly
                                    disabled
                                />
                                <p className="text-xs text-gray-500 mt-1">Thông tin này được quản lý bởi Quản trị viên.</p>
                            </div>

                            <button
                                onClick={handleSaveInfo}
                                disabled={loading}
                                className="mt-2 w-full bg-teal-600 text-white py-2 rounded font-bold hover:bg-teal-700 transition"
                            >
                                {loading ? <i className="fa-solid fa-spinner fa-spin"></i> : 'Lưu thông tin'}
                            </button>
                        </div>
                    )}

                    {activeTab === 'password' && (
                        <div className="flex flex-col gap-4">
                            <div className="bg-yellow-50 p-3 rounded text-xs text-yellow-800 border border-yellow-200 mb-2">
                                <i className="fa-solid fa-circle-info mr-1"></i>
                                Mật khẩu mới cần ít nhất 6 ký tự. Sau khi đổi, bạn có thể cần đăng nhập lại.
                            </div>
                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-1">Mật khẩu mới</label>
                                <input
                                    type="password"
                                    className="w-full border rounded px-3 py-2 outline-none focus:ring-2 focus:ring-teal-500"
                                    value={passData.newPassword}
                                    onChange={e => setPassData({ ...passData, newPassword: e.target.value })}
                                />
                            </div>
                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-1">Nhập lại mật khẩu</label>
                                <input
                                    type="password"
                                    className="w-full border rounded px-3 py-2 outline-none focus:ring-2 focus:ring-teal-500"
                                    value={passData.confirmPassword}
                                    onChange={e => setPassData({ ...passData, confirmPassword: e.target.value })}
                                />
                            </div>

                            <button
                                onClick={handleChangePassword}
                                disabled={loading}
                                className="mt-2 w-full bg-red-600 text-white py-2 rounded font-bold hover:bg-red-700 transition"
                            >
                                {loading ? <i className="fa-solid fa-spinner fa-spin"></i> : 'Xác nhận đổi mật khẩu'}
                            </button>
                        </div>
                    )}
                </div>
            </div>
        </div>
    );
};

export default AccountSettingsModal;
