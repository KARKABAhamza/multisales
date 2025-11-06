// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../presentation/widgets/sarlau_app_bar.dart';
import '../presentation/widgets/sarlau_footer.dart';
import '../core/providers/optimized_auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SarlauAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            Text('Connexion', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 12),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Email'),
                    onSaved: (v) => email = v ?? '',
                    validator: (v) => v == null || !v.contains('@') ? 'Email invalide' : null,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Mot de passe'),
                    obscureText: true,
                    onSaved: (v) => password = v ?? '',
                    validator: (v) => v == null || v.isEmpty ? 'Champ requis' : null,
                  ),
                  const SizedBox(height: 12),
                  Consumer<OptimizedAuthProvider>(
                    builder: (context, auth, _) => ElevatedButton(
                      onPressed: auth.isLoading
                          ? null
                          : () async {
                              if (_formKey.currentState?.validate() ?? false) {
                                _formKey.currentState?.save();
                                final ok = await context.read<OptimizedAuthProvider>().login(email, password);
                                if (ok) {
                                  if (mounted) context.go('/');
                                } else if (auth.errorMessage != null) {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(auth.errorMessage!)),
                                    );
                                  }
                                }
                              }
                            },
                      child: auth.isLoading ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Se connecter'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const SarlauFooter(),
          ],
        ),
      ),
    );
  }
}
