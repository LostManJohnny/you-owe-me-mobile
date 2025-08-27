import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_event.dart';
import '../bloc/auth/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.bloc, this.clientOutOfDate = false});

  final AuthBloc bloc;
  final bool clientOutOfDate;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _emailCtrl;
  late final TextEditingController _pwCtrl;
  late final TextEditingController _firstNameCtrl;
  late final TextEditingController _lastNameCtrl;
  late final TextEditingController _usernameCtrl;

  @override
  void initState() {
    super.initState();
    final s = widget.bloc.state;
    _emailCtrl = TextEditingController(text: s.email);
    _pwCtrl = TextEditingController(text: s.password);
    _firstNameCtrl = TextEditingController(text: s.firstName);
    _lastNameCtrl = TextEditingController(text: s.lastName);
    _usernameCtrl = TextEditingController(text: s.username);
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _pwCtrl.dispose();
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _usernameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocSelector<AuthBloc, AuthState, AuthFormMode>(
          bloc: widget.bloc,
          selector: (s) => s.mode,
          builder: (_, mode) => Text(mode == AuthFormMode.signIn ? 'Sign in' : 'Create account'),
        ),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        bloc: widget.bloc,
        listenWhen: (prev, curr) => prev.errorMessage != curr.errorMessage,
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          }
          if (widget.clientOutOfDate) {
            ScaffoldMessenger.of(context).showMaterialBanner(
              MaterialBanner(
                content: const Text('Your app is out of date. Please sign in again.'),
                leading: const Icon(Icons.warning_amber),
                actions: [
                  TextButton(
                    onPressed: () => ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
                    child: const Text('Dismiss'),
                  ),
                ],
              ),
            );
          }
        },
        buildWhen: (prev, curr) => prev.status != curr.status || prev.mode != curr.mode,
        builder: (context, state) {
          final isLoading = state.status == AuthStatus.submitting;

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _emailCtrl,
                      onChanged: (v) => widget.bloc.add(AuthEvent.profileChanged(email: v)),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      autofillHints: const [AutofillHints.username, AutofillHints.email],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _pwCtrl,
                      onChanged: (v) => widget.bloc.add(AuthEvent.profileChanged(password: v)),
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                      autofillHints: const [AutofillHints.password],
                    ),
                    if (state.mode == AuthFormMode.signUp) ...[
                      const SizedBox(height: 12),
                      TextField(
                        controller: _firstNameCtrl,
                        onChanged: (v) => widget.bloc.add(AuthEvent.profileChanged(firstName: v)),
                        decoration: const InputDecoration(
                          labelText: 'First Name',
                          border: OutlineInputBorder(),
                        ),
                        autofillHints: const [AutofillHints.name],
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _lastNameCtrl,
                        onChanged: (v) => widget.bloc.add(AuthEvent.profileChanged(lastName: v)),
                        decoration: const InputDecoration(
                          labelText: 'Last Name',
                          border: OutlineInputBorder(),
                        ),
                        autofillHints: const [AutofillHints.familyName],
                      ),
                      const SizedBox(height: 12),
                      IntlPhoneField(
                        decoration: const InputDecoration(
                          labelText: 'Phone',
                          border: OutlineInputBorder(),
                        ),
                        initialCountryCode: 'CA',
                        onChanged: (phone) => widget.bloc.add(
                          AuthEvent.profileChanged(phone: phone.completeNumber),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _usernameCtrl,
                        onChanged: (v) => widget.bloc.add(AuthEvent.profileChanged(username: v)),
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          border: OutlineInputBorder(),
                        ),
                        autofillHints: const [AutofillHints.username],
                      ),
                    ],
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: isLoading ? null : () => widget.bloc.add(const AuthEvent.submitted()),
                        child: isLoading
                            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                            : Text(state.mode == AuthFormMode.signIn ? 'Sign in' : 'Create account'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: isLoading ? null : () => widget.bloc.add(const AuthEvent.resetPasswordRequested()),
                      child: const Text('Forgot password?'),
                    ),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: isLoading ? null : () => widget.bloc.add(const AuthEvent.toggleMode()),
                      icon: const Icon(Icons.swap_horiz),
                      label: Text(
                        state.mode == AuthFormMode.signIn ? 'New here? Create an account' : 'Have an account? Sign in',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
