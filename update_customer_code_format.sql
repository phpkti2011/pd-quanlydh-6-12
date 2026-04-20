-- Updated Customer Code Generation (KH + YY + . + Sequence)
-- Format: KH25.0001
CREATE OR REPLACE FUNCTION generate_customer_code()
RETURNS TEXT
LANGUAGE plpgsql
AS $$
DECLARE
    year_prefix TEXT;
    next_seq INT;
    new_code TEXT;
BEGIN
    -- Get current year last 2 digits (e.g., '25')
    year_prefix := to_char(NOW(), 'YY');
    
    -- Find max code for current year to increment
    -- Codes starting with 'KH' + year_prefix + '.'
    -- Example: KH25.1741 -> Extraction needs to handle the dot
    -- Regex: Extract digits after the last dot
    
    SELECT COALESCE(MAX(SUBSTRING(code FROM '\.([0-9]+)$')::INT), 0) + 1
    INTO next_seq
    FROM customers
    WHERE code LIKE 'KH' || year_prefix || '.%';

    -- Format: KH + YY + . + 0000 (padding)
    new_code := 'KH' || year_prefix || '.' || lpad(next_seq::TEXT, 4, '0');
    
    RETURN new_code;
END;
$$;
