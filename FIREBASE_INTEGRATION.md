# Guide d'Intégration Firebase pour MULTISALES

## Vue d'ensemble

Ce guide vous aide à intégrer Firebase Realtime Database avec la plateforme MULTISALES pour synchroniser les données en temps réel.

## Prérequis

- Compte Firebase avec un projet créé
- Base de données Realtime configurée: `https://multisales-18e57-default-rtdb.firebaseio.com`
- Dart SDK installé

## Configuration Initiale

### 1. Mettre à jour les dépendances

Les dépendances Firebase sont déjà ajoutées dans `pubspec.yaml`:

```yaml
dependencies:
  firebase_core: ^2.24.0
  firebase_database: ^10.4.0
  firebase_auth: ^4.15.0
```

Installez-les avec:
```bash
dart pub get
```

### 2. Configurer Firebase

Éditez `lib/config/firebase_config.dart` et remplacez les valeurs suivantes:

```dart
static Future<void> initialize() async {
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'VOTRE_CLE_API',              // ← À remplacer
      appId: 'multisales-18e57',
      messagingSenderId: 'VOTRE_SENDER_ID', // ← À remplacer
      projectId: 'multisales-18e57',
      databaseURL: databaseUrl,
    ),
  );
}
```

**Où trouver ces valeurs:**
1. Allez sur [Firebase Console](https://console.firebase.google.com)
2. Sélectionnez votre projet `multisales-18e57`
3. Allez dans Paramètres du projet → Général
4. Descendez jusqu'à "Vos applications" → "Configuration du SDK"

### 3. Configurer les règles de sécurité

Dans la console Firebase, allez dans **Realtime Database** → **Règles** et copiez le contenu de `firebase_rules.json`:

```json
{
  "rules": {
    ".read": "auth != null",
    ".write": "auth != null",
    
    "products": {
      ".indexOn": ["category", "supplier"]
    },
    "orders": {
      ".indexOn": ["status", "supplierId", "orderDate"]
    },
    "suppliers": {
      ".indexOn": ["name"]
    },
    "invoices": {
      ".indexOn": ["status", "orderId", "issueDate"]
    },
    "inventory": {
      "$productId": {
        ".validate": "newData.isNumber() && newData.val() >= 0"
      }
    }
  }
}
```

**⚠️ Important:** Ces règles requièrent l'authentification. Pour le développement, vous pouvez temporairement utiliser:

```json
{
  "rules": {
    ".read": true,
    ".write": true
  }
}
```

**⚠️ Attention:** Ne jamais utiliser ces règles en production!

### 4. Configurer l'authentification (Optionnel mais recommandé)

1. Dans Firebase Console, allez dans **Authentication**
2. Activez au moins une méthode d'authentification (Email/Password recommandé)
3. Pour le développement, créez quelques utilisateurs de test

## Utilisation

### Services Firebase disponibles

MULTISALES fournit des services Firebase pour toutes les entités:

- `FirebaseCatalogService` - Gestion des produits
- `FirebaseOrderService` - Gestion des commandes
- `FirebaseInventoryService` - Gestion des stocks
- `FirebaseInvoiceService` - Gestion des factures
- `FirebaseSupplierService` - Gestion des fournisseurs

### Exemple d'utilisation basique

```dart
import 'package:multisales/multisales.dart';

Future<void> main() async {
  // Initialiser Firebase
  await FirebaseConfig.initialize();
  
  // Créer les services
  final catalogService = FirebaseCatalogService();
  
  // Ajouter un produit
  final product = Product(
    id: 'P001',
    name: 'Chaise de bureau',
    category: 'Mobilier',
    price: 150.00,
    stockQuantity: 50,
  );
  
  await catalogService.addProduct(product);
  
  // Récupérer tous les produits
  final products = await catalogService.getAllProducts();
  print('Produits: ${products.length}');
}
```

### Synchronisation en temps réel

Les services Firebase supportent les Streams pour les mises à jour en temps réel:

```dart
// Écouter les changements sur tous les produits
catalogService.watchProducts().listen((products) {
  print('Produits mis à jour: ${products.length}');
  for (var product in products) {
    print('  - ${product.name}: €${product.price}');
  }
});

// Écouter les changements sur un produit spécifique
catalogService.watchProduct('P001').listen((product) {
  if (product != null) {
    print('Produit P001 mis à jour: ${product.name}');
  }
});

// Écouter les changements de stock
inventoryService.watchStock('P001').listen((quantity) {
  print('Stock de P001: $quantity unités');
  if (quantity < 10) {
    print('⚠️ Stock faible!');
  }
});
```

## Lancer l'exemple

Un exemple complet est fourni dans `bin/main_firebase.dart`:

```bash
dart run bin/main_firebase.dart
```

Cet exemple démontre:
- Initialisation de Firebase
- Ajout de produits, fournisseurs, commandes
- Gestion des stocks
- Génération de factures
- Statistiques en temps réel

## Structure de la base de données

```
multisales-18e57/
├── products/
│   └── {productId}/
│       ├── id
│       ├── name
│       ├── category
│       ├── price
│       └── stockQuantity
├── orders/
│   └── {orderId}/
│       ├── id
│       ├── supplierId
│       ├── items/
│       ├── status
│       └── orderDate
├── suppliers/
│   └── {supplierId}/
│       ├── id
│       ├── name
│       ├── email
│       └── phone
├── invoices/
│   └── {invoiceId}/
│       ├── id
│       ├── orderId
│       ├── amount
│       ├── status
│       └── issueDate
└── inventory/
    └── {productId}: {quantity}
```

## Comparaison: Services Locaux vs Firebase

### Services Locaux (Mémoire)

**Avantages:**
- Rapide pour les prototypes
- Pas de configuration requise
- Fonctionne hors ligne

**Inconvénients:**
- Données perdues au redémarrage
- Pas de synchronisation multi-utilisateurs
- Pas de persistance

**Utilisation:**
```dart
import 'package:multisales/services/catalog_service.dart';

final catalogService = CatalogService(); // Local
```

### Services Firebase (Cloud)

**Avantages:**
- Données persistantes
- Synchronisation en temps réel
- Multi-utilisateurs
- Sauvegardes automatiques
- Accès depuis n'importe où

**Inconvénients:**
- Nécessite configuration
- Nécessite connexion internet
- Coûts potentiels (plan gratuit généreux)

**Utilisation:**
```dart
import 'package:multisales/services/firebase_catalog_service.dart';

await FirebaseConfig.initialize();
final catalogService = FirebaseCatalogService(); // Firebase
```

## Migration de Local vers Firebase

Pour migrer les données existantes:

```dart
// 1. Initialiser les deux services
final localCatalog = CatalogService();
final firebaseCatalog = FirebaseCatalogService();

// 2. Récupérer les données locales
final localProducts = localCatalog.getAllProducts();

// 3. Uploader vers Firebase
for (var product in localProducts) {
  await firebaseCatalog.addProduct(product);
}

print('Migration terminée: ${localProducts.length} produits');
```

## Dépannage

### Erreur: "Firebase not initialized"

**Solution:** Assurez-vous d'appeler `FirebaseConfig.initialize()` avant d'utiliser les services:

```dart
await FirebaseConfig.initialize();
```

### Erreur: "Permission denied"

**Solution:** Vérifiez vos règles de sécurité Firebase. Pour le développement:

```json
{
  "rules": {
    ".read": true,
    ".write": true
  }
}
```

### Données non synchronisées

**Vérifications:**
1. Connexion internet active
2. URL de la base de données correcte
3. Règles de sécurité appropriées
4. Authentification configurée (si requise)

## Tests

Les modèles incluent maintenant les méthodes `toJson()` et `fromJson()` pour la sérialisation Firebase:

```dart
// Sérialisation
final product = Product(...);
final json = product.toJson();

// Désérialisation
final productFromJson = Product.fromJson(json);
```

## Sécurité en Production

Pour la production, utilisez des règles strictes:

```json
{
  "rules": {
    "products": {
      ".read": "auth != null",
      ".write": "auth != null && auth.token.admin === true"
    },
    "orders": {
      ".read": "auth != null && (auth.uid === data.child('userId').val() || auth.token.admin === true)",
      ".write": "auth != null"
    }
  }
}
```

## Support

Pour plus d'informations:
- [Documentation Firebase](https://firebase.google.com/docs/database)
- [Console Firebase](https://console.firebase.google.com)
- [Repository MULTISALES](https://github.com/KARKABAhamza/multisales)

## Prochaines étapes

1. Configurer Firebase Auth pour la sécurité
2. Implémenter des Cloud Functions pour la logique métier
3. Ajouter Firebase Storage pour les images de produits
4. Configurer Firebase Analytics pour le suivi
5. Implémenter des notifications push via FCM
