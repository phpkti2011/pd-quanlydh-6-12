import React, { useState, useEffect } from 'react';
import { InvoiceProfile } from '../types';
import { customerService } from '../services/customerService';

interface InvoiceInfoModalProps {
    isOpen: boolean;
    onClose: () => void;
    onSave: (infoString: string) => void;
    initialInfo?: string;
    customerId?: string; // New Prop for fetching profiles
}

const InvoiceInfoModal: React.FC<InvoiceInfoModalProps> = ({ isOpen, onClose, onSave, initialInfo, customerId }) => {
    const [invoiceForm, setInvoiceForm] = useState({
        mst: '',
        companyName: '',
        address: '',
        email: '',
    });

    // Profiles State
    const [profiles, setProfiles] = useState<InvoiceProfile[]>([]);
    const [loadingProfiles, setLoadingProfiles] = useState(false);
    const [savingProfile, setSavingProfile] = useState(false);

    useEffect(() => {
        if (isOpen) {
            // 1. Parse Initial Info if exists
            if (initialInfo) {
                const lines = initialInfo.split('\n');
                const newForm = { mst: '', companyName: '', address: '', email: '' };

                lines.forEach(line => {
                    if (line.startsWith('MST: ')) newForm.mst = line.replace('MST: ', '');
                    else if (line.startsWith('Công ty: ')) newForm.companyName = line.replace('Công ty: ', '');
                    else if (line.startsWith('Địa chỉ: ')) newForm.address = line.replace('Địa chỉ: ', '');
                    else if (line.startsWith('Email: ')) newForm.email = line.replace('Email: ', '');
                });
                setInvoiceForm(newForm);
            } else {
                setInvoiceForm({ mst: '', companyName: '', address: '', email: '' });
            }

            // 2. Fetch Saved Profiles if Customer ID is present
            if (customerId) {
                fetchProfiles(customerId);
            }
        }
    }, [isOpen, initialInfo, customerId]);

    const fetchProfiles = async (custId: string) => {
        setLoadingProfiles(true);
        try {
            const data = await customerService.getInvoiceProfiles(custId);
            setProfiles(data);
        } catch (error) {
            console.error("Failed to load invoice profiles", error);
        } finally {
            setLoadingProfiles(false);
        }
    };

    const handleSaveProfile = async () => {
        if (!customerId) return;
        if (!invoiceForm.mst || !invoiceForm.companyName) {
            alert("Vui lòng nhập MST và Tên Công ty để lưu hồ sơ.");
            return;
        }

        setSavingProfile(true);
        try {
            await customerService.createInvoiceProfile({
                customer_id: customerId,
                company_name: invoiceForm.companyName,
                tax_code: invoiceForm.mst,
                address: invoiceForm.address,
                email: invoiceForm.email,
                is_default: profiles.length === 0 // Make default if it's the first one
            });
            // Refresh list
            await fetchProfiles(customerId);
            alert("Đã lưu thông tin xuất hóa đơn mới vào hồ sơ khách hàng.");
        } catch (error) {
            console.error(error);
            alert("Lỗi khi lưu hồ sơ.");
        } finally {
            setSavingProfile(false);
        }
    };

    const handleSelectProfile = (profile: InvoiceProfile) => {
        setInvoiceForm({
            mst: profile.tax_code,
            companyName: profile.company_name,
            address: profile.address || '',
            email: profile.email || '',
        });
    };

    const handleDeleteProfile = async (e: React.MouseEvent, id: string) => {
        e.stopPropagation();
        if (!confirm("Bạn có chắc muốn xóa hồ sơ xuất hóa đơn này?")) return;

        try {
            await customerService.deleteInvoiceProfile(id);
            if (customerId) fetchProfiles(customerId);
        } catch (err) {
            alert("Chưa xóa được");
        }
    }

    const handleSave = () => {
        const parts = [];
        if (invoiceForm.mst) parts.push(`MST: ${invoiceForm.mst}`);
        if (invoiceForm.companyName) parts.push(`Công ty: ${invoiceForm.companyName}`);
        if (invoiceForm.address) parts.push(`Địa chỉ: ${invoiceForm.address}`);
        if (invoiceForm.email) parts.push(`Email: ${invoiceForm.email}`);

        const infoString = parts.join('\n');
        onSave(infoString);
        onClose();
    };

    if (!isOpen) return null;

    return (
        <div className="fixed inset-0 bg-black bg-opacity-60 z-[70] flex items-center justify-center p-4 animate-fadeIn">
            <div className="bg-white rounded-lg shadow-xl w-full max-w-2xl overflow-hidden transform scale-100 transition-transform flex flex-col max-h-[90vh]">
                <div className="bg-blue-50 px-6 py-4 border-b border-blue-100 flex justify-between items-center shrink-0">
                    <h3 className="font-bold text-blue-800 text-lg"><i className="fa-solid fa-file-invoice mr-2"></i>Thông tin xuất Hóa đơn</h3>
                    <button onClick={onClose} className="text-gray-400 hover:text-red-500"><i className="fa-solid fa-xmark text-xl"></i></button>
                </div>

                <div className="p-6 overflow-y-auto flex-1">
                    <div className="grid grid-cols-1 lg:grid-cols-12 gap-6">
                        {/* LEFT: Profiles List */}
                        {customerId && (
                            <div className="lg:col-span-5 lg:border-r lg:pr-6 border-gray-200 space-y-3">
                                <h4 className="font-bold text-gray-700 text-sm mb-2 flex justify-between items-center">
                                    <span>Danh sách đã lưu</span>
                                    {loadingProfiles && <i className="fa-solid fa-spinner fa-spin text-gray-400"></i>}
                                </h4>

                                <div className="space-y-2 max-h-60 lg:max-h-full overflow-y-auto pr-1">
                                    {profiles.length === 0 ? (
                                        <div className="text-center py-6 text-gray-400 text-sm italic bg-gray-50 rounded-lg">
                                            Chưa có hồ sơ được lưu.<br />Nhập thông tin bên phải và nhấn "Lưu Mới".
                                        </div>
                                    ) : (
                                        profiles.map(p => (
                                            <div
                                                key={p.id}
                                                onClick={() => handleSelectProfile(p)}
                                                className={`p-3 rounded-lg border cursor-pointer transition-all hover:bg-blue-50 group relative ${invoiceForm.mst === p.tax_code ? 'bg-blue-50 border-blue-300 ring-1 ring-blue-300' : 'bg-white border-gray-200'}`}
                                            >
                                                <div className="font-bold text-sm text-gray-800 truncate" title={p.company_name}>{p.company_name}</div>
                                                <div className="text-xs text-gray-500 font-mono mt-1">MST: {p.tax_code}</div>
                                                <button
                                                    onClick={(e) => handleDeleteProfile(e, p.id)}
                                                    className="absolute top-2 right-2 text-gray-300 hover:text-red-500 opacity-0 group-hover:opacity-100 transition-opacity p-1"
                                                >
                                                    <i className="fa-solid fa-trash-can"></i>
                                                </button>
                                            </div>
                                        ))
                                    )}
                                </div>
                            </div>
                        )}

                        {/* RIGHT: Form */}
                        <div className={`${customerId ? 'lg:col-span-7' : 'col-span-12'} space-y-4`}>
                            <div className="flex justify-between items-center mb-2">
                                <label className="block text-sm font-semibold text-gray-700">Chi tiết Hóa đơn</label>
                                {customerId && (
                                    <button
                                        onClick={handleSaveProfile}
                                        disabled={savingProfile || !invoiceForm.mst}
                                        className="text-xs bg-green-50 text-green-700 hover:bg-green-100 px-2 py-1 rounded border border-green-200 transition-colors flex items-center gap-1 font-medium"
                                    >
                                        {savingProfile ? <i className="fa-solid fa-spinner fa-spin"></i> : <i className="fa-solid fa-save"></i>} Lưu Mới
                                    </button>
                                )}
                            </div>

                            <div>
                                <label className="block text-xs font-semibold text-gray-600 mb-1 uppercase">Mã số thuế</label>
                                <input type="text" className="w-full border border-gray-300 rounded px-3 py-2 text-sm focus:ring-2 focus:ring-blue-500 bg-gray-50 focus:bg-white transition-colors font-mono"
                                    value={invoiceForm.mst} onChange={e => setInvoiceForm({ ...invoiceForm, mst: e.target.value })} placeholder="Nhập MST..." />
                            </div>
                            <div>
                                <label className="block text-xs font-semibold text-gray-600 mb-1 uppercase">Tên Công ty</label>
                                <textarea rows={2} className="w-full border border-gray-300 rounded px-3 py-2 text-sm focus:ring-2 focus:ring-blue-500"
                                    value={invoiceForm.companyName} onChange={e => setInvoiceForm({ ...invoiceForm, companyName: e.target.value })} placeholder="Nhập tên công ty..." />
                            </div>
                            <div>
                                <label className="block text-xs font-semibold text-gray-600 mb-1 uppercase">Địa chỉ Công ty</label>
                                <textarea rows={2} className="w-full border border-gray-300 rounded px-3 py-2 text-sm focus:ring-2 focus:ring-blue-500"
                                    value={invoiceForm.address} onChange={e => setInvoiceForm({ ...invoiceForm, address: e.target.value })} placeholder="Nhập địa chỉ..." />
                            </div>
                            <div>
                                <label className="block text-xs font-semibold text-gray-600 mb-1 uppercase">Email nhận HĐ</label>
                                <input type="email" className="w-full border border-gray-300 rounded px-3 py-2 text-sm focus:ring-2 focus:ring-blue-500"
                                    value={invoiceForm.email} onChange={e => setInvoiceForm({ ...invoiceForm, email: e.target.value })} placeholder="Nhập email..." />
                            </div>
                        </div>
                    </div>

                </div>

                <div className="px-6 py-4 bg-gray-50 border-t border-gray-100 flex justify-end gap-3 shrink-0">
                    <button
                        onClick={onClose}
                        className="px-4 py-2 bg-white border border-gray-300 rounded text-gray-700 hover:bg-gray-100 font-medium text-sm transition-colors"
                    >
                        Hủy bỏ
                    </button>
                    <button
                        onClick={handleSave}
                        className="px-5 py-2 bg-blue-600 text-white rounded hover:bg-blue-700 font-bold text-sm shadow-md transition-colors flex items-center gap-2"
                    >
                        <i className="fa-solid fa-check"></i> Chọn & Đóng
                    </button>
                </div>
            </div>
        </div>
    );
};

export default InvoiceInfoModal;
