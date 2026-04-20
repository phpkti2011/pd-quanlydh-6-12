import React, { useState, useEffect } from 'react';
import { customerService } from '../../services/customerService';
import { Customer, CustomerAnalytics, CustomerLog } from '../../types';
import { CustomerKanban } from './CustomerKanban';
import { CustomerTimeline } from './CustomerTimeline';
import { CustomerInvoiceProfiles } from './CustomerInvoiceProfiles';

interface CustomerManagerProps {
    onClose: () => void;
}

const CustomerManager: React.FC<CustomerManagerProps> = ({ onClose }) => {
    const [customers, setCustomers] = useState<Customer[]>([]);
    const [selectedCustomer, setSelectedCustomer] = useState<Customer | null>(null);
    const [analytics, setAnalytics] = useState<CustomerAnalytics | null>(null);
    const [logs, setLogs] = useState<CustomerLog[]>([]);
    const [activeTab, setActiveTab] = useState<'info' | 'logs' | 'invoice'>('info');

    const [searchTerm, setSearchTerm] = useState('');
    const [loading, setLoading] = useState(false);
    const [isEditing, setIsEditing] = useState(false);

    const [isCreating, setIsCreating] = useState(false);
    const [viewMode, setViewMode] = useState<'list' | 'kanban'>('list'); // Phase 3

    // Form states
    const [newCustomer, setNewCustomer] = useState<Partial<Customer>>({
        name: '', phone: '', email: '', address: '', source: 'Facebook', crm_notes: '',
        is_urgent_entry: false, refused_provide_phone: false
    });
    const [newLogContent, setNewLogContent] = useState('');
    const [newLogType, setNewLogType] = useState('Note');
    const [tagInput, setTagInput] = useState('');

    useEffect(() => {
        loadCustomers();
    }, []);

    useEffect(() => {
        const delayDebounce = setTimeout(() => {
            loadCustomers(searchTerm);
        }, 500);
        return () => clearTimeout(delayDebounce);
    }, [searchTerm]);

    const loadCustomers = async (search: string = '') => {
        setLoading(true);
        try {
            const data = await customerService.getAllCustomers(search);
            setCustomers(data);
        } catch (error) {
            console.error("Failed to load customers", error);
        } finally {
            setLoading(false);
        }
    };

    const handleSelectCustomer = async (c: Customer) => {
        setSelectedCustomer(c);
        setIsEditing(false);
        setIsCreating(false);
        setAnalytics(null);
        setActiveTab('info');
        try {
            const stats = await customerService.getCustomerAnalytics(c.code);
            setAnalytics(stats);
            if (activeTab === 'logs') loadLogs(c.code);
        } catch (e) {
            console.error(e);
        }
    };

    const loadLogs = async (customerId: string) => {
        try {
            const data = await customerService.getCustomerLogs(customerId);
            setLogs(data);
        } catch (e) { console.error(e); }
    };

    useEffect(() => {
        if (selectedCustomer && activeTab === 'logs') {
            loadLogs(selectedCustomer.code);
        }
    }, [activeTab, selectedCustomer]);

    const handleSave = async (e: React.FormEvent) => {
        e.preventDefault();
        if (!selectedCustomer) return;
        try {
            await customerService.updateCustomer(selectedCustomer.code, selectedCustomer);
            alert("Cập nhật thành công!");
            setIsEditing(false);
            loadCustomers(searchTerm);
        } catch (e) {
            alert("Lỗi: " + (e as Error).message);
        }
    };

    const handleCreate = async (e: React.FormEvent) => {
        e.preventDefault();
        if (!newCustomer.name) {
            alert("Vui lòng nhập Tên khách hàng");
            return;
        }
        // Validation: Phone is mandatory unless flagged
        if (!newCustomer.phone && !newCustomer.is_urgent_entry && !newCustomer.refused_provide_phone) {
            alert("Vui lòng nhập Số điện thoại (hoặc chọn 'Gấp' / 'Khách từ chối')");
            return;
        }
        try {
            const created = await customerService.createCustomer(newCustomer);
            alert(`Đã tạo khách hàng mới: ${created.code}`);
            setIsCreating(false);
            setNewCustomer({
                name: '', phone: '', email: '', address: '', source: 'Facebook', crm_notes: '',
                is_urgent_entry: false, refused_provide_phone: false
            });
            loadCustomers();
            handleSelectCustomer(created);
        } catch (e) {
            alert("Lỗi tạo khách hàng: " + (e as Error).message);
        }
    };

    const handleAddLog = async () => {
        if (!selectedCustomer || !newLogContent) return;
        try {
            await customerService.addCustomerLog({
                customer_id: selectedCustomer.code,
                type: newLogType,
                content: newLogContent
            });
            setNewLogContent('');
            loadLogs(selectedCustomer.code);
        } catch (e) {
            alert("Lỗi thêm log: " + (e as Error).message);
        }
    };

    // Helper for Tier Badge
    const renderTierBadge = (tier?: string) => {
        let color = 'bg-gray-100 text-gray-800';
        if (tier === 'Bạc') color = 'bg-gray-200 text-gray-700 border-gray-400'; // Silver
        if (tier === 'Vàng') color = 'bg-yellow-100 text-yellow-800 border-yellow-300';
        if (tier === 'Bạch Kim') color = 'bg-purple-100 text-purple-800 border-purple-300';

        return <span className={`text-[10px] uppercase font-bold px-2 py-0.5 rounded border ${color}`}>{tier || 'Đồng'}</span>;
    };

    return (
        <div className="fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center p-4">
            <div className="bg-white rounded-xl shadow-2xl w-full max-w-6xl h-[85vh] flex overflow-hidden">

                {/* Left Sidebar: List / Kanban */}
                <div className={`${viewMode === 'kanban' ? 'w-full' : 'w-1/3'} border-r border-gray-200 flex flex-col bg-gray-50 transition-all duration-300`}>
                    <div className="p-4 border-b border-gray-200 bg-white">
                        <div className="flex justify-between items-center mb-3">
                            <h3 className="text-lg font-bold text-[#4E342E]">Quản lý Khách hàng</h3>
                            <div className="flex bg-gray-100 rounded-lg p-1">
                                <button onClick={() => setViewMode('list')} className={`px-2 py-1 rounded text-xs font-bold transition-all ${viewMode === 'list' ? 'bg-white shadow text-[#4E342E]' : 'text-gray-500'}`}><i className="fa-solid fa-list"></i></button>
                                <button onClick={() => setViewMode('kanban')} className={`px-2 py-1 rounded text-xs font-bold transition-all ${viewMode === 'kanban' ? 'bg-white shadow text-[#4E342E]' : 'text-gray-500'}`}><i className="fa-solid fa-columns"></i></button>
                            </div>
                        </div>
                        <div className="relative">
                            <i className="fa-solid fa-search absolute left-3 top-1/2 -translate-y-1/2 text-gray-400"></i>
                            <input
                                type="text"
                                placeholder="Tìm tên, SĐT, mã KH..."
                                className="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg text-sm focus:ring-2 focus:ring-[#4E342E] focus:outline-none"
                                value={searchTerm}
                                onChange={(e) => setSearchTerm(e.target.value)}
                            />
                        </div>
                    </div>
                    {viewMode === 'list' ? (
                        <div className="flex-1 overflow-y-auto p-2">
                            {loading ? (
                                <div className="text-center py-4"><i className="fa-solid fa-spinner fa-spin text-gray-400"></i></div>
                            ) : (
                                customers.map(c => (
                                    <div
                                        key={c.code}
                                        onClick={() => handleSelectCustomer(c)}
                                        className={`p-3 rounded-lg mb-2 cursor-pointer transition-colors border
                            ${selectedCustomer?.code === c.code ? 'bg-[#4E342E] text-white border-[#4E342E] shadow-md' : 'bg-white hover:bg-gray-100 border-gray-100'}`}
                                    >
                                        <div className="flex justify-between items-start">
                                            <div className="font-bold text-sm">{c.name}</div>
                                            {renderTierBadge(c.tier)}
                                        </div>
                                        <div className={`text-xs flex gap-2 mt-1 ${selectedCustomer?.code === c.code ? 'text-gray-300' : 'text-gray-500'}`}>
                                            <span>{c.code}</span>
                                            <span>•</span>
                                            <span>{c.phone}</span>
                                        </div>
                                        {c.is_urgent_entry && (
                                            <span className="mt-1 inline-block px-1.5 py-0.5 bg-red-100 text-red-600 rounded text-[10px] font-bold">GẤP</span>
                                        )}
                                        {c.tags && c.tags.length > 0 && (
                                            <div className="mt-1 flex gap-1 flex-wrap">
                                                {c.tags.map(t => (
                                                    <span key={t} className="text-[10px] bg-blue-100 text-blue-800 px-1 rounded">{t}</span>
                                                ))}
                                            </div>
                                        )}
                                    </div>
                                ))
                            )}
                            {customers.length === 0 && !loading && <div className="text-center py-4 text-gray-400 text-sm">Không tìm thấy kết quả</div>}
                        </div>
                    ) : (
                        <div className="flex-1 overflow-hidden relative bg-gray-100">
                            <CustomerKanban
                                customers={customers}
                                onUpdateCustomer={() => loadCustomers(searchTerm)}
                                onSelectCustomer={(c) => {
                                    handleSelectCustomer(c);
                                    setViewMode('list'); // Switch to list view to show details
                                }}
                            />
                        </div>
                    )}
                    <div className="p-3 border-t border-gray-200 bg-white">
                        <button
                            onClick={() => { setSelectedCustomer(null); setIsCreating(true); }}
                            className="w-full bg-[#4E342E] text-white py-2 rounded-lg text-sm hover:opacity-90 transition-colors font-bold shadow-sm"
                        >
                            <i className="fa-solid fa-user-plus mr-2"></i> Thêm Khách Hàng
                        </button>
                    </div>
                </div>

                {/* Right Content: Details */}
                {viewMode === 'list' && (
                    <div className="flex-1 flex flex-col overflow-y-auto relative bg-white">
                        {/* Main Modal Close Button - Always visible */}
                        <button
                            onClick={onClose}
                            className="absolute top-4 right-4 text-gray-400 hover:text-red-500 hover:bg-red-50 text-2xl z-50 w-10 h-10 flex items-center justify-center rounded-full transition-colors border-2 border-transparent hover:border-red-200"
                            title="Đóng Quản lý Khách hàng"
                        >
                            <i className="fa-solid fa-xmark"></i>
                        </button>

                        {isCreating ? (
                            <div className="p-8 max-w-2xl mx-auto w-full">
                                <h2 className="text-2xl font-bold text-[#4E342E] mb-6 flex items-center gap-2">
                                    <i className="fa-solid fa-user-plus"></i> Thêm Khách Hàng Mới
                                </h2>
                                <form onSubmit={handleCreate} className="space-y-4">
                                    <div className="grid grid-cols-2 gap-4">
                                        <div className="col-span-2">
                                            <label className="block text-sm font-bold text-gray-700 mb-1">Tên Khách Hàng <span className="text-red-500">*</span></label>
                                            <input type="text" className="w-full border p-2 rounded focus:ring-2 focus:ring-[#4E342E]" value={newCustomer.name} onChange={e => setNewCustomer({ ...newCustomer, name: e.target.value })} placeholder="VD: Nhà thuốc ABC" required />
                                        </div>
                                        <div className="flex flex-col">
                                            <label className="block text-sm font-bold text-gray-700 mb-1">Số điện thoại <span className={`text-red-500 ${newCustomer.is_urgent_entry || newCustomer.refused_provide_phone ? 'hidden' : ''}`}>*</span></label>
                                            <input
                                                type="text"
                                                className={`w-full border p-2 rounded focus:ring-2 focus:ring-[#4E342E] ${(newCustomer.refused_provide_phone) ? 'bg-gray-100' : ''}`}
                                                value={newCustomer.phone}
                                                onChange={e => setNewCustomer({ ...newCustomer, phone: e.target.value })}
                                                placeholder="0909..."
                                                disabled={newCustomer.refused_provide_phone}
                                                required={!newCustomer.is_urgent_entry && !newCustomer.refused_provide_phone}
                                            />
                                            <div className="flex items-center gap-4 mt-2">
                                                <label className="flex items-center gap-1.5 text-xs text-orange-600 cursor-pointer select-none">
                                                    <input
                                                        type="checkbox"
                                                        className="rounded text-orange-600 focus:ring-orange-600"
                                                        checked={newCustomer.is_urgent_entry || false}
                                                        onChange={e => {
                                                            const checked = e.target.checked;
                                                            setNewCustomer(prev => ({
                                                                ...prev,
                                                                is_urgent_entry: checked,
                                                                refused_provide_phone: checked ? false : prev.refused_provide_phone // mutually exclusive mostly
                                                            }));
                                                        }}
                                                    />
                                                    <span className="font-bold">Gấp - Bổ sung sau</span>
                                                </label>

                                                <label className="flex items-center gap-1.5 text-xs text-red-600 cursor-pointer select-none">
                                                    <input
                                                        type="checkbox"
                                                        className="rounded text-red-600 focus:ring-red-600"
                                                        checked={newCustomer.refused_provide_phone || false}
                                                        onChange={e => {
                                                            const checked = e.target.checked;
                                                            setNewCustomer(prev => ({
                                                                ...prev,
                                                                refused_provide_phone: checked,
                                                                is_urgent_entry: checked ? false : prev.is_urgent_entry, // mutually exclusive
                                                                phone: checked ? '' : prev.phone
                                                            }));
                                                        }}
                                                    />
                                                    <span className="font-bold">Khách từ chối cung cấp</span>
                                                </label>
                                            </div>
                                        </div>
                                        <div>
                                            <label className="block text-sm font-bold text-gray-700 mb-1">Email</label>
                                            <input type="email" className="w-full border p-2 rounded focus:ring-2 focus:ring-[#4E342E]" value={newCustomer.email} onChange={e => setNewCustomer({ ...newCustomer, email: e.target.value })} />
                                        </div>
                                        <div className="col-span-2">
                                            <label className="block text-sm font-bold text-gray-700 mb-1">Địa chỉ</label>
                                            <input type="text" className="w-full border p-2 rounded focus:ring-2 focus:ring-[#4E342E]" value={newCustomer.address} onChange={e => setNewCustomer({ ...newCustomer, address: e.target.value })} />
                                        </div>
                                        <div>
                                            <label className="block text-sm font-bold text-gray-700 mb-1">Nguồn khách</label>
                                            <select className="w-full border p-2 rounded focus:ring-2 focus:ring-[#4E342E]" value={newCustomer.source} onChange={e => setNewCustomer({ ...newCustomer, source: e.target.value })}>
                                                <option value="Facebook">Facebook</option>
                                                <option value="Zalo">Zalo</option>
                                                <option value="GioiThieu">Giới thiệu</option>
                                                <option value="VangLai">Vãng lai (Trực tiếp)</option>
                                                <option value="Khac">Khác</option>
                                            </select>
                                        </div>
                                        <div className="col-span-2">
                                            <label className="block text-sm font-bold text-gray-700 mb-1">Ghi chú (CRM)</label>
                                            <textarea className="w-full border p-2 rounded focus:ring-2 focus:ring-[#4E342E]" rows={3} value={newCustomer.crm_notes} onChange={e => setNewCustomer({ ...newCustomer, crm_notes: e.target.value })} placeholder="Thói quen mua hàng, người liên hệ chính..."></textarea>
                                        </div>
                                    </div>
                                    <div className="flex justify-end gap-3 pt-4 border-t mt-4">
                                        <button type="button" onClick={() => setIsCreating(false)} className="px-5 py-2 border rounded-lg hover:bg-gray-50 font-medium">Hủy bỏ</button>
                                        <button type="submit" className="px-6 py-2 bg-[#4E342E] text-white rounded-lg hover:opacity-90 font-bold shadow-md">Tạo mới</button>
                                    </div>
                                </form>
                            </div>
                        ) : selectedCustomer ? (
                            <div className="flex flex-col h-full">
                                {/* Header Detail */}
                                <div className="p-6 border-b border-gray-100 flex justify-between items-start bg-gray-50">
                                    <div>
                                        <div className="flex items-center gap-3">
                                            <h2 className="text-2xl font-bold text-gray-800">{selectedCustomer.name}</h2>
                                            {renderTierBadge(selectedCustomer.tier)}
                                        </div>
                                        <div className="text-sm text-gray-500 mt-1 flex gap-3">
                                            <span>Code: <span className="font-mono text-gray-700">{selectedCustomer.code}</span></span>
                                            <span>|</span>
                                            <span>Phone: <span className="font-mono text-gray-700">{selectedCustomer.phone}</span></span>
                                        </div>
                                        <div className="mt-2 flex gap-2">
                                            {(selectedCustomer.tags || []).map(tag => (
                                                <span key={tag} className="bg-blue-100 text-blue-700 px-2 py-0.5 rounded text-xs">{tag}</span>
                                            ))}
                                            <span onClick={() => {
                                                const newTag = prompt("Nhập thẻ mới (VD: VIP, Khó tính):");
                                                if (newTag) {
                                                    const updatedTags = [...(selectedCustomer.tags || []), newTag];
                                                    setSelectedCustomer({ ...selectedCustomer, tags: updatedTags });
                                                    customerService.updateCustomerTags(selectedCustomer.code, updatedTags);
                                                }
                                            }} className="text-gray-400 hover:text-gray-600 text-xs cursor-pointer border border-dashed border-gray-300 px-2 py-0.5 rounded">+ Thẻ</span>
                                        </div>
                                    </div>
                                    <div className="flex items-center gap-4 ml-4">
                                        {!isEditing && (
                                            <button onClick={() => setIsEditing(true)} className="text-white bg-[#4E342E] hover:bg-[#3E241E] px-4 py-2 rounded-lg border border-transparent transition-colors font-medium text-sm flex items-center gap-2 shadow-sm">
                                                <i className="fa-solid fa-pen"></i> Sửa
                                            </button>
                                        )}
                                        <button
                                            onClick={() => setSelectedCustomer(null)}
                                            className="text-gray-400 hover:text-gray-600 hover:bg-gray-100 transition-colors p-1.5 rounded-full text-sm"
                                            title="Quay lại danh sách"
                                        >
                                            <i className="fa-solid fa-arrow-left"></i>
                                        </button>
                                    </div>
                                </div>

                                {/* Tabs */}
                                <div className="flex border-b border-gray-200 px-6">
                                    <button
                                        onClick={() => setActiveTab('info')}
                                        className={`px-4 py-3 text-sm font-bold border-b-2 transition-colors ${activeTab === 'info' ? 'border-[#4E342E] text-[#4E342E]' : 'border-transparent text-gray-500 hover:text-gray-700'}`}
                                    >
                                        Thông tin chung
                                    </button>
                                    <button
                                        onClick={() => setActiveTab('logs')}
                                        className={`px-4 py-3 text-sm font-bold border-b-2 transition-colors ${activeTab === 'logs' ? 'border-[#4E342E] text-[#4E342E]' : 'border-transparent text-gray-500 hover:text-gray-700'}`}
                                    >
                                        Hồ sơ 360° (Timeline)
                                    </button>
                                    <button
                                        onClick={() => setActiveTab('invoice')}
                                        className={`px-4 py-3 text-sm font-bold border-b-2 transition-colors ${activeTab === 'invoice' ? 'border-[#4E342E] text-[#4E342E]' : 'border-transparent text-gray-500 hover:text-gray-700'}`}
                                    >
                                        Thông tin xuất HĐ
                                    </button>
                                </div>

                                {/* Tab Content */}
                                <div className="flex-1 overflow-y-auto p-6 bg-white">
                                    {activeTab === 'info' && (
                                        <>
                                            {isEditing ? (
                                                <form onSubmit={handleSave} className="grid grid-cols-2 gap-4 mb-8 bg-orange-50 p-6 rounded-xl border border-orange-100">
                                                    <div className="col-span-2 text-sm font-bold text-orange-800 mb-2 border-b border-orange-200 pb-1">Chỉnh sửa thông tin</div>
                                                    <div>
                                                        <label className="block text-xs font-bold text-gray-600 mb-1">Tên Khách Hàng</label>
                                                        <input type="text" className="w-full border p-2 rounded bg-white" value={selectedCustomer.name} onChange={e => setSelectedCustomer({ ...selectedCustomer, name: e.target.value })} />
                                                    </div>
                                                    <div>
                                                        <label className="block text-xs font-bold text-gray-600 mb-1">Số điện thoại</label>
                                                        <input type="text" className="w-full border p-2 rounded bg-white" value={selectedCustomer.phone} onChange={e => setSelectedCustomer({ ...selectedCustomer, phone: e.target.value })} />
                                                    </div>
                                                    <div>
                                                        <label className="block text-xs font-bold text-gray-600 mb-1">Email</label>
                                                        <input type="email" className="w-full border p-2 rounded bg-white" value={selectedCustomer.email || ''} onChange={e => setSelectedCustomer({ ...selectedCustomer, email: e.target.value })} />
                                                    </div>
                                                    <div>
                                                        <label className="block text-xs font-bold text-gray-600 mb-1">Địa chỉ</label>
                                                        <input type="text" className="w-full border p-2 rounded bg-white" value={selectedCustomer.address || ''} onChange={e => setSelectedCustomer({ ...selectedCustomer, address: e.target.value })} />
                                                    </div>
                                                    <div>
                                                        <label className="block text-xs font-bold text-gray-600 mb-1">Nguồn khách hàng</label>
                                                        <select className="w-full border p-2 rounded bg-white" value={selectedCustomer.source || 'Khac'} onChange={e => setSelectedCustomer({ ...selectedCustomer, source: e.target.value })}>
                                                            <option value="Facebook">Facebook</option>
                                                            <option value="Zalo">Zalo</option>
                                                            <option value="GioiThieu">Giới thiệu</option>
                                                            <option value="VangLai">Vãng lai (Trực tiếp)</option>
                                                            <option value="Khac">Khác</option>
                                                        </select>
                                                    </div>
                                                    <div className="col-span-2">
                                                        <label className="block text-xs font-bold text-gray-600 mb-1">Ghi chú CRM</label>
                                                        <textarea className="w-full border p-2 rounded bg-white" rows={3} value={selectedCustomer.crm_notes || ''} onChange={e => setSelectedCustomer({ ...selectedCustomer, crm_notes: e.target.value })}></textarea>
                                                    </div>
                                                    <div className="col-span-2 flex justify-end gap-2 pt-2">
                                                        <button type="button" onClick={() => setIsEditing(false)} className="px-4 py-2 border rounded bg-white hover:bg-gray-50">Hủy</button>
                                                        <button type="submit" className="px-4 py-2 bg-[#4E342E] text-white rounded hover:opacity-90">Lưu thay đổi</button>
                                                    </div>
                                                </form>
                                            ) : (
                                                <div className="grid grid-cols-2 gap-6 mb-8 bg-white rounded-xl">
                                                    <div>
                                                        <span className="block text-xs font-bold text-gray-500 uppercase flex items-center gap-1"><i className="fa-solid fa-phone text-gray-400"></i> Liên hệ</span>
                                                        <p className="text-gray-800 font-medium text-lg">{selectedCustomer.phone || '---'}</p>
                                                        <p className="text-gray-600 text-sm">{selectedCustomer.email}</p>
                                                    </div>
                                                    <div>
                                                        <span className="block text-xs font-bold text-gray-500 uppercase flex items-center gap-1"><i className="fa-solid fa-location-dot text-gray-400"></i> Địa chỉ</span>
                                                        <p className="text-gray-800">{selectedCustomer.address || '---'}</p>
                                                    </div>
                                                    <div>
                                                        <span className="block text-xs font-bold text-gray-500 uppercase flex items-center gap-1"><i className="fa-solid fa-earth-americas text-gray-400"></i> Nguồn</span>
                                                        <span className="bg-blue-100 text-blue-800 text-xs px-2 py-1 rounded-full font-bold">{selectedCustomer.source}</span>
                                                    </div>
                                                    <div className="col-span-2">
                                                        <span className="block text-xs font-bold text-gray-500 uppercase flex items-center gap-1"><i className="fa-solid fa-note-sticky text-gray-400"></i> Ghi chú</span>
                                                        <p className="text-gray-700 italic bg-gray-50 p-3 rounded border border-gray-100 mt-1">{selectedCustomer.crm_notes || "Không có ghi chú"}</p>
                                                    </div>
                                                </div>
                                            )}

                                            {/* Analytics Section */}
                                            <h3 className="text-lg font-bold text-gray-700 mb-4 border-b pb-2 flex items-center gap-2">
                                                <i className="fa-solid fa-chart-line text-[#00796b]"></i> Thống kê hoạt động
                                            </h3>
                                            {analytics ? (
                                                <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
                                                    <div className="bg-white border p-4 rounded-xl text-center shadow-sm hover:shadow-md transition-shadow cursor-default">
                                                        <div className="text-gray-500 text-xs uppercase font-bold mb-1">Tổng chi tiêu</div>
                                                        <div className="text-[#00796b] font-bold text-xl">{(analytics.totalRevenue).toLocaleString('vi-VN')}</div>
                                                    </div>
                                                    <div className="bg-white border p-4 rounded-xl text-center shadow-sm hover:shadow-md transition-shadow cursor-default">
                                                        <div className="text-gray-500 text-xs uppercase font-bold mb-1">Tổng đơn hàng</div>
                                                        <div className="text-gray-800 font-bold text-xl">{analytics.orderCount}</div>
                                                    </div>
                                                    <div className="bg-white border p-4 rounded-xl text-center shadow-sm hover:shadow-md transition-shadow cursor-default">
                                                        <div className="text-gray-500 text-xs uppercase font-bold mb-1">Đơn cuối</div>
                                                        <div className="text-gray-800 font-bold text-sm">{analytics.lastOrderDate}</div>
                                                    </div>
                                                </div>
                                            ) : (
                                                <div className="text-center py-8 text-gray-400">
                                                    <i className="fa-solid fa-spinner fa-spin text-2xl mb-2"></i>
                                                    <div>Đang tải dữ liệu thống kê...</div>
                                                </div>
                                            )}
                                        </>
                                    )}

                                    {activeTab === 'logs' && (
                                        <div className="h-full flex flex-col">
                                            {/* Add Log Form */}
                                            <div className="bg-gray-50 p-4 rounded-lg border border-gray-200 mb-6 flex-shrink-0">
                                                <h4 className="font-bold text-gray-700 mb-2">Ghi nhận tương tác mới</h4>
                                                <div className="flex gap-2 mb-2">
                                                    {['Call', 'Visit', 'Note', 'Complaint'].map(type => (
                                                        <button
                                                            key={type}
                                                            onClick={() => setNewLogType(type)}
                                                            className={`px-3 py-1 rounded text-xs font-bold border transition-colors ${newLogType === type ? 'bg-[#4E342E] text-white border-[#4E342E]' : 'bg-white text-gray-600 border-gray-300'}`}
                                                        >
                                                            {type}
                                                        </button>
                                                    ))}
                                                </div>
                                                <textarea
                                                    className="w-full border p-2 rounded text-sm focus:ring-2 focus:ring-[#4E342E]"
                                                    rows={3}
                                                    placeholder="Chi tiết nội dung..."
                                                    value={newLogContent}
                                                    onChange={e => setNewLogContent(e.target.value)}
                                                ></textarea>
                                                <div className="flex justify-end mt-2">
                                                    <button
                                                        onClick={handleAddLog}
                                                        className="px-4 py-2 bg-[#4E342E] text-white rounded text-sm font-bold shadow hover:opacity-90 disabled:opacity-50"
                                                        disabled={!newLogContent}
                                                    >
                                                        Lưu Hoạt Động
                                                    </button>
                                                </div>
                                            </div>

                                            {/* Timeline */}
                                            <div className="flex-1 min-h-0">
                                                <CustomerTimeline customer={selectedCustomer} onAddLog={() => { }} />
                                            </div>
                                        </div>
                                    )}

                                    {activeTab === 'invoice' && (
                                        <CustomerInvoiceProfiles customer={selectedCustomer} />
                                    )}
                                </div>

                            </div>
                        ) : (
                            <div className="flex-1 flex flex-col items-center justify-center text-gray-300">
                                <div className="bg-gray-50 p-8 rounded-full mb-4">
                                    <i className="fa-solid fa-users text-6xl text-gray-200"></i>
                                </div>
                                <p className="text-lg font-medium text-gray-400">Chọn khách hàng để xem chi tiết</p>
                                <p className="text-sm">Hoặc tạo khách hàng mới</p>
                            </div>
                        )}
                    </div>
                )}
            </div>
        </div>
    );
};

export default CustomerManager;
