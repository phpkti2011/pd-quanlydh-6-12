import React, { useState, useEffect, useRef } from 'react';
import { customerService } from '../services/customerService';
import { Customer } from '../types';

interface CustomerSearchProps {
    onSelect: (customer: Customer) => void;
    initialValue?: string; // Initial name to display
    onAddNew?: () => void;
}

const CustomerSearch: React.FC<CustomerSearchProps> = ({ onSelect, initialValue = '', onAddNew }) => {
    const [searchTerm, setSearchTerm] = useState(initialValue);
    const [suggestions, setSuggestions] = useState<Customer[]>([]);
    const [isOpen, setIsOpen] = useState(false);
    const [loading, setLoading] = useState(false);
    const wrapperRef = useRef<HTMLDivElement>(null);

    useEffect(() => {
        setSearchTerm(initialValue);
    }, [initialValue]);

    useEffect(() => {
        // Click outside to close
        function handleClickOutside(event: MouseEvent) {
            if (wrapperRef.current && !wrapperRef.current.contains(event.target as Node)) {
                setIsOpen(false);
            }
        }
        document.addEventListener("mousedown", handleClickOutside);
        return () => document.removeEventListener("mousedown", handleClickOutside);
    }, [wrapperRef]);

    useEffect(() => {
        const delayDebounce = setTimeout(() => {
            if (searchTerm && isOpen) {
                fetchSuggestions(searchTerm);
            }
        }, 300);

        return () => clearTimeout(delayDebounce);
    }, [searchTerm, isOpen]);

    const fetchSuggestions = async (search: string) => {
        setLoading(true);
        try {
            const data = await customerService.getAllCustomers(search);
            setSuggestions(data.slice(0, 100)); // Limit 100
        } catch (error) {
            console.error(error);
        } finally {
            setLoading(false);
        }
    };

    const handleSelect = (customer: Customer) => {
        setSearchTerm(customer.name);
        setIsOpen(false);
        onSelect(customer);
    };

    return (
        <div className="relative w-full" ref={wrapperRef}>
            <div className="relative">
                <input
                    type="text"
                    className="w-full border border-gray-300 rounded-md px-3 py-2 bg-white focus:ring-2 focus:ring-[#00796b] focus:border-transparent text-sm"
                    placeholder="Tìm tên, SĐT hoặc Mã KH..."
                    value={searchTerm}
                    onChange={(e) => { setSearchTerm(e.target.value); setIsOpen(true); }}
                    onFocus={() => setIsOpen(true)}
                />
                {loading && <i className="fa-solid fa-spinner fa-spin absolute right-3 top-2.5 text-gray-400"></i>}
            </div>

            {isOpen && searchTerm.length > 0 && (
                <div className="absolute z-50 w-full bg-white border border-gray-200 mt-1 rounded-md shadow-lg max-h-96 overflow-y-auto">
                    {suggestions.length > 0 ? (
                        suggestions.map(c => (
                            <div
                                key={c.code}
                                className="p-3 hover:bg-teal-50 cursor-pointer border-b border-gray-50 last:border-0"
                                onClick={() => handleSelect(c)}
                            >
                                <div className="font-bold text-gray-800 text-sm">{c.name}</div>
                                <div className="text-xs text-gray-500 flex justify-between">
                                    <span>{c.phone}</span>
                                    <span className="bg-gray-100 px-1 rounded">{c.code}</span>
                                </div>
                            </div>
                        ))
                    ) : (
                        <div className="p-3 text-sm text-gray-500 text-center">
                            Không tìm thấy khách hàng.
                            {onAddNew && (
                                <button
                                    className="block w-full mt-2 text-[#00796b] font-bold hover:underline"
                                    onClick={() => { setIsOpen(false); onAddNew(); }}
                                >
                                    + Thêm mới ngay
                                </button>
                            )}
                        </div>
                    )}
                </div>
            )}
        </div>
    );
};

export default CustomerSearch;
