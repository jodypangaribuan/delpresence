import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/utils/api_logger.dart';
import '../models/auth_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login({
    required String username,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;
  final String baseUrl = 'https://cis.del.ac.id/api';

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<AuthResponseModel> login({
    required String username,
    required String password,
  }) async {
    try {
      final uri = Uri.parse('${ApiConstants.campusAuthEndpoint}');

      // Create form data for the request
      var request = http.MultipartRequest('POST', uri);
      request.fields['username'] = username;
      request.fields['password'] = password;

      // Log the request with ApiLogger
      ApiLogger.logRequest(
        method: 'POST',
        url: uri.toString(),
        headers: {'Content-Type': 'multipart/form-data'},
        body: {'username': username, 'password': '********'}, // Mask password
      );

      // Send the request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      // Log the response
      ApiLogger.logResponse(
        statusCode: response.statusCode,
        url: uri.toString(),
        headers: response.headers,
        body: _safeParseJson(response.body),
        responseTime: null, // Could add timing in the future
      );

      if (response.statusCode == 200) {
        // Parse the response
        Map<String, dynamic> jsonResponse = json.decode(response.body);

        // Check if authentication was successful
        if (jsonResponse.containsKey('token')) {
          // Get user_id to verify student role
          int? userId;
          if (jsonResponse.containsKey('user') && jsonResponse['user'] is Map) {
            userId = jsonResponse['user']['user_id'];

            if (userId == null) {
              ApiLogger.logError(
                uri.toString(),
                'Authentication succeeded but user_id is null',
                null,
              );
              return AuthResponseModel.error('User ID not found in response');
            }

            // Try to verify if this user is a student by checking student endpoint
            final verifyStudentUri =
                Uri.parse('${ApiConstants.mahasiswaEndpoint}?user_id=$userId');

            // Verify is student by checking mahasiswa endpoint
            ApiLogger.logRequest(
              method: 'INFO',
              url: 'Verifying user is a student',
              body: {'user_id': userId},
            );

            // Save tokens temporarily to use for verification
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('token', jsonResponse['token']);

            // Reset any existing access_denied flag before verification
            await prefs.setBool('access_denied', false);

            try {
              // Student verification request
              final verifyResponse = await client.get(
                verifyStudentUri,
                headers: {
                  'Content-Type': 'application/json',
                  'Authorization': 'Bearer ${jsonResponse['token']}',
                },
              );

              ApiLogger.logResponse(
                statusCode: verifyResponse.statusCode,
                url: verifyStudentUri.toString(),
                headers: verifyResponse.headers,
                body: _safeParseJson(verifyResponse.body),
              );

              if (verifyResponse.statusCode != 200) {
                // Remove token since verification failed
                await prefs.remove('token');

                ApiLogger.logError(
                  verifyStudentUri.toString(),
                  'User verification failed: Not a student',
                  null,
                );

                // Now we know it's not a student, set access denied flag
                await prefs.setBool('access_denied', true);
                print(
                    "Setting access_denied to true - Not a student (HTTP error)");

                return AuthResponseModel.error(
                    'ACCESS_DENIED: Hanya akun mahasiswa yang diizinkan');
              }

              // Parse verification response to confirm student data exists
              final Map<String, dynamic> verifyData =
                  json.decode(verifyResponse.body);

              print(
                  "Student verification response: ${verifyData['status']} - Has data: ${verifyData.containsKey('data')}");

              if (verifyData['status'] != 'success' ||
                  !verifyData.containsKey('data')) {
                // Remove token since verification failed
                await prefs.remove('token');

                ApiLogger.logError(
                  verifyStudentUri.toString(),
                  'User verification failed: Response indicated non-student',
                  null,
                );

                // Save access denied flag to prevent future access attempts
                await prefs.setBool('access_denied', true);
                print(
                    "Setting access_denied to true - Not a student (API response error)");

                return AuthResponseModel.error(
                    'ACCESS_DENIED: Hanya akun mahasiswa yang diizinkan');
              }
            } catch (e) {
              // Remove token since verification failed
              await prefs.remove('token');

              ApiLogger.logError(
                verifyStudentUri.toString(),
                'Error verifying student status: ${e.toString()}',
                null,
              );

              print("Exception during student verification: $e");

              // Only set access_denied if there's a clear indication this isn't a student
              if (e.toString().contains('not a student') ||
                  e.toString().contains('no student found') ||
                  e.toString().contains('unauthorized')) {
                await prefs.setBool('access_denied', true);
                print(
                    "Setting access_denied to true - Exception indicates not a student");

                return AuthResponseModel.error(
                    'ACCESS_DENIED: Hanya akun mahasiswa yang diizinkan');
              }

              // For other errors, don't block access as this could be a temporary error
              return AuthResponseModel.error(
                  'Error verifying student status: ${e.toString()}');
            }

            // If we reach here, verification succeeded, save user data permanently
            await prefs.setInt('user_id', userId);
            await prefs.setString('auth_token', jsonResponse['token']);

            // Save refresh token if available
            if (jsonResponse.containsKey('refresh_token')) {
              await prefs.setString(
                  'refresh_token', jsonResponse['refresh_token']);
            }

            ApiLogger.logRequest(
              method: 'INFO',
              url: 'Student verification successful',
              body: {'user_id': userId},
            );
          } else {
            ApiLogger.logError(
              uri.toString(),
              'Authentication succeeded but user data is missing',
              null,
            );
            return AuthResponseModel.error('User data not found in response');
          }

          // Create a proper response structure
          final userData = {
            'success': true,
            'message': 'Login successful',
            'data': {
              'token': jsonResponse['token'],
              'user': {
                'id': userId?.toString() ?? '',
                'username': username,
                'name':
                    jsonResponse['user'] != null && jsonResponse['user'] is Map
                        ? jsonResponse['user']['username'] ?? 'User'
                        : 'User'
              }
            }
          };

          return AuthResponseModel.fromJson(userData);
        } else {
          ApiLogger.logError(
            uri.toString(),
            'Authentication failed: ${jsonResponse['message'] ?? 'No error message'}',
            null,
          );
          return AuthResponseModel.error('Username atau password salah');
        }
      } else if (response.statusCode == 401) {
        ApiLogger.logError(
          uri.toString(),
          'Authentication failed: Invalid credentials',
          null,
        );

        // Don't set access_denied flag for invalid credentials
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('access_denied', false);

        return AuthResponseModel.error('Username atau password salah');
      } else {
        ApiLogger.logError(
          uri.toString(),
          'Server error: ${response.statusCode}',
          null,
        );
        return AuthResponseModel.error('Server error: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      ApiLogger.logError(
        ApiConstants.campusAuthEndpoint,
        'Login error: ${e.toString()}',
        stackTrace,
      );
      return AuthResponseModel.error('Connection error: ${e.toString()}');
    }
  }

  // Helper method to safely parse JSON for logging
  dynamic _safeParseJson(String text) {
    try {
      return json.decode(text);
    } catch (e) {
      return text;
    }
  }
}
