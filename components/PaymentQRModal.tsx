import React, { useEffect, useState } from 'react';
import { Order } from '../types';
import { BankSettings, settingService, SETTING_KEYS } from '../services/settingService';
import { generateVietQRUrl, VIET_QR_BANKS } from '../utils/vietqr';
import { BankSettingsModal } from './BankSettingsModal';
import { orderService } from '../services/orderService';
import html2canvas from 'html2canvas';

interface PaymentQRModalProps {
    isOpen: boolean;
    onClose: () => void;
    order: Order;
}

type AccountType = 'nonVat' | 'vat';
type PaymentType = 'deposit' | 'remaining' | 'full';

export const PaymentQRModal: React.FC<PaymentQRModalProps> = ({ isOpen, onClose, order }) => {
    const [settings, setSettings] = useState<BankSettings | null>(null);
    const [loading, setLoading] = useState(false);
    const qrCardRef = React.useRef<HTMLDivElement>(null);

    // Form State
    const [accountType, setAccountType] = useState<AccountType>('nonVat');
    const [paymentType, setPaymentType] = useState<PaymentType>('deposit');
    const [customAmount, setCustomAmount] = useState<number>(0);
    const [showConfig, setShowConfig] = useState(false);

    // Random Code State (Persisted)
    const [randomCode, setRandomCode] = useState<string>('');
    const [isGenerating, setIsGenerating] = useState(false);

    useEffect(() => {
        if (isOpen) {
            loadSettings();
            // Default logic: Suggest VAT if vat_amount > 0
            if (order.vat_amount > 0) setAccountType('vat');
            else setAccountType('nonVat');

            // Load existing random code
            if (order.payment_random_code) setRandomCode(order.payment_random_code);
            else setRandomCode('');

            // Default amount logic
            if (order.payment_status === 'ChuaThanhToan') {
                setPaymentType('deposit');
                setCustomAmount(order.total_amount ? Math.round(order.total_amount / 2) : 0); // Suggest 50% deposit
            } else if (order.payment_status === 'DaCoc') {
                setPaymentType('remaining');
                setCustomAmount(order.remaining_amount || 0);
            } else {
                setPaymentType('full');
                setCustomAmount(order.total_amount || 0);
            }
        }
    }, [isOpen, order]);

    // Generate and Persist Random Code if missing (for Non-VAT)
    useEffect(() => {
        const ensureRandomCode = async () => {
            if (isOpen && accountType === 'nonVat' && !randomCode && !order.payment_random_code && !isGenerating) {
                setIsGenerating(true);
                const newCode = Math.random().toString(36).substring(2, 8).toUpperCase();
                try {
                    await orderService.updateOrder(order.id, { payment_random_code: newCode });
                    setRandomCode(newCode);
                } catch (err) {
                    console.error("Failed to save payment code", err);
                } finally {
                    setIsGenerating(false);
                }
            }
        };
        ensureRandomCode();
    }, [isOpen, accountType, randomCode, order.payment_random_code]);

    const loadSettings = async () => {
        setLoading(true);
        const data = await settingService.getSetting<BankSettings>(SETTING_KEYS.BANK_CONFIG);
        setSettings(data);
        setLoading(false);
    };

    // Calculate Amount based on Type
    useEffect(() => {
        if (paymentType === 'deposit') {
            // Always recalculate 50% when switching to 'deposit' mode to fix navigation bug
            setCustomAmount(order.total_amount ? Math.round(order.total_amount / 2) : 0);
        } else if (paymentType === 'remaining') {
            setCustomAmount(order.remaining_amount || (order.total_amount - (order.deposit_amount || 0)));
        } else if (paymentType === 'full') {
            setCustomAmount(order.total_amount || 0);
        }
    }, [paymentType, order]);


    if (!isOpen) return null;

    const currentBank = settings?.[accountType];
    const isConfigured = currentBank && currentBank.bankId && currentBank.accountNo;
    const bankDetails = isConfigured ? VIET_QR_BANKS.find(b => b.id === currentBank.bankId) : null;

    // QR Content Generation
    // VAT: Strict Order Code. Non-VAT: Random Code (Persisted).
    const qrContent = accountType === 'vat' ? `TT DH ${order.order_code}` : (randomCode || 'DANG TAO...');
    const qrUrl = isConfigured ? generateVietQRUrl({
        bankId: currentBank.bankId,
        accountNo: currentBank.accountNo,
        accountName: currentBank.accountName,
        amount: customAmount,
        description: qrContent,
        template: 'compact'
    }) : '';

    return (
        <>
            <div className="fixed inset-0 z-[60] flex items-center justify-center p-4 bg-black/60 backdrop-blur-sm">
                <div className="bg-white rounded-2xl shadow-2xl w-full max-w-md overflow-hidden flex flex-col max-h-[90vh]">

                    {/* Header */}
                    <div className="bg-gradient-to-r from-teal-600 to-teal-800 px-6 py-4 flex justify-between items-center text-white shrink-0">
                        <h3 className="font-bold text-lg flex items-center gap-2">
                            <i className="fa-solid fa-qrcode"></i>
                            Tạo Mã QR Thanh Toán
                        </h3>
                        <button onClick={onClose} className="text-white/80 hover:text-white transition-colors">
                            <i className="fa-solid fa-xmark text-xl"></i>
                        </button>
                    </div>

                    <div className="p-6 overflow-y-auto flex-1">
                        {loading ? (
                            <div className="flex justify-center py-10"><i className="fa-solid fa-spinner fa-spin text-teal-600 text-2xl"></i></div>
                        ) : !settings || (!settings.vat.accountNo && !settings.nonVat.accountNo) ? (
                            <div className="text-center py-8">
                                <div className="text-gray-400 text-5xl mb-4"><i className="fa-solid fa-豬bank"></i></div>
                                <p className="text-gray-600 mb-4">Chưa có cấu hình tài khoản ngân hàng.</p>
                                <button
                                    onClick={() => setShowConfig(true)}
                                    className="px-4 py-2 bg-teal-600 text-white rounded-lg hover:bg-teal-700"
                                >
                                    Cấu hình ngay
                                </button>
                            </div>
                        ) : (
                            <div className="space-y-5">
                                {/* Settings Row */}
                                <div className="flex justify-between items-center text-xs text-gray-500 border-b pb-2">
                                    <span>Đơn hàng: <b>{order.order_code}</b></span>
                                    <button onClick={() => setShowConfig(true)} className="text-teal-600 hover:underline flex items-center gap-1">
                                        <i className="fa-solid fa-gear"></i> Cấu hình TK
                                    </button>
                                </div>

                                {/* Account Selection */}
                                <div className="grid grid-cols-2 gap-2 p-1 bg-gray-100 rounded-lg">
                                    <button
                                        onClick={() => setAccountType('nonVat')}
                                        disabled={order.vat_amount > 0}
                                        style={order.vat_amount > 0 ? { display: 'none' } : {}}
                                        className={`py-2 px-3 text-sm font-medium rounded-md transition-all ${accountType === 'nonVat'
                                            ? 'bg-white text-teal-700 shadow-sm col-span-2'
                                            : 'text-gray-500 hover:text-gray-700'
                                            }`}
                                    >
                                        Tài khoản thường
                                    </button>
                                    <button
                                        onClick={() => setAccountType('vat')}
                                        disabled={!order.vat_amount || order.vat_amount <= 0}
                                        style={!order.vat_amount || order.vat_amount <= 0 ? { display: 'none' } : {}}
                                        className={`py-2 px-3 text-sm font-medium rounded-md transition-all ${accountType === 'vat'
                                            ? 'bg-white text-teal-700 shadow-sm col-span-2'
                                            : 'text-gray-500 hover:text-gray-700'
                                            }`}
                                    >
                                        Tài khoản VAT {order.vat_amount > 0 && '(Bắt buộc)'}
                                    </button>
                                </div>

                                {!isConfigured ? (
                                    <div className="text-center p-4 bg-red-50 text-red-600 rounded-lg text-sm">
                                        Chưa cấu hình tài khoản {accountType === 'vat' ? 'VAT' : 'thường'}.
                                    </div>
                                ) : (
                                    <>
                                        {/* Payment Type */}
                                        <div>
                                            <div className="flex gap-2 mb-2">
                                                {[
                                                    { id: 'deposit', label: 'Đặt cọc' },
                                                    { id: 'remaining', label: 'Thanh toán còn lại' },
                                                    { id: 'full', label: 'Thanh toán đủ' }
                                                ].map(type => (
                                                    <button
                                                        key={type.id}
                                                        onClick={() => setPaymentType(type.id as PaymentType)}
                                                        className={`flex-1 py-1.5 text-xs font-bold border rounded-md transition-colors
                                                            ${paymentType === type.id
                                                                ? 'bg-teal-50 border-teal-500 text-teal-700'
                                                                : 'bg-white border-gray-200 text-gray-600 hover:bg-gray-50'}`}
                                                    >
                                                        {type.label}
                                                    </button>
                                                ))}
                                            </div>

                                            {/* Amount Input */}
                                            <div className="relative">
                                                <label className="absolute -top-2 left-2 bg-white px-1 text-xs font-bold text-gray-500">Số tiền chuyển khoản</label>
                                                <input
                                                    type="number"
                                                    value={customAmount}
                                                    onChange={(e) => setCustomAmount(Number(e.target.value))}
                                                    className="w-full p-3 pr-16 border-2 border-teal-100 rounded-xl text-xl font-bold text-teal-700 focus:border-teal-500 focus:outline-none text-right"
                                                />
                                                <span className="absolute right-4 top-1/2 -translate-y-1/2 text-gray-400 font-bold">VNĐ</span>
                                            </div>
                                            <div className="text-right text-xs text-gray-400 mt-1">
                                                {customAmount.toLocaleString('vi-VN')} đ
                                            </div>
                                        </div>

                                        {/* QR Display */}
                                        <div
                                            ref={qrCardRef as any}
                                            className="bg-white border border-gray-200 rounded-xl p-4 flex flex-col items-center shadow-inner group relative"
                                            style={{ backgroundColor: 'white' }}
                                        >
                                            {bankDetails && (
                                                <img
                                                    src={bankDetails.logo}
                                                    alt={bankDetails.name}
                                                    className="h-8 object-contain mb-2"
                                                    onError={(e) => e.currentTarget.style.display = 'none'}
                                                    crossOrigin="anonymous"
                                                />
                                            )}
                                            <div className="bg-white p-2 border rounded-lg shadow-sm relative group-hover:shadow-md transition-shadow">
                                                <img
                                                    src={qrUrl}
                                                    alt="QR Code"
                                                    className="w-48 h-48 object-contain"
                                                    id="qr-image"
                                                    crossOrigin="anonymous"
                                                />

                                                {/* Copy Overlay */}
                                                <button
                                                    data-html2canvas-ignore="true"
                                                    onClick={async () => {
                                                        if (!qrCardRef.current) return;
                                                        setLoading(true);
                                                        try {
                                                            const canvas = await html2canvas(qrCardRef.current, {
                                                                useCORS: true,
                                                                scale: 2,
                                                                backgroundColor: '#ffffff',
                                                                logging: false,
                                                                ignoreElements: (element) => element.hasAttribute('data-html2canvas-ignore')
                                                            });

                                                            canvas.toBlob(async (blob) => {
                                                                if (!blob) throw new Error("Canvas render failed");
                                                                await navigator.clipboard.write([
                                                                    new ClipboardItem({ 'image/png': blob })
                                                                ]);
                                                                alert('Đã copy ảnh QR ĐẦY ĐỦ (Logo + STK) vào bộ nhớ đệm!');
                                                            });
                                                        } catch (err) {
                                                            alert('Lỗi khi copy ảnh: ' + (err as any).message);
                                                            console.error(err);
                                                        } finally {
                                                            setLoading(false);
                                                        }
                                                    }}
                                                    className="absolute inset-0 bg-black/40 opacity-0 group-hover:opacity-100 flex items-center justify-center text-white font-bold rounded-lg transition-opacity"
                                                    title="Bấm để Copy toàn bộ thẻ (bao gồm Logo và STK)"
                                                >
                                                    {loading ? <i className="fa-solid fa-spinner fa-spin mr-2"></i> : <i className="fa-regular fa-copy mr-2"></i>}
                                                    Copy Ảnh Đầy Đủ
                                                </button>
                                            </div>
                                            <div className="mt-3 text-center">
                                                <div className="font-bold text-gray-800">{currentBank!.accountName}</div>
                                                <div className="text-sm text-gray-600 font-mono tracking-wider">{currentBank!.accountNo}</div>
                                                <div className="text-xs text-gray-400 mt-1">Nội dung: <span className="font-bold text-black">{qrContent}</span></div>
                                            </div>
                                        </div>
                                    </>
                                )}
                            </div>
                        )}
                    </div>

                    <div className="p-4 border-t border-gray-100 bg-gray-50 flex justify-center shrink-0">
                        <button onClick={onClose} className="text-gray-500 hover:text-gray-800 font-medium">Đóng</button>
                    </div>
                </div>
            </div>

            {/* Config Modal */}
            <BankSettingsModal isOpen={showConfig} onClose={() => { setShowConfig(false); loadSettings(); }} />
        </>
    );
};
