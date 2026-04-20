import React, { useState, useEffect } from 'react';
import { formatDateTime } from '../utils/dateFormatter';
import { Order } from '../types';
import { COLORS } from '../constants';
import CustomerSearch from './CustomerSearch';
import QuickAddCustomerModal from './QuickAddCustomerModal';
import InvoiceInfoModal from './InvoiceInfoModal';
import { AIOrderInputModal } from './AIOrderInputModal';

interface OrderModalProps {
  isOpen: boolean;
  onClose: () => void;
  onSubmit: (order: Partial<Order>) => void;
  initialData?: Order | null;
  userRole?: string;
}

const OrderModal: React.FC<OrderModalProps> = ({ isOpen, onClose, onSubmit, initialData, userRole }) => {
  const [formData, setFormData] = useState<Partial<Order>>({
    vat_rate: 0,
    total_amount_pre_vat: 0,
    is_urgent: false,
    payment_status: 'CongNo',
  });

  // State for Quick Add
  const [showQuickAdd, setShowQuickAdd] = useState(false);

  // State for Invoice Info Modal
  const [showInvoiceModal, setShowInvoiceModal] = useState(false);

  // State for AI Modal
  const [showAIModal, setShowAIModal] = useState(false);

  useEffect(() => {
    if (initialData) {
      // Handle AI Draft Data mappings
      const initProps = { ...initialData };
      if (!initProps.total_amount_pre_vat && initProps.total_amount) {
        initProps.total_amount_pre_vat = initProps.total_amount; // Assume pre-vat if not specified
      }
      setFormData(initProps);
    } else {
      // Reset form for new order
      setFormData({
        vat_rate: 0,
        total_amount_pre_vat: 0,
        is_urgent: false,
        payment_status: 'CongNo',
      });
    }
  }, [initialData, isOpen]);

  const handleChange = (field: keyof Order, value: any) => {
    setFormData(prev => {
      const updated = { ...prev, [field]: value };

      // Auto calc VAT
      if (field === 'total_amount_pre_vat' || field === 'vat_rate') {
        const amount = field === 'total_amount_pre_vat' ? Number(value) : Number(prev.total_amount_pre_vat || 0);
        const rate = field === 'vat_rate' ? Number(value) : (prev.vat_rate || 0);
        updated.vat_amount = amount * (rate / 100);
        updated.total_amount = amount + updated.vat_amount;

        // Trigger Invoice Modal if VAT > 0 and field is vat_rate
        if (field === 'vat_rate' && Number(value) > 0) {
          setShowInvoiceModal(true);
        }
      }
      return updated;
    });
  };

  const handleAIResult = (data: any) => {
    setFormData(prev => {
      const newData = { ...prev };

      if (data.description) newData.description = data.description;
      if (data.notes) newData.notes = prev.notes ? prev.notes + ' | ' + data.notes : data.notes;

      // Financials
      if (data.total_amount_number) {
        newData.total_amount_pre_vat = data.total_amount_number;
        // Recalculate total immediately if needed, mainly just setting pre_vat is enough for the effect to pick up? 
        // Actually the effect runs on handleChange, manual set might not trigger effect unless we call handleChange logic.
        // But here we are setting state directly. We should manually calc total.
        const rate = prev.vat_rate || 0;
        newData.vat_amount = data.total_amount_number * (rate / 100);
        newData.total_amount = data.total_amount_number + (newData.vat_amount || 0);
      }

      // Booleans
      if (data.has_be_demi) newData.has_be_demi = true;
      if (data.has_design) newData.has_design = true;
      if (data.has_large_print) newData.has_large_print = true;
      if (data.has_ep_kim) newData.has_ep_kim = true;
      if (data.has_gia_cong_ngoai) newData.has_gia_cong_ngoai = true;

      return newData;
    });

    if (data.customer_name || data.phone) {
      console.log("AI Detected Customer:", data);
    }
  };

  if (!isOpen) return null;
  // Defensive check to prevent crash during state transition
  if (!formData) return null;


  const safeDateValue = (dateStr?: string | Date | null) => {
    if (!dateStr) return '';
    try {
      const d = new Date(dateStr);
      const year = d.getFullYear();
      const month = String(d.getMonth() + 1).padStart(2, '0');
      const day = String(d.getDate()).padStart(2, '0');
      return `${year}-${month}-${day}`;
    } catch (e) {
      return '';
    }
  };

  const handleSave = () => {
    // 1. Validate Customer
    if (!formData.customer_id) {
      alert("Vui lòng chọn khách hàng từ danh sách! (Nếu là khách mới, hãy bấm 'Thêm KH')");
      return;
    }

    // 2. Validate Products
    if (!formData.description) {
      alert("Vui lòng nhập nội dung đơn hàng!");
      return;
    }

    // 3. Clean Data before Submit
    const payload = { ...formData };

    // Fix Dates: If empty string, set to null or undefined to avoid DB error
    if (payload.delivery_date === '') {
      payload.delivery_date = null as any;
    }

    onSubmit(payload);
  };

  return (
    <>
      <div className="fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center p-4 overflow-y-auto">
        <div className="bg-white rounded-xl shadow-2xl w-full max-w-4xl max-h-[90vh] overflow-y-auto transform transition-all scale-100">
          {/* Header */}
          <div className="flex justify-between items-center p-6 border-b border-gray-100 bg-gray-50 rounded-t-xl sticky top-0 z-10">
            <div>
              <h3 className="text-xl font-bold text-[#00796b] flex items-center gap-2">
                <i className={`fa-solid ${initialData ? 'fa-pen-to-square' : 'fa-plus-circle'}`}></i>
                {initialData ? `Đơn hàng ${initialData.order_code}` : 'Tạo Đơn Hàng Mới'}
              </h3>
              {initialData && initialData.created_at && <span className="text-sm text-gray-500">Ngày tạo: {formatDateTime(initialData.created_at)}</span>}
            </div>
            <button onClick={onClose} className="text-gray-400 hover:text-red-500 transition-colors w-8 h-8 flex items-center justify-center rounded-full hover:bg-gray-200">
              <i className="fa-solid fa-xmark text-xl"></i>
            </button>
          </div>

          <div className="p-6 grid grid-cols-1 lg:grid-cols-12 gap-6">
            {/* Customer Info - Full Width (Moved to Top) */}
            <div className="lg:col-span-12 bg-blue-50 p-4 rounded-lg border border-blue-100">
              <h4 className="font-bold text-blue-800 mb-3 flex items-center gap-2"><i className="fa-solid fa-user"></i> Khách hàng</h4>
              <div className="grid grid-cols-1 md:grid-cols-12 gap-4">
                <div className="md:col-span-9">
                  <label className="block text-sm font-semibold text-gray-700 mb-1">Tên Khách hàng <span className="text-red-500">*</span></label>
                  <div className="flex gap-2">
                    <div className="flex-1">
                      <CustomerSearch
                        initialValue={formData.customer?.name || formData.customer_name || ''}
                        onSelect={(c) => {
                          // CRM Logic: Block at Order #4 if urgent entry (missing phone)
                          if (c.is_urgent_entry && (c.order_count || 0) >= 3) {
                            alert(`KHÁCH HÀNG BỊ KHÓA QUYỀN TẠO ĐƠN!\nNguyên nhân: Đã nợ thông tin SĐT quá 3 đơn hàng.\nVui lòng vào Quản lý Khách hàng cập nhật SĐT cho "${c.name}" trước khi tạo đơn mới.`);
                            return;
                          }

                          // Check Refused Phone Risk
                          const isRefusedPhone = c.refused_provide_phone;

                          setFormData(prev => ({
                            ...prev,
                            customer_id: c.id,
                            customer: c,
                            // If refused phone, force Payment to NOT be CongNo if currently CongNo
                            payment_status: isRefusedPhone && prev.payment_status === 'CongNo' ? 'ChuaThanhToan' : prev.payment_status
                          }));

                          if (isRefusedPhone) {
                            alert("CẢNH BÁO: Khách hàng này từ chối cung cấp SĐT -> Được xếp loại Rủi Ro Cao.\nHệ thống sẽ khóa chức năng Công Nợ & COD.");
                          }
                        }}
                        onAddNew={() => setShowQuickAdd(true)}
                      />
                    </div>
                    <button
                      type="button"
                      onClick={() => setShowQuickAdd(true)}
                      className="px-3 py-2 bg-[#00796b] text-white rounded-md hover:bg-[#00695c] transition-colors font-medium text-sm flex items-center gap-1 whitespace-nowrap"
                      title="Thêm khách hàng mới"
                    >
                      <i className="fa-solid fa-user-plus"></i>
                      <span className="hidden sm:inline">Thêm KH</span>
                    </button>
                  </div>
                </div>
                <div className="md:col-span-3">
                  <label className="block text-sm font-semibold text-gray-700 mb-1">Số điện thoại</label>
                  <input
                    type="text" className="w-full border border-gray-300 rounded-md px-3 py-2 bg-gray-100" placeholder=""
                    value={formData.customer?.phone || ''}
                    disabled
                  />
                </div>
              </div>
            </div>

            {/* ... Content ... */}
            <div className="lg:col-span-7 space-y-6">


              {/* Product Specs */}
              <div>
                <h4 className="font-bold text-gray-700 mb-3 flex items-center gap-2"><i className="fa-solid fa-box-open"></i> Thông tin sản phẩm</h4>
                <div className="mb-4">
                  <div className="flex justify-between items-center mb-1">
                    <label className="block text-sm font-semibold text-gray-700">Nội dung / Quy cách <span className="text-red-500">*</span></label>
                    <button
                      onClick={() => setShowAIModal(true)}
                      className="text-xs font-bold text-purple-600 hover:text-purple-800 bg-purple-50 hover:bg-purple-100 px-2 py-1 rounded transition-colors flex items-center gap-1"
                    >
                      <i className="fa-solid fa-wand-magic-sparkles"></i> Nhập từ AI
                    </button>
                  </div>
                  <textarea
                    rows={12}
                    className="w-full border border-gray-300 rounded-md px-3 py-2 focus:ring-2 focus:ring-[#00796b] focus:border-transparent text-sm resize-none"
                    value={formData.description || ''}
                    onChange={(e) => handleChange('description', e.target.value)}
                    placeholder="- Loại giấy: ...&#10;- Kích thước: ...&#10;- Số lượng: ..."
                  ></textarea>
                </div>
                <div>
                  <label className="block text-sm font-semibold text-gray-700 mb-1">Ghi chú Đơn Hàng:</label>
                  <textarea
                    rows={2}
                    className="w-full border border-gray-300 rounded-md px-3 py-2 text-sm resize-none"
                    value={formData.notes || ''}
                    onChange={(e) => handleChange('notes', e.target.value)}
                    placeholder="Lưu ý đặc biệt cho thiết kế/in ấn..."
                  ></textarea>
                </div>
              </div>

              {/* Sub-tasks */}
              <div>
                <h4 className="font-bold text-gray-700 mb-3 flex items-center gap-2"><i className="fa-solid fa-list-check"></i> Công đoạn yêu cầu</h4>
                <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
                  {[
                    { key: 'isUrgent', label: 'CẦN GẤP', color: 'text-red-600 font-extrabold', icon: 'fa-fire' },
                    { key: 'has_design', label: 'Thiết kế', color: 'text-[#0288D1]', icon: 'fa-pen-nib', feeKey: 'design_fee' },
                    { key: 'has_large_print', label: 'In Khổ Lớn', color: 'text-[#6A1B9A]', icon: 'fa-print', feeKey: 'large_print_fee' },
                    { key: 'has_be_demi', label: 'Bế Demi', color: 'text-[#AD1457]', icon: 'fa-cut' },
                    { key: 'has_gia_cong_ngoai', label: 'Gia Công Ngoài', color: 'text-[#8D6E63]', icon: 'fa-industry' },
                    { key: 'has_ep_kim', label: 'Ép Kim', color: 'text-[#AF9500]', icon: 'fa-star' },
                  ].map((item) => {
                    const isChecked = item.key === 'isUrgent' ? !!formData.is_urgent : !!(formData as any)[item.key];
                    return (
                      <div key={item.key} className={`p-3 rounded-lg border transition-all ${isChecked ? 'bg-white border-[#00796b] shadow-sm' : 'bg-gray-50 border-gray-200 opacity-80'}`}>
                        <label className="flex items-center cursor-pointer mb-2">
                          <div className={`w-5 h-5 rounded border flex items-center justify-center mr-2 ${isChecked ? 'bg-[#00796b] border-[#00796b]' : 'bg-white border-gray-400'}`}>
                            {isChecked && <i className="fa-solid fa-check text-white text-xs"></i>}
                          </div>
                          <input
                            type="checkbox"
                            className="hidden"
                            checked={isChecked}
                            onChange={(e) => item.key === 'isUrgent' ? handleChange('is_urgent', e.target.checked) : handleChange(item.key as keyof Order, e.target.checked)}
                          />
                          <span className={`text-sm font-semibold ${item.color}`}><i className={`fa-solid ${item.icon} mr-1`}></i> {item.label}</span>
                        </label>

                        {/* Conditional Fee Input */}
                        {isChecked && (item.feeKey || item.key === 'has_gia_cong_ngoai') && (
                          <div className="ml-7 animate-fade-in-down space-y-2">
                            {item.feeKey && (
                              <div className="flex items-center border border-gray-300 rounded-md overflow-hidden bg-white">
                                <input
                                  type="number"
                                  className="w-full px-2 py-1 text-sm outline-none font-medium text-gray-700"
                                  placeholder="Nhập phí..."
                                  value={(formData as any)[item.feeKey] || ''}
                                  onChange={(e) => handleChange(item.feeKey as keyof Order, parseFloat(e.target.value) || 0)}
                                />
                                <span className="bg-gray-100 text-xs text-gray-500 px-2 py-1 border-l">đ</span>
                              </div>
                            )}

                            {/* Special Note for GC Ngoài */}
                            {item.key === 'has_gia_cong_ngoai' && (
                              <textarea
                                rows={2}
                                className="w-full px-2 py-1 text-xs border border-gray-300 rounded-md outline-none bg-yellow-50 focus:bg-white transition-colors resize-none"
                                placeholder="Ghi chú Gia Công Ngoài (nếu có)..."
                                value={formData.outsource_note || ''}
                                onChange={(e) => handleChange('outsource_note', e.target.value)}
                              ></textarea>
                            )}
                          </div>
                        )}
                      </div>
                    );
                  })}
                </div>
              </div>
            </div>

            {/* RIGHT COLUMN: Financials & Dates */}
            <div className="lg:col-span-5 space-y-6">
              {/* Dates */}
              <div className="bg-gray-50 p-4 rounded-lg border border-gray-200">
                <h4 className="font-bold text-gray-700 mb-3"><i className="fa-solid fa-calendar-days"></i> Thời gian</h4>
                <div className="space-y-3">
                  <div>
                    <label className="block text-xs font-bold text-gray-500 uppercase mb-1">Ngày giao hàng dự kiến</label>
                    <input
                      type="datetime-local"
                      className="w-full border border-gray-300 rounded-md px-3 py-2 font-medium"
                      value={formData.delivery_date ? new Date(new Date(formData.delivery_date).getTime() - (new Date(formData.delivery_date).getTimezoneOffset() * 60000)).toISOString().slice(0, 16) : ''}
                      onChange={(e) => handleChange('delivery_date', e.target.value)}
                    />
                  </div>
                </div>
              </div>

              {/* Payment */}
              <div className="bg-[#e0f2f1] p-5 rounded-lg border border-[#b2dfdb]">
                <h4 className="font-bold text-[#00695c] mb-4 text-lg border-b border-[#b2dfdb] pb-2 flex justify-between">
                  <span><i className="fa-solid fa-file-invoice-dollar"></i> Thanh toán</span>
                  <span className="text-sm bg-white px-2 py-0.5 rounded border text-gray-600 font-normal">Đơn vị: VNĐ</span>
                </h4>

                <div className="space-y-4">
                  <div className="flex justify-between items-center">
                    <label className="text-gray-700 font-medium">Thành tiền (Chưa VAT)</label>
                    <input
                      type="number"
                      className="w-32 text-right border border-gray-300 rounded px-2 py-1 focus:ring-2 focus:ring-[#00796b] font-bold"
                      value={formData.total_amount_pre_vat || 0}
                      onChange={(e) => handleChange('total_amount_pre_vat', e.target.value)}
                    />
                  </div>

                  <div className="flex justify-between items-center">
                    <label className="text-gray-700 font-medium flex items-center gap-1">VAT <i className="fa-solid fa-percent text-gray-400 text-xs"></i></label>
                    <div className="flex items-center gap-1">
                      <select
                        className="w-24 text-right border border-gray-300 rounded px-2 py-1"
                        value={formData.vat_rate || 0}
                        onChange={(e) => handleChange('vat_rate', e.target.value)}
                      >
                        <option value="0">0%</option>
                        <option value="8">8%</option>
                        <option value="10">10%</option>
                      </select>
                      {(formData.vat_rate || 0) > 0 && (
                        <button
                          onClick={() => setShowInvoiceModal(true)}
                          className="w-8 h-8 rounded border border-blue-200 text-blue-600 hover:bg-blue-50 flex items-center justify-center transition-colors"
                          title="Nhập thông tin xuất hóa đơn"
                        >
                          <i className="fa-solid fa-pen-to-square"></i>
                        </button>
                      )}
                    </div>
                  </div>
                  {/* VAT Amount Display */}
                  <div className="flex justify-between items-center text-sm text-gray-500 pt-1 border-t border-dashed border-gray-300">
                    <span>Tiền thuế VAT:</span>
                    <span>{(formData.vat_amount || 0).toLocaleString('vi-VN')}</span>
                  </div>

                  <div className="flex justify-between items-center pt-2 border-t border-gray-300">
                    <label className="text-[#d81b60] font-bold text-lg">TỔNG CỘNG</label>
                    <span className="text-[#d81b60] font-bold text-xl">{(formData.total_amount || 0).toLocaleString('vi-VN')}</span>
                  </div>

                  <div className="bg-white p-3 rounded border border-gray-200 mt-4 space-y-3">
                    <div>
                      <label className="block text-xs font-bold text-gray-500 uppercase mb-1">Trạng thái thanh toán</label>
                      <select
                        className={`w-full border rounded px-2 py-1.5 font-bold ${formData.payment_status === 'DaThanhToan' ? 'text-green-700 bg-green-50' :
                          formData.payment_status === 'CongNo' ? 'text-red-700 bg-red-50' : 'text-orange-700'
                          }`}
                        value={formData.payment_status}
                        onChange={(e) => handleChange('payment_status', e.target.value)}
                      >
                        <option value="CongNo" disabled={!!formData.customer?.refused_provide_phone}>
                          {formData.customer?.refused_provide_phone ? 'Công nợ (Bị khóa do thiếu SĐT)' : 'Công nợ'}
                        </option>
                        <option value="ChuaThanhToan">Chưa thanh toán</option>
                        <option value="DaCoc">Đã đặt cọc</option>
                        <option value="DaThanhToan">Đã thanh toán đủ</option>
                      </select>
                    </div>

                    {(formData.payment_status === 'DaCoc' || formData.payment_status === 'CongNo') && (
                      <div className="animate-fade-in-down">
                        <label className="block text-xs font-bold text-gray-500 uppercase mb-1">Số tiền đã cọc</label>
                        <input
                          type="number"
                          className="w-full border border-orange-300 rounded px-2 py-1.5 font-bold text-orange-700"
                          value={formData.deposit_amount || 0}
                          onChange={(e) => handleChange('deposit_amount', e.target.value)}
                        />
                        <div className="flex justify-between text-xs mt-2 text-gray-600">
                          <span>Còn lại:</span>
                          <span className="font-bold text-red-600">{((formData.total_amount || 0) - (formData.deposit_amount || 0)).toLocaleString('vi-VN')}</span>
                        </div>
                      </div>
                    )}
                  </div>
                </div>
              </div>
            </div>

          </div>

          <div className="flex justify-end gap-3 p-6 border-t border-gray-100 bg-gray-50 rounded-b-xl sticky bottom-0 z-20">
            <button onClick={onClose} className="px-5 py-2.5 bg-white border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-100 font-medium transition-all shadow-sm">
              <i className="fa-solid fa-xmark mr-2"></i>Hủy bỏ
            </button>
            <button
              onClick={handleSave}
              className="px-6 py-2.5 bg-[#00796b] text-white rounded-lg hover:bg-[#00695c] font-bold shadow-md hover:shadow-lg transition-all flex items-center"
            >
              <i className="fa-solid fa-save mr-2"></i> {initialData ? 'Cập Nhật Đơn Hàng' : 'Tạo Đơn Hàng'}
            </button>
          </div>
        </div>
      </div>

      {/* ... Quick Add Modal ... */}
      <QuickAddCustomerModal
        isOpen={showQuickAdd}
        onClose={() => setShowQuickAdd(false)}
        onSuccess={(c) => {
          setFormData(prev => ({ ...prev, customer_id: c.id, customer: c }));
        }}
      />

      {/* Invoice Info Modal */}
      <InvoiceInfoModal
        isOpen={showInvoiceModal}
        onClose={() => setShowInvoiceModal(false)}
        onSave={(infoString) => {
          setFormData(prev => ({ ...prev, invoice_info: infoString }));
          setShowInvoiceModal(false);
        }}
        initialInfo={formData.invoice_info || ''}
        customerId={formData.customer_id}
      />

      {/* AI Input Modal */}
      <AIOrderInputModal
        isOpen={showAIModal}
        onClose={() => setShowAIModal(false)}
        onSuccess={handleAIResult}
        userRole={userRole}
      />
    </>
  );
};

export default OrderModal;
