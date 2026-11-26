# Landed Android app

Native Flutter Android client for Landed (formerly SettleMate). The screens currently provide a visual/product prototype with sample in-memory data.

## Build an Android APK

Install Flutter 3.27 or newer and the Android SDK, then run:

```bash
cd flutter
flutter create --platforms=android --org com.dinakarnayak --project-name landed .
python3 ../.github/scripts/prepare-android.py
flutter pub get
flutter analyze
flutter test
flutter build apk --release
```

The APK is created at `build/app/outputs/flutter-apk/app-release.apk`. One-time signing and sign-in setup: see [`../docs/android-setup.md`](../docs/android-setup.md).

## Automated free build

Every push to `feat/settlemate-android-apk` runs the Android build workflow: tests, then a signed release APK uploaded as the **Landed-Android** artifact. The **Demo video** workflow records the app on an emulator. This does not publish to Google Play.

## App areas

- Home: next task, work hours and money at a glance, upcoming deadlines, alerts
- Arrival checklist (12 steps, add your own)
- Work-hours tracker by Monday–Sunday week, multiple jobs, pay estimate, limit warnings
- Money: monthly budget, spending by category, daily allowance
- Deadlines with visa-expiry countdown, private encrypted notes, emergency numbers
- 12 guides (visa, work, money, housing, health, study, transport, food, phone, community, emergencies, careers) linking to official sources
- Food near me (OpenStreetMap, opt-in approximate location)
- Banks & SIMs with labelled referral links
- Offline Ask helper (50+ answers, plus answers from your own data)

## Privacy & security

- All personal data encrypted on the device with AES-256-GCM; key in the Android Keystore
- No analytics, ads or trackers; fonts bundled; Android cloud backup disabled
- App lock (fingerprint/face/PIN), screenshots and Recents preview blocked by default
- Passphrase-encrypted backup and restore; erase everything
- Optional sign-in (Google, Facebook, email) through Firebase Authentication, off unless configured; only the sign-in identity is stored there
