import 'package:flutter/material.dart';
import 'package:delcommerce/core/depandancy_injection/service_locator.dart';
import 'package:delcommerce/core/utils/service_locator/service_locator.dart';
import 'package:delcommerce/delcommerce.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'package:delcommerce/core/utils/firebase_helper.dart';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await FirebaseHelper.ensureInitialized();
    await setupServiceLocator();
    await setupOldServiceLocator();
    runApp(const DelStore());
  } catch (e, stackTrace) {
    debugPrint('Initialization error: $e');
    debugPrint('Stack trace: $stackTrace');
    rethrow;
  }
}
