import test from 'node:test';
import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';

const sql = await readFile(new URL('../backend/migrations/001_personal_data_rls.sql', import.meta.url), 'utf8');
const protectedTables = ['user_profiles', 'personal_tasks', 'work_shifts', 'personal_transactions', 'user_preferences'];

test('every personal table is included in forced row-level security', () => {
  for (const table of protectedTables) assert.ok(sql.includes("'" + table + "'"), 'missing protected table ' + table);
  assert.match(sql, /ENABLE ROW LEVEL SECURITY/);
  assert.match(sql, /FORCE ROW LEVEL SECURITY/);
});

test('policies use the verified Neon Auth subject for authenticated requests', () => {
  assert.match(sql, /auth\.user_id\(\)/);
  assert.match(sql, /FOR ALL TO authenticated, settlemate_api/);
  assert.match(sql, /USING \(owner_id = \(SELECT auth\.user_id\(\)\)\)/);
  assert.match(sql, /WITH CHECK \(owner_id = \(SELECT auth\.user_id\(\)\)\)/);
});

test('new rows default to the signed-in user's subject', () => {
  assert.match(sql, /owner_id text NOT NULL DEFAULT auth\.user_id\(\)/);
  assert.match(sql, /owner_id text PRIMARY KEY DEFAULT auth\.user_id\(\)/);
});

test('optional direct backend role cannot bypass RLS', () => {
  assert.match(sql, /NOLOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT NOBYPASSRLS/);
});
