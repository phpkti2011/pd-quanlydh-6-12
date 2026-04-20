-- Import Customers Data via Bulk Insert

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0002', 'Cty Cp 1office', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0004', 'HIỀN - IN CHẤT LƯỢNG VIỆT', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0005', 'THUỲ DUNG 0973871850', '0973871850', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0006', 'THUỴ VŨ', '0938.567.885', NULL, 'phpkti2011', NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0007', 'LỘC - IN CHẤT LƯỢNG VIỆT', '0985799997', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0008', 'Quân Hồ', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0009', 'PHƯƠNG UYÊN - 0776129309', '0776129309', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0010', 'TRẦN KHÔI', '0917304105', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0011', 'JENDY TRƯƠNG', '0377.777.171', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0012', 'KIM NGÂN', '0839323971', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0013', 'PHÚC NGUYỄN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0014', 'NHÀ HÀNG BINGO', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0015', 'TRỊNH NAM', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0017', 'YẾN NGUYỄN', '0901346401', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0018', 'ĐÔNG HÀ', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0019', 'AN - MAP', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0020', 'NHI THÁI', '0912336495', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0021', 'ZALO NGỌC', '097414 5588', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0022', 'ZALO NHI', '0939281302', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0023', 'ANH MINH', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0024', 'MINH NGUYỆT', '0931791393', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0025', 'HÀ PHƯƠNG - MAP', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0026', 'LAC TRUONG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0027', 'PHÚ - MAP', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0028', 'SANG - MAP', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0029', 'TIỆM VÀNG THANH TÂM', '0326771134', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0030', 'ERIC LÊ', '0982055573', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0031', 'QUỐC CỘNG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0032', 'THÁI', '0902288186', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0033', 'MINH HƯNG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0034', 'ANNA DO LINH', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0035', 'ANH BẢO', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0036', 'HOÀNG KHA', '0947545417', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0037', 'THIÊN THANH', '0919852239', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0038', 'THY', '0762259815', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0039', 'THU VÂN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0040', 'HUỲNH QUANG', '0396278155', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0041', 'NGỌC CHÂU', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0042', 'NỮ HOÀNG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0043', 'THANH VY', '0785208468', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0044', 'LINH LEE', '0909021386', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0045', 'JONATHAN NGUYỄN - 0936038198 - FB', '0936038198', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0046', 'LÀM HỘP GIẤY', '0382242939', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0047', 'PHƯƠNG PHẠM', 'nhà xe thanh công. Ng nhận : Nguyễn Minh Khuê sdt : 0962.667.417 địa chỉ : 548 Bình Tiến, An Bình, Phú Giáo, Bình Dương', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0048', 'CƠM GÀ ĐÔNG NGUYÊN', 'Công ty thái mậu', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0049', 'BẢO KỲ', 'khách vãng lai', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0053', 'PHƯƠNG NAM', '0908163028', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0054', 'IN CLC', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0055', 'NGUYỆT NHI', '0383991832', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0056', 'NAM PHƯƠNG', '0352377662', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0057', 'UNG UYÊN', '0779707879', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0058', 'THUỲ LINH', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0059', 'TRÀ SỮA BEO BÉO', '0334763730', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0060', 'UYÊN', '0913665830', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0061', 'JEROME BOLLET', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0062', 'THANH SANG ZALO', 'decal trong tái bản', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0063', 'DANIEL HOÀNG', '0938113261', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0064', 'ZALO TRINH', '0329171568', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0065', 'THIỆN', '0932546988', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0066', 'MINH ANH', '0973444834', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0067', 'TRISTY', '0974745678', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0068', 'MAI HƯƠNG', '0936075782', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0069', 'YẾN XÀO KIM QUYÊN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0070', 'CATCHERS', '0329711395', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0071', 'PHƯƠNG MAI', '0901870036', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0072', 'ENDY LĂNG', '0973332718', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0073', 'HOA NGUYEN', '0901666946', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0074', 'PHƯƠNG BÌNH FILE', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0075', 'NGA', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0076', 'THANH SANG _MA', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0077', 'THANH SANG - MAP', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0078', 'LÊ SƠN HÀ', 'công nợ, gần nhà anh phúc', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0079', 'KIM LÊ', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0081', 'PHƯƠNG DUNG', '0908123509', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0082', 'MỘC F&B', '0379619915', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0083', 'PHƯƠNG THẢO', '0902058588', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0084', 'MẪN CTY RINGO', '0333033138', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0085', 'CÔNG TY IN P&D', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0086', 'HOÀNG NGỌC ANH', 'B01 Nam Thông 2A Phú Mỹ Hưng P Tân Phú Quận 7', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0087', 'DYNAGRO', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0088', 'PHƯƠNG NHI', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0089', 'LILY HOÀNG', '0918420027', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0090', 'THUỲ HƯƠNG', '0353679672', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0091', 'ĐÔNG HÀ', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0092', 'TĂNG THẢO VY', '0919919319', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0093', 'LABENE', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0094', 'JOE LE', '0933307106', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0095', 'Trần Thịnh (zalo Phúc)', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0096', 'KIỀU TRANG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0097', 'TUẤN KTI', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0098', 'ANNIE HUỲNH', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0099', 'CHỊ HAI', 'Khách của duy tke', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0100', 'TIỂU MI', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0101', 'HƯNG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0102', 'OANIE LAM', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0103', 'CAM THUY', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0104', 'UYÊN UYÊN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0105', 'QUỐC ĐỊNH', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0106', 'PHẠM TRUNG DŨNG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0107', 'MINH THƯ', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0108', 'VÕ TRUNG NGHĨA', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0109', 'HẠO TRẦN', 'khách in voucher, bạt, menu ép plastic', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0110', 'NELSON', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0111', 'HALEHOANGDUNG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0112', 'PHƯƠNG THẢO', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0113', 'QUỐC BẢO', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0114', 'ANH VINH VPA', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0115', 'KEI', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0116', 'HERA', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0117', 'NGUYỄN LUÔN VUI', '0766221386', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0118', 'NAM LÊ', '0398791757', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0119', 'VÕ NGUYÊN HOÀNG', '0934050279', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0120', 'MAI PHƯƠNG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0121', 'QUỲNH ANH', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0122', 'UYỂN NHI', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0123', 'HIỀN THANH', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0125', 'KIM THU', 'cafe trần long. in decal khổ lớn', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0126', 'ĐẠT NGUYỄN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0127', 'CHÍ THIỆN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0128', 'THANH TIÊN', '0939959611', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0129', 'THÙY GIANG HHB', '0936263328', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0130', 'TRÌNH', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0131', 'CHỊ HUỲNH', 'in decal giấy', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0132', 'MINH KHÔI', 'In giấy', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0133', 'THANH NHÃ', '0397494514', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0134', 'thy', '0762259815', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0135', 'CTY LOGISTAR', 'in decal, cắt thành phẩm', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0136', 'THẢO PHƯƠNG', 'khách in cataloge', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0137', 'ANH CƯỜNG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0138', 'TRÚC PHẠM', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0139', 'UYEN DANG', 'Khách in standee, cataloge', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0140', 'HIỀN AMY', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0141', 'KATI NGUYEN FB', '0948331138', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0142', 'LÊ MỸ TRINH', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0143', 'MINH PHƯỢNG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0144', 'DUY LÊ', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0145', 'VŨ VĂN SÁNG', 'báo có hàng xong ship code hoặc báo tiền ship', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0146', 'TIỆM TRÀ RITEA', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0147', 'RON HUỲNH', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0148', 'MAI', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0149', 'THÁI THANH THỊNH', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0150', 'PANDA NÈ', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0151', 'MỸ NHUNG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0152', 'NGỌC ÁNH', '979642056', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0153', 'NGHĨA VĂN THIA', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0154', 'LAN ANH', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0155', 'HÂN NGUYỄN', 'ZALO', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0156', 'OM NƯỚNG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0157', 'MỸ HẰNG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0158', 'HẢI YẾN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0159', 'THE PHAN', 'in decal si bạc', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0160', 'LINH HANNAH', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0161', 'THẢO NGUYỄN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0162', 'NGAN TRAN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0163', 'TÍT NHUNG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0164', 'HOÀNG MY', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0165', 'HUỲNH NHƯ GRANCE', 'khách c dung', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0166', 'QUẾ NGHI', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0167', 'NGUYỄN LONG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0168', 'ANDY BẢO', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0169', 'CHÂU', 'ZALO', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0170', 'ROSIE NGUYỄN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0171', 'THU HIỀN', 'decal', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0172', 'ANNI - TRẦN KHÔI', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0173', 'LƯƠNG YẾN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0174', 'QUẾ TRINH', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0176', 'NGUYỄN THUỶ', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0177', 'LASHVE', 'in tem, sticker', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0178', 'DƯ LINH', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0179', 'PHAN THANH NGHĨA', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0180', 'CTY SAB', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0181', 'CTY THIÊN AN', 'in tem', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0182', 'KIM NGÂN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0183', 'PHAPS', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0184', 'NGUYỄN THÁI LÂM', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0185', 'MOONNIE', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0186', 'LETTKD LÊ - FB', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0187', 'WIN TRẦN HUY', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0189', 'CTY UPSV', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0190', 'XUÂN QUI', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0191', 'TÔ UYÊN', 'card', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0192', 'PHẠM LINH', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0193', 'APEC PHAN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0194', 'THẢO NT', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0195', 'HACHI', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0196', 'YẾN LINH - NẮNG YÊU FB', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0197', 'DIỄM NGÂN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0198', 'THANH HIỀN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0199', 'TRƯƠNG NGỌC', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0200', 'EMILY NHUNG QUACH', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0201', 'CHUU', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0202', 'PHẠM MAI NGÂN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0203', 'NGỌC LINH', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0204', 'TIỂU PHỤNG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0205', 'MINH HƯNG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0206', 'TRÀ MAI', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0207', 'QUÝ THƯƠNG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0208', 'Pham Hung Son', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0209', 'IFA LTD', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0210', 'IFA LTD', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0211', 'TRUNG HẬU', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0212', 'HÙNG ANH', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0213', 'TÀI TRỢ IN ẤN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0214', 'ANH TUẤN KTI', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0215', 'TRƯỜNG TINY FLOWER', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0216', 'HỒNG NHUNG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0217', 'LÊ KIM CHI', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0218', 'THANH TUYỀN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0219', 'THANH NGÂN', 'in pp', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0221', 'THẢO', '974856795', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0222', 'THẢO NGUYÊN', '933797575', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0223', 'HOA NGUYỄN', 'in pp', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0224', 'NGUYỄN VŨ PHƯƠNG DUNG', '973676024', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0225', 'THÚY HẰNG NGUYỄN', '962065353', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0226', 'NGÔ VIỆT HOÀNG', '383530600', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0227', 'JOHN THỊNH', '909997832', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0228', 'TRƯƠNG UYÊN', '906689705', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0229', 'HÀN NGUYỄN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0230', 'TRẦN THANH', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0231', 'HẠNH NHIÊN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0232', 'THƯ', 'ZALO', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0233', 'NICOLAS NGUYỄN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0234', 'TRẦN THƯ', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0235', 'MỸ HẰNG', '091 7287731', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0236', 'NGUYÊN CƯỜNG AMARA', '342164413', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0237', 'VŨ MINH HIỀN', '949213393', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0238', 'THIÊN THIỆN-', '333931739', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0239', 'CAO KỲ', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0240', 'MINH TRƯƠNG', 'Khách vãng lai', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0241', 'MINH THÙY', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0242', 'LÊ VĂN HƯNG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0243', 'NGỌC THU HUỲNH', 'lễ 30/4', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0244', 'MS THÚY LÌ', '901583939', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0245', 'CẨM NINH', 'in cho nhà hàng', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0246', 'THẢO QUYÊN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0247', 'THANH THẢO', '776678886', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0248', 'ANH KHOA FB', '989801134', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0249', 'ZALO LY', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0250', 'SAM TRẦN FB', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0251', 'CÔ XIÊN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0252', 'HOANG TAN THANH', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0253', 'THAO NGUYEN fb', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0254', 'HIẾU', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0255', 'TRẦN TRÚC', '971613695', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0256', 'MINH VU', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0257', 'THANH NHÀN', '334804364', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0259', 'ZALO VIVI', 'in sticker giá cố định', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0260', 'NHẬT UYÊN', '932171616', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0261', 'THY ENY-', '963253341', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0262', 'HOÀNG DUNG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0263', 'THẢO LY', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0264', 'BENNY NGUYỄN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0265', 'KIM THOA MANGO TRAVEL', '898319280', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0266', 'MY LƯƠNG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0268', 'Võ Anh Nhân - FB - 088 6699 789', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0269', 'NGUYỄN THỊ NGỌC SANG - 097 1300048', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0270', 'NGUYỄN THỊ DIỄM LINH', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0271', 'HUỲNH NGỌC', 'zalo', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0272', 'CHỊ HỒNG', '326885735', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0273', 'NGUYỄN HOÀNG MI-0903067175', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0274', 'QUỲNH TINA', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0275', 'til', '942914416', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0276', 'DANG YEN', '934765707', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0277', 'MINH ANH Flooring Tech', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0278', 'AMANDA', 'pp ko keo', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0279', 'PINK LÙN', '937725990', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0280', 'KIỀU VƯƠNG', '968712672', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0281', 'HẢI TRIỀU AUTO', '938584113', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0282', 'NHẬT VY', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0283', 'FB SU KEM', '984612896', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0285', 'HẬU', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0286', 'NGỌC NGÂN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0287', 'PHẠM LÊ', '934995884', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0288', 'LISA', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0289', 'ZALO CÁ', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0290', 'DUY KHÁNH ZALO', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0291', 'MINH CHÂU', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0292', 'NGUYỄN THÚY', '902627546', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0293', 'HỒNG OANH-', '364899207', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0294', 'ANH VINH-', '939833456', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0295', 'HOÀNG LỘC', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0296', 'NGUYỄN VĂN AN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0297', 'MẠNH HÙNG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0298', 'LỘC', '789901900', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0299', 'HẨU HẨU FB', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0300', 'NGUYỄN NGHỊ', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0301', 'SƠN VÕ', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0302', 'ISAVE', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0303', 'PHÓ ĐỨC DUY', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0304', 'PHƯƠNG ÁNH', '819602402', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0305', 'CHỊ THÚY', '904365735', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0306', 'Pham Tran Nhu Quynh', '969180199', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0307', 'MINH THI', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0308', 'IN VIỆT XINH', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0309', 'QUÝ TRẦN', '942223023', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0310', 'TRƯƠNG CÔNG HÙNG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0311', 'CHỮ HƯƠNG', '090 4994134', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0312', 'THÀNH ĐẠT NGUYỄN', '947014121', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0313', 'PHAN TẤN SANG', '329950803', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0314', 'HÙNG LÝ', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0315', 'MAI TRẦN', '932626207', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0316', 'NƯỚC UỐNG M KITECH', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0317', 'PHÚC HẬU', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0318', 'PHAN PHƯƠNG UYÊN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0319', 'NGUYỄN PHẤN', '787634931', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0320', 'UYỂN TRINH', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0321', 'THÙY MAI', '399310514', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0322', 'VÂN NGUYỄN', '907360473', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0323', 'SPS', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0324', 'QUÂN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0325', 'DUY', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0326', 'PHONG ĐỖ', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0327', 'KIM LOAN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0328', 'ANHTUAN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0329', 'MẪN MẪN', '706017267', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0330', 'NGUYỄN NHẬT VY', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0331', 'TÔ THANH LIÊM', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0332', 'ANH GIANG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0333', 'NHÂN THIỆN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0334', 'NHƯ HẢO', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0335', 'ĐOÀN VÂN BẢO ANH', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0336', 'LÊ HOÀNG KHÁNH', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0337', 'TUẤN NGUYỄN VINHOMES', '876.814.125', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0338', 'VŨ PHƯƠNG THẢO', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0339', 'INTELPACK', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0340', 'THUY PHAN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0341', 'THÙY DUNG FORMEX', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0342', 'TRÚC MKT', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0343', 'PHƯƠNG TIPI', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0344', 'VŨ-0939511759', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0345', 'THÚY HUYỀN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0346', 'NGUYỄN HUỲNH GIA BẢO', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0347', 'THỊNH NGUYỄN', '935401723', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0348', 'TRỌNG SỸ', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0349', 'CTY GTY', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0350', 'TUYẾT NGUYỄN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0351', 'PHƯƠNG THANH', '938047936', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0352', 'THANH NGUYỄN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0353', 'NGUYỄN XUÂN BÌNH', '779357979', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0354', 'KHẢ MI', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0355', 'LƯƠNG PHÚC HẬU', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0356', 'MINH TÂM', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0357', 'LINH TRƯƠNG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0358', 'QUÝ', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0359', 'JUN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0360', 'MY NGUYEN TRAN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0361', 'TRINH NGOC THOA', 'zalo', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0362', 'NGUYỄN CHI', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0363', 'NG VŨ', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0364', 'HẠ', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0365', 'MỘC HEALTHY', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0366', 'HÀ PHƯƠNG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0367', 'TRỌNG LÂM', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0368', 'TRACY ONG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0369', 'ĐINH THANH TRÚC', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0370', 'ĐỖ TIẾN DANH', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0371', 'NGỌC CHÂU', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0372', 'HÀ NGUYỄN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0373', 'KHƯƠNG EMER', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0374', 'KIẾN HƯNG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0375', 'NGUYỄN VIỆT TRÂM', '934055952', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0376', 'ANH THƯ', '392025880', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0377', 'LEV', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0378', 'CHÚ DŨNG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0379', 'ASI', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0380', 'CÔNG TY TNHH INBODY VIETNAM', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0381', 'THÙY DƯƠNG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0382', 'UYÊN DOÃN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0383', 'WINGS', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0384', 'MINH PHƯỢNG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0385', 'WUYNHU', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0386', 'MINH TRANG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0387', 'Kim Oanh', 'zalo', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0388', 'THỤC KIỀU SHOP', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0389', 'LEE HUI MENG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0390', 'LING CHEN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0391', 'TRINH TRINH', '939784272', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0392', 'THÚY HẰNG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0393', 'NGỌC TRANG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0394', 'TẤN PHONG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0395', 'MR NGHI', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0396', 'THANH NGÂN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0397', 'TAEWOO', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0398', 'BARBIE PRINCESS', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0399', 'HIÊN SAPO', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0400', 'PHU VO', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0401', 'NGUYỄN NHI', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0402', 'MS DAK', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0403', 'XUAN THUY', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0404', 'KIM NGÂN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0405', 'KARA LE', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0406', 'THÀNH NAM', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0407', 'DUY LINH', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0408', 'PHƯƠNG UYÊN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0409', 'DUYÊN LÊ', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0410', 'QUANG ANH', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0411', 'THÁI ANH DƯƠNG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0412', 'VÕ THỌ', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0413', 'VIỆT HUY', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0414', 'HOÀNG KHANH', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0415', 'HUY TRỰC NGUYỄN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0416', 'HOAIHT', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0417', 'TRẦN XUÂN PHÚC', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0418', 'VY', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0419', 'HOAIHT', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0420', 'KIM THÀNH', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0421', 'PHƯƠNG LINH', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0422', 'VIÊN NGÔ', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0423', 'CHÚ DŨNG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0424', 'THẢO NHI', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0425', 'KHÁNH TÚ', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0426', 'NGUYỄN ĐỨC THIÊN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0427', 'BN UYÊN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0428', 'TRẦN VŨ', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0429', 'PHẠM LÊ HỒNG YẾN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0430', 'MIU ZALO', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0431', 'HUỲNH DIỆP', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0432', 'HẢI BẰNG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0433', 'TRỊNH NGUYỄN HÀ VY', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0434', 'YOGURT', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0435', 'NGỌC GIÀU', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0436', 'TUẤN ANH ĐỖ', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0437', 'LÊ NHI', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0438', 'BICH LIEN MANG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0439', 'TRÚC LINH', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0440', 'GAM', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0441', 'UYÊN THƠ', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0442', 'THẮM NGUYỄN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0443', 'VY VŨ', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0444', 'MINH NHƯ', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0445', 'TRÚC NHỎ', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0446', 'KHẢI', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0447', 'LINH NGUYỄN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0448', 'THU HIỀN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0449', 'CẨM UYÊN', 'ZALO', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0450', 'TIẾN MẠNH', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0451', 'SANDY', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0452', 'TRÍ TRỊNH', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0453', 'THẠCH TRẦN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0454', 'LÊ PHƯƠNG ANH', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0455', 'TÚ ANH NGUYỄN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0456', 'KHẢ ANH', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0457', 'HONG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0458', 'HONGTRAN CHANH DUY TAM', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0459', 'CCC REAL', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0460', 'KIM SAA', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0461', 'THƯ QUỲNH', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0462', 'KHÁNH TIÊN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0463', 'LOAN PHẠM', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0464', 'CHÍ TOÀN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0465', 'JOSIE PHAM', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0466', 'KIM DUYÊN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0467', 'CTY SSQC', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0468', 'HAMI UNI', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0469', 'VƯƠNG HOÀNG THẢO', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0470', 'MINH THIỆN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0471', 'QUỲNH NGA', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0472', 'NGỌC PHÚ', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0473', 'HƯNG KN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0474', 'ĐẶNG HOÀNG LONG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0475', 'NGỌC NHI', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0476', 'NANCY NGÂN ĐỖ', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0477', 'NAM NGUYỄN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0478', 'NGUYỄN QUÝ ĐÔN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0479', 'CTY KIM LONG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0480', 'KIM CHI', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0481', 'CHÍ HÀO', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0482', 'CHỊ LISA', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0483', 'QUANG CHIẾN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0484', 'MINH PAE', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0485', 'HỮU PHƯỚC', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0486', 'KIM TOẢ', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0487', 'HOÀNG ANH', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0488', 'NGUYEN MINH CUONG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0489', 'QUANG MINH', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0490', 'CHÍ HIẾU', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0491', 'THAO TRANG LE', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0492', 'MỸ HẠNH LÊ', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0493', 'THUỲ DUNG ZALO', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0494', 'NGUYỄN QUÝ ĐÔN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0495', 'PHONG TRIỆU', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0496', 'LINH PHƯƠNG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0497', 'OANH KIỀU', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0498', 'NGUYỄN ĐÌNH HÓA', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0499', 'MỸ XUÂN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0500', 'GIA THỊNH', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0501', 'CHÂU DIỆP', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0502', 'BẢO HOÀNG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0503', 'THƯ LÊ', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0504', 'HƯNG LONG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0505', 'ANNIE TRẦN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0506', 'DÂU TÂY', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0507', 'KIỀU VƯƠNG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0508', 'HOÀNG YẾN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0509', 'DU CA', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0510', 'MINH VỸ', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0511', 'XUÂN TRÚC', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0512', 'SU', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0513', 'LÊ TẤM', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0514', 'KHÓI THUỐC', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0515', 'VY LÊ', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0516', 'GIA LẬP', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0517', 'PHƯƠNG ANH', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0518', 'CHỊ NA', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0519', 'THUỲ TRANG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0520', 'CHỊ MAY', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0521', 'TODAYTEC', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0522', 'ANH ANDY', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0523', 'LALA', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0524', 'RYN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0525', 'DIỆU HÂN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0526', 'THIÊN TRANG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0527', 'HUY', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0528', 'VÂN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0529', 'PHAN HOÀNG PHƯƠNG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0530', 'ÁNH NGỌC', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0531', 'VƯU ANH', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0532', 'LÝ MINH THỦY', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0533', 'THẮNG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0534', 'CHÚ ÚT', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0535', 'NGUYỄN HÀ QUANG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0536', 'NGA GYM', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0537', 'JOHN NGUYỄN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0538', 'TRÚC', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0539', 'PHẠM PHÚC HẬU', 'zalo', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0540', 'HUYNH NHU', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0541', 'LINH ĐẶNG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0542', 'QUY NGUYEN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0543', 'PHẠM LÂM', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0544', 'MỸ LINH', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0545', 'ĐOÀN THẾ VINH', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0546', 'ĐOÀN THẾ CHÍNH', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0547', 'HIỀN TRẦN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0548', 'HẢI ĐỒNG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0549', 'NHẬT MINH', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0550', 'ANH HOA', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0551', 'CHỊ GIANG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0552', 'KIM ANH', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0553', 'ĐẠI VĂN TRÌNH', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0554', 'TRÂM PHẠM', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0555', 'THẢO LY', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0556', 'NGUYỄN TIẾN THÀNH', 'zalo', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0557', 'KHÁNH HUYỀN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0558', 'BÍCH HỢP', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0559', 'HONG ANH NGUYEN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0560', 'PHƯƠNG LINH', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0561', 'TRƯƠNG THẾ LONG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0562', 'ANH QUỐC', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0563', 'NYO', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0564', 'TRƯƠNG NGỌC HẢI', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0565', 'ANH NGHĨA', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0566', 'ĐÀO THÀNH ĐẠT', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0567', 'MINH TRÍ ĐẶNG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0568', 'TRẦN NGỌC NHƯ', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0569', 'TRÚC QUÂN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0570', 'AT LY', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0571', 'THUY NGUYEN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0572', 'QUỲNH NHƯ', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0573', 'TRẦN THU THẢO', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0574', 'XUÂN SƠN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0575', 'HUỲNH KIỆT', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0576', 'TRƯƠNG NHƯ CAO ANH', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0577', 'ĐĂNG KHOA', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0578', 'HÀNG SAI IN LẠI', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0579', 'HẢI YẾN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0580', 'LÊ NAM', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0581', 'LÊ HOÀNG PHONG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0582', 'AN NGUYỄN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0583', 'NGỌC VY', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0584', 'SECC', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0585', 'HÀ NGUYỄN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0586', 'HOÀNG VINH', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0587', 'TRÙNG DƯƠNG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0588', 'ÁNH PHẠM', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0589', 'LFA LTD', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0590', 'THUỲ DƯƠNG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0591', 'MINH THƯƠNG', 'ZALO', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0592', 'TRÍ LÊ', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0593', 'DUNG DUNG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0594', 'YẾN SÀO KIM QUYÊN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0595', 'TÂM', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0596', 'MEO MEO', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0597', 'NHIÊN TRẦN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0598', 'TRẦN MỸ LINH', 'ZALO', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0599', 'PHUONG PHAN', 'ZALO', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0600', 'FINFIN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0601', 'VI KHANH', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0602', 'VI KHANH', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0603', 'TRÂM NGUYỄN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0604', 'CHỊ HIỀN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0605', 'TRUNG NGUYÊN', 'ZALO', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0606', 'ĐÀI TRẦN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0607', 'PHƯƠNG ĐOÀN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0608', 'QUỲNH NHƯ', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0609', 'PHƯƠNG ĐOÀN NAM', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0610', 'HIEMI', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0611', 'FIN FIN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0612', 'NHƯ NGỌC', 'ZALO', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0613', 'HVAJ', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0614', 'NGA', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0615', 'CHOUCHOU', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0616', 'CAOBI', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0617', 'DUY NGUYỄN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0618', 'CAO TRI', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0619', 'HIẾU- PHƯƠNG NAM', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0620', 'HÀ', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0621', 'THÀNH NGUYỄN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0622', 'NÂU', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0623', 'THANH TRƯƠNG', 'ZALO', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0624', 'NGỌC', 'ZALO', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0625', 'THIỆN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0626', 'TRẦN DUY ANH', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0627', 'NGÔ GIA KHÁNH', 'ZALO', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0628', 'TRÀN NHƯ QUỲNH', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0629', 'LINGIE', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0630', 'NHÃ LINH', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0631', 'LÝ ĐỨC', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0632', 'HUNG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0633', 'NHI LE', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0634', 'LINDA', '0909 795 899', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0635', 'NGUYỄN BẮC', 'ZALO', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0636', 'AN NHIÊN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0637', 'MAI GIA CHUNG', 'ZALO', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0638', 'kloe nguyen', 'zalo', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0639', 'TRAN LAM LAM FB', 'FB', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0640', 'BÉ SU', 'FB', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0641', 'VIỆT TRINH', 'FB', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0642', 'HIỀN TRẦN ZALO', 'GG', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0643', 'NHẬT HẠ', 'ZALO', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0644', 'ĐỨC HOÀNG', 'ZALO', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0645', 'THƯƠNG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0646', 'BẢO PHAN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0647', 'HUỲNH ĐỨC', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0648', 'QUỐC ĐẠT', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0649', 'MỘC MIU', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0650', 'PHƯỚC SINH', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0651', 'LINH ĐỖ', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0652', 'YẾN NHI', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0653', 'NGỌC THÀNH', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0654', 'CHOCO', 'GG', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0655', 'JENNY LEE', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0656', 'KHÁNH MINH', 'GG', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0657', 'SAKURA', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0658', 'KHÁCH LẺ', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0659', 'THÀNH TRẦN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0660', 'OANH ĐINH', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0661', 'ĐỖ QUYÊN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0662', 'TRINH ĐỨC', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0663', 'THUỲ DƯƠNG NGUYỄN', 'fb', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0664', 'KHANG', 'FB', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0665', 'HÀ TRỌNG NGHĨA', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0666', 'HAPPY', 'GG', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0667', 'Minh Minh', 'zalo', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0668', 'QUYÊN LÊ', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0669', 'NHIEEN HIGH', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0670', 'CHÍ HIỂN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0671', 'PHƯƠNG ANH FB', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0672', 'GẠO', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0673', 'ANH NGHĨA', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0674', 'MINH TÍN PHẠM', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0675', 'UYỂN THY', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0676', 'TONY BAO', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0677', 'SCORPION', 'ZALO', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0678', 'Đ', 'GG', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0679', 'THANH', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0680', 'MS HẰNG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0681', 'DUY TK', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0682', 'KANHA NGO', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0683', 'YẾN NHI', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0684', 'VŨ MẠNH LƯƠNG', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0685', 'HỒ CHI', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0686', 'MINH TÂN', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0687', 'DAVID', NULL, NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0688', 'anh', '123456', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0689', 'Hailey', '25PD.2506.583 Hailey', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0690', 'Phạm Hồng Phúc', '906702063', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0691', 'Văn Phú', 'Zalo', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0678', 'TEST 1', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0679', 'TEST 2', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0680', 'TEST 3', '1', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0681', 'TEST 4', '3', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0682', 'TEST 5', '5', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0683', 'TEST 6', '6', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0684', 'TEST 7', '10', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0685', 'TEST 8', '11', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0686', 'TEST 9', '12', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0687', 'TEST 10', '14', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0688', 'TEST 11', '15', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0689', 'TEST 12', '16', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0690', 'TEST 13', '17', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0691', 'TEST 14', '18', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0692', 'TEST 15', '20', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0693', 'TEST 16', '21', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0694', 'Trung Đức Kva', '123', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0695', 'CHÍ CÔNG', '967177819', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0696', 'A TÀI SỬA XE MÁY', '973477214', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0697', 'Linh', '886870897', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0698', 'Nguyen Hoang Hai', '908489964', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0699', 'MAI ÁNH', '989992817', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0700', 'TRẦN TRUNG HUY', 'CHƯA CÓ', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0701', 'GIA HÂN', '935252015', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0702', 'DAT TRUONG', '.', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0703', 'VY', '938098401', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0704', 'VŨ LY', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0705', 'KHÁNH LINH', '..', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0706', 'Lê Ngọc Thuỳ Trang', '333', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0707', 'QUỲNH HƯƠNG', '949226502', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0708', 'NHƯ', ',', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0709', 'LAM VÕ', ',,', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0710', 'HOÀNG NHƯ', '999999999999', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0711', 'THÀNH ĐẠT', '89.', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0712', 'KẾ TOÁN ONZCA', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0713', 'BÙI TOÀN', '906958746', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0714', 'Anna', 'Anna', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0715', 'NGUYỄN TUẤN HƯNG', 'HƯNG', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0716', 'HUỲNH KIỆT', 'HUỲNH KIỆT', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0717', 'ĐINH CHÍ BẢO', 'ĐINH CHÍ BẢO', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0718', 'KHÔI ĐÀO', 'KHÔI ĐÀO', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0719', 'CHEN YUAN', '388278493', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0720', 'Shindo Trần', 'Shindo Trần', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0721', 'TERESA', '...', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0722', 'DŨNG TRÍ', '708558293', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0723', 'NGUYỄN ĐẮC TÍN', '/', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0724', 'Hanh Tr', 'Hanh Tr', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0725', 'Thuy Hoa', 'Thuy Hoa', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0726', 'CÔ VÂN', 'CÔ VÂN', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0727', 'UYỂN MY', 'UYỂN MY', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0728', 'BỘI ANH', 'BỘI ANH', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0729', 'NHI NGUYỄN', ';', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0730', 'THÔNG MOON', ':', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0731', 'GREG', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0732', 'BÍCH THỦY - PTI', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0733', 'YI', '096 1176561', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0734', 'CHỊ CHI', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0735', 'Julie Nguyen', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0736', 'HY PHAN', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0737', 'NGỌC KHANH', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0738', 'ANH PHƯƠNG ( CTY)', 'ANH PHƯƠNG ( CTY)', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0739', 'TRÍ CON', '764627936', 'C7/24 phạm hùng xã bình hưng huyện bình chánh', NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0740', 'DƯƠNG VŨ', '856303376', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0741', 'Thanh Thanh - Tea Food', 'Thanh Thanh - Tea Food', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0742', 'NHẬT HẢO', ';;', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0743', 'LINH LINH', 'LINH LINH', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0744', 'TIEN LENS', '902825290', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0745', 'MISS QUỲNH', '963913341', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0746', 'DANH THÁI', '\', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0747', 'TUYẾT MKT', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0748', 'Chị Châu', '|', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0749', 'Khanh Ha', 'Khanh Ha', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0750', 'Bunny Puff', 'Bunny Puff', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0751', 'Nguyễn Vy', 'Nguyễn Vy', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0752', 'thiên đăng', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0753', 'Ngọc Mai', 'Ngọc Mai', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0754', 'Nguyễn Hương Trà', 'Nguyễn Hương Trà', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0755', 'Lâm Cẩm Chí', 'Lâm Cẩm Chí', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0756', 'NGUYỄN MINH KHUÊ', '_', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0757', 'Tâm', 'Tâm', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0758', 'PHƯƠNG VY', '>', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0759', 'PHƯƠNGKHAYTI', '966854541', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0760', 'khách lẻ', 'khách lẻ', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0761', 'Mee Nè', 'Mee Nè', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0762', 'Chuppy', 'Chuppy', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0763', 'Nguyễn Thu Huyền', 'Nguyễn Thu Huyền', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0764', 'NGUYỄN THU HUYỀN', 'NGUYỄN THU HUYỀN', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0765', 'Ttmt', 'Ttmt', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0766', 'Anh T L', '__', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0767', 'Hà P Lute', 'Hà P Lute', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0768', 'Yenthanh', 'Yenthanh', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0769', 'OANH PERFUME', '(.)', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0770', 'Justin Cuong', 'Justin Cuong', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0771', 'công ty', 'công ty', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0772', 'Ven', 'Ven', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0773', 'Thanh Như', 'Thanh Như', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0774', 'Nguyễn Như Quỳnh', 'Nguyễn Như Quỳnh', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0775', 'Nguyễn An', 'Nguyễn An', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0776', 'Nguyễn Tuấn Anh', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0777', 'Nguyễn Tuấn Anh', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0778', 'Nguyễn Nhi', 'Nguyễn Nhi', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0779', 'ANH ĐƯỢC', '()', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0780', 'Doãn Thảo', 'Doãn Thảo', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0781', 'Ngân Quỳnh', 'Ngân Quỳnh', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0782', 'TRANG  NGUYỄN', '||', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0783', 'HOÀNG MINH', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0784', 'Uyên Thy', 'Uyên Thy', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0785', 'Nguyen Trang', 'Nguyen Trang', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0786', 'HOAI ANH', '\\', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0787', 'QUYÊN TRẦN', 'QUYÊN TRẦN', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0788', 'PHONG TẠ', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0789', 'Omely', 'Omely', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0790', 'ANH VINH', '84932752825', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0791', 'MINH BẢO', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0792', 'Xuân Thiện', 'Xuân Thiện', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0793', 'Hoàng Văn Hổ', 'Hoàng Văn Hổ', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0794', 'Thu Hiền', 'Thu Hiền', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0795', 'Soi Lại Chính Mình', 'Soi Lại Chính Mình', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0796', 'VO MINH THUC', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0797', 'LÊ THANH TRÚC', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0798', 'C P', 'C P', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0799', 'Phan Minh Thiện', 'Phan Minh Thiện', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0800', 'Minh Thư', 'Minh Thư', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0801', 'Loan Pham', 'Loan Pham', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0802', 'CHỊ LOAN PHẠM', 'CHỊ LOAN PHẠM', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0803', 'M Quân', 'M Quân', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0804', 'Huongnguyetque', 'Huongnguyetque', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0805', 'NGU NGO', '__-', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0806', 'TRINH BỘI', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0807', 'HỒNG THƠ ADA', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0808', 'Trà Myy', 'Trà Myy', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0809', 'Nngọc Bích', 'Nngọc Bích', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0810', 'HANH NGUYEN', '933676063', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0811', 'chị yu', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0812', 'Thuý Nhi', 'Thuý Nhi', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0813', 'QUỲNH NHƯ', '///', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0814', 'Nguyễn Ngân Thương', 'Nguyễn Ngân Thương', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0815', 'Thile', 'Thile', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0816', 'THANH HOA', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0817', 'THANH NGÂN', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0818', 'MILO', '918462539', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0819', 'Quỳnh Anh', 'Quỳnh Anh', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0820', 'Tuấn Anh', 'Tuấn Anh', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0821', 'TƯỜNG VY', '___', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0822', 'Mai Hương', 'Mai Hương', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0823', 'Dorie Dorie', 'Dorie Dorie', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0824', 'Phương Trần', 'Phương Trần', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0825', 'ANH CƯƠNGF', '773240987', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0826', 'ANH CƯỜNG', '773240987', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0827', 'ĐOAN NGHI', '____', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0828', 'Harry', 'Harry', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0829', 'Hoaitam', 'Hoaitam', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0830', 'Nguyễn Hồng', 'Nguyễn Hồng', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0831', 'NHUNG', '089 8469776', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0832', 'Bùi Kim Chấn', 'Bùi Kim Chấn', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0833', 'Tú bùi', 'Tú bùi', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0834', 'Khánh Ngọc', 'Khánh Ngọc', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0835', 'Thanh Thảo', 'Thanh Thảo', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0836', 'CHÍ TOÀN', '___-', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0837', 'Duc Anh Lorien', 'Duc Anh Lorien', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0838', 'Đá Viên Coffee', 'Đá Viên Coffee', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0839', 'Minh Thùy', 'Minh Thùy', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0840', 'CÔNG TY SPS', '(()0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0841', 'Lygon Function', 'Lygon Function', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0842', 'HẢI AU', '""', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0843', 'NGÔ XUÂN TRIỆU', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0844', 'DAM THE QUYEN', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0845', 'TY', 'TY', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0846', 'Nguyen Thuy Vinh', 'Nguyen Thuy Vinh', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0847', 'THUẬN THUẬN', 'THUẬN', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0848', 'CTY PALMA', 'PALMA', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0849', 'Glc Viet Nam', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0850', 'Anh Tú', 'Anh Tú', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0851', 'Linh Nhung', 'Linh Nhung', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0852', 'MINH HUỲNH', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0853', 'Nguyễn Vi Tùng', 'Nguyễn Vi Tùng', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0854', 'Ash', 'Ash', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0855', 'Công ty TNHH STHERB', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0856', 'Thắng', 'Thắng', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0857', 'Linh Uyên Dương', 'Linh Uyên Dương', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0858', 'Vũ Khánh Ly', 'Vũ Khánh Ly', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0859', 'Oanh', 'Oanh', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0860', 'Anna Trang Nguyễn', 'Anna Trang Nguyễn', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0861', 'David Truong', '886382848', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0862', 'CHỊ XUÂN', '(XUÂN)', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0863', 'PHI NGUYEN', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0864', 'Michelle Truong', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0865', 'Châu Nguyễn', 'Châu Nguyễn', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0866', 'Yến', 'Yến', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0867', 'Hoang Trang', 'Hoang Trang', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0868', 'PHẠM HỒNG LOAN', '(LOAN)', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0869', 'Phước Thịnh', 'Phước Thịnh', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0870', 'Thuat Pham', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0871', 'Trang', 'Trang', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0872', 'Vy Vy', 'Vy Vy', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0873', 'Linh Mom', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0874', 'Do Phuoc Loc', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0875', 'Gia Hân', 'hân', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0876', 'Ngô Minh Thi', 'Ngô Minh Thi', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0877', 'Sơn Đủ Thứ', 'Sơn Đủ Thứ', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0878', 'MINH DIỆP', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0879', 'Van Thanh Trung', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0880', 'Lý An', 'Lý An', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0881', 'bongthayyeudoiqua', 'gg zalo', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0882', 'Long Anh', 'zl', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0883', 'No Name', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0884', 'Ngọc', 'Ngọc', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0885', 'Vân Jenny', 'Vân Jenny', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0886', 'SOC KAFE', 'SOC', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0887', 'Hân', 'Hân', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0888', 'Huỳnh Hân', 'Huỳnh Hân', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0889', 'TRUNG HẢI', 'TRUNG HẢI', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0890', 'Thanh Thanh - Mingyue', 'Thanh Thanh - Mingyue', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0891', 'Lệ', 'Lệ', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0892', 'Zen Nguyễn', 'Zen Nguyễn', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0893', 'Ngọc Tuyết', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0894', 'THUỲ DƯƠNG NGUYỄN', 'DƯƠNG', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0895', 'Apu Bơ', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0896', 'Hồng Ngọc', 'Hồng Ngọc', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0897', 'NGỌC ÁNH', '(ÁNH)', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0898', 'MIU', 'MIU', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0899', 'Nguyên Chương', 'Nguyên Chương', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0900', 'Huỳnh Phương Đông', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0901', 'PX Thích', 'PX Thích', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0902', 'Nhật Minh', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0903', 'Công ty TNHH Toàn Ánh zalo MINH THY', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0904', 'Hoàng Bửu', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0905', 'Ngọt Thanh', 'Ngọt Thanh', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0906', 'THUỲ DƯƠNG', 'CT LÊ HOÀNG', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0907', 'XUAN THUY', 'THUY', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0908', 'Khoa', 'Khoa', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0909', 'Phạm Thị Địp', 'Phạm Thị Địp', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0910', 'vy thanh vy', 'vy thanh vy', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0911', 'CHAU KHIET DUNG', 'DUNG', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0912', 'XUÂN NGÂN', 'NGÂN', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0913', 'VŨ', 'VŨ', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0914', 'Quỳnh', 'Quỳnh', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0915', 'Lê Nguyễn Kỳ Anh', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0916', 'Gia Hân', 'Gia Hân', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0917', 'Nhất Đăng', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0918', 'PHONG ĐOÀN LÊ', 'PHONG', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0919', 'NGHI LÊ', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0920', 'Bvn Quang', 'Bvn Quang', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0921', 'magic key', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0922', 'Pham Minh Tuan', 'Pham Minh Tuan', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0923', 'Tiệm Cà Phê Tinatrang', 'Tiệm Cà Phê Tinatrang', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0924', 'Nguyễn Trung Tín', 'Nguyễn Trung Tín', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0925', 'Ngọc Hiếu', 'Ngọc Hiếu', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0926', 'Hà Liễu', 'Hà Liễu', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0927', 'LAM PHƯƠNG', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0928', 'Phương Linh', 'Phương Linh', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0929', 'Nober Mai', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0930', 'Nguyen Mai Linh', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0931', 'Nguyen Mai Linh', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0932', 'ÁNH NGỌC', 'NGỌC', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0933', 'Kim', 'Kim', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0934', 'Đinh Hồng Anh', 'Đinh Hồng Anh', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0935', 'Ho Duy', 'Ho Duy', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0936', 'Bích Phương', 'Bích Phương', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0937', 'Peter Nguyễn', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0938', 'Phước Hạnh', 'Phước Hạnh', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0939', 'Gà Bông', 'bông', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0940', 'Chung My', 'Chung My', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0941', 'Mi Nguyễn', 'Mi', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0942', 'HOÀNG TRINH', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0943', 'Lê Quân', 'Lê Quân', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0944', 'Nguyễn Lê Hoàng Vy', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0945', 'Nguyen Hoang Huy', 'Nguyen Hoang Huy', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0946', 'NGỌC QUỲNH ZALO NQ', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0947', 'ADAM BUI', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0948', 'Adam Bui', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0949', 'Thi Nguyen', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0950', 'Miên Vị', 'Miên Vị', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0951', 'khánh vân', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0952', 'Vy Luong', 'vy', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0953', 'anh DOANH', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0954', 'Ngọc', '(())', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0955', 'TRÚC QUỲNH', '(QUỲNH)', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0956', 'Đăng Agrest', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0957', 'HƯNG LÝ', 'LÝ', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0958', 'KOREAN SCHOOL', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0959', 'Huynh Thao Ly', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0960', 'trần đức', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0961', 'Dai Le', 'Dai Le', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0962', 'Nguyễn Thái Duy', 'DUY', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0963', 'Ngânn Kim', 'Ngânn Kim', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0964', 'MANH', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0965', 'Phương Trăm', 'Phương Trăm', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0966', 'TRỊNH TUYẾT NHI', 'nhi', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0967', 'Hoàng Bửu', 'Hoàng Bửu', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0968', 'Thao My', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0969', 'Phuong Huynh', 'Phuong Huynh', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0970', 'Sáng Phan', 'Sáng Phan', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0971', 'Hà Quyên Timing Chain', 'Hà Quyên Timing Chain', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0972', 'Nge Nge', 'Nge Nge', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0973', 'Long Phan', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0974', 'Trịnh Ngọc Công', 'Trịnh Ngọc Công', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0975', 'Trí Phước', 'Trí Phước', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0976', 'HƯƠNG CAM', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0977', 'Yến Loan', 'Yến Loan', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0978', 'JASON DƯƠNG', 'JASON DƯƠNG', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0979', 'BABY TRẦN', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0980', 'Viet Duc', 'Viet Duc', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0981', 'na na', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0982', 'nguyễn minh duy', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0983', 'Hà Anh', 'Hà Anh', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0984', 'Văn Phú', 'Văn Phú', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0985', 'Quangnguyen', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0986', 'Quế Trân', 'Quế Trân', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0987', 'XUÂN HƯƠNG', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0988', 'Chi Thanh', '938633355', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0989', 'Thảo Vy Vinastar Hcm', 'Thảo Vy Vinastar Hcm', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0990', 'MINH GIANG', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0991', 'HIẾU NGUYỄN', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0992', 'DỰ NGUYỄN', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0993', '리엔', '리엔', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0994', 'Daisy', '835188551', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0995', 'Daisy', '835188551', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0996', 'Daisy', '835188551', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0997', 'NGUYỄN HẢI NHI', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0998', 'chị TAB', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.0999', 'PHƯƠNG QUỲNH', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1000', 'TRẦN HUYỀN', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1001', 'như', 'như', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1002', 'Sương Sương', 'Sương Sương', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1003', 'Hoàn mỹ', 'Hoàn mỹ', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1004', 'ALEC', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1005', 'XUÂN TRINH_SHUYI VIỆT NAM', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1006', 'NGUYÊN TRẦN', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1007', 'NEKO THƯ', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1008', 'winfat', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1009', 'Hoàng Ngọc', 'Hoàng Ngọc', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1010', 'LÊ NGỌC', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1011', 'Chị Mẫn', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1012', 'PHONG NK', 'PHONG NK', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1013', 'Hong Ngoc', 'Hong Ngoc', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1014', 'Hoài Ngọc', 'Hoài Ngọc', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1015', 'Nguyễn Thị Quỳnh Trang', 'Nguyễn Thị Quỳnh Trang', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1016', 'Pham Bach', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1017', 'trúc nguyễn', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1018', 'hang luong', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1019', 'Khánh Hoà', 'Khánh Hoà', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1020', 'LÊE AN', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1021', 'Văn Thôi', 'Văn Thôi', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1022', 'Ái my', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1023', 'Ponoco', 'Ponoco', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1024', 'Hậu - Phụ Kiện Quay Phim', 'Hậu - Phụ Kiện Quay Phim', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1025', 'PHƯƠNG TRINH', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1026', 'Sa Tarot', 'Sa Tarot', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1027', 'JOAN HÀN', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1028', 'PHAN LINH', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1029', 'Trần Hiền', 'Trần Hiền', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1030', 'THAÁI THANH NGÂN', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1031', 'Kỳ Mỹ', 'Kỳ Mỹ', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1032', 'TRUNG THẾ BETA', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1033', 'chị Jolie', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1034', 'Phạm Sương', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1035', 'Công Ty TNHH Thiên Thanh Mộc', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1036', 'Thắng Kim Vũ', 'Thắng Kim Vũ', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1037', 'PHÚC ĐỈNH', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1038', 'THÙY HƯƠNG', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1039', 'Phạm Uyên', 'Phạm Uyên', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1040', 'thanh phong', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1041', 'Tue Anh Do', 'Tue Anh Do', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1042', 'Linh Nguyễn Nhật', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1043', 'ĐOAN ANH', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1044', 'DĐOAN TRANG', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1045', 'Khanh Ơi', 'Khanh Ơi', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1046', 'Huỳnh Thúy Ngân', 'Huỳnh Thúy Ngân', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1047', 'ÁNH LINH', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1048', 'Mạnh Hà', 'Mạnh Hà', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1049', 'Nguyễn Minh Duy', 'Nguyễn Minh Duy', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1050', 'phamk dũng', 'phamk dũng', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1051', 'tuyền', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1052', 'Cao Lê Gia Linh', 'Cao Lê Gia Linh', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1053', 'QUÝ MAP', 'QUÝ MAP', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1054', 'ĐẠT PHAN', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1055', 'Ngoc', 'Ngoc', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1056', 'GIA NGHI', '093 101 7212', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1057', 'Viee', 'Viee', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1058', 'VŨ KHÁNH LY', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1059', 'selina', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1060', 'Nguyen Nhuan', 'Nguyen Nhuan', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1061', 'Trinh Truong', 'Trinh Truong', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1062', 'Haru Lien', 'Haru Lien', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1063', 'HOÀNG THẮNG', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1064', 'Phát Đạt', 'Phát Đạt', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1065', 'TRÂN TRÂN', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1066', 'Liên LiDii', 'Liên LiDii', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1067', 'TOÀN VŨ', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1068', 'kim trinh', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1069', 'DƯƠNG BÌNH', '962586846', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1070', 'Trần Lê Quân', 'Trần Lê Quân', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1071', 'Chú Phú', 'Chú Phú', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1072', 'HOÀNG NHI', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1073', 'Phước Trần', 'Phước Trần', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1074', 'THANH NGUYỄN', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1075', 'Athy Pạm', 'Athy Pạm', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1076', 'Hoài Thương', 'Hoài Thương', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1077', 'lou lee', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1078', 'KIỀU TRANG', 'KIỀU TRANG', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1079', 'Minh Tri', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1080', 'TRÍ LAN', 'TRÍ LAN', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1081', 'BÙI DIỀN', 'BÙI DIỀN', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1082', 'LÊ THANH NGA', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1083', 'TÝ LAI', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1084', 'Thùy Trang Phạm', 'Thùy Trang Phạm', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1085', 'ANH THƠ', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1086', 'TUONG TUONG', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1087', 'Hàn Việt Singsingcan', 'Hàn Việt Singsingcan', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1088', 'Anh Thơ', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1089', 'HỒNG NGỌC', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1090', 'Trần Quý', 'Trần Quý', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1091', 'SHIN PHẠM', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1092', 'Nx Thành', 'TAKI DELI', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1093', 'ANH THU NGUYEN', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1094', 'Kim Thoa', 'Kim Thoa', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1095', 'Thanh Lâm', 'Thanh Lâm', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1096', 'Nguyên', 'Nguyên', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1097', 'Nguyễn Thành Hơn', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1098', 'Mai Cao Thanh Nhã', '918791095', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1099', 'MÃ QUỐC QUANG', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1100', 'THỤY KHA', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1101', 'Trinh Dang', 'Trinh Dang', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1102', 'HIỀN THẢO', 'HIỀN THẢO', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1103', 'BEN LÊ', 'BEN LÊ', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1104', 'HỒNG PHÚC', 'HỒNG PHÚC', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1105', 'Trường Phát', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1106', 'TRUONG PHAT', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1107', 'NGỌC MAI', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1108', 'VÂN ANH', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1109', 'Grand Hyams Hotel_ Ms hiền', 'Ms hiền', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1110', 'VÂN ANH', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1111', 'VÂN NGUYỄN', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1112', 'TUYẾT TRINH', 'TUYẾT TRINH', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1113', 'Áo Dài Hary', 'Áo Dài Hary', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1114', 'MỸ HÀ', 'MỸ HÀ', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1115', 'ming hòa', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1116', 'Hoàng Tú', 'Hoàng Tú', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1117', 'Trịnh Ngọc Hưởng Mr', 'Trịnh Ngọc Hưởng Mr', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1118', 'nguyễn bảo', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1119', 'MILAN', 'MILAN', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1120', 'trămm', 'trămm', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1121', 'Minh Nhật', 'Minh Nhật', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1122', 'Thanh Phương', 'Thanh Phương', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1123', 'HƯNG NGUYỄN', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1124', 'Mai Thảo', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1125', 'Thầy Thuốc Nam Dược', 'Thầy Thuốc Nam Dược', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1126', 'Đức Vinh', 'Đức Vinh', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1127', 'HUYỀN LINH', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1128', 'Tae Dinh', 'Tae Dinh', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1129', 'Huynh Hung', 'Huynh Hung', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1130', 'Daniel Ng', 'Daniel Ng', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1131', 'Minh Phan', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1132', 'TRÀN ANH COMESTIC', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1133', 'TRÀN ANH COSMETIC', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1134', 'Hoang Bao Han', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1135', 'LÊ NGỌC TƯỜNG VY', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1136', 'MR LEE VU', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1137', 'NGỌC ÁNH', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1138', 'Khu Du Lịch Sinh Thái Phú Ninh', '....', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1139', 'MANH PHAM', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1140', 'TRẦN ĐỨC MINH', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1141', 'TRẦN ĐỨC MINH', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1142', 'Peter', 'Peter', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1143', 'Cao Hằng', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1144', 'tommy', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1145', 'Dhm Viet Nam', 'Dhm Viet Nam', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1146', 'SOY HẬU', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1147', 'SOY HẬU', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1148', 'ANH TUẤN DECAL', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1149', 'CAO HĂNG', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1150', 'Mr Vui', 'Mr Vui', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1151', 'CAO TRANG', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1152', 'Hello Kafe', 'Hello Kafe', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1153', 'KHANG HOÀNG LÊ', '931836448', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1154', 'Đặng Hồng Phước', 'Đặng Hồng Phước', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1155', 'JASMINE NGUYEN', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1156', 'Bích Trâm', 'Bích Trâm', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1157', 'NGÂN TRẦN', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1158', 'Nam Mỹ', 'Nam Mỹ', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1159', 'TOỐNG HƯƠNG LÊ', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1160', 'Tạ phương nghi', 'Tạ phương nghi', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1161', 'Anh Thư', 'Anh Thư', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1162', 'Lê Mỹ Diệu', 'Lê Mỹ Diệu', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1163', 'NGUYEN ĐÌNH THƯƠNG', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1164', 'Nhật Vy', 'Nhật Vy', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1165', 'HỒNG NGỌC', 'HỒNG NGỌC', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1166', 'MỸ TÂM', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1167', 'Tôn Nữ Minh Hiền', '937235105', '185 Đinh Tiên Hoàng phường Đakao quận 1', NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1168', 'tuantran', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1169', 'HOÀNG THU HOÀN', 'HOÀNG THU HOÀN', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1170', 'Hoàng Loan', 'Hoàng Loan', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1171', 'MAIKHUE', 'MAIKHUE', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1172', 'Thanhh Tâm', '908165359', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1173', 'Tý Lai', '907042222', '132 tân mỹ p tân thuận', NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1174', 'MAN LE', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1175', 'Khương Cao', 'Khương Cao', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1176', 'Minh Tâm', '929354933', '480/34 Bình Quới, P.28, Q. Bình Thạnh', NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1177', 'Mỹ Duyên', '392621411', '211B đường 17, phường tân quy, quận 7', NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1178', 'Hồng Ngọc', '942235596', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1179', 'Nguyễn Ngọc Thanh Thảo', '909564162', 'nhà khách gần bên, tự qua lấy', NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1180', 'Glytuong', 'Glytuong', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1181', 'Minh Châu - Lưu Võ', '903190218', 'In xong khách tự tới lấy', NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1182', 'Nguyễn Trung Tín', '942136169', 'Khách tự ghé lấy', NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1183', 'ANH COFFEE', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1184', 'Jennie', 'Jennie', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1185', 'Hoang Hai Binh', '388069276', '121A đường Hoàng Văn Thụ, P8, Quận Phú Nhuận, TP HCM.', NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1186', 'Hthi Cẩm Tiên', 'Hthi Cẩm Tiên', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1187', 'SUSAN', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1188', 'CHÚ Victoire', 'Victoire', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1189', 'Thư - Gas Thanh Kim Long', 'Thư - Gas Thanh Kim Long', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1190', 'Nguyễn Lê Hoàng Khang', '931836448', 'Khách tự ghé lấy', NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1191', 'TÁ', 'TÁ', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1192', 'Máy Bao Bì Carton', 'Máy Bao Bì Carton', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1193', 'Nguyễn Ngọc Phương', '908383089', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1194', 'Trần Thị Bảo Trân', '903371701', 'Lô Q-6A, Đường số 5, KCN Long Hậu, Cần Giuộc, Long An', NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1195', 'MẪN TÚ', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1196', 'Nam Hùng', 'Nam Hùng', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1197', 'My Nguyễn', 'My Nguyễn', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1198', 'Nguyen Cute', 'Nguyen Cute', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1199', 'Hoa Kiều', 'Hoa Kiều', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1200', 'Đức Trí', 'Đức Trí', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1201', 'NHẠT LINH', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1202', 'Diệu Hoa', 'Diệu Hoa', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1203', 'Thu Hiền', '868359859', '650 huỳnh tấn phát , phường tân phú, quận 7', NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1204', 'In PD', 'sếp  Phúc', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1205', 'Nguyen Thach Anh', 'Nguyen Thach Anh', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1206', 'Daebak Coffee Bakery', 'Daebak Coffee Bakery', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1207', 'Anh Quốc', 'Anh Quốc', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1208', 'Mai Đình Moshi', '822990006', 'Khách tự ghé lấy', NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1209', 'Đình Nam', 'Đình Nam', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1210', 'Thile', '933222857', '74/7 đường 14A cư xá ngân hàng quận 7', NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1211', 'Lý An', '797979063', 'Giao lên takashimaya 92-94 nam kỳ khởi nghĩa, bến nghé Q1', NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1212', 'Global home', 'Global home', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1213', 'Trâm Huỳnh_Onzca', '1000', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1214', 'Ruby', 'Ruby', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1215', 'Tùng', 'Tùng', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1216', 'A. HIỀN', '937956797', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1217', 'A. HIỀN PHÙNG', '937956797', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1218', 'Trâm Mai', 'Trâm Mai', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1219', 'Phú', '583272330', '72m đường Hoàng Quốc Việt, phường Phú Mỹ Quận 7', NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1220', 'Mie', '935246363', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1221', 'Nhật Lệ', '799403279', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1222', 'Nguyễn Duy Cường', '399864336', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1223', 'Long Nguyen', 'Long Nguyen', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1224', 'NGUYỄN KHOA', '11111', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1225', 'Chị Ốc Trang', '13092025', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1226', 'Tiến Võ', 'Tiến Võ', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1227', 'Trường Giang', '762812070', 'Khách tự ghé lấy', NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1228', 'Ngô Hoàng Anh', '372475363', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1229', 'Uyên-iến', 'Uyên-iến', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1230', 'Daisy', 'Daisy', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1231', 'Trần Nhân', '779601880', 'Khách tự ghé lấy', NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1232', 'Bunny Puff', '582775292', '1622/52 huỳnh tấn phát, nhà bè, hcm', NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1233', 'Thien Minh Printing', 'Thien Minh Printing', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1234', 'Trần Ngọc Sơn', '329899440', 'Khách tự ghé lấy', NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1235', 'Vy', 'KH0092', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1236', 'Lily', '908120139', 'Khách tự ghé lấy', NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1237', 'Thúy', 'Thúy', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1238', 'Thiên Hương', '386335961', 'Khách tự ghé lấy', NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1239', 'PHƯƠNG NGÂN', '936627613', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1240', 'Nabi', '705337951', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1241', 'Trần Ngọc Chương', '965248866', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1242', 'Huỳnh Gia Linh', 'Huỳnh Gia Linh', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1243', 'Trần Ngọc Chương', '965248866', 'Khách tự ghé lấy', NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1244', 'Hồng Kỳ', 'Hồng Kỳ', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1245', 'Tú Nguyễn', 'Tú Nguyễn', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1246', 'NGUYỄN ĐỨC QUANG', 'NGUYEN DUC QUANG', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1247', 'Minh Hậu', 'Minh Hậu', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1248', 'Anh Khoa', 'Anh Khoa', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1249', 'Đạo', '909529030', 'Khách tự ghé lấy', NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1250', 'Nguyễn Yến Bảo Trân', 'trân', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1251', 'My Mimi', '917221786', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1252', 'Nguyễn Thị Thùy Linh', '395864785', 'Khách tự ghé lấy', NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1253', 'Chung My', '367100343', 'Block i, Ecogreen Sài Gòn, 39B Nguyễn Văn Linh, Tân Thuận Tây, quận 7', NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1254', 'NGHIÊM HIẾU', '966358639', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1255', 'HThanh Pancake', 'thanh', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1256', 'Minh Tâm', 'Minh Tâm', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1257', 'Naul Chou', 'Naul Chou', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1258', 'Lương Minh Khoa', '886565670', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1259', 'Phạm Thị Ánh Ngọc', '355281901', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1260', 'Ly Ly', 'Ly Ly', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1261', 'Lương Minh Khoa', '886565670', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1262', 'Nguyễn Đông', '933378992', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1263', 'An', 'An', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1264', 'Chu Trọng Tân', '327249792', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1265', 'Nghĩa Nguyễn', 'Nghĩa Nguyễn', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1266', 'CTY KỲ LÂN', 'CTY KỲ LÂN', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1267', 'Duyên Trương', 'Duyên Trương', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1268', 'Trang Nguyễn Kt Vật Tư', 'trang', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1269', 'Phan Anh', 'Phan Anh', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1270', 'Son Nguyen', '909385859', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1271', 'Tt Thanh Duyên', 'zalo Tt Thanh Duyên', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1272', 'Vân Piano', 'Vân Piano', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1273', 'TUYẾT HƯƠNG', '931936097', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1274', 'Phuong Vo Thuy', 'THUY.', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1275', 'HOÀNG THY', 'CTY XYZ Corp', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1276', 'Phương Anh', 'Anh', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1277', 'Phạm Đắc Toàn', '763521347', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1278', 'Oanh Đinh', '909648285', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1279', 'My Hang Tr', 'My Hang Tr', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1280', 'David Duong', 'David Duong', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1281', 'Hanah Lương', '938920205', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1282', 'Xuân Thiện', '703525894', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1283', 'Thu Ngân', '903331402', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1284', 'CTY COZY', 'COZY', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1285', 'Phat Nguyen', 'Phat Nguyen', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1286', 'Duc Le', '938507629', 'Khách tự ghé lấy', NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1287', 'CTY KIẾN THẠCH', '902650039', 'Khách tự ghé lấy', NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1288', 'Phạm An Thiên', '901365846', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1289', 'MAI TRẦN', 'IN DECAL BẾ BAO GẠO', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1290', 'Lily Ly', '964888908', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1291', 'Thiên Ngân', '795352207', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1292', 'Nguyễn Phúc', '936092600', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1293', 'Quý', '933358030', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1294', 'Nguyên Trần', 'Nguyên Trần', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1295', 'Nguyễn Hào Lê Quyên', 'quyên', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1296', 'Phương Ununi', 'in standee', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1297', 'In Tam Hiệp', 'In Tam Hiệp (bạn a Phúc)', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1298', 'Nguyễn Hữu Nghĩa', 'Nguyễn Hữu Nghĩa', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1299', 'Mạnh Hưng Trần', 'Mạnh', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1300', 'TUYẾT HƯƠNG', 'B’S GROUP', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1301', 'HƯƠNG LY', 'CÔNG TY TNHH B’S GROUP', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1302', 'Y Kỳ', '903904605', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1303', 'Nguyen Vinh', 'Nguyen Vinh', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1304', 'Nguyen Vinh', '353919493', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1305', 'Uyển Myy', 'Uyển Myy', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1306', 'Mai Trangg', 'Mai Trangg', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1307', 'Ngọc Diệp', 'Ngọc Diệp', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1308', 'TRƯƠNG NHẬT HUY', '938638183', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1309', 'Huy Dean', '972986969', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1310', 'Trọng Trí', '397194966', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1311', 'Trương Việt Hoàng', 'Trương Việt Hoàng', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1312', 'Trương Việt Hoàng', '944560092', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1313', 'S''tc Thông', '334184392', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1314', 'Phạm Quang Thái', 'THÁI', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1315', 'Hoàng Sơn', '966670892', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1316', 'Quỳnh', '382365278', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1317', 'Chuyên Hàng Auth', 'In nhãn phụ', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1318', 'Trần Thu Hà', 'hà', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1319', 'Tân Handsome', 'Tân Handsome', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1320', 'Thúy Phạm', '378976145', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1321', 'ĐẶNG TUẤN KIỆT', 'In standee', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1322', 'Lê Tâm', '337783749', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1323', 'Trang Lê', '919308675', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1324', 'Minh Trí', 'Minh Trí', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1325', 'Việt Tạ', 'Việt Tạ', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1326', 'Nguyễn Thị Thảo Nguyên', '782745990', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1327', 'NGUYỄN THƠ', 'Standee', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1328', 'Hồng Ngọc 0921803961', '921803961', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1329', 'Đặng Quỳnh', '938441913', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1330', 'ĐINH NGỌC', '936239554', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1331', 'Mia Dang', '906096603', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1332', 'Nguyễn Thị Ngọc Diễm', '785230205', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1333', 'Hoàng My', 'Hoàng My', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1334', 'Hoàng My', '582215534', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1335', 'NGUYỄN XUÂN THẢO VY', 'TEM PHỤ', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1336', 'Uyển Myy', '899457754', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1337', 'Hoang Anh', '946100913', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1338', 'Kim Hưng', '-938725839', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1339', 'LÂM QUANG VINH', 'Namecard', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1340', 'C P Quynh', '908714879', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1341', 'Đông Phương', '868068119', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1342', 'Thuỳ Dung', '983326986', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1343', 'HOÀNG SỸ', 'pankace', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1344', 'Đông Phương', '868068119', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1345', 'Akuna', '911735800', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1346', 'Hoàng Khánh Vân', '903170190', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1347', 'Hoàng Khánh Vân', '903170190', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1348', 'Bảo Yến', '909426105', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1349', 'NGUYỄN QUỐC CƯỜNG', 'IN NHÃN, NAMECARD', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1350', 'Phan Anh', '355281442', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1351', 'Thuỳ Dương', '706307074', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1352', 'PHƯƠNG PHẠM', 'DECAL', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1353', 'THANH TRÚC - 0933003179', '933003179', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1354', 'Thủy Tiên Lee', '982581363', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1355', 'Nguyễn Thành An', 'Nguyễn Thành An/pc zalo', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1356', 'ĐẶNG HỒNG NGỌC', 'PANCAKE', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1357', 'QUYÊN TRẦN', '906539092', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1358', 'Alice Nguyen', 'Alice Nguyen', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1359', 'Vũ Qui', 'Vũ Qui', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1360', 'Mynhan Vo', 'Mynhan Vo', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1361', 'Khánh Vân', '339789239', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1362', 'Hương Duyên', 'Hương Duyên', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1363', 'Luân', 'Luân', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1364', 'Quyên Trần', '906539092', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1365', 'Susan Tran', '933866663', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1366', 'Truc', '886880567', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1367', 'Truc', '886880567', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1368', 'Truc', '886880567', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1369', 'Tùng', '898478062', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1370', 'Hao Tran', '328535445', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1371', 'PHƯƠNG DUNG', 'PHƯƠNG DUNG', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1372', 'Nhất Đăng', '888835504', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1373', 'Nguyễn huỳnh Đức', '799355110', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1374', 'Trần Thị Kim Thuỷ', 'Trần Thị Kim Thuỷ', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1375', 'Được Được', 'Được', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1376', 'Tấn Đạt', '886665528', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1377', 'LoanPham', '943777772', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1378', 'Thuý Hằng', '327097339', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1379', 'Ms Kim Nga', '349403296', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1380', 'Nguyễn Đức Quang', '933376061', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1381', 'Hun - Duy Hưng', '903643475', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1382', 'Cường Đoàn', 'Cường Đoàn', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1383', 'Phương Đông', '964538422', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1384', 'Nguyễn Hoàng', '865763847', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1385', 'Thuỵ Quân', '946182219', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1386', 'Lương Minh Thư', 'thư', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1387', 'Ds Nhi', 'Ds Nhi', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1388', 'Nganguyen Sato', 'Nganguyen Sato', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1389', 'Trinh', 'Trinh', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1390', 'Lê Nguyễn Minh Thư', 'Lê Nguyễn Minh Thư', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1391', 'đặg nguyên phúc', '902850344', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1392', 'Thanh Nguyễn', 'Thanh Nguyễn', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1393', 'Thanh Nguyễn', '369457827', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1394', 'Hân Hân', '936587961', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1395', 'cô hương', '933537173', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1396', 'Nguyễn Đức Cường', '852535658', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1397', 'Okava', '901434950', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1398', 'Thắng Bulong Kim Vũ', 'Thắng Bulong Kim Vũ', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1399', 'Ngoc NTB', 'Ngoc NTB', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1400', 'TRẦN NHẬT HUY', 'TRẦN NHẬT HUY', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1401', 'Toán Daedong Ginseng', 'Toán Daedong Ginseng', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1402', 'Uyên Nguyễn', '972382413', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1403', 'LỮ XUÂN HẢI', 'NAMECARD', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1404', 'Nga Chung', 'Nga Chung', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1405', 'Phan Tuân', '362182838', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1406', 'Bé Linh', 'Bé Linh', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1407', 'Heo', 'Heo', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1408', 'Nguyễn Kim Thiên Hòa', '914327672', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1409', 'Phương Nhi', 'Phương Nhi', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1410', 'Bích Chi Kem Quê', 'Bích Chi Kem Quê', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1411', 'Tiến Đình', 'Pancakes', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1412', 'Quỳnh Trang', '325.636.474', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1413', 'Phương Jessica', '898086079', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1414', 'Sonn', 'Sonn', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1415', 'Yến', '909724196', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1416', 'Minh Huy', 'Minh Huy', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1417', 'Vượng Tâm', '398333560', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1418', 'Linda', '909795899', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1419', 'Mỹ Vy', '938836017', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1420', 'Mhien', 'Mhien', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1421', 'Sakena Sa', '961741233', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1422', 'Thanh Thảo', 'Thanh Thảo..', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1423', 'Minh Trân', 'Minh Trân', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1424', 'Hà Hằng', 'Hà Hằng', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1425', 'Hà Hằng', 'Hà Hằng..', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1426', 'Nguyễn Khoa', '908436501', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1427', 'Thao Nguyen', '349524726', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1428', 'David Phước', 'David Phước', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1429', 'BAO BÌ TIẾN PHÁT', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1430', 'anh Kim Cương', '904844788', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1431', 'Kelly Ho', 'Kelly Ho', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1432', 'Jack Tran (nhóm Jendy Trương)', 'Jack Tran', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1433', 'Brandon', 'Brandon', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1434', 'Mi (0939268896)', '939268896', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1435', 'Lệ Quyên', 'Lệ Quyên', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1436', 'Trọng Lâm', '899990734', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1437', 'LÊ VĂN AN ( 0943333460 (', '943333460', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1438', 'Thy Truong', 'Thy Truong', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1439', 'Kim Linh', '908701408', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1440', 'Phượng', '903783418', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1441', 'Tấn Hậu', '799996940', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1442', 'TRƯƠNG MAI HIÊN', '318879047', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1443', 'Võ Hoàng Tú Minh', '961695897', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1444', 'Nhuy Vo Thi', '342313610', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1445', 'TrieuThanhauto', 'TrieuThanhauto', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1446', 'LỢI  0966058118', '966058118', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1447', 'Nhật Linh', '762422382', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1448', 'Danny Ho Hưng', 'Danny Ho Hưng', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1449', 'Lê Thủy Tiên', 'Lê Thủy Tiên', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1450', 'MINH ĐẠT  0839978437', '839978437', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1451', 'VĂN LÊ', 'VĂN LÊ', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1452', 'VĂN LÊ', '901484599', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1453', 'Giúp Việc Hàn Nguyễn', '794391864', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1454', 'Thảo Phương', '987901089', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1455', 'Hồng Vân', 'Hồng Vân', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1456', 'Nhi', '939281302', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1457', 'Phạm Thiên An 0901365846', '901365846', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1458', 'Lii', 'Lii', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1459', 'Thư', 'Thư', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1460', 'WAKA', 'WAKA', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1461', 'Huyền Võ', '978966093', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1462', 'Giang Pham', '783888385', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1463', 'BÌNH', 'BÌNH', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1464', 'Quốc Bảo', 'Quốc Bảo', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1465', 'Đạt', '9091152632', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1466', 'Nghĩa Nguyễn', '703739342', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1467', 'Tuấnkhải', 'Tuấnkhải', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1468', 'ĐỨC NGUYỄN NGON NGON', 'ĐỨC NGUYỄN NGON NGON', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1469', 'ĐỨC NGUYỄN NGON NGON', '902206903', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1470', 'Thu Nam', 'Thu Nam', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1471', 'ĐOAN TRINH', 'ĐOAN TRINH', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1472', 'Phạm Ngọc Quyền (Nhóm Jendy Trương)', 'Phạm Ngọc Quyền', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1473', 'Trịnh Kim Ngọc', 'Trịnh Kim Ngọc', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1474', 'thanhthaoo', '938257880', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1475', 'Võ Thanh Vy nhóm Tăng Thảo Vy', 'Võ Thanh Vy', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1476', 'Quốc Phiên - Phú Quốc', '962645685', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1477', 'Bảo', '904229122', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1478', 'Bop', '969100701', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1479', 'Nhân Lê', '888247388', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1480', 'Trương Nam Khách', '938078087', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1481', 'Danh Vi', '966541440', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1482', 'Bob/Mr Ninh', '918410090', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1483', 'Thúy Hằng 0931237143', '931237143', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1484', 'Hien Nek', 'Hien Nek', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1485', 'Phương Lan', 'Phương Lan', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1486', 'Madeira Emb (0901083037)', '901083037', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1487', 'Vy +65 8447 1292', '#ERROR!', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1488', 'Thuận', 'Thuận', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1489', 'Thắng', '938819419', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1490', 'Tường Vy  0388018951', '388018951', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1491', 'Tinaflower', 'Tinaflower', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1492', 'World Spice', 'chị Trang', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1493', 'Thị Cún', 'Thị Cún', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1494', 'Hoàng Anh', '794855047', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1495', 'Pham Ngoc Lam', 'Pham Ngoc Lam', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1496', 'Lương Trung Hậu', 'Lương Trung Hậu', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1497', 'Huong Do', '904181187', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1498', 'Thanh Châu', 'Thanh Châu', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1499', 'Trần Ngọc Như', 'Trần Ngọc Như', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1500', 'Trần Ngọc Như', '397698599', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1501', 'STELL', '(CTY)', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1502', 'STEEL', '(CTY).', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1503', 'Anh Hàng Xóm', 'Anh Hàng Xóm', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1504', 'Dương Thanh Tú (nhóm ĐẠI THIÊN PHÚ/ 7 LUCKS)', 'nhóm ĐẠI THIÊN PHÚ/ 7 LUCKS', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1505', 'Tran Huyen', '972972615', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1506', 'Thiên Ý', '038 5324593', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1507', 'Selina', '961344000', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1508', 'Dtp Group/ nhóm 7 Luck', 'nhóm 7 Luck', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1509', 'V Nguyen', 'V Nguyen', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1510', 'Hoàng Anh', '392692883', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1511', 'Chee 玉芝', '888225054', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1512', 'Thủy Tiên', '797155072', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1513', 'Kim Anh - INNOVATION', 'INNOVATION', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1514', 'TRÚC', 'CỔ PHẦN CÔNG NGHỆ HANET', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1515', 'Nguyễn Hải Nhi', '911280281', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1516', 'CƯỜNG TRẤN', '988656173', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1517', 'Nguyễn huỳnh Đức', '799355110', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1518', 'Ngọc Trân', 'Ngọc Trân', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1519', 'PHẠM NGUYỄN THỦY TIÊN', 'IN ĐỒ ÁN', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1520', 'Anh Thư', '333162441', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1521', 'Khánh Phụng', '916231825', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1522', 'Huỳnh Như', '396921718', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1523', 'Thảo Nguyên', 'Thảo Nguyên', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1524', 'Ngô Như', 'Ngô Như pancake', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1525', 'Huyền Trần', 'Huyền Trần', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1526', 'Kim Linh', '908701408', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1527', 'An Nhiên', '363399246', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1528', 'Minh Châu', '774134562', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1529', 'HẠNH', 'BDS INDEPENDENT', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1530', 'Nhật Anh', '939369294', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1531', 'Quỳnh', '382365278', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1532', 'Minh Châu', '774134562', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1533', 'Habaoxuyen', 'Habaoxuyen', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1534', 'Ngọc Ánh', '981189413', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1535', 'Nguyễn Thanh Tín', '564908888', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1536', 'Thiên Trang', '908790006', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1537', 'Mỹ Xuyên', '343080521', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1538', 'Bảo Khánh', '937850003', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1539', 'Metanano Việt Nam', 'Metanano Việt Nam', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1540', 'Nhật Trần', 'Nhật Trần', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1541', 'Hải', '336954803', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1542', 'Thế Thụy', '阮世瑞', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1543', 'Đan Thy', '799088177', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1544', 'Anh Tú', 'Anh Tú..', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1545', 'LÊ THƯ KỲ', '356589724', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1546', 'Hana', '972332704', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1547', 'Đông Phương', '969678675', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1548', 'Chang', '966009845', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1549', 'LÊ PHAN', '937335816', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1550', 'Lê Trần Linh Anh', 'Lê Trần Linh Anh', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1551', 'Khải Phát', '933449393', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1552', 'Hoàng Trinh', '903381298', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1553', 'Min An', '937699324', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1554', 'Tuấn Anh', 'Anh..', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1555', 'Linh Nguyen', 'Linh Nguyen', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1556', 'Lý Hạnh', 'Lý Hạnh', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1557', 'ĐẶNG TRÚC', 'ĐẶNG TRÚC', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1558', 'Smile/Vân Anh', '912513131', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1559', 'Thanh Trúc', '933003179', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1560', 'Ntd/ anh Đạt', '903311989', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1561', 'Trường Dem Home', '985011854', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1562', 'Ngoc Khanh', '949614088', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1563', 'Ngoc Khanh', '949614088', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1564', 'Hồng Thơ Ada', 'Hồng Thơ Ada', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1565', 'Ngọc Thuỳ', '779068936', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1566', 'Táo Đỏ', '937603661', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1567', 'Dung Huynh', '919980011', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1568', 'Lin', 'Lin', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1569', 'Minh Duy', 'Minh Duy', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1570', 'Đỗ Tuấn', '982191268', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1571', 'TUYẾT MINH', '917178634', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1572', 'TUYẾT MINH', '917178634', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1573', 'TUYẾT MINH', '917178634', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1574', 'Trúc Linh', '355611339', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1575', 'Trúc Linh', '355611339', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1576', 'Trúc Linh', '355611339', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1577', 'Trúc Linh', '355611339', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1578', 'Trọng Khiêm', '979899451', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1579', 'Thắng', 'Phan Tran Le Thang', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1580', 'Hoàn Nguyễn - Định Cư 环阮', '091 9616666', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1581', 'Thành Luân', '917771334', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1582', 'Ân', 'Nguyễn', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1583', 'Nguyễn Tiến', '889888366', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1584', 'TFK', 'TFK', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1585', 'CÔNG TY CỔ PHẦN THE FRESH KITCHEN', '19005013', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1586', 'Jenny', '933006777', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1587', 'THUY NGUYÊN', 'THUY NGUYÊN', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1588', 'Ngô Quế Huyền', '913297583', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1589', 'Thắng', '989757384', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1590', 'Huệ Đoàn', '948164806', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1591', 'Thiên Tài', 'Thiên Tài', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1592', 'Trần Văn Phi', 'Trần Văn Phi', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1593', 'Thùy Dung', '773856538', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1594', 'ĐẠI NGUYỄN', '708780255', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1595', 'Bình', 'Bình', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1596', 'Khánh Ngân', 'Khánh Ngân', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1597', 'Cơm Noon', 'Cơm Noon', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1598', 'Linh Pham', '911136336', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1599', 'Hương Nguyễn', '399704908', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1600', 'Nhật Phương Phú Mỹ Hưng', 'Nhật Phương Phú Mỹ Hưng', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1601', 'Anna Mỹ Liên', '938652411', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1602', 'Hoàng', '938713807', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1603', 'Choco Phuong', 'Choco Phuong', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1604', 'Anh Vinh', 'Anh Vinh', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1605', 'Nguyễn Duy Đức Huy', '335131003', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1606', 'Anh Duy', 'Anh Duy', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1607', 'Anh Duy', 'Anh Duy...', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1608', 'Xuan Trang', 'Xuan Trang', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1609', 'Thành', 'Thành, Grizz, Ny', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1610', 'Cẩm Nguyệt', 'Cẩm Nguyệt', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1611', 'Hoàng Thạch Nguyễn', '965606029', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1612', 'Trung Tín', '359580653', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1613', 'Kim Chii', '379326605', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1614', 'Phương Phi', 'Phương Phi', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1615', 'Phương Phi', 'Phương Phi...', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1616', 'Ngô Mậu Di', 'Ngô Mậu Di', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1617', 'Thuận Hoàng Coffee', '974087795', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1618', 'Vĩnhcao', 'Vĩnhcao', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1619', 'Vy Huỳnh', '933750155', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1620', 'Tarek', '979199660', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1621', 'Q Huyện', 'Q Huyện', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1622', 'Quỳnh Nie', 'Quỳnh Nie', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1623', 'Lâm Mẫn Nghi', 'Lâm Mẫn Nghi', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1624', 'Minh Trang', '961880609', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1625', 'Hiểu San', 'Hiểu San', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1626', 'Hải Đăng', '909400370', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1627', 'Gotco', 'Gotco', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1628', 'Thanh Diệu', '932955810', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1629', 'Thanh Diệu', '932955810', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1630', 'Lưu Thị Hoà', '908155111', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1631', 'Khánh Mai', '090 3320786', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1632', 'Công Hậu', '372561349', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1633', 'Thanh Hung', 'Thanh Hung', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1634', 'Hoàng Sơn', '969001333', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1635', 'Mr Đức', '397777526', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1636', 'Xuân Hương', '334555816', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1637', 'Trinh Phạm', '908544938', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1638', 'Thanh Nhân Kata', '384479063', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1639', 'Huỳnh Hữu Thành', '357788541', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1640', 'Quốc Huy', 'Quốc Huy', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1641', 'Trang Phan', '775760729', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1642', 'Miu', '399380946', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1643', 'Hứa Phúc Đạt', 'Hứa Phúc Đạt', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1644', 'Phương Anh Trần', 'Phương Anh Trần', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1645', 'Anh Thư', '337452454', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1646', 'Mn', '888165897', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1647', 'Phương Trâm', '906863945', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1648', 'Nghĩa', '989507434', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1649', 'Chu Viên Thế Kiên', '367546960', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1650', 'Phú Thành', '906634709', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1651', 'Snetel And Queen Global', '383935515', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1652', 'Huyền', 'Huyền', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1653', 'CTY HIKARI', '333122119', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1654', 'Thanh Thúy', 'Thanh Thúy', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1655', 'Truong Ngoc Binh', 'Truong Ngoc Binh', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1656', 'Đatvo', 'Đatvo', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1657', 'Huyen Nguyen', '868429990', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1658', 'Jenny', '367824306', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1659', 'Ngân', '919128161', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1660', 'Đông', '326060260', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1661', 'Linh Nguyen', 'Linhhh', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1662', 'Lê Ngân', '765293865', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1663', 'Trâm', 'Trâm', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1664', 'Chị Hiền', 'hienclvcongnocanhan', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1665', 'Ái My', '798442613', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1666', 'Khánh Tiên Nexus', '706868680', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1667', 'Jenny Pham', 'Jenny Pham', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1668', 'Tnguynn', '917843379', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1669', 'Châu Phạm', 'Châu Phạm', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1670', 'Đỗ Hữu Đồng', '908336100', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1671', 'Dung Dung', '927384738', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1672', 'Trương Hiếu Ngân', 'Trương Hiếu Ngân', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1673', 'Long', 'Long', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1674', 'Quỳnh Nie', '767723607', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1675', 'Ngân Nguyễn', '973852926', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1676', 'Nguyễn Hồ Lan', '908551982', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1677', 'Nam', '968958154', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1678', 'Ngọc', '825032433', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1679', 'Phương Nhi', '377434372', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1680', 'Bích Phượng', 'Bích Phượng', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1681', 'Son Min Seok', 'Son Min Seok', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1682', 'Khánh Ly', 'Khánh Ly', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1683', 'CTY ĐẠI VIỆT LOG', '#ERROR!', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1684', 'Nguyễn Lợi', '983751545', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1685', 'Danle', 'Danle', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1686', 'anh Phương', '374160806', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1687', 'Lê Nhi', '911120779', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1688', 'Vũ Minh Quyên', '932417837', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1689', 'Thanhtruc', '399976783', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1690', 'Khách Anh Huy', 'Khách Anh Huy', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1691', 'Quynh Tran', '984690067', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1692', 'phuongthanh Tran', 'thanh....', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1693', 'Huynhthungocx', '902715551', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1694', 'Trần Tấn Phát', 'Trần Tấn Phát', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1695', 'Hà tuyết', '356724198', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1696', 'Cao Ngân Giang', 'Cao Ngân Giang', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1697', 'Thảo Đinh', 'Thảo Đinh', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1698', 'Khánh Phụng', '916231825', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1699', 'Yếnn', 'Yếnn', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1700', 'Phan Hoang', '909213241', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1701', 'Thảo My', 'Thảo My', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1702', 'Hồng Ngọc', '921803961', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1703', 'Nhi', '767879795', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1704', 'Thu Trang', 'Thu Trang', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1705', 'Hoàng Phúc', 'Hoàng Phúc', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1706', 'Nguyễn Trần Quốc Bảo', 'BẢO,,', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1707', 'CTY FunFusion', 'FunFusion', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1708', 'Hung Bass', 'Hung Bass', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1709', 'Nhật Phượng', '559601185', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1710', 'Trương Hiếu Ngân', '949000951', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1711', 'Tú Nguyên', '763792542', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1712', 'Thục Anh', '919140591', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1713', 'Mary', 'Mary', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1714', 'Hữu Nhân', 'Hữu Nhân', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1715', 'Nhi Nhi', '707336023', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1716', 'Trang', '352515893', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1717', 'Nguyễn Chí Cường', 'Nguyễn Chí Cường', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1718', 'Ms Tâm', 'Ms Tâm', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1719', 'Hong Nguyen', '707603074', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1720', 'Duy', 'Duy', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1721', 'Tthphượng Thái Tuấn', 'Tthphượng Thái Tuấn', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1722', 'Hà Thúy Ngọc', 'Hà Thúy Ngọc', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1723', 'Trí Trương', 'Trí Trương', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1724', 'Vân Anh', '973394745', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1725', 'Tuấn Minh', '963141165', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1726', 'Tran Nguyen', 'Tran Nguyen', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1727', 'Tuyết Nga (CTY TẦM NHÌN MỚI)', 'Tuyết Nga', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1728', 'Cẩm Linh', '905469357', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1729', 'Vị Vương', 'Vị Vương', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1730', 'Nguyễn Nhật Thông', '773909602', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1731', 'Bella', 'Bella', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1732', 'Trần Ngọc Loan Idc', '901779515', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1733', 'Linh Nguyen', '842593848', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1734', 'Mai Tran', '909579898', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1735', 'Bích Ngà', '966799207', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1736', 'Yến Nhi', '379448061', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1737', 'Duy Hưng', 'Duy Hưng', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1738', 'Khanh Phạm', 'Khanh Phạm', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1739', 'Kate Phạm', 'Kate Phạm', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1740', 'Đoàn Ngọc Trường', 'Đoàn Ngọc Trường', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1741', 'Nguyễn Nhã', 'Nguyễn Nhã', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1742', 'Duyên Trần', '398871270', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1743', 'Trần Vĩ', '859949999', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1744', 'Trần Vĩ', '859949999', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1745', 'Liên', 'Liên', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1746', 'Đại Thiên Phú', 'In ấn thiệp-bao thư Phúc-7luck-CTY P&D', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1747', '7luck', 'In ấn thiệp-bao thư Phúc-7luck', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1748', 'Lương Vỹ', 'Lương Vỹ', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1749', 'Lê Thu', '977929172', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1750', 'Văn Anh Kiệt', 'Văn Anh Kiệt', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1751', 'Minh Tuyến', 'Minh Tuyến', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1752', 'Trần Vinh', 'Trần Vinh', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1753', 'Nhi Nguyễn', 'Nhi Nguyễn', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1754', 'Phương Nam', 'Phương Nam', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1755', 'Trunng tâm plana', 'Trung tâm plana', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1756', 'Huyền Trân', '818220761', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1757', 'YẾN SƯƠNG', 'namecard', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1758', 'Trần Thị Anh Thư', 'Trần Thị Anh Thư', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1759', 'Huỳnh Dung Gl', 'Huỳnh Dung Gl', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1760', 'Huy Cường Toàn Ánh', '949343605', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1761', 'Huy Cường Toàn Ánh', '949343605', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1762', 'Nguyễn Việt Hương', '981476178', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1763', 'Viet Do', 'Viet Do', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1764', 'Quanha', 'Quanha', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1765', 'Thảo', 'Thảo', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1766', 'Thảo', 'Thảo Thảo', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1767', 'Quế Anh', 'Quế Anh', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1768', 'Trần Đức Minh', '357960903', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1769', 'Đặng Quyên', 'Đặng Quyên', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1770', 'Đặng Quyên', 'Đặng Quyên anh cảnh', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1771', 'Duy Toàn', 'Duy Toàn', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1772', 'Trần Thắng Nhật', '968345007', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1773', 'Anh Khoa Dsmart', 'Anh Khoa Dsmart', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1774', 'Anh Khoa Dsmart', 'Anh Khoa Dsmart///', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1775', 'Anh Khoa Dsmart', 'Anh Khoa..', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1776', 'Anh Khoa Dsmart', '0', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1777', 'Ngô Quốc Dũng', '916163460', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1778', 'Laer', 'Laer', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1779', 'Suli', '934564548', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1780', 'Lữ Ly', '971177237', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1781', 'Trinh Gia Tuong', 'Trinh Gia Tuong', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1782', 'Lyn Lyn', '908400288', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1783', 'Minh Chu', 'Minh Chu', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1784', 'Kim Ngân - Khả Vương', 'Kim Ngân-Khả Vương', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1785', 'Áo dài Nhã Yến', '968821755', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1786', 'Lê Thị Phương Ánh', '937591394', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1787', 'Lệ Quyên', 'Lệ Quyên...', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1788', 'Ceci - Khánh Linh', 'Ceci-Khánh Linh', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1789', 'Nhoo', '094 2899703', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1790', 'Tuyen Ly', '978371672', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1791', 'Lý Kim Tú', '968888052', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1792', 'Ho Cong Luan', 'Ho Cong Luan', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1793', 'Vinamilk Midtown', '345313511', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1794', 'Khắc Huy', '866443459', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1795', 'Hung Van', '906784680', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1796', 'Trúc Phạm', '373012357', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1797', 'Kiều', '348282660', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1798', 'Hanh Nguyen', 'Hanh Nguyen', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1799', 'Mỹ Duyên', '387245849', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1800', 'Quỳnh', '707036085', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1801', 'Bùi Thanh Hưng', 'Bùi Thanh Hưng', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1802', 'Chau Nguyen Bui', 'Chau Nguyen Bui', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1803', 'Anh Phúc', 'Anh Phúc', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1804', 'Trung Ái', '339362870', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1805', 'Mai Long', 'Mai Long', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1806', 'Lê Thị Cẩm Nhung', '909892179', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1807', 'Stella', '945983978', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1808', 'Stella', '945983978', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1809', 'Viet Tran', 'Viet Tran', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1810', 'Kim Nguyên', 'Kim Nguyên', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1811', 'Tai Nguyen', '935518271', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1812', 'Võ Thắng', 'Võ Thắng', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1813', 'Stella', '945983978', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1814', 'CTY BÁNH MỨT THÀNH LONG 1', '936431068', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1815', 'Vinamilk', 'Vinamilk', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1816', 'James Lee', '932736662', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1817', 'Phan Gia Kiến', '933637883', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1818', 'Hg Trâm', 'Hg Trâm', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1819', 'Nguyen Nhan', 'Nguyen Nhan', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1820', 'Hồng Yến Nhi', 'Hồng Yến Nhi', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1821', 'Hoàng Huy', 'Hoàng Huy', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1822', 'Nguyễn Thị Thanh Thảo', '944117137', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1823', 'Chuyên hàng thanh lý', 'Chuyên hàng thanh lý', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1824', 'Trần Thị Thu Hạnh', 'Trần Thị Thu Hạnh', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1825', 'T T K', '702228023', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1826', 'Phạm Thị Thảo Nguyên', 'Phạm Thị Thảo Nguyên', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1827', 'Trân Mèo', 'Trân Mèo', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1828', 'cô Nhung Đặng', 'Nhung Đặng', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1829', 'Khang Nguyen - Tom', '768574834', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1830', 'Giò Chả Hải Hương', 'Giò Chả Hải Hương', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1831', 'Đình Khanh', '967750571', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1832', 'Ngọc Mai (CÔNG TY TNHH LN PARTNERS)', 'Ngọc Mai (CÔNG TY TNHH LN PARTNERS)', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1833', 'An Nguyen', '943045669', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1834', 'Lê Huy', 'Lê Huy', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1835', 'Pháp', '942351390', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1836', 'Kim Thùy', '967920634', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1837', 'Mr Lee Vu / anh Linh', '917177777', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1838', 'Nhơn', '984144311', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1839', 'Ngô Văn Việt', '949146704', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1840', 'Phan Thị Diễm', 'Phan Thị Diễm', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1841', 'Đồng - Hạt Điều Đồng Phú', '985706499', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1842', 'Phương Thảo', 'Phương Thảo', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1843', 'Sarah Xuân Mai', 'Sarah Xuân Mai', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1844', 'Phạm Công Trường', '945299896', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1845', 'Nguyễn Tuấn Anh', '822949898', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1846', 'Linh Lam', '938724968', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1847', 'Ngọc Ngân', 'Ngọc Ngân', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1848', 'Timmy Trần Tú Hr Aplus', 'Timmy Trần Tú Hr Aplus', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1849', 'Phong Tạ', '774578123', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1850', 'Lài Nguyễn', 'Lài Nguyễn', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1851', 'Huyền Trân', '818220761', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1852', 'Tan Nguyen', 'Tan Nguyen', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1853', 'Đức', 'Đức', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1854', 'Thanh Thanh', 'Thanh Thanh', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1855', 'Nguyen Danh', '373039073', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1856', 'Ốc Trang', '908222295', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1857', 'Huyền Muzu', '982450613', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1858', 'Duy Khánh', '382930331', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1859', 'Nguyễn Huỳnh Hải Âu', '397373672', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1860', 'Lý Bội Tuyền', 'Lý Bội Tuyền', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1861', 'Phương Nguyễn', 'Phương Nguyễn', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1862', 'Phan Trần Lâm Anh', 'Phan Trần Lâm Anh', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1863', 'Vũ Uyên Minh', '842500156', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1864', 'Huyen Kate', 'Huyen Kate', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1865', 'Phan Tường Vi', 'Phan Tường Vi', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1866', 'Hoà Võ', 'Hoà Võ', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1867', 'Duy Thảo', 'Duy Thảo', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1868', 'Nguyễn Hải', 'Nguyễn Hải', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1869', 'Nguyễn Thị Hồng Vân', 'Nguyễn Thị Hồng Vân', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1870', 'Quách Viễn Lập', 'Quách Viễn Lập', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1871', 'Quách Viễn Lập', '988033378', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1872', 'Phạm Ngọc Khánh', 'Phạm Ngọc Khánh', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1873', 'Hùng Nguyễn', 'EXPC', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1874', 'Chị Linh Tropika', '906230491', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1875', 'Vĩnh Khương', '924056453', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1876', 'Huệ Tropika', 'Huệ Tropika', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1877', 'Thúy An', 'Thúy An', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1878', 'Lâm Ngọc Đào', 'Lâm Ngọc Đào', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1879', 'Nguyên Nguyễn', 'Nguyên Nguyễn', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1880', 'Lê Đức Trí', '868177716', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1881', 'Trần Nguyễn Phương Khanh', '917507095', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1882', 'Đỗ Nhi', 'Đỗ Nhi', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1883', 'Phương Linh', '336219936', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1884', 'Dung Ngo', '903569725', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1885', 'Phạm Hoài Duy', 'Phạm Hoài Duy', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1886', 'Nhung Nguyễn', 'Nhung Nguyễn', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1887', 'Minh', 'Minh', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1888', 'Lê Minh Tùng', 'Lê Minh Tùng', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1889', 'Quỳnh Anh Nguyễn', 'Quỳnh Anh Nguyễn', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1890', 'Edyi', 'Edyi', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1891', 'Thu Trà', 'Thu Trà', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1892', 'Xuân Hương', 'Xuân Hương', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1893', 'Chi Chi', '523381511', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1894', 'Nanci Ngọc Huỳnh', 'Nanci Ngọc Huỳnh', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1895', 'Kim Le', '777003985', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1896', 'Truyền', 'Truyền', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1897', 'Phạm Thuỳ Dương', '931867938', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1898', 'Thu Huyền', 'Thu Huyền', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1899', 'Mai Thành Đạt', 'Mai Thành Đạt', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1900', 'Nguyễn Nhật Vy', '702953837', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1901', 'Wendy Lan Trần', '972133436', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1902', 'Kit', 'Kit', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1903', 'Kim Chi', '948007266', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1904', 'Thảo Nguyên', 'Thảo Nguyên ( FB)', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1905', 'Bún Đậu Thuần Nhiên', '814897939', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1906', 'Nhi Pham', 'Nhi Pham', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1907', 'Bùi Hải Yến', 'Bùi Hải Yến', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1908', 'Jedidiah Huong Thom', '908719150', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1909', 'Nguyễn Thái Hòa', 'Nguyễn Thái Hòa', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1910', 'Hoàng Nhi', '335697820', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1911', 'Dũng', '788884490', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1912', 'Nguyễn Thái Duy', '704402596', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1913', 'Hùng Lê', '866507107', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1914', 'Châu Trần', 'Châu Trần', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1915', 'Thao Nguyen', 'Thao Nguyen', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1916', 'Hồng Lê', '908618073', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1917', 'Henry He', 'Henry He', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1918', 'Hvaj Languages', '949863413', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1919', 'Trần Văn Thiên', '347767817', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1920', 'Han Hoang', 'Han Hoang', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1921', 'Thùy Trâm', 'Thùy Trâm', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1922', 'Thục Trang', 'Thục Trang', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1923', 'Hà Thúy Ngọc', '812015776', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1924', 'Đức Quân', '794451413', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1925', 'Hf', '707021202', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1926', 'Vân Anh', 'Vân Anh', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1927', 'Thân Thương', 'Thân Thương', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1928', 'An Nguyễn', 'An Nguyễn', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1929', 'CTY TOẢ SÁNG', 'CTY..', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1930', 'Huy Toàn', 'Huy Toàn', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1931', 'Dũng', 'Dũng', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1932', 'COP LAM HỒNG', 'COP', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();

INSERT INTO customers (code, name, phone, address, email, crm_notes, updated_at)
VALUES ('KH25.1933', 'Kloe Nguyen', '932864607', NULL, NULL, NULL, NOW())
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    phone = EXCLUDED.phone,
    address = EXCLUDED.address,
    email = EXCLUDED.email,
    crm_notes = EXCLUDED.crm_notes,
    updated_at = NOW();
