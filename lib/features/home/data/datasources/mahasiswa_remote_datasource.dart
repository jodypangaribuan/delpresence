import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/mahasiswa_model.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/http_override.dart';
import '../../../../core/utils/api_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class MahasiswaRemoteDataSource {
  Future<MahasiswaComplete> getMahasiswaData(int userId);
}

class MahasiswaRemoteDataSourceImpl implements MahasiswaRemoteDataSource {
  final http.Client client;
  final SharedPreferences sharedPreferences;

  MahasiswaRemoteDataSourceImpl({
    required this.client,
    required this.sharedPreferences,
  });

  @override
  Future<MahasiswaComplete> getMahasiswaData(int userId) async {
    final token = sharedPreferences.getString('token');
    if (token == null) {
      ApiLogger.logError(
        'getMahasiswaData',
        'Token not found in SharedPreferences',
        null,
      );
      throw ServerException('Token not found');
    }

    final url =
        Uri.parse('${ApiConstants.mahasiswaCompleteEndpoint}?user_id=$userId');

    try {
      // Log the request
      ApiLogger.logRequest(
        method: 'GET',
        url: url.toString(),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${token.substring(0, 10)}...',
        },
      );

      final startTime = DateTime.now();
      final response = await client.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
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

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse['status'] == 'success' &&
            jsonResponse.containsKey('data')) {
          return MahasiswaComplete.fromJson(jsonResponse['data']);
        } else {
          final errorMessage =
              jsonResponse['message'] ?? 'Failed to get student data';
          ApiLogger.logError(
            url.toString(),
            'API returned success status code but with error: $errorMessage',
            null,
          );
          throw ServerException(errorMessage);
        }
      } else if (response.statusCode == 401) {
        // Could add token refresh logic here
        ApiLogger.logError(
          url.toString(),
          'Unauthorized: Token might be expired',
          null,
        );
        throw ServerException('Unauthorized: Please log in again');
      } else {
        ApiLogger.logError(
          url.toString(),
          'Server error with status code: ${response.statusCode}',
          null,
        );
        throw ServerException(
            'Failed to get student data. Status code: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      ApiLogger.logError(
        url.toString(),
        'Error fetching student data: ${e.toString()}',
        stackTrace,
      );
      throw ServerException(e.toString());
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
