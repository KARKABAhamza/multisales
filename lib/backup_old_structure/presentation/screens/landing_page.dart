import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/landing_provider.dart';
import '../../core/localization/app_localizations.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return ChangeNotifierProvider(
      create: (_) => LandingProvider(),
      child: Consumer<LandingProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Logo
                    Image.asset('assets/images/multisales_logo.jpg', height: 120),
                    const SizedBox(height: 32),
                    // Titre principal
                    Text(
                      localizations?.welcomeToMultiSales ?? 'Bienvenue sur MULTISALES',
                      style: Theme.of(context).textTheme.displayMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    // Slogan / proposition de valeur
                    Text(
                      localizations?.welcomeMessage ?? 'La plateforme digitale pour gérer et développer votre activité.',
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    // CTA principaux
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () => Navigator.pushNamed(context, '/services'),
                          child: Text(localizations?.learnMore ?? 'Découvrir les services'),
                        ),
                        const SizedBox(width: 16),
                        OutlinedButton(
                          onPressed: () => Navigator.pushNamed(context, '/login'),
                          child: Text(localizations?.signIn ?? 'Espace client'),
                        ),
                      ],
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
