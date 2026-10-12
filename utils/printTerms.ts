// NGUỒN DUY NHẤT của "Điều khoản dịch vụ in ấn".
// Dùng chung cho phiếu in (utils/printGenerator.ts) và trang tra cứu công khai (components/TrackingPage.tsx).
// Sửa chữ ở ĐÂY, không chép lại ở nơi khác.
// Các chỗ ⚠ (thời hạn lưu hồ sơ 24 tháng, khiếu nại 03 ngày) cần chủ xưởng / luật sư xác nhận.

export interface PrintTermsClause {
    /** Nội dung khoản (đã gồm số khoản, vd "1.1. ..."). */
    text: string;
    /** Các mục con a), b), c)... (đã gồm nhãn). */
    items?: string[];
}

export interface PrintTermsArticle {
    title: string;
    clauses: PrintTermsClause[];
}

export const PRINT_TERMS_TITLE = 'ĐIỀU KHOẢN DỊCH VỤ IN ẤN';

export const PRINT_TERMS_INTRO =
    'Khi đặt in tại Công ty TNHH In P&D (sau đây gọi tắt là P&D), Khách hàng xác nhận đã được thông báo, đọc, hiểu và đồng ý toàn bộ các điều khoản dưới đây. ' +
    'Điều khoản là một phần không tách rời của phiếu đặt hàng/báo giá/hợp đồng. ' +
    'Việc Khách hàng ký tên, hoặc xác nhận "Đồng ý" qua Zalo/email/biểu mẫu trực tuyến, hoặc thanh toán đặt cọc, được hiểu là chấp thuận điều khoản.';

