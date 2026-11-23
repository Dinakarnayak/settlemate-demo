# Startup Plan: Daily-Life App for International Students in the UK

*Dinakar Nayak N · November 2026*

## 1. Summary

**Working name:** SettleMate (placeholder, so check trademarks before using it)

**What it is:** One mobile app that helps international students with everyday life in the UK: arrival tasks, visa and work-hour rules, budgeting in GBP, cheaper groceries and money transfers, housing, and finding people from their own community.

**Why now:** About 686,000 international students were enrolled at UK universities in 2024/25, which is 24% of all students. Most of them handle the same problems with scattered WhatsApp groups, Google searches and trial and error.

**Where to start:** A pilot at the University of Leicester and other universities in the city, then other UK university cities.

## 2. Read first: visa rules for founders

- **On a Student visa you cannot run a business.** Student visa holders are not allowed to be self-employed, freelance, trade online or engage in business activity. That includes setting up a company or earning money from the app.
- **What you *can* usually do while studying:** research the idea, plan it, use your university's enterprise and start-up support, and build skills or prototypes as coursework or a portfolio project. Don't charge users, sell ads or sign commercial deals.
- **Routes that allow a business:**
  - **Graduate visa** (after your MSc): self-employment is allowed. Check the current length of the route on gov.uk.
  - **Innovator Founder visa**: needs an endorsement from an approved body for a new, innovative business.
- **Action:** Book a session with the university's international student advice team and the enterprise/start-up team. Ask exactly which activities are safe before you build anything public.

> The whole plan is phased around this: **validate and prototype now, then launch commercially after graduation.**

## 3. The problem

| Area | Typical pain |
|---|---|
| Arrival | Bank account, GP registration, NI number, eVisa/share code, SIM, council tax exemption: confusing order and deadlines |
| Work rules | Students must stay within their weekly term-time hour limit. Tracking shifts across jobs is manual and risky |
| Money | Budgeting in GBP, high living costs, expensive transfers home, finding student discounts |
| Food | Finding affordable home-country groceries and cheap meals nearby |
| Housing | Scams, deposits, finding flatmates, knowing tenant rights |
| Belonging | Loneliness, finding people from the same country, language or interests |
| Deadlines | Visa expiry, tuition instalments, attendance rules, assignment load |

## 4. The product

### All-in-one app: the full picture

SettleMate is **one app for everything an international student needs day to day**. The home screen shows today's tasks, this week's work hours, money left this month and nearby deals. Every module sits behind one login and one profile (university, city and home country).

| Module | What it does inside the app |
|---|---|
| Arrival & visa | Arrival checklist, eVisa/share code guide, reminders before your visa expires, attendance rules |
| Work | Tracker for your weekly hour limit across several jobs, visa-friendly part-time job board, payslip and NI number help |
| Money | GBP budget, bill reminders, comparison of transfers home, banking guide |
| Food & deals | Student discounts, cheap meals, map of home-country grocery stores, recipes on a budget |
| Housing | Verified listings, flatmate finder, scam alerts, deposit and tenant-rights guide |
| Transport | Railcard and bus pass guide, journey costs, cheapest routes home for holidays |
| Health | GP registration steps, NHS 111 and pharmacy guide, wellbeing contacts |
| Study | Deadline calendar, timetable sync, links to university support services |
| Community | Groups by university and country, events, buy/sell marketplace, buddy matching |
| Emergency | Emergency numbers, embassy contacts, lost-document steps |
| AI assistant | Answers "how do I…" questions about every module, with links to official sources |
| After graduation | Graduate visa steps, CV help, job search, guide to starting a business |

**How to build it:** the app is designed as all-in-one from day one, but you release it in stages. The MVP ships the five modules students use most. The rest are switched on one release at a time, inside the same app.

### MVP (version 1)

1. **Arrival checklist** with reminders, personalised by city and university
2. **Work-hours tracker** with warnings before you go over your visa's weekly limit
3. **Budget tracker** in GBP with categories and a city cost-of-living guide
4. **Deals and food map** added by the community
5. **Community groups** by university and home country, with buy/sell

