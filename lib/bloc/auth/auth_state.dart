import 'package:equatable/equatable.dart';
import 'package:you_owe_us/domain/auth/user_profile.dart';

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
  final UserProfile? userProfile;

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
    this.userProfile,
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
    String? username,
    String? phone,
    AuthFormMode? mode,
    String? errorMessage,
    Object? user,
    UserProfile? userProfile,
  }) {
    return AuthState(
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      username: username ?? this.username,
      phone: phone ?? this.phone,
      mode: mode ?? this.mode,
      errorMessage: errorMessage,
      user: user ?? this.user,
      userProfile: userProfile ?? this.userProfile,
    );
  }

  factory AuthState.unauthenticated() => const AuthState(status: AuthStatus.unauthenticated);

  factory AuthState.authenticated(Object? user) => AuthState(status: AuthStatus.authenticated, user: user);

  @override
  List<Object?> get props => [
        status,
        email,
        password,
        firstName,
        lastName,
        phone,
        username,
        mode,
        errorMessage,
        user,
      ];
}
