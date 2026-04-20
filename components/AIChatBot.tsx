import React, { useState, useEffect, useRef } from 'react';
import { GoogleGenerativeAI } from "@google/generative-ai";
import { customerService } from '../services/customerService';
import { alertService } from '../services/alertService';
import { orderService } from '../services/orderService';
import { Order } from '../types';
import { settingsService } from '../services/settingsService';

// Simple Markdown Renderer
const renderFormattedText = (text: string) => {
    if (!text) return null;
    return text.split('\n').map((line, index) => {
        // 1. Headers / Bold Sections (Lines starting with ** or containing **)
        // We will just parse inline bold for simplicity across all lines
        const parts = line.split(/(\*\*.*?\*\*)/g);

        return (
            <div key={index} className={`min-h-[20px] ${line.trim().startsWith('-') || line.trim().startsWith('* ') ? 'pl-4 relative' : ''}`}>
                {/* List Bullet */}
                {(line.trim().startsWith('-') || line.trim().startsWith('* ')) && (
                    <span className="absolute left-0 top-0 text-blue-500">•</span>
                )}

                {parts.map((part, partIdx) => {
                    if (part.startsWith('**') && part.endsWith('**')) {
                        return <strong key={partIdx} className="text-blue-700 font-bold bg-blue-50 px-1 rounded">{part.slice(2, -2)}</strong>;
                    }
                    return <span key={partIdx}>{part.replace(/^[-*]\s/, '')}</span>;
                })}
            </div>
        );
    });
};

// Basic software manual context
const SOFTWARE_MANUAL = `
PHẦN MỀM QUẢN LÝ ĐƠN HÀNG IN ẤN - TÍNH NĂNG:
1. Quản lý đơn hàng: Nhập đơn mới, theo dõi trạng thái (Thiết kế -> In -> Gia công -> Giao hàng).
2. Tính lương thưởng: Tự động tính thưởng cho NVKD và NV Sản xuất theo quy chế.
3. Báo cáo: Báo cáo tài chính, Công nợ, Doanh thu theo tháng/năm.
4. AI: Hỗ trợ nhập liệu từ ảnh/tin nhắn và Chatbot trả lời thông tin.

QUYỀN HẠN:
- Admin: Full quyền (Cài đặt hệ thống, KPI, Nhân viên).
- NVKD: Xem đơn mình phụ trách, công nợ khách hàng mình, xem thưởng cá nhân.
- NV Sản xuất: Xem đơn cần làm, báo cáo sản lượng, xem thưởng cá nhân.
`;

const STATUS_MAP: Record<string, string> = {
    'Moi': 'Mới',
    'TiepNhan': 'Tiếp nhận',
    'NhanFile': 'Nhận File',
    'XuLyFile': 'Xử lý File',
    'BinhFile': 'Bình File',
    'In': 'In',
    'ThanhPham': 'Thành phẩm',
    'DongGoi': 'Đóng gói',
    'ChoGiaoHang': 'Chờ giao hàng',
    'GiaoHang': 'Đi giao hàng',
    'DaGiaoHang': 'Đã giao hàng',
    'HoanThanh': 'Hoàn thành',
    'TamNgung': 'Tạm ngưng',
    'Huy': 'Đã hủy'
};

const PAYMENT_MAP: Record<string, string> = {
    'ChuaThanhToan': 'Chưa thanh toán',
    'DaCoc': 'Đã cọc',
    'DaThanhToan': 'Đã thanh toán',
    'CongNo': 'Công nợ'
};

// Helper Types
interface Message {
    id: string;
    text: string;
    sender: 'user' | 'bot';
    timestamp: Date;
    type?: 'order_list';
    data?: any[];
}

interface AIChatBotProps {
    onOpenOrderModal: (order: Partial<Order>) => void;
    currentUserRole: string;
}

const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(amount);
};

