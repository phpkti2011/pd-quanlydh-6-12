import React, { useState, useEffect } from 'react';
import { commentService, Comment } from '../services/commentService';
import { aiDiffService } from '../services/aiDiffService';

interface CommentSectionProps {
    orderId: string;
    contextKey: string; // 'notes', 'status_note', 'design_note'
    initialContent?: string; // Legacy content to init if empty
    readOnly?: boolean;
    onLegacyUpdate?: (val: string) => void; // Sync back to legacy field if needed
    placeholder?: string;
}

const CommentSection: React.FC<CommentSectionProps> = ({
    orderId, contextKey, initialContent, readOnly, onLegacyUpdate, placeholder
}) => {
    const [comments, setComments] = useState<Comment[]>([]);
    const [input, setInput] = useState('');
    const [loading, setLoading] = useState(false);
    const [analyzing, setAnalyzing] = useState(false);

    useEffect(() => {
        loadComments();
    }, [orderId, contextKey]);

    const loadComments = async () => {
        try {
            const data = await commentService.getComments(orderId, contextKey);
            setComments(data);

            // Migration logic: If no comments but legacy content exists, treat as first comment
            if (data.length === 0 && initialContent) {
                // Determine if we should auto-migrate or just display? 
                // Display legacy as a "ghost" comment or just let user start fresh?
                // Let's just let user input. 
                // Actually user requested: "History shows who entered it".
                // If we have legacy data, we don't know who entered it unless we tracked it.
                // We'll leave legacy as is, but future inputs go to table. 
            }
        } catch (error) {
            console.error(error);
        }
    };

    const handleSubmit = async () => {
        if (!input.trim()) return;
        setLoading(true);
        setAnalyzing(true);

        try {
            // Check for previous content for AI Diff
            let aiSummary = undefined;
            const lastComment = comments[comments.length - 1];
            const previousContent = lastComment ? lastComment.content : initialContent;

            if (previousContent && previousContent !== input) {
                const diff = await aiDiffService.generateDiffSummary(previousContent, input);
                if (diff) aiSummary = diff;
            }

            // Save
            await commentService.addComment(orderId, contextKey, input, aiSummary);

            // Sync Legacy if needed (to keep 'notes' column updated for reports)
            if (onLegacyUpdate) {
                onLegacyUpdate(input);
            }

            setInput('');
            loadComments();
        } catch (error) {
            alert("Lỗi lưu ghi chú: " + (error as Error).message);
        } finally {
            setLoading(false);
            setAnalyzing(false);
        }
    };

    return (
        <div className="flex flex-col gap-2">
            {/* History List */}
            <div className="space-y-3 max-h-60 overflow-y-auto pr-1">
                {comments.length === 0 && initialContent && (
                    <div className="text-sm p-2 bg-gray-50 border border-gray-100 rounded text-gray-500 italic">
                        (Nội dung cũ): {initialContent}
                    </div>
                )}

                {comments.map((comment) => (
                    <div key={comment.id} className="text-sm p-2 bg-white border border-gray-200 rounded shadow-sm">
                        <div className="flex justify-between items-start mb-1">
                            <span className="font-bold text-xs text-blue-700">{comment.user?.full_name || 'Người dùng'}</span>
                            <span className="text-[10px] text-gray-400">{new Date(comment.created_at).toLocaleString('vi-VN')}</span>
                        </div>
                        <div className="text-gray-800 whitespace-pre-wrap">{comment.content}</div>

                        {/* AI Analysis Badge */}
                        {comment.ai_summary && (
                            <div className="mt-2 text-xs bg-purple-50 border border-purple-100 p-1.5 rounded text-purple-800 flex items-start gap-1.5">
                                <i className="fa-solid fa-wand-magic-sparkles mt-0.5"></i>
                                <span>{comment.ai_summary}</span>
                            </div>
                        )}
                    </div>
                ))}
            </div>

            {/* Input Area */}
            {!readOnly && (
                <div className="flex flex-col gap-2 mt-2">
                    <textarea
                        className="w-full border border-gray-300 rounded p-2 text-sm focus:outline-none focus:border-blue-500"
                        rows={2}
                        placeholder={placeholder || "Nhập ghi chú..."}
                        value={input}
                        onChange={(e) => setInput(e.target.value)}
                    />
                    <div className="flex justify-between items-center">
                        {comments.length > 0 && (
                            <button
                                onClick={() => setInput(comments[comments.length - 1].content)}
                                className="text-xs text-gray-500 hover:text-blue-600 underline"
                            >
                                <i className="fa-solid fa-copy mr-1"></i>Copy nội dung cũ để sửa
                            </button>
                        )}
                        <button
                            onClick={handleSubmit}
                            disabled={loading}
                            className="bg-blue-600 text-white px-3 py-1.5 rounded text-xs font-bold hover:bg-blue-700 transition-colors ml-auto flex items-center gap-2"
                        >
                            {loading ? <i className="fa-solid fa-spinner fa-spin"></i> : <i className="fa-solid fa-paper-plane"></i>}
                            Gửi
                        </button>
                    </div>
                    {analyzing && <div className="text-[10px] text-purple-600 text-right animate-pulse">Đang phân tích thay đổi...</div>}
                </div>
            )}
        </div>
    );
};

export default CommentSection;
