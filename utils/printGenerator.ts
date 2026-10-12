import { Order } from '../types';
import { LOGO_SVG } from './logoSVG';
import { PRINT_TERMS_TITLE, PRINT_TERMS_INTRO, PRINT_TERMS_ARTICLES } from './printTerms';

const escHtml = (s: string) => s.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');

// Điều khoản in ấn: render từ nguồn duy nhất utils/printTerms.ts (2 cột để vừa phiếu).
const renderPrintTermsHtml = (): string => `
    <div class="term-block">
        <b style="font-size: 9pt; text-transform: uppercase;">${escHtml(PRINT_TERMS_TITLE)}</b>
        <div style="margin-top: 2px; text-align: justify;">${escHtml(PRINT_TERMS_INTRO)}</div>
        <div style="column-count: 2; column-gap: 14px; margin-top: 4px; font-size: 7pt; line-height: 1.25; text-align: justify;">
            ${PRINT_TERMS_ARTICLES.map(a => `
                <div style="break-inside: avoid-column; margin-bottom: 3px;">
                    <b>${escHtml(a.title)}</b>
                    ${a.clauses.map(c => `<div>${escHtml(c.text)}</div>${(c.items || []).map(i => `<div style="padding-left: 8px;">${escHtml(i)}</div>`).join('')}`).join('')}
                </div>`).join('')}
        </div>
        <div style="margin-top: 8px; font-size: 8pt; text-align: right; break-inside: avoid;">
            <div style="display: inline-block; text-align: center; min-width: 200px;"><b>KHÁCH HÀNG XÁC NHẬN</b><br/><i>(Đã đọc, hiểu và đồng ý điều khoản — ký, ghi rõ họ tên)</i><br/><br/><br/><br/>Ngày ....../....../........</div>
        </div>
    </div>`;

