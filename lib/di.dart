import 'package:get_it/get_it.dart';
import 'package:you_owe_us/app_config.dart';
import 'package:you_owe_us/services/auth_service.dart';
import 'package:you_owe_us/services/base_service.dart';
import 'package:you_owe_us/navigation/app_router.dart';
import 'bloc/auth/auth_bloc.dart';

final sl = GetIt.instance; // service locator
T c<T extends Object>() => sl<T>(); // shorthand resolver

Future<void> setupDI(AppConfig config) async {
  // Core config
  sl.registerSingleton<AppConfig>(config);

  // Services
  sl.registerLazySingleton<AuthService>(() => AuthService());
  sl.registerLazySingleton<BaseService>(() => BaseService(c<AppConfig>()));

  // Router (depends on AuthService)
  sl.registerLazySingleton<AppRouter>(() => AppRouter(c<AuthService>()));

  // Blocs
  sl.registerFactory<AuthBloc>(() => AuthBloc(c<AuthService>()));
}
