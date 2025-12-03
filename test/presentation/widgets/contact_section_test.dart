import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:multisales_app/presentation/widgets/contact_section.dart';
import 'package:multisales_app/core/providers/contact_provider.dart';
import 'package:multisales_app/core/services/contact_service.dart';

class _FakeContactService extends ContactService {
  bool called = false;

  @override
  Future<void> submitContact({
    required String name,
    required String email,
    required String message,
  }) async {
    called = true;
    // Simulate a tiny delay to reflect async work
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }
}

void main() {
  testWidgets('ContactSection happy path shows success SnackBar and calls service', (tester) async {
    final fakeService = _FakeContactService();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => ContactProvider(service: fakeService),
          ),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: ContactSection()),
          ),
        ),
      ),
    );

    // Fill in the form fields (order: name, email, message)
    final nameField = find.byType(TextFormField).at(0);
    final emailField = find.byType(TextFormField).at(1);
    final messageField = find.byType(TextFormField).at(2);

    await tester.enterText(nameField, 'Jean Dupont');
    await tester.enterText(emailField, 'jean.dupont@example.com');
    await tester.enterText(messageField, 'Bonjour, ceci est un message de test.');

    // Tap the submit button
  final sendLabel = find.text('Envoyer le message');
  expect(sendLabel, findsOneWidget);
  await tester.ensureVisible(sendLabel);
  await tester.tap(sendLabel);
    await tester.pumpAndSettle();

    // Expect a success SnackBar message
    expect(find.text('Merci — votre message a été envoyé.'), findsOneWidget);

    // Service should have been called
    expect(fakeService.called, isTrue);
  });

  testWidgets('ContactSection error path shows error SnackBar when service fails', (tester) async {
    // A failing fake service that throws
    final failingService = _FailingContactService();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => ContactProvider(service: failingService),
          ),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: ContactSection()),
          ),
        ),
      ),
    );

    // Fill in minimal valid inputs
    await tester.enterText(find.byType(TextFormField).at(0), 'Jean Dupont');
    await tester.enterText(find.byType(TextFormField).at(1), 'jean.dupont@example.com');
    await tester.enterText(find.byType(TextFormField).at(2), 'Message insuffisant mais > 10 caractères.');

    // Submit
    final sendLabel = find.text('Envoyer le message');
    await tester.ensureVisible(sendLabel);
    await tester.tap(sendLabel);
    await tester.pumpAndSettle();

    // Expect the error snackbar message
    expect(find.text('Échec de l’envoi. Réessayez plus tard.'), findsOneWidget);
  });

  testWidgets('ContactSection shows download confirmation dialog when brochure button tapped', (tester) async {
    bool downloadCalled = false;
    final fakeService = _FakeContactService();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => ContactProvider(service: fakeService),
          ),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: ContactSection(
                onDownloadBrochure: () {
                  downloadCalled = true;
                },
              ),
            ),
          ),
        ),
      ),
    );

    // Find and tap the download brochure button
    final downloadButton = find.text('Télécharger brochure (PDF)');
    expect(downloadButton, findsOneWidget);
    await tester.ensureVisible(downloadButton);
    await tester.tap(downloadButton);
    await tester.pumpAndSettle();

    // Verify that the confirmation dialog appears
    expect(find.text('Confirmer le téléchargement'), findsOneWidget);
    expect(find.text('Vous êtes sur le point de télécharger notre brochure produits en format PDF. Souhaitez-vous continuer ?'), findsOneWidget);

    // Verify that cancel and proceed buttons are present
    expect(find.text('Annuler'), findsOneWidget);
    expect(find.text('Télécharger'), findsOneWidget);

    // Download should not have been called yet
    expect(downloadCalled, isFalse);
  });

  testWidgets('ContactSection download is cancelled when user taps cancel', (tester) async {
    bool downloadCalled = false;
    final fakeService = _FakeContactService();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => ContactProvider(service: fakeService),
          ),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: ContactSection(
                onDownloadBrochure: () {
                  downloadCalled = true;
                },
              ),
            ),
          ),
        ),
      ),
    );

    // Find and tap the download brochure button
    final downloadButton = find.text('Télécharger brochure (PDF)');
    await tester.ensureVisible(downloadButton);
    await tester.tap(downloadButton);
    await tester.pumpAndSettle();

    // Tap cancel button
    final cancelButton = find.text('Annuler');
    await tester.tap(cancelButton);
    await tester.pumpAndSettle();

    // Download should not have been called
    expect(downloadCalled, isFalse);

    // Dialog should be dismissed
    expect(find.text('Confirmer le téléchargement'), findsNothing);
  });

  testWidgets('ContactSection download proceeds when user confirms', (tester) async {
    bool downloadCalled = false;
    final fakeService = _FakeContactService();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => ContactProvider(service: fakeService),
          ),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: ContactSection(
                onDownloadBrochure: () {
                  downloadCalled = true;
                },
              ),
            ),
          ),
        ),
      ),
    );

    // Find and tap the download brochure button
    final downloadButton = find.text('Télécharger brochure (PDF)');
    await tester.ensureVisible(downloadButton);
    await tester.tap(downloadButton);
    await tester.pumpAndSettle();

    // Verify the dialog appeared
    expect(find.text('Confirmer le téléchargement'), findsOneWidget);

    // Find the proceed button in the dialog (ElevatedButton with text "Télécharger")
    final proceedButton = find.descendant(
      of: find.byType(AlertDialog),
      matching: find.widgetWithText(ElevatedButton, 'Télécharger'),
    );
    expect(proceedButton, findsOneWidget);
    await tester.tap(proceedButton);
    await tester.pumpAndSettle();

    // Download should have been called
    expect(downloadCalled, isTrue);

    // Dialog should be dismissed
    expect(find.text('Confirmer le téléchargement'), findsNothing);
  });
}

class _FailingContactService extends ContactService {
  @override
  Future<void> submitContact({
    required String name,
    required String email,
    required String message,
  }) async {
    throw Exception('Simulated failure');
  }
}
