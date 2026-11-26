# Personal beta security and privacy plan

## Product promise
Each tester has an independent account and private personal workspace. A user's profile, tasks, work shifts, spending records and preferences must never be visible or writable by another user. Cross-device sync is allowed only after sign-in and server-side authorization.

## Current release boundary
The public web/PWA prototype currently stores sample/personal state in browser local storage. It does not provide authenticated accounts, cloud backup, multi-device sync, account deletion, or server-enforced user isolation. Do not ask beta testers to enter real financial, immigration, identity, health or other sensitive information until the controls below are implemented and independently tested.

## Architecture baseline
- Identity provider: Neon Auth, with email verification required for public beta; review provider configuration and trusted origins before enabling sign-ups.
- Database: PostgreSQL on Neon, with a separate development/staging environment before production.
- API: server-side only. Verify JWT signature, issuer, audience and expiry against the provider JWKS. Never trust a user ID supplied in a request body or URL.
- Data access: set the verified subject using transaction-local set_config('request.jwt.claim.sub', subject, true) and run every user-data query in that transaction.
- Database: migration backend/migrations/001_personal_data_rls.sql applies owner-based row-level security to each personal table. The runtime database role must not own the tables and must not have BYPASSRLS.
- Client: only public auth configuration may ship to browsers. Database URLs, service credentials, signing keys and SMTP secrets must remain server-side.
- Deletion: implement a verified account-deletion flow that removes all rows for the user and revokes sessions; document any legally required retention before launch.
- Export: provide a user-initiated export of their profile and personal records.
- Observability: never log access tokens, passwords, full financial records or sensitive free-text notes.

## Required beta gates
1. Create an isolated Neon project/environment and configure Neon Auth.
2. Configure email verification, password reset, allowed origins and production redirect URLs.
3. Apply the migration; create a least-privilege API database role that cannot bypass RLS.
4. Implement API middleware that verifies tokens and binds the verified subject to each DB transaction.
5. Add automated tests proving User A cannot read, update or delete User B's rows, including attempts to forge owner IDs.
6. Add rate limiting, input validation, CSRF/origin protections where applicable, secure headers and dependency scanning.
7. Add export, account deletion, privacy notice, consent and support contact.
8. Run independent security review and cross-device end-to-end tests before inviting real users.

## Test accounts and trial policy
Use synthetic data only during the initial trial. Start with a small invited group, collect feedback without collecting unnecessary personal data, and expand only after the isolation tests and deletion/export flows pass.
