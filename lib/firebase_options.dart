// File generated manually for Firebase configuration
// Replace the placeholder values with your actual Firebase project settings
// Get these values from: https://console.firebase.google.com > Project Settings

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // TODO: Replace these values with your Firebase project configuration
  // Go to Firebase Console > Project Settings > Your apps > Add app
  
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCK7n-UqN24a-aLVqGkTMpKKpikKoX0oNQ',
    appId: '1:471457421223:android:811b24f884b8e4a93d8882',
    messagingSenderId: '471457421223',
    projectId: 'smart-planner-2026',
    authDomain: 'smart-planner-2026.firebaseapp.com',
    storageBucket: 'smart-planner-2026.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCK7n-UqN24a-aLVqGkTMpKKpikKoX0oNQ',
    appId: '1:471457421223:android:811b24f884b8e4a93d8882',
    messagingSenderId: '471457421223',
    projectId: 'smart-planner-2026',
    storageBucket: 'smart-planner-2026.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCK7n-UqN24a-aLVqGkTMpKKpikKoX0oNQ',
    appId: '1:471457421223:android:811b24f884b8e4a93d8882',
    messagingSenderId: '471457421223',
    projectId: 'smart-planner-2026',
    storageBucket: 'smart-planner-2026.firebasestorage.app',
    iosBundleId: 'com.example.smartTaskPlanner',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCK7n-UqN24a-aLVqGkTMpKKpikKoX0oNQ',
    appId: '1:471457421223:android:811b24f884b8e4a93d8882',
    messagingSenderId: '471457421223',
    projectId: 'smart-planner-2026',
    storageBucket: 'smart-planner-2026.firebasestorage.app',
    iosBundleId: 'com.example.smartTaskPlanner',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCK7n-UqN24a-aLVqGkTMpKKpikKoX0oNQ',
    appId: '1:471457421223:android:811b24f884b8e4a93d8882',
    messagingSenderId: '471457421223',
    projectId: 'smart-planner-2026',
  );
}
