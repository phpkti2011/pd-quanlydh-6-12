import React, { createContext, useContext, useState, useCallback } from 'react';

type ToastType = 'success' | 'error' | 'info' | 'warning';

interface Toast {
    id: number;
    message: string;
    type: ToastType;
}

interface ToastContextType {
    addToast: (message: string, type?: ToastType) => void;
    removeToast: (id: number) => void;
}

const ToastContext = createContext<ToastContextType | undefined>(undefined);

export const useToast = () => {
    const context = useContext(ToastContext);
    if (!context) {
        throw new Error('useToast must be used within a ToastProvider');
    }
    return context;
};

export const ToastProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
    const [toasts, setToasts] = useState<Toast[]>([]);

    const addToast = useCallback((message: string, type: ToastType = 'info') => {
        const id = Date.now();
        setToasts((prev) => [...prev, { id, message, type }]);

        // Auto remove after 3 seconds
        setTimeout(() => {
            setToasts((prev) => prev.filter((t) => t.id !== id));
        }, 3000);
    }, []);

    const removeToast = useCallback((id: number) => {
        setToasts((prev) => prev.filter((t) => t.id !== id));
    }, []);

    return (
        <ToastContext.Provider value={{ addToast, removeToast }}>
            {children}
            <div className="fixed top-4 right-4 z-[9999] flex flex-col gap-2">
                {toasts.map((toast) => (
                    <div
                        key={toast.id}
                        onClick={() => removeToast(toast.id)}
                        className={`min-w-[300px] max-w-sm px-4 py-3 rounded-lg shadow-lg cursor-pointer transform transition-all duration-300 hover:scale-[1.02] flex items-center gap-3 animate-slideInRight
              ${toast.type === 'success' ? 'bg-white border-l-4 border-green-500 text-gray-800' : ''}
              ${toast.type === 'error' ? 'bg-white border-l-4 border-red-500 text-gray-800' : ''}
              ${toast.type === 'warning' ? 'bg-white border-l-4 border-yellow-500 text-gray-800' : ''}
              ${toast.type === 'info' ? 'bg-white border-l-4 border-blue-500 text-gray-800' : ''}
            `}
                    >
                        {/* Icon */}
                        <div className={`shrink-0 text-lg
               ${toast.type === 'success' ? 'text-green-500' : ''}
               ${toast.type === 'error' ? 'text-red-500' : ''}
               ${toast.type === 'warning' ? 'text-yellow-500' : ''}
               ${toast.type === 'info' ? 'text-blue-500' : ''}
            `}>
                            {toast.type === 'success' && <i className="fa-solid fa-circle-check"></i>}
                            {toast.type === 'error' && <i className="fa-solid fa-circle-xmark"></i>}
                            {toast.type === 'warning' && <i className="fa-solid fa-triangle-exclamation"></i>}
                            {toast.type === 'info' && <i className="fa-solid fa-circle-info"></i>}
                        </div>

                        <div className="flex-1 text-sm font-medium leading-tight">
                            {toast.message}
                        </div>

                        <button className="text-gray-400 hover:text-gray-600">
                            <i className="fa-solid fa-xmark"></i>
                        </button>
                    </div>
                ))}
            </div>
        </ToastContext.Provider>
    );
};
