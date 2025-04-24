import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'core/theme/theme.dart';
import 'core/utils/http_override.dart';
import 'core/utils/api_logger.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/splash/presentation/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set HTTP overrides untuk menerima sertifikat self-signed
  HttpOverrides.global = DevHttpOverrides();

  // Configure API Logger
  ApiLogger.setEnabled(true);
  ApiLogger.setDetailedMode(true);
  ApiLogger.setColorfulLogs(true);

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

  // Create http client
  final httpClient = http.Client();

  // Create auth data source
  final authDataSource = AuthRemoteDataSourceImpl(client: httpClient);

  // Create auth repository
  final authRepository = AuthRepositoryImpl(
    remoteDataSource: authDataSource,
    prefs: prefs,
  );

  runApp(MyApp(
    prefs: prefs,
    httpClient: httpClient,
    authRepository: authRepository,
  ));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  final http.Client httpClient;
  final AuthRepository authRepository;

  const MyApp({
    super.key,
    required this.prefs,
    required this.httpClient,
    required this.authRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provide the auth repository
        Provider<AuthRepository>(
          create: (_) => authRepository,
        ),
        // Provide the auth bloc
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authRepository),
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
