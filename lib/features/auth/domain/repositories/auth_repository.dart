import '../../data/models/auth_response_model.dart';

abstract class AuthRepository {
  Future<AuthResponseModel> register({
    required String nimNip,
    required String name,
    required String email,
    required String password,
    required String userType,
  });

  Future<AuthResponseModel> login({
    required String nimNip,
    required String password,
  });

  Future<AuthResponseModel> refreshToken(String refreshToken);

  Future<AuthResponseModel> logout();

  Future<AuthResponseModel> getCurrentUser();
}
