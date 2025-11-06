import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../l10n/app_localizations.dart';
import '../presentation/widgets/sarlau_app_bar.dart';
import '../presentation/widgets/sarlau_footer.dart';
import '../design/design_tokens.dart';

class ExpertisePage extends StatelessWidget {
  ExpertisePage({super.key});

  final List<Map<String, dynamic>> categories = [
    {
      'title': 'EPI & Sécurité',
      'image': 'assets/images/services/gants.jpg',
      'points': [
        'Gants de protection (chimie, mécanique, chaleur)',
        'Casques, lunettes, chaussures de sécurité',
        'Vestes, harnais et signalisation',
      ],
      'icon': Icons.security,
    },
    {
      'title': 'Lubrifiants & Entretien',
      'image': 'assets/images/services/mref.jpg',
      'points': [
        'Sprays multi‑usage (dégraissants, lubrifiants, dégrippants)',
        'Produits d’entretien et solutions anticorrosion',
        'Fournitures pour maintenance préventive',
      ],
      'icon': Icons.build,
    },
    {
      'title': 'Pneumatiques & Atelier Auto',
      'image': 'assets/images/services/mref1.jpg',
      'points': [
        'Pneus & chambres à air (véhicules légers et utilitaires)',
        'Accessoires montage / équilibrage',
        'Consommables pour ateliers (valves, colles, kits réparation)',
      ],
      'icon': Icons.directions_car,
    },
    {
      'title': 'Plomberie & Robinetterie',
      'image': 'assets/images/services/mref2.jpg',
      'points': [
        'Robinetterie, vannes et raccords',
        'Tuyauterie, joints et fournitures d’installation',
        'Produits pour maintenance réseaux eau / chauffage',
      ],
      'icon': Icons.plumbing,
    },
    {
      'title': 'Consommables & Produits MRO',
      'image': 'assets/images/services/mref3.jpg',
      'points': [
        'Nettoyants, solvants, chiffons techniques',
        'Cartouches, adhésifs, fixations, sécurité atelier',
        'Kits d’entretien et recharges',
      ],
      'icon': Icons.inbox,
    },
    {
      'title': 'Équipements & Accessoires divers',
      'image': 'assets/images/services/refm.jpg',
      'points': [
        'Petits équipements, outils manuels et électriques',
        'Mobilier d’atelier et rangement',
        'Solutions sur mesure selon besoin client',
      ],
      'icon': Icons.handyman,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: const SarlauAppBar(),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(t.sectionOurExpertiseTitle, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: categories.map((c) {
              final imagePath = (c['image']) as String;
              return _ExpertiseCard(
                title: c['title'] as String,
                points: List<String>.from(c['points'] as List),
                icon: c['icon'] as IconData,
                imagePath: imagePath,
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          const SarlauFooter(),
        ],
      ),
    );
  }
}

class _ExpertiseCard extends StatelessWidget {
  final String title;
  final List<String> points;
  final IconData icon;
  final String? imagePath;

  const _ExpertiseCard({required this.title, required this.points, required this.icon, this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        width: 320,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (imagePath != null)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
              child: Image.asset(
                imagePath!,
                width: double.infinity,
                height: 160,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stack) {
                  return Container(
                    height: 160,
                    color: Colors.grey[200],
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.broken_image, size: 36, color: Colors.black45),
                        SizedBox(height: 8),
                        Text('Image indisponible', style: TextStyle(color: Colors.black45)),
                      ],
                    ),
                  );
                },
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Icon(icon, size: 28, color: DesignTokens.primary),
                const SizedBox(width: 10),
                Expanded(child: Text(title, style: Theme.of(context).textTheme.titleLarge)),
              ]),
              const SizedBox(height: 10),
              ...points.map((p) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(children: [
                      const Icon(Icons.check, size: 14, color: Colors.black45),
                      const SizedBox(width: 8),
                      Expanded(child: Text(p)),
                    ]),
                  )),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => context.go('/contact'),
                  child: Text(AppLocalizations.of(context)!.finalCtaContact),
                ),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}
