
import React, { useState, useEffect } from 'react';
import { supabase } from '../services/supabaseClient';
import { authService } from '../services/auth';

const ResetPassword = () => {
    const [password, setPassword] = useState('');
    const [confirmPassword, setConfirmPassword] = useState('');
    const [loading, setLoading] = useState(false);
    const [message, setMessage] = useState<{ type: 'success' | 'error', text: string } | null>(null);

    // Parse hash to see if we have an access token (implicit flow)
    // Supabase usually handles session establishment automatically if token is in URL.
    // We just need to check if we have a session or user.

    useEffect(() => {
        // Optional: Check if user is authenticated via the link
        authService.getSession().then(session => {
            if (!session) {
                // If no session, the link might be invalid or expired
                // But for 'resetPasswordForEmail', it logs the user in and triggers a password_recovery event.
            }
        });
    }, []);

    const handleUpdatePassword = async (e: React.FormEvent) => {
        e.preventDefault();

        if (password !== confirmPassword) {
            setMessage({ type: 'error', text: 'Mật khẩu xác nhận không khớp.' });
            return;
        }

        if (password.length < 6) {
            setMessage({ type: 'error', text: 'Mật khẩu phải có ít nhất 6 ký tự.' });
            return;
        }

        setLoading(true);
        setMessage(null);

        try {
            const { error } = await supabase.auth.updateUser({ password: password });

            if (error) throw error;

            setMessage({ type: 'success', text: 'Cập nhật mật khẩu thành công! Đang chuyển hướng...' });

            // Redirect to home after 2 seconds
            setTimeout(() => {
                window.location.href = '/';
            }, 2000);

        } catch (err: any) {
            setMessage({ type: 'error', text: err.message || 'Lỗi cập nhật mật khẩu.' });
        } finally {
            setLoading(false);
        }
    };

    return (
        <div className="min-h-screen flex items-center justify-center bg-gray-100">
            <div className="max-w-md w-full bg-white shadow-lg rounded-lg p-8">
                <div className="text-center mb-6">
                    <h2 className="text-2xl font-bold text-gray-800">Đặt Lại Mật Khẩu</h2>
                    <p className="text-gray-600">Nhập mật khẩu mới của bạn</p>
                </div>

                {message && (
                    <div className={`mb-4 p-3 rounded text-sm text-center ${message.type === 'success' ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-700'}`}>
                        {message.text}
                    </div>
                )}

                <form onSubmit={handleUpdatePassword} className="space-y-6">
                    <div>
                        <label className="block text-sm font-medium text-gray-700 mb-1">Mật khẩu mới</label>
                        <input
                            type="password"
                            required
                            className="w-full px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                            placeholder="••••••••"
                            value={password}
                            onChange={(e) => setPassword(e.target.value)}
                        />
                    </div>
                    <div>
                        <label className="block text-sm font-medium text-gray-700 mb-1">Xác nhận mật khẩu</label>
                        <input
                            type="password"
                            required
                            className="w-full px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                            placeholder="••••••••"
                            value={confirmPassword}
                            onChange={(e) => setConfirmPassword(e.target.value)}
                        />
                    </div>

                    <button
                        type="submit"
                        disabled={loading}
                        className={`w-full py-2 px-4 rounded-md text-white font-medium ${loading ? 'bg-gray-400 cursor-not-allowed' : 'bg-blue-600 hover:bg-blue-700'
                            } transition duration-200`}
                    >
                        {loading ? 'Đang xử lý...' : 'Cập nhật Mật khẩu'}
                    </button>
                </form>
            </div>
        </div>
    );
};

export default ResetPassword;
