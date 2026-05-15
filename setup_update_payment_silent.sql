-- ============================================================
-- Silent payment update RPC
-- Dùng trong Quản Lý Công Nợ để Chốt TT / Hoàn tác hàng loạt
-- mà KHÔNG bắn notification cho user (tránh spam).
--
-- Bug fix: file setup_production_commission_tiers.sql có chứa
-- hàm này nhưng nhiều DB chưa chạy → 404 khi gọi RPC.
-- Chạy nguyên file này trong Supabase SQL Editor.
-- ============================================================

CREATE OR REPLACE FUNCTION update_payment_silent(
    p_order_id UUID,
    p_payment_status TEXT,
    p_deposit_amount NUMERIC,
    p_remaining_amount NUMERIC
) RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    -- Disable payment notification trigger temporarily (nếu trigger tồn tại)
    BEGIN
        ALTER TABLE orders DISABLE TRIGGER trigger_notify_payment_update;
    EXCEPTION WHEN undefined_object THEN
        -- Trigger không tồn tại, bỏ qua
        NULL;
    END;

    UPDATE orders SET
        payment_status = p_payment_status::payment_status,
        deposit_amount = p_deposit_amount,
        remaining_amount = p_remaining_amount,
        updated_at = NOW()
    WHERE id = p_order_id;

    -- Re-enable trigger (nếu tồn tại)
    BEGIN
        ALTER TABLE orders ENABLE TRIGGER trigger_notify_payment_update;
    EXCEPTION WHEN undefined_object THEN
        NULL;
    END;
END;
$$;

GRANT EXECUTE ON FUNCTION update_payment_silent(UUID, TEXT, NUMERIC, NUMERIC) TO authenticated;

NOTIFY pgrst, 'reload schema';
