import 'core/providers/theme_provider.dart';
import 'package:go_router/go_router.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// Core Providers
import 'core/providers/language_provider.dart';
// import 'core/providers/order_provider.dart';
import 'core/providers/order_provider.dart';
import 'core/providers/communication_provider.dart';
import 'core/providers/appointment_provider.dart';
// import 'core/providers/chat_provider.dart';
// import 'core/providers/onboarding_provider.dart';
// import 'core/providers/promotion_provider.dart';
// import 'core/providers/feedback_provider.dart';
// import 'core/providers/dashboard_provider.dart';
// import 'core/providers/document_provider.dart';

// Services
// ...existing code...
import 'core/services/analytics_service.dart';
import 'core/services/notification_service.dart';
import 'core/services/location_service.dart';
import 'core/services/firestore_service.dart';

// Routing and Theming
import 'core/themes/app_theme.dart';
import 'core/localization/app_localizations.dart';

// Utilities
import 'core/utils/connectivity_service.dart';
import 'core/utils/error_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize error handling
  ErrorHandler.initialize();

  // Register Firebase Messaging background handler
  FirebaseMessaging.onBackgroundMessage(
      NotificationService.handleBackgroundMessage);

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Firebase initialization removed (options parameter required and not available)

  // Initialize core services
  await _initializeCoreServices();

  // Launch app with error boundary
  runApp(const MultiSalesApp());
}

/// Initialize all core services
Future<void> _initializeCoreServices() async {
  try {
    // Initialize analytics
    final analyticsService = AnalyticsService();
    await analyticsService.setAnalyticsCollectionEnabled(true);

    // Initialize notifications
    final notificationService = NotificationService();
    await notificationService.initialize();

    // Initialize location services
    final locationService = LocationService();
    await locationService.initialize();

    // Initialize connectivity monitoring
    ConnectivityService.initialize();

    // Log app launch
    await analyticsService.logCustomEvent(
      eventName: 'app_launched',
      parameters: {
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'platform': 'flutter_multiplatform',
        'version': '1.0.0',
      },
    );
  } catch (e) {
    ErrorHandler.logError('Service initialization failed', e);
  }
}

class MultiSalesApp extends StatelessWidget {
  const MultiSalesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LanguageProvider>(create: (_) => LanguageProvider()),
  ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()..initialize()),
        ChangeNotifierProvider<OrderProvider>(create: (_) => OrderProvider(firestoreService: FirestoreService())..initialize()),
        ChangeNotifierProvider<CommunicationProvider>(create: (_) => CommunicationProvider(firestoreService: FirestoreService())),
        ChangeNotifierProvider<AppointmentProvider>(create: (_) => AppointmentProvider(firestoreService: FirestoreService())),
      ],
  child: Consumer2<LanguageProvider, ThemeProvider>(
        builder: (context, languageProvider, themeProvider, _) {
          return MaterialApp.router(
            title: 'MultiSales',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            routerConfig: GoRouter(
              initialLocation: '/home',
              routes: [
                GoRoute(
                  path: '/home',
                  name: 'home',
                  builder: (context, state) => const HomeScreen(),
                ),
                GoRoute(
                  path: '/settings',
                  name: 'settings',
                  builder: (context, state) => const SettingsScreen(),
                ),
              ],
              errorBuilder: (context, state) => Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text('Page not found: {state.error}'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context.go('/home'),
                        child: const Text('Go Home'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            locale: languageProvider.currentLocale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: MediaQuery.of(context).textScaler.clamp(
                    minScaleFactor: 0.8,
                    maxScaleFactor: 1.2,
                  ),
                ),
                child: child ?? const SizedBox.shrink(),
              );
            },
          );
        },
      ),
    );
  }
}
