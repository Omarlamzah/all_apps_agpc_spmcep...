# Congress App

Flutter application for AGPC and the other congress brands managed by the
iTech Event platform. The interface and published content are loaded from the
Laravel event API, so each congress can keep its own identity, content and
enabled features from the administration website.

## Features

- Dynamic event branding, hero image and countdown
- Event information and president's message with photo
- PDF program and structured agenda
- Speakers, sponsors and board members
- E-poster library with public comments
- Live stream with public comments
- Multi-event configuration through `APP_FLAVOR`
- Android, iOS and web targets

## Requirements

- Flutter SDK compatible with Dart `^3.11.4`
- An Android/iOS device, emulator, or Chrome
- Access to the event API

## Run AGPC

Install dependencies:

```bash
flutter pub get
```

Run in Chrome:

```bash
flutter run -d chrome \
  --dart-define=APP_FLAVOR=agpc \
  --dart-define=API_URL=https://events.itechevent.com/api/public/api/public/mobile
```

Run on a connected Android device:

```bash
flutter run \
  --dart-define=APP_FLAVOR=agpc \
  --dart-define=API_URL=https://events.itechevent.com/api/public/api/public/mobile
```

## Quality checks

```bash
flutter analyze
flutter test
```

## Production builds

```bash
flutter build apk --release \
  --dart-define=APP_FLAVOR=agpc \
  --dart-define=API_URL=https://events.itechevent.com/api/public/api/public/mobile

flutter build web --release \
  --dart-define=APP_FLAVOR=agpc \
  --dart-define=API_URL=https://events.itechevent.com/api/public/api/public/mobile
```

Do not commit signing files, API secrets, or local environment files.

## Codemagic and TestFlight

The repository includes an `agpc-ios-testflight` workflow in
`codemagic.yaml`. It builds a signed AGPC IPA with bundle identifier
`com.itechevent.agpc2026` and uploads it to App Store Connect.

Before the first build:

1. Register `com.itechevent.agpc2026` in Apple Developer.
2. Create the new `AGPC 2026` app record in App Store Connect.
3. Add an App Store Connect integration in Codemagic named
   `agpc_app_store`.
4. Add this GitHub repository to Codemagic and run the
   `AGPC 2026 - iOS TestFlight` workflow from `main`.

The workflow uploads to App Store Connect but does not automatically submit
the app for App Review.
