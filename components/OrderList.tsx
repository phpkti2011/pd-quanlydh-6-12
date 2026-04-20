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
}

const OrderList: React.FC<OrderListProps> = ({ orders, onEdit, onRefresh, currentUser, tabCounts, currentTab }) => {
  // const [currentTab, setCurrentTab] = useState('all'); // Removed internal state

  const handleStatusChange = async (orderId: string, newStatus: string) => {
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
            {filteredOrders.map((order) => (
              <tr key={order.id} className="hover:bg-gray-50 transition-colors">
                <td className="px-4 py-3 align-top">
                  <div className="font-bold text-gray-800">{order.order_code}</div>
                  <div className="text-[#00796b] font-medium text-xs">{order.customer?.name || 'Vãng lai'}</div>
                  <div className="text-xs text-gray-500 mt-1">{formatDateTime(order.created_at)}</div>
                  {order.is_urgent && <span className="inline-block mt-1 text-[10px] bg-red-100 text-red-600 px-1.5 py-0.5 rounded font-bold">GẤP</span>}
                </td>
                <td className="px-4 py-3 align-top">
                  <p className="whitespace-pre-wrap text-gray-700 text-xs">{order.description}</p>
                  <div className="mt-2 text-xs bg-gray-100 inline-block px-2 py-1 rounded">
                    <span className="font-bold text-red-600">{order.total_amount.toLocaleString('vi-VN')}</span>
                  </div>
                </td>
                <td className="px-4 py-3 align-top">
                  <span className={`inline-block px-2 py-1 rounded text-[10px] font-bold uppercase
                    ${order.payment_status === 'DaThanhToan' ? 'bg-green-100 text-green-700' :
                      order.payment_status === 'DaCoc' ? 'bg-orange-100 text-orange-700' : 'bg-red-100 text-red-700'}`}>
                    {order.payment_status}
                  </span>
                  <div className="text-xs text-gray-500 mt-1">{/* Note field or method */}</div>
                </td>
                <td className="px-4 py-3 align-top">
                  <select
                    className="border border-gray-300 rounded text-xs py-1 px-2 w-full focus:ring-1 focus:ring-[#00796b]"
                    value={order.status}
                    onChange={(e) => handleStatusChange(order.id, e.target.value)}
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
                </td>
                <td className="px-4 py-3 align-top">
                  {renderStageCell(order)}
                </td>
                <td className="px-4 py-3 align-top">
                  <div className="flex flex-col gap-2">
                    <TaskControl orderId={order.id} taskKey="thietKe" taskLabel="Thiết kế" hasTask={order.has_design} isCompleted={order.design_status === 'Completed'} color={COLORS.design} />
                    <TaskControl orderId={order.id} taskKey="inKhoLon" taskLabel="In Khổ Lớn" hasTask={order.has_large_print} isCompleted={order.large_print_status === 'Completed'} color={COLORS.largeFormat} />
                    <TaskControl orderId={order.id} taskKey="be_demi" taskLabel="Bế Demi" hasTask={order.has_be_demi} isCompleted={order.be_demi_status === 'Completed'} color={COLORS.pink} />
                    <TaskControl orderId={order.id} taskKey="gia_cong_ngoai" taskLabel="GC Ngoài" hasTask={order.has_gia_cong_ngoai} isCompleted={order.outsource_status === 'Completed'} color={COLORS.orange} />
                    <TaskControl orderId={order.id} taskKey="ep_kim" taskLabel="Ép Kim" hasTask={order.has_ep_kim} isCompleted={order.ep_kim_status === 'Completed'} color={COLORS.warning} />
                    <TaskControl orderId={order.id} taskKey="invoice" taskLabel="Hóa đơn" hasTask={true} isCompleted={order.invoice_status === 'Issued'} color="#607d8b" />
                  </div>
                </td>
                <td className="px-4 py-3 align-top text-right">
                  <button
                    onClick={() => onEdit(order)}
                    className="p-1.5 text-gray-500 hover:text-[#00796b] hover:bg-green-50 rounded transition-colors" title="Sửa"
                  >
                    <i className="fa-solid fa-pen"></i>
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default OrderList;
