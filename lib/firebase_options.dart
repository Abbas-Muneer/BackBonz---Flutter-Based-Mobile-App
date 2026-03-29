import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

class DefaultFirebaseOptions {
  static const String _placeholder = 'replace-with-your-value';

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: _placeholder,
    appId: _placeholder,
    messagingSenderId: _placeholder,
    projectId: _placeholder,
    authDomain: _placeholder,
    storageBucket: _placeholder,
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAK0trw_853qCyrbTQmG7tn6W1WqCnXP-4',
    appId: '1:766924281931:android:8ddb7792cf53fced6c15ce',
    messagingSenderId: '766924281931',
    projectId: 'backbonz-2959b',
    storageBucket: 'backbonz-2959b.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: _placeholder,
    appId: _placeholder,
    messagingSenderId: _placeholder,
    projectId: _placeholder,
    iosBundleId: 'com.backbonz.backbonz',
    storageBucket: _placeholder,
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: _placeholder,
    appId: _placeholder,
    messagingSenderId: _placeholder,
    projectId: _placeholder,
    iosBundleId: 'com.backbonz.backbonz',
    storageBucket: _placeholder,
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: _placeholder,
    appId: _placeholder,
    messagingSenderId: _placeholder,
    projectId: _placeholder,
    authDomain: _placeholder,
    storageBucket: _placeholder,
  );

  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: _placeholder,
    appId: _placeholder,
    messagingSenderId: _placeholder,
    projectId: _placeholder,
    authDomain: _placeholder,
    storageBucket: _placeholder,
  );

  static bool get isConfigured => currentPlatform.apiKey != _placeholder;

  static String get setupMessage =>
      'Firebase options are still placeholders. Run `flutterfire configure` '
      'or replace `lib/firebase_options.dart` with your generated values.';

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
        throw UnsupportedError('DefaultFirebaseOptions not supported here.');
    }
  }
}
