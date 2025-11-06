import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/services_provider.dart';
import '../../core/localization/app_localizations.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return ChangeNotifierProvider(
      create: (_) => ServicesProvider()..fetchServices(),
      child: Consumer<ServicesProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.errorMessage != null) {
            return Center(child: Text(provider.errorMessage!));
          }
          return Scaffold(
            appBar: AppBar(
              title: Text(localizations?.keyFeatures ?? 'Nos Services'),
            ),
            body: ListView.builder(
              padding: const EdgeInsets.all(24.0),
              itemCount: provider.services.length,
              itemBuilder: (context, index) {
                final service = provider.services[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  child: ListTile(
                    leading: service.imageUrl.isNotEmpty
                        ? Image.asset(service.imageUrl, width: 48)
                        : null,
                    title: Text(service.title),
                    subtitle: Text(service.description),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
