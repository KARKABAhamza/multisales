# Firebase / Firestore Migration TODOs

This file lists focused, small edits to migrate the codebase to the newer FlutterFire plugin family
(we upgraded to firebase_core ^4.x and matching plugins) and to make timestamp/FieldValue handling
consistent across the app.

Summary of safe edits applied

- Added helper utilities: `lib/core/services/firestore_utils.dart`
  - `timestampToDate(Object? value) -> DateTime?` — normalizes Timestamp/DateTime/int/string inputs
  - `dateToFirestore(DateTime? dt) -> Object` — converts DateTime to `Timestamp` or returns `FieldValue.serverTimestamp()` when null
  - `serverTimestamp()` — convenience wrapper for `FieldValue.serverTimestamp()`
- Updated uses in:
  - `lib/models/product_models.dart`
  - `lib/core/services/order_service.dart`
  - `lib/core/services/review_service.dart`

Why these changes

- Reduces duplication of Timestamp/FieldValue checks and conversions.
- Centralizes server-timestamp placeholder usage to a single helper for easier future changes.
- These are low-risk edits that keep runtime behavior identical while simplifying future migration steps.

Files to review (detailed suggestions)

1. lib/models/product_models.dart

- Replaced repeated `is Timestamp` checks with `timestampToDate(data['createdAt'])` and `timestampToDate(data['updatedAt'])`.
- Replaced manual `Timestamp.fromDate(...)` / `FieldValue.serverTimestamp()` patterns with `dateToFirestore(createdAt)` and `serverTimestamp()`.
- Why: keeps model mapping concise and robust.

2. lib/core/services/order_service.dart

- Use `serverTimestamp()` for `createdAt` payload.
- Use `timestampToDate` when mapping `createdAt` from Firestore.

3. lib/core/services/review_service.dart

- Use `timestampToDate` for createdAt mapping.
- Use `serverTimestamp()` for write operations.

Other places to consider (not auto-changed)

- `lib/core/services/contact_service.dart` — contains `FieldValue.serverTimestamp()` and `FirebaseFunctions` usage. Consider switching to `serverTimestamp()` and ensuring callable error handling matches the updated `FirebaseFunctions` API.
- `lib/data/models/product.dart`, `lib/data/models/order.dart`, `lib/models/product_models.dart` (other variants) — review and switch to `timestampToDate` where applicable.
- `functions/index.js` — server-side timestamps are correct; ensure client writes and server reads expectations align.

Next recommended steps

- Run full analyzer and tests (already done). If you plan to continue migrating APIs (callable signatures, messaging handlers), produce small PRs per area.
- Run platform smoke tests for Android/iOS to ensure native plugin upgrade compatibility.
- Optionally: replace remaining FieldValue/Timestamp usage across the repo using the helper (I can automate a safe sweep and create a PR).

If you'd like, I can:

- Create a PR that applies these helper usages to all occurrences of `FieldValue.serverTimestamp()` and `Timestamp` checks (automated sweep). (Suggested: do this in a separate branch.)
- Start migrating `contact_service.dart` callable error handling to match the new `FirebaseFunctionsException` shape if needed.
- Run Android/iOS builds to validate native-level integrations.

Pick the next action or tell me to proceed with an automated sweep.
