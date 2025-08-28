import 'package:flutter/material.dart';
import '../../core/localization/app_localizations.dart';

class CentralizedLoginWidget extends StatelessWidget {
  final bool showEmailLogin;
  final bool showGoogleLogin;
  final void Function()? onEmailLogin;
  final void Function()? onGoogleLogin;
  final String? errorMessage;
  final bool isLoading;
  final Widget? mfaWidget;

  const CentralizedLoginWidget({
    super.key,
    this.showEmailLogin = true,
    this.showGoogleLogin = true,
    this.onEmailLogin,
    this.onGoogleLogin,
    this.errorMessage,
    this.isLoading = false,
    this.mfaWidget,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/multisales_logo.jpg',
                height: 120,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              localizations.welcomeToMultiSales,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            if (showEmailLogin)
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.email),
                  label: Text(localizations.signIn),
                  onPressed: isLoading ? null : onEmailLogin,
                ),
              ),
            if (showGoogleLogin)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      side: const BorderSide(color: Colors.grey),
                    ),
                    icon: const Icon(Icons.account_circle,
                        color: Colors.red, size: 24),
                    label: isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(localizations.oauthSignIn),
                    onPressed: isLoading ? null : onGoogleLogin,
                  ),
                ),
              ),
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            if (mfaWidget != null) ...[
              const SizedBox(height: 24),
              mfaWidget!,
            ],
          ],
        ),
      ),
    );
  }
}
