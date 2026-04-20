import React, { useState, useEffect, useCallback } from 'react';
import { api } from '../../services/mockApi';
import { FinancialReportData } from '../../types';

interface FinancialReportProps {
  onClose: () => void;
}

// Helper to format date as YYYY-MM-DD
const formatDate = (date: Date): string => {
  const y = date.getFullYear();
  const m = String(date.getMonth() + 1).padStart(2, '0');
  const d = String(date.getDate()).padStart(2, '0');
  return `${y}-${m}-${d}`;
};

const FinancialReport: React.FC<FinancialReportProps> = ({ onClose }) => {
  const now = new Date();
  const firstDayOfMonth = new Date(now.getFullYear(), now.getMonth(), 1);
  const lastDayOfMonth = new Date(now.getFullYear(), now.getMonth() + 1, 0);

  const [startDate, setStartDate] = useState(formatDate(firstDayOfMonth));
  const [endDate, setEndDate] = useState(formatDate(lastDayOfMonth));
  const [report, setReport] = useState<FinancialReportData | null>(null);
  const [loading, setLoading] = useState(false);

  const fetchData = useCallback(async (start: string, end: string) => {
    setLoading(true);
    try {
      const data = await api.getFinancialReport(start, end);
      setReport(data);
    } catch (error) {
      console.error('Error fetching financial report:', error);
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    fetchData(startDate, endDate);
  }, []);

  const handleToday = () => {
    const today = formatDate(now);
    setStartDate(today);
    setEndDate(today);
    fetchData(today, today);
  };

  const handleThisMonth = () => {
    const start = formatDate(firstDayOfMonth);
    const end = formatDate(lastDayOfMonth);
    setStartDate(start);
    setEndDate(end);
    fetchData(start, end);
  };

  const handleView = () => {
    fetchData(startDate, endDate);
  };

  const Card = ({ title, value, color, subText }: { title: string, value: number, color: string, subText?: string }) => (
    <div className="bg-gray-50 rounded-lg p-6 border border-gray-200 text-center">
      <h4 className="text-gray-500 text-sm font-bold uppercase mb-2">{title}</h4>
      <p className="text-3xl font-bold mb-1" style={{ color }}>{value.toLocaleString('vi-VN')}</p>
      <span className="text-xs text-gray-400">VNĐ</span>
      {subText && <p className="text-xs text-gray-500 mt-2 italic">{subText}</p>}
    </div>
  );

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center p-4">
      <div className="bg-white rounded-xl shadow-2xl w-full max-w-4xl max-h-[90vh] overflow-y-auto">
        <div className="flex justify-between items-center p-6 border-b border-gray-100">
          <h3 className="text-xl font-bold text-[#2E7D32]">Báo cáo Tài chính</h3>
          <button onClick={onClose} className="text-gray-400 hover:text-gray-600 text-2xl">&times;</button>
        </div>

        <div className="p-6">
          <div className="flex justify-center gap-4 mb-6 flex-wrap">
            <button
              onClick={handleToday}
              className="bg-[#607d8b] text-white px-4 py-2 rounded text-sm hover:bg-[#455a64] transition"
            >
              Hôm nay
            </button>
            <button
              onClick={handleThisMonth}
              className="bg-[#607d8b] text-white px-4 py-2 rounded text-sm hover:bg-[#455a64] transition"
            >
              Tháng này
            </button>
            <div className="flex items-center gap-2 border border-gray-300 rounded px-2">
              <span className="text-xs text-gray-500">Từ</span>
              <input
                type="date"
                className="text-sm py-1 outline-none"
                value={startDate}
                onChange={(e) => setStartDate(e.target.value)}
              />
              <span className="text-xs text-gray-500">Đến</span>
              <input
                type="date"
                className="text-sm py-1 outline-none"
                value={endDate}
                onChange={(e) => setEndDate(e.target.value)}
              />
            </div>
            <button
              onClick={handleView}
              className="bg-[#00796b] text-white px-4 py-2 rounded text-sm hover:bg-[#005a4f] transition"
            >
              <i className="fa-solid fa-eye"></i> Xem
            </button>
          </div>

          {loading || !report ? (
            <div className="text-center py-10"><i className="fa-solid fa-spinner fa-spin text-2xl text-gray-400"></i></div>
          ) : (
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              <Card title="Tổng thu (Tiền mặt)" value={report.tongThuTienMat} color="#333" />
              <Card title="Tổng thu (Chuyển khoản)" value={report.tongThuChuyenKhoan} color="#333" />

              <div className="md:col-span-2">
                <Card title="Tổng Doanh thu (Đã thu)" value={report.tongDoanhThuDaThu} color="#2E7D32" subText="Tổng tiền thực tế đã thu về trong kỳ (bao gồm tiền cọc và thanh toán)" />
              </div>

              <div className="md:col-span-2">
                <Card title="Công nợ mới phát sinh" value={report.congNoMoiPhatSinh} color="#f57c00" subText="Tổng giá trị đơn hàng chưa thanh toán hoặc còn nợ trong kỳ" />
              </div>
            </div>
          )}
        </div>
      </div>
    </div>
  );
};

export default FinancialReport;
