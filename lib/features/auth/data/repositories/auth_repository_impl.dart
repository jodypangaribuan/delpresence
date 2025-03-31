import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import '../datasources/auth_remote_datasource.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/auth_response_model.dart';
import 'dart:convert';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final SharedPreferences prefs;

  // Constants for SharedPreferences keys
  static const String _keyUsername = 'saved_username';
  static const String _keyPassword = 'saved_password';
  static const String _keyRememberMe = 'remember_me';
  static const String _keyAuthToken = 'auth_token';
  static const String _keyToken = 'token';
  static const String _keyUserId = 'user_id';
  static const String _keyAccessDenied = 'access_denied';

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.prefs,
  });

  @override
  Future<AuthResponseModel> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await remoteDataSource.login(
        username: username,
        password: password,
      );

      if (response.success && response.data != null) {
        await saveToken(response.data!.token);
      }

      return response;
    } catch (e) {
      debugPrint('Login error: $e');
      return AuthResponseModel.error('Login failed: ${e.toString()}');
    }
  }

  @override
  Future<void> saveToken(String token) async {
    await prefs.setString(_keyAuthToken, token);
    debugPrint('Token saved successfully');
  }

  @override
  Future<String?> getToken() async {
    return prefs.getString(_keyAuthToken);
  }

  @override
  Future<void> clearToken() async {
    await prefs.remove(_keyAuthToken);
    await prefs.remove(_keyToken); // Clear API token if exists
    await prefs.remove(_keyUserId); // Clear user_id
    await prefs.setBool(_keyAccessDenied, false); // Reset access_denied flag
    debugPrint('Token and user data cleared successfully');
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // Remember me implementation

  @override
  Future<void> saveCredentials(
      String username, String password, bool remember) async {
    if (remember) {
      // Only save credentials if remember is true
      await prefs.setString(_keyUsername, username);

      // Encrypt password with simple encoding - for production use a proper encryption library
      final encodedPassword = base64.encode(utf8.encode(password));
      await prefs.setString(_keyPassword, encodedPassword);

      debugPrint('Credentials saved successfully');
    } else {
      // If remember is false, clear any saved credentials
      await clearCredentials();
    }

    // Always save the remember choice
    await prefs.setBool(_keyRememberMe, remember);
  }

  @override
  Future<Map<String, String>?> getSavedCredentials() async {
    final rememberMe = await getRememberMe();

    if (!rememberMe) {
      return null;
    }

    final username = prefs.getString(_keyUsername);
    final encodedPassword = prefs.getString(_keyPassword);

    if (username == null || encodedPassword == null) {
      return null;
    }

    // Decrypt the password
    final decodedPassword = utf8.decode(base64.decode(encodedPassword));

    return {
      'username': username,
      'password': decodedPassword,
    };
  }

  @override
  Future<bool> getRememberMe() async {
    return prefs.getBool(_keyRememberMe) ?? false;
  }

  @override
  Future<void> clearCredentials() async {
    await prefs.remove(_keyUsername);
    await prefs.remove(_keyPassword);
    debugPrint('Saved credentials cleared');
  }
}
