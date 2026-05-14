
import React, { useState, useEffect, useMemo } from 'react';
import { useDebounce } from './hooks/useDebounce';
import { COLORS } from './constants';
import { orderService } from './services/orderService';
import { supabase } from './services/supabaseClient';
import { authService } from './services/auth';
import { dashboardService } from './services/dashboardService';
import { Order, OrderStatus } from './types';
import Dashboard from './components/Dashboard';
import OrderList from './components/OrderList';
import OrderCard from './components/OrderCard';
import StatusTabs from './components/StatusTabs';
import OrderModal from './components/OrderModal';
import CustomerManager from './components/reports/CustomerManager';
import FinancialReport from './components/reports/FinancialReport';
import SalesCommissionModal from './components/reports/SalesCommissionModal';
import StaffCommissionModal from './components/reports/StaffCommissionModal';
import Login from './components/Login';
import ResetPassword from './components/ResetPassword';
import EmployeeManager from './components/EmployeeManager';
import KPIManager from './components/KPIManager'; // Import KPIManager
import ActivityReportModal from './components/reports/ActivityReportModal';
import PerformanceStatsModal from './components/reports/PerformanceStatsModal';
import SalesEvaluationModal from './components/reports/SalesEvaluationModal';
import DebtReportModal from './components/reports/DebtReportModal';
import DailyReportModal from './components/reports/DailyReportModal';
import VersionManager from './components/VersionManager';
import CollectionReportModal from './components/reports/CollectionReportModal';
import ActivityLogModal from './components/reports/ActivityLogModal';
import CustomerReportModal from './components/reports/CustomerReportModal';
import TrackingPage from './components/TrackingPage';

import { AISettingsModal } from './components/AISettingsModal';
import AccountSettingsModal from './components/AccountSettingsModal';

import { AIChatBot } from './components/AIChatBot';
import { DashboardAlerts } from './components/DashboardAlerts';
import { useOrderSubscription } from './hooks/useOrderSubscription';
import { NotificationBell } from './components/NotificationBell';

