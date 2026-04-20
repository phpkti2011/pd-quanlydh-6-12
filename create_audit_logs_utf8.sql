-- Create user_logs table for audit trail
create table if not exists public.user_logs (
    id uuid default gen_random_uuid() primary key,
    created_at timestamptz default now(),
    user_id uuid references auth.users(id),
    user_name text, -- Cache name for faster display
    action_type text, -- 'LOGIN', 'ORDER_CREATE', 'ORDER_UPDATE', 'PAYMENT_ADD', etc.
    entity_id text, -- e.g. 'DH-123'
    entity_type text, -- 'order', 'customer', 'payment', 'system'
    details jsonb, -- e.g. { "old": "...", "new": "..." }
    ip_address text
);

-- Indexes for performance
create index if not exists idx_user_logs_user_id on user_logs(user_id);
create index if not exists idx_user_logs_action_type on user_logs(action_type);
create index if not exists idx_user_logs_created_at on user_logs(created_at);
create index if not exists idx_user_logs_entity_id on user_logs(entity_id);

-- RLS Policies
alter table user_logs enable row level security;

-- Insert: Everyone can insert their own logs (or system can insert)
create policy "Authenticated users can insert logs"
    on user_logs for insert
    to authenticated
    with check (true);

-- Select: Only Admin, KeToan, QuanLySanXuat can view logs
create policy "Admins and Managers can view all logs"
    on user_logs for select
    to authenticated
    using (
        exists (
            select 1 from profiles
            where profiles.id = auth.uid()
            and profiles.role in ('Admin', 'KeToan', 'QuanLySanXuat')
        )
    );
