# Guide de l'API MULTISALES

## Services disponibles

### CatalogService

Service de gestion du catalogue centralisé de produits.

#### Méthodes

##### `addProduct(Product product)`
Ajoute un produit au catalogue.

**Exemple :**
```dart
final product = Product(
  id: 'P001',
  name: 'Chaise de bureau ergonomique',
  category: 'Mobilier',
  price: 150.00,
  stockQuantity: 50,
);
catalogService.addProduct(product);
```

##### `getProduct(String id) → Product?`
Récupère un produit par son ID.

**Retour :** Le produit trouvé ou `null`

##### `getAllProducts() → List<Product>`
Retourne tous les produits du catalogue.

##### `getProductsByCategory(String category) → List<Product>`
Filtre les produits par catégorie.

**Exemple :**
```dart
final mobilier = catalogService.getProductsByCategory('Mobilier');
```

##### `searchProducts(String query) → List<Product>`
Recherche des produits par nom (insensible à la casse).

##### `updateProduct(String id, Product product) → bool`
Met à jour un produit existant.

**Retour :** `true` si succès, `false` si produit non trouvé

##### `removeProduct(String id) → bool`
Supprime un produit du catalogue.

##### `getProductCount() → int`
Retourne le nombre total de produits.

---

### OrderService

Service de gestion des commandes.

#### Méthodes

##### `createOrder(Order order)`
Crée une nouvelle commande.

**Exemple :**
```dart
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

##### `getOrder(String id) → Order?`
Récupère une commande par son ID.

##### `getAllOrders() → List<Order>`
Retourne toutes les commandes.

##### `getOrdersByStatus(OrderStatus status) → List<Order>`
Filtre les commandes par statut.

**Statuts disponibles :**
- `OrderStatus.pending` - En attente
- `OrderStatus.confirmed` - Confirmée
- `OrderStatus.processing` - En traitement
- `OrderStatus.shipped` - Expédiée
- `OrderStatus.delivered` - Livrée
- `OrderStatus.cancelled` - Annulée

##### `getOrdersBySupplier(String supplierId) → List<Order>`
Filtre les commandes par fournisseur.

##### `updateOrderStatus(String id, OrderStatus newStatus) → bool`
Met à jour le statut d'une commande.

##### `cancelOrder(String id) → bool`
Annule une commande.

##### `getTotalRevenue() → double`
Calcule le chiffre d'affaires total.

---

### InventoryService

Service de gestion des stocks.

#### Méthodes

##### `initializeStock(String productId, int quantity)`
Initialise le stock pour un produit.

##### `getStock(String productId) → int`
Retourne le niveau de stock actuel.

##### `updateStock(String productId, int change) → bool`
Met à jour le stock (positif ou négatif).

**Exemple :**
```dart
// Ajouter 50 unités
inventoryService.updateStock('P001', 50);

// Retirer 10 unités
inventoryService.updateStock('P001', -10);
```

**Retour :** `false` si le stock serait négatif

##### `addStock(String productId, int quantity) → bool`
Ajoute du stock (réception).

##### `removeStock(String productId, int quantity) → bool`
Retire du stock (pour commande).

##### `isInStock(String productId, int requiredQuantity) → bool`
Vérifie la disponibilité.

##### `getLowStockProducts(int threshold) → Map<String, int>`
Retourne les produits avec stock faible.

**Exemple :**
```dart
final lowStock = inventoryService.getLowStockProducts(10);
// Retourne tous les produits avec moins de 10 unités
```

---

### InvoiceService

Service de gestion des factures.

#### Méthodes

##### `generateInvoice(Invoice invoice)`
Génère une nouvelle facture.

**Exemple :**
```dart
final invoice = Invoice(
  id: 'INV001',
  orderId: 'O001',
  issueDate: DateTime.now(),
  dueDate: DateTime.now().add(Duration(days: 30)),
  amount: 1200.00,
  status: InvoiceStatus.issued,
  taxAmount: 240.00, // 20% TVA
);
invoiceService.generateInvoice(invoice);
```

##### `getInvoice(String id) → Invoice?`
Récupère une facture par son ID.

##### `getAllInvoices() → List<Invoice>`
Retourne toutes les factures.

##### `getInvoicesByStatus(InvoiceStatus status) → List<Invoice>`
Filtre les factures par statut.

**Statuts disponibles :**
- `InvoiceStatus.draft` - Brouillon
- `InvoiceStatus.issued` - Émise
- `InvoiceStatus.paid` - Payée
- `InvoiceStatus.overdue` - En retard
- `InvoiceStatus.cancelled` - Annulée

##### `getInvoicesByOrder(String orderId) → List<Invoice>`
Récupère les factures d'une commande.

##### `updateInvoiceStatus(String id, InvoiceStatus newStatus) → bool`
Met à jour le statut d'une facture.

##### `markAsPaid(String id) → bool`
Marque une facture comme payée.

##### `getOverdueInvoices() → List<Invoice>`
Retourne les factures en retard.

##### `getTotalOutstanding() → double`
Calcule le montant total en attente de paiement.

##### `getTotalPaid() → double`
Calcule le montant total payé.

---

## Modèles de données

### Product

```dart
class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final int stockQuantity;
  final String? description;
  final String? supplier;
}
```

### Order

```dart
class Order {
  final String id;
  final String supplierId;
  final List<OrderItem> items;
  final OrderStatus status;
  final DateTime orderDate;
  final DateTime? deliveryDate;
  final String? notes;
  
  double get totalAmount; // Calculé automatiquement
}

class OrderItem {
  final String productId;
  final int quantity;
  final double unitPrice;
  
  double get totalPrice; // Calculé automatiquement
}
```

### Supplier

```dart
class Supplier {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? address;
  final String? taxId;
  final List<String>? categories;
}
```

### Invoice

```dart
class Invoice {
  final String id;
  final String orderId;
  final DateTime issueDate;
  final DateTime dueDate;
  final double amount;
  final InvoiceStatus status;
  final String? notes;
  final double? taxAmount;
  final double? discountAmount;
  
  double get totalAmount; // Calculé automatiquement
  bool get isOverdue; // Calculé automatiquement
}
```

---

## Utilitaires

### DocumentUtils

Fonctions utilitaires pour la gestion des documents.

```dart
// Générer un ID de document
String id = DocumentUtils.generateDocumentId('INV');

// Formater une devise
String formatted = DocumentUtils.formatCurrency(1200.50); // "€1200.50"

// Formater une date
String date = DocumentUtils.formatDate(DateTime.now()); // "06/11/2025"

// Générer un numéro de facture
String invoiceNo = DocumentUtils.generateInvoiceNumber(); // "INV-202511-12345"

// Générer un numéro de commande
String orderNo = DocumentUtils.generateOrderNumber(); // "ORD-202511-12345"

// Valider un email
bool valid = DocumentUtils.isValidEmail('test@example.com');

// Valider un numéro de téléphone
bool valid = DocumentUtils.isValidPhoneNumber('+33123456789');
```
