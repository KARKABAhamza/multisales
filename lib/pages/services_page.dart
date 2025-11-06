import 'package:flutter/material.dart';
import '../presentation/widgets/sarlau_app_bar.dart';
import '../presentation/widgets/sarlau_footer.dart';
import '../l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../presentation/widgets/contact_section.dart';
import '../presentation/widgets/logos_grid_featured.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: const SarlauAppBar(),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text('Nos produits et fournitures', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(t.servicesIntroShort),
          const SizedBox(height: 24),
          Text('Nos prestations', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _Bullet(t.svcSourcing),
              _Bullet(t.svcIndustrialSupplies),
              _Bullet(t.svcHotelSupplies),
              _Bullet(t.svcConsumables),
              _Bullet(t.svcEPI),
              _Bullet(t.svcLogistics),
              _Bullet(t.svcContracts),
            ],
          ),
          const SizedBox(height: 24),
          Text(t.sectionWhatWeSell, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(t.whatWeSellIntro),
          const SizedBox(height: 12),
          const LogosGridFeatured(),
          const SizedBox(height: 24),
          // Section contact au-dessus du footer
          ContactSection(
            onRequestQuote: () => context.go('/contact'),
            onDownloadBrochure: () => launchUrl(Uri.parse('https://example.com/brochure.pdf')),
          ),
          const SizedBox(height: 24),
          const SarlauFooter(),
        ],
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet(this.text);
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 220),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
