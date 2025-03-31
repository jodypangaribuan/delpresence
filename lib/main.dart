import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'core/theme/theme.dart';
import 'core/utils/http_override.dart';
import 'core/utils/api_logger.dart';
import 'features/splash/presentation/screens/splash_screen.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

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

  runApp(MyApp(
    prefs: prefs,
    httpClient: httpClient,
  ));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  final http.Client httpClient;

  const MyApp({
    Key? key,
    required this.prefs,
    required this.httpClient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Set up dependencies
    final authRemoteDataSource = AuthRemoteDataSourceImpl(client: httpClient);
    final authRepository = AuthRepositoryImpl(
      remoteDataSource: authRemoteDataSource,
      prefs: prefs,
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              AuthBloc(authRepository)..add(CheckAuthStatusEvent()),
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
