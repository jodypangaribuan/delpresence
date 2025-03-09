import 'package:delcommerce/core/depandancy_injection/service_locator.dart';
import 'package:delcommerce/core/usecase/usecase.dart';
import 'package:delcommerce/features/auth/data/models/login_response.dart';
import 'package:delcommerce/features/auth/domain/repository/auth_repo.dart';

class GetCachedUserUsecase extends UseCase<LoginUserData?, NoParams> {
  @override
  Future<LoginUserData?> call({NoParams? param}) async {
    return await sl<AuthRepo>().getCachedUser();
  }
}
