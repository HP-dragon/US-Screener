# US Screener

A Flutter app prototype for stock screener notes with a simple landing screen and expandable main menu navigation.

## Project goal

This project is a starting point for an app that can be expanded into a US stock screener and notes workflow compatible with web, Android, Windows, and later iOS.

## Run locally

1. Install Flutter.
2. Open the project folder.
3. Run:

```bash
flutter pub get
flutter run -d chrome
```

For Android debug build:

```bash
flutter run -d android
```

For release web build:

```bash
flutter build web
```

## Build APK otomatis lewat GitHub Actions

Repository ini sudah disiapkan agar GitHub Actions otomatis membuat file APK Android debug pada setiap `push`, `pull_request`, atau saat workflow dijalankan manual.

### Cara mengambil APK dari HP Android

1. Buka tab **Actions** di repository GitHub.
2. Pilih workflow **Build Android APK**.
3. Buka run terbaru yang statusnya berhasil.
4. Download artifact **us-screener-debug-apk**.
5. Ekstrak file ZIP hasil download, lalu install file `app-debug.apk` di HP Android.

> Jika Android menolak instalasi, aktifkan izin install aplikasi dari sumber tidak dikenal di HP kamu terlebih dahulu.

## Folder structure

- `lib/` — app source code
- `test/` — widget tests
- `pubspec.yaml` — Flutter project configuration
