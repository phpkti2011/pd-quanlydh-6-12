import React, { useEffect, useState } from 'react';
import { trackingService, PublicOrderInfo } from '../services/trackingService';
import { STATUS_LABEL_MAP, COLORS } from '../constants';
import { PRINT_TERMS_INTRO, PRINT_TERMS_ARTICLES } from '../utils/printTerms';

interface TrackingPageProps {
    token: string;
}

const TrackingPage: React.FC<TrackingPageProps> = ({ token }) => {
    const [order, setOrder] = useState<PublicOrderInfo | null>(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState('');

    useEffect(() => {
        const fetchOrder = async () => {
            try {
                const data = await trackingService.getOrderInfo(token);
                if (data) {
                    setOrder(data);
                } else {
                    setError('Không tìm thấy đơn hàng hoặc liên kết không hợp lệ.');
                }
            } catch (err) {
                if (err instanceof Error) {
                    setError(err.message);
                } else {
                    setError('Có lỗi xảy ra khi tải thông tin.');
                }
                console.error(err);
            } finally {
                setLoading(false);
            }
        };
        fetchOrder();
    }, [token]);

    if (loading) {
        return (
            <div className="min-h-screen flex items-center justify-center bg-gray-50 text-gray-500">
                <i className="fa-solid fa-circle-notch fa-spin text-3xl text-teal-600"></i>
            </div>
        );
    }

    if (error || !order) {
        return (
            <div className="min-h-screen flex flex-col items-center justify-center bg-gray-50 p-4">
                <div className="bg-white p-8 rounded-lg shadow-md text-center max-w-md w-full">
                    <div className="text-red-500 text-5xl mb-4"><i className="fa-solid fa-circle-exclamation"></i></div>
                    <h2 className="text-xl font-bold text-gray-800 mb-2">Không tìm thấy đơn hàng</h2>
                    <p className="text-gray-600">{error}</p>
                </div>
            </div>
        );
    }

    const getStatusColor = (status: string) => {
        // Map status to a color class or hex
        if (status === 'HoanThanh' || status === 'DaGiaoHang') return 'bg-green-100 text-green-700 border-green-200';
        if (status === 'Huy') return 'bg-red-100 text-red-700 border-red-200';
        if (status === 'Pending' || status === 'Moi') return 'bg-blue-100 text-blue-700 border-blue-200';
        return 'bg-yellow-50 text-yellow-800 border-yellow-200';
    };

    // Helper to format date
    const formatDate = (dateStr: string | null) => {
        if (!dateStr) return 'Chưa xác định';
        return new Date(dateStr).toLocaleDateString('vi-VN');
    };

    return (
        <div className="min-h-screen bg-gray-100 font-sans text-sm md:text-base selection:bg-teal-100 pb-10">
            {/* Header */}
            <div className="bg-white shadow-sm border-b border-gray-200 sticky top-0 z-10">
                <div className="max-w-2xl mx-auto px-4 py-3 flex items-center justify-between">
                    <div className="flex items-center gap-2">
                        <div className="w-8 h-8 bg-teal-600 rounded flex items-center justify-center text-white font-bold text-lg">
                            P
                        </div>
                        <span className="font-bold text-gray-800 text-lg">P&D Printing</span>
                    </div>
                    <div className="text-xs text-gray-500 font-medium bg-gray-100 px-2 py-1 rounded">
                        Theo dõi đơn hàng
                    </div>
                </div>
            </div>

            <main className="max-w-2xl mx-auto px-4 py-6 space-y-4">

                {/* Status Card */}
                <div className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
                    <div className="p-5 border-b border-gray-100 bg-gray-50/50">
                        <div className="flex justify-between items-start mb-2">
                            <div>
                                <h1 className="text-xl font-bold text-gray-900">{order.order_code}</h1>
                                <p className="text-gray-500 text-sm mt-1">
                                    Ngày đặt: {formatDate(order.created_at)}
                                </p>
                            </div>
                            <span className={`px-3 py-1 rounded-full text-xs font-bold border ${getStatusColor(order.status)}`}>
                                {STATUS_LABEL_MAP[order.status] || order.status}
                            </span>
                        </div>

                        {/* Detailed Timeline */}
                        {/* Detailed Timeline - 8 Steps Granular */}
                        <div className="mt-8 mb-8 px-1 md:px-0">
                            <div className="w-full">
                                <div className="flex justify-between items-center relative">
                                    {/* Background Line */}
                                    <div className="absolute left-[6.25%] right-[6.25%] top-1/2 -translate-y-1/2 h-1.5 bg-gray-300 -z-10 rounded-full"></div>

                                    {/* Active Progress Line */}
                                    <div
                                        className="absolute left-[6.25%] top-1/2 -translate-y-1/2 h-1.5 bg-teal-500 -z-10 rounded-full transition-all duration-700 ease-out shadow-[0_0_8px_rgba(20,184,166,0.5)]"
                                        style={{
                                            width: ['Moi', 'TiepNhan', 'NhanFile'].includes(order.status) ? '0%' :
                                                ['XuLyFile'].includes(order.status) ? '12.5%' :
                                                    ['BinhFile'].includes(order.status) ? '25%' :
                                                        ['In'].includes(order.status) ? '37.5%' :
                                                            ['ThanhPham'].includes(order.status) ? '50%' :
                                                                ['DongGoi'].includes(order.status) ? '62.5%' :
                                                                    ['ChoGiaoHang', 'GiaoHang', 'DaGiaoHang'].includes(order.status) ? '75%' :
                                                                        ['HoanThanh'].includes(order.status) ? '87.5%' : '0%'
                                        }}
                                    ></div>

                                    {/* Steps */}
                                    {[
                                        { label: 'Tiếp nhận', icon: 'fa-file-invoice', activeState: ['Moi', 'TiepNhan', 'NhanFile'] },
                                        { label: 'Xử lý File', icon: 'fa-file-signature', activeState: ['XuLyFile'] },
                                        { label: 'Bình File', icon: 'fa-object-group', activeState: ['BinhFile'] },
                                        { label: 'In', icon: 'fa-print', activeState: ['In'] },
                                        { label: 'Thành phẩm', icon: 'fa-scissors', activeState: ['ThanhPham'] },
                                        { label: 'Đóng gói', icon: 'fa-box', activeState: ['DongGoi'] },
                                        { label: 'Giao hàng', icon: 'fa-truck-fast', activeState: ['ChoGiaoHang', 'GiaoHang', 'DaGiaoHang'] },
                                        { label: 'Hoàn thành', icon: 'fa-flag-checkered', activeState: ['HoanThanh'] }
                                    ].map((step, idx) => {
                                        // Determine status of this step
                                        const statusOrderHierarchy = [
                                            ['Moi', 'TiepNhan', 'NhanFile'],
                                            ['XuLyFile'],
                                            ['BinhFile'],
                                            ['In'],
                                            ['ThanhPham'],
                                            ['DongGoi'],
                                            ['ChoGiaoHang', 'GiaoHang', 'DaGiaoHang'],
                                            ['HoanThanh']
                                        ];

                                        const currentGroupIdx = statusOrderHierarchy.findIndex(group => group.includes(order.status));

                                        const isCompleted = currentGroupIdx > idx; // Past step
                                        const isCurrent = currentGroupIdx === idx; // Current active step

                                        return (
                                            <React.Fragment key={idx}>
                                                {/* Connection Arrow (Except before first) */}
                                                {idx > 0 && (
                                                    <div
                                                        className={`absolute top-1/2 -translate-y-1/2 -z-0 transition-colors duration-500 bg-white px-1
                                                        ${statusOrderHierarchy.findIndex(group => group.includes(order.status)) >= idx ? 'text-teal-500' : 'text-gray-300'}`}
                                                        style={{ left: `${idx * 12.5}%`, transform: 'translate(-50%, -50%)' }}
                                                    >
                                                        <i className="fa-solid fa-angles-right text-[10px] md:text-sm"></i>
                                                    </div>
                                                )}

                                                <div className="flex flex-col items-center gap-2 relative group" style={{ width: '12.5%' }}>

                                                    {/* Icon Circle */}
                                                    <div className={`w-8 h-8 md:w-10 md:h-10 rounded-full flex items-center justify-center text-xs md:text-base border-2 z-10 transition-all duration-300 transform 
                                                        ${isCompleted
                                                            ? 'bg-teal-500 border-teal-500 text-white shadow-teal-200 shadow-md'
                                                            : isCurrent
                                                                ? 'bg-white border-teal-500 text-teal-600 shadow-lg scale-110 ring-2 ring-teal-50'
                                                                : 'bg-white border-gray-300 text-gray-300'
                                                        }`}
                                                    >
                                                        {isCompleted ? <i className="fa-solid fa-check text-white"></i> : <i className={`fa-solid ${step.icon}`}></i>}
                                                    </div>

                                                    {/* Label */}
                                                    <span className={`text-[9px] md:text-[10px] font-semibold text-center transition-colors duration-300 absolute -bottom-8 w-16 leading-tight
                                                        ${isCurrent ? 'text-teal-700' : isCompleted ? 'text-teal-600' : 'text-gray-400'}`}>
                                                        {step.label}
                                                    </span>
                                                </div>
                                            </React.Fragment>
                                        );
                                    })}
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                {/* Details Card */}
                <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-5">
                    <h3 className="font-bold text-gray-800 mb-3 flex items-center gap-2">
                        <i className="fa-solid fa-box-open text-teal-600"></i> Thông tin chi tiết
                    </h3>

                    <div className="space-y-3 text-sm">
                        <div className="grid grid-cols-[120px_1fr] gap-2 py-1 border-b border-gray-50">
                            <span className="text-gray-500">Mã đơn hàng:</span>
                            <span className="font-bold text-gray-900">{order.order_code}</span>
                        </div>
                        <div className="grid grid-cols-[120px_1fr] gap-2 py-1 border-b border-gray-50">
                            <span className="text-gray-500">Khách hàng:</span>
                            <span className="font-medium text-gray-900">{order.customer_name || 'Khách lẻ'}</span>
                        </div>
                        <div className="grid grid-cols-[120px_1fr] gap-2 py-1 border-b border-gray-50">
                            <span className="text-gray-500">Ngày đặt hàng:</span>
                            <span className="font-medium text-gray-900">{formatDate(order.created_at)}</span>
                        </div>
                        <div className="grid grid-cols-[120px_1fr] gap-2 py-1 border-b border-gray-50">
                            <span className="text-gray-500">Ngày giao (DK):</span>
                            <span className="font-medium text-teal-700 font-bold">{formatDate(order.delivery_date)}</span>
                        </div>
                        <div className="grid grid-cols-[100px_1fr] gap-2">
                            <span className="text-gray-500">Quy cách:</span>
                            <div className="font-medium text-gray-900 whitespace-pre-line bg-gray-50 p-3 rounded-lg border border-gray-100">
                                {order.description || 'Chưa có thông tin'}
                            </div>
                        </div>
                    </div>
                </div>

                {/* Terms and Conditions (Using same text as Print) */}
                <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-5">
                    <h3 className="font-bold text-gray-800 mb-3 flex items-center gap-2">
                        <i className="fa-solid fa-file-contract text-gray-600"></i> Điều khoản in ấn
                    </h3>
                    <div className="text-xs text-gray-600 space-y-2 leading-relaxed text-justify bg-gray-50 p-3 rounded border border-gray-100">
                        <p>{PRINT_TERMS_INTRO}</p>
                        {PRINT_TERMS_ARTICLES.map(article => (
                            <div key={article.title}>
                                <p><strong>{article.title}</strong></p>
                                {article.clauses.map(clause => (
                                    <div key={clause.text} className="mt-0.5">
                                        <p>{clause.text}</p>
                                        {clause.items?.map(item => <p key={item} className="pl-4">{item}</p>)}
                                    </div>
                                ))}
                            </div>
                        ))}
                    </div>
                </div>

                {/* Contact Footer */}
                <div className="text-center text-xs text-gray-500 mt-6">
                    <p className="font-bold">CÔNG TY TNHH IN P&D</p>
                    <p>Hotline/Zalo: 0906702063 – 0333915038</p>
                    <p>Địa chỉ: 58 đường 41, P.Tân Hưng, TP.HCM</p>
                </div>

            </main>
        </div>
    );
};

export default TrackingPage;
