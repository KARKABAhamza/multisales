import '../providers/services_provider.dart';

class ServicesService {
  // Simule la récupération des services depuis une API ou Firestore
  Future<List<ServiceProduct>> fetchServices() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      ServiceProduct(
        id: '1',
        title: 'CRM & Gestion de la Relation Client',
        description: 'Optimisez la gestion de vos prospects et clients avec notre CRM intégré.',
        imageUrl: 'assets/images/service_crm.png',
      ),
      ServiceProduct(
        id: '2',
        title: 'Facturation & Abonnements',
        description: 'Automatisez la facturation et la gestion des abonnements clients.',
        imageUrl: 'assets/images/service_billing.png',
      ),
      ServiceProduct(
        id: '3',
        title: 'Support & Ticketing',
        description: 'Centralisez les demandes clients et suivez leur résolution.',
        imageUrl: 'assets/images/service_support.png',
      ),
    ];
  }
}
