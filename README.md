# SettleMate: clickable demo

An all-in-one daily-life app for international students in the UK. This repository holds a clickable front-end prototype.

**Live demo:** https://dinakarnayak.github.io/settlemate-demo/

**Installable app:** https://dinakarnayak.github.io/settlemate-demo/app/ (open it on your phone, then choose *Add to Home Screen*)

## What's in the demo

- **Home:** next arrival task, weekly work hours, money left this month, events and deals nearby
- **Arrival checklist:** SIM, bank, eVisa/share code, GP, NI number, council tax, Railcard. Ticking tasks earns XP.
- **Work hours tracker:** log shifts and get warnings before you reach your weekly term-time limit
- **Money:** monthly budget, one-tap quick add, spending by category
- **Discover:** student deals, home-country groceries, events and community groups
- **Assistant:** a scripted chat for common "how do I…" questions about UK life

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
| Assistant answers | The matching official page, or a web search |

The Flutter app opens the same links with `url_launcher`.

## Tech

The web demo and app are plain HTML, CSS and JavaScript with no build step. Progress is saved in the browser's `localStorage`. Open `index.html` or `app/index.html` in a browser to run them locally.

### Install the app on your phone

1. Open https://dinakarnayak.github.io/settlemate-demo/app/ on your phone.
2. **Android (Chrome):** menu ⋮ → *Install app* / *Add to Home screen*.
3. **iPhone (Safari):** Share → *Add to Home Screen*.

It then opens full screen from its own icon, like a normal app.

## Note

This is a prototype with sample data. Rules shown are simplified and are not legal advice. Always check your own visa conditions on gov.uk.

## Author

Dinakar Nayak N · [GitHub](https://github.com/Dinakarnayak) · [LinkedIn](https://linkedin.com/in/dinakar-nayak-n)
