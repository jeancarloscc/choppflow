// lib/firebase_options.dart
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
        return linux;
      default:
        return web;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAThu9ZvfBmo8-TZDNWU3YzM00jGxJsV3o',
    authDomain: 'choppflow-app.firebaseapp.com',
    projectId: 'choppflow-app',
    storageBucket: 'choppflow-app.firebasestorage.app',
    messagingSenderId: '484466545175',
    appId: '1:484466545175:web:9af00d9790d42cbe468252',
    measurementId: 'G-7P1YQ1QW1Q',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAThu9ZvfBmo8-TZDNWU3YzM00jGxJsV3o',
    appId: '1:484466545175:web:9af00d9790d42cbe468252',
    messagingSenderId: '484466545175',
    projectId: 'choppflow-app',
    storageBucket: 'choppflow-app.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAThu9ZvfBmo8-TZDNWU3YzM00jGxJsV3o',
    appId: '1:484466545175:web:9af00d9790d42cbe468252',
    messagingSenderId: '484466545175',
    projectId: 'choppflow-app',
    storageBucket: 'choppflow-app.firebasestorage.app',
    iosClientId: '',
    iosBundleId: 'com.jeancc.project.choppflow',
  );

  static const FirebaseOptions macos = ios;
  static const FirebaseOptions windows = android;
  static const FirebaseOptions linux = android;
}
