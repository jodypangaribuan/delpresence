// login_status_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:delcommerce/core/depandancy_injection/service_locator.dart';
import 'package:delcommerce/features/auth/domain/usecases/is_logged_in_usecase.dart';
import 'package:delcommerce/features/auth/presentation/logic/login_status/login_status_state.dart';

class LoginStatusCubit extends Cubit<LoginStatusState> {
  final IsLoggedInUsecase isLoggedInUsecase;

  LoginStatusCubit({
    IsLoggedInUsecase? isLoggedInUsecase,
  })  : isLoggedInUsecase = isLoggedInUsecase ?? sl<IsLoggedInUsecase>(),
        super(const LoginStatusState());

  Future<void> checkLoginStatus() async {
    emit(state.copyWith(status: AuthStatus.checking));

    try {
      final isLoggedIn = await isLoggedInUsecase.call();
      emit(state.copyWith(
        status:
            isLoggedIn ? AuthStatus.authenticated : AuthStatus.unauthenticated,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: 'Error occurred while checking login status: $e',
      ));
    }
  }
}
