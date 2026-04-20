import React, { useState } from 'react';

interface StageControlProps {
  stageKey: 'BinhFile' | 'In' | 'ThanhPham' | string;
  stageLabel: string;
  orderId: number | string;
  participants: any[];
  color: string;
  isProminent?: boolean;
  onJoin?: () => Promise<void>;
  onLeave?: () => Promise<void>;
  isJoined?: boolean;
  readOnly?: boolean;
}

const StageControl: React.FC<StageControlProps> = ({
  stageKey, stageLabel, participants = [], color, isProminent = false, onJoin, onLeave, isJoined = false,
  readOnly = false
}) => {
  const [loading, setLoading] = useState(false);

  // Helper to format participant list
  // Note: participants from DB might be [{user_id, start_time, ...}]
  // We need names. If not available, show ID or 'User'
  const displayParticipants = participants.map(p => ({
    name: p.user?.full_name || p.user_id || 'N/A', // Handle joined user data if available
    time: p.started_at ? new Date(p.started_at).toLocaleString('vi-VN') : ''
  }));

  const handleJoin = async () => {
    if (!onJoin || readOnly) return;
    setLoading(true);
    try {
      await onJoin();
    } catch (error) {
      console.error(error);
    } finally {
      setLoading(false);
    }
  };

  const handleUndo = async () => {
    if (!onLeave || readOnly) return;
    if (!window.confirm("Bạn có chắc chắn muốn hoàn tác?")) return;
    setLoading(true);
    try {
      await onLeave();
    } catch (error) {
      console.error(error);
    } finally {
      setLoading(false);
    }
  };

  // Nếu là Prominent (Nút to theo trạng thái)
  if (isProminent) {
    return (
      <div className="w-full">
        {!isJoined ? (
          <button
            onClick={handleJoin}
            disabled={loading || readOnly}
            className={`w-full text-white font-bold py-2 rounded-md transition-opacity flex items-center justify-center gap-2 shadow-sm ${readOnly ? 'opacity-50 cursor-not-allowed' : 'hover:opacity-90'}`}
            style={{ backgroundColor: color }}
          >
            {loading ? <i className="fa-solid fa-spinner fa-spin"></i> : <i className="fa-solid fa-hand-paper"></i>}
            Tham gia '{stageLabel}'
          </button>
        ) : (
          <div className="flex gap-2">
            <button disabled className="flex-1 bg-gray-200 text-gray-500 font-bold py-2 rounded-md cursor-not-allowed border border-gray-300">
              <i className="fa-solid fa-check mr-1"></i> Đã tham gia '{stageLabel}'
            </button>
            <button
              onClick={handleUndo}
              disabled={loading || readOnly}
              className={`w-12 bg-orange-100 text-orange-600 border border-orange-200 rounded-md transition-colors flex items-center justify-center ${readOnly ? 'opacity-50 cursor-not-allowed' : 'hover:bg-orange-200'}`}
              title="Hoàn tác"
            >
              {loading ? <i className="fa-solid fa-spinner fa-spin"></i> : <i className="fa-solid fa-rotate-left"></i>}
            </button>
          </div>
        )}

        {displayParticipants.length > 0 && (
          <div className="mt-2 text-left text-xs text-gray-600 bg-gray-50 border border-gray-100 rounded p-2">
            {displayParticipants.map((p, idx) => (
              <div key={idx} className="mb-1 last:mb-0 flex justify-between">
                <span className="font-semibold">{p.name}</span> <span className="text-gray-400 text-[10px]">{p.time}</span>
              </div>
            ))}
          </div>
        )}
      </div>
    );
  }

  // Giao diện mặc định (nhỏ) cho các trạng thái khác hoặc lịch sử
  return (
    <div className="border border-gray-200 rounded p-2 bg-gray-50 text-center text-xs h-full flex flex-col justify-between">
      <div className="font-bold mb-1.5 uppercase" style={{ color }}>{stageLabel}</div>

      <div className="flex gap-1 justify-center mb-2">
        {isJoined ? (
          <>
            <button disabled className="flex-1 bg-gray-200 text-gray-500 px-1 py-1 rounded cursor-not-allowed text-[10px]">
              Đã tham gia
            </button>
            <button
              onClick={handleUndo}
              disabled={loading || readOnly}
              className={`bg-orange-100 text-orange-600 px-2 py-1 rounded transition-colors ${readOnly ? 'opacity-50 cursor-not-allowed' : 'hover:bg-orange-200'}`}
            >
              {loading ? <i className="fa-solid fa-spinner fa-spin"></i> : <i className="fa-solid fa-rotate-left"></i>}
            </button>
          </>
        ) : (
          <button
            onClick={handleJoin}
            disabled={loading || readOnly}
            className={`w-full text-white px-2 py-1 rounded transition-opacity flex items-center justify-center gap-1 ${readOnly ? 'opacity-50 cursor-not-allowed' : 'hover:opacity-90'}`}
            style={{ backgroundColor: color }}
          >
            {loading ? <i className="fa-solid fa-spinner fa-spin"></i> : <i className="fa-solid fa-hand-paper"></i>} Tham gia
          </button>
        )}
      </div>

      {displayParticipants.length > 0 && (
        <div className="text-left text-[10px] text-gray-600 bg-white border border-gray-100 rounded p-1 max-h-16 overflow-y-auto mt-auto">
          {displayParticipants.map((p, idx) => (
            <div key={idx} className="mb-0.5">
              <span className="font-bold">{p.name}</span>
            </div>
          ))}
        </div>
      )}
    </div>
  );
};

export default StageControl;
