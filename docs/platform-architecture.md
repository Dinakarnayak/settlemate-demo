# SettleMate platform architecture

## Product direction

SettleMate is one product with a shared experience across mobile, tablet, laptop and desktop. The current repository is a working HTML/CSS/JavaScript prototype with a PWA entry point and an early Flutter starter. This document defines a staged architecture; it does not claim that unconfigured cloud services, native binaries or AI providers are already connected.

## Experience layers

| Surface | Near-term delivery | Longer-term native option |
|---|---|---|
| Mobile | Installable PWA, responsive full-screen layout, offline shell | Flutter Android/iOS app |
| Tablet | Responsive two-column layouts and touch navigation | Flutter tablet layouts |
| Laptop / desktop | Wide workspace, persistent side navigation, keyboard shortcuts, installable desktop PWA | Optional Tauri 2 desktop wrapper |
| Web | Static deployable app with no mandatory build step | React/Next.js only when product complexity justifies migration |

## Architecture principles

1. **One domain model:** keep student profile, tasks, term dates, work logs, spending and safety checks independent of presentation.
2. **Offline-first:** local data remains usable without a network; future sync must be explicit, conflict-aware and recoverable.
3. **Progressive enhancement:** install prompts, keyboard shortcuts, notifications and device APIs are optional capabilities with graceful fallbacks.
4. **Privacy by default:** no sensitive student, visa, financial or identity data should be sent to analytics or AI services without clear consent and a documented purpose.
5. **Trustworthy guidance:** visa, employment and financial guidance must cite current official sources, show last-checked dates and avoid presenting estimates as legal advice.
6. **Accessible everywhere:** keyboard support, visible focus, reduced motion, semantic controls, sufficient contrast and touch targets.

## Proposed technology evolution

- **Current foundation:** semantic HTML, modern CSS, JavaScript modules, Web App Manifest, Service Worker, Node's built-in test runner.
- **Web product (when needed):** TypeScript + React with a framework such as Next.js; migrate feature-by-feature rather than rewriting the prototype.
- **Native mobile:** Flutter, sharing API contracts and domain rules with the web application.
- **Desktop packaging:** Tauri 2 only if desktop-specific integrations justify a native wrapper; otherwise use the installable PWA.
- **Backend:** a small TypeScript API (NestJS or Fastify) with PostgreSQL; add Redis/queues only for demonstrated workload.
- **Identity:** standards-based OAuth/OIDC and passkeys through a maintained identity provider; never implement password cryptography from scratch.
- **AI:** provider-agnostic model gateway, retrieval from approved sources, citations, evaluations, rate limits and human confirmation for consequential actions.
- **Operations:** GitHub Actions, dependency/security scanning, structured logs, OpenTelemetry and tested backups before production launch.

## Delivery stages

### Stage 1 — Cross-device foundation (this release)
- Responsive mobile/tablet/desktop shell.
- Installable PWA prompt where the browser supports it.
- Desktop keyboard shortcuts and reduced-motion support.
- Offline cache includes the cross-device enhancement assets.
- Architecture and quality gates documented.

### Stage 2 — Reliable personal data
- Versioned local schema and export/import.
- Encrypted authenticated sync only after threat modelling.
- Conflict resolution and account/device management.
- Automated accessibility and end-to-end tests.

### Stage 3 — Connected services
- Backend API, PostgreSQL, identity, audit trail and consent controls.
- Official-source update pipeline for compliance content.
- Notifications and calendar integrations with user permission.

### Stage 4 — AI and automation
- Retrieval-grounded assistant with source citations and freshness metadata.
- Document extraction with user review before saving.
- Optional agent workflows with explicit approvals for payments, messages, bookings or legal/visa-related actions.
- Evaluation suite, abuse controls and cost monitoring.

### Stage 5 — Native distribution
- Flutter mobile builds for iOS and Android.
- Desktop PWA validation first; Tauri wrapper only if needed.
- Store signing, privacy disclosures, crash reporting and release automation.

## Production readiness checklist

- [ ] Threat model and privacy impact assessment
- [ ] Authenticated sync and encryption design reviewed
- [ ] Backup/restore and account deletion tested
- [ ] Accessibility audit (WCAG 2.2 AA target)
- [ ] End-to-end tests on iOS Safari, Android Chrome, Windows, macOS and Linux
- [ ] Official guidance content reviewed and date-stamped
- [ ] AI safety, citation and evaluation gates
- [ ] Incident response, monitoring and dependency patch process
