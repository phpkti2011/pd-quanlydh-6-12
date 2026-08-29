import React, { useState, useMemo, useEffect } from 'react';
import { supabase } from '../services/supabaseClient';
import { Profile } from '../types';
import { compareVietnameseName } from '../utils/nameSort';
import {
    CommissionField,
    STAGE_COMMISSION_FIELDS,
    SUBTASK_COMMISSION_FIELDS,
    fillCommissionKeys,
    readRate,
    isRateUnset,
} from '../utils/commissionFields';
import { ROLE_LABELS } from '../utils/roleLabels';

type Group = 'stages' | 'subtasks';
type ProfileField = 'commission_stages' | 'commission_subtasks';

/** Vai trò không ăn hoa hồng sản xuất — hàm tính thưởng loại NVKD ra hẳn. */
const NON_PRODUCTION_ROLES = ['NhanVienKinhDoanh', 'Khach'];

/**
 * Ô tiêu đề ghim ở mép trên. Nền phải đặt trên CHÍNH ô (không phải <thead>),
 * và đường kẻ phải dùng inset shadow — border-collapse:collapse của Tailwind
 * không vẽ border cho ô sticky.
 */
const HEAD_CELL = 'sticky top-0 z-20 shadow-[inset_0_-2px_0_rgb(209,213,219)]';

/**
 * Ô thống kê ghim ở mép dưới. Ba dòng xếp chồng lên nhau nên phải có chiều cao
 * CỐ ĐỊNH (h-8 = 32px) để các mốc bottom-[64px] / bottom-[32px] / bottom-0 khớp
 * đúng, không hở khe cũng không đè nhau.
 */
const FOOT_CELL = 'sticky z-20 bg-gray-50 h-8 py-1';
/** Đường kẻ ngăn cách — chỉ vẽ ở dòng thống kê TRÊN CÙNG, không vẽ cả 3 dòng. */
const FOOT_TOP_LINE = 'shadow-[inset_0_2px_0_rgb(209,213,219)]';

const GROUP_CONFIG: Record<Group, { field: ProfileField; fields: CommissionField[]; title: string }> = {
    stages: {
        field: 'commission_stages',
        fields: STAGE_COMMISSION_FIELDS,
        title: 'Hoa hồng Quy trình',
    },
    subtasks: {
        field: 'commission_subtasks',
        fields: SUBTASK_COMMISSION_FIELDS,
        title: 'Hoa hồng Công đoạn',
    },
};

interface Props {
    employees: Profile[];
    onSaved: () => void;
    onDirtyChange: (dirty: boolean) => void;
}

/** Chỉ chứa dòng đã sửa; mỗi dòng chỉ chứa field thực sự đổi. */
type Edits = Record<string, Partial<Record<ProfileField, Record<string, number>>>>;

