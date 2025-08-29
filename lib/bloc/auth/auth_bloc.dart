import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:you_owe_us/domain/auth/user_profile.dart';
import 'package:you_owe_us/services/auth_service.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;
  late final StreamSubscription<User?> _sub;
  UserProfile? userProfile;

  AuthBloc(this._authService) : super(AuthState.unauthenticated()) {
    _sub = _authService.authStateChanges().listen(
          (user) => add(AuthEvent.userChanged(user)),
          onError: (_) => add(const AuthEvent.userChanged(null)),
        );

    on<AuthEvent>((event, emit) async {
      switch (event) {
        case AuthEventUserChanged(:final user):
          _onUserChanged(user, emit);

        case AuthEventProfileChanged(
            email: final email,
            password: final password,
            firstName: final firstName,
            lastName: final lastName,
            username: final username,
            phone: final phone,
          ):
          emit(state.copyWith(
            email: email ?? state.email,
            password: password ?? state.password,
            firstName: firstName ?? state.firstName,
            lastName: lastName ?? state.lastName,
            username: username ?? state.username,
            phone: phone ?? state.phone,
            errorMessage: null,
          ));

        case AuthEventToggleMode():
          final next = state.mode == AuthFormMode.signIn ? AuthFormMode.signUp : AuthFormMode.signIn;
          emit(state.copyWith(mode: next, errorMessage: null));

        case AuthEventSubmitted():
          await _submit(emit);

        case AuthEventResetPasswordRequested():
          await _resetPassword(emit);

        case AuthEventSignOutRequested():
          await _authService.signOut();
      }
    });
  }

  void _onUserChanged(Object? user, Emitter<AuthState> emit) {
    if (user is User) {
      emit(AuthState.authenticated(user));
    } else {
      // preserve form values + mode when unauthenticated
      emit(AuthState.unauthenticated().copyWith(
        email: state.email,
        password: state.password,
        firstName: state.firstName,
        lastName: state.lastName,
        username: state.username,
        phone: state.phone,
        mode: state.mode,
      ));
    }
  }

  Future<void> _submit(Emitter<AuthState> emit) async {
    if (!state.canSubmit) {
      emit(state.copyWith(errorMessage: 'Enter a valid email and 6+ char password.'));
      return;
    }
    emit(state.copyWith(status: AuthStatus.submitting, errorMessage: null));
    try {
      if (state.mode == AuthFormMode.signIn) {
        userProfile = await _authService.signIn(
          email: state.email.trim(),
          password: state.password,
        );
      } else {
        final profile = UserProfile(
          firstName: state.firstName.trim(),
          lastName: state.lastName.trim(),
          email: state.email.trim(),
          phone: state.phone.trim().isEmpty ? null : state.phone.trim(),
          username: state.username.trim().isEmpty ? null : state.username.trim(),
        );

        userProfile = await _authService.signUp(
          email: state.email.trim(),
          password: state.password,
          userProfile: profile,
        );
      }
      emit(state.copyWith(userProfile: userProfile, status: AuthStatus.success));
    } on FirebaseAuthException catch (ex) {
      emit(state.copyWith(status: AuthStatus.failure, errorMessage: _friendly(ex)));
    } catch (_) {
      emit(state.copyWith(status: AuthStatus.failure, errorMessage: 'Something went wrong.'));
    }
  }

  Future<void> _resetPassword(Emitter<AuthState> emit) async {
    final email = state.email.trim();
    if (!email.contains('@')) {
      emit(state.copyWith(errorMessage: 'Enter your email above to reset password.'));
      return;
    }
    emit(state.copyWith(status: AuthStatus.submitting, errorMessage: null));
    try {
      await _authService.sendPasswordResetEmail(email: email);
      emit(state.copyWith(status: AuthStatus.success));
    } on FirebaseAuthException catch (ex) {
      emit(state.copyWith(status: AuthStatus.failure, errorMessage: _friendly(ex)));
    }
  }

  String _friendly(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'That email looks invalid.';
      case 'user-not-found':
        return 'No account found for that email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'An account already exists for that email.';
      case 'weak-password':
        return 'Please choose a stronger password (min 6 chars).';
      case 'too-many-requests':
        return 'Too many attempts. Try again later.';
      default:
        return e.message ?? 'Authentication error occurred.';
    }
  }

  @override
  Future<void> close() async {
    await _sub.cancel();
    return super.close();
  }
}
