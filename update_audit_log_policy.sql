-- Drop the restrictive policy
drop policy if exists "Admins and Managers can view all logs" on user_logs;

-- Create a new permissive policy for viewing logs
-- Option 1: Allow all authenticated users to view all logs (Transparent collaboration)
create policy "Authenticated users can view logs"
    on user_logs for select
    to authenticated
    using (true);

-- Option 2 (Alternative - commented out): Allow standard employees to view only logs related to orders they participate in? 
-- Too complex for now. Let's assume transparency is fine for internal logs.
