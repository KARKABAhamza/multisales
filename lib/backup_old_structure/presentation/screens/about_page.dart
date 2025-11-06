import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/about_provider.dart';
import '../../core/localization/app_localizations.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return ChangeNotifierProvider(
      create: (_) => AboutProvider(),
      child: Consumer<AboutProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text(localizations?.aboutMultiSales ?? 'À Propos'),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations?.ourMission ?? 'Notre mission',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    localizations?.missionStatement ?? 'Accompagner les entreprises dans leur transformation digitale.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    localizations?.keyFeatures ?? 'Nos valeurs',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    localizations?.keyFeaturesDesc ?? 'Innovation, sécurité, accompagnement client.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    localizations?.securityPrivacy ?? 'Sécurité & Confidentialité',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    localizations?.securityPrivacyDesc ?? 'Vos données sont protégées et confidentielles.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Équipe',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  // À personnaliser avec les membres de l'équipe
                  Text(
                    'Notre équipe est composée de professionnels passionnés par la transformation digitale.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
