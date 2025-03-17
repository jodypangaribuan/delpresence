import '../../data/models/auth_response_model.dart';

abstract class AuthRepository {
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
  });

  Future<AuthResponseModel> registerLecture({
    required String nip,
    required String firstName,
    String? middleName,
    String? lastName,
    required String email,
    required String password,
    required String position,
  });

  Future<AuthResponseModel> login({
    required String loginId,
    required String password,
  });

  Future<AuthResponseModel> refreshToken(String refreshToken);

  Future<AuthResponseModel> logout();

  Future<AuthResponseModel> getCurrentUser();
}
