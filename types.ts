export type UserRole = 'Admin' | 'NhanVienKinhDoanh' | 'NhanVienSanXuat' | 'QuanLySanXuat' | 'KeToan' | 'Khach' | 'NhanVienBinhFile' | 'NhanVienThietKe';
export type OrderStatus = 'Moi' | 'TiepNhan' | 'NhanFile' | 'XuLyFile' | 'BinhFile' | 'In' | 'ThanhPham' | 'DongGoi' | 'ChoGiaoHang' | 'GiaoHang' | 'HoanThanh' | 'Huy' | 'TamNgung' | 'DaGiaoHang';
export type PaymentStatus = 'ChuaThanhToan' | 'DaCoc' | 'DaThanhToan' | 'CongNo';

export interface Profile {
  id: string;
  email: string;
  full_name?: string;
  role: UserRole;
  phone_number?: string;
  base_salary_config?: any;
  created_at: string;
  updated_at?: string;

  // Employee Management Fields
  employee_code?: string;
  position?: string;
  competency_score?: number;
  commission_rate?: number;
  subtask_commission_policy?: number;
  sales_commission_policy?: number;

  // JSON Config for Detailed Commission
  commission_subtasks?: Record<string, number>;
  commission_stages?: Record<string, number>;
  commission_tiers?: { min: number; max: number; rate: number; note?: string }[];
  is_locked?: boolean;
  product_manager_commission_rate?: number;
}

export interface SalesTarget {
  id: string;
  entity_type: 'user' | 'department' | 'company';
  entity_id?: string; // Nullable for department/company if not using profile ID
  department_name?: string; // 'Sales', 'Company'
  period_month: number;
  period_year: number;
  target_amount: number;
  created_at?: string;
  updated_at?: string;
}

export interface Customer {
  id: string;
  code: string;
  name: string;
  phone?: string;
  email?: string;
  address?: string;
  source?: string;
  crm_notes?: string;
  tier?: 'Đồng' | 'Bạc' | 'Vàng' | 'Bạch Kim';
  tags?: string[];
  loyalty_points?: number;

  // CRM Upgrade Phase 1
  refused_provide_phone?: boolean;
  is_urgent_entry?: boolean;
  order_count?: number;
  last_order_at?: string;

  // Phase 3: Pipeline
  pipeline_stage?: 'NEW' | 'QUOTED' | 'NEGOTIATING' | 'WON' | 'LOST';

  // Ownership
  sales_rep_id?: string;
  sales_rep?: { full_name: string }; // For display

  created_at: string;
  updated_at?: string;
}

export interface Order {
  id: string;
  order_code: string;
  customer_id?: string;
  sales_rep_id?: string;

  description?: string;
  notes?: string;
  status_note?: string;

  // Payment Confirmation
  payment_confirmed?: boolean;
  payment_method_deposit?: string;
  payment_method_remaining?: string;
  payment_note?: string;
  payment_confirmed_by?: string;
  payment_confirmed_at?: string;

  invoice_info?: string;
  delivery_address?: string;
  tracking_code?: string; // Legacy or external?
  tracking_token?: string; // New Secure Token
  payment_random_code?: string; // Random code for non-VAT transfers

  payment_confirmed_by_user?: { full_name: string };

  has_design: boolean;
  design_fee: number;
  has_large_print: boolean;
  large_print_fee: number;
  has_be_demi: boolean;
  be_demi_fee: number;
  has_gia_cong_ngoai: boolean;
  gia_cong_ngoai_fee: number;
  outsource_note?: string;
  has_ep_kim: boolean;
  ep_kim_fee: number;
  has_can_mang: boolean;
  can_mang_fee: number;

  // Task Statuses (Added for Tabs)
  design_status?: 'Pending' | 'Completed';
  large_print_status?: 'Pending' | 'Completed';
  be_demi_status?: 'Pending' | 'Completed';
  outsource_status?: 'Pending' | 'Completed';
  ep_kim_status?: 'Pending' | 'Completed';
  invoice_status?: 'Pending' | 'Issued';

  total_amount_pre_vat: number;
  vat_rate: number;
  vat_amount: number;
  total_amount: number;
  deposit_amount: number;
  remaining_amount: number;

  status: OrderStatus;
  payment_status: PaymentStatus;
  is_urgent: boolean;
  delivery_date?: string;

  created_at: string;
  updated_at?: string;

  // Joins
  customer?: Customer;
  sales_rep?: Profile;
  participants?: OrderProcessParticipant[];
}


export interface OrderProcessParticipant {
  id: string;
  order_id: string;
  user_id?: string;
  stage: string;
  started_at: string;
  completed_at?: string;
  contribution_weight?: number;
  created_at: string;

  // Joins
  user?: Profile;
}

export interface CommissionPolicy {
  id: string;
  policy_type: 'SALES_TIER' | 'GROUP_TIER' | 'SUBTASK_RATE' | 'MAINTASK_WEIGHT' | 'PRODUCTION_TIER';
  apply_to?: string;
  threshold_min?: number;
  threshold_max?: number;
  rate: number;
}

export interface SalesCommissionResult {
  sales_rep_name: string;
  personal_sales: number;
  completed_sales?: number;         // NEW: Doanh số đơn hoàn thành
  completed_order_count?: number;   // NEW: Số đơn hoàn thành
  personal_comm: number;
  group_sales_total: number;
  group_comm: number;
  total_comm: number;
  commission_tiers?: { min: number; max: number; rate: number }[];
  total_orders: number;
  highest_order_value: number;
  new_customers: number;
  success_rate: number;
  active_days: number;
  group_rate?: number;
  group_bonus_fund?: number;
}

export interface StaffCommissionResult {
  participant_name: string;
  main_task_comm: number;
  sub_task_comm: number;
  total_comm: number;
  tier_percentage?: number;          // Hệ số mốc thưởng sản xuất (0, 70, 100, 150)
  completed_sales?: number;
  completed_order_count?: number;
}

export interface ProductionTierSummary {
  total_revenue: number;
  current_tier_pct: number;
  next_tier_threshold: number | null;
  next_tier_pct: number | null;
  all_tiers: { min: number; max: number | null; rate: number }[];
}

export interface CustomerAnalytics {
  totalRevenue: number;
  orderCount: number;
  lastOrderDate: string;
  avgDaysBetweenOrders: number;
}

export interface CustomerLog {
  id: string;
  customer_id: string;
  type: 'Call' | 'Visit' | 'Note' | 'Complaint';
  content: string;
  created_by?: string;
  created_at: string;
  created_by_user?: { full_name: string };
}

export interface InvoiceProfile {
  id: string;
  customer_id: string;
  company_name: string;
  tax_code: string;
  address?: string;
  email?: string;
  is_default: boolean;
  created_at?: string;
}

export interface AppNotification {
  id: string;
  user_id: string;
  title: string;
  message: string;
  type: string;
  reference_id?: string;
  link?: string;
  is_read: boolean;
  created_at: string;
}
