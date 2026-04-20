import React, { useState, useEffect } from 'react';
import { COLORS } from '../constants';
import { Order } from '../types';
import { orderService } from '../services/orderService';
import { supabase } from '../services/supabaseClient';
import { authService } from '../services/auth';

interface PaymentConfirmationModalProps {
    isOpen: boolean;
    order: Order;
    pendingStatus?: any; // The status intending to be set
    onClose: () => void;
    onSuccess: () => void;
}

const PaymentConfirmationModal: React.FC<PaymentConfirmationModalProps> = ({ isOpen, order, pendingStatus, onClose, onSuccess }) => {
    const [depositMethod, setDepositMethod] = useState('');
    const [remainingMethod, setRemainingMethod] = useState('');
    const [note, setNote] = useState('');
    const [depositAmount, setDepositAmount] = useState<number>(0);
    const [isSaving, setIsSaving] = useState(false);
    const [userRole, setUserRole] = useState<string>('');

    useEffect(() => {
        const fetchRole = async () => {
            try {
                const { data: { user } } = await supabase.auth.getUser();
                if (user) {
                    const profile = await authService.getUserProfile(user.id);
                    setUserRole(profile?.role || '');
                }
            } catch (error) {
                console.error("Error fetching role:", error);
            }
        };
        fetchRole();
    }, [isOpen]);

    useEffect(() => {
        if (isOpen && order) {
            setDepositMethod(order.payment_method_deposit || 'Chuyển khoản');
            setRemainingMethod(order.payment_method_remaining || 'Chuyển khoản');
            setNote(order.payment_note || '');
            setDepositAmount(order.deposit_amount || 0);
        }
    }, [isOpen, order]);

    if (!isOpen) return null;

    const handleConfirm = async () => {
        setIsSaving(true);
        try {
            const { data: { user } } = await supabase.auth.getUser();

            const remainingAmount = order.total_amount - depositAmount;
            const isAuthorized = userRole === 'Admin' || userRole === 'KeToan';

            await orderService.updateOrder(order.id, {
                payment_status: pendingStatus || order.payment_status, // Ensure status is updated if pending
                payment_confirmed: isAuthorized, // Only authorized users can confirm immediately
                payment_method_deposit: depositMethod,
                payment_method_remaining: remainingMethod,
                payment_note: note,
                payment_confirmed_by: user?.id,
                payment_confirmed_at: new Date().toISOString(),
                deposit_amount: depositAmount,
                remaining_amount: remainingAmount > 0 ? remainingAmount : 0
            });
            onSuccess();
            onClose();
        } catch (error) {
            alert('Lỗi xác nhận thanh toán: ' + (error as Error).message);
        } finally {
            setIsSaving(false);
        }
    };

    const effectiveStatus = pendingStatus || order.payment_status;
    const isDeposit = effectiveStatus === 'DaCoc';
    const isPaid = effectiveStatus === 'DaThanhToan';

    return (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-50">
            <div className="bg-white rounded-lg shadow-xl w-full max-w-md mx-4 animate-fade-in-up">
                <div className="px-4 py-3 border-b border-gray-100 flex justify-between items-center bg-gray-50">
                    <h3 className="font-bold text-gray-800">Xác nhận thanh toán</h3>
                    <button onClick={onClose} className="text-gray-400 hover:text-gray-600 transition-colors">
                        <i className="fa-solid fa-xmark text-lg"></i>
                    </button>
                </div>

                <div className="p-4 space-y-4">
                    {/* Deposit Method and Amount - Show if DaCoc or DaThanhToan */}
                    {(isDeposit || isPaid) && (
                        <div className="space-y-3">
                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-1">Hình thức ĐÃ CỌC</label>
                                <select
                                    className="w-full border border-gray-300 rounded px-2 py-1.5 focus:outline-none focus:ring-1 focus:ring-[#00796b]"
                                    value={depositMethod}
                                    onChange={(e) => setDepositMethod(e.target.value)}
                                >
                                    <option value="Chuyển khoản">Chuyển khoản</option>
                                    <option value="Tiền mặt">Tiền mặt</option>
                                </select>
                            </div>

                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-1">Số tiền đã cọc (VNĐ) <span className="text-red-500">*</span></label>
                                <input
                                    type="number"
                                    className="w-full border border-gray-300 rounded px-2 py-1.5 focus:outline-none focus:ring-1 focus:ring-[#00796b] font-mono font-bold text-gray-800"
                                    value={depositAmount}
                                    onChange={(e) => setDepositAmount(Number(e.target.value))}
                                    min={0}
                                />
                                <div className="text-sm font-bold text-gray-800 mt-2 text-right bg-blue-50 p-2 rounded border border-blue-100">
                                    Số tiền thanh toán đợt này (Còn lại): <span className="text-red-600 text-lg ml-1">{(order.total_amount - depositAmount).toLocaleString('vi-VN')} đ</span>
                                </div>
                            </div>
                        </div>
                    )}

                    {/* Remaining Method - Only if Paid */}
                    {isPaid && (
                        <div>
                            <label className="block text-sm font-medium text-gray-700 mb-1">Hình thức thanh toán CÒN LẠI</label>
                            <select
                                className="w-full border border-gray-300 rounded px-2 py-1.5 focus:outline-none focus:ring-1 focus:ring-[#00796b]"
                                value={remainingMethod}
                                onChange={(e) => setRemainingMethod(e.target.value)}
                            >
                                <option value="Chuyển khoản">Chuyển khoản</option>
                                <option value="Tiền mặt">Tiền mặt</option>
                            </select>
                        </div>
                    )}

                    <div>
                        <label className="block text-sm font-medium text-gray-700 mb-1">Ghi chú Thanh toán</label>
                        <textarea
                            className="w-full border border-gray-300 rounded px-2 py-1.5 focus:outline-none focus:ring-1 focus:ring-[#00796b] min-h-[80px]"
                            value={note}
                            onChange={(e) => setNote(e.target.value)}
                            placeholder="Ghi chú thêm về giao dịch..."
                        />
                    </div>
                </div>

                <div className="px-4 py-3 bg-gray-50 border-t border-gray-100 flex justify-end gap-2">
                    <button
                        onClick={onClose}
                        className="px-3 py-1.5 rounded text-gray-600 hover:bg-gray-200 transition-colors text-sm font-medium"
                        disabled={isSaving}
                    >
                        Hủy
                    </button>
                    <button
                        onClick={handleConfirm}
                        className={`px-3 py-1.5 rounded text-white shadow-sm hover:opacity-90 transition-opacity text-sm font-bold flex items-center gap-2`}
                        style={{ backgroundColor: (userRole === 'Admin' || userRole === 'KeToan') ? COLORS.success : '#f59e0b' }} // Green for Confirm, Orange for Pending
                        disabled={isSaving}
                    >
                        {isSaving && <i className="fa-solid fa-spinner fa-spin"></i>}
                        {(userRole === 'Admin' || userRole === 'KeToan') ? 'Xác nhận TT' : 'Lưu & Chờ duyệt'}
                    </button>
                </div>
            </div>
        </div>
    );
};

export default PaymentConfirmationModal;
