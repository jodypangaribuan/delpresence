import 'student_model.dart';
import 'lecture_model.dart';
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
  final dynamic user;
  final String userType;
  final TokensModel? tokens;

  AuthDataModel({
    required this.user,
    required this.userType,
    this.tokens,
  });

  factory AuthDataModel.fromJson(Map<String, dynamic> json) {
    // Extract user data based on user_type
    final userType = json['user_type'] as String? ?? '';
    dynamic user;

    if (json.containsKey('user') && json['user'] != null) {
      if (userType == 'student') {
        user = StudentModel.fromJson(json['user'] as Map<String, dynamic>);
      } else if (userType == 'lecture') {
        user = LectureModel.fromJson(json['user'] as Map<String, dynamic>);
      } else {
        user = UserModel.fromJson(json['user'] as Map<String, dynamic>);
      }
    }

    // Extract tokens if available
    TokensModel? tokens;
    if (json.containsKey('tokens') && json['tokens'] != null) {
      tokens = TokensModel.fromJson(json['tokens'] as Map<String, dynamic>);
    }

    return AuthDataModel(
      user: user,
      userType: userType,
      tokens: tokens,
    );
  }
}

class TokensModel {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;
  final String tokenType;

  TokensModel({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.tokenType,
  });

  factory TokensModel.fromJson(Map<String, dynamic> json) {
    return TokensModel(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      expiresIn: json['expires_in'] as int,
      tokenType: json['token_type'] as String? ?? 'Bearer',
    );
  }
}
