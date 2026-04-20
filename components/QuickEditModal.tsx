import React, { useState, useEffect } from 'react';
import { COLORS } from '../constants';

interface QuickEditModalProps {
    isOpen: boolean;
    title: string;
    initialValue: string;
    onSave: (value: string) => Promise<void>;
    onClose: () => void;
}

const QuickEditModal: React.FC<QuickEditModalProps> = ({ isOpen, title, initialValue, onSave, onClose }) => {
    const [value, setValue] = useState(initialValue);
    const [isSaving, setIsSaving] = useState(false);

    useEffect(() => {
        setValue(initialValue);
    }, [initialValue, isOpen]);

    if (!isOpen) return null;

    const handleSave = async () => {
        setIsSaving(true);
        try {
            await onSave(value);
            onClose();
        } catch (error) {
            alert('Lỗi khi lưu: ' + (error as Error).message);
        } finally {
            setIsSaving(false);
        }
    };

    return (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-50">
            <div className="bg-white rounded-lg shadow-xl w-full max-w-md mx-4 overflow-hidden animate-fade-in-up">
                <div className="px-4 py-3 border-b border-gray-100 flex justify-between items-center bg-gray-50">
                    <h3 className="font-bold text-gray-800">{title}</h3>
                    <button onClick={onClose} className="text-gray-400 hover:text-gray-600 transition-colors">
                        <i className="fa-solid fa-xmark text-lg"></i>
                    </button>
                </div>

                <div className="p-4">
                    <textarea
                        className="w-full border border-gray-300 rounded-md p-3 text-sm focus:outline-none focus:ring-1 focus:ring-[#00796b] min-h-[120px]"
                        value={value}
                        onChange={(e) => setValue(e.target.value)}
                        placeholder="Nhập nội dung..."
                        autoFocus
                    />
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
                        onClick={handleSave}
                        className="px-3 py-1.5 rounded text-white shadow-sm hover:opacity-90 transition-opacity text-sm font-bold flex items-center gap-2"
                        style={{ backgroundColor: COLORS.primary }}
                        disabled={isSaving}
                    >
                        {isSaving && <i className="fa-solid fa-spinner fa-spin"></i>}
                        Lưu
                    </button>
                </div>
            </div>
        </div>
    );
};

export default QuickEditModal;
