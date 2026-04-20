export const formatDate = (dateString?: string | null): string => {
    if (!dateString) return '';
    try {
        const date = new Date(dateString);
        return new Intl.DateTimeFormat('vi-VN', {
            timeZone: 'Asia/Ho_Chi_Minh',
            day: '2-digit',
            month: '2-digit',
            year: 'numeric'
        }).format(date);
    } catch (e) {
        return dateString || '';
    }
};

export const formatDateTime = (dateString?: string | null): string => {
    if (!dateString) return '';
    try {
        const date = new Date(dateString);
        return new Intl.DateTimeFormat('vi-VN', {
            timeZone: 'Asia/Ho_Chi_Minh',
            day: '2-digit',
            month: '2-digit',
            year: 'numeric',
            hour: '2-digit',
            minute: '2-digit',
            hour12: false
        }).format(date);
    } catch (e) {
        return dateString || '';
    }
};

export const toVietnamTime = (date: Date): Date => {
    // Helper if we need to shift a Date object logic-wise, 
    // but usually string formatting is enough for display.
    return new Date(date.toLocaleString("en-US", { timeZone: "Asia/Ho_Chi_Minh" }));
};
