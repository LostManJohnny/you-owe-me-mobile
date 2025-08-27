import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

import 'package:you_owe_us/app_config.dart';
import 'package:you_owe_us/navigation/app_router.dart';
import 'package:you_owe_us/services/auth_service.dart';
import 'package:you_owe_us/services/base_web_service.dart';
import 'package:you_owe_us/services/user_profile_service.dart';
import 'bloc/auth/auth_bloc.dart';

final sl = GetIt.instance; // service locator
T c<T extends Object>() => sl<T>(); // shorthand resolver

Future<void> setupDI(AppConfig config) async {
  // Core
  sl.registerSingleton<AppConfig>(config);

  // Auth (no router/BaseService dependency)
  sl.registerLazySingleton<AuthService>(() => AuthService(c<UserProfileService>()));

  // Router (depends ONLY on the auth state stream)
  sl.registerLazySingleton<AppRouter>(
    () => AppRouter(FirebaseAuth.instance.authStateChanges()),
  );

  // Expose GoRouter directly for convenience
  sl.registerLazySingleton<GoRouter>(() => sl<AppRouter>().router);

  // HTTP base service(s) that need GoRouter for 403 handling
  sl.registerLazySingleton<BaseWebService>(
    () => BaseWebService(c<AppConfig>(), c<GoRouter>()),
  );

  // Services
  sl.registerLazySingleton<UserProfileService>(() => UserProfileService());

  // Blocs
  sl.registerFactory<AuthBloc>(() => AuthBloc(c<AuthService>()));
}
