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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAcB7QVOsHo1YA0lQicpEybOPRhTKWlvxw',
    authDomain: 'calorietracker-d6894.firebaseapp.com',
    projectId: 'calorietracker-d6894',
    storageBucket: 'calorietracker-d6894.firebasestorage.app',
    messagingSenderId: '1070198649926',
    appId: '1:1070198649926:web:8233dc372c698cb5064647',
    measurementId: 'G-4700C40HH5',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAcB7QVOsHo1YA0lQicpEybOPRhTKWlvxw',
    appId: '1:1070198649926:android:8233dc372c698cb5064647',
    messagingSenderId: '1070198649926',
    projectId: 'calorietracker-d6894',
    storageBucket: 'calorietracker-d6894.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAcB7QVOsHo1YA0lQicpEybOPRhTKWlvxw',
    appId: '1:1070198649926:ios:8233dc372c698cb5064647',
    messagingSenderId: '1070198649926',
    projectId: 'calorietracker-d6894',
    storageBucket: 'calorietracker-d6894.firebasestorage.app',
    iosBundleId: 'com.example.calorieTrackerFlutter',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAcB7QVOsHo1YA0lQicpEybOPRhTKWlvxw',
    appId: '1:1070198649926:ios:8233dc372c698cb5064647',
    messagingSenderId: '1070198649926',
    projectId: 'calorietracker-d6894',
    storageBucket: 'calorietracker-d6894.firebasestorage.app',
    iosBundleId: 'com.example.calorieTrackerFlutter',
  );
}
