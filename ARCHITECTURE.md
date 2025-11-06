# Architecture de MULTISALES

## Vue d'ensemble

MULTISALES est une plateforme B2B modulaire conçue pour simplifier l'approvisionnement multi-catégorie. L'architecture est basée sur une séparation claire entre les modèles de données, les services métier, et les utilitaires.

## Structure du projet

```
multisales/
├── bin/
│   └── main.dart           # Point d'entrée de l'application
├── lib/
│   ├── models/             # Modèles de données
│   │   ├── product.dart    # Modèle de produit
│   │   ├── order.dart      # Modèle de commande
│   │   ├── supplier.dart   # Modèle de fournisseur
│   │   └── invoice.dart    # Modèle de facture
│   ├── services/           # Services métier
│   │   ├── catalog_service.dart     # Gestion du catalogue
│   │   ├── order_service.dart       # Gestion des commandes
│   │   ├── inventory_service.dart   # Gestion des stocks
│   │   └── invoice_service.dart     # Gestion des factures
│   ├── utils/              # Utilitaires
│   │   └── document_utils.dart      # Utilitaires pour documents
│   └── multisales.dart     # Fichier d'export de la bibliothèque
├── test/                   # Tests unitaires
│   ├── catalog_service_test.dart
│   ├── order_service_test.dart
│   └── inventory_service_test.dart
├── demo.py                 # Script de démonstration
├── pubspec.yaml            # Configuration du projet
└── README.md               # Documentation principale
```

## Composants principaux

### Modèles de données

#### Product
- Représente un produit dans le catalogue
- Attributs : ID, nom, catégorie, prix, quantité en stock
- Support pour multi-catégories (industriel, hôtelier, consommables)

#### Order
- Représente une commande client
- Contient plusieurs items (OrderItem)
- Statuts : pending, confirmed, processing, shipped, delivered, cancelled
- Calcul automatique du montant total

#### Supplier
- Représente un fournisseur
- Informations de contact et identification fiscale

#### Invoice
- Représente une facture
- Gestion des taxes et remises
- Détection automatique des factures en retard
- Statuts : draft, issued, paid, overdue, cancelled

### Services métier

#### CatalogService
- Gestion centralisée du catalogue de produits
- Recherche par nom, catégorie
- Opérations CRUD sur les produits

#### OrderService
- Création et suivi des commandes
- Filtrage par statut, fournisseur, date
- Calcul du chiffre d'affaires

#### InventoryService
- Gestion des niveaux de stock
- Alertes pour stock faible
- Mise à jour en temps réel

#### InvoiceService
- Génération automatique de factures
- Suivi des paiements
- Calcul des montants en attente

## Flux de travail typique

1. **Ajout de produits au catalogue**
   ```dart
   final product = Product(id: 'P001', name: 'Chaise', ...);
   catalogService.addProduct(product);
   ```

2. **Création d'une commande**
   ```dart
   final order = Order(
     id: 'O001',
     items: [OrderItem(productId: 'P001', quantity: 5, ...)],
     status: OrderStatus.pending,
     ...
   );
   orderService.createOrder(order);
   ```

3. **Mise à jour du stock**
   ```dart
   inventoryService.updateStock('P001', -5);
   ```

4. **Génération de facture**
   ```dart
   final invoice = Invoice(
     orderId: 'O001',
     amount: order.totalAmount,
     status: InvoiceStatus.issued,
     ...
   );
   invoiceService.generateInvoice(invoice);
   ```

## Extensibilité

L'architecture modulaire permet d'ajouter facilement :
- Nouveaux types de produits et catégories
- Systèmes de paiement
- Intégrations avec des ERP externes
- Notifications automatiques
- Rapports et analyses avancées
- API REST pour interfaces web/mobile

## Sécurité et performance

- Validation des données à tous les niveaux
- Gestion des erreurs robuste
- Tests unitaires complets
- Architecture scalable pour croissance future
