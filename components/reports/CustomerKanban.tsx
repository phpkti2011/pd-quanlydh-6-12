import React, { useState } from 'react';
import { Customer } from '../../types';
import { COLORS } from '../../constants';
import { customerService } from '../../services/customerService';

interface CustomerKanbanProps {
    customers: Customer[];
    onUpdateCustomer: () => void;
    onSelectCustomer: (customer: Customer) => void;
}

const STAGES = {
    'NEW': { label: 'Mới Tiềm Năng', color: 'bg-blue-100 border-blue-200 text-blue-800' },
    'QUOTED': { label: 'Đã Báo Giá', color: 'bg-yellow-100 border-yellow-200 text-yellow-800' },
    'NEGOTIATING': { label: 'Đang Thương Lượng', color: 'bg-purple-100 border-purple-200 text-purple-800' },
    'WON': { label: 'Đã Chốt / Khách Hàng', color: 'bg-green-100 border-green-200 text-green-800' },
    'LOST': { label: 'Đã Rớt / Hủy', color: 'bg-gray-100 border-gray-200 text-gray-600' }
};

export const CustomerKanban: React.FC<CustomerKanbanProps> = ({ customers, onUpdateCustomer, onSelectCustomer }) => {
    const [draggedCustomerId, setDraggedCustomerId] = useState<string | null>(null);

    const handleDragStart = (e: React.DragEvent, id: string) => {
        setDraggedCustomerId(id);
        e.dataTransfer.setData('customerId', id);
        e.dataTransfer.effectAllowed = 'move';
    };

    const handleDragOver = (e: React.DragEvent) => {
        e.preventDefault();
        e.dataTransfer.dropEffect = 'move';
    };

    const handleDrop = async (e: React.DragEvent, stage: string) => {
        e.preventDefault();
        const customerId = e.dataTransfer.getData('customerId');

        if (customerId) {
            // Optimistic update logic could go here, but for safety we await
            try {
                await customerService.updatePipelineStage(customerId, stage);
                onUpdateCustomer(); // Refresh list
            } catch (err) {
                console.error("Failed to move card", err);
                alert("Lỗi khi chuyển trạng thái: " + (err as Error).message);
            }
        }
        setDraggedCustomerId(null);
    };

    const renderCard = (customer: Customer) => {
        return (
            <div
                key={customer.id}
                draggable
                onDragStart={(e) => handleDragStart(e, customer.code)}
                onClick={() => onSelectCustomer(customer)}
                className="bg-white p-3 rounded-lg shadow-sm mb-3 border border-gray-200 cursor-move hover:shadow-md transition-all active:cursor-grabbing group relative"
            >
                <div className="flex justify-between items-start mb-2">
                    <span className="font-bold text-gray-800 line-clamp-1">{customer.name}</span>
                    {customer.is_urgent_entry && !customer.phone && (
                        <span className="text-red-500 text-xs font-bold bg-red-50 px-1 rounded animate-pulse">GẤP</span>
                    )}
                </div>

                <div className="text-xs text-gray-500 space-y-1">
                    <div className="flex items-center gap-1">
                        <i className="fa-solid fa-barcode w-4"></i> {customer.code}
                    </div>
                    {customer.phone && (
                        <div className="flex items-center gap-1">
                            <i className="fa-solid fa-phone w-4"></i> {customer.phone}
                        </div>
                    )}
                    <div className="flex items-center gap-1">
                        <i className="fa-solid fa-calendar w-4"></i> {new Date(customer.created_at).toLocaleDateString()}
                    </div>
                </div>

                {/* Quick Actions (Hover) */}
                <div className="absolute top-2 right-2 opacity-0 group-hover:opacity-100 transition-opacity">
                    <i className="fa-solid fa-grip-vertical text-gray-300"></i>
                </div>
            </div>
        );
    };

    return (
        <div className="flex overflow-x-auto gap-4 p-4 h-full min-h-[500px] bg-gray-50 items-start">
            {Object.entries(STAGES).map(([stageKey, config]) => {
                const stageCustomers = customers.filter(c => (c.pipeline_stage || 'NEW') === stageKey);

                return (
                    <div
                        key={stageKey}
                        onDragOver={handleDragOver}
                        onDrop={(e) => handleDrop(e, stageKey)}
                        className={`min-w-[280px] w-[280px] flex flex-col h-full rounded-xl bg-gray-100/50 border-2 ${draggedCustomerId ? 'border-dashed border-gray-300' : 'border-transparent'}`}
                    >
                        {/* Header */}
                        <div className={`p-3 rounded-t-xl border-b font-bold flex justify-between items-center ${config.color}`}>
                            <span>{config.label}</span>
                            <span className="bg-white/50 px-2 py-0.5 rounded text-xs">{stageCustomers.length}</span>
                        </div>

                        {/* Drop Zone */}
                        <div className="flex-1 p-2 overflow-y-auto">
                            {stageCustomers.map(renderCard)}
                            {stageCustomers.length === 0 && (
                                <div className="text-center text-gray-400 text-sm py-4 italic">Trống</div>
                            )}
                        </div>
                    </div>
                );
            })}
        </div>
    );
};
