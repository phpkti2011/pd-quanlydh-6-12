
import React, { useState, useRef, useEffect } from 'react';
import { GoogleGenerativeAI } from "@google/generative-ai";

interface AIOrderInputModalProps {
    isOpen: boolean;
    onClose: () => void;
    onSuccess: (data: any) => void;
    userRole?: string;
}

import { settingsService } from '../services/settingsService';

export const AIOrderInputModal: React.FC<AIOrderInputModalProps> = ({ isOpen, onClose, onSuccess, userRole }) => {
    const [mode, setMode] = useState<'image' | 'text'>('image');
    const [textInput, setTextInput] = useState('');
    const [selectedImage, setSelectedImage] = useState<File | null>(null);
    const [previewUrl, setPreviewUrl] = useState<string | null>(null);
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState<string | null>(null);
    const [apiKey, setApiKey] = useState('');
    const [showKeyInput, setShowKeyInput] = useState(false);

    const [customInstruction, setCustomInstruction] = useState('');

    const fileInputRef = useRef<HTMLInputElement>(null);

    useEffect(() => {
        const loadConfig = async () => {
            // 1. Try Global Config First
            const config = await settingsService.getAIConfig();
            if (config.apiKey) {
                setApiKey(config.apiKey);
                if (config.instruction) setCustomInstruction(config.instruction);
            } else {
                // 2. Fallback to Local Storage (Legacy)
                const storedKey = localStorage.getItem('GOOGLE_AI_API_KEY');
                const storedInstruction = localStorage.getItem('GOOGLE_AI_INSTRUCTION');
                if (storedKey) setApiKey(storedKey);
                else {
                    // Only show input if user is Admin, otherwise show error/warning later
                    if (isOpen && !apiKey) setShowKeyInput(true);
                }
                if (storedInstruction) setCustomInstruction(storedInstruction);
            }
        };
        if (isOpen) loadConfig();
    }, [isOpen]);

    const saveKey = async (key: string) => {
        setApiKey(key);
        // Only save to Global if Admin? Or just Local?
        // Let's save to Local for now to avoid accidental global overwrite by non-admin if logic fails
        localStorage.setItem('GOOGLE_AI_API_KEY', key);

        // OPTIONAL: If Admin, maybe save to Global? 
        // For now, keep simple: "Cấu hình AI" in this modal is local override or handled via dedicated Settings Page.
        // BUT user asked to "Hide config". 
        // Let's assume this modal is for "Personal/Local" override if Admin wants?
        // actually, user said "Tự động lấy Key từ DB".
    };

    const saveInstruction = (ins: string) => {
        setCustomInstruction(ins);
        localStorage.setItem('GOOGLE_AI_INSTRUCTION', ins);
    };

    if (!isOpen) return null;

    const handleImageChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        if (e.target.files && e.target.files[0]) {
            const file = e.target.files[0];
            setSelectedImage(file);
            setPreviewUrl(URL.createObjectURL(file));
            setError(null);
        }
    };

    const handlePaste = (e: React.ClipboardEvent) => {
        const items = e.clipboardData.items;
        for (let i = 0; i < items.length; i++) {
            if (items[i].type.indexOf('image') !== -1) {
                const blob = items[i].getAsFile();
                if (blob) {
                    setMode('image');
                    setSelectedImage(blob);
                    setPreviewUrl(URL.createObjectURL(blob));
                    e.preventDefault();
                }
            }
        }
    };

    const runAI = async (key: string, imgBase64?: string, text?: string) => {
        const genAI = new GoogleGenerativeAI(key);
        // Robust Fallback: Try multiple model aliases, including new 002 and 2.0 versions
        const models = [
            'gemini-3-flash-preview',
            'gemini-3-pro-preview',
            'gemini-2.5-flash',
            'gemini-2.5-pro',
            'gemini-2.0-flash',
            'gemini-1.5-flash'
        ];

        const errors: string[] = [];

        const prompt = `
            Extract JSON order data from image/text.
            
            USER CUSTOM INSTRUCTIONS (IMPORTANT):
            ${customInstruction}
            
            Fields: 
            - customer_name
            - phone
            - description (summary of specs/qty)
            - notes
            - total_amount_number (number, e.g 100000)
            - is_vat_included (boolean)
            - has_be_demi (boolean, if mention "bế", "demi", "cán màng", "bế thành phẩm")
            - has_design (boolean, if mention "thiết kế")
            - has_large_print (boolean, if mention "in bạt", "khổ lớn")
            - has_ep_kim (boolean, if mention "ép kim")
            - has_gia_cong_ngoai (boolean)
            Return plain JSON. No markdown.
        `;

        for (const modelName of models) {
            try {
                console.log(`Trying model: ${modelName}`);
                const model = genAI.getGenerativeModel({
                    model: modelName,
                    generationConfig: {
                        maxOutputTokens: 2000,
                        temperature: 0.1,
                    }
                });

                let result;
                if (imgBase64) {
                    const cleanBase64 = imgBase64.split(',')[1];
                    result = await model.generateContent([
                        prompt,
                        { inlineData: { data: cleanBase64, mimeType: "image/jpeg" } }
                    ]);
                } else if (text) {
                    result = await model.generateContent([prompt, text]);
                } else {
                    throw new Error("No input");
                }

                const response = await result.response;
                const textOutput = response.text();
                const cleaned = textOutput.replace(/```json/g, '').replace(/```/g, '').trim();
                return JSON.parse(cleaned);

            } catch (err: any) {
                console.warn(`Model ${modelName} failed:`, err);
                errors.push(`${modelName}: ${err.message}`);
            }
        }

        throw new Error("All models failed details:\n" + errors.join('\n'));
    };

    const resizeImage = (file: File): Promise<string> => {
        return new Promise((resolve, reject) => {
            const reader = new FileReader();
            reader.readAsDataURL(file);
            reader.onload = (e) => {
                const img = new Image();
                img.src = e.target?.result as string;
                img.onload = () => {
                    const MAX_WIDTH = 800; // Resize to 800px
                    const MAX_HEIGHT = 800;
                    let width = img.width;
                    let height = img.height;

                    if (width > height) {
                        if (width > MAX_WIDTH) {
                            height *= MAX_WIDTH / width;
                            width = MAX_WIDTH;
                        }
                    } else {
                        if (height > MAX_HEIGHT) {
                            width *= MAX_HEIGHT / height;
                            height = MAX_HEIGHT;
                        }
                    }

                    const canvas = document.createElement('canvas');
                    canvas.width = width;
                    canvas.height = height;
                    const ctx = canvas.getContext('2d');
                    ctx?.drawImage(img, 0, 0, width, height);
                    resolve(canvas.toDataURL('image/jpeg', 0.6)); // Quality 0.6
                };
                img.onerror = () => reject(new Error("Lỗi đọc ảnh"));
            };
            reader.onerror = () => reject(new Error("Lỗi đọc file"));
        });
    };

    const handleSubmit = async () => {
        if (!apiKey) {
            setError("Vui lòng nhập API Key");
            setShowKeyInput(true);
            return;
        }

        setLoading(true);
        setError(null);

        try {
            let data;
            if (mode === 'image') {
                if (!selectedImage) throw new Error("Vui lòng chọn ảnh");
                const base64 = await resizeImage(selectedImage);
                data = await runAI(apiKey, base64, undefined);
            } else {
                if (!textInput.trim()) throw new Error("Vui lòng nhập nội dung");
                data = await runAI(apiKey, undefined, textInput);
            }

            onSuccess(data);
            onClose();

        } catch (err: any) {
            console.error(err);
            // Display raw error for debugging
            setError(err.message || String(err));
        } finally {
            setLoading(false);
        }
    };

    return (
        <div className="fixed inset-0 bg-black/60 z-[60] flex items-center justify-center p-4 backdrop-blur-sm">
            <div className="bg-white rounded-xl shadow-2xl w-full max-w-lg overflow-hidden flex flex-col max-h-[90vh]">

                {/* Header */}
                <div className="bg-gradient-to-r from-purple-600 to-indigo-600 px-6 py-4 flex justify-between items-center text-white shrink-0">
                    <h3 className="font-bold text-lg flex items-center gap-2">
                        <i className="fa-solid fa-wand-magic-sparkles"></i>
                        Nhập Đơn Hàng Từ AI
                    </h3>
                    <button onClick={onClose} className="text-white/80 hover:text-white transition-colors">
                        <i className="fa-solid fa-xmark text-xl"></i>
                    </button>
                </div>

                <div className="p-6 overflow-y-auto">
                    {/* API Key & Instructions Config - Only for Admin */}
                    {(!userRole || userRole === 'Admin') && (
                        <div className="mb-4">
                            {!showKeyInput ? (
                                <div className="flex justify-between items-center bg-yellow-50 p-2 rounded border border-yellow-200">
                                    <span className="text-xs text-yellow-800 flex items-center gap-1">
                                        <i className="fa-solid fa-gear"></i>
                                        Cấu hình AI (Key & "Dạy" AI)
                                    </span>
                                    <button onClick={() => setShowKeyInput(true)} className="text-blue-600 hover:underline text-xs font-bold">Chỉnh sửa</button>
                                </div>
                            ) : (
                                <div className="bg-yellow-50 border border-yellow-200 p-3 rounded-lg mb-4 space-y-3">
                                    <div>
                                        <label className="block text-xs font-bold text-yellow-800 mb-1">Google Gemini API Key</label>
                                        <input
                                            type="text"
                                            value={apiKey}
                                            onChange={(e) => saveKey(e.target.value)}
                                            className="w-full text-sm border border-yellow-300 rounded px-2 py-1 focus:ring-2 focus:ring-yellow-500 outline-none"
                                            placeholder="AIza..."
                                        />
                                        <p className="text-[10px] text-yellow-700 mt-1">
                                            Lấy key miễn phí tại <a href="https://aistudio.google.com/app/apikey" target="_blank" className="underline text-blue-700">Google AI Studio</a>.
                                        </p>
                                    </div>

                                    <div>
                                        <label className="block text-xs font-bold text-yellow-800 mb-1">
                                            Huấn luyện AI (Quy tắc riêng)
                                            <div className="group relative inline-block ml-1">
                                                <i className="fa-solid fa-circle-question text-gray-400 cursor-help"></i>
                                                <div className="hidden group-hover:block absolute left-0 bottom-full mb-2 w-64 bg-black/80 text-white text-xs p-2 rounded z-50">
                                                    Nhập các quy tắc bạn muốn AI tuân theo. Ví dụ: "Nếu không nói gì thì VAT là 8%", "Khách tên A luôn là sđt 090..."
                                                </div>
                                            </div>
                                        </label>
                                        <textarea
                                            rows={3}
                                            value={customInstruction}
                                            onChange={(e) => saveInstruction(e.target.value)}
                                            className="w-full text-sm border border-yellow-300 rounded px-2 py-1 focus:ring-2 focus:ring-yellow-500 outline-none resize-none"
                                            placeholder='Ví dụ: "Nếu khách không ghi VAT, mặc định là 0%". "Mặc định bạt là có đóng khoen"...'
                                        ></textarea>
                                    </div>

                                    <button
                                        onClick={() => setShowKeyInput(false)}
                                        className="w-full py-1 bg-yellow-100 hover:bg-yellow-200 text-yellow-800 text-xs font-bold rounded transition-colors"
                                    >
                                        Đóng cấu hình
                                    </button>
                                </div>
                            )}
                        </div>
                    )}

                    {/* Tabs */}
                    <div className="flex gap-2 mb-6 bg-gray-100 p-1 rounded-lg">
                        <button
                            onClick={() => setMode('image')}
                            className={`flex-1 py-2 rounded-md text-sm font-bold transition-all ${mode === 'image' ? 'bg-white text-purple-700 shadow-sm' : 'text-gray-500 hover:text-gray-700'}`}
                        >
                            <i className="fa-solid fa-image mr-2"></i>Hình ảnh
                        </button>
                        <button
                            onClick={() => setMode('text')}
                            className={`flex-1 py-2 rounded-md text-sm font-bold transition-all ${mode === 'text' ? 'bg-white text-purple-700 shadow-sm' : 'text-gray-500 hover:text-gray-700'}`}
                        >
                            <i className="fa-solid fa-paragraph mr-2"></i>Văn bản
                        </button>
                    </div>

                    {/* Content */}
                    <div className="min-h-[200px]" onPaste={handlePaste}>
                        {mode === 'image' ? (
                            <div className="space-y-4">
                                <div
                                    className="border-2 border-dashed border-gray-300 rounded-lg p-6 text-center hover:bg-gray-50 transition-colors cursor-pointer relative"
                                    onClick={() => fileInputRef.current?.click()}
                                >
                                    {previewUrl ? (
                                        <img src={previewUrl} alt="Preview" className="max-h-48 mx-auto rounded shadow-sm object-contain" />
                                    ) : (
                                        <div className="py-8 text-gray-400">
                                            <i className="fa-solid fa-cloud-arrow-up text-4xl mb-3"></i>
                                            <p className="font-medium">Nhấn để tải ảnh lên</p>
                                            <p className="text-xs mt-1">hoặc dán ảnh (Ctrl+V) vào đây</p>
                                        </div>
                                    )}
                                    <input
                                        type="file"
                                        ref={fileInputRef}
                                        onChange={handleImageChange}
                                        accept="image/*"
                                        className="hidden"
                                    />
                                </div>
                            </div>
                        ) : (
                            <div>
                                <textarea
                                    className="w-full border border-gray-300 rounded-lg p-3 h-48 focus:ring-2 focus:ring-purple-500 focus:border-transparent resize-none text-sm"
                                    placeholder="Dán nội dung tin nhắn đặt hàng vào đây..."
                                    value={textInput}
                                    onChange={(e) => setTextInput(e.target.value)}
                                ></textarea>
                            </div>
                        )}
                    </div>

                    {/* Error Message */}
                    {error && (
                        <div className="mt-4 p-3 bg-red-50 text-red-600 rounded-lg text-sm flex items-center gap-2 break-all">
                            <i className="fa-solid fa-triangle-exclamation"></i>
                            {error}
                        </div>
                    )}
                </div>

                {/* Footer */}
                <div className="p-4 border-t border-gray-100 bg-gray-50 flex justify-end gap-3">
                    <button onClick={onClose} className="px-4 py-2 text-gray-600 hover:text-gray-800 font-medium">Hủy</button>
                    <button
                        onClick={handleSubmit}
                        disabled={loading}
                        className="px-6 py-2 bg-gradient-to-r from-purple-600 to-indigo-600 text-white rounded-lg font-bold shadow-md hover:shadow-lg transition-all disabled:opacity-70 flex items-center gap-2"
                    >
                        {loading ? <i className="fa-solid fa-spinner fa-spin"></i> : <i className="fa-solid fa-wand-magic-sparkles"></i>}
                        {loading ? 'Đang phân tích...' : 'Phân tích ngay'}
                    </button>
                </div>
            </div>
        </div>
    );
};
