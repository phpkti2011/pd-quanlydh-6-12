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
    { id: 'MB', name: 'MBBank', logo: 'https://img.vietqr.io/image/MB-logo.svg' },
    { id: 'VCB', name: 'Vietcombank', logo: 'https://img.vietqr.io/image/VCB-logo.svg' },
    { id: 'TCB', name: 'Techcombank', logo: 'https://img.vietqr.io/image/TCB-logo.svg' },
    { id: 'ACB', name: 'ACB', logo: 'https://img.vietqr.io/image/ACB-logo.svg' },
    { id: 'VPB', name: 'VPBank', logo: 'https://img.vietqr.io/image/VPB-logo.svg' },
    { id: 'TPB', name: 'TPBank', logo: 'https://img.vietqr.io/image/TPB-logo.svg' },
    { id: 'BIDV', name: 'BIDV', logo: 'https://img.vietqr.io/image/BIDV-logo.svg' },
    { id: 'VIB', name: 'VIB', logo: 'https://img.vietqr.io/image/VIB-logo.svg' },
    { id: 'ICB', name: 'VietinBank', logo: 'https://img.vietqr.io/image/ICB-logo.svg' },
    { id: 'OCB', name: 'OCB', logo: 'https://img.vietqr.io/image/OCB-logo.svg' },
    { id: 'MSB', name: 'MSB', logo: 'https://img.vietqr.io/image/MSB-logo.svg' }
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

    // Quick Link API Format: https://img.vietqr.io/image/<BANK_ID>-<ACCOUNT_NO>-<TEMPLATE>.svg?amount=<AMOUNT>&addInfo=<DESCRIPTION>&accountName=<NAME>
    return `https://img.vietqr.io/image/${bankId}-${accountNo}-${template}.svg?${amt}${addInfo}${accName}`;
};
