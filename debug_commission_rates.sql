-- =====================================================
-- FIX: Clean up duplicate commission_policies + fix rates
-- Run in Supabase SQL Editor (PRODUCTION)
-- =====================================================

-- 1. Check current state (debug only - see results tab)
SELECT id, policy_type, apply_to, rate FROM commission_policies 
WHERE policy_type IN ('MAINTASK_RATE', 'SUBTASK_RATE') 
ORDER BY policy_type, apply_to;
