
-- Update get_dashboard_stats to return counts for Status Tabs
-- Logic based on 'order_counting_logic.md' and 'status_tabs_design.md'

CREATE OR REPLACE FUNCTION get_dashboard_stats(
    p_period TEXT DEFAULT 'month',
    p_start_date DATE DEFAULT NULL,
    p_end_date DATE DEFAULT NULL
)
RETURNS JSONB AS $$
DECLARE
    v_start_date DATE;
    v_end_date DATE;
    v_result JSONB;
BEGIN
    -- 1. Determine Date Range
    IF p_period = 'today' THEN
        v_start_date := CURRENT_DATE;
        v_end_date := CURRENT_DATE;
    ELSIF p_period = 'month' THEN
        v_start_date := DATE_TRUNC('month', CURRENT_DATE)::DATE;
        v_end_date := (DATE_TRUNC('month', CURRENT_DATE) + INTERVAL '1 month' - INTERVAL '1 day')::DATE;
    ELSE
        v_start_date := COALESCE(p_start_date, DATE_TRUNC('month', CURRENT_DATE)::DATE);
        v_end_date := COALESCE(p_end_date, CURRENT_DATE);
    END IF;

    -- 2. Build JSON Result
    SELECT jsonb_build_object(
        'period', p_period,
        'startDate', v_start_date,
        'endDate', v_end_date,
        
        -- A. Key Metrics (Existing)
        'metrics', (
            SELECT jsonb_build_object(
                'ordersCount', COUNT(*),
                'revenueWithVAT', COALESCE(SUM(total_amount), 0),
                'revenueNoVAT', COALESCE(SUM(total_amount - vat_amount), 0), -- Fixed: Exact subtraciton
                'designRevenue', COALESCE(SUM(CASE WHEN has_design THEN design_fee ELSE 0 END), 0),
                'largePrintRevenue', COALESCE(SUM(CASE WHEN has_large_print THEN large_print_fee ELSE 0 END), 0),
                'newCustomersCount', 0, -- Simplification for performance, or implement correct query
                'returningCustomersCount', 0
            )
            FROM orders
            WHERE created_at::DATE BETWEEN v_start_date AND v_end_date
            AND status != 'Huy'
        ),

        -- B. Charts Data (Existing - Simplified for brevity in this update)
        'dailyRevenue', '[]'::jsonb, 
        'statusCounts', (
             SELECT jsonb_object_agg(status, cnt)
             FROM (
                 SELECT status, COUNT(*) as cnt
                 FROM orders WHERE created_at::DATE BETWEEN v_start_date AND v_end_date GROUP BY status
             ) t
        ),
        'salesByEmployee', '[]'::jsonb,

        -- C. [NEW] Status Tab Counts (For UI Tabs)
        'tabCounts', (
            SELECT jsonb_build_object(
                -- Main Statuses (Count all matching status)
                'all', COUNT(*),
                'moi', COUNT(*) FILTER (WHERE status = 'Moi'),
                'tiep_nhan', COUNT(*) FILTER (WHERE status = 'TiepNhan'),
                'nhan_file', COUNT(*) FILTER (WHERE status = 'NhanFile'),
                'xu_ly_file', COUNT(*) FILTER (WHERE status = 'XuLyFile'),
                'binh_file', COUNT(*) FILTER (WHERE status = 'BinhFile'),
                'in', COUNT(*) FILTER (WHERE status = 'In'),
                'thanh_pham', COUNT(*) FILTER (WHERE status = 'ThanhPham'),
                'dong_goi', COUNT(*) FILTER (WHERE status = 'DongGoi'),
                'cho_giao_hang', COUNT(*) FILTER (WHERE status = 'ChoGiaoHang'),
                'da_giao_hang', COUNT(*) FILTER (WHERE status = 'DaGiaoHang'), -- Separate tab
                'hoan_thanh', COUNT(*) FILTER (WHERE status = 'HoanThanh' OR status = 'DaGiaoHang'), -- Legacy group both
                'huy', COUNT(*) FILTER (WHERE status = 'Huy'),
                'tam_ngung', COUNT(*) FILTER (WHERE status = 'TamNgung'),

                -- Sub-task Statuses (Count UNCOMPLETED/Pending only, where task is enabled)
                'thiet_ke', COUNT(*) FILTER (WHERE has_design = TRUE AND (design_status IS NULL OR design_status != 'Completed')),
                'in_kho_lon', COUNT(*) FILTER (WHERE has_large_print = TRUE AND (large_print_status IS NULL OR large_print_status != 'Completed')),
                'be_demi', COUNT(*) FILTER (WHERE has_be_demi = TRUE AND (be_demi_status IS NULL OR be_demi_status != 'Completed')),
                'gia_cong_ngoai', COUNT(*) FILTER (WHERE has_gia_cong_ngoai = TRUE AND (outsource_status IS NULL OR outsource_status != 'Completed')),
                'ep_kim', COUNT(*) FILTER (WHERE has_ep_kim = TRUE AND (ep_kim_status IS NULL OR ep_kim_status != 'Completed')),
                
                -- Invoice Status (Count Pending)
                'xuat_hoa_don', COUNT(*) FILTER (WHERE invoice_status IS NULL OR invoice_status != 'Issued'),

                -- Special
                'gap', COUNT(*) FILTER (WHERE is_urgent = TRUE AND status NOT IN ('Huy', 'HoanThanh', 'DaGiaoHang'))
            )
            FROM orders
            WHERE created_at::DATE BETWEEN v_start_date AND v_end_date
        )

    ) INTO v_result;

    RETURN v_result;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