The clickable demo in this repo (`index.html`) shows the MVP.

## 5. Target users and market

- **Primary users:** new international students in their first 3 months in the UK.
- **Secondary users:** existing international students and graduates moving onto the Graduate route.
- **Market size:** about 686,000 international students in UK higher education (2024/25). Numbers fell 6% that year. India is still the biggest source country, and Nepal is growing fast.
- **Watch-out:** a shrinking market means you have to win on usefulness and retention, not just volume.

## 6. Competitors

| Type | Examples | Gap you fill |
|---|---|---|
| Student discounts | UNiDAYS, Student Beans | Discounts only, not built for international students |
| Money transfers | Wise, Remitly | Money only |
| University apps | Each uni's own app | Only cover academic life, differ by uni |
| Informal | WhatsApp, Facebook, Telegram groups | Messy, scams, no tools |

## 7. Business model (after graduation)

The app stays free for students. Revenue comes from:

1. **Affiliate/referral fees:** banks, SIM providers, money-transfer services, insurance, student housing
2. **Local business listings:** grocery stores and restaurants pay to be featured
3. **University partnerships:** a branded onboarding module for each university's international intake
4. **Premium (optional):** advanced budgeting and the AI assistant for about £2–3/month

Don't take payments or move money through the app yourself. That needs FCA regulation.

## 8. Go-to-market

- **Pilot city:** Leicester
- **Channels:** international student societies, Welcome Week stalls, WhatsApp and Instagram communities, student ambassadors from each nationality
- **Timing:** launch features before the January and September intakes
- **Growth:** invite-your-flatmates referrals, then expand city by city

## 9. Tech stack

- **App:** Flutter or React Native
- **Backend:** Firebase or Supabase
- **Maps:** Google Maps or Mapbox
- **AI assistant:** an LLM API with retrieval over gov.uk and university guidance
- **Privacy:** GDPR-compliant, minimal data, never store visa documents or passport numbers

## 10. Roadmap

| Phase | When | Goal | Activities (visa-safe) |
|---|---|---|---|
| 0. Research | Now – Mar 2027 | Prove the problem | 30+ student interviews, surveys, competitor review |
| 1. Prototype | Mar – Dec 2027 | Prove the solution | Figma mockups, non-commercial prototype, usability tests |
| 2. Pre-launch | Final MSc months | Get ready | Brand, legal checks, apply for Graduate or Innovator Founder visa |
| 3. Launch | After visa switch (late 2028) | First 1,000 users | Register company, publish app, Leicester pilot |
| 4. Scale | 2029+ | 5+ cities, revenue | University partnerships, premium tier, funding |

## 11. Starting budget (rough)

| Item | Cost |
|---|---|
| Apple developer account | ~£80/year |
| Google Play developer account | ~£20 one-off |
| Domain and email | ~£20–50/year |
| Firebase/Supabase | Free tier at the start |
| Company registration (after the visa switch) | ~£50 |
| Marketing | £200–500 |
| **Total to launch** | **about £400–700** |

## 12. Key metrics

- Weekly active users and 30-day retention (target: 40% or more)
- Checklist tasks completed per new arrival
- Community posts and deals added by users
- Referral rate
- Later: revenue per user and number of university partners

## 13. Risks

| Risk | Mitigation |
|---|---|
| Breaching Student visa conditions | Don't trade until you're on the right visa, and get written advice from the university |
| Wrong visa or work-hour info in the app | Link every rule to gov.uk, review monthly, add a clear disclaimer |
| Low retention | Recurring features: budget, work hours, community, deals |
| Big players copy the idea | Win on community and the international-student focus |
| Falling student numbers | Expand to graduates and other newcomers |

## 14. Next 30 days

1. Book the university's international advice and enterprise teams
2. Get 50+ survey responses from international students in Leicester
3. Interview 10 students about their top 3 pain points
4. Test this clickable demo with them and note feedback
5. Check name, domain and trademark availability
