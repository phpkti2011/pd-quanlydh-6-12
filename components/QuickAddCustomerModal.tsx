import React, { useState } from 'react';
import { customerService } from '../services/customerService';
import { supabase } from '../services/supabaseClient';
import { Customer } from '../types';

interface QuickAddCustomerModalProps {
    isOpen: boolean;
    onClose: () => void;
    onSuccess: (customer: Customer) => void;
    prefillName?: string;
}

const SOURCE_OPTIONS = [
    { value: 'VangLai', label: 'Vãng lai (Trực tiếp)' },
    { value: 'Facebook', label: 'Facebook' },
    { value: 'Zalo', label: 'Zalo' },
    { value: 'GioiThieu', label: 'Giới thiệu' },
    { value: 'Google', label: 'Google' },
    { value: 'Website', label: 'Website' },
    { value: 'Khac', label: 'Khác' },
];

const QuickAddCustomerModal: React.FC<QuickAddCustomerModalProps> = ({ isOpen, onClose, onSuccess, prefillName = '' }) => {
    const [formData, setFormData] = useState<Partial<Customer>>({
        name: prefillName,
        phone: '',
        address: '',
        source: ''
    });
    const [loading, setLoading] = useState(false);
    const [facebookConfirmed, setFacebookConfirmed] = useState(false);

    // Update name if prefill changes when opening
    React.useEffect(() => {
        if (isOpen) {
            setFormData(prev => ({ ...prev, name: prefillName || '' }));
            setFacebookConfirmed(false);
        }
    }, [isOpen, prefillName]);

    const isFacebook = formData.source === 'Facebook';

    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault();
        if (!formData.name) return alert("Vui lòng nhập tên khách hàng");
        if (!formData.phone) return alert("Vui lòng nhập số điện thoại");
        if (!formData.source) return alert("Vui lòng chọn nguồn khách hàng");

        // Nếu là Facebook mà chưa xác nhận
        if (isFacebook && !facebookConfirmed) return;

        setLoading(true);
        try {
            const newCustomer = await customerService.createCustomer(formData);

            // Ghi log khách hàng mới vào bảng facebook_customer_logs (cho tất cả nguồn)
            if (supabase) {
                const { data: { user } } = await supabase.auth.getUser();
                await supabase.from('quick_add_customer_logs').insert({
                    customer_id: newCustomer.id,
                    customer_name: newCustomer.name,
                    customer_phone: newCustomer.phone || '',
                    source: newCustomer.source || '',
                    created_by: user?.id || null,
                    facebook_confirmed: isFacebook ? true : null,
                });
            }

            onSuccess(newCustomer);
            onClose();
            // Reset form
            setFormData({ name: '', phone: '', address: '', source: '' });
            setFacebookConfirmed(false);
        } catch (error) {
            alert("Lỗi: " + (error as Error).message);
        } finally {
            setLoading(false);
        }
    };

    if (!isOpen) return null;

    return (
        <div className="fixed inset-0 bg-black bg-opacity-60 z-[60] flex items-center justify-center p-4">
            <div className="bg-white rounded-lg shadow-xl w-full max-w-md animate-fade-in-down">
                <div className="p-4 border-b border-gray-100 flex justify-between items-center">
                    <h3 className="font-bold text-[#4E342E] text-lg">Thêm Khách hàng Nhanh</h3>
                    <button onClick={onClose} className="text-gray-400 hover:text-gray-600"><i className="fa-solid fa-xmark"></i></button>
                </div>

                <form onSubmit={handleSubmit} className="p-5 space-y-4">
                    <div>
                        <label className="block text-sm font-bold text-gray-700 mb-1">Tên khách hàng <span className="text-red-500">*</span></label>
                        <input
                            type="text" className="w-full border rounded p-2 focus:ring-2 focus:ring-[#4E342E]"
                            value={formData.name} onChange={e => setFormData({ ...formData, name: e.target.value })}
                            autoFocus
                        />
                    </div>
                    <div>
                        <label className="block text-sm font-bold text-gray-700 mb-1">Số điện thoại <span className="text-red-500">*</span></label>
                        <input
                            type="text" className="w-full border rounded p-2 focus:ring-2 focus:ring-[#4E342E]"
                            value={formData.phone} onChange={e => setFormData({ ...formData, phone: e.target.value })}
                            placeholder="Bắt buộc nhập"
                        />
                    </div>
                    <div>
                        <label className="block text-sm font-bold text-gray-700 mb-1">Nguồn khách hàng <span className="text-red-500">*</span></label>
                        <select
                            className="w-full border rounded p-2 focus:ring-2 focus:ring-[#4E342E] bg-white"
                            value={formData.source || ''}
                            onChange={e => {
                                setFormData({ ...formData, source: e.target.value });
                                setFacebookConfirmed(false);
                            }}
                        >
                            <option value="">-- Chọn nguồn --</option>
                            {SOURCE_OPTIONS.map(opt => (
                                <option key={opt.value} value={opt.value}>{opt.label}</option>
                            ))}
                        </select>
                    </div>

                    {/* Cảnh báo Facebook - bắt buộc xác nhận */}
                    {isFacebook && (
                        <div className="bg-yellow-50 border border-yellow-300 rounded-lg p-3">
                            <div className="flex items-start gap-2">
                                <i className="fa-solid fa-triangle-exclamation text-yellow-600 mt-0.5"></i>
                                <div className="flex-1">
                                    <p className="text-sm font-bold text-yellow-800">Khách hàng từ Facebook</p>
                                    <p className="text-xs text-yellow-700 mt-1">
                                        Vui lòng tạo đơn hàng trên <strong>Pancake</strong> trước khi tạo đơn trên hệ thống.
                                        Thông tin này sẽ được ghi log để đối chiếu.
                                    </p>
                                    <label className="flex items-center gap-2 mt-2 cursor-pointer">
                                        <input
                                            type="checkbox"
                                            checked={facebookConfirmed}
                                            onChange={e => setFacebookConfirmed(e.target.checked)}
                                            className="w-4 h-4 rounded border-yellow-400 text-yellow-600 focus:ring-yellow-500"
                                        />
                                        <span className="text-xs font-medium text-yellow-800">
                                            Tôi xác nhận đã tạo đơn trên Pancake
                                        </span>
                                    </label>
                                </div>
                            </div>
                        </div>
                    )}

                    <div>
                        <label className="block text-sm font-bold text-gray-700 mb-1">Địa chỉ</label>
                        <input
                            type="text" className="w-full border rounded p-2 focus:ring-2 focus:ring-[#4E342E]"
                            value={formData.address} onChange={e => setFormData({ ...formData, address: e.target.value })}
                        />
                    </div>

                    <div className="flex justify-end gap-3 pt-2">
                        <button type="button" onClick={onClose} className="px-4 py-2 text-sm text-gray-600 hover:bg-gray-100 rounded">Hủy</button>
                        <button
                            type="submit"
                            disabled={loading || (isFacebook && !facebookConfirmed)}
                            className="px-4 py-2 text-sm bg-[#4E342E] text-white rounded font-bold hover:opacity-90 disabled:opacity-50 disabled:cursor-not-allowed"
                        >
                            {loading ? <i className="fa-solid fa-spinner fa-spin"></i> : 'Tạo khách hàng'}
                        </button>
                    </div>
                </form>
            </div>
        </div>
    );
};

export default QuickAddCustomerModal;
