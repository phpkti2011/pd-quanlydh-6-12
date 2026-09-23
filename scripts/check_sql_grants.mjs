#!/usr/bin/env node
/**
 * Kiểm tra file SQL: mọi CREATE TABLE phải có GRANT đi kèm.
 *
 * Lý do: từ 30/10/2026 Supabase không tự cấp quyền Data API cho bảng mới.
 * Thiếu GRANT -> phần mềm báo "permission denied". Xem CLAUDE.md và
 * _TEMPLATE_tao_bang_moi.sql.
 *
 * Cách dùng:
 *   node scripts/check_sql_grants.mjs a.sql b.sql   # kiểm tra file chỉ định
 *   (hook Claude Code, PostToolUse Write|Edit)      # đọc JSON từ stdin,
 *                                                   # lấy tool_input.file_path
 *
 * Thiếu GRANT: in ra stderr và thoát mã 2 — Claude Code coi mã 2 là lỗi chặn
 * và đưa nội dung stderr về cho AI sửa.
 *
 * LƯU Ý KHI SỬA FILE NÀY: chỉ dùng regex LITERAL dạng /.../, KHÔNG dựng regex
 * từ chuỗi có "\\". Lớp shell/công cụ ghi file có thể nuốt bớt dấu gạch chéo,
 * khiến "\s" thành "s" và regex hỏng âm thầm — đã xảy ra thật ở bản đầu.
 */
import { readFileSync } from 'node:fs';

/**
 * Xoá comment nhưng GIỮ NGUYÊN độ dài (thay bằng khoảng trắng), để vị trí ký
 * tự trong bản sạch khớp bản gốc. Cần vậy vì ghi chú "CỐ Ý KHÔNG GRANT" nằm
 * trong comment, phải tìm trên bản gốc; còn CREATE TABLE / GRANT thì phải tìm
 * trên bản sạch, kẻo chữ "create table for..." trong comment bị nhận nhầm.
 */
function blankComments(sql) {
  return sql
    .replace(/--[^\n]*/g, m => ' '.repeat(m.length))
    .replace(/\/\*[\s\S]*?\*\//g, m => m.replace(/[^\n]/g, ' '));
}

const CREATE_RE  = /CREATE\s+TABLE\s+(?:IF\s+NOT\s+EXISTS\s+)?(?:public\.)?"?([A-Za-z_][A-Za-z0-9_]*)"?/gi;
const GRANT_RE   = /GRANT\s+[^;]*?\bON\s+(?:TABLE\s+)?(?:public\.)?"?([A-Za-z_][A-Za-z0-9_]*)"?\s+TO\s+([^;]+)/gi;
const OPT_OUT_RE = /KH[ÔO]NG\s+GRANT/i;

function checkFile(path) {
  if (!/\.sql$/i.test(path)) return [];
  let sql;
  try { sql = readFileSync(path, 'utf8'); } catch { return []; }
  const clean = blankComments(sql);

  // Bảng nào đã GRANT cho authenticated (so tên không phân biệt hoa thường)
  const granted = new Set();
  for (const m of clean.matchAll(GRANT_RE)) {
    if (/\bauthenticated\b/i.test(m[2])) granted.add(m[1].toLowerCase());
  }

  const hits = [...clean.matchAll(CREATE_RE)];
  const missing = [];
  hits.forEach((m, i) => {
    const table = m[1];
    if (granted.has(table.toLowerCase())) return;
    // Đoạn của bảng này trên BẢN GỐC (còn comment) để tìm ghi chú cố ý bỏ GRANT
    const end = i + 1 < hits.length ? hits[i + 1].index : sql.length;
    if (OPT_OUT_RE.test(sql.slice(m.index, end))) return;
    missing.push(table);
  });
  return missing;
}

function filesFromArgsOrHook() {
  const args = process.argv.slice(2);
  if (args.length > 0) return args;
  // Chế độ hook: JSON từ stdin. Chạy tay trần (không pipe) thì bỏ qua, tránh treo.
  if (process.stdin.isTTY) return [];
  let raw = '';
  try { raw = readFileSync(0, 'utf8'); } catch { return []; }
  if (!raw.trim()) return [];
  try {
    const p = JSON.parse(raw)?.tool_input?.file_path;
    return p ? [p] : [];
  } catch { return []; }
}

const report = [];
for (const f of filesFromArgsOrHook()) {
  const missing = checkFile(f);
  if (missing.length) report.push({ f, missing });
}
if (report.length === 0) process.exit(0);

const lines = ['THIẾU GRANT cho bảng mới (Supabase không tự cấp quyền từ 30/10/2026):'];
for (const { f, missing } of report) {
  for (const t of missing) lines.push('  ' + f + ': CREATE TABLE ' + t + ' không có "GRANT ... ON ' + t + ' TO authenticated"');
}
lines.push('Sửa theo _TEMPLATE_tao_bang_moi.sql: GRANT cho authenticated + service_role.');
lines.push('Bảng chỉ SECURITY DEFINER dùng: thêm "-- CỐ Ý KHÔNG GRANT: <lý do>" ngay dưới CREATE TABLE.');
process.stderr.write(lines.join('\n') + '\n');
process.exit(2);
