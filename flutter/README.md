# Landed: Flutter app (starter)

The Landed design as a Flutter app for Android and iOS. It has the same colours, fonts, tabs, XP, work-hours ring, budget and assistant as the web app.

## Run it

You need [Flutter](https://docs.flutter.dev/get-started/install) 3.27 or newer.

```bash
cd flutter
flutter create .        # generates the android/ and ios/ folders (keeps lib/ as it is)
flutter pub get
flutter run             # pick a phone, emulator or Chrome
```

## Files

| File | What's in it |
|---|---|
| `lib/main.dart` | App start, theme, floating pill navigation bar, "Ask" button |
| `lib/screens.dart` | Home, Arrival, Work, Money, Discover screens and the assistant sheet |
| `lib/state.dart` | All app data and actions (sample data, `ChangeNotifier`) |
| `lib/widgets.dart` | Progress ring, cards, meters, pills, event cards |
| `lib/theme.dart` | Colours and fonts (Fredoka + Plus Jakarta Sans via `google_fonts`) |

## Status

This is a starter written to match the web prototype. It hasn't been compiled yet, so expect to fix a few small errors the first time you run `flutter analyze`. Data is in memory only. The current starter is not yet connected to accounts or cloud storage. The planned private beta backend is PostgreSQL with Neon Auth; see `../backend/README.md` and `../docs/beta-security.md`. Native sign-in, secure token storage, per-user sync, export and account deletion must be implemented and tested before this client is offered to real beta users.
