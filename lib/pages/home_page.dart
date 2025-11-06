import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../presentation/widgets/sarlau_app_bar.dart';
import '../presentation/widgets/sarlau_footer.dart';
import '../presentation/widgets/hero_section.dart';
import '../presentation/widgets/services_preview.dart';
import '../presentation/widgets/logos_grid_featured.dart';
import '../design/design_tokens.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SarlauAppBar(),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hero
              HeroSection(
                onPrimaryCTA: () => context.go('/contact'),
                onSecondaryCTA: () => context.go('/expertise'),
              ),

              // Services preview (generic MULTISALES offering)
              ServicesPreview(),

              // Logos / partners (grid)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: LogosGridFeatured(),
              ),

              const SizedBox(height: 24),

              // Contact band CTA
              Container(
                color: DesignTokens.primary,
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        'Besoin d\'un réassort rapide ou d\'un devis personnalisé ? Contactez notre équipe commerciale.',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () => context.go('/contact'),
                      style: ElevatedButton.styleFrom(backgroundColor: DesignTokens.secondary),
                      child: const Text('Demander un devis'),
                    )
                  ],
                ),
              ),

              const SarlauFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
 
