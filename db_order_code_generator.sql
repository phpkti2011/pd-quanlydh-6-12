-- =====================================================
-- Order Code Auto-Generation Function and Trigger
-- =====================================================
-- Format: YYPD.MMDD.NNNN
-- Example: 25PD.1210.0001
--   25 = Year (2025)
--   PD = Company prefix
--   1210 = Date (December 10)
--   0001 = Daily sequence number

-- Drop existing function and trigger if they exist
DROP TRIGGER IF EXISTS before_insert_order_code ON orders;
DROP FUNCTION IF EXISTS set_order_code();
DROP FUNCTION IF EXISTS generate_order_code();

-- Function to generate next order code
CREATE OR REPLACE FUNCTION generate_order_code()
RETURNS TEXT
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    date_part TEXT;
    seq_part INT;
    new_code TEXT;
    start_of_month TIMESTAMP WITH TIME ZONE;
BEGIN
    -- Format: YYPDDDMM.NNNN
    -- Example: 25PD2212.0021 (22nd Dec 2025, 21st order of month)
    
    -- 1. Generate Date Part: YY + PD + DDMM
    date_part := to_char(NOW() AT TIME ZONE 'Asia/Ho_Chi_Minh', 'YY') || 'PD' || to_char(NOW() AT TIME ZONE 'Asia/Ho_Chi_Minh', 'DDMM');
    
    -- 2. Calculate Monthly Sequence
    -- Count existing orders in the current month (Asia/Ho_Chi_Minh)
    start_of_month := date_trunc('month', NOW() AT TIME ZONE 'Asia/Ho_Chi_Minh');
    
    SELECT COUNT(*) + 1
    INTO seq_part
    FROM orders
    WHERE created_at >= start_of_month;
    
    -- 3. Combine
    new_code := date_part || '.' || lpad(seq_part::TEXT, 4, '0');
    
    RETURN new_code;
END;
$$;

-- Trigger function to auto-set order_code on insert
CREATE OR REPLACE FUNCTION set_order_code()
RETURNS TRIGGER AS $$
BEGIN
    -- Only generate if order_code is not provided or empty
    IF NEW.order_code IS NULL OR NEW.order_code = '' THEN
        NEW.order_code := generate_order_code();
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Attach trigger to orders table
CREATE TRIGGER before_insert_order_code
BEFORE INSERT ON orders
FOR EACH ROW
EXECUTE FUNCTION set_order_code();

-- Test the function
-- SELECT generate_order_code();
