# SettleMate Android app

Native Flutter Android client for SettleMate. The screens currently provide a visual/product prototype with sample in-memory data.

## Build an Android APK

Install Flutter 3.27 or newer and the Android SDK, then run:

```bash
cd flutter
flutter create --platforms=android --org com.dinakarnayak --project-name settlemate .
flutter pub get
flutter analyze
flutter build apk --debug
```

The APK is created at `build/app/outputs/flutter-apk/app-debug.apk`.

## Automated free build

Every push to `feat/settlemate-android-apk` runs the Android build workflow. GitHub Actions uploads the debug APK as a downloadable workflow artifact when the build succeeds. This does not publish to Google Play.

## App areas

- Home dashboard
- Arrival checklist
- Work-hours tracker
- Money and spending
- Discover
- Assistant interface

## Current limitations

- This Android client is not connected to Neon Auth or the Neon Data API yet.
- App data is sample/in-memory data and is not private cloud-synced.
- Sign-in, secure token storage, export, account deletion and real multi-account isolation are not implemented in this client.
- Do not enter sensitive personal data or distribute this prototype to external testers.

The private beta backend and security gates are documented in `../backend/README.md`, `../docs/beta-security.md` and `../docs/neon-beta-setup.md`.
