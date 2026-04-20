import React, { useState, useEffect } from 'react';
import { settingsService } from '../services/settingsService';

interface AISettingsModalProps {
    isOpen: boolean;
    onClose: () => void;
}

export const AISettingsModal: React.FC<AISettingsModalProps> = ({ isOpen, onClose }) => {
    const [apiKey, setApiKey] = useState('');
    const [showKey, setShowKey] = useState(false);
    const [customInstruction, setCustomInstruction] = useState('');
    const [saved, setSaved] = useState(false);
    const [loading, setLoading] = useState(false);

    useEffect(() => {
        if (isOpen) {
            loadSettings();
        }
    }, [isOpen]);

    const loadSettings = async () => {
        setLoading(true);
        const config = await settingsService.getAIConfig();
        if (config.apiKey) setApiKey(config.apiKey);
        if (config.instruction) setCustomInstruction(config.instruction);
        setLoading(false);
    };

    const handleSave = async () => {
        setLoading(true);
        const success = await settingsService.saveAIConfig(apiKey, customInstruction);
        setLoading(false);
        if (success) {
            setSaved(true);
            setTimeout(() => setSaved(false), 2000);
        } else {
            alert("Lỗi khi lưu cấu hình!");
        }
    };

    if (!isOpen) return null;

    return (
        <div className="fixed inset-0 bg-black/60 z-[70] flex items-center justify-center p-4 backdrop-blur-sm">
            <div className="bg-white rounded-xl shadow-2xl w-full max-w-md overflow-hidden flex flex-col animate-fadeIn">

                {/* Header */}
                <div className="bg-gradient-to-r from-yellow-500 to-orange-500 px-6 py-4 flex justify-between items-center text-white shrink-0">
                    <h3 className="font-bold text-lg flex items-center gap-2">
                        <i className="fa-solid fa-gear"></i>
                        Cấu hình AI Trợ Lý (Toàn hệ thống)
                    </h3>
                    <button onClick={onClose} className="text-white/80 hover:text-white transition-colors">
                        <i className="fa-solid fa-xmark text-xl"></i>
                    </button>
                </div>

                <div className="p-6 space-y-5 relative">
                    {loading && (
                        <div className="absolute inset-0 bg-white/60 z-10 flex items-center justify-center">
                            <i className="fa-solid fa-circle-notch fa-spin text-yellow-600 text-2xl"></i>
                        </div>
                    )}

                    {/* API Key Section */}
                    <div>
                        <label className="block text-sm font-bold text-gray-700 mb-1">
                            Google Gemini API Key <span className="text-red-500">*</span>
                        </label>
                        <div className="relative">
                            {/* Hidden inputs to trick browser auto-fill */}
                            <input style={{ display: 'none' }} />
                            <input type="password" style={{ display: 'none' }} />

                            <i className="fa-solid fa-key text-gray-400 absolute left-3 top-1/2 -translate-y-1/2"></i>
                            <input
                                type={showKey ? "text" : "password"}
                                value={apiKey}
                                onChange={(e) => setApiKey(e.target.value)}
                                className="w-full pl-9 pr-10 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-yellow-500 focus:border-transparent outline-none text-sm"
                                placeholder="Dán mã key... (AIzaSync...)"
                                autoComplete="new-password"
                                name="gemini_api_key_field_no_autofill"
                            />
                            <button
                                onClick={() => setShowKey(!showKey)}
                                className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-600"
                            >
                                <i className={`fa-solid ${showKey ? 'fa-eye-slash' : 'fa-eye'}`}></i>
                            </button>
                        </div>
                        <p className="text-xs text-gray-500 mt-1">
                            Key này sẽ được lưu trên Database và áp dụng cho <span className="font-bold">tất cả nhân viên</span>.
                        </p>
                    </div>

                    {/* Instruction Section */}
                    <div>
                        <label className="block text-sm font-bold text-gray-700 mb-1">
                            Huấn luyện AI (Quy tắc chung)
                        </label>
                        <div className="bg-yellow-50 border border-yellow-100 rounded-lg p-3 mb-2 text-xs text-yellow-800">
                            <i className="fa-solid fa-lightbulb mr-1.5 text-yellow-600"></i>
                            Quy tắc này sẽ áp dụng cho toàn bộ nhân viên khi chat với AI.
                        </div>
                        <textarea
                            rows={8}
                            value={customInstruction}
                            onChange={(e) => setCustomInstruction(e.target.value)}
                            className="w-full border border-gray-300 rounded-lg p-3 focus:ring-2 focus:ring-yellow-500 focus:border-transparent outline-none text-sm resize-none"
                            placeholder="Nhập quy tắc chung..."
                        ></textarea>
                    </div>

                </div>

                {/* Footer */}
                <div className="p-4 border-t border-gray-100 bg-gray-50 flex justify-end gap-3">
                    <button onClick={onClose} className="px-4 py-2 text-gray-600 hover:text-gray-800 font-medium text-sm">
                        Đóng
                    </button>
                    <button
                        onClick={handleSave}
                        disabled={loading}
                        className={`px-6 py-2 rounded-lg font-bold text-white text-sm shadow-md transition-all flex items-center gap-2
                            ${saved ? 'bg-green-600' : 'bg-yellow-600 hover:bg-yellow-700 hover:shadow-lg'}
                            ${loading ? 'opacity-70 cursor-not-allowed' : ''}
                        `}
                    >
                        {saved ? <><i className="fa-solid fa-check"></i> Đã lưu</> : <><i className="fa-solid fa-save"></i> Lưu & Áp dụng</>}
                    </button>
                </div>

            </div>
        </div >
    );
};
