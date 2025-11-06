# ADR-001: Firebase (Firestore + Storage + Functions) for MVP

Date: 2025-10-31
Status: Accepted

## Context

The MultiSales app targets fast delivery on multiple platforms (Web, Android, iOS, Desktop). We need authentication, structured data, media uploads, server-side workflows, and an easy local development story.

## Decision

Use Firebase — Firestore, Storage, and Cloud Functions — as the primary backend for the MVP.

- Tight Flutter integration and good developer experience
- Local emulators for Auth/Firestore/Functions
- Simple hosting for the web build
- Scales sufficiently for the MVP scope

## Consequences

- Data model is document-oriented; fit the MVP needs well
- Server-side logic handled by Functions (triggers, callable, scheduled)
- Security rules must be designed and reviewed for production readiness
- Vendor lock-in considerations exist; mitigated by layering and clean domain models

## Migration strategy (post-MVP)

If strong relational needs appear (complex joins, transactions, reporting):

1) Introduce Repository interfaces in the app layer (Dart) to abstract persistence
   - Example: `UserRepository`, `OrderRepository`, etc.
   - Keep domain models independent of SDKs

2) Add a new data backend implementation
   - Supabase/Postgres implementation living next to the Firestore one
   - Mappers to reuse the same domain models

3) Progressive switchover
   - Feature flags or environment-based injection to route specific features to Postgres first
   - Data export/import pipeline from Firestore to Postgres when needed

## Links

- See `docs/ARCHITECTURE.md` for the layered overview and migration notes.
- Firestore indexes: `firestore.indexes.json`
- Cloud Functions: `functions/`
