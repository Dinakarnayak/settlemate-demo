# Personal beta security and privacy plan

## Product promise
Each tester has an independent account and private personal workspace. A user's profile, tasks, work shifts, spending records and preferences must never be visible or writable by another user. Cross-device sync is allowed only after sign-in and server-side authorization.

## Provisioned infrastructure (26 November 2026)
- Neon project: `settlemate-beta` (`divine-feather-82800549`), AWS London region.
- PostgreSQL 17, database `settlemate`, default branch `main`.
- Neon Auth is provisioned with Better Auth. Email/password sign-in and sign-up are enabled; email OTP verification is required on sign-up and sign-in, and sessions are revoked on password reset.
- Trusted web origin: `https://dinakarnayak.github.io`. Localhost is currently allowed for development and must be disabled before production.
- Neon Data API is active for the `settlemate` database, uses Neon Auth JWT verification and exposes only the `public` schema. CORS is restricted to the GitHub Pages origin.
- Auth and Data API URLs are recorded in `docs/neon-beta-setup.md`. No database password, server key or secret is stored in the repository.

## Database isolation
- Tables: `user_profiles`, `user_preferences`, `personal_tasks`, `work_shifts`, and `personal_transactions`.
- Every table has row-level security enabled and forced.
- Policies are scoped to the authenticated user's JWT subject using Neon Data API's `auth.user_id()`; the database derives the default owner id from that same verified subject.
- Data API access is granted to the built-in `authenticated` role only; no anonymous table grants are made.
- A non-login `settlemate_api` role exists for future backend work. It has no `BYPASSRLS` privilege.
- A database-level isolation probe passed using the restricted `settlemate_api` role: a second subject could not read or update the first subject's row, and a forged owner insert was rejected. Probe rows were deleted.

## Current release boundary
The PWA and Flutter starter have not yet been connected to this Auth/Data API. The live app still stores its prototype state in browser local storage. This infrastructure setup alone does not provide user sign-in UI, cloud sync, account deletion, data export or tested mobile sessions. Do not invite testers to enter real financial, immigration, identity, health or other sensitive information yet.

## Required beta gates
1. Integrate the official `@neondatabase/neon-js` client into the web app and connect sign-up, sign-in, session restore and sign-out.
2. Sync only the signed-in user's profile, tasks, shifts, spending and preferences through the Data API; never trust client-supplied owner IDs.
3. Add automated end-to-end tests with two real verified accounts covering read, insert, update and delete isolation.
4. Implement export and verified account deletion, including session revocation.
5. Disable localhost origins, configure a production email sender and review password reset and verification delivery.
6. Add rate limiting, input validation, secure headers, privacy notice, consent and support contact.
7. Build and test native clients, offline conflict handling and cross-device session flows.
8. Run independent security review before a public invitation.

## Trial policy
Use synthetic data during development. Keep sign-ups unavailable from any user-facing entry point until the client integration and cross-account tests are complete. Start with a small invited group after those gates pass.
