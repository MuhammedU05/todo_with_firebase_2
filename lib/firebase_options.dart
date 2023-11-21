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
    apiKey: 'AIzaSyAkWXd2LqEaQYkRnYUdwXJZswSplHN6y8w',
    appId: '1:256001512086:web:fc5f8eb35b088777e828b7',
    messagingSenderId: '256001512086',
    projectId: 'todo-with-firebase-1',
    authDomain: 'todo-with-firebase-1.firebaseapp.com',
    storageBucket: 'todo-with-firebase-1.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDmxfhkRgTf-LizpUTsUNrd56ElRSPypDM',
    appId: '1:256001512086:android:36917d9b7c426165e828b7',
    messagingSenderId: '256001512086',
    projectId: 'todo-with-firebase-1',
    storageBucket: 'todo-with-firebase-1.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCdyZnZeuv_YxfwZLJ9iZl7hHe08y3TxvU',
    appId: '1:256001512086:ios:c857786532ec8005e828b7',
    messagingSenderId: '256001512086',
    projectId: 'todo-with-firebase-1',
    storageBucket: 'todo-with-firebase-1.appspot.com',
    iosBundleId: 'com.example.todoWithFirebase2',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCdyZnZeuv_YxfwZLJ9iZl7hHe08y3TxvU',
    appId: '1:256001512086:ios:76990e4aa309575ce828b7',
    messagingSenderId: '256001512086',
    projectId: 'todo-with-firebase-1',
    storageBucket: 'todo-with-firebase-1.appspot.com',
    iosBundleId: 'com.example.todoWithFirebase2.RunnerTests',
  );
}
