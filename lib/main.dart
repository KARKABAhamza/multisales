import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'router.dart';
import 'design/design_tokens.dart';
import 'l10n/app_localizations.dart';
import 'core/providers/language_provider.dart';
import 'core/providers/optimized_auth_provider.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/providers/contact_provider.dart';
import 'core/providers/messaging_provider.dart';
import 'core/providers/storage_upload_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MultiSalesApp());
}

class MultiSalesApp extends StatelessWidget {
  const MultiSalesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => OptimizedAuthProvider()),
        ChangeNotifierProvider(create: (_) => ContactProvider()),
        // Register push messaging provider (Web/Mobile)
        ChangeNotifierProvider(create: (_) => MessagingProvider()),
        // Storage upload (signed URL) provider
        ChangeNotifierProvider(create: (_) => StorageUploadProvider()),
      ],
      child: Consumer<LanguageProvider>(
        builder: (context, lang, _) => MaterialApp.router(
          title: 'MULTISALES',
          theme: ThemeData(
            useMaterial3: true,
            primaryColor: DesignTokens.primary,
            scaffoldBackgroundColor: Colors.white,
            colorScheme: ColorScheme.fromSeed(
              seedColor: DesignTokens.primary,
              brightness: Brightness.light,
              primary: DesignTokens.primary,
              secondary: DesignTokens.secondary,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: DesignTokens.primary,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: DesignTokens.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            outlinedButtonTheme: OutlinedButtonThemeData(
              style: OutlinedButton.styleFrom(
                foregroundColor: DesignTokens.primary,
                side: const BorderSide(color: DesignTokens.primary, width: 1.4),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: DesignTokens.primary),
            ),
            textTheme: DesignTokens.textTheme,
          ),
          darkTheme: ThemeData.dark(),
          routerConfig: appRouter,
          debugShowCheckedModeBanner: false,
          // Localization
          locale: lang.currentLocale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
  }
}
