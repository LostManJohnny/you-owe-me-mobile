import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:you_owe_us/services/auth_service.dart';

import '../bloc/auth/auth_bloc.dart';
import '../ui/login_page.dart';
import '../ui/home_page.dart';

/// Simple ChangeNotifier that ticks whenever the stream emits.
/// go_router listens to this to re-run `redirect`.
class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription _sub;

  GoRouterRefreshStream(Stream<dynamic> stream) {
    _sub = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

class AppRouter {
  AppRouter(this._authService);

  final AuthService _authService;

  late final router = GoRouter(
    initialLocation: '/home',
    // Re-run redirects whenever Firebase auth state changes:
    refreshListenable: GoRouterRefreshStream(_authService.authStateChanges()),
    redirect: (context, state) {
      final user = FirebaseAuth.instance.currentUser;
      final loggingIn = state.matchedLocation == '/login';

      if (user == null) {
        // Not logged in -> go to /login unless we're already there
        return loggingIn ? null : '/login';
      }

      // Logged in -> keep away from /login
      if (loggingIn) return '/home';

      return null; // no redirect
    },
    routes: [
// ... inside MyApp build, using go_router route builder as example:
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginPage(bloc: context.read<AuthBloc>()),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => HomePage(bloc: context.read<AuthBloc>()),
      ),
    ],
  );
}
