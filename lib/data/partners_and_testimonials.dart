import 'package:multisales_app/presentation/widgets/testimonials_section.dart';

// Curated real-world-like testimonials (use your own customer names if needed)
const List<Testimonial> testimonialsData = [
  Testimonial(
    quote:
        'With MultiSales, we reduced our onboarding time from 3 weeks to 5 days and closed 28% more deals in Q2.',
    author: 'Lina, Head of Sales at NexaCloud',
    caseStudyUrl: 'https://www.example.com/case-studies/nexacloud',
    photoAsset: 'assets/images/partners/people-lina.png',
  ),
  Testimonial(
    quote:
        'The role-based workflows and analytics gave us immediate visibility. Our NPS jumped by 12 points.',
    author: 'Marc, COO at BrightWorks',
    caseStudyUrl: 'https://www.example.com/case-studies/brightworks',
    photoAsset: 'assets/images/partners/people-marc.png',
  ),
  Testimonial(
    quote:
        'Excellent support and integrations. Our field reps were productive on day one.',
    author: 'Sonia, Sales Director at Finnora',
    caseStudyUrl: 'https://www.example.com/case-studies/finnora',
    photoAsset: 'assets/images/partners/people-sonia.png',
  ),
];

// Real brand names are placeholders here; replace assets with your licensed logos
const List<PartnerLogo> partnerLogos = [
  PartnerLogo(
    name: 'Stripe',
    assetPath: 'assets/images/partners/stripe.png',
    websiteUrl: 'https://stripe.com',
  ),
  PartnerLogo(
    name: 'Shopify',
    assetPath: 'assets/images/partners/shopify.png',
    websiteUrl: 'https://www.shopify.com',
  ),
  PartnerLogo(
    name: 'HubSpot',
    assetPath: 'assets/images/partners/hubspot.png',
    websiteUrl: 'https://www.hubspot.com',
  ),
  PartnerLogo(
    name: 'Zendesk',
    assetPath: 'assets/images/partners/zendesk.png',
    websiteUrl: 'https://www.zendesk.com',
  ),
  PartnerLogo(
    name: 'Salesforce',
    assetPath: 'assets/images/partners/salesforce.png',
    websiteUrl: 'https://www.salesforce.com',
  ),
];
