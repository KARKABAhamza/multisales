import 'package:flutter/material.dart';
import '../../data/logos.dart';
import '../../models/logo.dart';
import '../../l10n/app_localizations.dart';

class LogosGridFeatured extends StatelessWidget {
  final double spacing;
  final double cardElevation;

  const LogosGridFeatured({super.key, this.spacing = 12, this.cardElevation = 2});

  int _columnsForWidth(double w) {
    if (w >= 1400) return 6;
    if (w >= 1100) return 5;
    if (w >= 800) return 4;
    if (w >= 600) return 3;
    if (w >= 400) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final cols = _columnsForWidth(constraints.maxWidth);
      return Padding(
        padding: EdgeInsets.all(spacing),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: logos.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            childAspectRatio: 1.4,
          ),
          itemBuilder: (context, index) {
            final logo = logos[index];
            return _LogoCard(logo: logo, elevation: cardElevation);
          },
        ),
      );
    });
  }
}

class _LogoCard extends StatelessWidget {
  final Logo logo;
  final double elevation;
  const _LogoCard({required this.logo, required this.elevation});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        onTap: () => _showPreview(context, logo),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Semantics(
                  label: logo.label,
                  child: Image.asset(
                    logo.assetPath,
                    fit: BoxFit.contain,
                    width: double.infinity,
                    errorBuilder: (context, error, stack) => const Icon(Icons.broken_image),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                logo.label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPreview(BuildContext context, Logo logo) {
    final t = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(logo.label, style: Theme.of(context).textTheme.titleLarge),
            ),
            Container(
              color: Colors.black,
              constraints: const BoxConstraints(maxHeight: 400),
              child: Image.asset(logo.assetPath, fit: BoxFit.contain),
            ),
            TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(t.closeLabel)),
            const SizedBox(height: 4),
          ]),
        );
      },
    );
  }
}
