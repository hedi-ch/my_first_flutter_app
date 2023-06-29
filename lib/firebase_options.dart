// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyAep5ubmzT5j15VRP4ISeFk4CJ4MNREKS4',
    appId: '1:280877193265:web:94209567d4900f65951d10',
    messagingSenderId: '280877193265',
    projectId: 'my-first-flutter-app-7d38a',
    authDomain: 'my-first-flutter-app-7d38a.firebaseapp.com',
    storageBucket: 'my-first-flutter-app-7d38a.appspot.com',
    measurementId: 'G-Z29NNTG5D9',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBNJCaQ95Mh5gdpTMpqELPSXl-ZKuby0Zo',
    appId: '1:280877193265:android:1f4fab666a501056951d10',
    messagingSenderId: '280877193265',
    projectId: 'my-first-flutter-app-7d38a',
    storageBucket: 'my-first-flutter-app-7d38a.appspot.com',
  );
}
