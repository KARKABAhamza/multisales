import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:multisales_app/core/providers/optimized_auth_provider.dart';
import 'package:multisales_app/router.dart';
import 'package:multisales_app/l10n/app_localizations.dart' as l10n;
import 'package:multisales_app/core/services/auth_service.dart';

class _MockAuthService extends AuthService {
  @override
  bool isAdminEmail() => false;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('/admin redirects non-admin to /', (WidgetTester tester) async {
    // Provide a larger surface to avoid app bar overflow in tests
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    final auth = OptimizedAuthProvider(authService: _MockAuthService());
    // Simulate non-admin (no @multisales.com email)
    auth.setAuthenticated(true);

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(size: Size(1280, 800), devicePixelRatio: 1.0),
        child: MultiProvider(
          providers: [ChangeNotifierProvider(create: (_) => auth)],
          child: MaterialApp.router(
            routerConfig: appRouter,
            localizationsDelegates: l10n.AppLocalizations.localizationsDelegates,
            supportedLocales: l10n.AppLocalizations.supportedLocales,
          ),
        ),
      ),
    );

    // Try to navigate to /admin
    final router = appRouter;
    router.go('/admin');
    await tester.pumpAndSettle();

    // Expect current location not /admin (redirected to /)
    expect(router.routerDelegate.currentConfiguration.fullPath, '/');
  });
}
