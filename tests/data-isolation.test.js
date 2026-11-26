import test from 'node:test';
import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';

const sql = await readFile(new URL('../backend/migrations/001_personal_data_rls.sql', import.meta.url), 'utf8');
const protectedTables = ['user_profiles', 'personal_tasks', 'work_shifts', 'personal_transactions', 'user_preferences'];

test('every personal data table is included in forced row-level security', () => {
  for (const table of protectedTables) assert.ok(sql.includes("'" + table + "'"), 'missing protected table ' + table);
  assert.match(sql, /ENABLE ROW LEVEL SECURITY/);
  assert.match(sql, /FORCE ROW LEVEL SECURITY/);
});

test('owner policy protects reads and writes', () => {
  assert.match(sql, /USING \(owner_id = app_private\.current_user_id\(\)\)/);
  assert.match(sql, /WITH CHECK \(owner_id = app_private\.current_user_id\(\)\)/);
  assert.match(sql, /current_setting\('request\.jwt\.claim\.sub', true\)/);
});

test('migration documents the trusted identity boundary', () => {
  assert.match(sql, /Never accept this subject from request JSON/);
  assert.match(sql, /must not have BYPASSRLS/);
});
