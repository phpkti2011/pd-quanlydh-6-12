import React, { useState, useMemo } from 'react';
import { formatDate, formatDateTime } from '../utils/dateFormatter';
import { orderService } from '../services/orderService';
import { Order, OrderStatus } from '../types';
import StatusTabs from './StatusTabs';
import TaskControl from './TaskControl';
import StageControl from './StageControl';

const COLORS = {
  stageBinhFile: '#795548',
  stageIn: '#E91E63',
  stageThanhPham: '#2196F3',
  design: '#0288D1',
  largeFormat: '#6A1B9A',
  pink: '#e91e63',
  orange: '#FF9800',
  warning: '#FFC107'
};

interface OrderListProps {
  orders: Order[];
  onEdit: (order: Order) => void;
  onRefresh: () => void;
  currentUser: any;
  tabCounts?: Record<string, number>; // New prop for counts
  currentTab: string; // Lifted state
  onViewHistory?: (orderCode: string) => void;
  /** Tạo đơn sản xuất lại từ đơn này (xem setup_rework_orders.sql) */
  onRework?: (order: Order) => void;
  /** Mở đơn gốc / đơn làm lại được liên kết */
  onOpenOrder?: (ref: { id: string; order_code: string }) => void;
}

// "26PD2908.0636-L2" -> "-L2"
const reworkSuffix = (code: string) => {
  const i = code.lastIndexOf('-L');
  return i >= 0 ? code.slice(i) : code;
};