export const generatePrintHTML = (order: Order, type: 'receipt' | 'delivery' = 'receipt', customLogo?: string, customBackground?: string) => {
    const isReceipt = type === 'receipt';
    // Đơn sản xuất lại: phiếu nội bộ — không tiền, không điều khoản, ghi rõ gốc + lý do
    const isRework = !!order.rework_of_order_id;
    const title = isReceipt ? (isRework ? 'PHIẾU SẢN XUẤT LẠI' : 'ĐƠN ĐẶT HÀNG') : 'PHIẾU GIAO HÀNG';

    // Use embedded SVG logo by default (always works reliably)
    // If custom logo is provided (e.g. base64), use it, otherwise use the SVG constant
    const logoContent = customLogo || LOGO_SVG;


    const date = new Date(order.created_at);
    const day = date.getDate().toString().padStart(2, '0');
    const month = (date.getMonth() + 1).toString().padStart(2, '0');
    const year = date.getFullYear();
    const dateStr = `${day}/${month}/${year}`;

    // Background is removed by default unless explicitly provided (and not the old logo-bg)
    const backgroundUrl = customBackground || '';

    const styles = `
    <style>
      @import url('https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap');
      body { 
        font-family: 'Roboto', 'Times New Roman', serif; 
        font-size: 10pt; 
        line-height: 1.25; 
        color: #000; 
        margin: 0; 
        padding: 0;
        ${backgroundUrl ? `background-image: url('${backgroundUrl}');` : ''}
        background-size: 210mm 297mm;
        background-position: top center; 
        background-repeat: no-repeat;
      }
      @page { size: A4; margin: 0cm; } /* Loại bỏ margin mặc định để background full trang */
      .container { 
        width: 100%; 
        max-width: 210mm; 
        margin: 0 auto; 
        padding: 1cm 1cm 0.5cm 1cm; /* Padding nội dung bên trong */
      }
      
      /* Header */
      .header-table { width: 100%; margin-bottom: 5px; border: none; }
      .header-table td { vertical-align: middle; padding: 0; border: none; }
      /* Compact columns to pull left */
      .brand-column { width: 110px; text-align: left; vertical-align: top; } 
      .company-info-column { text-align: left; padding-left: 0; }
      .order-meta-column { width: 30%; text-align: right; font-weight: bold; font-size: 10pt; vertical-align: top; }

      .company-name { font-size: 14px; font-weight: bold; text-transform: uppercase; color: #1a237e; margin-bottom: 3px; }
      .company-address { font-size: 10px; margin-bottom: 1px; }
      
      .main-title { font-size: 22px; font-weight: bold; color: #d32f2f; text-align: center; text-transform: uppercase; margin: 5px 0 10px 0; }

      /* Customer Info */
      .customer-info { margin-bottom: 10px; font-weight: bold; border-bottom: 1px solid #ddd; padding-bottom: 5px; }
      .customer-row { display: flex; justify-content: space-between; margin-bottom: 3px; }

      /* Product Table */
      .product-table { width: 100%; border-collapse: collapse; margin-bottom: 15px; font-size: 10pt; background-color: rgba(255, 255, 255, 0.8); } /* Thêm nền trắng mờ cho bảng nếu cần */
      .product-table th, .product-table td { border: 1px solid #000; padding: 4px; vertical-align: top; }
      .product-table th { background-color: #f5f5f5; text-align: center; font-weight: bold; text-transform: uppercase; padding: 6px; }
      .col-desc { text-align: left; }
      .col-amount { width: 130px; text-align: right; font-weight: bold; }

      /* Summary Rows */
      .summary-row td { text-align: right; font-weight: bold; padding: 4px; }
      .summary-label { text-align: left !important; font-weight: bold; text-transform: uppercase; }
      
      /* Footer */
      .signature-section { margin-top: 5px; text-align: right; page-break-inside: avoid; }
      .creator-name { font-weight: bold; margin-top: 50px; font-size: 13px; }

      /* Terms - Compacted */
      .terms-section { margin-top: 15px; font-size: 8pt; line-height: 1.2; text-align: justify; border-top: 1px solid #ccc; padding-top: 5px; background-color: rgba(255, 255, 255, 0.8); }
      .term-block { margin-bottom: 5px; }
      .term-block b { font-size: 8.5pt; }

      @media print {
        body { -webkit-print-color-adjust: exact; print-color-adjust: exact; }
        .no-print { display: none; }
      }
    </style>
  `;

    return `
    <!DOCTYPE html>
    <html>
    <head>
      <title>${title} - ${order.order_code}</title>
      ${styles}
    </head>
    <body>
      <div class="container">
        
        <!-- HEADER TABLE -->
        <table class="header-table">
            <tr>
                <td class="brand-column">
                    <img src="${logoContent}" style="width: 100px; height: auto; object-fit: contain;" />
                </td>
                <td class="company-info-column">
                    <div class="company-name">CÔNG TY TNHH IN P&D</div>
                    <div class="company-address"><b>MST:</b> 0315320892 &nbsp;-&nbsp; <b>SĐT:</b> 0906702063 – 0333915038</div>
                    <div class="company-address"><b>Địa chỉ:</b> 58 đường 41, P.Tân Hưng, TP.HCM.</div>
                </td>
                <td class="order-meta-column">
                    <div>MÃ ĐH: ${order.order_code}</div>
                    <div>NGÀY: ${dateStr}</div>
                    ${isRework ? `<div style="color:#e65100;">SX LẠI CỦA: ${order.rework_of?.order_code || ''}</div>` : ''}
                </td>
            </tr>
        </table>

        <!-- TITLE -->
        <div class="main-title">${title}</div>

        <!-- CUSTOMER INFO -->
        <div class="customer-info">
            <div class="customer-row">
                <span style="flex: 2;">Khách hàng: ${order.customer?.name || order.customer_id || 'Khách lẻ'}</span>
                <span style="flex: 1;">SĐT: ${order.customer?.phone || ''}</span>
            </div>
            <div class="customer-row">
                <span>Địa chỉ: ${order.customer?.address || order.delivery_address || ''}</span>
            </div>
            ${isRework ? `<div class="customer-row" style="color:#e65100;">
                <span>LÝ DO SẢN XUẤT LẠI: ${order.rework_reason || ''}</span>
            </div>` : ''}
        </div>

        <!-- MAIN TABLE -->
        <table class="product-table">
            <thead>
                <tr>
                    <th class="col-desc">SẢN PHẨM - QUY CÁCH</th>
                    <th class="col-amount">${isReceipt ? (isRework ? 'GHI CHÚ' : 'THÀNH TIỀN') : 'SỐ LƯỢNG GIAO HÀNG'}</th>
                </tr>
            </thead>
            <tbody>
                <!-- Product Item -->
                <tr>
                    <td class="col-desc" style="white-space: pre-line; padding: 5px;">
                        ${order.description || ''}
                    </td>
                    <td class="col-amount" style="vertical-align: top; padding-top: 5px;">
                        ${isReceipt && !isRework ? (order.total_amount_pre_vat?.toLocaleString('vi-VN') + ' VNĐ') : ''}
                    </td>
                </tr>
                
                <!-- Use a minimum height for visually balanced look -->
                <tr style="height: 50px;">
                   <td></td><td></td>
                </tr>

                <!-- Summary Section (Only for Receipt; không in cho đơn sản xuất lại) -->
                ${isReceipt && !isRework ? `
                <tr class="summary-row">
                    <td class="summary-label">TỔNG TIỀN (CHƯA VAT)</td>
                    <td>${order.total_amount_pre_vat?.toLocaleString('vi-VN')} VNĐ</td>
                </tr>
                 <tr class="summary-row">
                    <td class="summary-label">VAT (${order.vat_rate}%)</td>
                    <td>${order.vat_amount?.toLocaleString('vi-VN')} VNĐ</td>
                </tr>
                 <tr class="summary-row">
                    <td class="summary-label">TỔNG TIỀN (CÓ VAT)</td>
                    <td>${order.total_amount?.toLocaleString('vi-VN')} VNĐ</td>
                </tr>
                
                <!-- Dynamic Calculation for Print -->
                ${(() => {
                let paid = order.deposit_amount || 0;
                let remaining = order.total_amount - paid;

                // If status is "Paid" (DaThanhToan), force Paid = Total, Remaining = 0
                // unless explicit deposit/remaining suggests otherwise (but usually Paid means fully paid)
                if (order.payment_status === 'DaThanhToan') {
                    paid = order.total_amount;
                    remaining = 0;
                }
                // If "Deposited" (DaCoc), stick to the explicit deposit_amount

                return `
                     <tr class="summary-row">
                        <td class="summary-label">${order.payment_status === 'DaThanhToan' ? 'ĐÃ THANH TOÁN' : 'ĐÃ CỌC'}</td>
                        <td>${paid.toLocaleString('vi-VN')} VNĐ</td>
                    </tr>
                     <tr class="summary-row">
                        <td class="summary-label">CÒN LẠI</td>
                        <td>${remaining.toLocaleString('vi-VN')} VNĐ</td>
                    </tr>
                    `;
            })()}
                ` : ''}
            </tbody>
        </table>

        <!-- SIGNATURE -->
        <div class="signature-section">
            ${isReceipt ? `
            <div style="margin-right: 30px; text-align: center; display: inline-block;">
                <b>NGƯỜI TẠO ĐƠN</b>
                <div class="creator-name">${order.sales_rep?.full_name || 'Admin'}</div>
            </div>
            ` : `
            <div style="display: flex; justify-content: space-between; padding: 0 20px;">
                <div style="text-align: center;">
                    <b>NGƯỜI NHẬN HÀNG</b>
                    <div style="font-style: italic; font-size: 9pt; margin-top: 2px;">(Ký và ghi rõ họ, tên)</div>
                </div>
                <div style="text-align: center;">
                    <b>NGƯỜI GIAO HÀNG</b>
                    <div style="font-style: italic; font-size: 9pt; margin-top: 2px;">(Ký và ghi rõ họ, tên)</div>
                </div>
            </div>
            `}
        </div>

        <!-- TERMS AND CONDITIONS (Compact) — bỏ với phiếu sản xuất lại (nội bộ) -->
        ${isRework ? '' : `
        <div class="terms-section" style="font-size: 7.5pt; line-height: 1.3;">
            <div class="term-block" style="display: flex; justify-content: space-between; gap: 20px; border-bottom: 1px dashed #ccc; padding-bottom: 5px; margin-bottom: 8px;">
                <div style="flex: 0 0 40%;">
                     <b>Thời gian giao hàng:</b> Theo thỏa thuận.
                </div>
                <div style="flex: 1;">
                     <b>Thanh toán:</b><br/>
                     - Đợt 1: Cọc 50% đơn hàng.<br/>
                     - Đợt 2: Phần còn lại thanh toán khi sản xuất xong và trước khi giao hàng.
                </div>
            </div>

            ${renderPrintTermsHtml()}
        </div>
        `}
      </div>
      <script>
        window.onload = function() { window.print(); }
      </script>
    </body>
    </html>
    `;
};
