import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/service_model.dart';
import 'service_card.dart';

class ServicesPreview extends StatelessWidget {
  const ServicesPreview({super.key});

  // Aperçu catalogue adapté aux nouvelles images (noms en minuscules)
  final List<ServiceModel> demoServices = const [
    ServiceModel(
      id: 'epi-securite',
      title: 'EPI & Sécurité',
      excerpt: 'Gants, casques, chaussures et équipements conformes aux normes.',
      imageUrl: 'assets/images/services/mref6.jpg',
    ),
    ServiceModel(
      id: 'lubrifiants-entretien',
      title: 'Lubrifiants & Entretien',
      excerpt: 'Sprays dégrippants, lubrifiants, produits anticorrosion.',
      imageUrl: 'assets/images/services/mref.jpg',
    ),
    ServiceModel(
      id: 'pneumatiques',
      title: 'Pneumatiques & Accessoires Auto',
      excerpt: 'Pneus, valves, kits réparation et consommables atelier.',
      imageUrl: 'assets/images/services/mref0.jpg',
    ),
    ServiceModel(
      id: 'plomberie',
      title: 'Plomberie & Robinetterie',
      excerpt: 'Vannes, raccords, tuyaux et pièces de maintenance.',
      imageUrl: 'assets/images/services/mref1.jpg',
    ),
    ServiceModel(
      id: 'consommables-mro',
      title: 'Consommables & MRO',
      excerpt: 'Nettoyants, adhésifs, cartouches et fournitures de maintenance.',
      imageUrl: 'assets/images/services/mref10.jpg',
    ),
    ServiceModel(
      id: 'equipements-divers',
      title: 'Équipements & Accessoires',
      excerpt: 'Outillage, mobilier d’atelier et solutions sur mesure.',
      imageUrl: 'assets/images/services/mref11.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Nos catégories de produits', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: demoServices.map((s) => ServiceCard(service: s)).toList(),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => context.go('/services'),
              child: const Text('Voir le catalogue complet'),
            ),
          ),
        ],
      ),
    );
  }
}
