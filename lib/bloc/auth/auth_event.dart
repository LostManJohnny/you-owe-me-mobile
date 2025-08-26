import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthUserChanged extends AuthEvent {
  final Object? user;

  const AuthUserChanged(this.user);

  @override
  List<Object?> get props => [user];
}

class EmailChanged extends AuthEvent {
  final String email;

  const EmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

class PasswordChanged extends AuthEvent {
  final String password;

  const PasswordChanged(this.password);

  @override
  List<Object?> get props => [password];
}

class ToggleMode extends AuthEvent {
  const ToggleMode();
}

class Submitted extends AuthEvent {
  const Submitted();
}

class ResetPasswordRequested extends AuthEvent {
  const ResetPasswordRequested();
}

class SignOutRequested extends AuthEvent {
  const SignOutRequested();
}