const App: React.FC = () => {
  const [session, setSession] = useState<any>(null);
  const [userRole, setUserRole] = useState<string>('');
  const [userProfile, setUserProfile] = useState<any>(null);

  // Tracking State
  const [trackingCode, setTrackingCode] = useState<string | null>(null);

  const [currentTab, setCurrentTab] = useState("Tất cả"); // Legacy Status Tab
  const [currentSubTab, setCurrentSubTab] = useState<string>(''); // New Sub-tab State
  const [viewMode, setViewMode] = useState<'list' | 'board'>('board');
  const [orders, setOrders] = useState<Order[]>([]);

  // Pagination State
  const [currentPage, setCurrentPage] = useState(1);
  const [totalOrders, setTotalOrders] = useState(0);
  const ITEMS_PER_PAGE = 50;

  // Stats temporarily disabled or need new service
  const [stats, setStats] = useState<any>(null);
  const [tabCounts, setTabCounts] = useState<Record<string, number>>({});
  const [loading, setLoading] = useState(false);

  // Modals State
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingOrder, setEditingOrder] = useState<Order | null>(null);
  const [isCustomerManagerOpen, setIsCustomerManagerOpen] = useState(false);
  const [isFinancialReportOpen, setIsFinancialReportOpen] = useState(false);
  const [isSalesCommOpen, setIsSalesCommOpen] = useState(false);
  const [isStaffCommOpen, setIsStaffCommOpen] = useState(false);
  const [isEmployeeManagerOpen, setIsEmployeeManagerOpen] = useState(false); // Add Employee Manager State
  const [isKPIManagerOpen, setIsKPIManagerOpen] = useState(false); // Add KPI Manager State
  const [isActivityReportOpen, setIsActivityReportOpen] = useState(false);
  const [isPerformanceStatsOpen, setIsPerformanceStatsOpen] = useState(false);
  const [isSalesEvalOpen, setIsSalesEvalOpen] = useState(false);
  const [isDebtReportOpen, setIsDebtReportOpen] = useState(false);
  const [isDailyReportOpen, setIsDailyReportOpen] = useState(false);
  const [isCollectionReportOpen, setIsCollectionReportOpen] = useState(false);
  const [isActivityLogOpen, setIsActivityLogOpen] = useState(false);
  const [isCustomerReportOpen, setIsCustomerReportOpen] = useState(false);

  const [isActionMenuOpen, setIsActionMenuOpen] = useState(false); // Mobile Action Menu Toggle

  const [isAISettingsOpen, setIsAISettingsOpen] = useState(false);
  const [isAccountSettingsOpen, setIsAccountSettingsOpen] = useState(false);
  // Filters State
  // Filters State
  // Đọc ?search= từ URL nếu mở từ notification
  const [searchTerm, setSearchTerm] = useState(() => {
    const params = new URLSearchParams(window.location.search);
    return params.get('search') || '';
  });
  const debouncedSearchTerm = useDebounce(searchTerm, 500);

  // Lắng nghe message từ Service Worker (khi click notification)
  useEffect(() => {
    const handler = (event: MessageEvent) => {
      if (event.data?.type === 'SEARCH_ORDER' && event.data.orderCode) {
        setSearchTerm(event.data.orderCode);
      }
    };
    navigator.serviceWorker?.addEventListener('message', handler);
    return () => navigator.serviceWorker?.removeEventListener('message', handler);
  }, []);

  const [fromDate, setFromDate] = useState(''); // YYYY-MM-DD
  const [toDate, setToDate] = useState('');     // YYYY-MM-DD
  const [selectedSalesRep, setSelectedSalesRep] = useState('all');
  const [startSort, setSortOrder] = useState('newest'); // newest, oldest, value_desc
  const [paymentVerifyStatus, setPaymentVerifyStatus] = useState('all'); // all, verified, pending

  const [salesRepsList, setSalesRepsList] = useState<any[]>([]);

  // Month Filter State (default = current month)
  const now = new Date();
  const [orderMonth, setOrderMonth] = useState(now.getMonth() + 1); // 1-12
  const [orderYear, setOrderYear] = useState(now.getFullYear());

  // Fetch Sales Reps on Mount
  useEffect(() => {
    authService.getAllSalesReps().then(reps => setSalesRepsList(reps));
  }, []);

  const [historyOrderCode, setHistoryOrderCode] = useState<string | undefined>(undefined);

  // Realtime Subscription (Auto-enabled)
  useOrderSubscription({
    onNewOrder: () => {
      refreshOrders(currentPage);
    }
  });

  // Auth Effect
  useEffect(() => {
    // 1. Check for Tracking Code first (Public Access)
    const params = new URLSearchParams(window.location.search);
    const code = params.get('tracking_code');
    if (code) {
      setTrackingCode(code);
      return; // Stop auth flow if tracking code is present
    }

    // Check active session
    authService.getSession().then(session => {
      setSession(session);
      if (session?.user) {
        authService.getUserProfile(session.user.id).then(async profile => {
          if (profile) {
            if (profile.is_locked) {
              alert("Tài khoản của bạn đã bị KHÓA. Vui lòng liên hệ Admin.");
              await authService.signOut();
              setSession(null);
              return;
            }
            setUserRole(profile.role || '');
            setUserProfile(profile);
          }
        });
      }
    });

    // Listen for changes
    if (supabase) {
      const { data: { subscription } } = supabase.auth.onAuthStateChange((_event, session) => {
        setSession(session);
        if (session?.user) {
          authService.getUserProfile(session.user.id).then(async profile => {
            if (profile) {
              if (profile.is_locked) {
                alert("Tài khoản của bạn đã bị KHÓA. Vui lòng liên hệ Admin.");
                await authService.signOut();
                setSession(null);
                return;
              }
              setUserRole(profile.role || '');
              setUserProfile(profile);
            }
          });
        } else {
          setUserRole('');
          setUserProfile(null);
        }
      });
      return () => subscription.unsubscribe();
    }
  }, []);

  // Fetch Data Wrapper
  const refreshOrders = async (page = 1) => {
    if (!session) return;
    setLoading(true);
    try {
      // 1. Fetch Paginated Orders with Sales Rep Filter AND Status (Server-side)
      const { data, count } = await orderService.getOrders(currentTab, page, ITEMS_PER_PAGE, selectedSalesRep, {
        searchTerm,
        fromDate,
        toDate,
        paymentVerifyStatus,
        sortOrder: startSort,
        filterMonth: orderMonth,
        filterYear: orderYear,
      });
      setOrders(data);
      setTotalOrders(count || 0);

      // 2. Fetch Lightweight Statuses for Tab Counts (filtered by same month)
      const allStatusData = await orderService.getAllOrderStatuses(orderMonth, orderYear);

      const newTabCounts: Record<string, number> = {
        all: allStatusData.length,
        xuat_hoa_don: allStatusData.filter((o: any) => o.vat_amount > 0 && o.status !== 'Huy').length,
        nhan_file: allStatusData.filter((o: any) => ['Moi', 'TiepNhan', 'NhanFile'].includes(o.status)).length,
        xu_ly_file: allStatusData.filter((o: any) => o.status === 'XuLyFile').length,
        binh_file: allStatusData.filter((o: any) => o.status === 'BinhFile').length,
        in: allStatusData.filter((o: any) => o.status === 'In').length,
        thanh_pham: allStatusData.filter((o: any) => o.status === 'ThanhPham').length,
        dong_goi: allStatusData.filter((o: any) => o.status === 'DongGoi').length,
        cho_giao_hang: allStatusData.filter((o: any) => o.status === 'ChoGiaoHang').length,
        da_giao_hang: allStatusData.filter((o: any) => o.status === 'DaGiaoHang').length,
        hoan_thanh: allStatusData.filter((o: any) => o.status === 'HoanThanh').length,
        gap: allStatusData.filter((o: any) => o.is_urgent && o.status !== 'Huy' && o.status !== 'HoanThanh').length,
        huy: allStatusData.filter((o: any) => o.status === 'Huy').length,
        tam_ngung: allStatusData.filter((o: any) => o.status === 'TamNgung').length,

        // Task Counts
        thiet_ke: allStatusData.filter((o: any) => o.has_design).length,
        in_kho_lon: allStatusData.filter((o: any) => o.has_large_print).length,
        be_demi: allStatusData.filter((o: any) => o.has_be_demi).length,
        gia_cong_ngoai: allStatusData.filter((o: any) => o.has_gia_cong_ngoai).length,
        ep_kim: allStatusData.filter((o: any) => o.has_ep_kim).length,
      };
      setTabCounts(newTabCounts);

      // 3. Keep fetching Dashboard Stats if needed for other charts (revenue etc), but don't overwrite tabCounts
      const dashboardStats = await dashboardService.getStats('month');
      setStats(dashboardStats);

    } catch (error) {
      console.error("Failed to fetch data", error);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    if (session) {
      // Reset to page 1 on filter change
      setCurrentPage(1);
      refreshOrders(1);
    }
  }, [currentTab, session, selectedSalesRep, debouncedSearchTerm, fromDate, toDate, paymentVerifyStatus, startSort, orderMonth, orderYear]); // Trigger on any filter change


  // Reset Sub-tab when Main Tab changes
  useEffect(() => {
    setCurrentSubTab(''); // Reset to default (empty) which usually implies the first sub-tab

    // Logic:
    // If 'Xuất hóa đơn', default 'Chưa xuất'
    if (currentTab === 'Xuất hóa đơn') setCurrentSubTab('Chưa xuất');

    const taskTabs = ['Thiết Kế', 'In Khổ Lớn', 'Bế Demi', 'Gia công ngoài', 'Ép Kim'];
    const normalizedTab = currentTab.normalize('NFC');
    if (taskTabs.some(t => t.normalize('NFC') === normalizedTab)) {
      setCurrentSubTab('Chưa hoàn thành');
    }

  }, [currentTab]);

  const handleCreateOrder = () => {
    setEditingOrder(null);
    setIsModalOpen(true);
  };

  const handleEditOrder = (order: Order) => {
    setEditingOrder(order);
    setIsModalOpen(true);
  };

  const handleSubmitOrder = async (orderData: Partial<Order>) => {
    // Auto-assign Sales Rep ID for new orders if user is NhanVienKinhDoanh
    if (!editingOrder?.id && userRole === 'NhanVienKinhDoanh' && session?.user?.id) {
      orderData.sales_rep_id = session.user.id;
    }

    if (editingOrder?.id) {
      await orderService.updateOrder(editingOrder.id, orderData);
    } else {
      await orderService.createOrder(orderData);
    }
    setIsModalOpen(false);
    refreshOrders(); // Use shared refresh
  };

  const ActionButtons = [
    { label: "Nhập đơn mới", icon: "fa-plus", color: COLORS.btnNewOrder, onClick: handleCreateOrder, roles: ['Admin', 'NhanVienKinhDoanh', 'KeToan'] },
    { label: "Quản lý KH", icon: "fa-users", color: COLORS.btnCustomer, onClick: () => setIsCustomerManagerOpen(true), roles: ['Admin', 'NhanVienKinhDoanh', 'KeToan'] },
    { label: "BC Khách hàng", icon: "fa-chart-bar", color: "#5D4037", onClick: () => setIsCustomerReportOpen(true), roles: ['Admin', 'NhanVienKinhDoanh', 'KeToan'] },
    { label: "Báo cáo ngày", icon: "fa-chart-line", color: "#1d4ed8", onClick: () => setIsDailyReportOpen(true), roles: ['Admin', 'KeToan'] },
    { label: "Thưởng NVKD", icon: "fa-percent", color: COLORS.btnBonusSales, onClick: () => setIsSalesCommOpen(true), roles: ['Admin', 'NhanVienKinhDoanh', 'KeToan'] },
    { label: "Thưởng HHSX", icon: "fa-gift", color: COLORS.btnBonusStaff, onClick: () => setIsStaffCommOpen(true), roles: ['Admin', 'KeToan', 'QuanLySanXuat', 'NhanVienSanXuat', 'NhanVienThietKe', 'NhanVienBinhFile', 'NhanVienGiaoHang'] }, // Allowed for production staff to see own bonus
    // { label: "Xuất Toàn bộ Thưởng", icon: "fa-file-excel", color: COLORS.btnExportBonus, onClick: () => alert("Tính năng Xuất thưởng đang phát triển"), roles: ['Admin', 'KeToan'] },
    { label: "BC Hoạt động", icon: "fa-chart-pie", color: COLORS.btnActivityReport, onClick: () => setIsActivityReportOpen(true), roles: ['Admin', 'QuanLySanXuat', 'NhanVienSanXuat', 'NhanVienThietKe', 'NhanVienBinhFile', 'KeToan'] },
    { label: "Lịch sử HĐ", icon: "fa-history", color: "#607d8b", onClick: () => setIsActivityLogOpen(true), roles: ['Admin', 'KeToan', 'QuanLySanXuat'] },
    { label: "Báo cáo TC", icon: "fa-cash-register", color: COLORS.btnFinanceReport, onClick: () => setIsFinancialReportOpen(true), roles: ['Admin', 'KeToan'] },
    { label: "Thống kê HS", icon: "fa-person-digging", color: COLORS.btnWorkStats, onClick: () => setIsPerformanceStatsOpen(true), roles: ['Admin', 'QuanLySanXuat', 'NhanVienSanXuat', 'NhanVienThietKe', 'NhanVienBinhFile'] }, // Allowed for production staff to see own stats
    { label: "Đánh giá NVKD", icon: "fa-chart-line", color: COLORS.btnEvalSales, onClick: () => setIsSalesEvalOpen(true), roles: ['Admin', 'NhanVienKinhDoanh', 'KeToan'] },
    { label: "Xem công nợ", icon: "fa-file-invoice-dollar", color: COLORS.btnDebt, onClick: () => setIsDebtReportOpen(true), roles: ['Admin', 'KeToan', 'NhanVienKinhDoanh'] }, // Sales needs to see debt
    { label: "Xem đơn Cần thu", icon: "fa-hand-holding-dollar", color: COLORS.btnCollect, onClick: () => setIsCollectionReportOpen(true), roles: ['Admin', 'KeToan', 'NhanVienKinhDoanh'] },
    { label: "Quản lý nhân viên", icon: "fa-user-tie", color: "#455a64", onClick: () => setIsEmployeeManagerOpen(true), roles: ['Admin'] },
    { label: "Thiết lập KPI", icon: "fa-bullseye", color: "#d84315", onClick: () => setIsKPIManagerOpen(true), roles: ['Admin'] },
    { label: "Cài đặt AI", icon: "fa-robot", color: "#f59e0b", onClick: () => setIsAISettingsOpen(true), roles: ['Admin'] },
  ];

  // Filter orders based on current Tab (for Board View)
  const filteredOrders = useMemo(() => {
    // 1. Always start with the full list, but we will apply filters sequentially.
    // Note: We do NOT return early for 'Tất cả' anymore because we need to respect Search/Date/Rep filters.

    return orders.filter(order => {
      // 0. Global Filters (Date, Search, SalesRep, PaymentStatus)

      // A. Search
      if (searchTerm) {
        const lowerTerm = searchTerm.toLowerCase();
        const matches = (
          (order.order_code || '').toLowerCase().includes(lowerTerm) ||
          (order.customer?.name || '').toLowerCase().includes(lowerTerm) ||
          (order.customer?.code || '').toLowerCase().includes(lowerTerm) ||
          (order.description || '').toLowerCase().includes(lowerTerm)
        );
        if (!matches) return false;

        // IF SEARCHING: SKIP ALL STATUS FILTERS -> RETURN TRUE for matches
        return true;
      }

      // B. Date Range
      if (fromDate) {
        if (new Date(order.created_at) < new Date(fromDate)) return false;
      }
      if (toDate) {
        // Add 1 day to include the end date fully
        const end = new Date(toDate);
        end.setHours(23, 59, 59);
        if (new Date(order.created_at) > end) return false;
      }

      // C. Sales Rep (Cleaned up: Handled by Server-side filtering now)
      // if (selectedSalesRep !== 'all') { ... }

      // D. Payment Verify Status
      if (paymentVerifyStatus !== 'all') {
        if (paymentVerifyStatus === 'verified' && !order.payment_confirmed) return false;
        if (paymentVerifyStatus === 'pending' && order.payment_confirmed) return false;
      }

      const normalizedTab = currentTab.normalize('NFC');

      // Explicitly handle 'Tất cả' to show ONLY ACTIVE orders (Exclude HoanThanh, DaGiaoHang, Huy)
      if (normalizedTab === 'Tất cả') {
        return order.status !== 'HoanThanh' && order.status !== 'DaGiaoHang' && order.status !== 'Huy';
      }

      // 1. Group 1: Main Statuses
      const statusMap: Record<string, string> = {
        'Moi': 'Moi',
        'Tiếp nhận': 'TiepNhan',
        'TiepNhan': 'TiepNhan',
        // 'Nhận File': 'NhanFile', // REMOVED: Handled specially below
        'Xử lý File': 'XuLyFile',
        'Bình File': 'BinhFile',
        'In': 'In',
        'Thành Phẩm': 'ThanhPham',
        'Đóng gói': 'DongGoi',
        'Chờ giao hàng': 'ChoGiaoHang',
        'Đã giao hàng': 'DaGiaoHang',
        'Đã hoàn thành': 'HoanThanh',
        'Hoàn thành': 'HoanThanh',
        'Đã hủy': 'Huy',
        'Tạm ngưng': 'TamNgung'
      };

      // Special Case: "Nhận File" Tab includes Moi, TiepNhan, NhanFile
      if (normalizedTab === 'Nhận File') {
        return order.status === 'Moi' || order.status === 'TiepNhan' || order.status === 'NhanFile';
      }

      // Handle direct map match
      if (statusMap[normalizedTab]) {
        const targetStatus = statusMap[normalizedTab];
        if (targetStatus === 'HoanThanh') {
          return order.status === 'HoanThanh' || order.status === 'DaGiaoHang';
        }
        return order.status === targetStatus;
      }

      // ... existing special filters ...
      if (normalizedTab === 'Gấp') return order.is_urgent && order.status !== 'Huy' && order.status !== 'HoanThanh';
      if (normalizedTab === 'Xuất hóa đơn') {
        const initialCheck = order.vat_amount > 0 && order.status !== 'Huy';
        if (!initialCheck) return false;
        if (currentSubTab === 'Đã xuất') return order.invoice_status === 'Issued';
        if (currentSubTab === 'Chưa xuất') return order.invoice_status !== 'Issued';
        return true;
      }
      // Helper check inside filter
      const isTaskDone = (status: string | undefined, orderStatus: string) => {
        return status === 'Completed' || orderStatus === 'HoanThanh' || orderStatus === 'DaGiaoHang';
      };

      if (normalizedTab === 'Thiết Kế') {
        if (!order.has_design) return false;
        if (currentSubTab === 'Đã hoàn thành') return isTaskDone(order.design_status, order.status);
        if (currentSubTab === 'Chưa hoàn thành') return !isTaskDone(order.design_status, order.status);
        return true;
      }
      if (normalizedTab === 'In Khổ Lớn') {
        if (!order.has_large_print) return false;
        if (currentSubTab === 'Đã hoàn thành') return isTaskDone(order.large_print_status, order.status);
        if (currentSubTab === 'Chưa hoàn thành') return !isTaskDone(order.large_print_status, order.status);
        return true;
      }
      if (normalizedTab === 'Bế Demi') {
        if (!order.has_be_demi) return false;
        if (currentSubTab === 'Đã hoàn thành') return isTaskDone(order.be_demi_status, order.status);
        if (currentSubTab === 'Chưa hoàn thành') return !isTaskDone(order.be_demi_status, order.status);
        return true;
      }
      if (normalizedTab === 'Gia công ngoài') {
        if (!order.has_gia_cong_ngoai) return false;
        if (currentSubTab === 'Đã hoàn thành') return isTaskDone(order.outsource_status, order.status);
        if (currentSubTab === 'Chưa hoàn thành') return !isTaskDone(order.outsource_status, order.status);
        return true;
      }
      if (normalizedTab === 'Ép Kim') {
        if (!order.has_ep_kim) return false;
        if (currentSubTab === 'Đã hoàn thành') return isTaskDone(order.ep_kim_status, order.status);
        if (currentSubTab === 'Chưa hoàn thành') return !isTaskDone(order.ep_kim_status, order.status);
        return true;
      }

      return true;
    }).sort((a, b) => {
      // E. Sorting
      if (startSort === 'oldest') return new Date(a.created_at).getTime() - new Date(b.created_at).getTime();
      if (startSort === 'value_desc') return b.total_amount - a.total_amount;
      return new Date(b.created_at).getTime() - new Date(a.created_at).getTime(); // Default newest
    });
  }, [orders, currentTab, currentSubTab, searchTerm, fromDate, toDate, selectedSalesRep, paymentVerifyStatus, startSort]);

  // Calculate Sub-tab Counts (Real-time based on orders)
  const subTabCounts = useMemo(() => {
    const counts: Record<string, number> = {};
    const normalizedTab = currentTab.normalize('NFC');

    if (normalizedTab === 'Xuất hóa đơn') {
      const validOrders = orders.filter(o => o.vat_amount > 0 && o.status !== 'Huy');
      counts['Chưa xuất'] = validOrders.filter(o => o.invoice_status !== 'Issued').length;
      counts['Đã xuất'] = validOrders.filter(o => o.invoice_status === 'Issued').length;
    }

    // Helper to check if task is completed: Explicitly completed OR Order is Completed/Delivered
    const isTaskCompleted = (status: string | undefined, orderStatus: string) => {
      return status === 'Completed' || orderStatus === 'HoanThanh' || orderStatus === 'DaGiaoHang';
    }

    if (normalizedTab === 'Thiết Kế') {
      const relevant = orders.filter(o => o.has_design);
      counts['Chưa hoàn thành'] = relevant.filter(o => !isTaskCompleted(o.design_status, o.status)).length;
      counts['Đã hoàn thành'] = relevant.filter(o => isTaskCompleted(o.design_status, o.status)).length;
    }
    if (normalizedTab === 'In Khổ Lớn') {
      const relevant = orders.filter(o => o.has_large_print);
      counts['Chưa hoàn thành'] = relevant.filter(o => !isTaskCompleted(o.large_print_status, o.status)).length;
      counts['Đã hoàn thành'] = relevant.filter(o => isTaskCompleted(o.large_print_status, o.status)).length;
    }
    if (normalizedTab === 'Bế Demi') {
      const relevant = orders.filter(o => o.has_be_demi);
      counts['Chưa hoàn thành'] = relevant.filter(o => !isTaskCompleted(o.be_demi_status, o.status)).length;
      counts['Đã hoàn thành'] = relevant.filter(o => isTaskCompleted(o.be_demi_status, o.status)).length;
    }
    if (normalizedTab === 'Gia công ngoài') {
      const relevant = orders.filter(o => o.has_gia_cong_ngoai);
      counts['Chưa hoàn thành'] = relevant.filter(o => !isTaskCompleted(o.outsource_status, o.status)).length;
      counts['Đã hoàn thành'] = relevant.filter(o => isTaskCompleted(o.outsource_status, o.status)).length;
    }
    if (normalizedTab === 'Ép Kim') {
      const relevant = orders.filter(o => o.has_ep_kim);
      counts['Chưa hoàn thành'] = relevant.filter(o => !isTaskCompleted(o.ep_kim_status, o.status)).length;
      counts['Đã hoàn thành'] = relevant.filter(o => isTaskCompleted(o.ep_kim_status, o.status)).length;
    }

    return counts;

    return counts;
  }, [orders, currentTab]);

  if (trackingCode) {
    return <TrackingPage token={trackingCode} />;
  }

  if (!session) {
    return <Login />;
  }

  const handleViewHistory = (orderCode: string) => {
    setHistoryOrderCode(orderCode);
    setIsActivityLogOpen(true);
  };

  return (
    <div className="min-h-screen pb-10 bg-gray-100 font-sans text-[15px]">

      {/* Top Action Bar - Sticky */}
      <div className="sticky top-0 z-50 bg-white shadow-md border-b border-gray-200 px-4 py-2 flex flex-col md:flex-row items-start justify-between gap-4">
        {/* Left: User Profile Card */}
        <div
          onClick={() => setIsAccountSettingsOpen(true)}
          className="flex-shrink-0 w-full md:w-[280px] bg-white border border-gray-200 rounded-lg p-2 shadow-sm flex items-center justify-between gap-2 cursor-pointer hover:bg-gray-50 transition-colors group"
        >
          <div className="flex items-center gap-3 overflow-hidden">
            <div className="w-10 h-10 rounded-full bg-teal-100 flex items-center justify-center text-teal-700">
              <i className="fa-solid fa-user-tie text-xl"></i>
            </div>
            <div className="flex flex-col min-w-0">
              <span className="font-bold text-gray-800 text-sm truncate" title={userProfile?.full_name || session.user.email}>
                {userProfile?.full_name || session.user.email?.split('@')[0]}
              </span>
              <span className="text-xs text-gray-500 truncate" title={session.user.email}>
                {session.user.email}
              </span>
              {userRole && (
                <span className={`text-[10px] font-bold px-1.5 py-0.5 rounded w-fit mt-0.5 ${userRole === 'Admin' ? 'bg-purple-100 text-purple-700' :
                  (userRole === 'NhanVienKinhDoanh' || userRole === 'Nhân Viên Kinh Doanh') ? 'bg-blue-100 text-blue-700' :
                    'bg-gray-100 text-gray-700'
                  }`}>
                  {userRole === 'NhanVienKinhDoanh' ? 'Nhân Viên Kinh Doanh' :
                    userRole === 'QuanLySanXuat' ? 'Quản Lý Sản Xuất' :
                      userRole === 'NhanVienSanXuat' ? 'Nhân Viên Sản Xuất' :
                        userRole === 'NhanVienThietKe' ? 'Nhân Viên Thiết Kế' :
                          userRole === 'KeToan' ? 'Kế Toán' :
                            userRole === 'NhanVienGiaoHang' ? 'Nhân Viên Giao Hàng' :
                              userRole}
                </span>
              )}
            </div>
          </div>

          <div className="flex flex-col gap-1 border-l pl-2 border-gray-100">
            {loading && <i className="fa-solid fa-circle-notch fa-spin text-teal-500 text-xs" title="Đang cập nhật..."></i>}
            <div onClick={(e) => e.stopPropagation()}>
              <NotificationBell userId={session.user.id} onOpenOrder={(orderCode) => {
                setSearchTerm(orderCode);
              }} />
            </div>
            <button
              onClick={(e) => { e.stopPropagation(); authService.signOut(); }}
              className="w-8 h-8 rounded hover:bg-red-50 text-gray-400 hover:text-red-500 transition-colors flex items-center justify-center"
              title="Đăng xuất"
            >
              <i className="fa-solid fa-right-from-bracket"></i>
            </button>
          </div>
        </div>

        {/* Right: Button Action Grid */}
        <div className="flex-1">
          {/* Mobile Menu Toggle */}
          <button
            onClick={() => setIsActionMenuOpen(!isActionMenuOpen)}
            className="md:hidden w-full bg-[#00796b] text-white py-2 rounded mb-2 font-bold flex items-center justify-center gap-2 shadow-sm"
          >
            <i className={`fa-solid ${isActionMenuOpen ? 'fa-chevron-up' : 'fa-bars'}`}></i>
            {isActionMenuOpen ? 'Thu gọn Menu' : 'Menu Thao Tác'}
          </button>

          {/* Action Grid */}
          <div className={`${isActionMenuOpen ? 'grid' : 'hidden'} md:grid grid-cols-2 md:grid-cols-7 gap-2 transition-all duration-300`}>
            {ActionButtons
              .filter(btn => !btn.roles || btn.roles.includes(userRole))
              .map((btn, idx) => (
                <button
                  key={idx}
                  onClick={() => {
                    btn.onClick();
                    setIsActionMenuOpen(false); // Auto-close on mobile click
                  }}
                  className="flex items-center justify-center gap-1 px-1.5 py-1.5 rounded text-white text-[11px] font-bold hover:opacity-90 transition shadow-sm whitespace-nowrap overflow-hidden text-ellipsis min-h-[32px]"
                  style={{ backgroundColor: btn.color }}
                  title={btn.label}
                >
                  <i className={`fa-solid ${btn.icon} text-[10px]`}></i> <span>{btn.label}</span>
                </button>
              ))}
          </div>
        </div>
      </div>

      {/* Main Content */}
      <main className="max-w-[1900px] mx-auto px-4 mt-4">

        {/* AI Alerts Widget */}
        <DashboardAlerts userRole={userRole} />

        {/* 1. Status Tabs */}
        <StatusTabs
          currentTab={currentTab}
          onTabChange={setCurrentTab}
          currentSubTab={currentSubTab}
          onSubTabChange={setCurrentSubTab}
          counts={tabCounts}
          subTabCounts={subTabCounts}
          userRole={userRole}
        />

        {/* Filters & View Toggle */}
        <div className="flex flex-wrap items-end gap-2 bg-white p-3 rounded-lg shadow-sm border border-gray-200 mt-4 mb-4">

          {/* 1. Search */}
          <div className="flex-1 min-w-[200px]">
            <label className="text-[11px] font-bold text-gray-500 block mb-1">Tìm kiếm</label>
            <div className="relative">
              <i className="fa-solid fa-search absolute left-3 top-1/2 -translate-y-1/2 text-gray-400 text-xs"></i>
              <input
                type="text"
                name="search_orders"
                autoComplete="off"
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                placeholder="Mã đơn, Tên KH..."
                className="w-full pl-8 pr-2 py-1.5 border border-gray-300 rounded text-sm focus:ring-1 focus:ring-blue-500 focus:outline-none"
              />
            </div>
          </div>

          {/* 2. From Date */}
          <div className="w-[130px]">
            <label className="text-[11px] font-bold text-gray-500 block mb-1">Từ ngày</label>
            <input type="date" value={fromDate} onChange={(e) => setFromDate(e.target.value)} className="w-full border border-gray-300 rounded px-2 py-1.5 text-sm" />
          </div>

          {/* 3. To Date */}
          <div className="w-[130px]">
            <label className="text-[11px] font-bold text-gray-500 block mb-1">Đến ngày</label>
            <input type="date" value={toDate} onChange={(e) => setToDate(e.target.value)} className="w-full border border-gray-300 rounded px-2 py-1.5 text-sm" />
          </div>

          {/* 4. Sales Rep */}
          <div className="w-[180px]">
            <label className="text-[11px] font-bold text-gray-500 block mb-1">Nhân viên KD</label>
            <div className="flex gap-1">
              <select
                value={selectedSalesRep}
                onChange={(e) => setSelectedSalesRep(e.target.value)}
                className="w-full border border-gray-300 rounded px-2 py-1.5 text-sm"
              >
                <option value="all">Tất cả NVKD</option>
                {session?.user?.id && <option value={session.user.id}>Đơn hàng của tôi</option>}
                {salesRepsList.map(rep => (
                  <option key={rep.id} value={rep.id}>{rep.full_name || rep.email}</option>
                ))}
              </select>

            </div>
          </div>

          {/* 5. MONTH/YEAR SELECTOR — Prominent */}
          <div className="flex-1 min-w-[220px]">
            <label className="text-[11px] font-bold text-gray-500 block mb-1">
              <i className="fa-solid fa-calendar-days mr-1"></i>Đơn Hàng Tháng
            </label>
            <div className="flex items-center gap-1.5 bg-gradient-to-r from-teal-600 to-teal-700 text-white px-3 py-1 rounded-lg shadow">
              <select
                value={orderMonth}
                onChange={(e) => setOrderMonth(Number(e.target.value))}
                className="bg-white/20 text-white font-bold text-base rounded px-2 py-1 cursor-pointer border border-white/30 focus:outline-none appearance-none text-center flex-1"
              >
                {Array.from({ length: 12 }, (_, i) => (
                  <option key={i + 1} value={i + 1} className="text-gray-800 bg-white">Tháng {i + 1}</option>
                ))}
              </select>
              <span className="text-white/60 font-bold">/</span>
              <select
                value={orderYear}
                onChange={(e) => setOrderYear(Number(e.target.value))}
                className="bg-white/20 text-white font-bold text-base rounded px-2 py-1 cursor-pointer border border-white/30 focus:outline-none appearance-none text-center"
                style={{ minWidth: '70px' }}
              >
                {Array.from({ length: 5 }, (_, i) => {
                  const y = new Date().getFullYear() - 2 + i;
                  return <option key={y} value={y} className="text-gray-800 bg-white">{y}</option>;
                })}
              </select>
            </div>
          </div>

          {/* 5. Sort */}
          <div className="w-[140px]">
            <label className="text-[11px] font-bold text-gray-500 block mb-1">Sắp xếp</label>
            <select
              value={startSort}
              onChange={(e) => setSortOrder(e.target.value)}
              className="w-full border border-gray-300 rounded px-2 py-1.5 text-sm"
            >
              <option value="newest">Ngày tạo: Mới nhất</option>
              <option value="oldest">Ngày tạo: Cũ nhất</option>
              <option value="value_desc">Giá trị: Cao - Thấp</option>
            </select>
          </div>

          {/* 6. Payment Status */}
          <div className="w-[140px]">
            <label className="text-[11px] font-bold text-gray-500 block mb-1">Trạng thái xác nhận</label>
            <select
              value={paymentVerifyStatus}
              onChange={(e) => setPaymentVerifyStatus(e.target.value)}
              className="w-full border border-gray-300 rounded px-2 py-1.5 text-sm"
            >
              <option value="all">Tất cả</option>
              <option value="verified">Đã xác nhận</option>
              <option value="pending">Chờ xác nhận</option>
            </select>
          </div>

          {/* 7. View Toggles */}
          <div className="flex items-center gap-1 ml-auto">
            <button
              onClick={() => setViewMode('board')}
              className={`w-9 h-9 rounded flex items-center justify-center transition-all ${viewMode === 'board' ? 'bg-[#00796b] text-white shadow-sm' : 'bg-gray-100 text-gray-500 hover:bg-gray-200'}`}
              title="Board View"
            >
              <i className="fa-solid fa-grip"></i>
            </button>
            <button
              onClick={() => setViewMode('list')}
              className={`w-9 h-9 rounded flex items-center justify-center transition-all ${viewMode === 'list' ? 'bg-[#00796b] text-white shadow-sm' : 'bg-gray-100 text-gray-500 hover:bg-gray-200'}`}
              title="List View"
            >
              <i className="fa-solid fa-list"></i>
            </button>
            <button
              onClick={refreshOrders}
              className="w-9 h-9 rounded flex items-center justify-center bg-gray-500 text-white hover:bg-gray-600 shadow-sm transition-all"
              title="Làm mới"
            >
              <i className="fa-solid fa-rotate"></i>
            </button>
            <button
              onClick={() => {
                setSearchTerm('');
                setFromDate('');
                setToDate('');
                setSelectedSalesRep('all');
                setSortOrder('newest');
                setPaymentVerifyStatus('all');
                // Reset month to current
                const resetNow = new Date();
                setOrderMonth(resetNow.getMonth() + 1);
                setOrderYear(resetNow.getFullYear());
              }}
              className="w-9 h-9 rounded flex items-center justify-center bg-gray-400 text-white hover:bg-gray-500 shadow-sm transition-all"
              title="Xóa bộ lọc"
            >
              <i className="fa-solid fa-filter-circle-xmark"></i>
            </button>
          </div>
        </div>


        {/* Content Area */}
        {loading && orders.length === 0 && currentTab !== "📊 Tổng quan" ? (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4 animate-pulse">
            {[...Array(8)].map((_, i) => (
              <div key={i} className="bg-white h-48 rounded-lg border border-gray-200 shadow-sm"></div>
            ))}
          </div>
        ) : (
          <>
            {currentTab === "📊 Tổng quan" ? (
              <Dashboard />
            ) : (
              // Order List View (For all other tabs)
              <>
                {viewMode === 'board' ? (
                  <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4 pb-10">
                    {filteredOrders.map(order => (
                      <OrderCard
                        key={order.id}
                        order={order}
                        onEdit={handleEditOrder}
                        onRefresh={refreshOrders}
                        currentUser={{ ...session?.user, role: userRole }}
                        onViewHistory={handleViewHistory}
                      />
                    ))}
                    {filteredOrders.length === 0 && <p className="col-span-full text-center text-gray-500 py-10 bg-white rounded-lg border border-gray-200 shadow-sm">Không có đơn hàng nào trong mục này.</p>}
                  </div>
                ) : (
                  <OrderList
                    orders={filteredOrders}
                    onEdit={handleEditOrder}
                    onRefresh={refreshOrders}
                    currentUser={{ ...session?.user, role: userRole }}
                    tabCounts={tabCounts}
                    currentTab={currentTab}
                    onViewHistory={handleViewHistory}
                  />
                )}
              </>
            )}
          </>
        )}

        {/* Pagination Controls */}
        <div className="flex justify-between items-center mt-4 bg-white p-3 rounded shadow-sm border border-gray-200">
          <div className="text-sm text-gray-600">
            Trang <strong>{currentPage}</strong> / {Math.max(1, Math.ceil(totalOrders / ITEMS_PER_PAGE))} (Tổng: {totalOrders})
          </div>
          <div className="flex gap-2">
            <button
              onClick={() => {
                const newPage = currentPage - 1;
                setCurrentPage(newPage);
                refreshOrders(newPage);
              }}
              disabled={currentPage === 1 || loading}
              className="px-3 py-1 bg-white border border-gray-300 rounded hover:bg-gray-50 disabled:opacity-50 text-sm font-medium"
            >
              <i className="fa-solid fa-chevron-left mr-1"></i> Trước
            </button>
            <button
              onClick={() => {
                const newPage = currentPage + 1;
                setCurrentPage(newPage);
                refreshOrders(newPage);
              }}
              disabled={currentPage >= Math.ceil(totalOrders / ITEMS_PER_PAGE) || loading}
              className="px-3 py-1 bg-white border border-gray-300 rounded hover:bg-gray-50 disabled:opacity-50 text-sm font-medium"
            >
              Sau <i className="fa-solid fa-chevron-right ml-1"></i>
            </button>
          </div>
        </div>

      </main>

      {/* Modals */}
      <OrderModal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        onSubmit={handleSubmitOrder}
        initialData={editingOrder}
        userRole={userRole as any}
        currentUserId={session?.user?.id}
      />

      {
        isCustomerManagerOpen && (
          <CustomerManager
            isOpen={isCustomerManagerOpen}
            onClose={() => setIsCustomerManagerOpen(false)}
          />
        )
      }

      {
        isEmployeeManagerOpen && (
          <EmployeeManager
            isOpen={isEmployeeManagerOpen}
            onClose={() => setIsEmployeeManagerOpen(false)}
          />
        )
      }

      {
        isKPIManagerOpen && (
          <KPIManager
            isOpen={isKPIManagerOpen}
            onClose={() => setIsKPIManagerOpen(false)}
          />
        )
      }

      {
        isFinancialReportOpen && (
          <FinancialReport onClose={() => setIsFinancialReportOpen(false)} />
        )
      }

      {/* Commission Modals */}
      <SalesCommissionModal
        isOpen={isSalesCommOpen}
        onClose={() => setIsSalesCommOpen(false)}
        currentUserRole={userRole}
        currentUserName={userProfile?.full_name}
      />

      <StaffCommissionModal
        isOpen={isStaffCommOpen}
        onClose={() => setIsStaffCommOpen(false)}
        currentUserRole={userRole}
        currentUserName={userProfile?.full_name}
      />

      <ActivityReportModal
        isOpen={isActivityReportOpen}
        onClose={() => setIsActivityReportOpen(false)}
        currentUserRole={userRole}
        currentUserName={userProfile?.full_name}
      />

      <ActivityLogModal
        isOpen={isActivityLogOpen}
        onClose={() => { setIsActivityLogOpen(false); setHistoryOrderCode(undefined); }}
        initialOrderCode={historyOrderCode}
      />

      <PerformanceStatsModal
        isOpen={isPerformanceStatsOpen}
        onClose={() => setIsPerformanceStatsOpen(false)}
        currentUserRole={userRole}
        currentUserName={userProfile?.full_name}
      />
      <SalesEvaluationModal
        isOpen={isSalesEvalOpen}
        onClose={() => setIsSalesEvalOpen(false)}
        currentUserRole={userRole || ''}
        currentUserName={userProfile?.full_name}
      />
      <DebtReportModal
        isOpen={isDebtReportOpen}
        onClose={() => setIsDebtReportOpen(false)}
      />
      <DailyReportModal
        isOpen={isDailyReportOpen}
        onClose={() => setIsDailyReportOpen(false)}
      />
      <CollectionReportModal
        isOpen={isCollectionReportOpen}
        onClose={() => setIsCollectionReportOpen(false)}
      />

      <CustomerReportModal
        isOpen={isCustomerReportOpen}
        onClose={() => setIsCustomerReportOpen(false)}
      />

      <AISettingsModal
        isOpen={isAISettingsOpen}
        onClose={() => setIsAISettingsOpen(false)}
      />

      <AccountSettingsModal
        isOpen={isAccountSettingsOpen}
        onClose={() => setIsAccountSettingsOpen(false)}
        userProfile={userProfile}
        onProfileUpdate={() => {
          if (session?.user?.id) {
            authService.getUserProfile(session.user.id).then(p => setUserProfile(p));
          }
        }}
      />

      <AIChatBot
        onOpenOrderModal={(data) => {
          setEditingOrder(data as any);
          setIsModalOpen(true);
        }}
        currentUserRole={userRole || ''}
      />
    </div >
  );
};

export default App;
