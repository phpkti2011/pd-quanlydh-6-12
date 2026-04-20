import React, { useState, useEffect } from 'react';
import { orderService } from '../services/orderService';
import { commentService, Comment } from '../services/commentService';
import { useToast } from './ToastProvider';

interface TaskControlProps {
  orderId: string;
  taskKey: string; // DB column for status
  taskNoteKey: string; // DB column for note
  taskLabel: string;
  hasTask: boolean;
  isCompleted?: boolean;
  color: string;
  note?: string;
  onEditNote: (taskNoteKey: string, currentNote: string, taskLabel: string) => void;
  completedBy?: string;
  completedAt?: string;
  completedByUserId?: string;
  currentUserId?: string;
  userRole?: string; // To allow Admin override if needed
  onRefresh?: () => void;
  readOnly?: boolean;
}

const TaskControl: React.FC<TaskControlProps> = ({
  orderId, taskKey, taskNoteKey, taskLabel, hasTask, isCompleted: initialStatus,
  color, note: initialNote, onEditNote,
  completedBy, completedAt, completedByUserId, currentUserId, userRole, onRefresh,
  readOnly = false
}) => {
  const toast = useToast();
  const [isCompleted, setIsCompleted] = useState(initialStatus);
  const [note, setNote] = useState(initialNote);
  const [comments, setComments] = useState<Comment[]>([]);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    setIsCompleted(initialStatus);
  }, [initialStatus]);

  useEffect(() => {
    setNote(initialNote);
  }, [initialNote]);

  // Fetch comments for this task context
  useEffect(() => {
    if (hasTask) {
      commentService.getComments(orderId, taskNoteKey)
        .then(data => setComments(data))
        .catch(err => console.error(err));
    }
  }, [orderId, taskNoteKey, hasTask]);

  if (!hasTask) return null;

  const mapTaskToStage = (key: string): string | null => {
    if (key === 'design_status') return 'ThietKe';
    if (key === 'large_print_status') return 'InKhoLon';
    if (key === 'ep_kim_status') return 'EpKim';
    if (key === 'be_demi_status') return 'BeDemi';
    if (key === 'outsource_status') return 'GiaCongNgoai';
    return null;
  };

  const handleToggle = async () => {
    if (readOnly) return;

    // 1. Permission Check for UNDO
    if (isCompleted) {
      // If completed, we are trying to Undo.
      // Check if current user is the one who completed it.
      // If completed, we are trying to Undo.
      // Check if current user is the one who completed it.
      // Strict Undo: Only the original completer can undo.
      const isOwner = currentUserId && completedByUserId && currentUserId === completedByUserId;

      if (!isOwner) {
        toast.addToast("Chỉ người thực hiện mới có quyền hoàn tác công đoạn này!", 'error');
        return;
      }
    }

    const newStatus = isCompleted ? 'Pending' : 'Completed';
    const stageName = mapTaskToStage(taskKey);

    setLoading(true);
    try {
      // 1. Update Order Status
      await orderService.updateOrder(orderId, { [taskKey]: newStatus });

      // 2. Log Participation (Commission/Activity)
      const userId = currentUserId;

      if (userId && stageName) {
        if (newStatus === 'Completed') {
          await orderService.joinStage(orderId, stageName, userId);
        } else {
          // Undo participation
          await orderService.leaveStage(orderId, stageName, userId);
        }
      }

      setIsCompleted(!isCompleted);

      // Trigger Parent Refresh
      if (onRefresh) {
        onRefresh();
      }
    } catch (error) {
      console.error(error);
      toast.addToast("Lỗi cập nhật trạng thái: " + (error as Error).message, 'error');
    } finally {
      setLoading(false);
    }
  };

  const handleEditNote = () => {
    if (readOnly) return;
    onEditNote(taskNoteKey, note || "", taskLabel);
  }

  return (
    <div className="mb-3 last:mb-0">
      <div className="flex items-start justify-between">
        <div className="flex flex-col">
          <div className="flex items-center gap-2">
            <span className="font-bold text-[15px]" style={{ color }}>{taskLabel}</span>
          </div>
          <div className={`text-sm italic ${isCompleted ? 'text-green-600 font-bold' : 'text-red-500'}`}>
            {isCompleted ? '✔ Xong' : 'Chưa làm'}
          </div>

          {/* Completion Info Block - Always Visible if Completed */}
          {isCompleted && completedBy && (
            <div className="mt-1 text-xs text-gray-500 bg-gray-50 border border-gray-100 rounded px-1.5 py-0.5 inline-block w-fit">
              <span className="font-bold text-gray-700">{completedBy}</span>
              {completedAt && (
                <span className="text-gray-400 ml-1">
                  {new Date(completedAt).toLocaleString('vi-VN', { hour: '2-digit', minute: '2-digit', day: '2-digit', month: '2-digit' })}
                </span>
              )}
            </div>
          )}
        </div>

        <div className="flex gap-2">
          <button
            onClick={handleToggle}
            disabled={loading || readOnly}
            className={`w-7 h-7 rounded-full border flex items-center justify-center transition-colors shadow-sm ${isCompleted ? 'border-orange-400 text-orange-500 hover:bg-orange-50 bg-white' : 'border-green-500 text-green-500 hover:bg-green-50 bg-white'} ${readOnly ? 'opacity-50 cursor-not-allowed' : ''}`}
            title={isCompleted ? "Hoàn tác" : "Hoàn thành"}
          >
            {loading ? (
              <i className="fa-solid fa-spinner fa-spin text-xs text-gray-400"></i>
            ) : isCompleted ? (
              <i className="fa-solid fa-rotate-left text-sm"></i>
            ) : (
              <i className="fa-solid fa-check text-sm"></i>
            )}
          </button>

          <button
            onClick={handleEditNote}
            disabled={readOnly}
            className={`w-7 h-7 rounded-full border border-blue-300 flex items-center justify-center hover:bg-blue-50 transition-colors text-blue-500 ${readOnly ? 'opacity-50 cursor-not-allowed' : ''}`}
            title="Sửa hội thoại / Ghi chú"
          >
            <i className="fa-solid fa-pen text-xs"></i>
          </button>
        </div>
      </div>

      {/* Render Conversation OR Legacy Note */}
      {(comments.length > 0 || note) && (
        <div
          className="mt-1 bg-[#fffbe6] border border-[#ffe58f] rounded overflow-hidden max-h-[60px] hover:max-h-[500px] transition-all duration-500 cursor-help relative group"
          title="Rê chuột/Chạm để xem toàn bộ hội thoại"
        >
          <div className="p-1.5 space-y-1.5">
            {/* 1. Legacy Note (if exists and no comments, OR display at top?) */}
            {/* If comments exist, we assume they supersede or include the note eventually. 
                    But for now, if we have comments, just show comments. 
                    If we have legacy note but no comments, show legacy note. 
                    Actually, let's show both if mixed? 
                    User said "hiện ra đoạn hội thoại". 
                */}

            {comments.length > 0 ? (
              // Show only the latest comment (last item in array)
              (() => {
                const latestComment = comments[comments.length - 1];
                return (
                  <>
                    {/* Hidden comments for expanded view - only visible on hover */}
                    {comments.slice(0, -1).map(c => (
                      <div key={c.id} className="text-xs border-b border-[#eee] pb-1 hidden group-hover:block">
                        <div className="flex justify-between opacity-70 mb-0.5">
                          <strong className="text-gray-700">{c.user?.full_name || 'N/A'}</strong>
                          <span className="text-[10px]">{new Date(c.created_at).toLocaleString('vi-VN', { hour: '2-digit', minute: '2-digit', day: '2-digit', month: '2-digit' })}</span>
                        </div>
                        <div className="text-gray-900">{c.content}</div>
                        {c.ai_summary && <div className="text-[10px] text-purple-600 italic mt-0.5">✨ {c.ai_summary}</div>}
                      </div>
                    ))}

                    {/* Latest comment - always visible */}
                    <div className="text-xs pb-1">
                      <div className="flex justify-between opacity-70 mb-0.5">
                        <strong className="text-gray-700">{latestComment.user?.full_name || 'N/A'}</strong>
                        <span className="text-[10px]">{new Date(latestComment.created_at).toLocaleString('vi-VN', { hour: '2-digit', minute: '2-digit', day: '2-digit', month: '2-digit' })}</span>
                      </div>
                      <div className="text-gray-900">{latestComment.content}</div>
                      {latestComment.ai_summary && <div className="text-[10px] text-purple-600 italic mt-0.5">✨ {latestComment.ai_summary}</div>}
                    </div>

                    {/* Indicator for older comments - hidden on hover */}
                    {comments.length > 1 && (
                      <div className="text-[10px] text-gray-500 italic text-center pt-0.5 group-hover:hidden">
                        +{comments.length - 1} tin nhắn cũ hơn (rê chuột để xem)
                      </div>
                    )}
                  </>
                );
              })()
            ) : (
              // Legacy Note Fallback
              <div className="text-sm text-gray-800">{note}</div>
            )}
          </div>
          {/* Fade overlay indicating truncation (hidden on hover) */}
          <div className="absolute bottom-0 left-0 right-0 h-4 bg-gradient-to-t from-[#fffbe6] to-transparent pointer-events-none group-hover:opacity-0 transition-opacity"></div>
        </div>
      )}
    </div>
  );
};

export default TaskControl;
