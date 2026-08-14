import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    return android;
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD6VT64EdpiwwOV75nqrYF85_qk1ZC61LY',
    appId: '1:822866756698:web:7c403e58924db69e734463',
    messagingSenderId: '822866756698',
    projectId: 'routefixer',
    storageBucket: 'routefixer.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD6VT64EdpiwwOV75nqrYF85_qk1ZC61LY',
    appId: '1:822866756698:android:7c403e58924db69e734463',
    messagingSenderId: '822866756698',
    projectId: 'routefixer',
    storageBucket: 'routefixer.firebasestorage.app',
  );
}
