
-- Update the role of the user with email 'test@pnd.com' (or similar) to 'Admin'
UPDATE profiles
SET role = 'Admin'
WHERE email LIKE '%test@pnd.com%';
