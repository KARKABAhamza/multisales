
# MultiSales Flutter App – AI Coding Agent Instructions

## Project Overview

This is a cross-platform onboarding app for MultiSales, built with Flutter 3.x and Firebase. It features:
- Role-based onboarding flows
- Multi-language support (EN, FR, AR, ES, DE)
- Provider-based state management
- Modular service layer for all Firebase and external integrations
- Cross-platform deployment (Web, Android, iOS, Windows, macOS)

## Architecture & Patterns

- **Provider Pattern:** All business logic is in `lib/core/providers/` as `ChangeNotifier` classes. UI never contains business logic.
- **Service Layer:** All Firebase and external API calls are wrapped in `lib/core/services/`. Widgets never call Firebase directly.
- **Routing:** Uses GoRouter (`lib/core/routing/app_router.dart`) with named routes and role-based navigation.
- **Localization:** Custom system in `lib/core/localization/app_localizations.dart` and `LanguageProvider`. All user-facing strings must be localized.
- **Onboarding:** Steps are generated dynamically per user role in `OnboardingProvider`.

## Key Conventions

- **Provider Structure:**
  - Always expose `isLoading` and `errorMessage`.
  - Call `notifyListeners()` after any state change.
  - Example:
    ```dart
    class ExampleProvider with ChangeNotifier {
      bool _isLoading = false;
      String? _errorMessage;
      // ...
    }
    ```
- **Service Usage:**
  - All async logic and error handling in service classes (e.g., `AuthService`, `FirestoreService`).
  - Never call Firebase or OAuth APIs from widgets.
- **UI Consumption:**
  - All screens use `Consumer<Provider>` for state.
  - Example error/loading pattern:
    ```dart
    Consumer<AuthProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) return CircularProgressIndicator();
        if (provider.errorMessage != null) return ErrorWidget(provider.errorMessage!);
        return MainContent();
      },
    )
    ```
- **Routing:**
  - Use `context.goNamed('routeName')` and pass role/extra as needed.
- **Localization:**
  - All strings via `AppLocalizations.of(context)?.key`.
  - Add new keys to `app_localizations.dart`.
- **Testing:**
  - Widget tests use mock providers and `ChangeNotifierProvider`.

## Developer Workflows

- **Run for Web:** Use VS Code task "Run Flutter Web" (localhost:3000)
- **Build:**
  - `flutter run -d chrome` (Web)
  - `flutter run -d windows` (Windows)
  - `flutter run -d android` (Android)
- **Firebase:**
  - Configure with `flutterfire configure --project=multisales-18e57`
- **Add Feature:**
  1. Create provider in `lib/core/providers/`
  2. Register in `main.dart` MultiProvider
  3. Add service logic in `lib/core/services/`
  4. Add UI in `presentation/screens/` or `widgets/`
  5. Add routes and localization as needed

## Integration Points

- **Firebase:** All access via service classes. Config in `firebase_options.dart`.
- **OAuth2:** Use a dedicated service and provider (see `OAuthProvider` pattern). Never put OAuth logic in widgets.
- **Analytics:** Use `AnalyticsService` for custom events.

## Anti-Patterns

- Never put business logic in widgets or use `setState()` for provider-managed state.
- Never hardcode strings; always use localization.
- Never mutate provider state without error handling and `notifyListeners()`.
- Never call Firebase or external APIs directly from UI.

## Key Files & Directories

- `lib/main.dart` – MultiProvider setup, Firebase init
- `lib/core/providers/` – All app state/business logic
- `lib/core/services/` – All Firebase/external API logic
- `lib/core/routing/app_router.dart` – GoRouter config
- `lib/core/localization/app_localizations.dart` – Localization system
- `presentation/screens/` – Full-screen widgets
- `presentation/widgets/` – Reusable UI components

## Example Patterns

**Provider registration in main.dart:**
```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    // ...
  ],
  child: ...
)
```

**Service usage in provider:**
```dart
final result = await _authService.signIn(email, password);
```

**Screen consumption:**
```dart
Consumer<AuthProvider>(builder: ...)
```

---

For any new feature, follow the above structure and always use the Provider + Service + Localization pattern. See this file for updates as the codebase evolves.
