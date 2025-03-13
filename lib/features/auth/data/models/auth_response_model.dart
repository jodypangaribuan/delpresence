import 'user_model.dart';

class AuthResponseModel {
  final bool success;
  final String message;
  final AuthDataModel? data;

  AuthResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'] != null ? AuthDataModel.fromJson(json['data']) : null,
    );
  }
}

class AuthDataModel {
  final UserModel user;
  final TokensModel? tokens;

  AuthDataModel({
    required this.user,
    this.tokens,
  });

  factory AuthDataModel.fromJson(Map<String, dynamic> json) {
    try {
      // Pastikan json['user'] adalah Map<String, dynamic>
      if (json['user'] == null || !(json['user'] is Map<String, dynamic>)) {
        throw FormatException('Invalid user data format');
      }

      return AuthDataModel(
        user: UserModel.fromJson(json['user']),
        tokens: json['tokens'] != null
            ? TokensModel.fromJson(json['tokens'])
            : null,
      );
    } catch (e) {
      // Log error dan rethrow untuk penanganan di level yang lebih tinggi
      print('Error parsing AuthDataModel: $e');
      rethrow;
    }
  }
}

class TokensModel {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;

  TokensModel({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
  });

  factory TokensModel.fromJson(Map<String, dynamic> json) {
    return TokensModel(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      expiresIn: json['expires_in'] as int,
    );
  }
}
