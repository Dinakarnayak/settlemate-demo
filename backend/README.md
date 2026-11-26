# Private beta backend foundation

This directory contains the first database migration for independent SettleMate accounts.

## Migration

Apply migrations in order in a dedicated development/staging Neon project. The first migration creates:

- One profile and preferences record per authenticated subject.
- User-owned task, work-shift and spending records.
- PostgreSQL row-level security (RLS) policies on every personal-data table.

The policies use the transaction-local subject set by the trusted API. They intentionally fail closed when the subject is absent. Do not connect a browser directly to the database.

## API contract the server must enforce

For every request:

1. Validate the access token signature using the identity provider JWKS.
2. Validate issuer, audience, expiry and required claims.
3. Begin a database transaction.
4. Set the verified token subject with a parameterised call to set_config('request.jwt.claim.sub', subject, true).
5. Execute all personal-data queries in that transaction.
6. Commit or roll back, then release the connection.

Never accept owner_id from the client as an authority. The server derives it from the verified token. Keep the API database role separate from the migration owner and do not grant BYPASSRLS.

## Not live yet

No Neon project, Neon Auth tenant, API server, runtime database credentials, email sender or cloud sync endpoint is provisioned by this repository change. Do not describe the app as multi-user or production-secure until those components and cross-user integration tests are deployed and verified.

See [the beta security plan](../docs/beta-security.md).
