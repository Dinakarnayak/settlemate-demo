# Neon beta environment (non-secret configuration)

Created 26 November 2026 for SettleMate's private personal beta.

| Setting | Value |
|---|---|
| Project | `settlemate-beta` |
| Project ID | `divine-feather-82800549` |
| Region | AWS London (`eu-west-2`) |
| PostgreSQL | 17 |
| Database | `settlemate` |
| Branch | `main` (`br-rapid-bread-bjonfd2d`) |
| Auth provider | Neon Auth / Better Auth |
| Auth URL | `https://ep-broad-waterfall-bj83bv8g.neonauth.c-3.eu-west-2.aws.neon.tech/settlemate/auth` |
| JWKS URL | `https://ep-broad-waterfall-bj83bv8g.neonauth.c-3.eu-west-2.aws.neon.tech/settlemate/auth/.well-known/jwks.json` |
| Data API URL | `https://ep-broad-waterfall-bj83bv8g.apirest.c-3.eu-west-2.aws.neon.tech/settlemate/rest/v1` |
| Allowed browser origin | `https://dinakarnayak.github.io` |

## Auth settings
Email/password sign-in is enabled, but new sign-ups are deliberately disabled until the app's account UI and beta invite flow are ready. Email OTP verification is required on sign-in. Password reset revokes sessions. The shared Neon email sender is currently configured as `auth@mail.myneon.app`; test delivery and configure a branded production sender before inviting external testers.

Localhost is currently permitted for development. Disable it before production.

## Data API
The Data API is active, validates Neon Auth JWTs using the JWKS URL above, exposes only the `public` schema, has a 1,000-row response cap, and restricts CORS to the GitHub Pages origin. OpenAPI exposure is disabled. Anonymous users have no grants.

## Safe client configuration
These two service URLs are public client configuration, not passwords. They may be used as build-time variables:

```env
VITE_NEON_AUTH_URL=https://ep-broad-waterfall-bj83bv8g.neonauth.c-3.eu-west-2.aws.neon.tech/settlemate/auth
VITE_NEON_DATA_API_URL=https://ep-broad-waterfall-bj83bv8g.apirest.c-3.eu-west-2.aws.neon.tech/settlemate/rest/v1
```

Never commit a PostgreSQL connection string, database password, auth server key, SMTP password or private signing key. The browser must use the official Neon SDK and JWT-backed Data API, never a privileged owner connection.

## Cost and resource note
The project and compute have been created in the connected Neon account. Billing and remaining free-tier allowance are account-specific; check the Neon console's Usage/Billing page before inviting testers or increasing compute limits.
