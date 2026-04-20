-- CONVERSATIONAL NOTES SCHEMA
-- Stores history of all note edits/inputs as a conversation thread.

BEGIN;

CREATE TABLE IF NOT EXISTS order_comments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_id UUID REFERENCES orders(id) ON DELETE CASCADE NOT NULL,
    user_id UUID REFERENCES profiles(id) ON DELETE SET NULL, -- Keep comment even if user deleted
    
    context_key TEXT NOT NULL, -- e.g. 'order_note', 'status_note', 'design_note'
    content TEXT NOT NULL,
    
    -- AI Analysis of what changed (if this was an edit)
    ai_summary TEXT, 
    
    -- Metadata
    is_auto_generated BOOLEAN DEFAULT FALSE, -- for system messages
    
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Index for fast retrieval by order/context
CREATE INDEX IF NOT EXISTS idx_order_comments_lookup ON order_comments(order_id, context_key);
CREATE INDEX IF NOT EXISTS idx_order_comments_created_at ON order_comments(created_at);

-- RLS
ALTER TABLE order_comments ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Read comments" ON order_comments FOR SELECT USING (true);
CREATE POLICY "Insert comments" ON order_comments FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Migration: Optional - migrate existing single-notes to first comment?
-- We can leave existing columns as "Latest state" cache, and use this table for history.
-- Making this additive is safer.

COMMIT;

NOTIFY pgrst, 'reload schema';
