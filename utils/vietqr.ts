// VietQR Utility

export interface VietQRParams {
    bankId: string;
    accountNo: string;
    template?: string; // 'compact', 'compact2', 'qr_only', 'print'
    amount?: number;
    description?: string; // 'addInfo'
    accountName?: string;
}

// Common banks in Vietnam for dropdown
export const VIET_QR_BANKS = [
    { id: 'MB', name: 'MBBank', logo: 'https://img.vietqr.io/image/MB-logo.png' },
    { id: 'VCB', name: 'Vietcombank', logo: 'https://img.vietqr.io/image/VCB-logo.png' },
    { id: 'TCB', name: 'Techcombank', logo: 'https://img.vietqr.io/image/TCB-logo.png' },
    { id: 'ACB', name: 'ACB', logo: 'https://img.vietqr.io/image/ACB-logo.png' },
    { id: 'VPB', name: 'VPBank', logo: 'https://img.vietqr.io/image/VPB-logo.png' },
    { id: 'TPB', name: 'TPBank', logo: 'https://img.vietqr.io/image/TPB-logo.png' },
    { id: 'BIDV', name: 'BIDV', logo: 'https://img.vietqr.io/image/BIDV-logo.png' },
    { id: 'VIB', name: 'VIB', logo: 'https://img.vietqr.io/image/VIB-logo.png' },
    { id: 'ICB', name: 'VietinBank', logo: 'https://img.vietqr.io/image/ICB-logo.png' },
    { id: 'OCB', name: 'OCB', logo: 'https://img.vietqr.io/image/OCB-logo.png' },
    { id: 'MSB', name: 'MSB', logo: 'https://img.vietqr.io/image/MSB-logo.png' }
];

export const generateVietQRUrl = ({
    bankId,
    accountNo,
    template = 'compact',
    amount,
    description,
    accountName
}: VietQRParams): string => {
    if (!bankId || !accountNo) return '';

    // Encode description safely
    const addInfo = description ? `&addInfo=${encodeURIComponent(description)}` : '';
    const accName = accountName ? `&accountName=${encodeURIComponent(accountName)}` : '';
    const amt = amount && amount > 0 ? `&amount=${amount}` : '';

    // Quick Link API Format: https://img.vietqr.io/image/<BANK_ID>-<ACCOUNT_NO>-<TEMPLATE>.png?amount=<AMOUNT>&addInfo=<DESCRIPTION>&accountName=<NAME>
    return `https://img.vietqr.io/image/${bankId}-${accountNo}-${template}.png?${amt}${addInfo}${accName}`;
};
