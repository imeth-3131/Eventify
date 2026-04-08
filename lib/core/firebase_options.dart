import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('Web Firebase options are not configured.');
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        throw UnsupportedError('This configuration currently supports Android only.');
      default:
        throw UnsupportedError('Unsupported platform.');
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBvbHVDNQRWYGH-Lo28xYINlJyhUdkH92o',
    appId: '1:496327084203:android:6b2b85cc8fe9c4e9488fee',
    messagingSenderId: '496327084203',
    projectId: 'eventify-abc2a',
    storageBucket: 'eventify-abc2a.firebasestorage.app',
  );
}
