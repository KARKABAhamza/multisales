import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/app_localizations.dart';
import '../../models/service_model.dart';

class ServiceCard extends StatelessWidget {
  final ServiceModel service;
  const ServiceCard({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.go('/services/${service.id}'),
        child: SizedBox(
          width: 320,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image area: supports local assets and network URLs
                SizedBox(
                  height: 120,
                  width: double.infinity,
                  child: () {
                    final url = service.imageUrl;
                    if (url == null || url.isEmpty) {
                      return Container(
                        color: Colors.grey[200],
                        alignment: Alignment.center,
                        child: const Icon(Icons.build, size: 56),
                      );
                    }
                    if (url.startsWith('assets/')) {
                      return Image.asset(url, fit: BoxFit.cover,
                          errorBuilder: (context, error, stack) => Container(
                                color: Colors.grey[200],
                                alignment: Alignment.center,
                                child: const Icon(Icons.broken_image, size: 40),
                              ));
                    }
                    return Image.network(url, fit: BoxFit.cover,
                        errorBuilder: (context, error, stack) => Container(
                              color: Colors.grey[200],
                              alignment: Alignment.center,
                              child: const Icon(Icons.broken_image, size: 40),
                            ));
                  }(),
                ),
                const SizedBox(height: 12),
                Text(service.title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(service.excerpt, maxLines: 3, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => context.go('/services/${service.id}'),
                    child: Text(t.learnMore),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
