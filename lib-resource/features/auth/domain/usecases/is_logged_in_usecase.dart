import 'package:delcommerce/core/depandancy_injection/service_locator.dart';
import 'package:delcommerce/core/usecase/usecase.dart';
import 'package:delcommerce/features/auth/domain/repository/auth_repo.dart';

class IsLoggedInUsecase extends UseCase<bool, NoParams> {
  @override
  Future<bool> call({NoParams? param}) async {
    return await sl<AuthRepo>().isLoggedIn();
  }
}