const CommissionMatrix: React.FC<Props> = ({ employees, onSaved, onDirtyChange }) => {
    const [group, setGroup] = useState<Group>('stages');
    const [edits, setEdits] = useState<Edits>({});
    const [showAllRoles, setShowAllRoles] = useState(false);
    const [searchTerm, setSearchTerm] = useState('');
    const [sortKey, setSortKey] = useState<string | null>(null);
    const [sortDesc, setSortDesc] = useState(true);
    const [saving, setSaving] = useState(false);

    const { field, fields } = GROUP_CONFIG[group];
    const dirtyCount = Object.keys(edits).length;

    // Báo ngược cho EmployeeManager để chặn rời tab khi còn sửa dở.
    useEffect(() => {
        onDirtyChange(dirtyCount > 0);
    }, [dirtyCount, onDirtyChange]);

    /** Giá trị đang hiển thị: ưu tiên phần đang sửa, không có thì lấy bản gốc. */
    const currentValue = (emp: Profile, key: string): number => {
        const pending = edits[emp.id]?.[field];
        if (pending && Object.prototype.hasOwnProperty.call(pending, key)) return pending[key];
        return readRate(emp[field], key);
    };

    const isDirtyCell = (emp: Profile, key: string): boolean => {
        const pending = edits[emp.id]?.[field];
        return !!pending && Object.prototype.hasOwnProperty.call(pending, key);
    };

    const handleChange = (emp: Profile, key: string, raw: string) => {
        const parsed = parseFloat(raw);
        const value = Number.isFinite(parsed) ? parsed : 0;

        setEdits(prev => {
            const rowPending = { ...(prev[emp.id]?.[field] || {}), [key]: value };

            // Trở lại đúng giá trị gốc ở mọi ô -> bỏ dòng khỏi danh sách đã sửa,
            // để nút Lưu không gửi update thừa.
            const stillChanged = Object.entries(rowPending).some(
                ([k, v]) => v !== readRate(emp[field], k) || isRateUnset(emp[field], k)
            );

            const nextRow = { ...prev[emp.id] };
            if (stillChanged) nextRow[field] = rowPending;
            else delete nextRow[field];

            const next = { ...prev };
            if (Object.keys(nextRow).length > 0) next[emp.id] = nextRow;
            else delete next[emp.id];
            return next;
        });
    };

    const visibleEmployees = useMemo(() => {
        const term = searchTerm.trim().toLowerCase();
        const list = employees.filter(emp => {
            if (!showAllRoles && NON_PRODUCTION_ROLES.includes(emp.role)) return false;
            if (!term) return true;
            return (
                emp.full_name?.toLowerCase().includes(term) ||
                emp.employee_code?.toLowerCase().includes(term) ||
                emp.email?.toLowerCase().includes(term)
            );
        });

        if (!sortKey) {
            return [...list].sort((a, b) => compareVietnameseName(a.full_name, b.full_name));
        }
        return [...list].sort((a, b) => {
            const diff = currentValue(a, sortKey) - currentValue(b, sortKey);
            if (diff !== 0) return sortDesc ? -diff : diff;
            return compareVietnameseName(a.full_name, b.full_name);
        });
        // currentValue phụ thuộc edits + field nên phải nằm trong deps
    }, [employees, showAllRoles, searchTerm, sortKey, sortDesc, edits, field]);

    /** Thống kê từng cột trên đúng tập đang hiển thị. */
    const columnStats = useMemo(() => {
        const stats: Record<string, { min: number; max: number; avg: number; zeros: number }> = {};
        fields.forEach(({ key }) => {
            if (visibleEmployees.length === 0) {
                stats[key] = { min: 0, max: 0, avg: 0, zeros: 0 };
                return;
            }
            const values = visibleEmployees.map(emp => currentValue(emp, key));
            stats[key] = {
                min: Math.min(...values),
                max: Math.max(...values),
                avg: values.reduce((sum, v) => sum + v, 0) / values.length,
                zeros: values.filter(v => v === 0).length,
            };
        });
        return stats;
    }, [visibleEmployees, fields, edits, field]);

    const toggleSort = (key: string) => {
        if (sortKey !== key) {
            setSortKey(key);
            setSortDesc(true);
        } else if (sortDesc) {
            setSortDesc(false);
        } else {
            setSortKey(null);
        }
    };

    const handleSave = async () => {
        const rows = Object.entries(edits);
        if (rows.length === 0) return;

        setSaving(true);
        try {
            const results = await Promise.all(
                rows.map(async ([id, pending]) => {
                    const emp = employees.find(e => e.id === id);
                    const payload: Partial<Profile> = {};

                    (Object.keys(pending) as ProfileField[]).forEach(profileField => {
                        const groupFields =
                            profileField === 'commission_stages'
                                ? STAGE_COMMISSION_FIELDS
                                : SUBTASK_COMMISSION_FIELDS;
                        // Luôn ghi ĐỦ key: thiếu key nghĩa là 0 khi tính thưởng.
                        payload[profileField] = fillCommissionKeys(groupFields, {
                            ...(emp?.[profileField] || {}),
                            ...pending[profileField],
                        });
                    });

                    // .select('id') để đếm dòng thật sự đổi — RLS chặn thì Postgres
                    // trả mảng rỗng chứ KHÔNG báo lỗi.
                    const { data, error } = await supabase
                        .from('profiles')
                        .update(payload)
                        .eq('id', id)
                        .select('id');

                    if (error) throw error;
                    return (data || []).length;
                })
            );

            const updated = results.reduce((sum, n) => sum + n, 0);
            if (updated < rows.length) {
                alert(
                    `Chỉ lưu được ${updated}/${rows.length} nhân viên.\n` +
                    'Nhiều khả năng tài khoản của bạn không có quyền sửa hồ sơ người khác (cần quyền Admin).'
                );
            } else {
                alert(`Đã lưu % hoa hồng cho ${updated} nhân viên.`);
            }

            setEdits({});
            onSaved();
        } catch (err: any) {
            console.error('Save commission matrix error:', err);
            alert('Lỗi khi lưu: ' + (err?.message || 'Không rõ nguyên nhân'));
        } finally {
            setSaving(false);
        }
    };

    const handleReset = () => {
        if (dirtyCount === 0) return;
        if (!window.confirm(`Hoàn tác toàn bộ thay đổi chưa lưu của ${dirtyCount} nhân viên?`)) return;
        setEdits({});
    };

    const fmt = (n: number) => (Number.isInteger(n) ? String(n) : n.toFixed(2));

    return (
        <div className="flex-1 flex flex-col min-h-0">
            {/* Toolbar */}
            <div className="px-6 py-3 border-b border-gray-100 bg-white flex gap-3 items-center flex-wrap flex-shrink-0">
                <div className="inline-flex rounded-lg border border-gray-300 overflow-hidden">
                    {(Object.keys(GROUP_CONFIG) as Group[]).map(g => (
                        <button
                            key={g}
                            onClick={() => setGroup(g)}
                            className={`px-4 py-2 text-sm font-medium transition-colors ${group === g
                                ? 'bg-blue-600 text-white'
                                : 'bg-white text-gray-600 hover:bg-gray-50'
                                }`}
                        >
                            {GROUP_CONFIG[g].title}
                        </button>
                    ))}
                </div>

                <div className="relative flex-1 min-w-[200px] max-w-xs">
                    <i className="fa-solid fa-search absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
                    <input
                        type="text"
                        className="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none text-sm"
                        placeholder="Tìm nhân viên..."
                        value={searchTerm}
                        onChange={e => setSearchTerm(e.target.value)}
                    />
                </div>

                <label className="flex items-center gap-2 text-sm text-gray-600 cursor-pointer select-none">
                    <input
                        type="checkbox"
                        className="rounded border-gray-300 text-blue-600 focus:ring-blue-500"
                        checked={showAllRoles}
                        onChange={e => setShowAllRoles(e.target.checked)}
                    />
                    Hiện cả NVKD &amp; Khách
                </label>

                <span className="text-sm text-gray-400 ml-auto">
                    {visibleEmployees.length} nhân viên
                </span>
            </div>

            {/* Chú thích màu */}
            <div className="px-6 py-2 bg-gray-50 border-b border-gray-100 text-xs text-gray-500 flex gap-5 flex-wrap flex-shrink-0">
                <span className="flex items-center gap-1.5">
                    <span className="inline-block w-3 h-3 rounded-sm border border-amber-400 bg-amber-50"></span>
                    Chưa cấu hình (tính thưởng hiểu là 0)
                </span>
                <span className="flex items-center gap-1.5">
                    <span className="inline-block w-3 h-3 rounded-sm border border-blue-500 bg-blue-50"></span>
                    Đã sửa, chưa lưu
                </span>
                <span>Bấm tiêu đề cột để xếp theo % của khâu đó.</span>
                {!showAllRoles && (
                    <span className="italic">
                        Đang ẩn NVKD &amp; Khách — họ không ăn hoa hồng sản xuất, mà hưởng theo bậc doanh số riêng.
                    </span>
                )}
            </div>

            {/* Bảng — CHỈ tấm thẻ trắng được cuộn (cả dọc lẫn ngang).
                Đừng thêm overflow ở thẻ bọc ngoài: 2 vùng cuộn lồng nhau sẽ làm
                sticky bám nhầm vùng và tiêu đề trôi mất. */}
            <div className="flex-1 min-h-0 p-4 bg-gray-50">
                <div className="h-full bg-white rounded-lg shadow border border-gray-200 overflow-auto">
                    <table className="w-full text-sm text-left">
                        {/* sticky đặt trên từng <th>, không đặt trên <thead>: mỗi ô phải tự
                            có nền, nếu không các dòng dữ liệu sẽ cuộn xuyên qua. Dùng
                            inset shadow thay border vì border-collapse:collapse không vẽ
                            viền cho ô sticky. */}
                        <thead className="text-gray-700 font-semibold">
                            <tr>
                                <th className={`${HEAD_CELL} px-4 py-3 min-w-[220px] bg-gray-100`}>Nhân viên</th>
                                <th
                                    className={`${HEAD_CELL} px-3 py-3 text-center w-20 bg-gray-100`}
                                    title="Điểm năng lực — nhân vào hoa hồng công việc chính"
                                >
                                    Điểm NL
                                </th>
                                {fields.map(f => {
                                    const active = sortKey === f.key;
                                    return (
                                        <th
                                            key={f.key}
                                            onClick={() => toggleSort(f.key)}
                                            title={`${f.label} — bấm để xếp theo cột này`}
                                            className={`${HEAD_CELL} px-2 py-3 text-center min-w-[96px] cursor-pointer select-none transition-colors ${active ? 'bg-blue-100 text-blue-800' : 'bg-gray-100 hover:bg-gray-200'
                                                }`}
                                        >
                                            {f.shortLabel}
                                            {active && (
                                                <i className={`fa-solid ${sortDesc ? 'fa-arrow-down' : 'fa-arrow-up'} ml-1 text-xs`}></i>
                                            )}
                                        </th>
                                    );
                                })}
                            </tr>
                        </thead>
                        <tbody className="divide-y divide-gray-100">
                            {visibleEmployees.length === 0 ? (
                                <tr>
                                    <td colSpan={fields.length + 2} className="p-8 text-center text-gray-500">
                                        Không tìm thấy nhân viên nào
                                    </td>
                                </tr>
                            ) : (
                                visibleEmployees.map(emp => (
                                    <tr key={emp.id} className="hover:bg-blue-50/40 transition-colors">
                                        <td className="px-4 py-2">
                                            <div className="font-bold text-gray-800">{emp.full_name || emp.email}</div>
                                            <div className="text-xs text-gray-500">
                                                {ROLE_LABELS[emp.role || ''] || emp.role}
                                                {emp.is_locked && (
                                                    <span className="ml-2 inline-flex items-center px-1.5 py-0.5 rounded text-[10px] font-medium bg-red-100 text-red-800">
                                                        <i className="fa-solid fa-lock mr-1"></i>Đã khóa
                                                    </span>
                                                )}
                                            </div>
                                        </td>
                                        <td className="px-3 py-2 text-center">
                                            <span className="px-2 py-1 bg-green-100 text-green-700 rounded-md font-bold text-xs">
                                                {emp.competency_score || 0}
                                            </span>
                                        </td>
                                        {fields.map(f => {
                                            const unset = isRateUnset(emp[field], f.key);
                                            const dirty = isDirtyCell(emp, f.key);
                                            return (
                                                <td key={f.key} className="px-2 py-2 text-center">
                                                    <input
                                                        type="number"
                                                        step="0.1"
                                                        value={currentValue(emp, f.key)}
                                                        onChange={e => handleChange(emp, f.key, e.target.value)}
                                                        title={
                                                            dirty ? 'Đã sửa, chưa lưu'
                                                                : unset ? 'Chưa cấu hình — tính thưởng hiểu là 0'
                                                                    : undefined
                                                        }
                                                        className={`w-20 border rounded px-2 py-1 text-right font-mono font-bold outline-none focus:ring-1 focus:ring-blue-500 ${dirty
                                                            ? 'border-blue-500 bg-blue-50 text-blue-800'
                                                            : unset
                                                                ? 'border-amber-400 bg-amber-50'
                                                                : 'border-gray-300'
                                                            }`}
                                                    />
                                                </td>
                                            );
                                        })}
                                    </tr>
                                ))
                            )}
                        </tbody>
                        {visibleEmployees.length > 0 && (
                            <tfoot className="text-xs">
                                <tr>
                                    <td className={`${FOOT_CELL} ${FOOT_TOP_LINE} bottom-[64px] px-4 font-bold text-gray-600`} colSpan={2}>
                                        Thấp nhất – Cao nhất
                                    </td>
                                    {fields.map(f => (
                                        <td key={f.key} className={`${FOOT_CELL} ${FOOT_TOP_LINE} bottom-[64px] px-2 text-center font-mono text-gray-700`}>
                                            {fmt(columnStats[f.key].min)} – {fmt(columnStats[f.key].max)}
                                        </td>
                                    ))}
                                </tr>
                                <tr>
                                    <td className={`${FOOT_CELL} bottom-[32px] px-4 font-bold text-gray-600`} colSpan={2}>
                                        Trung bình
                                    </td>
                                    {fields.map(f => (
                                        <td key={f.key} className={`${FOOT_CELL} bottom-[32px] px-2 text-center font-mono font-bold text-gray-800`}>
                                            {columnStats[f.key].avg.toFixed(2)}
                                        </td>
                                    ))}
                                </tr>
                                <tr>
                                    <td className={`${FOOT_CELL} bottom-0 px-4 font-bold text-gray-600`} colSpan={2}>
                                        Số người đang để 0
                                    </td>
                                    {fields.map(f => {
                                        const { zeros } = columnStats[f.key];
                                        return (
                                            <td
                                                key={f.key}
                                                className={`${FOOT_CELL} bottom-0 px-2 text-center font-mono ${zeros === visibleEmployees.length ? 'text-red-600 font-bold' : 'text-gray-500'
                                                    }`}
                                            >
                                                {zeros}/{visibleEmployees.length}
                                            </td>
                                        );
                                    })}
                                </tr>
                            </tfoot>
                        )}
                    </table>
                </div>
            </div>

            {/* Thanh lưu */}
            <div className="p-4 bg-gray-50 border-t flex justify-between items-center gap-3 flex-shrink-0">
                <span className={`text-sm ${dirtyCount > 0 ? 'text-blue-700 font-medium' : 'text-gray-400'}`}>
                    {dirtyCount > 0
                        ? `Đang sửa ${dirtyCount} nhân viên, chưa lưu`
                        : 'Chưa có thay đổi nào'}
                </span>
                <div className="flex gap-3">
                    <button
                        onClick={handleReset}
                        disabled={dirtyCount === 0 || saving}
                        className="px-4 py-2 text-gray-600 hover:bg-gray-200 rounded font-medium disabled:opacity-40 disabled:hover:bg-transparent"
                    >
                        Hoàn tác
                    </button>
                    <button
                        onClick={handleSave}
                        disabled={dirtyCount === 0 || saving}
                        className="px-6 py-2 bg-blue-600 text-white rounded font-bold hover:bg-blue-700 shadow-sm disabled:opacity-40 disabled:hover:bg-blue-600 flex items-center gap-2"
                    >
                        {saving && <i className="fa-solid fa-spinner fa-spin"></i>}
                        Lưu thay đổi
                    </button>
                </div>
            </div>
        </div>
    );
};

export default CommissionMatrix;
