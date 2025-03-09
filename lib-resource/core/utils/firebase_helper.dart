import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../firebase_options.dart';

class FirebaseHelper {
  static bool _initialized = false;

  static Future<void> ensureInitialized() async {
    if (!_initialized) {
      try {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
        _initialized = true;
      } catch (e) {
        if (e is FirebaseException && e.code == 'duplicate-app') {
          _initialized = true;
        } else {
          rethrow;
        }
      }
    }
  }

  static Future<UserCredential> createUser(
      String email, String password) async {
    return await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  static Future<void> createUserData(
      String uid, Map<String, dynamic> data) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).set(data);
  }
}
