import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:go_router/go_router.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:url_launcher/url_launcher.dart';
import '../../l10n/app_localizations.dart';

class ContactSalesCtaBlock extends StatelessWidget {
  const ContactSalesCtaBlock({super.key});

  static const String phone = '+212 784007410';
  static const String email = 'contact@multisales.ma';

  Future<void> _downloadOrShareBrochure(BuildContext context) async {
    try {
      final data = await rootBundle.load('assets/documents/brochure.pdf');
      final bytes = data.buffer.asUint8List();
      await Printing.sharePdf(bytes: bytes, filename: 'Brochure-MultiSales.pdf');
    } catch (e) {
      final doc = pw.Document();
      doc.addPage(
        pw.MultiPage(
          build: (ctx) => [
            pw.Header(level: 0, child: pw.Text('MULTISALES — Brochure Produits')),
            pw.Paragraph(text: 'Central d\'achat et fournisseur de matériels industriels, hôteliers et EPI.'),
            pw.SizedBox(height: 8),
            pw.Bullet(text: 'Sourcing & Achat centralisé : négociation fournisseurs, achats multi-catégories.'),
            pw.Bullet(text: 'Fournitures industrielles : pièces, outillage, composants.'),
            pw.Bullet(text: 'Fournitures hôtelières : linge, vaisselle, produits d\'accueil.'),
            pw.Bullet(text: 'Consommables : cartouches, produits d\'entretien, consommables techniques.'),
            pw.Bullet(text: 'EPI & Sécurité : casques, gants, chaussures, protections certifiées.'),
            pw.Bullet(text: 'Logistique & Stockage : préparation, stockage sécurisé, expédition rapide.'),
            pw.Bullet(text: 'Contrats & abonnements : réassort automatique, SLA.'),
            pw.SizedBox(height: 16),
            pw.Paragraph(text: 'Contact: $phone — $email'),
          ],
        ),
      );
      final generated = await doc.save();
      await Printing.sharePdf(bytes: generated, filename: 'Brochure-MultiSales.pdf');
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;

    return Card(
      color: cs.surfaceContainerHigh,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(t.contactSalesCta, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 12),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 24,
              runSpacing: 12,
              children: [
                _ContactChip(
                  icon: Icons.phone,
                  label: phone,
                  onTap: () => launchUrl(Uri.parse('tel:${phone.replaceAll(' ', '')}')),
                ),
                _ContactChip(
                  icon: Icons.email,
                  label: email,
                  onTap: () => launchUrl(Uri.parse('mailto:$email')),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: [
                ElevatedButton(
                  onPressed: () => context.go('/contact'),
                  child: Text(t.ctaRequestQuotePersonalized),
                ),
                OutlinedButton(
                  onPressed: () => context.go('/contact'),
                  child: Text(t.ctaContactPurchasing),
                ),
                OutlinedButton(
                  onPressed: () => context.go('/contact'),
                  child: Text(t.ctaReassortExpress),
                ),
                OutlinedButton(
                  onPressed: () => _downloadOrShareBrochure(context),
                  child: Text(t.ctaDownloadBrochure),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ContactChip({required this.icon, required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 8),
            Text(label),
          ],
        ),
      ),
    );
  }
}
