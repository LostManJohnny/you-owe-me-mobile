import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:you_owe_us/navigation/common_scaffold.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_event.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final email = context.select<AuthBloc, String?>((b) => b.state.userProfile?.email);

    return CommonScaffold(
      title: 'Home',
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () => context.read<AuthBloc>().add(const AuthEvent.signOutRequested()),
        ),
      ],
      body: Center(
        child: email == null
            ? const CircularProgressIndicator()
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.verified_user, size: 64),
                  const SizedBox(height: 12),
                  const Text('Signed in as'),
                  const SizedBox(height: 4),
                  Text(email),
                ],
              ),
      ),
    );
  }
}
