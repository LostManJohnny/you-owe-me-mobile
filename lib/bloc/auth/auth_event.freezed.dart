// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuthEvent {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is AuthEvent);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AuthEvent()';
  }
}

/// @nodoc
class $AuthEventCopyWith<$Res> {
  $AuthEventCopyWith(AuthEvent _, $Res Function(AuthEvent) __);
}

/// @nodoc

class AuthEventUserChanged implements AuthEvent {
  const AuthEventUserChanged(this.user);

  final Object? user;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AuthEventUserChangedCopyWith<AuthEventUserChanged> get copyWith =>
      _$AuthEventUserChangedCopyWithImpl<AuthEventUserChanged>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AuthEventUserChanged &&
            const DeepCollectionEquality().equals(other.user, user));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(user));

  @override
  String toString() {
    return 'AuthEvent.userChanged(user: $user)';
  }
}

/// @nodoc
abstract mixin class $AuthEventUserChangedCopyWith<$Res>
    implements $AuthEventCopyWith<$Res> {
  factory $AuthEventUserChangedCopyWith(AuthEventUserChanged value,
          $Res Function(AuthEventUserChanged) _then) =
      _$AuthEventUserChangedCopyWithImpl;
  @useResult
  $Res call({Object? user});
}

/// @nodoc
class _$AuthEventUserChangedCopyWithImpl<$Res>
    implements $AuthEventUserChangedCopyWith<$Res> {
  _$AuthEventUserChangedCopyWithImpl(this._self, this._then);

  final AuthEventUserChanged _self;
  final $Res Function(AuthEventUserChanged) _then;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? user = freezed,
  }) {
    return _then(AuthEventUserChanged(
      freezed == user ? _self.user : user,
    ));
  }
}

/// @nodoc

class AuthEventProfileChanged implements AuthEvent {
  const AuthEventProfileChanged(
      {this.email,
      this.password,
      this.firstName,
      this.lastName,
      this.username,
      this.phone});

  final String? email;
  final String? password;
  final String? firstName;
  final String? lastName;
  final String? username;
  final String? phone;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AuthEventProfileChangedCopyWith<AuthEventProfileChanged> get copyWith =>
      _$AuthEventProfileChangedCopyWithImpl<AuthEventProfileChanged>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AuthEventProfileChanged &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.phone, phone) || other.phone == phone));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, email, password, firstName, lastName, username, phone);

  @override
  String toString() {
    return 'AuthEvent.profileChanged(email: $email, password: $password, firstName: $firstName, lastName: $lastName, username: $username, phone: $phone)';
  }
}

/// @nodoc
abstract mixin class $AuthEventProfileChangedCopyWith<$Res>
    implements $AuthEventCopyWith<$Res> {
  factory $AuthEventProfileChangedCopyWith(AuthEventProfileChanged value,
          $Res Function(AuthEventProfileChanged) _then) =
      _$AuthEventProfileChangedCopyWithImpl;
  @useResult
  $Res call(
      {String? email,
      String? password,
      String? firstName,
      String? lastName,
      String? username,
      String? phone});
}

/// @nodoc
class _$AuthEventProfileChangedCopyWithImpl<$Res>
    implements $AuthEventProfileChangedCopyWith<$Res> {
  _$AuthEventProfileChangedCopyWithImpl(this._self, this._then);

  final AuthEventProfileChanged _self;
  final $Res Function(AuthEventProfileChanged) _then;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? email = freezed,
    Object? password = freezed,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? username = freezed,
    Object? phone = freezed,
  }) {
    return _then(AuthEventProfileChanged(
      email: freezed == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      password: freezed == password
          ? _self.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
      firstName: freezed == firstName
          ? _self.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _self.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      username: freezed == username
          ? _self.username
          : username // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _self.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class AuthEventToggleMode implements AuthEvent {
  const AuthEventToggleMode();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is AuthEventToggleMode);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AuthEvent.toggleMode()';
  }
}

/// @nodoc

class AuthEventSubmitted implements AuthEvent {
  const AuthEventSubmitted();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is AuthEventSubmitted);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AuthEvent.submitted()';
  }
}

/// @nodoc

class AuthEventResetPasswordRequested implements AuthEvent {
  const AuthEventResetPasswordRequested();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AuthEventResetPasswordRequested);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AuthEvent.resetPasswordRequested()';
  }
}

/// @nodoc

class AuthEventSignOutRequested implements AuthEvent {
  const AuthEventSignOutRequested();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AuthEventSignOutRequested);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AuthEvent.signOutRequested()';
  }
}

// dart format on
