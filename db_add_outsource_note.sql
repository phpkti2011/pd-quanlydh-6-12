-- Add outsource_note column to orders table
ALTER TABLE orders ADD COLUMN IF NOT EXISTS outsource_note TEXT;
