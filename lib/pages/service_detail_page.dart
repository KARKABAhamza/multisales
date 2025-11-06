import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../presentation/widgets/sarlau_app_bar.dart';
import '../presentation/widgets/sarlau_footer.dart';

class ServiceDetailPage extends StatelessWidget {
  final String serviceId;
  const ServiceDetailPage({required this.serviceId, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SarlauAppBar(),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text('Détail service: $serviceId', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 12),
          const Text('Description détaillée du service (Markdown rendu possible).'),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton(
              onPressed: () => context.go('/contact'),
              child: const Text('Demander un devis'),
            ),
          ),
          const SizedBox(height: 24),
          const SarlauFooter(),
        ],
      ),
    );
  }
}
