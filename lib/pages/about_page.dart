import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../presentation/widgets/sarlau_app_bar.dart';
import '../presentation/widgets/sarlau_footer.dart';
import '../design/design_tokens.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  Widget _buildSectionTitle(BuildContext context, String text) {
    return Text(text, style: Theme.of(context).textTheme.headlineMedium);
  }

  Widget _buildParagraph(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }

  Widget _buildBullet(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline, size: 18, color: DesignTokens.primary),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyMedium)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SarlauAppBar(),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 28.0),
        children: [
          _buildSectionTitle(context, 'À propos de MULTISALES'),
          const SizedBox(height: 12),

          // Présentation
          _buildParagraph(
            context,
            "MULTISALES est un fournisseur multi‑catégorie et central d’achat basé à Casablanca. "
            "Nous achetons et revendons une large gamme de matériels et fournitures : équipements industriels, fournitures hôtelières, consommables, équipements de protection individuelle (EPI) et équipements divers. "
            "Notre mission est de simplifier l’approvisionnement pour les entreprises en centralisant les commandes et en assurant des livraisons rapides et fiables.",
          ),

          // Mission & valeur
          _buildSectionTitle(context, 'Notre mission'),
          _buildParagraph(
            context,
            "Nous visons à garantir la disponibilité des produits essentiels pour nos clients tout en optimisant les coûts et les délais. "
            "Pour cela, nous sélectionnons des fournisseurs fiables, négocions des tarifs compétitifs par achat en volume et appliquons des contrôles qualité stricts.",
          ),

          _buildSectionTitle(context, 'Ce que nous proposons'),
          _buildParagraph(
            context,
            "MULTISALES propose des services complets pour couvrir vos besoins d’approvisionnement :",
          ),
          _buildBullet(context, "Sourcing & achats centralisés (multi‑catégories)"),
          _buildBullet(context, "Stockage, préparation de commandes et expédition"),
          _buildBullet(context, "Fourniture d’EPI conformes aux normes en vigueur"),
          _buildBullet(context, "Fournitures hôtelières et consommables pour entreprises"),
          _buildBullet(context, "Solutions d’abonnement et réassort automatique selon SLA"),

          const SizedBox(height: 12),
          _buildSectionTitle(context, 'Nos engagements'),
          _buildParagraph(
            context,
            "Qualité, conformité et réactivité sont au cœur de notre offre. Nous fournissons la documentation produit, assurons la traçabilité des commandes et offrons une assistance commerciale dédiée pour le suivi des approvisionnements et la gestion des retours.",
          ),

          const SizedBox(height: 16),
          _buildSectionTitle(context, 'Bénéfices pour nos clients'),
          const SizedBox(height: 8),
          _buildBullet(context, "Réduction des délais d’approvisionnement grâce à un stock centralisé"),
          _buildBullet(context, "Tarifs compétitifs obtenus par achats en volume"),
          _buildBullet(context, "Conformité produit (normes & documentation)"),
          _buildBullet(context, "Support client et gestion simplifiée des commandes"),

          const SizedBox(height: 20),
          // Contact quick card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: Row(
                children: [
                  const Icon(Icons.contact_phone, color: DesignTokens.primary, size: 36),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Contact commercial', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                        SizedBox(height: 6),
                        Text('49 boulevard CHEFCHAOUNI II, Ain Sébaâ, Casablanca'),
                        SizedBox(height: 4),
                        Text('+212 661 29 74 42 | +212 661 08 98 59'),
                        SizedBox(height: 4),
                        Text('commercial@skyconnect.ma'),
                        SizedBox(height: 6),
                        Text('Horaires: 08:30 – 18:00'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => context.go('/contact'),
                    style: ElevatedButton.styleFrom(backgroundColor: DesignTokens.secondary),
                    child: const Text('Nous contacter'),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 28),
          const SarlauFooter(),
        ],
      ),
    );
  }
}
