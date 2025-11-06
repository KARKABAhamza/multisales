// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../design/design_tokens.dart';

class HeroSection extends StatelessWidget {
  final VoidCallback? onPrimaryCTA;
  final VoidCallback? onSecondaryCTA;

  const HeroSection({super.key, this.onPrimaryCTA, this.onSecondaryCTA});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 900;
    final heroHeight = isWide ? 420.0 : 420.0;

    return SizedBox(
      width: double.infinity,
      height: heroHeight,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background image (asset)
          Image.asset(
            'assets/images/hero_bg.jpg',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: DesignTokens.primary.withOpacity(0.06),
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.all(20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520, maxHeight: 320),
                  child: Image.asset('assets/images/multisales_logo.jpg', fit: BoxFit.contain),
                ),
              );
            },
          ),

          // Dark overlay to increase text contrast
          Container(
            color: Colors.black.withOpacity(0.45),
          ),

          // Content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isWide ? 64.0 : 20.0, vertical: 28),
            child: Row(
              children: [
                Expanded(
                  flex: isWide ? 6 : 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'MULTISALES — Fournisseur & Central d’Achat Multicatégorie',
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.6,
                            ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: isWide ? 520 : double.infinity,
                        child: Text(
                          'Achat et revente de matériels et fournitures : industriel, hôtelier, consommables, EPI et équipements divers. '
                          'Un interlocuteur unique pour simplifier vos approvisionnements, réduire vos délais et optimiser vos coûts.',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white70),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        children: [
                          ElevatedButton(
                            onPressed: onPrimaryCTA,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: DesignTokens.primary,
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                            ),
                            child: const Text('Demander un devis personnalisé'),
                          ),
                          OutlinedButton(
                            onPressed: onSecondaryCTA,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Colors.white70),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                            child: const Text('Voir nos catégories'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                if (isWide) ...[
                  const SizedBox(width: 40),
                  Expanded(
                    flex: 4,
                    child: Align(
                      alignment: Alignment.center,
                      child: Card(
                        color: Colors.transparent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 420, maxHeight: 260),
                            child: Image.asset(
                              'assets/images/multisales_logo.jpg',
                              fit: BoxFit.contain,
                              errorBuilder: (c, e, s) => const SizedBox.shrink(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
