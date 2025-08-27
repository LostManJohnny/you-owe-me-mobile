import 'package:equatable/equatable.dart';

enum AuthFormMode { signIn, signUp }

enum AuthStatus { unknown, unauthenticated, authenticated, submitting, success, failure }

class AuthState extends Equatable {
  final AuthStatus status;
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String phone;
  final String username;
  final AuthFormMode mode;
  final String? errorMessage;
  final Object? user;

  const AuthState({
    this.status = AuthStatus.unknown,
    this.email = '',
    this.password = '',
    this.firstName = '',
    this.lastName = '',
    this.phone = '',
    this.username = '',
    this.mode = AuthFormMode.signIn,
    this.errorMessage,
    this.user,
  });

  bool get canSubmit =>
      email.trim().contains('@') &&
      password.trim().length >= 6 &&
      (mode == AuthFormMode.signIn ||
          (firstName.trim().isNotEmpty &&
              lastName.trim().isNotEmpty &&
              phone.trim().isNotEmpty &&
              username.trim().isNotEmpty));

  AuthState copyWith({
    AuthStatus? status,
    String? email,
    String? password,
    String? firstName,
    String? lastName,
    String? userName,
    String? phone,
    String? username,
    AuthFormMode? mode,
    String? errorMessage,
    Object? user,
  }) {
    return AuthState(
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
      mode: mode ?? this.mode,
      errorMessage: errorMessage,
      user: user ?? this.user,
    );
  }

  factory AuthState.unauthenticated() => const AuthState(status: AuthStatus.unauthenticated);

  factory AuthState.authenticated(Object user) => AuthState(status: AuthStatus.authenticated, user: user);

  @override
  List<Object?> get props => [status, email, password, mode, errorMessage, user];
}