export const AIChatBot: React.FC<AIChatBotProps> = ({ onOpenOrderModal, currentUserRole }) => {
    const [isOpen, setIsOpen] = useState(false);
    const [messages, setMessages] = useState<Message[]>([
        { id: '1', text: 'Xin chào! Tôi là trợ lý ảo của bạn. Tôi có thể giúp gì về đơn hàng, tồn kho, hay báo cáo?', sender: 'bot', timestamp: new Date() }
    ]);
    const [inputText, setInputText] = useState('');
    const [isTyping, setIsTyping] = useState(false);
    const [apiKey, setApiKey] = useState('');
    const [customInstruction, setCustomInstruction] = useState('');
    const messagesEndRef = useRef<HTMLDivElement>(null);

    // Load Key Global from DB
    useEffect(() => {
        const loadConfig = async () => {
            const config = await settingsService.getAIConfig();
            if (config.apiKey) setApiKey(config.apiKey);
            if (config.instruction) setCustomInstruction(config.instruction);
        };
        loadConfig();

        // Run Logic on Open
        if (isOpen) {
            checkMorningBriefing();
        }
    }, [isOpen]);

    const checkMorningBriefing = async () => {
        if (messages.some(m => m.text.includes("HỆ THỐNG CẢNH BÁO") || m.text.includes("BÁO CÁO ĐẦU NGÀY"))) return;

        // 1. Compliance Check (Legacy)
        try {
            const issues = await customerService.getComplianceIssues();
            if (issues && issues.length > 0) {
                setMessages(prev => [...prev, {
                    id: 'sys_compl_' + Date.now(),
                    text: `⚠️ HỆ THỐNG CẢNH BÁO: Hiện có ${issues.length} khách hàng "Gấp" chưa bổ sung SĐT.\nHệ thống sẽ khóa quyền tạo đơn thứ 4. Vui lòng kiểm tra ngay.`,
                    sender: 'bot',
                    timestamp: new Date()
                }]);
            }
        } catch (e) {
            console.error("Compliance check failed", e);
        }

        // 2. Role-Based Briefing
        try {
            if (currentUserRole === 'NhanVienKinhDoanh') {
                const alerts = await alertService.getSalesAlerts();
                const totalAlerts = alerts.debt.length + alerts.deadline.length + alerts.approval.length;

                if (totalAlerts > 0) {
                    let msg = `🌅 **BÁO CÁO ĐẦU NGÀY (SALES)**\nBạn có ${totalAlerts} việc cần xử lý:\n`;
                    if (alerts.debt.length > 0) msg += `- 🔴 ${alerts.debt.length} khách nợ quá hạn 3 ngày.\n`;
                    if (alerts.deadline.length > 0) msg += `- 🟠 ${alerts.deadline.length} đơn cần giao gấp hôm nay/mai.\n`;
                    if (alerts.approval.length > 0) msg += `- 🟡 ${alerts.approval.length} đơn đang chờ duyệt tiền.\n`;

                    setMessages(prev => [...prev, {
                        id: 'sys_brief_' + Date.now(),
                        text: msg,
                        sender: 'bot',
                        timestamp: new Date()
                    }]);
                }
            } else if (['QuanLySanXuat', 'NhanVienSanXuat', 'NhanVienThietKe'].includes(currentUserRole)) { // Manager or Staff
                const alerts = await alertService.getProductionAlerts();
                const totalAlerts = alerts.urgent.length + alerts.bottleneck.length;

                if (totalAlerts > 0) {
                    let msg = `🌅 **BÁO CÁO ĐẦU NGÀY (SẢN XUẤT)**\nTình hình sản xuất hiện tại:\n`;
                    if (alerts.urgent.length > 0) msg += `- 🔥 ${alerts.urgent.length} đơn GẤP cần xong ngay.\n`;
                    if (alerts.bottleneck.length > 0) msg += `- 🐢 ${alerts.bottleneck.length} đơn đang bị kẹt > 2 ngày.\n`;

                    setMessages(prev => [...prev, {
                        id: 'sys_brief_' + Date.now(),
                        text: msg,
                        sender: 'bot',
                        timestamp: new Date()
                    }]);
                }
            }
        } catch (e) {
            console.error("Briefing check failed", e);
        }
    };

    // Auto-scroll
    useEffect(() => {
        messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
    }, [messages]);

    const handleSend = async () => {
        if (!inputText.trim()) return;

        const userMsg: Message = { id: Date.now().toString(), text: inputText, sender: 'user', timestamp: new Date() };
        setMessages(prev => [...prev, userMsg]);
        setInputText('');
        setIsTyping(true);

        try {
            if (!apiKey) {
                setTimeout(() => {
                    setMessages(prev => [...prev, { id: 'err', text: 'Vui lòng cài đặt API Key trước (Nút Cài đặt AI màu vàng trên thanh công cụ).', sender: 'bot', timestamp: new Date() }]);
                    setIsTyping(false);
                }, 1000);
                return;
            }

            // 1. Context Gathering (Enriched)
            const { data: allOrders } = await orderService.getOrders('Tất cả', 1, 100); // Fetch more for context

            // Filter: Focus on Active Orders + Recent Completed (last 3 days)
            // This reduces noise and token usage.
            const activeOrders = allOrders.filter(o =>
                o.status !== 'Huy' &&
                (o.status !== 'HoanThanh' || new Date(o.updated_at || o.created_at) > new Date(Date.now() - 3 * 86400000))
            );

            // Enrich Context
            const orderContext = activeOrders.map(o => ({
                id: o.id,
                code: o.order_code || o.id.substring(0, 8),
                customer: o.customer?.name || 'Khách lẻ', // Fixed from customer_name
                status: STATUS_MAP[o.status] || o.status,
                payment_status: PAYMENT_MAP[o.payment_status] || o.payment_status, // Important for Sales
                notes: o.notes, // Important for "Reading notes"
                status_note: o.status_note, // Important for progress
                product: o.description,
                total: o.total_amount,
                remaining: o.remaining_amount,
                is_urgent: o.is_urgent,
                sales_rep: o.sales_rep?.full_name,
                created_at: o.created_at.split('T')[0] // Just date
            }));

            // 2. Call Gemini with Fallback
            const genAI = new GoogleGenerativeAI(apiKey);

            const models = [
                'gemini-3-flash-preview',
                'gemini-3-pro-preview',
                'gemini-2.5-flash',
                'gemini-2.5-pro',
                'gemini-2.0-flash',
                'gemini-1.5-flash'
            ];

            const systemPrompt = `
                You are a smart Order Management Assistant.
                
                USER ROLE: ${currentUserRole}
                USER CUSTOM INSTRUCTIONS: ${customInstruction}

                SOFTWARE MANUAL:
                ${SOFTWARE_MANUAL}

                CURRENT ORDERS DATA (Active & Recent):
                ${JSON.stringify(orderContext)}
                
                SALES REPOER (Morning Brief):
                (The user might have just seen the morning brief. Use the JSON data above to elaborate).

                USER Question: "${userMsg.text}"

                TASKS:
                1. ANALYZE RISKS (DEEP ANALYSIS):
                   - Look at "notes" and "status_note". If a note says "Gấp" or "Can lay ngay" but status is "DangXuLy" or "ThietKe", WARN THE USER.
                   - Check "payment_status". If "CongNo" and total is high, remind Sales to check limit.
                   - Compare "created_at" with current progress.
                2. Answer questions about orders, status, revenue.
                3. LISTING/SEARCHING ORDERS:
                   - IF the user asks to list/find orders, return JSON: { "action": "list_orders", "data": [...] }
                4. CREATING ORDERS:
                   - Return JSON: { "action": "create_order", "data": {...} }

                ROLE-SPECIFIC BEHAVIOR:
                - If User is SALES: Focus on "My Orders" (check sales_rep_name vs User), payment status, and customer notes.
                - If User is PRODUCTION: Focus on "status", "is_urgent", "notes" (printing specs), and deadlines.

                CRITICAL OUTPUT RULES:
                - If the response involves a LIST of orders, you MUST use the JSON format ({ "action": "list_orders", ... }).
                - FORMATTING: 
                  + Use **Bold** for Keys, Amounts, and Important Statuses.
                  + Use EMOJIS (✅, ⚠️, 💰, 📦, 🚚) liberally to make it look like a dashboard report.
                  + Break independent points into separate lines.
                  + Use bullet points "* " for lists.
                - Do NOT reveal sensitive info (user passwords, salaries) if User Role is NOT Admin.
                - Answer in Vietnamese.

                REPORTING SCOPE:
                - **Completed Orders ('Hoàn thành', 'Đã giao hàng')**: ONLY report Financial info (Total, Deposit, Remaining, Payment Status). DO NOT report production progress or stage status (it's irrelevant).
            `;

            let text = '';
            let success = false;
            const errors: string[] = [];

            for (const modelName of models) {
                try {
                    const model = genAI.getGenerativeModel({ model: modelName });
                    const result = await model.generateContent(systemPrompt);
                    const response = result.response;
                    text = response.text();
                    success = true;
                    break;
                } catch (e: any) {
                    errors.push(`${modelName}: ${e.message}`);
                }
            }

            if (!success) {
                let errorMsg = "Không thể kết nối AI. ";
                if (errors.some(e => e.includes('404'))) {
                    errorMsg += "Lỗi 404: API Key không hợp lệ hoặc Model không khả dụng tại region này. Vui lòng kiểm tra lại Key Google AI Studio.";
                } else if (errors.some(e => e.includes('400') || e.includes('API key'))) {
                    errorMsg += "Lỗi API Key: Key không chính xác.";
                } else {
                    errorMsg += "Chi tiết: " + errors.join(', ');
                }
                throw new Error(errorMsg);
            }

            // Check for Action JSON
            try {
                const jsonMatch = text.match(/\{[\s\S]*\}/);
                if (jsonMatch) {
                    const jsonStr = jsonMatch[0];
                    const actionData = JSON.parse(jsonStr);
                    if (actionData.action === 'create_order') {
                        setMessages(prev => [...prev, { id: (Date.now() + 1).toString(), text: 'Đang mở form tạo đơn hàng với thông tin bạn cung cấp...', sender: 'bot', timestamp: new Date() }]);
                        // Delay slightly to let user see message
                        setTimeout(() => onOpenOrderModal(actionData.data), 800);
                        return;
                    }

                    if (actionData.action === 'list_orders') {
                        setMessages(prev => [...prev, {
                            id: (Date.now() + 1).toString(),
                            text: `Tìm thấy ${actionData.data.length} đơn hàng liên quan:`,
                            sender: 'bot',
                            timestamp: new Date(),
                            type: 'order_list',
                            data: actionData.data
                        }]);
                        return;
                    }
                }
            } catch (e) {
                // Not JSON or parse error, treat as text
            }

            const botMsg: Message = { id: (Date.now() + 1).toString(), text: text, sender: 'bot', timestamp: new Date() };
            setMessages(prev => [...prev, botMsg]);

        } catch (error: any) {
            console.error("Chatbot Error:", error);
            setMessages(prev => [...prev, { id: 'err', text: error.message || 'Lỗi kết nối AI', sender: 'bot', timestamp: new Date() }]);
        } finally {
            setIsTyping(false);
        }
    };

    const handleOrderClick = async (orderId: string) => {
        // Fetch full order details to open modal
        // Since we don't have getById specific endpoint easily available without modifying service, 
        // we can find it in the context we just loaded or fetch all again. context is reliable.
        try {
            // Re-fetch to be sure or use a service method if available. 
            // For now, let's fetch all and find. 
            // Re-fetch to be sure or use a service method if available. 
            // For now, let's fetch all and find. 
            const { data: all } = await orderService.getOrders('Tất cả', 1, 100);
            const match = all.find(o => o.id === orderId);
            if (match) {
                onOpenOrderModal(match);
            } else {
                alert("Không tìm thấy đơn hàng này!");
            }
        } catch (e) {
            console.error(e);
        }
    };

    const handleKeyPress = (e: React.KeyboardEvent) => {
        if (e.key === 'Enter') handleSend();
    };

    return (
        <>
            {/* Floating Button */}
            <button
                onClick={() => setIsOpen(!isOpen)}
                className="fixed bottom-6 right-6 w-14 h-14 bg-gradient-to-r from-blue-600 to-cyan-500 rounded-full shadow-lg hover:shadow-xl transition-all z-[60] flex items-center justify-center text-white animate-bounce-slow"
                title="Trợ lý AI"
            >
                {isOpen ? <i className="fa-solid fa-xmark text-2xl"></i> : <i className="fa-solid fa-message text-2xl"></i>}
            </button>

            {/* Chat Window */}
            {isOpen && (
                <div className="fixed bottom-20 left-1/2 -translate-x-1/2 sm:left-auto sm:translate-x-0 sm:bottom-24 sm:right-6 w-[90vw] sm:w-96 h-[70vh] sm:h-[500px] bg-white rounded-xl shadow-2xl z-[60] flex flex-col border border-gray-200 overflow-hidden animate-slideUp">
                    {/* Header */}
                    <div className="bg-gradient-to-r from-blue-600 to-cyan-500 p-4 text-white flex justify-between items-center shrink-0">
                        <div className="flex items-center gap-2">
                            <div className="w-8 h-8 bg-white/20 rounded-full flex items-center justify-center">
                                <i className="fa-solid fa-robot"></i>
                            </div>
                            <div>
                                <h3 className="font-bold text-sm">Trợ Lý Ảo</h3>
                                <div className="flex items-center gap-1">
                                    <span className="w-2 h-2 bg-green-400 rounded-full animate-pulse"></span>
                                    <span className="text-[10px] opacity-80">Online</span>
                                </div>
                            </div>
                        </div>
                        <button onClick={() => setMessages([])} className="text-white/70 hover:text-white text-xs" title="Xóa lịch sử">
                            <i className="fa-solid fa-trash"></i>
                        </button>
                    </div>

                    {/* Messages Area */}
                    <div className="flex-1 overflow-y-auto p-4 bg-gray-50 space-y-4">
                        {messages.map((msg) => (
                            <div key={msg.id} className={`flex ${msg.sender === 'user' ? 'justify-end' : 'justify-start'}`}>
                                <div className={`max-w-[80%] rounded-lg p-3 text-sm shadow-sm ${msg.sender === 'user'
                                    }`}>

                                    {msg.sender === 'user' ? msg.text : renderFormattedText(msg.text)}

                                    {/* Render Order List if type is order_list */}
                                    {msg.type === 'order_list' && msg.data && Array.isArray(msg.data) && (
                                        <div className="mt-2 space-y-2">
                                            {msg.data.map((order: any, idx: number) => (
                                                <div
                                                    key={idx}
                                                    onClick={() => handleOrderClick(order.id)}
                                                    className="bg-white border border-gray-200 p-3 rounded-lg hover:border-blue-300 hover:shadow-md cursor-pointer transition-all text-left group"
                                                >
                                                    <div className="flex justify-between items-center mb-1">
                                                        <span className="font-extrabold text-blue-800 text-sm bg-blue-50 px-2 py-0.5 rounded border border-blue-100 uppercase">
                                                            {order.code || 'N/A'}
                                                        </span>
                                                        <span className={`text-[10px] px-2 py-0.5 rounded-full font-bold ${order.status === 'Moi' ? 'bg-green-100 text-green-700' :
                                                            order.status === 'DangXuLy' ? 'bg-yellow-100 text-yellow-700' :
                                                                order.status === 'HoanThanh' ? 'bg-blue-100 text-blue-700' : 'bg-gray-100 text-gray-600'
                                                            }`}>
                                                            {order.status === 'Moi' ? 'Mới' :
                                                                order.status === 'DangXuLy' ? 'Đang xử lý' :
                                                                    order.status === 'HoanThanh' ? 'Hoàn thành' : order.status}
                                                        </span>
                                                    </div>

                                                    <div className="text-[#d32f2f] font-bold text-sm mb-1 line-clamp-1 border-b border-dashed border-gray-100 pb-1">
                                                        <i className="fa-solid fa-user mr-1 text-xs opacity-60"></i> {order.customer}
                                                    </div>

                                                    <div className="text-xs text-gray-600 mb-1 line-clamp-2 italic">
                                                        {order.product}
                                                    </div>

                                                    <div className="text-right">
                                                        <span className="text-xs font-bold text-gray-800">{formatCurrency(order.total)}</span>
                                                    </div>
                                                </div>
                                            ))}
                                        </div>
                                    )}

                                    {/* Duplicate removed */}

                                    <div className={`text-[10px] mt-1 ${msg.sender === 'user' ? 'text-blue-200' : 'text-gray-400'}`}>
                                        {msg.timestamp.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}
                                    </div>
                                </div>
                            </div>
                        ))}
                        {isTyping && (
                            <div className="flex justify-start">
                                <div className="bg-white border border-gray-200 rounded-lg rounded-bl-none p-3 shadow-sm flex gap-1">
                                    <span className="w-2 h-2 bg-gray-400 rounded-full animate-bounce"></span>
                                    <span className="w-2 h-2 bg-gray-400 rounded-full animate-bounce delay-75"></span>
                                    <span className="w-2 h-2 bg-gray-400 rounded-full animate-bounce delay-150"></span>
                                </div>
                            </div>
                        )}
                        <div ref={messagesEndRef} />
                    </div>

                    {/* Input Area */}
                    <div className="p-3 bg-white border-t border-gray-100 flex gap-2">
                        <input
                            type="text"
                            value={inputText}
                            onChange={(e) => setInputText(e.target.value)}
                            onKeyPress={handleKeyPress}
                            placeholder="Hỏi về đơn hàng..."
                            className="flex-1 border border-gray-300 rounded-full px-4 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
                        />
                        <button
                            onClick={handleSend}
                            disabled={!inputText.trim() || isTyping}
                            className="w-10 h-10 bg-blue-600 hover:bg-blue-700 disabled:bg-gray-300 text-white rounded-full flex items-center justify-center transition-colors shadow-sm"
                        >
                            <i className="fa-solid fa-paper-plane text-xs"></i>
                        </button>
                    </div>
                </div>
            )}
        </>
    );
};
