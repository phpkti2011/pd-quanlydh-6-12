
import React, { useState } from 'react';
import { authService } from '../services/auth';
import { supabase } from '../services/supabaseClient';

import { useToast } from './ToastProvider';

const Login = () => {
    const { addToast } = useToast();
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');
    const [error, setError] = useState<string | null>(null);
    const [loading, setLoading] = useState(false);
    const [isSignUp, setIsSignUp] = useState(false);
    const [fullName, setFullName] = useState('');
    const [isForgotPassword, setIsForgotPassword] = useState(false);

    const handleForgotPassword = async () => {
        if (!email) {
            setError("Vui lòng nhập email.");
            return;
        }
        setLoading(true);
        setError(null);
        try {
            await authService.resetPasswordForEmail(email);
            addToast("Đã gửi link khôi phục mật khẩu vào email của bạn!", 'success');
            setIsForgotPassword(false);
        } catch (err: any) {
            setError(err.message || "Không gửi được email khôi phục.");
        } finally {
            setLoading(false);
        }
    };

    const handleAuth = async (e: React.FormEvent) => {
        e.preventDefault();
        setLoading(true);
        setError(null);

        try {
            if (isSignUp) {
                const { error: signUpError } = await supabase.auth.signUp({
                    email,
                    password,
                    options: {
                        data: {
                            full_name: fullName,
                        },
                    },
                });
                if (signUpError) throw signUpError;
                addToast('Đăng ký thành công! Vui lòng kiểm tra email xác nhận (nếu có) hoặc đăng nhập.', 'success');
                setIsSignUp(false);
            } else {
                await authService.signInWithEmail(email, password);
                // Session update will be handled by onAuthStateChange in App.tsx
            }
        } catch (err: any) {
            setError(err.message || (isSignUp ? 'Đăng ký thất bại.' : 'Đăng nhập thất bại.'));
        } finally {
            setLoading(false);
        }
    };

    return (
        <div className="min-h-screen flex items-center justify-center bg-gray-100">
            <div className="max-w-md w-full bg-white shadow-lg rounded-lg p-8">
                <div className="text-center mb-6">
                    <h2 className="text-2xl font-bold text-gray-800">{isSignUp ? 'Đăng Ký Tài Khoản' : 'Đăng Nhập'}</h2>
                    <p className="text-gray-600">P&D Order Manager</p>
                </div>

                {error && (
                    <div className="mb-4 p-3 bg-red-100 text-red-700 rounded text-sm text-center">
                        {error}
                    </div>
                )}

                <form onSubmit={handleAuth} className="space-y-6">
                    {/* Forgot Password View */}
                    {isForgotPassword ? (
                        <div>
                            <div className="text-center mb-4">
                                <p className="text-sm text-gray-600">Nhập email để nhận link đặt lại mật khẩu</p>
                            </div>
                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-1">Email</label>
                                <input
                                    type="email"
                                    required
                                    className="w-full px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                                    placeholder="user@example.com"
                                    value={email}
                                    onChange={(e) => setEmail(e.target.value)}
                                />
                            </div>
                            <button
                                type="button"
                                onClick={handleForgotPassword}
                                disabled={loading}
                                className={`w-full py-2 px-4 mt-4 rounded-md text-white font-medium ${loading ? 'bg-gray-400 cursor-not-allowed' : 'bg-orange-600 hover:bg-orange-700'} transition duration-200`}
                            >
                                {loading ? 'Đang gửi...' : 'Gửi Link Khôi Phục'}
                            </button>
                            <div className="text-center mt-3">
                                <button
                                    type="button"
                                    onClick={() => { setIsForgotPassword(false); setError(null); }}
                                    className="text-sm text-blue-600 hover:underline"
                                >
                                    Quay lại Đăng nhập
                                </button>
                            </div>
                        </div>
                    ) : (
                        // Standard Login/Register Form
                        <>
                            {isSignUp && (
                                <div>
                                    <label className="block text-sm font-medium text-gray-700 mb-1">Họ và Tên</label>
                                    <input
                                        type="text"
                                        required
                                        className="w-full px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                                        placeholder="Nguyễn Văn A"
                                        value={fullName}
                                        onChange={(e) => setFullName(e.target.value)}
                                    />
                                </div>
                            )}
                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-1">Email</label>
                                <input
                                    type="email"
                                    required
                                    className="w-full px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                                    placeholder="user@example.com"
                                    value={email}
                                    onChange={(e) => setEmail(e.target.value)}
                                />
                            </div>
                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-1">Mật khẩu</label>
                                <input
                                    type="password"
                                    required
                                    className="w-full px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                                    placeholder="••••••••"
                                    value={password}
                                    onChange={(e) => setPassword(e.target.value)}
                                />
                            </div>

                            <button
                                type="submit"
                                disabled={loading}
                                className={`w-full py-2 px-4 rounded-md text-white font-medium ${loading ? 'bg-gray-400 cursor-not-allowed' : 'bg-blue-600 hover:bg-blue-700'
                                    } transition duration-200`}
                            >
                                {loading ? 'Đang xử lý...' : (isSignUp ? 'Đăng Ký' : 'Đăng Nhập')}
                            </button>

                            <div className="text-center text-sm text-gray-600 mt-4">
                                {isSignUp ? 'Đã có tài khoản? ' : 'Chưa có tài khoản? '}
                                <button
                                    type="button"
                                    onClick={() => { setIsSignUp(!isSignUp); setError(null); }}
                                    className="text-blue-600 hover:underline focus:outline-none font-medium"
                                >
                                    {isSignUp ? 'Đăng nhập ngay' : 'Đăng ký ngay'}
                                </button>
                            </div>

                            {!isSignUp && (
                                <div className="text-center text-xs text-gray-500 mt-3">
                                    <button
                                        type="button"
                                        onClick={() => { setIsForgotPassword(true); setError(null); }}
                                        className="text-orange-600 hover:underline focus:outline-none"
                                    >
                                        Quên mật khẩu?
                                    </button>
                                </div>
                            )}
                        </>
                    )}
                </form>
            </div>
        </div>
    );
};

export default Login;
