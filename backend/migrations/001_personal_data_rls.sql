-- SettleMate personal beta: user-owned data with PostgreSQL row-level security.
-- The API MUST verify bearer-token signature, issuer, audience and expiry, then set
-- the verified subject for each transaction with:
-- SELECT set_config('request.jwt.claim.sub', $1, true);
-- Never accept this subject from request JSON, query params, or an unverified JWT.
-- Run application queries inside the same transaction. The API DB role must not own
-- these tables and must not have BYPASSRLS.

CREATE SCHEMA IF NOT EXISTS app_private;
CREATE OR REPLACE FUNCTION app_private.current_user_id()
RETURNS text LANGUAGE sql STABLE PARALLEL SAFE
AS $$ SELECT NULLIF(current_setting('request.jwt.claim.sub', true), '') $$;

CREATE TABLE IF NOT EXISTS public.user_profiles (
  owner_id text PRIMARY KEY,
  display_name text NOT NULL DEFAULT '',
  home_country char(2),
  preferred_currency char(3),
  timezone text NOT NULL DEFAULT 'Europe/London',
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE TABLE IF NOT EXISTS public.personal_tasks (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_id text NOT NULL,
  title text NOT NULL CHECK (char_length(title) BETWEEN 1 AND 160),
  notes text NOT NULL DEFAULT '' CHECK (char_length(notes) <= 2000),
  due_at timestamptz,
  completed_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS personal_tasks_owner_due_idx ON public.personal_tasks (owner_id, due_at);

CREATE TABLE IF NOT EXISTS public.work_shifts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_id text NOT NULL,
  employer_label text NOT NULL DEFAULT '' CHECK (char_length(employer_label) <= 120),
  starts_at timestamptz NOT NULL,
  ends_at timestamptz NOT NULL,
  unpaid_break_minutes integer NOT NULL DEFAULT 0 CHECK (unpaid_break_minutes BETWEEN 0 AND 1440),
  created_at timestamptz NOT NULL DEFAULT now(),
  CHECK (ends_at > starts_at)
);
CREATE INDEX IF NOT EXISTS work_shifts_owner_start_idx ON public.work_shifts (owner_id, starts_at DESC);

CREATE TABLE IF NOT EXISTS public.personal_transactions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_id text NOT NULL,
  label text NOT NULL CHECK (char_length(label) BETWEEN 1 AND 160),
  category text NOT NULL DEFAULT 'other' CHECK (char_length(category) <= 60),
  amount_minor bigint NOT NULL CHECK (amount_minor >= 0),
  currency char(3) NOT NULL,
  occurred_at timestamptz NOT NULL DEFAULT now(),
  created_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS personal_transactions_owner_date_idx ON public.personal_transactions (owner_id, occurred_at DESC);

CREATE TABLE IF NOT EXISTS public.user_preferences (
  owner_id text PRIMARY KEY,
  preferences jsonb NOT NULL DEFAULT '{}'::jsonb CHECK (jsonb_typeof(preferences) = 'object'),
  updated_at timestamptz NOT NULL DEFAULT now()
);

-- Enforce ownership even when a query accidentally omits an owner filter.
DO $$
DECLARE table_name text;
BEGIN
  FOREACH table_name IN ARRAY ARRAY[
    'user_profiles', 'personal_tasks', 'work_shifts',
    'personal_transactions', 'user_preferences'
  ]
  LOOP
    EXECUTE format('ALTER TABLE public.%I ENABLE ROW LEVEL SECURITY', table_name);
    EXECUTE format('ALTER TABLE public.%I FORCE ROW LEVEL SECURITY', table_name);
    EXECUTE format('DROP POLICY IF EXISTS personal_owner_isolation ON public.%I', table_name);
    EXECUTE format(
      'CREATE POLICY personal_owner_isolation ON public.%I
       USING (owner_id = app_private.current_user_id())
       WITH CHECK (owner_id = app_private.current_user_id())',
      table_name
    );
  END LOOP;
END
$$;

-- Deliberately no grants, auth-provider foreign keys, or production credentials here.
-- Provision a least-privilege runtime role and verify provider JWT claims before rollout.
