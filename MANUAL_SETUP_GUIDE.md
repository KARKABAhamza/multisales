# Manual Firebase Setup Guide

## Current Issue

- FlutterFire CLI requires Firebase CLI to be installed
- Firebase CLI installation is in progress via npm

## Step-by-Step Solution

### 1. Wait for Firebase CLI Installation

The command `npm install -g firebase-tools` is currently running. Wait for it to complete.

### 2. Login to Firebase

Once Firebase CLI is installed, run:

```powershell
firebase login
```

### 3. Configure FlutterFire

After successful login, run:

```powershell
# Add FlutterFire to PATH for current session
$env:PATH += ";C:\Users\HP\AppData\Local\Pub\Cache\bin"

# Configure Firebase
flutterfire configure --project=multisales-18e57
```

### 4. Alternative: Manual Configuration in Firebase Console

If the CLI approach continues to have issues, manually create apps in Firebase Console:

1. **Go to Firebase Console**: <https://console.firebase.google.com/>
2. **Select your project**: multisales-18e57
3. **Add apps for each platform:**

   **For Web App:**
   - Click "Add app" → Web (</>)
   - App nickname: "MultiSales Web"
   - Copy the config and update `firebase_options.dart`

   **For Android App:**
   - Click "Add app" → Android
   - Package name: `com.example.multisales_app`
   - Download `google-services.json` to `android/app/`

   **For iOS App:**
   - Click "Add app" → iOS
   - Bundle ID: `com.example.multisalesApp`
   - Download `GoogleService-Info.plist` to `ios/Runner/`

### 5. Enable Firebase Services

In Firebase Console:

1. **Authentication:**
   - Go to Authentication → Sign-in method
   - Enable "Email/Password"

2. **Firestore Database:**
   - Go to Firestore Database
   - Click "Create database"
   - Start in test mode
   - Choose location (default is fine)

3. **Storage:**
   - Go to Storage
   - Click "Get started"
   - Start in test mode

### 6. Test the App

Once configured, test on different platforms:

```powershell
# Web
flutter run -d chrome

# Windows
flutter run -d windows

# Android (if emulator/device connected)
flutter run -d android
```

### 7. Current Temporary Configuration

The app currently has temporary app IDs that will allow Firebase to initialize, but you'll need real app IDs from Firebase Console for full functionality.

### 8. Security Rules (Production)

Before going live, update Firestore and Storage security rules in Firebase Console.

**Firestore Rules:**

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only access their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    // Products are readable by authenticated users
    match /products/{productId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null; // Restrict as needed
    }
  }
}
```

**Storage Rules:**

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

## Troubleshooting

### If Firebase CLI installation fails

- Try: `npm cache clean --force`
- Then: `npm install -g firebase-tools`

### If PATH issues persist

- Permanently add to system PATH: `C:\Users\HP\AppData\Local\Pub\Cache\bin`
- Restart terminal/VS Code after PATH changes

### If Firebase initialization fails

- Check internet connection
- Verify project ID: `multisales-18e57`
- Ensure you're logged into the correct Google account

## Next Steps After Setup

1. Create user registration screen
2. Add product management functionality
3. Implement order system
4. Add file upload for product images
5. Create admin panel
6. Add payment integration
