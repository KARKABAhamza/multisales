# Architecture Overview

This document summarizes how the app is structured across presentation (UI), business (state and logic), and data (persistence and integrations), plus the current architectural choice for the MVP and the migration path to a relational backend if needed later.

## TL;DR – Choix d’architecture (recommandé maintenant)

- MVP: Rester sur Firebase (Firestore + Storage + Cloud Functions)
  - Raison: time-to-market rapide, très bien intégré avec Flutter, émulateurs locaux pour tests, faible maintenance.
- Anticiper une migration possible vers Postgres/Supabase si un besoin relationnel fort apparaît (jointures complexes, transactions multi-ressources, contraintes solides, reporting SQL).

## Layers

- Presentation (UI)
  - Flutter Widgets + GoRouter for navigation
  - No business logic in Widgets
  - All user-facing strings via `AppLocalizations` (EN, FR, AR, ES, DE)

- Business (State & Logic)
  - Providers (`ChangeNotifier`) under `lib/core/providers/`
  - Expose the standard state surface: `isLoading`, `errorMessage`
  - Orchestrate use-cases by delegating to Services

- Data (Persistence & Integrations)
  - Services under `lib/core/services/` wrap external SDKs/APIs
  - Firestore for structured documents and queries
  - Storage for binary files (images, docs, videos)
  - Cloud Functions for server-side tasks (triggers, signed URLs, scheduled jobs)

## Firebase MVP – Details

- Firestore
  - Core collections: `users`, `products`, `categories`, `orders`, `uploads`
  - Composite indexes added for common queries (see `firestore.indexes.json`)
  - Security rules to be refined before production

- Storage
  - Pathing by entity and user when relevant, metadata for traceability
  - Uploads use signed URLs via a callable function for security and performance

- Cloud Functions (Node 18)
  - Event-driven (e.g., `onOrderCreate`, `onUserCreate`)
  - Callable (e.g., `getSignedUploadUrl`)
  - Scheduled (e.g., nightly Firestore export to GCS)

## Provider + Service contract (business rules)

- Provider responsibilities
  - Hold UI state: `isLoading`, `errorMessage`, progress where applicable
  - Validate inputs at the edge and map domain errors to friendly UI messages
  - Call Services and `notifyListeners()` on any state change

- Service responsibilities
  - Single place for Firebase/HTTP/SDK logic and error handling
  - Return typed results or throw domain-specific exceptions
  - Keep Widgets free from platform/service code

## Migration path → Postgres/Supabase (optionnel à moyen terme)

Objectif: garder la souplesse du MVP tout en limitant le coût de migration si un besoin relationnel fort apparaît.

- Séparer l’accès aux données derrière des interfaces (Repository pattern)
  - Exemple (à introduire si/ quand nécessaire):
    - `abstract class UserRepository { Future<User> getById(String id); ... }`
    - Implémentations: `FirestoreUserRepository`, plus tard `SupabaseUserRepository`
  - Les Providers consomment l’interface, pas l’implémentation concrète

- Modèles de domaine indépendants
  - Garder les models dans `lib/models/` sans dépendre d’un SDK spécifique
  - Mapper Firestore/Supabase vers les mêmes modèles

- Stratégie de migration progressive
  - Introduire le repository Supabase en parallèle
  - Commencer par des fonctionnalités ciblées (ex. reporting, historiques)
  - Feature flag / injection par environnement pour basculer une route/feature

- Données et schémas
  - Documenter le mapping Firestore ↔️ Postgres (tables, clés, contraintes)
  - Prévoir des scripts d’export Firestore → CSV/NDJSON puis import vers Postgres

## Edge cases & qualité

- Résilience réseau: retry/backoff côté client pour les opérations critiques
- Conflits concurrents: privilégier des écritures atomiques (batched writes, transactions Firestore) pour le MVP
- Performance: utiliser les indexes Firestore, limiter la taille des documents, activer la pagination (limit/offset ou cursors)
- Sécurité: règles Firestore/Storage strictes; callable functions avec validations; App Check si pertinent
- Observabilité: logs Cloud Functions, analytique événementielle via `AnalyticsService`

## Comment utiliser ce document

- Pour le MVP, continuer à implémenter Provider + Service avec Firebase.
- Si/ quand le besoin relationnel devient critique, introduire le niveau Repository et une nouvelle implémentation Supabase/Postgres sans casser l’UI/Providers.
