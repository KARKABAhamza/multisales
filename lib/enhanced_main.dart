import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';

// Core Providers
import 'core/providers/optimized_auth_provider.dart';
import 'core/providers/language_provider.dart';
import 'core/providers/theme_provider.dart';

// Business Logic Providers
import 'core/providers/account_provider.dart';
import 'core/providers/product_catalog_provider.dart';
import 'core/providers/support_provider.dart';
import 'core/providers/notification_provider.dart';
import 'core/providers/location_provider.dart';
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
import 'core/services/firebase_service.dart';
import 'core/services/analytics_service.dart';
import 'core/services/notification_service.dart';
import 'core/services/location_service.dart';
import 'core/services/firestore_service.dart';

// Routing and Theming
import 'core/routing/simple_app_router.dart';
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

  // Initialize Firebase with comprehensive services
  final firebaseService = FirebaseService();
  await firebaseService.initializeFirebase(
    options: DefaultFirebaseOptions.currentPlatform,
    enableCrashlytics: true,
    enablePerformance: true,
    enableAnalytics: true,
    enableRemoteConfig: true,
    enableMessaging: true,
    enableAppCheck: true,
  );

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
        // Core Providers
        ChangeNotifierProvider(
          create: (_) => OptimizedAuthProvider()..initialize(),
        ),
        ChangeNotifierProvider(
          create: (_) => LanguageProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider()..initialize(),
        ),

        // Business Logic Providers - Account Management
        ChangeNotifierProvider(
          create: (context) => AccountProvider(
            context.read<OptimizedAuthProvider>(),
          ),
        ),

        // Business Logic Providers - Products & Services
        ChangeNotifierProvider(
          create: (_) => ProductCatalogProvider()..initialize(),
        ),

        // Business Logic Providers - Support & Communication
        ChangeNotifierProvider(
          create: (_) => SupportProvider(
            firestoreService: FirestoreService(),
          ),
        ),

        // Business Logic Providers - Notifications & Location
        ChangeNotifierProvider(
          create: (_) => NotificationProvider(
            firestoreService: FirestoreService(),
          )..initialize(),
        ),
        ChangeNotifierProvider(
          create: (_) => LocationProvider()..initialize(),
        ),

        // Business Logic Providers - Orders & E-commerce
        ChangeNotifierProvider(
          create: (_) => OrderProvider(
            firestoreService: FirestoreService(),
          )..initialize(),
        ),

        // Business Logic Providers - Communications
        ChangeNotifierProvider(
          create: (_) => CommunicationProvider(
            firestoreService: FirestoreService(),
          ),
        ),

        // Business Logic Providers - Appointments & Scheduling
        ChangeNotifierProvider(
          create: (_) => AppointmentProvider(
            firestoreService: FirestoreService(),
          ),
        ),
      ],
      child: Consumer3<LanguageProvider, ThemeProvider, OptimizedAuthProvider>(
        builder: (context, languageProvider, themeProvider, authProvider, _) {
          return MaterialApp.router(
            title: 'MultiSales',

            // Theme Configuration
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,

            // Routing Configuration
            routerConfig: SimpleAppRouter.createRouter(authProvider),

            // Localization Configuration
            locale: languageProvider.currentLocale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,

            // Performance & Debug Configuration
            debugShowCheckedModeBanner: false,

            // Global UI Configuration
            builder: (context, child) {
              return MediaQuery(
                // Ensure text scaling doesn't break layouts
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
