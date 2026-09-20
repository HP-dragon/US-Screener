# US Screener Notes

A Flutter Material 3 app for drafting and managing US stock screener analysis notes.

## Current scope (phase 1)

- Notes list focused on US stocks (sample notes: AAPL, NVDA, MSFT)
- Create, edit, save, search, and delete notes
- Local in-memory state only (no market API yet)
- Responsive layout suitable for Flutter Web/Chrome and expandable to Android, Windows, and iOS

## Run locally

1. Install Flutter.
2. Open this project folder.
3. Run:

```bash
flutter pub get
flutter run -d chrome
```

If Chrome device is unavailable:

```bash
flutter run -d web-server
```

## Test

```bash
flutter test
```
