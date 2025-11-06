# MULTISALES - Démarrage Rapide

## Installation

```bash
git clone https://github.com/KARKABAhamza/multisales.git
cd multisales
dart pub get
```

## Lancer la démo

### Dart (si disponible)
```bash
dart run bin/main.dart
```

### Python (démo alternative)
```bash
python3 demo.py
```

## Utilisation basique

### 1. Ajouter un produit au catalogue

```dart
import 'package:multisales/multisales.dart';

final catalogService = CatalogService();
final product = Product(
  id: 'P001',
  name: 'Chaise de bureau',
  category: 'Mobilier',
  price: 150.00,
  stockQuantity: 50,
);
catalogService.addProduct(product);
```

### 2. Créer une commande

```dart
final orderService = OrderService();
final order = Order(
  id: 'O001',
  supplierId: 'S001',
  items: [
    OrderItem(productId: 'P001', quantity: 5, unitPrice: 150.00),
  ],
  status: OrderStatus.pending,
  orderDate: DateTime.now(),
);
orderService.createOrder(order);
```

### 3. Gérer le stock

```dart
final inventoryService = InventoryService();
inventoryService.initializeStock('P001', 50);
inventoryService.updateStock('P001', -5); // Retirer 5 unités
```

### 4. Générer une facture

```dart
final invoiceService = InvoiceService();
final invoice = Invoice(
  id: 'INV001',
  orderId: 'O001',
  issueDate: DateTime.now(),
  dueDate: DateTime.now().add(Duration(days: 30)),
  amount: order.totalAmount,
  status: InvoiceStatus.issued,
);
invoiceService.generateInvoice(invoice);
```

## Lancer les tests

```bash
dart test
```

## Structure des fichiers

```
multisales/
├── README.md              # Documentation principale
├── API_GUIDE.md           # Guide API complet
├── ARCHITECTURE.md        # Architecture du système
├── CONTRIBUTING.md        # Guide de contribution
├── LICENSE                # Licence MIT
├── bin/main.dart          # Point d'entrée
├── lib/                   # Code source
│   ├── models/            # Modèles de données
│   ├── services/          # Services métier
│   └── utils/             # Utilitaires
└── test/                  # Tests
```

## Documentation complète

- **[README.md](README.md)** - Vue d'ensemble
- **[ARCHITECTURE.md](ARCHITECTURE.md)** - Architecture détaillée
- **[API_GUIDE.md](API_GUIDE.md)** - Référence API
- **[CONTRIBUTING.md](CONTRIBUTING.md)** - Guide de contribution

## Fonctionnalités principales

✅ Catalogue centralisé de produits
✅ Gestion complète des commandes
✅ Suivi des stocks en temps réel
✅ Génération automatique de factures
✅ Gestion des documents

## Support

Pour toute question ou problème :
- Ouvrir une issue sur GitHub
- Consulter la documentation dans le dossier `/docs`

## Licence

MIT License - voir [LICENSE](LICENSE)

---

**Repository:** https://github.com/KARKABAhamza/multisales
