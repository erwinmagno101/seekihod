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
    apiKey: 'AIzaSyCZ6kSRcj_DkYMr1ZKuwqTvGCMcRgEdgXg',
    appId: '1:101362972412:web:a4a8f64aaa86a5c4938979',
    messagingSenderId: '101362972412',
    projectId: 'seekihod-tourist-guide',
    authDomain: 'seekihod-tourist-guide.firebaseapp.com',
    databaseURL: 'https://seekihod-tourist-guide-default-rtdb.firebaseio.com',
    storageBucket: 'seekihod-tourist-guide.appspot.com',
    measurementId: 'G-0LS2TC42FQ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDJ_H95VTaSgF91Pdk5D6uHWzxtntoola0',
    appId: '1:101362972412:android:0f065eb15f28d632938979',
    messagingSenderId: '101362972412',
    projectId: 'seekihod-tourist-guide',
    databaseURL: 'https://seekihod-tourist-guide-default-rtdb.firebaseio.com',
    storageBucket: 'seekihod-tourist-guide.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAyXNNKfFOq3SyxBoOBpFnEvG3C3-FLRX4',
    appId: '1:101362972412:ios:da39320131080b38938979',
    messagingSenderId: '101362972412',
    projectId: 'seekihod-tourist-guide',
    databaseURL: 'https://seekihod-tourist-guide-default-rtdb.firebaseio.com',
    storageBucket: 'seekihod-tourist-guide.appspot.com',
    iosClientId: '101362972412-je51nsqb9rs2lp9b7pld3b1n5ghk1dm9.apps.googleusercontent.com',
    iosBundleId: 'com.example.seekihod',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAyXNNKfFOq3SyxBoOBpFnEvG3C3-FLRX4',
    appId: '1:101362972412:ios:da39320131080b38938979',
    messagingSenderId: '101362972412',
    projectId: 'seekihod-tourist-guide',
    databaseURL: 'https://seekihod-tourist-guide-default-rtdb.firebaseio.com',
    storageBucket: 'seekihod-tourist-guide.appspot.com',
    iosClientId: '101362972412-je51nsqb9rs2lp9b7pld3b1n5ghk1dm9.apps.googleusercontent.com',
    iosBundleId: 'com.example.seekihod',
  );
}
