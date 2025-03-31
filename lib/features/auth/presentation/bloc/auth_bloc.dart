import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/models/auth_response_model.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<LogoutEvent>(_onLogout);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
  }

  AuthRepository get repository => _authRepository;

  Future<void> _onLogin(
    LoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());

      final response = await _authRepository.login(
        username: event.username,
        password: event.password,
      );

      if (response.success && response.data != null) {
        emit(AuthSuccess(
          user: response.data!.user,
          message: response.message,
        ));
      } else {
        if (response.message.toLowerCase().contains('authentication failed') ||
            response.message.toLowerCase().contains('invalid credentials') ||
            response.message.toLowerCase().contains('login failed') ||
            response.message.toLowerCase().contains('incorrect') ||
            response.message.toLowerCase().contains('wrong') ||
            response.message.toLowerCase().contains('401')) {
          emit(AuthError('Username atau password salah'));
        } else {
          emit(AuthError(response.message));
        }
      }
    } catch (e) {
      final errorMsg = e.toString().toLowerCase();
      if (errorMsg.contains('authentication failed') ||
          errorMsg.contains('invalid credentials') ||
          errorMsg.contains('login failed') ||
          errorMsg.contains('unauthorized') ||
          errorMsg.contains('401')) {
        emit(AuthError('Username atau password salah'));
      } else {
        emit(AuthError(e.toString()));
      }
    }
  }

  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());

      // Get remember me state before clearing tokens
      final rememberMe = await _authRepository.getRememberMe();

      // If remember me is false, clear credentials
      if (!rememberMe) {
        await _authRepository.clearCredentials();
      }

      // Always clear tokens
      await _authRepository.clearToken();

      emit(AuthInitial());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      final isLoggedIn = await _authRepository.isLoggedIn();

      if (isLoggedIn) {
        // For simplicity, we're not fetching the user profile
        // In a full implementation, you'd fetch the user profile from API
        emit(const AuthAuthenticated());
      } else {
        emit(AuthInitial());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
