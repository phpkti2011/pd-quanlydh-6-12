
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'orders' 
AND column_name IN ('vat_rate', 'vat_amount', 'total_amount_pre_vat', 'invoice_info', 'invoice_status');
