# Firebase Configuration Instructions

## Current Status

✅ Flutter project setup complete

✅ Firebase dependencies added

✅ Basic authentication screens created

⚠️ Firebase configuration needs real app IDs

## Next Steps

### Option 1: Add FlutterFire to PATH (Recommended)

1. **Add to System PATH:**

   - Press `Win + R`, type `sysdm.cpl`, press Enter
   - Click "Environment Variables"
   - Under "User variables", find "Path" and click "Edit"
   - Click "New" and add: `C:\Users\HP\AppData\Local\Pub\Cache\bin`
   - Click OK on all dialogs
   - **Restart your terminal/VS Code**

2. **Run configuration:**

   ```bash
   flutterfire configure --project=multisales-18e57
   ```

### Option 2: Use the PowerShell Script

Run the provided script:

```powershell
.\configure_firebase.ps1
```

### Option 3: Manual Configuration with Full Path

```powershell
C:\Users\HP\AppData\Local\Pub\Cache\bin\flutterfire configure --project=multisales-18e57
```

## Testing the App

After configuration, test the app:

```bash
# For web
flutter run -d chrome

# For Windows
flutter run -d windows

# For Android (if you have emulator/device)
flutter run -d android
```

## Firebase Console Setup

1. Go to [Firebase Console](https://console.firebase.google.com/)

2. Select your project: **multisales-18e57**

3. Go to **Authentication** → **Sign-in method**

4. Enable **Email/Password** authentication

5. Go to **Firestore Database** → **Create database** (start in test mode)

## Project Structure Created

```text
lib/
├── core/
│   ├── constants/app_constants.dart
│   └── services/
│       ├── auth_service.dart
│       ├── firestore_service.dart
│       └── storage_service.dart
├── data/models/
│   ├── user_model.dart
│   └── product_model.dart
├── presentation/
│   ├── screens/login_screen.dart
│   └── widgets/auth_wrapper.dart
├── firebase_options.dart
└── main.dart
```

## Features Available

- ✅ User authentication (email/password)
- ✅ Firestore database operations
- ✅ Firebase Storage file uploads
- ✅ Authentication state management
- ✅ Login screen with validation
- ✅ User and Product data models

## Troubleshooting

If you get path-related errors:

1. Restart your terminal after adding to PATH
2. Use the full path to flutterfire command
3. Use the provided PowerShell script

If Firebase initialization fails:

1. Make sure you've run flutterfire configure
2. Check that your project ID is correct: multisales-18e57
3. Verify your API key in Firebase Console
