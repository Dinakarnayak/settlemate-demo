# Landed: clickable demo

An all-in-one daily-life app for international students in the UK. This repository holds a clickable front-end prototype.

**Live demo:** https://dinakarnayak.github.io/settlemate-demo/

**Installable app:** https://dinakarnayak.github.io/settlemate-demo/app/ (open it on your phone, then choose *Add to Home Screen*)

## What's in the demo

- **Welcome tour:** pick your name and home country from 50+ countries (searchable)
- **Feels like home:** greeting in your home language, UK and home clocks, money shown in your currency, plus food, community and embassy links for your country
- **Today:** a student's day planner with lectures, a cheap lunch, a study block, shifts, how much you can spend today, and deadline countdowns
- **Term dates:** uses the University of Leicester's published postgraduate dates to show the term, week number and next vacation, and whether your term-time work limit applies. 2026/27 is marked as estimated until the University publishes it.
- **Arrival checklist:** SIM, bank, eVisa/share code, scams, GP, NI number, council tax, Railcard, with XP rewards
- **Work hours:** shift log, weekly limit ring, vacation detection from term dates
- **Money:** budget, quick add, spending chart, converter to your home currency
- **Safe (Scam Shield):** paste any message to check for scam signs, five golden rules, common scams targeting international students, and where to report (Report Fraud, 7726, report@phishing.gov.uk, your bank, your university, your embassy)
- **Discover:** verified deals, events, community groups and a "home away from home" section
- **Account:** ride-app style profile with Help, Wallet and Term dates tiles, safety and visa check-ups, personal info, emergency contact and settings
- **Assistant:** answers common questions and links to the official page

## Startup plan

The full business plan (problem, market, business model, roadmap and visa considerations) is in [docs/startup-plan.md](docs/startup-plan.md).

## What's in this repo

| Folder | What it is |
|---|---|
| `index.html` | Clickable demo inside a phone frame, for showing people |
| `app/` | The same design as an installable phone app (PWA): full screen, app icon, works offline |
| `flutter/` | Flutter starter for Android and iOS with the same design (see `flutter/README.md`) |
| `docs/startup-plan.md` | The startup plan |

## Links to other apps and sites

For now, every card and link opens a trusted outside service instead of a built-in feature:

| In the app | Opens |
|---|---|
| Arrival tasks ("Open guide") | gov.uk (eVisa, NI number, council tax), NHS Find a GP, 16–25 Railcard, MoneyHelper |
| Deals and grocery stores | Google Maps, or the provider's website |
| Events | Eventbrite / web search |
| Community groups ("Find online") | Facebook group search |
| Work tab | Student visa rules on gov.uk |
| Money tab | MoneyHelper guides, transfer-fee comparison search |
| Safe tab | Report Fraud, UKCISA scam guide, your embassy |
| Home away from home | Google Maps food search, Facebook groups, embassy search, live exchange rate |
| Assistant answers | The matching official page, or a web search |

The Flutter app opens the same links with `url_launcher`. (The Flutter starter doesn't have the newest features yet: the welcome tour, Scam Shield, term dates, Today plan and account page.)

## Cross-device experience

SettleMate now adapts its layout to the device:
- **Phone:** full-screen, touch-first app with safe-area spacing.
- **Tablet:** wider cards and a comfortable touch layout.
- **Laptop / desktop:** a wide workspace with a persistent side navigation, keyboard shortcuts and an installable PWA where supported.

On desktop, use **Alt+1–6** to switch the six primary tabs, **Ctrl/Cmd+K** to open the assistant, and **Esc** to close it. Browsers that support PWA installation show an **Install app** action when installation is available.

The same app remains available in the browser; no separate account or duplicate data store is created by changing screen size.

## Tech

The current web app is plain HTML, CSS and JavaScript with no build step. It uses a Web App Manifest, Service Worker, responsive CSS and progressive browser capabilities. Progress is saved in the browser's `localStorage`. Open `index.html` or `app/index.html` in a browser to run them locally.

The staged technology roadmap is documented in [docs/platform-architecture.md](docs/platform-architecture.md). Native Flutter builds, backend services, authenticated sync and live AI integrations remain future stages and are not represented as active services today.

### Install the app on your phone

1. Open https://dinakarnayak.github.io/settlemate-demo/app/ on your phone.
2. **Android (Chrome):** menu ⋮ → *Install app* / *Add to Home screen*.
3. **iPhone (Safari):** Share → *Add to Home Screen*.

It then opens full screen from its own icon, like a normal app.

## Private personal beta (in progress)

The next release is designed for **independent personal accounts**: every tester will have a private profile, tasks, work shifts, spending records and preferences, with secure sync across their own devices.

The first backend foundation is being developed on a separate feature branch:
- PostgreSQL schema for personal records.
- Row-level security policies that fail closed without a verified user subject.
- Security and launch checklist for authentication, verified API sessions, export, deletion and cross-user isolation tests.

**This is not enabled in the live demo yet.** The current public PWA remains a browser-local prototype. Do not enter real financial, immigration, identity or other sensitive information. Account sign-up, cloud sync, native app builds and public beta access will be enabled only after the backend, email verification, security tests and release checks are complete. See [docs/beta-security.md](docs/beta-security.md).

## Private personal beta infrastructure

A dedicated Neon project, Neon Auth and the Neon Data API have now been provisioned. The database has per-user tables and forced row-level security. See [the non-secret environment configuration](docs/neon-beta-setup.md) and [the security plan](docs/beta-security.md).

**Important:** the live PWA and Flutter starter are not yet connected to sign-in or cloud sync. The app remains a local prototype; do not enter sensitive information or invite external testers until the client integration, export/deletion flows and two-account end-to-end isolation tests are complete.

## Note

This is a prototype with sample data. Rules shown are simplified and are not legal advice. Always check your own visa conditions on gov.uk.

## Author

Dinakar Nayak N · [GitHub](https://github.com/Dinakarnayak) · [LinkedIn](https://linkedin.com/in/dinakar-nayak-n)
