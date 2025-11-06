MULTISALES – Flutter Web Repository Template

Overview
This template defines the recommended structure, conventions, and initial artifacts for the MULTISALES Flutter Web project. It aligns with routing, state management, Firebase, CI/CD, and SEO requirements described in the project brief.

Folder Structure
```
lib/
  main.dart
  router.dart
  firebase_options.dart
  core/
    providers/
    routing/
    services/
    themes/
    utils/
  data/
    data_sources/
    models/
    repositories/
  models/
  features/
    auth/
    expertise/
    services_catalog/
    contact/
    client_space/
    admin/
  pages/
    home_page.dart
    about_page.dart
    expertise_page.dart
    services_page.dart
    service_detail_page.dart
    contact_page.dart
    login_page.dart
    account_shell.dart
    admin_shell.dart
  presentation/
    screens/
    widgets/
  widgets/
    app_bar.dart
    footer.dart
    hero_section.dart
    service_card.dart
    contact_form.dart

assets/
  images/
  icons/
  videos/
  fonts/
  i18n/

docs/
  RepoTemplate.md
  Backlog_Jira.csv
  Backlog_Trello.csv
  IMPORT_INSTRUCTIONS.md

web/
  index.html
  manifest.json
  firebase-config.js
  firebase-messaging-sw.js
```

Routing (go_router) – Target Map
- `/` Accueil
- `/a-propos` À propos
- `/expertise` Nos Métiers
- `/services` Liste des services
- `/services/:id` Détail service
- `/contact` Contact
- `/connexion` Connexion
- `/compte` (shell)
  - `/compte/documents`
  - `/compte/communications`
  - `/compte/contrats`
- `/admin` (shell)
  - `/admin/services`
  - `/admin/contacts`
  - `/admin/clients`

State Management
- Riverpod recommended for providers in `lib/core/providers` and feature-level state in `lib/features/*`.

Backend (Firebase Option)
- Auth: Email/Password
- Firestore: collections `users`, `clients`, `services`, `messages`, `communications`, `documents`, `contracts`
- Storage: documents/uploads
- Hosting + Analytics

Security & Roles (high level)
- Role claims on user tokens: `role: admin|client|public`.
- Firestore rules enforce read/write by role and ownership.

SEO & Web
- Use HTML renderer for SEO when possible.
- Configure meta tags in `web/index.html` (title, description, og:*).
- Provide 404 fallback routing via hosting config.

Internationalization
- `flutter_localizations` + `.arb` files under `assets/i18n` (phase 2+).

CI/CD
- GitHub Actions: build Flutter Web, deploy to Firebase Hosting.

Coding Conventions
- Dart lints enabled via `analysis_options.yaml`.
- Material 3 theming with light/dark in `lib/core/themes`.
- Keep services in `lib/core/services` thin and testable.
- Avoid deep widget nesting; extract to `presentation/widgets`.

Initial Stubs (suggested)
- `lib/pages/login_page.dart`: simple email/password form.
- `lib/pages/account_shell.dart` and `lib/pages/admin_shell.dart`: Navigation scaffolds with guards.
- `lib/widgets/hero_section.dart`: homepage hero with CTA.

Environment Setup Notes
- Ensure `firebase_options.dart` is generated (FlutterFire CLI) for all platforms including web.
- For local dev on web: `flutter run -d chrome --web-renderer html`.

Data Model (summary)
- See `docs/Backlog_*` for CRUD tasks and collections naming.



