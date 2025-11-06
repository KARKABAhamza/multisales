# Guide de Contribution

Merci de votre intérêt pour contribuer à MULTISALES ! Ce guide vous aidera à démarrer.

## Table des matières

- [Code de conduite](#code-de-conduite)
- [Comment contribuer](#comment-contribuer)
- [Configuration de l'environnement](#configuration-de-lenvironnement)
- [Standards de code](#standards-de-code)
- [Tests](#tests)
- [Processus de Pull Request](#processus-de-pull-request)

## Code de conduite

En participant à ce projet, vous acceptez de maintenir un environnement respectueux et inclusif pour tous.

## Comment contribuer

Il existe plusieurs façons de contribuer à MULTISALES :

1. **Signaler des bugs** : Ouvrez une issue avec une description détaillée
2. **Proposer des fonctionnalités** : Discutez de nouvelles idées via les issues
3. **Améliorer la documentation** : Toute amélioration est la bienvenue
4. **Soumettre du code** : Corrigez des bugs ou implémentez de nouvelles fonctionnalités

## Configuration de l'environnement

### Prérequis

- Dart SDK 2.19 ou supérieur
- Git

### Installation

1. Clonez le repository :
```bash
git clone https://github.com/KARKABAhamza/multisales.git
cd multisales
```

2. Installez les dépendances :
```bash
dart pub get
```

3. Vérifiez que tout fonctionne :
```bash
dart run bin/main.dart
```

4. Lancez les tests :
```bash
dart test
```

## Standards de code

### Style de code

- Utilisez les conventions de nommage Dart standard
- CamelCase pour les classes : `CatalogService`
- camelCase pour les variables et fonctions : `getProduct`
- snake_case pour les noms de fichiers : `catalog_service.dart`

### Documentation

- Documentez toutes les classes et méthodes publiques
- Utilisez des commentaires de documentation Dart (`///`)
- Incluez des exemples d'utilisation pour les fonctionnalités complexes

**Exemple :**
```dart
/// Récupère un produit par son identifiant.
///
/// Retourne le [Product] correspondant à [id], ou `null` si non trouvé.
///
/// Exemple :
/// ```dart
/// final product = catalogService.getProduct('P001');
/// ```
Product? getProduct(String id) {
  return _products[id];
}
```

### Structure des commits

Utilisez des messages de commit clairs et descriptifs :

```
type: description courte

Description détaillée si nécessaire

Types possibles :
- feat: Nouvelle fonctionnalité
- fix: Correction de bug
- docs: Documentation seulement
- style: Formatage du code
- refactor: Refactorisation
- test: Ajout ou modification de tests
- chore: Maintenance
```

**Exemple :**
```
feat: add product search by supplier

Implémente la recherche de produits filtrée par fournisseur
dans le CatalogService. Ajoute également les tests associés.
```

## Tests

### Écrire des tests

Chaque nouvelle fonctionnalité doit inclure des tests :

```dart
import 'package:test/test.dart';
import 'package:multisales/services/catalog_service.dart';

void main() {
  group('CatalogService', () {
    late CatalogService catalogService;

    setUp(() {
      catalogService = CatalogService();
    });

    test('should add product to catalog', () {
      // Arrange
      final product = Product(...);

      // Act
      catalogService.addProduct(product);

      // Assert
      expect(catalogService.getProductCount(), equals(1));
    });
  });
}
```

### Lancer les tests

```bash
# Tous les tests
dart test

# Un fichier spécifique
dart test test/catalog_service_test.dart

# Avec couverture
dart test --coverage
```

## Processus de Pull Request

1. **Créez une branche** pour votre fonctionnalité :
```bash
git checkout -b feature/ma-fonctionnalite
```

2. **Faites vos modifications** en suivant les standards de code

3. **Ajoutez des tests** pour vos changements

4. **Vérifiez** que tous les tests passent :
```bash
dart test
```

5. **Commitez** vos changements :
```bash
git add .
git commit -m "feat: description de la fonctionnalité"
```

6. **Poussez** votre branche :
```bash
git push origin feature/ma-fonctionnalite
```

7. **Ouvrez une Pull Request** sur GitHub :
   - Donnez un titre clair
   - Décrivez les changements en détail
   - Référencez les issues liées si applicable
   - Attendez la revue de code

### Checklist PR

Avant de soumettre votre PR, vérifiez que :

- [ ] Le code suit les standards du projet
- [ ] Tous les tests passent
- [ ] De nouveaux tests ont été ajoutés si nécessaire
- [ ] La documentation a été mise à jour
- [ ] Les commits ont des messages descriptifs
- [ ] Aucun warning ou erreur de lint

## Questions ?

Si vous avez des questions, n'hésitez pas à :

- Ouvrir une issue pour discussion
- Contacter les mainteneurs du projet

Merci de contribuer à MULTISALES ! 🎉
