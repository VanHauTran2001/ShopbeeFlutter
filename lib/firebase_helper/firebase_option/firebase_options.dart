import 'dart:io';
import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseConfig{
  static FirebaseOptions get platformOptions{
      return const FirebaseOptions(
          apiKey: 'AIzaSyDkAoZYr3z2nm9z4IxXhnbTn3_7DIyxk9Q',
          appId: '1:986169779929:android:22f56760d98dd8d78c80c8',
          messagingSenderId: '986169779929',
          projectId: 'shopbeeflutter');
  }
}