const OrderList: React.FC<OrderListProps> = ({ orders, onEdit, onRefresh, currentUser, tabCounts, currentTab, onRework, onOpenOrder }) => {
  // const [currentTab, setCurrentTab] = useState('all'); // Removed internal state

  // Hoàn tác đơn ĐÃ HOÀN THÀNH: chỉ Admin.
  // Đưa đơn ra khỏi trạng thái Hoàn thành sẽ xoá completed_at (xem
  // setup_step5_completed_at.sql), khiến đơn rơi khỏi doanh số của tháng.
  const canUndoComplete = ['Admin', 'admin'].includes(currentUser?.role);
  // Ai được tạo đơn sản xuất lại (giống OrderCard)
  const canRework = ['Admin', 'QuanLySanXuat', 'NhanVienKinhDoanh'].includes(currentUser?.role);

  const handleStatusChange = async (orderId: string, newStatus: string, oldStatus: string) => {
    if (oldStatus === 'HoanThanh' && newStatus !== 'HoanThanh') {
      if (!confirm("Đơn này đang Hoàn thành. Hoàn tác sẽ xoá ngày hoàn thành và làm đơn không còn được tính vào doanh số tháng. Tiếp tục?")) {
        return;
      }
    }
    try {
      await orderService.updateStatus(orderId, newStatus as any);
      onRefresh();
    } catch (e) {
      alert("Lỗi: " + (e as Error).message);
    }
  };

  const checkIsJoined = (order: Order, stageKey: string) => {
    return order.participants?.some(p => p.stage === stageKey && p.user_id === currentUser?.id);
  };

  // Use orders directly from props (App.tsx handles all filtering now)
  const filteredOrders = orders;

  const renderStageCell = (order: Order) => {
    switch (order.status) {
      case 'BinhFile':
        return <StageControl
          stageKey="BinhFile"
          stageLabel="Bình File"
          orderId={order.id}
          participants={order.participants?.filter(p => p.stage === 'BinhFile') || []}
          color={COLORS.stageBinhFile}
          isProminent={true}
          onJoin={async () => { await orderService.joinStage(order.id, 'BinhFile', currentUser?.id); onRefresh(); }}
          onLeave={async () => { await orderService.leaveStage(order.id, 'BinhFile', currentUser?.id); onRefresh(); }}
          isJoined={checkIsJoined(order, 'BinhFile')}
        />;
      case 'In':
        return <StageControl
          stageKey="In"
          stageLabel="In"
          orderId={order.id}
          participants={order.participants?.filter(p => p.stage === 'In') || []}
          color={COLORS.stageIn}
          isProminent={true}
          onJoin={async () => { await orderService.joinStage(order.id, 'In', currentUser?.id); onRefresh(); }}
          onLeave={async () => { await orderService.leaveStage(order.id, 'In', currentUser?.id); onRefresh(); }}
          isJoined={checkIsJoined(order, 'In')}
        />;
      case 'ThanhPham':
        return <StageControl
          stageKey="ThanhPham"
          stageLabel="Thành Phẩm"
          orderId={order.id}
          participants={order.participants?.filter(p => p.stage === 'ThanhPham') || []}
          color={COLORS.stageThanhPham}
          isProminent={true}
          onJoin={async () => { await orderService.joinStage(order.id, 'ThanhPham', currentUser?.id); onRefresh(); }}
          onLeave={async () => { await orderService.leaveStage(order.id, 'ThanhPham', currentUser?.id); onRefresh(); }}
          isJoined={checkIsJoined(order, 'ThanhPham')}
        />;
      default:
        return (
          <div className="flex gap-2 text-xs">
            {(order.participants?.filter(p => p.stage === 'BinhFile').length || 0) > 0 && (
              <div className="px-2 py-1 bg-gray-100 rounded border border-gray-200">
                <span className="font-bold text-[#6D4C41]">Bình File:</span> {order.participants?.filter(p => p.stage === 'BinhFile').length}
              </div>
            )}
            {(order.participants?.filter(p => p.stage === 'In').length || 0) > 0 && (
              <div className="px-2 py-1 bg-gray-100 rounded border border-gray-200">
                <span className="font-bold text-[#D81B60]">In:</span> {order.participants?.filter(p => p.stage === 'In').length}
              </div>
            )}
            {(order.participants?.filter(p => p.stage === 'ThanhPham').length || 0) > 0 && (
              <div className="px-2 py-1 bg-gray-100 rounded border border-gray-200">
                <span className="font-bold text-[#1976D2]">TP:</span> {order.participants?.filter(p => p.stage === 'ThanhPham').length}
              </div>
            )}
          </div>
        );
    }
  };

  return (
    <div>
      {/* StatusTabs moved to App.tsx */}


      {/* 2. Order Table */}
      <div className="overflow-x-auto bg-white rounded-lg shadow-sm border border-gray-200">
        <table className="w-full text-sm text-left">
          <thead className="bg-[#00796b] text-white text-xs uppercase font-semibold">
            <tr>
              <th className="px-4 py-3 rounded-tl-lg min-w-[150px]">Mã đơn / KH</th>
              <th className="px-4 py-3 w-1/5 min-w-[200px]">Quy cách</th>
              <th className="px-4 py-3 min-w-[120px]">Thanh toán</th>
              <th className="px-4 py-3 min-w-[150px]">Trạng thái</th>
              <th className="px-4 py-3 min-w-[200px]">Công đoạn sản xuất</th>
              <th className="px-4 py-3 min-w-[200px]">Công đoạn phụ</th>
              <th className="px-4 py-3 text-right rounded-tr-lg min-w-[100px]">Thao tác</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-gray-100">
            {filteredOrders.map((order) => {
              // Đơn sản xuất lại (xem setup_rework_orders.sql): không công đoạn,
              // không thanh toán — dòng rút gọn, chỉ còn nút Hoàn thành.
              const isRework = !!order.rework_of_order_id;
              const isDone = order.status === 'HoanThanh' || order.status === 'Huy';
              return (
              <tr key={order.id} className={`hover:bg-gray-50 transition-colors ${isRework ? 'bg-orange-50/40' : ''}`}>
                <td className="px-4 py-3 align-top">
                  <div className="font-bold text-gray-800">{order.order_code}</div>
                  <div className="text-[#00796b] font-medium text-xs">{order.customer?.name || 'Vãng lai'}</div>
                  <div className="text-xs text-gray-500 mt-1">{formatDateTime(order.created_at)}</div>
                  {order.is_urgent && <span className="inline-block mt-1 text-[10px] bg-red-100 text-red-600 px-1.5 py-0.5 rounded font-bold">GẤP</span>}
                  {isRework && (
                    <button
                      type="button"
                      onClick={() => { if (order.rework_of) onOpenOrder?.(order.rework_of); }}
                      className="mt-1 inline-flex items-center gap-1 px-1.5 py-0.5 rounded text-[10px] font-bold bg-orange-100 text-orange-800 border border-orange-200 hover:bg-orange-200"
                      title="Mở đơn gốc"
                    >
                      <i className="fa-solid fa-rotate"></i> Làm lại đơn {order.rework_of?.order_code || '…'}
                    </button>
                  )}
                  {!isRework && (order.reworks?.length || 0) > 0 && (
                    <div className="mt-1 text-[10px] text-red-700 font-bold">
                      <i className="fa-solid fa-triangle-exclamation mr-1"></i>
                      Đã làm lại: {order.reworks!.map(r => reworkSuffix(r.order_code)).join(', ')}
                    </div>
                  )}
                </td>
                <td className="px-4 py-3 align-top">
                  <p className="whitespace-pre-wrap text-gray-700 text-xs">{order.description}</p>
                  {isRework ? (
                    <div className="mt-2 text-xs bg-orange-50 border border-orange-200 rounded px-2 py-1 space-y-0.5">
                      <div><span className="text-gray-500">Lý do:</span> <span className="font-bold text-orange-900">{order.rework_reason || 'Không ghi'}</span></div>
                      <div><span className="text-gray-500">Chi phí làm lại:</span> <span className="font-bold text-red-600">{(order.rework_cost || 0).toLocaleString('vi-VN')}</span></div>
                    </div>
                  ) : (
                    <div className="mt-2 text-xs bg-gray-100 inline-block px-2 py-1 rounded">
                      <span className="font-bold text-red-600">{order.total_amount.toLocaleString('vi-VN')}</span>
                    </div>
                  )}
                </td>
                <td className="px-4 py-3 align-top">
                  {isRework ? (
                    <span className="inline-block px-2 py-1 rounded text-[10px] font-bold uppercase bg-orange-100 text-orange-700" title="Khách không trả tiền cho đơn sản xuất lại">Nội bộ</span>
                  ) : (
                    <span className={`inline-block px-2 py-1 rounded text-[10px] font-bold uppercase
                      ${order.payment_status === 'DaThanhToan' ? 'bg-green-100 text-green-700' :
                        order.payment_status === 'DaCoc' ? 'bg-orange-100 text-orange-700' : 'bg-red-100 text-red-700'}`}>
                      {order.payment_status}
                    </span>
                  )}
                  <div className="text-xs text-gray-500 mt-1">{/* Note field or method */}</div>
                </td>
                <td className="px-4 py-3 align-top">
                  {isRework ? (
                    <div className="flex flex-col gap-1">
                      <span className={`inline-block px-2 py-1 rounded text-xs font-bold text-center ${order.status === 'HoanThanh' ? 'bg-green-100 text-green-700' : order.status === 'Huy' ? 'bg-gray-200 text-gray-600' : 'bg-orange-100 text-orange-800'}`}>
                        {order.status === 'HoanThanh' ? '✓ Đã xong' : order.status === 'Huy' ? 'Đã hủy' : 'Đang làm lại'}
                      </span>
                      {!isDone && (
                        <button
                          type="button"
                          onClick={() => { if (confirm('Xác nhận đã làm lại xong đơn này?')) handleStatusChange(order.id, 'HoanThanh', order.status); }}
                          className="px-2 py-1 rounded text-xs font-bold text-white bg-[#4CAF50] hover:opacity-90 shadow-sm"
                        >
                          <i className="fa-solid fa-check mr-1"></i>Hoàn thành
                        </button>
                      )}
                    </div>
                  ) : (
                  <select
                    className="border border-gray-300 rounded text-xs py-1 px-2 w-full focus:ring-1 focus:ring-[#00796b]"
                    value={order.status}
                    onChange={(e) => handleStatusChange(order.id, e.target.value, order.status)}
                    disabled={order.status === 'HoanThanh' && !canUndoComplete}
                    title={order.status === 'HoanThanh' && !canUndoComplete
                      ? "Chỉ Admin mới đổi được trạng thái đơn đã hoàn thành."
                      : undefined}
                  >
                    <option value="Moi">Mới</option>
                    <option value="TiepNhan">Tiếp nhận</option>
                    <option value="NhanFile">Nhận File</option>
                    <option value="XuLyFile">Xử lý File</option>
                    <option value="BinhFile">Bình File</option>
                    <option value="In">In</option>
                    <option value="ThanhPham">Thành phẩm</option>
                    <option value="DongGoi">Đóng gói</option>
                    <option value="ChoGiaoHang">Chờ giao hàng</option>
                    <option value="GiaoHang">Đi giao hàng</option>
                    <option value="DaGiaoHang">Đã giao hàng</option>
                    <option value="HoanThanh">Hoàn thành</option>
                    <option value="TamNgung">Tạm ngưng</option>
                    <option value="Huy">Đã hủy</option>
                  </select>
                  )}
                </td>
                <td className="px-4 py-3 align-top">
                  {isRework ? <span className="text-xs text-gray-400 italic">Không có công đoạn</span> : renderStageCell(order)}
                </td>
                <td className="px-4 py-3 align-top">
                  {isRework ? (
                    <span className="text-xs text-gray-400 italic">—</span>
                  ) : (
                  <div className="flex flex-col gap-2">
                    <TaskControl orderId={order.id} taskKey="thietKe" taskLabel="Thiết kế" hasTask={order.has_design} isCompleted={order.design_status === 'Completed'} color={COLORS.design} />
                    <TaskControl orderId={order.id} taskKey="inKhoLon" taskLabel="In Khổ Lớn" hasTask={order.has_large_print} isCompleted={order.large_print_status === 'Completed'} color={COLORS.largeFormat} />
                    <TaskControl orderId={order.id} taskKey="be_demi" taskLabel="Bế Demi" hasTask={order.has_be_demi} isCompleted={order.be_demi_status === 'Completed'} color={COLORS.pink} />
                    <TaskControl orderId={order.id} taskKey="gia_cong_ngoai" taskLabel="GC Ngoài" hasTask={order.has_gia_cong_ngoai} isCompleted={order.outsource_status === 'Completed'} color={COLORS.orange} />
                    <TaskControl orderId={order.id} taskKey="ep_kim" taskLabel="Ép Kim" hasTask={order.has_ep_kim} isCompleted={order.ep_kim_status === 'Completed'} color={COLORS.warning} />
                    <TaskControl orderId={order.id} taskKey="invoice" taskLabel="Hóa đơn" hasTask={true} isCompleted={order.invoice_status === 'Issued'} color="#607d8b" />
                  </div>
                  )}
                </td>
                <td className="px-4 py-3 align-top text-right">
                  <div className="flex justify-end gap-1">
                    {canRework && onRework && order.status !== 'Huy' && (
                      <button
                        onClick={() => onRework(order)}
                        className="p-1.5 text-gray-500 hover:text-[#e65100] hover:bg-orange-50 rounded transition-colors"
                        title={isRework ? "Làm lại lần nữa" : "Tạo đơn sản xuất lại"}
                      >
                        <i className="fa-solid fa-rotate"></i>
                      </button>
                    )}
                    <button
                      onClick={() => onEdit(order)}
                      className="p-1.5 text-gray-500 hover:text-[#00796b] hover:bg-green-50 rounded transition-colors" title="Sửa"
                    >
                      <i className="fa-solid fa-pen"></i>
                    </button>
                  </div>
                </td>
              </tr>
              );
            })}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default OrderList;
