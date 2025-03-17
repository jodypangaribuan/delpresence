import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/config/api_config.dart';
import '../../../../core/services/network_service.dart';
import '../../../../core/utils/api_logger.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/auth_response_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final NetworkService _networkService;
  final SharedPreferences _prefs;

  AuthRepositoryImpl(this._prefs)
      : _networkService = NetworkService(
          baseUrl: ApiConfig.instance.baseUrl,
          defaultHeaders: ApiConfig.instance.defaultHeaders,
          timeout: ApiConfig.instance.timeout,
        );

  // Private methods for token management
  Future<String?> _getToken() async {
    return _prefs.getString('access_token');
  }

  Future<void> _saveTokens(String accessToken, String refreshToken) async {
    await _prefs.setString('access_token', accessToken);
    await _prefs.setString('refresh_token', refreshToken);
    debugPrint('Tokens saved successfully');
  }

  Future<void> _clearTokens() async {
    await _prefs.remove('access_token');
    await _prefs.remove('refresh_token');
    debugPrint('Tokens cleared successfully');
  }

  // Helper method to add auth headers
  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await _getToken();
    final Map<String, String> headers =
        Map.from(ApiConfig.instance.defaultHeaders);
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  // Helper method to handle API response
  AuthResponseModel _handleApiResponse(ApiResponse<dynamic> response) {
    if (response.success) {
      final dynamic data = response.data;
      if (data is Map<String, dynamic>) {
        // Safely handle data structure
        final message = data['message'] ?? 'Success';

        // Check if data contains 'data' key and it's not null
        if (data.containsKey('data') && data['data'] != null) {
          try {
            // Make sure data['data'] is a Map before trying to convert it
            if (data['data'] is Map<String, dynamic>) {
              return AuthResponseModel(
                success: true,
                message: message,
                data: AuthDataModel.fromJson(data['data']),
              );
            } else {
              // data['data'] exists but is not a Map
              return AuthResponseModel(
                success: true,
                message: message,
              );
            }
          } catch (e) {
            debugPrint('Error parsing auth data: $e');
            return AuthResponseModel(
              success: true,
              message: message,
            );
          }
        } else {
          // No 'data' key or it's null
          return AuthResponseModel(success: true, message: message);
        }
      } else {
        // Response data is not a Map
        return AuthResponseModel(success: true, message: 'Success');
      }
    } else {
      return AuthResponseModel(
        success: false,
        message: response.errorMessage ?? 'Request failed',
      );
    }
  }

  @override
  Future<AuthResponseModel> registerStudent({
    required String nim,
    required String firstName,
    String? middleName,
    String? lastName,
    required String email,
    required String password,
    required String major,
    required String faculty,
    required String batch,
  }) async {
    try {
      final response = await _networkService.post<dynamic>(
        '/auth/register/student',
        body: {
          'nim': nim,
          'first_name': firstName,
          'middle_name': middleName,
          'last_name': lastName,
          'email': email,
          'password': password,
          'major': major,
          'faculty': faculty,
          'batch': batch,
        },
      );

      final authResponse = _handleApiResponse(response);

      if (authResponse.success && authResponse.data?.tokens != null) {
        await _saveTokens(
          authResponse.data!.tokens!.accessToken,
          authResponse.data!.tokens!.refreshToken,
        );
      }

      return authResponse;
    } catch (e, stackTrace) {
      ApiLogger.logError('/auth/register/student', e, stackTrace);
      return AuthResponseModel(
        success: false,
        message: 'Registration failed: ${e.toString()}',
      );
    }
  }

  @override
  Future<AuthResponseModel> registerLecture({
    required String nip,
    required String firstName,
    String? middleName,
    String? lastName,
    required String email,
    required String password,
    required String position,
  }) async {
    try {
      final response = await _networkService.post<dynamic>(
        '/auth/register/lecture',
        body: {
          'nip': nip,
          'first_name': firstName,
          'middle_name': middleName,
          'last_name': lastName,
          'email': email,
          'password': password,
          'position': position,
        },
      );

      final authResponse = _handleApiResponse(response);

      if (authResponse.success && authResponse.data?.tokens != null) {
        await _saveTokens(
          authResponse.data!.tokens!.accessToken,
          authResponse.data!.tokens!.refreshToken,
        );
      }

      return authResponse;
    } catch (e, stackTrace) {
      ApiLogger.logError('/auth/register/lecture', e, stackTrace);
      return AuthResponseModel(
        success: false,
        message: 'Registration failed: ${e.toString()}',
      );
    }
  }

  @override
  Future<AuthResponseModel> login({
    required String loginId,
    required String password,
  }) async {
    try {
      final response = await _networkService.post<dynamic>(
        '/auth/login',
        body: {
          'login_id': loginId,
          'password': password,
        },
      );

      final authResponse = _handleApiResponse(response);

      if (authResponse.success && authResponse.data?.tokens != null) {
        await _saveTokens(
          authResponse.data!.tokens!.accessToken,
          authResponse.data!.tokens!.refreshToken,
        );
      }

      return authResponse;
    } catch (e, stackTrace) {
      ApiLogger.logError('/auth/login', e, stackTrace);
      return AuthResponseModel(
        success: false,
        message: 'Login failed: ${e.toString()}',
      );
    }
  }

  @override
  Future<AuthResponseModel> refreshToken(String refreshToken) async {
    try {
      final response = await _networkService.post<dynamic>(
        '/auth/refresh',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $refreshToken',
        },
      );

      final authResponse = _handleApiResponse(response);

      if (authResponse.success && authResponse.data?.tokens != null) {
        await _saveTokens(
          authResponse.data!.tokens!.accessToken,
          authResponse.data!.tokens!.refreshToken,
        );
      }

      return authResponse;
    } catch (e, stackTrace) {
      ApiLogger.logError('/auth/refresh', e, stackTrace);
      return AuthResponseModel(
        success: false,
        message: 'Token refresh failed: ${e.toString()}',
      );
    }
  }

  @override
  Future<AuthResponseModel> logout() async {
    try {
      final refreshToken = await _prefs.getString('refresh_token');
      if (refreshToken == null) {
        // If no refresh token, just clear local tokens
        await _clearTokens();
        return AuthResponseModel(
            success: true, message: 'Logged out successfully');
      }

      final headers = await _getAuthHeaders();
      final response = await _networkService.post<dynamic>(
        '/auth/logout',
        headers: headers,
        body: {'refresh_token': refreshToken},
      );

      await _clearTokens();
      return _handleApiResponse(response);
    } catch (e, stackTrace) {
      ApiLogger.logError('/auth/logout', e, stackTrace);
      // Still clear tokens even if the request fails
      await _clearTokens();
      return AuthResponseModel(
        success: false,
        message: 'Logout failed: ${e.toString()}',
      );
    }
  }

  @override
  Future<AuthResponseModel> getCurrentUser() async {
    try {
      final headers = await _getAuthHeaders();
      final response = await _networkService.get<dynamic>(
        '/auth/me',
        headers: headers,
      );

      return _handleApiResponse(response);
    } catch (e, stackTrace) {
      ApiLogger.logError('/auth/me', e, stackTrace);
      return AuthResponseModel(
        success: false,
        message: 'Failed to get user: ${e.toString()}',
      );
    }
  }
}
