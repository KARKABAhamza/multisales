// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../l10n/app_localizations.dart';

class Testimonial {
  final String quote;
  final String author;
  final String? caseStudyUrl;
  final String? photoAsset;

  const Testimonial({
    required this.quote,
    required this.author,
    this.caseStudyUrl,
    this.photoAsset,
  });
}

class PartnerLogo {
  final String name;
  final String assetPath;
  final String? websiteUrl;

  const PartnerLogo({
    required this.name,
    required this.assetPath,
    this.websiteUrl,
  });
}

class TestimonialsSection extends StatelessWidget {
  final List<Testimonial> items;

  const TestimonialsSection({super.key, List<Testimonial>? items})
      : items = items ?? const [
          Testimonial(
            quote: 'MultiSales helped us increase our sales by 35% in just 3 months.',
            author: 'Ahmed, CEO at SkyConnect',
            caseStudyUrl: 'https://multisales.example.com/cases/skyconnect',
          ),
          Testimonial(
            quote: 'A reliable partner with outstanding support and great product quality.',
            author: 'Sofia, Operations Manager at TechWave',
            caseStudyUrl: 'https://multisales.example.com/cases/techwave',
          ),
          Testimonial(
            quote: 'Their onboarding made our team productive from day one.',
            author: 'Youssef, Sales Director at AtlasCorp',
            caseStudyUrl: 'https://multisales.example.com/cases/atlascorp',
          ),
        ];

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (loc?.testimonialsAndReferences != null)
          Text(
            loc!.testimonialsAndReferences,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        if (loc?.testimonialsSubtitle != null) ...[
          const SizedBox(height: 8),
          Text(
            loc!.testimonialsSubtitle,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
        const SizedBox(height: 12),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: items
              .map((t) => _TestimonialCard(
                    quote: t.quote,
                    author: t.author,
                    caseStudyUrl: t.caseStudyUrl,
                    photoAsset: t.photoAsset,
                  ))
              .toList(),
        )
      ],
    );
  }
}

class _TestimonialCard extends StatelessWidget {
  final String quote;
  final String author;
  final String? caseStudyUrl;
  final String? photoAsset;

  const _TestimonialCard({
    required this.quote,
    required this.author,
    this.caseStudyUrl,
    this.photoAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (photoAsset != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    photoAsset!,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stack) => Icon(
                      Icons.person,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ] else ...[
                Icon(Icons.format_quote, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  quote,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            author,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
          ),
          const SizedBox(height: 8),
          if (caseStudyUrl != null)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () async {
                  final uri = Uri.parse(caseStudyUrl!);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
                icon: const Icon(Icons.chevron_right),
                label: Text(AppLocalizations.of(context)?.readCaseStudy ?? 'Read case study'),
              ),
            )
        ],
      ),
    );
  }
}

class TrustedBySection extends StatelessWidget {
  final List<PartnerLogo> partners;

  const TrustedBySection({super.key, List<PartnerLogo>? partners})
      : partners = partners ?? const [
          PartnerLogo(
            name: 'SkyConnect',
            assetPath: 'assets/images/multisales_logo.jpg',
            websiteUrl: 'https://skyconnect.example.com',
          ),
          PartnerLogo(
            name: 'TechWave',
            assetPath: 'assets/images/multisales_logo.jpg',
            websiteUrl: 'https://techwave.example.com',
          ),
          PartnerLogo(
            name: 'AtlasCorp',
            assetPath: 'assets/images/multisales_logo.jpg',
            websiteUrl: 'https://atlascorp.example.com',
          ),
        ];

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc?.theyTrustUs ?? 'They trust us',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: partners
              .map((p) => _LogoTile(
                    name: p.name,
                    assetPath: p.assetPath,
                    websiteUrl: p.websiteUrl,
                  ))
              .toList(),
        )
      ],
    );
  }
}

class _LogoTile extends StatelessWidget {
  final String name;
  final String assetPath;
  final String? websiteUrl;
  const _LogoTile({required this.name, required this.assetPath, this.websiteUrl});

  @override
  Widget build(BuildContext context) {
    final tile = Container(
      height: 48,
      width: 140,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Image.asset(
              assetPath,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stack) => Icon(
                Icons.broken_image,
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ),
        ],
      ),
    );

    final content = Tooltip(message: name, child: tile);
    if (websiteUrl == null) return content;
    return InkWell(
      onTap: () async {
        final uri = Uri.parse(websiteUrl!);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      borderRadius: BorderRadius.circular(8),
      child: content,
    );
  }
}
