import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/repositories/auth_repository.dart';

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class RegisterStudentEvent extends AuthEvent {
  final String nim;
  final String firstName;
  final String? middleName;
  final String? lastName;
  final String email;
  final String password;
  final String major;
  final String faculty;
  final String batch;

  const RegisterStudentEvent({
    required this.nim,
    required this.firstName,
    this.middleName,
    this.lastName,
    required this.email,
    required this.password,
    required this.major,
    required this.faculty,
    required this.batch,
  });

  @override
  List<Object?> get props => [
        nim,
        firstName,
        middleName,
        lastName,
        email,
        password,
        major,
        faculty,
        batch,
      ];
}

class RegisterLectureEvent extends AuthEvent {
  final String nip;
  final String firstName;
  final String? middleName;
  final String? lastName;
  final String email;
  final String password;
  final String position;

  const RegisterLectureEvent({
    required this.nip,
    required this.firstName,
    this.middleName,
    this.lastName,
    required this.email,
    required this.password,
    required this.position,
  });

  @override
  List<Object?> get props => [
        nip,
        firstName,
        middleName,
        lastName,
        email,
        password,
        position,
      ];
}

class LoginEvent extends AuthEvent {
  final String loginId;
  final String password;

  const LoginEvent({
    required this.loginId,
    required this.password,
  });

  @override
  List<Object?> get props => [loginId, password];
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
  final dynamic user;
  final String? message;
  final String userType;

  const AuthSuccess({
    required this.user,
    required this.userType,
    this.message,
  });

  @override
  List<Object?> get props => [user, message, userType];
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
    on<RegisterStudentEvent>(_onRegisterStudent);
    on<RegisterLectureEvent>(_onRegisterLecture);
    on<LoginEvent>(_onLogin);
    on<LogoutEvent>(_onLogout);
    on<GetCurrentUserEvent>(_onGetCurrentUser);
  }

  Future<void> _onRegisterStudent(
    RegisterStudentEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());

      final response = await _authRepository.registerStudent(
        nim: event.nim,
        firstName: event.firstName,
        middleName: event.middleName,
        lastName: event.lastName,
        email: event.email,
        password: event.password,
        major: event.major,
        faculty: event.faculty,
        batch: event.batch,
      );

      if (response.success && response.data != null) {
        emit(AuthSuccess(
          user: response.data!.user,
          userType: response.data!.userType,
          message: response.message,
        ));
      } else {
        emit(AuthError(response.message));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onRegisterLecture(
    RegisterLectureEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());

      final response = await _authRepository.registerLecture(
        nip: event.nip,
        firstName: event.firstName,
        middleName: event.middleName,
        lastName: event.lastName,
        email: event.email,
        password: event.password,
        position: event.position,
      );

      if (response.success && response.data != null) {
        emit(AuthSuccess(
          user: response.data!.user,
          userType: response.data!.userType,
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
        loginId: event.loginId,
        password: event.password,
      );

      if (response.success && response.data != null) {
        emit(AuthSuccess(
          user: response.data!.user,
          userType: response.data!.userType,
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
          userType: response.data!.userType,
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
