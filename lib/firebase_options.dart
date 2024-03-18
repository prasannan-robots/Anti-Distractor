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
    apiKey: 'AIzaSyD4S9VTdUK4cKPY_8mZTbpotlErVk9FZyY',
    appId: '1:1045034252917:web:68919d5f34c551857ed63c',
    messagingSenderId: '1045034252917',
    projectId: 'anti-distractor',
    authDomain: 'anti-distractor.firebaseapp.com',
    storageBucket: 'anti-distractor.appspot.com',
    measurementId: 'G-8SX4SF8ZEP',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCleJ7fK1h5-1k_4kvy8E4vqh9EwgknFZA',
    appId: '1:1045034252917:android:5a50c396b88125327ed63c',
    messagingSenderId: '1045034252917',
    projectId: 'anti-distractor',
    storageBucket: 'anti-distractor.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBY_B23S28vyDIQivku69yKkZ47Cu4Vx-M',
    appId: '1:1045034252917:ios:116fa019fa5091a77ed63c',
    messagingSenderId: '1045034252917',
    projectId: 'anti-distractor',
    storageBucket: 'anti-distractor.appspot.com',
    androidClientId: '1045034252917-r7uqe9cdibl8s9kho7najs8fm8c2becs.apps.googleusercontent.com',
    iosClientId: '1045034252917-fomavjanuhv01pfg90jcmnb3g89ktl7e.apps.googleusercontent.com',
    iosBundleId: 'com.example.antiDistractor',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBY_B23S28vyDIQivku69yKkZ47Cu4Vx-M',
    appId: '1:1045034252917:ios:d7b9b558a76d1d567ed63c',
    messagingSenderId: '1045034252917',
    projectId: 'anti-distractor',
    storageBucket: 'anti-distractor.appspot.com',
    androidClientId: '1045034252917-r7uqe9cdibl8s9kho7najs8fm8c2becs.apps.googleusercontent.com',
    iosClientId: '1045034252917-uo5ihvjdctjaggjfas2o5d3a6eu2grqt.apps.googleusercontent.com',
    iosBundleId: 'com.example.antiDistractor.RunnerTests',
  );
}
