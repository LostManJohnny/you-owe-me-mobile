// navigation/app_router.dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../bloc/auth/auth_bloc.dart';
import '../ui/login_page.dart';
import '../ui/home_page.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription _sub;
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _sub = stream.asBroadcastStream().listen((_) => notifyListeners());
  }
  @override
  void dispose() { _sub.cancel(); super.dispose(); }
}

class AppRouter {
  AppRouter(Stream<User?> authStateStream);

  late final GoRouter router = GoRouter(
    initialLocation: '/home',
    refreshListenable: GoRouterRefreshStream(
      FirebaseAuth.instance.authStateChanges(), // or pass the stream via ctor
    ),
    redirect: (context, state) {
      final user = FirebaseAuth.instance.currentUser;
      final loggingIn = state.matchedLocation == '/login';

      // Allow explicit 403 redirect to /login
      final outOfDate = (state.extra as Map?)?['clientOutOfDate'] == true
          || state.uri.queryParameters['clientOutOfDate'] == 'true';

      if (outOfDate) return null;
      if (user == null) return loggingIn ? null : '/login';
      if (loggingIn) return '/home';
      return null;
    },
    routes: [
      GoRoute(
        name: 'login',
        path: '/login',
        builder: (context, state) {
          final extra = state.extra as Map?;
          final clientOutOfDate = extra?['clientOutOfDate'] == true
              || state.uri.queryParameters['clientOutOfDate'] == 'true';
          return LoginPage(
            bloc: context.read<AuthBloc>(),
            clientOutOfDate: clientOutOfDate,
          );
        },
      ),
      GoRoute(
        name: 'home',
        path: '/home',
        builder: (context, state) => HomePage(),
      ),
    ],
  );
}
