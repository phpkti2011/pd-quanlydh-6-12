-- Add new roles to the user_role ENUM type if they don't exist
ALTER TYPE user_role ADD VALUE IF NOT EXISTS 'QuanLySanXuat';
ALTER TYPE user_role ADD VALUE IF NOT EXISTS 'NhanVienBinhFile';
ALTER TYPE user_role ADD VALUE IF NOT EXISTS 'NhanVienThietKe';
