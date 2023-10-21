// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'

    show defaultTargetPlatform, kIsWeb, TargetPlatform;

// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';


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
    apiKey: 'AIzaSyCYOF4LApMVLK0QgFPJYJPjKBVJR9fPbak',
    appId: '1:718754203049:web:d16c6d7f99f67c40b770b8',
    messagingSenderId: '718754203049',
    projectId: 'multi-cast',
    authDomain: 'multi-cast.firebaseapp.com',
    storageBucket: 'multi-cast.appspot.com',
    measurementId: 'G-GX89R3B6XM',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBrriqefaZGrmHNAj5rzCV0toKezI3feWI',
    appId: '1:718754203049:android:a9c33d49c8119150b770b8',
    messagingSenderId: '718754203049',
    projectId: 'multi-cast',
    storageBucket: 'multi-cast.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC5SH_aVfFLvCwu9C7OaIZ4bz9dd7xWMRk',
    appId: '1:718754203049:ios:bf456272f82fef7ab770b8',
    messagingSenderId: '718754203049',
    projectId: 'multi-cast',
    storageBucket: 'multi-cast.appspot.com',
    androidClientId: '718754203049-qu1o9fr8k28cdjdt4k3h2tco0671d8v6.apps.googleusercontent.com',
    iosClientId: '718754203049-0qg9ujasnfkmmbjoqas8dokbntr3kqbe.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC5SH_aVfFLvCwu9C7OaIZ4bz9dd7xWMRk',
    appId: '1:718754203049:ios:944613361308f894b770b8',
    messagingSenderId: '718754203049',
    projectId: 'multi-cast',
    storageBucket: 'multi-cast.appspot.com',
    androidClientId: '718754203049-qu1o9fr8k28cdjdt4k3h2tco0671d8v6.apps.googleusercontent.com',
    iosClientId: '718754203049-bqfvkqp78kuu502fg6v8nmrj68pte5ob.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterApp.RunnerTests',
  );
}