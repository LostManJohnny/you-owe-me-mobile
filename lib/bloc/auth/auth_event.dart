// auth_event.dart
import 'package:freezed_annotation/freezed_annotation.dart';
part 'auth_event.freezed.dart';

@freezed
sealed class AuthEvent with _$AuthEvent {
  const factory AuthEvent.userChanged(Object? user) = AuthEventUserChanged;
  const factory AuthEvent.profileChanged({
    String? email,
    String? password,
    String? firstName,
    String? lastName,
    String? username,
    String? phone,
  }) = AuthEventProfileChanged;

  const factory AuthEvent.toggleMode() = AuthEventToggleMode;
  const factory AuthEvent.submitted() = AuthEventSubmitted;
  const factory AuthEvent.resetPasswordRequested() = AuthEventResetPasswordRequested;
  const factory AuthEvent.signOutRequested() = AuthEventSignOutRequested;
}
