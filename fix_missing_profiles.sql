-- Sync profiles from auth.users
-- This script ensures that every user in auth.users has a corresponding entry in public.profiles

INSERT INTO public.profiles (id, email, full_name, role)
SELECT 
    id, 
    email, 
    COALESCE(raw_user_meta_data->>'full_name', email) as full_name,
    'Admin' as role -- Default to Admin for dev, or 'NhanVienKinhDoanh'
FROM auth.users
WHERE id NOT IN (SELECT id FROM public.profiles)
ON CONFLICT (id) DO NOTHING;
