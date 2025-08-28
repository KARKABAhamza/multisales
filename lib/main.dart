import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'firebase_options.dart';
import 'core/providers/auth_provider.dart';
import 'core/providers/onboarding_provider.dart';
import 'core/providers/training_provider.dart';
import 'core/providers/language_provider.dart';
import 'core/providers/firebase_provider.dart';
import 'core/providers/appointment_provider.dart';
import 'core/services/firestore_service.dart';
import 'core/routing/app_router.dart';
import 'core/themes/app_theme.dart';
import 'core/localization/app_localizations.dart';
import 'core/services/analytics_service.dart';
import 'core/services/firebase_service.dart';
import 'core/providers/oauth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation complète de Firebase avec tous les services
  final firebaseService = FirebaseService();
  await firebaseService.initializeFirebase(
    options: DefaultFirebaseOptions.currentPlatform,
    enableCrashlytics: true,
    enablePerformance: true,
    enableAnalytics: true,
    enableRemoteConfig: true,
    enableMessaging: true,
    enableAppCheck: false, // Désactivé par défaut
  );

  // Initialiser Analytics (optionnel, déjà fait dans FirebaseService)
  final analyticsService = AnalyticsService();
  await analyticsService.setAnalyticsCollectionEnabled(true);

  // Log de l'initialisation de l'app
  await analyticsService.logCustomEvent(
    eventName: 'app_launched',
    parameters: <String, Object>{
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'platform': 'flutter_multiplatform',
    },
  );

  runApp(const MultiSalesApp());
}

class MultiSalesApp extends StatelessWidget {
  const MultiSalesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FirebaseProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => OnboardingProvider()),
        ChangeNotifierProvider(create: (_) => TrainingProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(
            create: (_) => AppointmentProvider(
                  firestoreService: FirestoreService(),
                )),
        ChangeNotifierProvider(create: (_) => OAuthProvider()),
      ],
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          return MaterialApp.router(
            title: 'MultiSales Onboarding',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            routerConfig: AppRouter.router,
            locale: languageProvider.currentLocale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
