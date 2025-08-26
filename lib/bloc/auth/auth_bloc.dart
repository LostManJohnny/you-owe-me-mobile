import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:you_owe_us/services/auth_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;
  late final StreamSubscription<User?> _sub;

  AuthBloc(this._authService) : super(AuthState.unauthenticated()) {
    _sub = _authService.authStateChanges().listen(
          (user) => add(AuthUserChanged(user)),
          onError: (_) => add(const AuthUserChanged(null)),
        );

    on<AuthUserChanged>(_onUserChanged);
    on<EmailChanged>((e, emit) => emit(state.copyWith(email: e.email, errorMessage: null)));
    on<PasswordChanged>((e, emit) => emit(state.copyWith(password: e.password, errorMessage: null)));
    on<ToggleMode>((e, emit) {
      final next = state.mode == AuthFormMode.signIn ? AuthFormMode.signUp : AuthFormMode.signIn;
      emit(state.copyWith(mode: next, errorMessage: null));
    });
    on<Submitted>(_onSubmitted);
    on<ResetPasswordRequested>(_onResetPassword);
    on<SignOutRequested>(_onSignOut);
  }

  void _onUserChanged(AuthUserChanged e, Emitter<AuthState> emit) {
    if (e.user != null) {
      emit(AuthState.authenticated(e.user!));
    } else {
      emit(AuthState.unauthenticated().copyWith(
        email: state.email,
        password: state.password,
        mode: state.mode,
      ));
    }
  }

  Future<void> _onSubmitted(Submitted e, Emitter<AuthState> emit) async {
    if (!state.canSubmit) {
      emit(state.copyWith(errorMessage: 'Enter a valid email and 6+ char password.'));
      return;
    }
    emit(state.copyWith(status: AuthStatus.submitting, errorMessage: null));
    try {
      if (state.mode == AuthFormMode.signIn) {
        await _authService.signIn(email: state.email.trim(), password: state.password.trim());
      } else {
        await _authService.signUp(email: state.email.trim(), password: state.password.trim());
      }
      emit(state.copyWith(status: AuthStatus.success));
    } on FirebaseAuthException catch (ex) {
      emit(state.copyWith(status: AuthStatus.failure, errorMessage: _friendly(ex)));
    } catch (_) {
      emit(state.copyWith(status: AuthStatus.failure, errorMessage: 'Something went wrong.'));
    }
  }

  Future<void> _onResetPassword(ResetPasswordRequested e, Emitter<AuthState> emit) async {
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

  Future<void> _onSignOut(SignOutRequested e, Emitter<AuthState> emit) async {
    await _authService.signOut();
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
