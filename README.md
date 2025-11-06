# MultiSales App

<!-- Replace <owner>/<repo> with your repository path -->
[![Flutter CI with Codacy](https://github.com/<owner>/<repo>/actions/workflows/flutter_codacy_ci.yml/badge.svg)](https://github.com/<owner>/<repo>/actions/workflows/flutter_codacy_ci.yml)

A multi-platform sales application built with Flutter and Firebase.

## Architecture

- MVP backend: Firebase (Firestore + Storage + Cloud Functions)
- UI: Flutter Widgets + GoRouter, no business logic in Widgets
- State/Logic: Provider pattern (`ChangeNotifier`) in `lib/core/providers/`, services in `lib/core/services/`
- Data: Firestore collections and indexes, Storage for media, Functions for triggers/callables/scheduled jobs

Details and the future migration path to Postgres/Supabase are documented in `docs/ARCHITECTURE.md` and the ADR `docs/architecture/adr-001-firebase-mvp.md`.

## Firebase Project Configuration

- **Project Name**: MULTISALES
- **Project ID**: multisales-18e57
- **Project Number**: 967872205422
- **Web API Key**: AIzaSyBz4EfU40riAMXt3sdKFFFq5Lc_X5W6WGQ
- **Associated Email**: <hamza.panuelos@gmail.com>

## Setup Instructions

### Prerequisites

- Flutter SDK installed
- Firebase CLI installed
- Android Studio / VS Code with Flutter plugin

### Firebase Setup

1. **Configure Firebase for your platforms:**

   ```bash
   # Install FlutterFire CLI
   dart pub global activate flutterfire_cli

   # Configure Firebase (this will overwrite the placeholder configurations)
   flutterfire configure --project=multisales-18e57
   ```

2. **Add your platform-specific app IDs:**

   - The current configuration uses placeholder app IDs
   - After running `flutterfire configure`, the real app IDs will be generated
   - Make sure to create apps for each platform you want to support in the Firebase Console

### Running the App

1. **Get dependencies:**

   ```bash
   flutter pub get
   ```

2. **Run the app:**

   ```bash
   flutter run
   ```

## Project Structure

```text
lib/
├── core/
│   ├── constants/
│   │   └── app_constants.dart
│   ├── services/
│   │   ├── auth_service.dart
│   │   ├── firestore_service.dart
│   │   └── storage_service.dart
│   └── utils/
├── data/
│   ├── models/
│   │   ├── user_model.dart
│   │   └── product_model.dart
│   └── repositories/
├── presentation/
│   ├── screens/
│   │   └── login_screen.dart
│   ├── widgets/
│   │   └── auth_wrapper.dart
│   └── providers/
├── firebase_options.dart
└── main.dart
```

## Features

- ✅ Firebase Authentication (Email/Password)
- ✅ Firestore Database integration
- ✅ Firebase Storage integration
- ✅ Authentication state management
- ✅ Responsive login screen
- ✅ Basic error handling

## Firebase Services Configured

1. **Authentication**: Email/password sign-in
2. **Firestore**: NoSQL database for app data
3. **Storage**: File upload and management
4. **Hosting**: Web app deployment (ready for configuration)

## Next Steps

1. Create apps in Firebase Console for each platform
2. Update the firebase_options.dart with real app IDs
3. Configure Firebase Security Rules
4. Add more screens (register, product management, etc.)
5. Implement product catalog functionality
6. Add order management system
7. Integrate payment processing

## Platform Support

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows
- ✅ macOS
- ⚠️ Linux (needs configuration)

## Notes

- The current Firebase configuration uses placeholder app IDs
- Run `flutterfire configure` to generate platform-specific configurations
- Make sure to update Firebase Security Rules before going to production
- Consider using environment variables for sensitive configuration in production
