ALTER TABLE orders 
ADD COLUMN IF NOT EXISTS status_note text;

-- Verify other note columns exist just in case
ALTER TABLE orders 
ADD COLUMN IF NOT EXISTS design_note text,
ADD COLUMN IF NOT EXISTS large_print_note text,
ADD COLUMN IF NOT EXISTS be_demi_note text,
ADD COLUMN IF NOT EXISTS outsource_note text,
ADD COLUMN IF NOT EXISTS ep_kim_note text;
