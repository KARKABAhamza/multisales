// lib/core/providers/provider_integration_example.dart

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'language_provider.dart';

/// Example showing how to integrate a public provider (e.g., LanguageProvider) with existing code
class PublicProviderIntegrationExample extends StatelessWidget {
  const PublicProviderIntegrationExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        final currentLocale = languageProvider.currentLocale;
        final supportedLocales = LanguageProvider.supportedLocales;
        final languageNames = LanguageProvider.languageNames;
        return Scaffold(
          appBar: AppBar(
            title: Text('Current Language: ${languageProvider.getLanguageName(currentLocale.languageCode)}'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Select your language:'),
                const SizedBox(height: 16),
                DropdownButton<String>(
                  value: currentLocale.languageCode,
                  items: supportedLocales.map((locale) {
                    final code = locale.languageCode;
                    return DropdownMenuItem<String>(
                      value: code,
                      child: Text(languageNames[code] ?? code.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      languageProvider.changeLanguageByCode(value);
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
// End of example
}

// All authentication usage examples removed for public-only logic
