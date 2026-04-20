-- CHECK 1: Profile Commission Tiers for 'test nv kinh doanh'
SELECT full_name, commission_tiers 
FROM profiles 
WHERE full_name ILIKE '%test nv kinh doanh%';

-- CHECK 2: Sales Targets for 12/2025
SELECT * 
FROM sales_targets 
WHERE period_month = 12 AND period_year = 2025;

-- CHECK 3: Run the calculation manually to see intermediate values (if possible via debug prints, but here we just check inputs)
-- We can also check the total sales helper query
SELECT COALESCE(SUM(total_amount_pre_vat), 0) as total_sales_verified
FROM orders
WHERE EXTRACT(MONTH FROM COALESCE(delivery_date, created_at)) = 12
  AND EXTRACT(YEAR FROM COALESCE(delivery_date, created_at)) = 2025
  AND status IN ('HoanThanh', 'DaGiaoHang');
