import 'package:flutter/material.dart';
import '../../models/logo.dart';

class LogosGrid extends StatelessWidget {
  final List<Logo> logos;
  final EdgeInsetsGeometry padding;

  const LogosGrid({super.key, required this.logos, this.padding = const EdgeInsets.symmetric(vertical: 8) });

  int _crossAxisCountForWidth(double w) {
    if (w >= 1200) return 6;
    if (w >= 900) return 5;
    if (w >= 700) return 4;
    if (w >= 500) return 3;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final count = _crossAxisCountForWidth(constraints.maxWidth);
        return GridView.builder(
          padding: padding,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: logos.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: count,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.3,
          ),
          itemBuilder: (context, index) {
            final item = logos[index];
            return Semantics(
              label: item.label,
              image: true,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.4)),
                ),
                padding: const EdgeInsets.all(12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    item.assetPath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stack) => Center(
                      child: Icon(Icons.image_not_supported, color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
