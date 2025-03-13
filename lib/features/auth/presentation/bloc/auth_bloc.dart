import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/user_model.dart';
import '../../domain/repositories/auth_repository.dart';

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class RegisterEvent extends AuthEvent {
  final String nimNip;
  final String name;
  final String email;
  final String password;
  final String userType;

  const RegisterEvent({
    required this.nimNip,
    required this.name,
    required this.email,
    required this.password,
    required this.userType,
  });

  @override
  List<Object?> get props => [nimNip, name, email, password, userType];
}

class LoginEvent extends AuthEvent {
  final String nimNip;
  final String password;

  const LoginEvent({
    required this.nimNip,
    required this.password,
  });

  @override
  List<Object?> get props => [nimNip, password];
}

class LogoutEvent extends AuthEvent {}

class GetCurrentUserEvent extends AuthEvent {}

// States
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final UserModel user;
  final String? message;

  const AuthSuccess({
    required this.user,
    this.message,
  });

  @override
  List<Object?> get props => [user, message];
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<RegisterEvent>(_onRegister);
    on<LoginEvent>(_onLogin);
    on<LogoutEvent>(_onLogout);
    on<GetCurrentUserEvent>(_onGetCurrentUser);
  }

  Future<void> _onRegister(
    RegisterEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());

      final response = await _authRepository.register(
        nimNip: event.nimNip,
        name: event.name,
        email: event.email,
        password: event.password,
        userType: event.userType,
      );

      if (response.success && response.data != null) {
        emit(AuthSuccess(
          user: response.data!.user,
          message: response.message,
        ));
      } else {
        emit(AuthError(response.message));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogin(
    LoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());

      final response = await _authRepository.login(
        nimNip: event.nimNip,
        password: event.password,
      );

      if (response.success && response.data != null) {
        emit(AuthSuccess(
          user: response.data!.user,
          message: response.message,
        ));
      } else {
        emit(AuthError(response.message));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());

      final response = await _authRepository.logout();

      if (response.success) {
        emit(AuthInitial());
      } else {
        emit(AuthError(response.message));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onGetCurrentUser(
    GetCurrentUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());

      final response = await _authRepository.getCurrentUser();

      if (response.success && response.data != null) {
        emit(AuthSuccess(
          user: response.data!.user,
          message: response.message,
        ));
      } else {
        emit(AuthError(response.message));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
