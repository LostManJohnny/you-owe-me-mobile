import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_event.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.bloc});

  final AuthBloc bloc;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            tooltip: 'Sign out',
            icon: const Icon(Icons.logout),
            onPressed: () => bloc.add(const SignOutRequested()),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.verified_user, size: 64),
            const SizedBox(height: 12),
            const Text('Signed in as'),
            const SizedBox(height: 4),
            Text(user?.email ?? '(no email)'),
          ],
        ),
      ),
    );
  }
}
