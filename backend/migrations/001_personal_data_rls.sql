-- SettleMate personal beta schema.
-- Prerequisite: Neon Auth and Neon Data API must be provisioned for this database.
-- Neon Auth issues JWTs with sub=user id and role=authenticated. The Data API
-- validates them and auth.user_id() reads the verified subject. Never accept
-- owner_id from a client as authority; RLS checks every insert and query.

CREATE TABLE IF NOT EXISTS public.user_profiles (
  owner_id text PRIMARY KEY DEFAULT auth.user_id(),
  display_name text NOT NULL DEFAULT '',
  home_country char(2),
  preferred_currency char(3),
  timezone text NOT NULL DEFAULT 'Europe/London',
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.personal_tasks (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_id text NOT NULL DEFAULT auth.user_id(),
  title text NOT NULL CHECK (char_length(title) BETWEEN 1 AND 160),
  notes text NOT NULL DEFAULT '' CHECK (char_length(notes) <= 2000),
  due_at timestamptz,
  completed_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS personal_tasks_owner_due_idx
  ON public.personal_tasks (owner_id, due_at);

CREATE TABLE IF NOT EXISTS public.work_shifts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_id text NOT NULL DEFAULT auth.user_id(),
  employer_label text NOT NULL DEFAULT '' CHECK (char_length(employer_label) <= 120),
  starts_at timestamptz NOT NULL,
  ends_at timestamptz NOT NULL,
  unpaid_break_minutes integer NOT NULL DEFAULT 0 CHECK (unpaid_break_minutes BETWEEN 0 AND 1440),
  created_at timestamptz NOT NULL DEFAULT now(),
  CHECK (ends_at > starts_at)
);
CREATE INDEX IF NOT EXISTS work_shifts_owner_start_idx
  ON public.work_shifts (owner_id, starts_at DESC);

CREATE TABLE IF NOT EXISTS public.personal_transactions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_id text NOT NULL DEFAULT auth.user_id(),
  label text NOT NULL CHECK (char_length(label) BETWEEN 1 AND 160),
  category text NOT NULL DEFAULT 'other' CHECK (char_length(category) <= 60),
  amount_minor bigint NOT NULL CHECK (amount_minor >= 0),
  currency char(3) NOT NULL,
  occurred_at timestamptz NOT NULL DEFAULT now(),
  created_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS personal_transactions_owner_date_idx
  ON public.personal_transactions (owner_id, occurred_at DESC);

CREATE TABLE IF NOT EXISTS public.user_preferences (
  owner_id text PRIMARY KEY DEFAULT auth.user_id(),
  preferences jsonb NOT NULL DEFAULT '{}'::jsonb
    CHECK (jsonb_typeof(preferences) = 'object'),
  updated_at timestamptz NOT NULL DEFAULT now()
);

-- Optional non-login role for a future direct-Postgres backend. The browser
-- Data API uses Neon Auth's built-in authenticated role instead.
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'settlemate_api') THEN
    CREATE ROLE settlemate_api NOLOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT NOBYPASSRLS;
  END IF;
END
$$;

GRANT USAGE ON SCHEMA public, auth TO authenticated, settlemate_api;
GRANT EXECUTE ON FUNCTION auth.user_id() TO authenticated, settlemate_api;
GRANT SELECT, INSERT, UPDATE, DELETE ON
  public.user_profiles,
  public.personal_tasks,
  public.work_shifts,
  public.personal_transactions,
  public.user_preferences
TO authenticated, settlemate_api;

DO $$
DECLARE table_name text;
BEGIN
  FOREACH table_name IN ARRAY ARRAY[
    'user_profiles',
    'personal_tasks',
    'work_shifts',
    'personal_transactions',
    'user_preferences'
  ]
  LOOP
    EXECUTE format('ALTER TABLE public.%I ENABLE ROW LEVEL SECURITY', table_name);
    EXECUTE format('ALTER TABLE public.%I FORCE ROW LEVEL SECURITY', table_name);
    EXECUTE format('DROP POLICY IF EXISTS personal_owner_isolation ON public.%I', table_name);
    EXECUTE format(
      'CREATE POLICY personal_owner_isolation ON public.%I
       FOR ALL TO authenticated, settlemate_api
       USING (owner_id = (SELECT auth.user_id()))
       WITH CHECK (owner_id = (SELECT auth.user_id()))',
      table_name
    );
  END LOOP;
END
$$;
