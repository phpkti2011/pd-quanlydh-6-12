
export const STATUSES = [
  "📊 Tổng quan",
  "Tất cả",
  "Xuất hóa đơn",
  "Nhận File",
  "Xử lý File",
  "Bình File",
  "In",
  "Thành Phẩm",
  "Đóng gói",
  "Chờ giao hàng",
  "Tạm ngưng",
  "Đã giao hàng",
  "Đã hoàn thành",
  "Gấp",
  "Đã hủy"
];

export const STATUS_LABEL_MAP: Record<string, string> = {
  Moi: "Mới",
  TiepNhan: "Tiếp nhận",
  NhanFile: "Nhận File",
  XuLyFile: "Xử lý File",
  BinhFile: "Bình File",
  In: "In",
  ThanhPham: "Thành Phẩm",
  DongGoi: "Đóng gói",
  ChoGiaoHang: "Chờ giao hàng",
  TamNgung: "Tạm ngưng",
  DaGiaoHang: "Đã giao hàng",
  HoanThanh: "Đã hoàn thành",
  Huy: "Đã hủy"
};

// Based on legacy logic: Only show these in the dropdown (plus the current status)
export const WORKFLOW_STATUS_KEYS = [
  "NhanFile",
  "XuLyFile",
  "BinhFile",
  "In",
  "ThanhPham",
  "DongGoi",
  "ChoGiaoHang"
];

// Danh sách Tab chính (Modules)
export const TAB_ORDER_LEGACY = [
  "📊 Tổng quan",
  "📦 Quản lý đơn hàng",
  "💰 Công nợ (Beta)",
  "🚚 Giao hàng (Beta)"
];

// Danh sách Status chi tiết được chuyển vào StatusTabs component
// Danh sách Status chi tiết được chuyển vào StatusTabs component
export const LEGACY_STATUS_TABS = [
  "📊 Tổng quan", "Tất cả", "Mới", "Tiếp nhận", "Nhận File", "Xử lý File", "Bình File", "In", "Thành Phẩm", "Đóng gói", "Chờ giao hàng", "Tạm ngưng", "Đã giao hàng", "Hoàn thành", "Gấp", "Đã hủy",
  "Thiết Kế", "In Khổ Lớn", "Bế Demi", "Gia công ngoài", "Ép Kim", "Xuất hóa đơn"
];

export const TASK_TABS = ["Thiết Kế", "In Khổ Lớn", "Bế Demi", "Gia công ngoài", "Ép Kim"];

export const COLORS = {
  primary: "#00796b",
  primaryDark: "#005a4f",
  danger: "#F44336",
  success: "#4CAF50",
  warning: "#f57c00",
  info: "#2196F3",
  design: "#0288D1",
  largeFormat: "#6A1B9A",
  demiCut: "#AD1457",
  outsource: "#8D6E63",
  hotFoil: "#AF9500",
  stageBinhFile: "#6D4C41",
  stageIn: "#D81B60",
  stageThanhPham: "#1976D2",

  // Button colors from screenshot
  btnNewOrder: "#4CAF50", // Green
  btnCustomer: "#4E342E", // Brown Dark
  btnBonusSales: "#D81B60", // Pink/Magenta
  btnBonusStaff: "#512DA8", // Purple
  btnExportBonus: "#00695C", // Teal Dark
  btnActivityReport: "#C2185B", // Red/Pink Dark
  btnFinanceReport: "#2E7D32", // Green Dark
  btnWorkStats: "#6D4C41", // Brown
  btnEvalSales: "#303F9F", // Blue Dark
  btnDebt: "#FF9800", // Orange
  btnCollect: "#039BE5", // Light Blue

  // Action Buttons (Footer)
  actionCopy: "#4285F4",   // Blue
  actionEmail: "#8B5CF6",  // Purple
  actionEdit: "#5D4037",   // Brown
  actionHistory: "#607D8B",// Blue Grey
  actionPrint: "#795548",  // Brown
  actionShip: "#1E88E5",   // Blue
  actionComplete: "#4CAF50", // Green
  actionPause: "#546E7A",  // Grey
  actionCancel: "#F44336"  // Red
};

export const PAYMENT_STATUSES = ["Công nợ", "Chưa thanh toán", "Đã cọc", "Đã thanh toán"];

// CẤU HÌNH SUPABASE
// Vui lòng điền URL và ANON KEY từ Supabase Dashboard > Settings > API
export const SUPABASE_URL = import.meta.env.VITE_SUPABASE_URL;
export const SUPABASE_ANON_KEY = import.meta.env.VITE_SUPABASE_ANON_KEY;

