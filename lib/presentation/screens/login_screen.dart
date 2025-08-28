import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/services/auth_service.dart';

import 'package:provider/provider.dart';
import '../../core/providers/oauth_provider.dart';
import '../../core/localization/app_localizations.dart';
// Removed unused imports
import '../widgets/social_login_buttons.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  // bool _obscurePassword = true; // Unused, remove or implement if needed

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    final localizations = AppLocalizations.of(context)!;
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        final user = await _authService.signInWithEmailAndPassword(
          _emailController.text,
          _passwordController.text,
        );
        setState(() {
          _isLoading = false;
        });
        if (user.isSuccess && user.user != null) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(localizations.loginSuccess)),
            );
            context.go('/home');
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(localizations.loginFailed)),
            );
          }
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${localizations.error}: $e')),
          );
        }
      }
    }
  }

  // _resetPassword is unused. Remove or implement as needed for password reset feature.

  Future<void> _signInWithGoogle(BuildContext context) async {
    final oauthProvider = Provider.of<OAuthProvider>(context, listen: false);
    await oauthProvider.signIn();
    if (oauthProvider.errorMessage != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(oauthProvider.errorMessage!)),
      );
    }
  }

  void _showNotImplemented(BuildContext context, String provider) {
    final localizations = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(localizations.socialSignInNotImplemented(provider))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.loginTitle),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<OAuthProvider>(
          builder: (context, oauthProvider, _) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 32),
                  Text(
                    localizations.loginTitle,
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  // Email/password form
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: localizations.email,
                            border: const OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) => (value == null || value.isEmpty)
                              ? localizations.emailRequired
                              : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: localizations.password,
                            border: const OutlineInputBorder(),
                          ),
                          obscureText: true,
                          validator: (value) => (value == null || value.isEmpty)
                              ? localizations.passwordRequired
                              : null,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.login),
                          label: Text(localizations.signIn),
                          onPressed: _isLoading
                              ? null
                              : () {
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    _signIn();
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(48),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(localizations.orSignInWith),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Social login buttons
                  SocialLoginButtons(
                    isLoading: _isLoading || oauthProvider.isLoading,
                    errorMessage: oauthProvider.errorMessage,
                    onGoogle: oauthProvider.isLoading
                        ? null
                        : () async {
                            await _signInWithGoogle(context);
                          },
                    onFacebook: () => _showNotImplemented(context, 'Facebook'),
                    onApple: () => _showNotImplemented(context, 'Apple'),
                  ),
                  const SizedBox(height: 32),
                  TextButton(
                    onPressed: () {
                      // Navigate to AuthScreen and show the Sign Up tab
                      context.go('/auth', extra: {'tab': 'signup'});
                    },
                    child: Text(localizations.noAccount),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
