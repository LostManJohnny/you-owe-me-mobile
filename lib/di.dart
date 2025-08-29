import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

import 'package:you_owe_us/app_config.dart';
import 'package:you_owe_us/navigation/app_router.dart';
import 'package:you_owe_us/services/auth_service.dart';
import 'package:you_owe_us/services/base_web_service.dart';
import 'package:you_owe_us/services/user_profile_service.dart';
import 'bloc/auth/auth_bloc.dart';

final sl = GetIt.instance;

T c<T extends Object>() => sl<T>();

Future<void> setupDI(AppConfig config) async {
  // region Core
  sl.registerSingleton<AppConfig>(config);
  // endregion

  // region Router
  sl.registerLazySingleton<AppRouter>(
    () => AppRouter(FirebaseAuth.instance.authStateChanges()),
  );
  sl.registerLazySingleton<GoRouter>(() => sl<AppRouter>().router);
  // endregion

  // region Web layer
  sl.registerLazySingleton<BaseWebService>(
    () => BaseWebService(c<AppConfig>(), c<GoRouter>()),
  );
  // endregion

  // region Domain services
  sl.registerLazySingleton<UserProfileService>(
    () => UserProfileService(),
  );

  sl.registerLazySingleton<AuthService>(
    () => AuthService(c<UserProfileService>()),
  );

  // endregion

  // region Bloc
  sl.registerFactory<AuthBloc>(() => AuthBloc(c<AuthService>()));
  // endregion
}
