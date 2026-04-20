-- DEBUG: Check where '20%' ratio for 'Thành phẩm' (ThanhPham) is stored
-- Check commission_policies columns and data

SELECT * FROM commission_policies 
WHERE apply_to IN ('ThanhPham', 'Thành phẩm', 'In', 'In ấn');

-- Also check if there is any other table for stage settings?
SELECT table_name FROM information_schema.tables 
WHERE table_schema = 'public';
