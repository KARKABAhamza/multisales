import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:multisales_app/core/providers/contact_provider.dart';
import 'package:multisales_app/pages/contact_page.dart';
import 'package:multisales_app/l10n/app_localizations.dart' as l10n;
import 'package:multisales_app/core/providers/optimized_auth_provider.dart';
import 'package:multisales_app/core/services/auth_service.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:firebase_core/firebase_core.dart';

class _MockAuthService extends AuthService {
  @override
  bool isAdminEmail() => false;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseCoreMocks();
  // ignore: discarded_futures
  Firebase.initializeApp();

  testWidgets('Contact form validation shows error on invalid email', (WidgetTester tester) async {
    // Ensure enough space to layout complex page without overflows
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ContactProvider()),
          ChangeNotifierProvider(create: (_) => OptimizedAuthProvider(authService: _MockAuthService())),
        ],
        child: MaterialApp(
          locale: const Locale('fr'),
          localizationsDelegates: l10n.AppLocalizations.localizationsDelegates,
          supportedLocales: l10n.AppLocalizations.supportedLocales,
          home: const ContactPage(),
        ),
      ),
    );

    // Let initial layouts settle
    await tester.pumpAndSettle();

    // Enter invalid email and try to submit
    final emailField = find.widgetWithText(TextFormField, 'Email Address');
    expect(emailField, findsOneWidget);
    await tester.ensureVisible(emailField);
    await tester.tap(emailField);
    await tester.pump();
    await tester.enterText(emailField, 'invalid-email');

    final nameField = find.widgetWithText(TextFormField, 'First Name / Last Name');
    await tester.ensureVisible(nameField);
    await tester.tap(nameField);
    await tester.pump();
    await tester.enterText(nameField, 'Test User');

    final sendButton = find.text('Envoyer');
    await tester.ensureVisible(sendButton);
    await tester.tap(sendButton);
    await tester.pumpAndSettle();

    // Expect validation error
    expect(find.text('Please enter a valid email address'), findsOneWidget);
  });
}
