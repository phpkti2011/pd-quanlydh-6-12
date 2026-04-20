import { Order } from '../types';
import { LOGO_SVG } from './logoSVG';

export const generatePrintHTML = (order: Order, type: 'receipt' | 'delivery' = 'receipt', customLogo?: string, customBackground?: string) => {
    const isReceipt = type === 'receipt';
    const title = isReceipt ? 'ĐƠN ĐẶT HÀNG' : 'PHIẾU GIAO HÀNG';

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
        </div>

        <!-- MAIN TABLE -->
        <table class="product-table">
            <thead>
                <tr>
                    <th class="col-desc">SẢN PHẨM - QUY CÁCH</th>
                    <th class="col-amount">${isReceipt ? 'THÀNH TIỀN' : 'SỐ LƯỢNG GIAO HÀNG'}</th>
                </tr>
            </thead>
            <tbody>
                <!-- Product Item -->
                <tr>
                    <td class="col-desc" style="white-space: pre-line; padding: 5px;">
                        ${order.description || ''}
                    </td>
                    <td class="col-amount" style="vertical-align: top; padding-top: 5px;">
                        ${isReceipt ? (order.total_amount_pre_vat?.toLocaleString('vi-VN') + ' VNĐ') : ''}
                    </td>
                </tr>
                
                <!-- Use a minimum height for visually balanced look -->
                <tr style="height: 50px;">
                   <td></td><td></td>
                </tr>

                <!-- Summary Section (Only for Receipt) -->
                ${isReceipt ? `
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

        <!-- TERMS AND CONDITIONS (Compact) -->
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

            <div class="term-block">
                <b style="font-size: 9pt; text-transform: uppercase;">ĐIỀU KHOẢN IN ẤN:</b><br/>
                <div style="margin-top: 2px;">
                    Quý khách hàng khi đặt hàng in các sản phẩm in ấn tại Công Ty TNHH In P&D (sau đây gọi tắt là P&D), đồng nghĩa với việc khách hàng đã được thông báo, đọc hiểu và đồng ý với các điều khoản sau:
                </div>
                <div style="margin-top: 4px;">
                    <b>1. Thông tin khách hàng:</b><br/>
                    - Khách hàng cam kết các thông tin về nhân thân chính chủ (Họ và tên, số điện thoại, email,...) mà khách hàng sử dụng để liên hệ và làm việc với P&D là hợp pháp. Không có bất kỳ việc sử dụng thông tin cá nhân không chính chủ và bất hợp pháp nào để tạo đơn hàng, nếu có Khách hàng chịu mọi trách nhiệm trước Pháp luật.<br/>
                    - Công Ty TNHH In P&D không có trách nhiệm phải xác minh, biết hoặc phải biết thông tin của Khách hàng liên hệ với P&D là hợp pháp hay không. Trong trường hợp P&D nhận thấy có bất kỳ bằng chứng nào cho thấy Khách hàng sử dụng thông tin cá nhân trái phép hoặc khi có yêu cầu của cơ quan có thẩm quyền, P&D sẽ bảo lưu quyền của mình: miễn trách nhiệm bồi thường cho Khách hàng và bên thứ ba khác (nếu có); Khách hàng hoàn toàn chịu mọi trách nhiệm trước Pháp luật.<br/>
                    - Các thông tin về sản phẩm hoặc các thông tin, trao đổi khác có liên quan đến sản phẩm, P&D sẽ liên hệ Khách hàng qua số điện thoại, tài khoản zalo, email, ... mà khách hàng đã cung cấp.
                </div>
                 <div style="margin-top: 4px;">
                    <b>2. Nội dung sản phẩm in:</b><br/>
                    - Khách hàng cam kết Nội dung sản phẩm in không chứa các nội dung sau:<br/>
                    a) Tuyên truyền chống Nhà nước Cộng hòa xã hội chủ nghĩa Việt Nam; phá hoại khối đại đoàn kết toàn dân tộc.<br/>
                    b) Tuyên truyền kích động chiến tranh xâm lược, chủ nghĩa khủng bố, chủ nghĩa li khai, gây hận thù, chia rẽ giữa các dân tộc và nhân dân các nước; kích động bạo lực; truyền bá tư tưởng phản động, lối sống dâm ô, đồi trụy, hành vi tội ác, tệ nạn xã hội, mê tín dị đoan, phá hoại thuần phong mỹ tục.<br/>
                    c) Tiết lộ bí mật nhà nước, bí mật đời tư của cá nhân và bí mật khác do pháp luật quy định.<br/>
                    d) Thông tin sai sự thật, xuyên tạc lịch sử, phủ nhận thành tựu cách mạng; xúc phạm dân tộc, danh nhân, anh hùng dân tộc; sử dụng hình ảnh bản đồ Việt Nam nhưng không thể hiện hoặc thể hiện không đúng chủ quyền quốc gia; vu khống, xúc phạm uy tín của cơ quan, tổ chức và danh dự, nhân phẩm của cá nhân.
                </div>
                 <div style="margin-top: 4px;">
                    <b>3. Quyền và trách nhiệm đối với sản phẩm in:</b><br/>
                    - Khách hàng là người có đầy đủ quyền đặt in, gia công sau in, chế bản đối với các sản phẩm mà khách hàng đặt in tại P&D, và chịu toàn bộ trách nhiệm trước pháp luật cho bất kỳ nghĩa vụ nào đối với cá nhân, tổ chức khác (nếu có).<br/>
                    - Sản phẩm in không xâm phạm đến quyền sở hữu trí tuệ hoặc quyền và lợi ích hợp pháp của cá nhân, tổ chức khác (nếu có).<br/>
                    - Sản phẩm in không dùng cho mục đích làm giả giấy tờ của cơ quan nhà nước, trực tiếp hoặc gián tiếp sản xuất hàng giả hoặc phát tán nội dung vi phạm quy định pháp luật.<br/>
                    - P&D không có trách nhiệm tìm hiểu, xác minh, biết hoặc phải biết mục đích sử dụng dịch vụ của Khách hàng hoặc các nội dung của sản phẩm mà Khách hàng đặt in có vi phạm quyền sở hữu trí tuệ hay các quy định khác của pháp luật có liên quan.
                </div>
            </div>
        </div>
      </div>
      <script>
        window.onload = function() { window.print(); }
      </script>
    </body>
    </html>
    `;
};