export const PRINT_TERMS_ARTICLES: PrintTermsArticle[] = [
    {
        title: 'Điều 1. Thông tin khách hàng',
        clauses: [
            { text: '1.1. Khách hàng cung cấp thông tin trung thực, chính xác về họ tên, số điện thoại, email, địa chỉ và các thông tin khác dùng để liên hệ, đặt hàng; các thông tin này thuộc quyền sử dụng hợp pháp của Khách hàng. Nghiêm cấm dùng thông tin của người khác hoặc thông tin giả mạo để tạo đơn hàng.' },
            { text: '1.2. Trường hợp đặt in cho tổ chức, người đặt hàng cam kết có thẩm quyền đại diện hoặc được ủy quyền hợp lệ.' },
            { text: '1.3. Theo quy định về hoạt động in, P&D có quyền yêu cầu Khách hàng xuất trình và lưu bản sao giấy tờ nhân thân, giấy tờ pháp lý của tổ chức (đăng ký doanh nghiệp, giấy ủy quyền…) và xác nhận mẫu in (chữ ký, dấu hoặc xác nhận bằng tin nhắn điện tử). Khách hàng không cung cấp thì P&D có quyền từ chối nhận in.' },
            { text: '1.4. P&D liên hệ Khách hàng về sản phẩm và các trao đổi liên quan qua số điện thoại, Zalo, email mà Khách hàng đã cung cấp.' },
            { text: '1.5. Nếu phát hiện Khách hàng dùng thông tin trái phép/giả mạo hoặc khi có yêu cầu hợp pháp của cơ quan có thẩm quyền, P&D có quyền từ chối, tạm dừng, hủy đơn và Khách hàng hoàn toàn chịu trách nhiệm trước pháp luật.' },
        ],
    },
    {
        title: 'Điều 2. Dữ liệu cá nhân',
        clauses: [
            { text: '2.1. P&D xử lý dữ liệu cá nhân của Khách hàng để: tiếp nhận và thực hiện đơn hàng, thanh toán, giao nhận, bảo hành/khiếu nại, và tuân thủ nghĩa vụ pháp luật, yêu cầu của cơ quan có thẩm quyền.' },
            { text: '2.2. Khách hàng đồng ý cho P&D xử lý dữ liệu cho các mục đích trên. Khách hàng có quyền yêu cầu truy cập, chỉnh sửa, rút lại đồng ý hoặc xóa dữ liệu theo quy định pháp luật bằng cách liên hệ hotline/Zalo của P&D; việc rút lại có thể khiến P&D không thể tiếp tục thực hiện đơn hàng.' },
            { text: '2.3. P&D chỉ chia sẻ dữ liệu cho đơn vị vận chuyển, thanh toán phục vụ đơn hàng và cơ quan nhà nước có thẩm quyền; không bán dữ liệu cho bên thứ ba.' },
            { text: '2.4. Nếu nội dung in chứa dữ liệu cá nhân, hình ảnh của người khác (ảnh chân dung, họ tên, số điện thoại, danh sách…), Khách hàng cam kết đã được sự đồng ý của chủ thể dữ liệu và chịu trách nhiệm về việc đó.' },
        ],
    },
    {
        title: 'Điều 3. Nội dung sản phẩm in và cam kết của Khách hàng',
        clauses: [
            { text: '3.1. Khách hàng cam kết là chủ sở hữu hoặc được chủ sở hữu cho phép/ủy quyền hợp pháp đối với toàn bộ nội dung, hình ảnh, nhãn hiệu, phông chữ, tác phẩm… đặt in.' },
            {
                text: '3.2. Khách hàng cam kết nội dung sản phẩm in không chứa:',
                items: [
                    'a) Tuyên truyền chống Nhà nước Cộng hòa xã hội chủ nghĩa Việt Nam; phá hoại khối đại đoàn kết toàn dân tộc.',
                    'b) Tuyên truyền kích động chiến tranh xâm lược, chủ nghĩa khủng bố, chủ nghĩa li khai, gây hận thù, chia rẽ giữa các dân tộc và nhân dân các nước; kích động bạo lực; truyền bá tư tưởng phản động, lối sống dâm ô, đồi trụy, hành vi tội ác, tệ nạn xã hội, mê tín dị đoan, phá hoại thuần phong mỹ tục.',
                    'c) Tiết lộ bí mật nhà nước, bí mật đời tư của cá nhân và bí mật khác do pháp luật quy định.',
                    'd) Thông tin sai sự thật, xuyên tạc lịch sử, phủ nhận thành tựu cách mạng; xúc phạm dân tộc, danh nhân, anh hùng dân tộc; sử dụng bản đồ Việt Nam nhưng không thể hiện hoặc thể hiện không đúng chủ quyền quốc gia (kể cả Hoàng Sa, Trường Sa); vu khống, xúc phạm uy tín của cơ quan, tổ chức và danh dự, nhân phẩm của cá nhân.',
                    'đ) Làm giả hoặc mô phỏng giống thật: giấy tờ, con dấu, tài liệu của cơ quan, tổ chức; thẻ, bằng cấp, chứng chỉ; tiền, giấy tờ có giá, tem, vé, hóa đơn, chứng từ; hàng giả.',
                    'e) Xâm phạm quyền sở hữu trí tuệ của bên thứ ba: sao chép trái phép tác phẩm, hình ảnh, phông chữ, phần mềm, nhãn hiệu, kiểu dáng, nhân vật; hàng nhái.',
                    'g) Quảng cáo hàng hóa, dịch vụ bị cấm hoặc không đủ điều kiện quảng cáo; quảng cáo sai sự thật, gây nhầm lẫn; vi phạm Luật Quảng cáo.',
                    'h) Sử dụng hình ảnh, giọng nói, thông tin của người khác khi chưa được đồng ý; xâm phạm đời tư.',
                    'i) Sử dụng trái quy định quốc kỳ, quốc huy, quốc ca, Đảng kỳ, hình ảnh lãnh tụ, biểu tượng, tên gọi của cơ quan nhà nước, lực lượng vũ trang.',
                    'k) Cờ bạc, cá độ, lô đề, cho vay nặng lãi, đa cấp trái phép, lừa đảo; hàng hóa, dịch vụ bị cấm kinh doanh; các nội dung khác bị pháp luật cấm.',
                ],
            },
            { text: '3.3. Sản phẩm in không dùng để làm giả giấy tờ, sản xuất hoặc tiêu thụ hàng giả, hoặc phát tán nội dung vi phạm pháp luật, dù trực tiếp hay gián tiếp.' },
            { text: '3.4. Với nội dung do P&D thiết kế theo yêu cầu, hình ảnh/tài liệu tham khảo do Khách hàng cung cấp vẫn thuộc trách nhiệm của Khách hàng theo mục 3.1–3.3.' },
        ],
    },
    {
        title: 'Điều 4. Giấy tờ và điều kiện nhận in theo loại sản phẩm',
        clauses: [
            {
                text: '4.1. Tùy loại sản phẩm, pháp luật có yêu cầu giấy tờ khác nhau. Khách hàng có nghĩa vụ cung cấp trước khi in, và P&D chỉ sản xuất sau khi nhận đủ:',
                items: [
                    'a) Xuất bản phẩm, tài liệu không kinh doanh (sách, báo, tạp chí, kỷ yếu, nội san, tài liệu hội nghị/hội thảo… thuộc diện phải cấp phép): giấy phép xuất bản/quyết định xuất bản/hợp đồng với đơn vị xuất bản theo quy định.',
                    'b) Bao bì, nhãn hàng hóa, tem nhãn, sản phẩm mang nhãn hiệu/thương hiệu của bên thứ ba: giấy chứng nhận đăng ký nhãn hiệu, hợp đồng hoặc giấy ủy quyền cho phép sử dụng, giấy tờ công bố/đăng ký sản phẩm (nếu pháp luật yêu cầu).',
                    'c) Quảng cáo hàng hóa, dịch vụ thuộc diện phải xác nhận/cấp phép nội dung (thuốc, thực phẩm chức năng, mỹ phẩm, khám chữa bệnh, tài chính, bất động sản, giáo dục…): giấy tờ chứng minh đủ điều kiện kinh doanh/quảng cáo.',
                    'd) Sản phẩm khác theo quy định pháp luật hoặc theo yêu cầu hợp lý của P&D.',
                ],
            },
            { text: '4.2. Thời gian giao hàng chỉ tính từ khi Khách hàng cung cấp đủ giấy tờ và duyệt mẫu. Việc chậm cung cấp không phải lỗi của P&D.' },
            { text: '4.3. P&D có quyền từ chối nhận in những sản phẩm vượt ngoài phạm vi giấy phép, điều kiện pháp lý hoặc năng lực của P&D (như xuất bản phẩm, tem chống giả, giấy tờ có giá, sản phẩm có yêu cầu bảo mật).' },
        ],
    },
    {
        title: 'Điều 5. Duyệt mẫu và trách nhiệm đối với nội dung',
        clauses: [
            { text: '5.1. Trước khi in, P&D gửi mẫu/bản thiết kế để Khách hàng duyệt. Khách hàng kiểm tra kỹ nội dung, chính tả, số liệu, thông tin liên hệ, hình ảnh, kích thước, màu sắc và xác nhận bằng chữ ký hoặc tin nhắn (Zalo/email) trước khi sản xuất.' },
            { text: '5.2. Sau khi Khách hàng đã duyệt, mọi sai sót thuộc nội dung đã duyệt do Khách hàng chịu trách nhiệm; chi phí in lại (nếu có) do Khách hàng chi trả.' },
            { text: '5.3. Với file do Khách hàng cung cấp, P&D không chịu trách nhiệm về lỗi file (thiếu font, độ phân giải thấp, hệ màu, thiếu tràn lề…) nếu không nhận xử lý và đã nhắc trước khi in.' },
            { text: '5.4. Màu in có thể chênh lệch so với màn hình ở mức dung sai thông thường của ngành in.' },
        ],
    },
    {
        title: 'Điều 6. Quyền kiểm tra, từ chối và phối hợp với cơ quan có thẩm quyền của P&D',
        clauses: [
            { text: '6.1. P&D kiểm tra tiếp nhận ở mức hợp lý theo quy định về hoạt động in. Việc P&D tiếp nhận, thiết kế hoặc in không đồng nghĩa với việc P&D xác nhận hoặc bảo đảm tính hợp pháp của nội dung.' },
            { text: '6.2. P&D có quyền từ chối, tạm dừng, hủy đơn hoặc ngừng giao hàng khi: (i) nội dung vi phạm hoặc có dấu hiệu vi phạm Điều 3; (ii) Khách hàng không cung cấp giấy tờ theo Điều 1, Điều 4; (iii) thông tin Khách hàng giả mạo hoặc không chính xác; (iv) có yêu cầu của cơ quan có thẩm quyền; (v) sản phẩm vượt khả năng pháp lý của P&D.' },
            { text: '6.3. Khi áp dụng mục 6.2, khoản đã thanh toán được hoàn lại sau khi trừ chi phí thực tế đã phát sinh (thiết kế, vật tư, công đoạn đã thực hiện…). P&D không chịu trách nhiệm về chậm trễ hoặc thiệt hại do việc này gây ra.' },
            { text: '6.4. P&D có quyền cung cấp thông tin, hồ sơ, mẫu in, dữ liệu liên quan cho cơ quan nhà nước có thẩm quyền khi có yêu cầu hợp pháp, và lưu giữ hồ sơ đơn hàng, mẫu in, file in trong thời hạn theo quy định pháp luật (tối thiểu 24 tháng).' },
            { text: '6.5. Sản phẩm bị cơ quan có thẩm quyền thu giữ, tiêu hủy do nội dung của Khách hàng thì chi phí và hậu quả do Khách hàng chịu.' },
        ],
    },
    {
        title: 'Điều 7. Trách nhiệm và bồi thường',
        clauses: [
            { text: '7.1. Khách hàng chịu toàn bộ trách nhiệm trước pháp luật (dân sự, hành chính, hình sự) về nội dung, bản quyền, tính hợp pháp của sản phẩm đặt in và hồ sơ đã cung cấp.' },
            { text: '7.2. Khách hàng bồi thường và bảo đảm P&D không bị thiệt hại cho mọi tổn thất, chi phí hợp lý (tiền phạt, chi phí giải quyết tranh chấp, luật sư, hàng hóa/vật tư bị thu giữ…) phát sinh do khiếu nại của bên thứ ba hoặc xử lý của cơ quan có thẩm quyền liên quan đến nội dung, hồ sơ do Khách hàng cung cấp.' },
            { text: '7.3. Điều khoản này không loại trừ trách nhiệm của P&D đối với lỗi do P&D gây ra trong thiết kế/sản xuất/giao hàng, cũng như quyền lợi của người tiêu dùng theo quy định pháp luật.' },
        ],
    },
    {
        title: 'Điều 8. Nhận hàng và khiếu nại',
        clauses: [
            { text: '8.1. Khách hàng kiểm tra số lượng, quy cách, chất lượng khi nhận hàng và thông báo lỗi do sản xuất trong vòng 03 ngày kể từ ngày nhận. P&D xử lý (in lại/giảm giá) với lỗi thuộc trách nhiệm của P&D.' },
            { text: '8.2. P&D giữ sản phẩm cho đến khi Khách hàng thanh toán đủ theo thỏa thuận.' },
        ],
    },
    {
        title: 'Điều 9. Điều khoản chung',
        clauses: [
            { text: '9.1. Áp dụng pháp luật Việt Nam. Tranh chấp ưu tiên thương lượng; không thành thì giải quyết tại Tòa án có thẩm quyền nơi P&D đặt trụ sở.' },
            { text: '9.2. Nếu một điều khoản bị vô hiệu, các điều khoản còn lại vẫn có hiệu lực.' },
            { text: '9.3. P&D có quyền cập nhật điều khoản theo quy định pháp luật; bản mới công bố tại trang tra cứu đơn hàng và áp dụng cho đơn đặt từ ngày cập nhật.' },
        ],
    },
];
