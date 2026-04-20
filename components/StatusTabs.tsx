
import React, { useMemo } from 'react';
import { UserRole } from '../types';

interface StatusTabsProps {
    currentTab: string;
    onTabChange: (tab: string) => void;
    currentSubTab?: string;
    onSubTabChange?: (subTab: string) => void;
    counts: Record<string, number>;
    subTabCounts?: Record<string, number>;
    userRole: UserRole;
}

const StatusTabs: React.FC<StatusTabsProps> = ({ currentTab, onTabChange, currentSubTab, onSubTabChange, counts, subTabCounts = {}, userRole }) => {
    const [isExpanded, setIsExpanded] = React.useState(false);

    const tabs = useMemo(() => {
        const getCountKey = (label: string): string => {
            const map: Record<string, string> = {
                'Tất cả': 'all',
                'Xuất hóa đơn': 'xuat_hoa_don',
                'Nhận File': 'nhan_file',
                'Xử lý File': 'xu_ly_file',
                'Bình File': 'binh_file',
                'In': 'in',
                'Thành Phẩm': 'thanh_pham',
                'Đóng gói': 'dong_goi',
                'Chờ giao hàng': 'cho_giao_hang',
                'Đã giao hàng': 'da_giao_hang',
                'Đã hoàn thành': 'hoan_thanh', // Updated to match screenshot "Đã hoàn thành"
                'Hoàn thành': 'hoan_thanh',     // Fallback if key differs
                'Gấp': 'gap',
                'Đã hủy': 'huy',
                'Tạm ngưng': 'tam_ngung',
                'Thiết Kế': 'thiet_ke',
                'In Khổ Lớn': 'in_kho_lon',
                'Bế Demi': 'be_demi',
                'Gia công ngoài': 'gia_cong_ngoai',
                'Ép Kim': 'ep_kim'
            };
            return map[label] || '';
        };

        // First row: Primary workflow tabs
        const row1Labels = [
            "📊 Tổng quan", "Tất cả", "Xuất hóa đơn", "Nhận File", "Xử lý File",
            "Bình File", "In", "Thành Phẩm", "Đóng gói", "Chờ giao hàng",
            "Tạm ngưng", "Đã giao hàng"
        ];

        // Second row: Completion, special, and subtasks
        // Changed "Hoàn thành" to "Đã hoàn thành" to match screenshot
        const row2Labels = [
            "Đã hoàn thành", "Gấp", "Đã hủy",
            "Thiết Kế", "In Khổ Lớn", "Bế Demi", "Gia công ngoài", "Ép Kim"
        ];

        const createTab = (label: string, isTask: boolean = false, isSpecial: boolean = false) => ({
            key: label,
            label: label,
            countKey: getCountKey(label),
            isTask,
            isSpecial
        });

        // Role-based Tab Filtering
        const getRelevantTabs = (allTabs: any[]) => {
            // These roles can see EVERYTHING, including Invoice
            const privilegedRoles = ['Admin', 'KeToan', 'NhanVienKinhDoanh', 'QuanLySanXuat'];

            if (privilegedRoles.includes(userRole)) {
                return allTabs;
            }

            // For other roles (Design, Production Staff, Delivery), hide specific sensitive tabs
            const restrictedTabs = ['Xuất hóa đơn', '📊 Tổng quan'];

            return allTabs.filter(t => !restrictedTabs.includes(t.key));
        };

        const r1 = row1Labels.map(label => createTab(
            label,
            false,
            label === "Xuất hóa đơn" || label === "Gấp"
        ));

        const r2 = row2Labels.map(label => createTab(
            label,
            ["Thiết Kế", "In Khổ Lớn", "Bế Demi", "Gia công ngoài", "Ép Kim"].includes(label),
            label === "Gấp"
        ));

        const allTabs = [...r1, ...r2];
        const filtered = getRelevantTabs(allTabs);

        // Re-group into rows for display?
        // Or just display filtered tabs in a single flow if few?
        // Let's preserve the row structure if possible, but filter items within them.

        return {
            row1: r1.filter(t => getRelevantTabs([t]).length > 0),
            row2: r2.filter(t => getRelevantTabs([t]).length > 0)
        };
    }, [userRole]);

    const renderTab = (tab: any) => {
        const count = counts[tab.countKey] || 0;
        const isActive = currentTab === tab.key;
        const showBadge = count > 0;

        // Visual Style adjustments based on Screenshot
        const baseClass = "px-4 py-1.5 rounded-full text-sm font-bold cursor-pointer transition-colors border border-transparent whitespace-nowrap flex items-center";

        // Inactive: bg-gray-200 (light gray), text-gray-700
        // Active: bg-[#00796b], text-white - UPDATED to match screenshot (looks like Pink/Red for Invoice?)
        // Let's stick to Teal for now, or match specific colors if needed.
        // Screenshot shows "Xuất hóa đơn" Active is Pink (#e91e63).
        // Task Tabs Styling (Sub-tasks)
        if (tab.isTask) {
            const taskActiveBg = isActive ? "bg-white border-[#00796b] text-[#00796b] ring-2 ring-[#00796b]" : "bg-white border-gray-300 text-gray-600 hover:border-gray-400";

            return (
                <div
                    key={tab.key}
                    onClick={() => onTabChange(tab.key)}
                    className={`px-3 py-1.5 rounded-md text-xs font-bold cursor-pointer transition-all border flex items-center gap-1.5 shadow-sm ${taskActiveBg}`}
                >
                    <i className="fa-solid fa-layer-group text-[10px] opacity-70"></i>
                    {tab.label}
                    {showBadge && (
                        <span className={`ml-1 px-1.5 py-0.5 rounded text-[10px] font-bold ${isActive ? 'bg-[#00796b] text-white' : 'bg-gray-200 text-gray-700'}`}>
                            {count}
                        </span>
                    )}
                </div>
            );
        }

        // Standard Tab Styling
        let activeBg = "bg-[#00796b]";
        if (tab.Key === "Xuất hóa đơn" && isActive) activeBg = "bg-[#e91e63]";

        const activeClass = isActive
            ? `${activeBg} text-white shadow-md border-transparent`
            : "bg-gray-200 text-gray-700 hover:bg-gray-300 border-transparent";

        const showBadgeStd = count > 0;
        const badgeClass = isActive
            ? "bg-white text-[#d32f2f]" // Dark red text on white for active badge
            : "bg-[#ef4444] text-white"; // Red-500

        return (
            <div
                key={tab.key}
                onClick={() => onTabChange(tab.key)}
                className={`${baseClass} ${activeClass}`}
            >
                {tab.label}
                {showBadgeStd && (
                    <span className={`ml-2 px-1.5 py-0.5 rounded-full text-xs font-bold ${badgeClass}`}>
                        {count}
                    </span>
                )}
            </div>
        );
    };

    // Sub-tab definitions
    const getSubTabs = (tabKey: string) => {
        if (tabKey === 'Xuất hóa đơn') {
            return [
                { key: 'Chưa xuất', label: 'Chưa xuất' },
                { key: 'Đã xuất', label: 'Đã xuất' }
            ];
        }
        const taskTabs = ['Thiết Kế', 'In Khổ Lớn', 'Bế Demi', 'Gia công ngoài', 'Ép Kim'];
        // Normalize checking
        if (taskTabs.some(t => t === tabKey || t.normalize('NFC') === tabKey.normalize('NFC'))) {
            return [
                { key: 'Chưa hoàn thành', label: 'Chưa hoàn thành' },
                { key: 'Đã hoàn thành', label: 'Đã hoàn thành' }
            ];
        }
        return [];
    };

    const activeSubTabs = getSubTabs(currentTab);

    const renderSubTab = (subTab: { key: string, label: string }) => {
        const isActive = currentSubTab === subTab.key;
        const count = subTabCounts?.[subTab.key] || 0;

        let baseStyle = "px-3 py-1.5 rounded-lg text-xs font-bold cursor-pointer transition-all flex items-center gap-2 border";
        let colorStyle = "";
        let icon = "";

        // Determine Type (Pending or Completed)
        const isPending = subTab.key.startsWith('Chưa');
        const isCompleted = subTab.key.startsWith('Đã');

        if (isActive) {
            if (isPending) {
                colorStyle = "bg-red-50 text-red-700 border-red-200 ring-1 ring-red-200";
                icon = "fa-clock";
            } else if (isCompleted) {
                colorStyle = "bg-green-50 text-green-700 border-green-200 ring-1 ring-green-200";
                icon = "fa-check-circle";
            } else {
                colorStyle = "bg-gray-100 text-gray-800 border-gray-300"; // Fallback
            }
        } else {
            // Inactive State
            colorStyle = "bg-white text-gray-500 border-gray-200 hover:bg-gray-50 hover:border-gray-300";
            if (isPending) icon = "fa-clock";
            if (isCompleted) icon = "fa-check-circle";
        }

        return (
            <div
                key={subTab.key}
                onClick={() => onSubTabChange?.(subTab.key)}
                className={`${baseStyle} ${colorStyle}`}
            >
                <i className={`fa-solid ${icon} ${isActive ? '' : 'opacity-50'}`}></i>
                {subTab.label}
                <span className={`px-1.5 py-0.5 rounded-md text-[10px] font-bold ${isActive ? 'bg-white shadow-sm' : 'bg-gray-100 text-gray-500'}`}>
                    {count}
                </span>
            </div>
        );
    };

    return (
        <div className="mb-4 border-b border-gray-200 pb-2 relative">
            {/* Mobile Expand Toggle */}
            <button
                onClick={() => setIsExpanded(!isExpanded)}
                className="md:hidden w-full flex items-center justify-between px-4 py-2 bg-gray-50 border border-gray-200 rounded mb-2 text-sm font-bold text-gray-700"
            >
                <span>{currentTab} {counts[currentTab] ? `(${counts[currentTab]})` : ''}</span>
                <i className={`fa-solid fa-chevron-${isExpanded ? 'up' : 'down'}`}></i>
            </button>

            {/* Tab Container - Collapsed on Mobile, Visible on Desktop */}
            <div className={`${isExpanded ? 'block' : 'hidden'} md:block transition-all duration-300`}>
                {/* First Row: Primary Workflow Tabs */}
                <div className="flex flex-wrap gap-2 mb-2">
                    {tabs.row1.map(renderTab)}
                </div>

                {/* Second Row: Completion, Special, and Subtasks */}
                <div className="flex flex-wrap gap-2 mb-2">
                    {tabs.row2.map(renderTab)}
                </div>
            </div>

            {/* Third Row: Sub-Tabs (Conditional) - Always visible if active? Or folded? */}
            {/* User probably wants sub-tabs visible if they are working on it. Keeping logical flow. */}
            {activeSubTabs.length > 0 && (
                <div className="flex flex-wrap gap-2 mt-3 pl-2 border-l-4 border-gray-300 animate-fadeIn">
                    {activeSubTabs.map(renderSubTab)}
                </div>
            )}
        </div>
    );
};

export default StatusTabs;
