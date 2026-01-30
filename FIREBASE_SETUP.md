# Firebase Setup Instructions

## Prerequisites
- Firebase Account (https://console.firebase.google.com)
- Flutter SDK installed
- FlutterFire CLI installed

## Step 1: Install FlutterFire CLI

```bash
dart pub global activate flutterfire_cli
```

## Step 2: Configure Firebase

1. **Login to Firebase:**
```bash
firebase login
```

2. **Create a Firebase project in the Firebase Console:**
   - Go to https://console.firebase.google.com
   - Click "Add project"
   - Name it "smart-task-planner" (or your preferred name)
   - Follow the setup wizard

3. **Configure FlutterFire:**
```bash
cd /path/to/your/project
flutterfire configure
```

This will:
- Create `firebase_options.dart` file
- Register your app with Firebase
- Download configuration files

4. **Select platforms:**
   - Choose Android and iOS when prompted
   - Select your Firebase project

## Step 3: Enable Firebase Services

### Enable Authentication:
1. Go to Firebase Console → Your Project
2. Click "Authentication" in the left menu
3. Click "Get started"
4. Enable "Email/Password" sign-in method

### Enable Firestore Database:
1. Go to Firebase Console → Your Project
2. Click "Firestore Database" in the left menu
3. Click "Create database"
4. Choose "Start in test mode" (for development)
5. Select your preferred location
6. Click "Enable"

## Step 4: Configure Firestore Security Rules

In Firebase Console → Firestore Database → Rules, replace with:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Login history collection
    match /login_history/{historyId} {
      allow read: if request.auth != null && resource.data.uid == request.auth.uid;
      allow create: if request.auth != null;
    }
    
    // Tasks collection (for future use)
    match /tasks/{taskId} {
      allow read, write: if request.auth != null && resource.data.userId == request.auth.uid;
      allow create: if request.auth != null;
    }
  }
}
```

Click "Publish" to save the rules.

## Step 5: Add Firebase Configuration to Android

The `flutterfire configure` command should have done this automatically, but verify:

**android/app/build.gradle:**
```gradle
android {
    defaultConfig {
        minSdkVersion 21  // Changed from 19 to 21 for Firebase
    }
}
```

## Step 6: Test the Setup

Run your app:
```bash
flutter run
```

## Firestore Collections Structure

### users collection:
```
users/{userId}
  - uid: string
  - name: string
  - email: string
  - phone: string
  - createdAt: timestamp
  - lastLoginAt: timestamp
  - updatedAt: timestamp (optional)
```

### login_history collection:
```
login_history/{historyId}
  - uid: string
  - email: string
  - action: string (login, logout, signup)
  - timestamp: timestamp
  - deviceInfo: map
    - platform: string
    - appVersion: string
```

## Features Implemented

✅ **Firebase Authentication:**
- Email/Password signup
- Email/Password login
- Logout with history tracking
- User profile management
- Password reset

✅ **Firestore Database:**
- User data storage
- Login history tracking
- Real-time data sync
- Query login history

✅ **Login History:**
- Track all login events
- Track logout events
- Track signup events
- Display history in app
- Filter by user

## Troubleshooting

### Error: "No Firebase App has been created"
- Make sure you ran `flutterfire configure`
- Check that `firebase_options.dart` exists
- Verify `Firebase.initializeApp()` is called in main.dart

### Error: "PERMISSION_DENIED"
- Check Firestore security rules
- Verify user is authenticated
- Make sure rules allow the operation

### Error: "java.lang.IllegalStateException"
- Update `minSdkVersion` to 21 in android/app/build.gradle
- Run `flutter clean` and rebuild

## Testing Accounts

After setup, create test accounts through the app signup flow. All data will be stored in Firebase.

## Production Checklist

Before deploying to production:
- [ ] Update Firestore security rules (remove test mode)
- [ ] Enable email verification
- [ ] Add password strength requirements
- [ ] Set up Firebase App Check
- [ ] Configure proper indexes
- [ ] Enable Firebase Analytics
- [ ] Add error reporting (Crashlytics)

## Support

For Firebase documentation:
- https://firebase.google.com/docs
- https://firebase.flutter.dev
