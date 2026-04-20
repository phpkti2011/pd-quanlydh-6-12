import React, { useEffect, useState } from 'react';
import { BankSettings, settingService, SETTING_KEYS } from '../services/settingService';
import { VIET_QR_BANKS } from '../utils/vietqr';

interface BankSettingsModalProps {
    isOpen: boolean;
    onClose: () => void;
}

const DEFAULT_SETTINGS: BankSettings = {
    vat: { bankId: '', accountNo: '', accountName: '' },
    nonVat: { bankId: '', accountNo: '', accountName: '' }
};

export const BankSettingsModal: React.FC<BankSettingsModalProps> = ({ isOpen, onClose }) => {
    const [settings, setSettings] = useState<BankSettings>(DEFAULT_SETTINGS);
    const [loading, setLoading] = useState(false);
    const [saving, setSaving] = useState(false);

    useEffect(() => {
        if (isOpen) {
            loadSettings();
        }
    }, [isOpen]);

    const loadSettings = async () => {
        setLoading(true);
        try {
            const data = await settingService.getSetting<BankSettings>(SETTING_KEYS.BANK_CONFIG);
            if (data) {
                setSettings(data);
            }
        } catch (error) {
            console.error('Failed to load bank settings:', error);
        } finally {
            setLoading(false);
        }
    };

    const handleSave = async () => {
        setSaving(true);
        try {
            await settingService.saveSetting(SETTING_KEYS.BANK_CONFIG, settings);
            alert('Lưu cấu hình thành công!');
            onClose();
        } catch (error) {
            alert('Lỗi khi lưu cấu hình.');
        } finally {
            setSaving(false);
        }
    };

    const handleChange = (type: 'vat' | 'nonVat', field: keyof typeof settings.vat, value: string) => {
        setSettings(prev => ({
            ...prev,
            [type]: {
                ...prev[type],
                [field]: value
            }
        }));
    };

    if (!isOpen) return null;

    return (
        <div className="fixed inset-0 z-[70] flex items-center justify-center p-4 bg-black/50">
            <div className="bg-white rounded-xl shadow-xl w-full max-w-2xl overflow-hidden">
                <div className="bg-gray-50 px-6 py-4 border-b border-gray-100 flex justify-between items-center">
                    <h3 className="font-bold text-lg text-gray-800">
                        <i className="fa-solid fa-building-columns text-teal-600 mr-2"></i>
                        Cấu hình Tài khoản Ngân hàng
                    </h3>
                    <button onClick={onClose} className="text-gray-400 hover:text-gray-600">
                        <i className="fa-solid fa-xmark text-xl"></i>
                    </button>
                </div>

                <div className="p-6 max-h-[80vh] overflow-y-auto">
                    {loading ? (
                        <div className="text-center py-8 text-gray-500">Đang tải...</div>
                    ) : (
                        <div className="space-y-8">
                            {/* Non-VAT Account */}
                            <div className="space-y-4">
                                <h4 className="font-bold text-gray-700 border-b pb-2">
                                    1. Tài khoản thường (K.VAT)
                                    <span className="text-xs font-normal text-gray-500 ml-2">(Dùng cho khách lẻ, không lấy hóa đơn)</span>
                                </h4>
                                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                                    <div>
                                        <label className="block text-sm font-medium text-gray-700 mb-1">Ngân hàng</label>
                                        <select
                                            value={settings.nonVat.bankId}
                                            onChange={(e) => handleChange('nonVat', 'bankId', e.target.value)}
                                            className="w-full p-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-teal-500 focus:border-teal-500"
                                        >
                                            <option value="">-- Chọn ngân hàng --</option>
                                            {VIET_QR_BANKS.map(bank => (
                                                <option key={bank.id} value={bank.id}>{bank.name} ({bank.id})</option>
                                            ))}
                                        </select>
                                    </div>
                                    <div>
                                        <label className="block text-sm font-medium text-gray-700 mb-1">Số tài khoản</label>
                                        <input
                                            type="text"
                                            value={settings.nonVat.accountNo}
                                            onChange={(e) => handleChange('nonVat', 'accountNo', e.target.value)}
                                            className="w-full p-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-teal-500"
                                            placeholder="Nhập số tài khoản"
                                        />
                                    </div>
                                    <div className="md:col-span-2">
                                        <label className="block text-sm font-medium text-gray-700 mb-1">Tên chủ tài khoản</label>
                                        <input
                                            type="text"
                                            value={settings.nonVat.accountName}
                                            onChange={(e) => handleChange('nonVat', 'accountName', e.target.value.toUpperCase())}
                                            className="w-full p-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-teal-500"
                                            placeholder="NGUYEN VAN A"
                                        />
                                    </div>
                                </div>
                            </div>

                            {/* VAT Account */}
                            <div className="space-y-4">
                                <h4 className="font-bold text-gray-700 border-b pb-2">
                                    2. Tài khoản Công ty (VAT)
                                    <span className="text-xs font-normal text-gray-500 ml-2">(Dùng cho đơn hàng xuất hóa đơn)</span>
                                </h4>
                                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                                    <div>
                                        <label className="block text-sm font-medium text-gray-700 mb-1">Ngân hàng</label>
                                        <select
                                            value={settings.vat.bankId}
                                            onChange={(e) => handleChange('vat', 'bankId', e.target.value)}
                                            className="w-full p-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-teal-500 focus:border-teal-500"
                                        >
                                            <option value="">-- Chọn ngân hàng --</option>
                                            {VIET_QR_BANKS.map(bank => (
                                                <option key={bank.id} value={bank.id}>{bank.name} ({bank.id})</option>
                                            ))}
                                        </select>
                                    </div>
                                    <div>
                                        <label className="block text-sm font-medium text-gray-700 mb-1">Số tài khoản</label>
                                        <input
                                            type="text"
                                            value={settings.vat.accountNo}
                                            onChange={(e) => handleChange('vat', 'accountNo', e.target.value)}
                                            className="w-full p-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-teal-500"
                                            placeholder="Nhập số tài khoản"
                                        />
                                    </div>
                                    <div className="md:col-span-2">
                                        <label className="block text-sm font-medium text-gray-700 mb-1">Tên chủ tài khoản</label>
                                        <input
                                            type="text"
                                            value={settings.vat.accountName}
                                            onChange={(e) => handleChange('vat', 'accountName', e.target.value.toUpperCase())}
                                            className="w-full p-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-teal-500"
                                            placeholder="CONG TY TNHH..."
                                        />
                                    </div>
                                </div>
                            </div>
                        </div>
                    )}
                </div>

                <div className="bg-gray-50 px-6 py-4 border-t border-gray-100 flex justify-end gap-3">
                    <button
                        onClick={onClose}
                        className="px-4 py-2 bg-white text-gray-700 rounded-lg border border-gray-300 hover:bg-gray-50 font-medium"
                    >
                        Hủy
                    </button>
                    <button
                        onClick={handleSave}
                        disabled={saving}
                        className="px-4 py-2 bg-teal-600 text-white rounded-lg hover:bg-teal-700 font-medium disabled:opacity-50 flex items-center gap-2"
                    >
                        {saving ? <i className="fa-solid fa-spinner fa-spin"></i> : <i className="fa-solid fa-save"></i>}
                        Lưu cấu hình
                    </button>
                </div>
            </div>
        </div>
    );
};
