import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:iconsax/iconsax.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/utils/api_logger.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../data/models/mahasiswa_model.dart';
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? rawData;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _checkIsStudent();
  }

  Future<void> _checkIsStudent() async {
    // Just fetch student data directly without checking access_denied flag first
    // This allows legitimate students to access the app even if the flag was set incorrectly
    _fetchStudentData();
  }

  Future<void> _fetchStudentData() async {
    try {
      // Reset state
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      // Get auth data from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final authToken = prefs.getString('auth_token');
      final userId = prefs.getInt('user_id');

      ApiLogger.logRequest(
        method: 'INFO',
        url: 'Preparing to fetch student data',
        body: {
          'User ID': userId,
          'Token available': token != null,
          'Auth token available': authToken != null,
        },
      );

      // Debug current access_denied flag state
      final isAccessDenied = prefs.getBool('access_denied') ?? false;
      print("Current access_denied flag: $isAccessDenied");

      // Verify we have the required data
      if ((token == null && authToken == null) || userId == null) {
        setState(() {
          isLoading = false;
          errorMessage = 'User data not found. Please login again.';
        });
        ApiLogger.logError(
          'HomeScreen',
          'Missing token or userId, login again required',
          null,
        );
        return;
      }

      // Try to use either token, preferring the direct API token
      final usedToken = token ?? authToken;

      // Create the URL with the user_id parameter
      final url = Uri.parse(
          '${ApiConstants.mahasiswaCompleteEndpoint}?user_id=$userId');

      // Log the request
      ApiLogger.logRequest(
        method: 'GET',
        url: url.toString(),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${usedToken!.substring(0, min(10, usedToken.length))}...',
        },
      );

      // Make the API request
      final startTime = DateTime.now();
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $usedToken',
        },
      );
      final endTime = DateTime.now();
      final responseTime = endTime.difference(startTime).inMilliseconds;

      // Log the response
      ApiLogger.logResponse(
        statusCode: response.statusCode,
        url: url.toString(),
        headers: response.headers,
        body: _safeParseJson(response.body),
        responseTime: responseTime,
      );

      // Process based on status code
      if (response.statusCode == 200) {
        // Parse the response
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse['status'] == 'success' &&
            jsonResponse.containsKey('data')) {
          // Store the raw data
          setState(() {
            rawData = jsonResponse;
            isLoading = false;
          });

          // Clear any incorrect access_denied flag since this is a valid student
          await prefs.setBool('access_denied', false);
          print("Cleared access_denied flag - Valid student detected");

          ApiLogger.logRequest(
            method: 'INFO',
            url: 'Student data loaded successfully',
            body: null,
          );
        } else {
          // Handle API error
          setState(() {
            isLoading = false;
            errorMessage =
                jsonResponse['message'] ?? 'Failed to get student data';
          });

          // Check for specific error about no student found
          if (jsonResponse['message'] != null &&
              (jsonResponse['message']
                      .toString()
                      .contains('no student found') ||
                  jsonResponse['message']
                      .toString()
                      .contains('not a student'))) {
            _handleNonStudentUser(jsonResponse['message']);
          } else {
            ApiLogger.logError(
              url.toString(),
              'API returned error: ${jsonResponse['message']}',
              null,
            );
          }
        }
      } else if (response.statusCode == 401) {
        ApiLogger.logError(
          url.toString(),
          'Authentication failed (401). Token may be invalid or expired.',
          null,
        );

        // Show error message
        setState(() {
          isLoading = false;
          errorMessage = 'Your session has expired. Please log in again.';
        });

        // Trigger logout after a delay to allow user to see the message
        Future.delayed(const Duration(seconds: 2), () {
          context.read<AuthBloc>().add(LogoutEvent());
        });
      } else if (response.statusCode == 404 || response.statusCode == 400) {
        // Handle cases where the endpoint might return 404 for student not found
        ApiLogger.logError(
          url.toString(),
          'Student record not found: ${response.statusCode}',
          null,
        );

        _handleNonStudentUser('No student record found for this account');
      } else {
        // Handle other HTTP errors
        ApiLogger.logError(
          url.toString(),
          'API returned error status: ${response.statusCode}',
          null,
        );

        setState(() {
          isLoading = false;
          errorMessage =
              'Failed to get student data. Server returned status: ${response.statusCode}';
        });
      }
    } catch (e, stackTrace) {
      // Handle exceptions
      ApiLogger.logError(
        'HomeScreen',
        'Exception during data fetch: $e',
        stackTrace,
      );

      // Check for specific error about no student found
      if (e.toString().contains('no student found') ||
          e.toString().contains('not a student')) {
        _handleNonStudentUser(e.toString());
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Network error: $e';
        });
      }
    }
  }

  // Handle the case where the user is not a student
  void _handleNonStudentUser(String message) {
    ApiLogger.logError(
      'HomeScreen',
      'Non-student user detected: $message',
      null,
    );

    print("Handling potential non-student: $message");

    // Only save the access_denied flag if there's a clear indication this isn't a student
    // Temporary errors shouldn't prevent future login attempts
    if (message.contains('no student found') ||
        message.contains('not a student') ||
        message.toLowerCase().contains('access denied')) {
      print("Setting access_denied flag - Confirmed non-student message");
      SharedPreferences.getInstance().then((prefs) {
        prefs.setBool('access_denied', true);
      });
    } else {
      print("NOT setting access_denied flag - Could be temporary error");
    }

    setState(() {
      isLoading = false;
      // Don't set the errorMessage since we'll show a toast instead
    });

    // Show a toast notification
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _showAccessDeniedToast(context);

        // Trigger logout after a delay
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            context.read<AuthBloc>().add(LogoutEvent());
          }
        });
      }
    });
  }

  // Show a toast-style notification for access denied
  void _showAccessDeniedToast(BuildContext context) {
    final message = 'Hanya akun mahasiswa yang diizinkan';
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 40,
        left: 0,
        right: 0,
        child: SafeArea(
          child: Center(
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 300),
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: Opacity(
                    opacity: value,
                    child: child,
                  ),
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.8),
                      Colors.white.withOpacity(0.7),
                      AppColors.primary.withOpacity(0.3),
                    ],
                    stops: const [0.1, 0.5, 0.9],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.white.withOpacity(0.5),
                    width: 1.5,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ui.ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.2),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.5),
                              width: 1.5,
                            ),
                          ),
                          child: Icon(
                            Iconsax.warning_2,
                            color: AppColors.primary,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Akses Ditolak',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                message,
                                style: TextStyle(
                                  color: AppColors.black.withOpacity(0.7),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    // Add the overlay entry
    overlay.insert(overlayEntry);

    // Remove the overlay entry after logout is triggered (3 seconds)
    Future.delayed(const Duration(seconds: 3), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }

  // Helper method to safely parse JSON for logging
  dynamic _safeParseJson(String text) {
    try {
      return json.decode(text);
    } catch (e) {
      return text;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Set status bar color to match app theme
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: AppColors.primary,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('DelPresence - Raw Data'),
          backgroundColor: AppColors.primary,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _fetchStudentData,
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                context.read<AuthBloc>().add(LogoutEvent());
              },
            ),
          ],
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Error',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _fetchStudentData,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (rawData == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_off,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'No Data',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Student data not available',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      );
    }

    // Show raw JSON data in a scrollable text view
    final prettyJsonString =
        const JsonEncoder.withIndent('  ').convert(rawData);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Raw API Response:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(12),
            width: double.infinity,
            child: SelectableText(
              prettyJsonString,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
