import 'package:flutter/material.dart';
import 'package:delcommerce/core/depandancy_injection/service_locator.dart';
import 'package:delcommerce/core/utils/service_locator/service_locator.dart';
import 'package:delcommerce/delcommerce.dart';
import 'package:delcommerce/core/utils/firebase_helper.dart';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    // Initialize Firebase first
    await FirebaseHelper.ensureInitialized();
    // Then setup service locators
    await setupServiceLocator();
    await setupOldServiceLocator();
    runApp(const DelStore());
  } catch (e, stackTrace) {
    debugPrint('Initialization error: $e');
    debugPrint('Stack trace: $stackTrace');
    rethrow;
  }
}
