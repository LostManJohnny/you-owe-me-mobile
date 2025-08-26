import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'bloc/auth/auth_bloc.dart';
import 'firebase_options.dart';
import 'app_config.dart';
import 'di.dart';
import 'navigation/app_router.dart'; // <-- get_it setup

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env (so ENV is available)
  await dotenv.load(fileName: '.env', isOptional: false);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Build config from ENV
  final config = AppConfig(dotenv.env['ENV']);

  // Register everything in get_it
  await setupDI(config);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      // resolve bloc from get_it
      create: (_) => c<AuthBloc>(),
      child: MaterialApp.router(
        title: 'Firebase BLoC Auth',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        // resolve router from get_it
        routerConfig: c<AppRouter>().router,
      ),
    );
  }
}
