import 'package:flutter/material.dart';
import '../../design/design_tokens.dart';
import '../../l10n/app_localizations.dart';

class ContactCTA extends StatelessWidget {
  final VoidCallback? onRequestQuote;
  final VoidCallback? onContactProcurement;
  final VoidCallback? onExpressOrder;
  final VoidCallback? onDownloadPdf;
  const ContactCTA({
    super.key,
    this.onRequestQuote,
    this.onContactProcurement,
    this.onExpressOrder,
    this.onDownloadPdf,
  });

  ButtonStyle _primaryStyle() => ElevatedButton.styleFrom(
        backgroundColor: DesignTokens.primary,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        shadowColor: Colors.black26,
        elevation: 4,
      );

  ButtonStyle _outlineStyle() => OutlinedButton.styleFrom(
        foregroundColor: DesignTokens.primary,
    side: BorderSide(color: DesignTokens.primary.withValues(alpha: 0.7)),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      );

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Card(
      elevation: 0,
      color: Colors.transparent,
      margin: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 22.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        child: Column(
          children: [
            Text(
              t.contactSalesCta,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black87),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 12,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: onRequestQuote,
                  icon: const Icon(Icons.request_page, size: 18),
                  label: Text(t.ctaRequestQuotePersonalized),
                  style: _primaryStyle(),
                ),
                OutlinedButton.icon(
                  onPressed: onContactProcurement,
                  icon: const Icon(Icons.contact_page, size: 18),
                  label: Text(t.ctaContactPurchasing),
                  style: _outlineStyle(),
                ),
                OutlinedButton.icon(
                  onPressed: onExpressOrder,
                  icon: const Icon(Icons.flash_on, size: 18),
                  label: Text(t.ctaReassortExpress),
                  style: _outlineStyle(),
                ),
                OutlinedButton.icon(
                  onPressed: onDownloadPdf,
                  icon: const Icon(Icons.download, size: 18),
                  label: Text(t.ctaDownloadBrochure),
                  style: _outlineStyle(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
