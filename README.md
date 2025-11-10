# MULTISALES

**Plateforme B2B de sourcing et d'approvisionnement multi-catégorie**

## Description

MULTISALES est une plateforme B2B complète qui simplifie l'achat et la revente de matériels industriels, hôteliers et consommables. La plateforme offre une solution centralisée pour gérer tous les aspects de l'approvisionnement.

## Fonctionnalités principales

- **Catalogue centralisé** : Base de données unifiée de produits multi-catégories
- **Gestion de commandes** : Processus complet de commande et suivi
- **Gestion de stock** : Suivi en temps réel des niveaux de stock
- **Facturation** : Génération automatique de factures et documents comptables
- **Gestion de documents** : Centralisation et traitement de tous les documents commerciaux
- **🔥 Intégration Firebase** : Synchronisation en temps réel avec Firebase Realtime Database

## Catégories de produits

- Matériels industriels
- Équipements hôteliers
- Consommables divers

## Repository

https://github.com/KARKABAhamza/multisales

## Installation

```bash
# Clone le repository
git clone https://github.com/KARKABAhamza/multisales.git
cd multisales

# Installer les dépendances
dart pub get

# Lancer l'application (version locale)
dart run bin/main.dart

# Lancer avec Firebase (nécessite configuration)
dart run bin/main_firebase.dart
```

## 🔥 Intégration Firebase

MULTISALES supporte Firebase Realtime Database pour la synchronisation en temps réel des données.

**Configuration rapide:**

1. Installez les dépendances: `dart pub get`
2. Configurez `lib/config/firebase_config.dart` avec vos identifiants Firebase
3. Mettez à jour les règles de sécurité (voir `firebase_rules.json`)
4. Lancez: `dart run bin/main_firebase.dart`

**📖 Guide complet:** Consultez [FIREBASE_INTEGRATION.md](FIREBASE_INTEGRATION.md)

**Base de données:** `https://multisales-18e57-default-rtdb.firebaseio.com`

## Structure du projet

```
multisales/
├── bin/                    # Point d'entrée de l'application
│   ├── main.dart          # Version locale (sans Firebase)
│   └── main_firebase.dart # Version avec Firebase
├── lib/                   # Code source principal
│   ├── config/            # Configuration Firebase
│   ├── models/            # Modèles de données (avec JSON)
│   ├── services/          # Services métier (local + Firebase)
│   └── utils/             # Utilitaires
├── test/                  # Tests unitaires et d'intégration
├── firebase_rules.json    # Règles de sécurité Firebase
└── pubspec.yaml           # Configuration du projet
```

## Licence

Copyright © 2025 MULTISALES

