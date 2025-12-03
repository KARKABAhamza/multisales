import 'package:flutter/material.dart';
import '../../design/design_tokens.dart';
import '../../l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class SarlauFooter extends StatelessWidget {
  const SarlauFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final year = DateTime.now().year;
    return Container(
      color: DesignTokens.primary,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            t.footerCompanyCasablanca,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.6,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            t.footerAddress,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 6),
          Text(
            t.footerContact,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 12),
          // Social icons row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                tooltip: 'LinkedIn',
                icon: const Icon(Icons.public, color: Colors.white),
                onPressed: () => _open('https://www.linkedin.com/company/multisales'),
              ),
              IconButton(
                tooltip: 'Facebook',
                icon: const Icon(Icons.thumb_up_alt_outlined, color: Colors.white),
                onPressed: () => _open('https://www.facebook.com/multisales'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '© $year MULTISALES. ${t.footerRightsReserved}',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white54),
          ),
        ],
      ),
    );
  }
}

Future<void> _open(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
