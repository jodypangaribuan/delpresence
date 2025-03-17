import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

import 'core/theme/theme.dart';
import 'core/config/api_config.dart';
import 'core/utils/api_logger.dart';
import 'core/utils/http_override.dart';
import 'core/utils/api_connection_monitor.dart';
import 'features/splash/presentation/screens/splash_screen.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set HTTP overrides untuk menerima sertifikat self-signed
  HttpOverrides.global = DevHttpOverrides();

  // Set system UI properties immediately on app startup
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
    ),
  );

  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  // Initialize API configuration dengan nilai default
  ApiConfig.instance.initialize(
    timeout: 60, // Memperpanjang timeout menjadi 60 detik
  );

  // Configure API logger
  ApiLogger.setEnabled(ApiConfig.instance.isLoggingEnabled);
  ApiLogger.setDetailedMode(true);

  // Check API connection
  await _checkApiConnection();

  runApp(MyApp(prefs: prefs));
}

/// Periksa koneksi API dan cetak hasilnya
Future<void> _checkApiConnection() async {
  debugPrint('');
  debugPrint('┌─────────────── DELPRESENCE APP ─────────────────');
  debugPrint('│ 🚀 Aplikasi dimulai pada ${DateTime.now()}');
  debugPrint('│ 🔄 Memeriksa koneksi ke API...');
  debugPrint('└───────────────────────────────────────────────');

  // Coba periksa koneksi ke API
  try {
    final isConnected = await ApiConnectionMonitor.instance.checkConnection();

    debugPrint('');
    debugPrint('┌─────────────── API CONNECTION ─────────────────');
    if (isConnected) {
      debugPrint('│ ✅ API terhubung dan siap digunakan');
    } else {
      debugPrint('│ ❌ API tidak dapat diakses!');
      debugPrint('│ 📝 Pesan: ${ApiConnectionMonitor.instance.statusMessage}');
      debugPrint('│ ⚠️  Aplikasi mungkin tidak berfungsi dengan baik');
    }
    debugPrint('└───────────────────────────────────────────────');
    debugPrint('');
  } catch (e) {
    debugPrint('');
    debugPrint('┌─────────────── API CONNECTION ERROR ──────────');
    debugPrint('│ ❌ Terjadi kesalahan saat memeriksa koneksi API');
    debugPrint('│ 📝 Error: ${e.toString()}');
    debugPrint('└───────────────────────────────────────────────');
    debugPrint('');
  }
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  const MyApp({Key? key, required this.prefs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(
            AuthRepositoryImpl(prefs),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
