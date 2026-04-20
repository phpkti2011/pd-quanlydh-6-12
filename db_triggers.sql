-- Function to update order status based on participant activity
CREATE OR REPLACE FUNCTION auto_update_order_status()
RETURNS TRIGGER AS $$
DECLARE
    new_status order_status;
BEGIN
    -- Determine status based on the stage being started
    -- Note: We map the 'stage' (from app) to the corresponding 'status' (in db)
    CASE NEW.stage
        WHEN 'BinhFile' THEN new_status := 'BinhFile';
        WHEN 'In' THEN new_status := 'In';
        WHEN 'ThanhPham' THEN new_status := 'ThanhPham';
        -- Add other mappings if necessary, e.g. if 'DongGoi' is a stage in participants
    ELSE
        -- If stage doesn't map to a primary status, do nothing
        RETURN NEW;
    END CASE;

    -- Update the order status
    UPDATE orders
    SET status = new_status,
        updated_at = NOW()
    WHERE id = NEW.order_id
    -- Optional: Only update if the current status is "earlier" in the workflow? 
    -- For now, we trust the latest action determines the status.
    AND status != 'Huy' AND status != 'HoanThanh';

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger definition
DROP TRIGGER IF EXISTS on_participant_added ON order_process_participants;
CREATE TRIGGER on_participant_added
AFTER INSERT ON order_process_participants
FOR EACH ROW
EXECUTE PROCEDURE auto_update_order_status();
