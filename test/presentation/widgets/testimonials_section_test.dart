import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:multisales_app/presentation/widgets/testimonials_section.dart';
// No localization delegates needed for these tests

Widget _wrapWithApp(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  group('TestimonialsSection', () {
    testWidgets('renders default testimonials with quotes and authors', (tester) async {
      await tester.pumpWidget(_wrapWithApp(const TestimonialsSection()));
      await tester.pumpAndSettle();

      // Expect three testimonial authors from defaults
      expect(find.textContaining('Ahmed, CEO at SkyConnect'), findsOneWidget);
      expect(find.textContaining('Sofia, Operations Manager at TechWave'), findsOneWidget);
      expect(find.textContaining('Youssef, Sales Director at AtlasCorp'), findsOneWidget);

      // Expect the read case study button label to exist at least once
      expect(find.textContaining('Read case study'), findsWidgets);
    });
  });

  group('TrustedBySection', () {
    testWidgets('renders partner logos with tooltips', (tester) async {
      await tester.pumpWidget(_wrapWithApp(const TrustedBySection()));
      await tester.pumpAndSettle();

      // Expect tooltips with partner names
      expect(find.byWidgetPredicate((w) => w is Tooltip && w.message == 'SkyConnect'), findsOneWidget);
      expect(find.byWidgetPredicate((w) => w is Tooltip && w.message == 'TechWave'), findsOneWidget);
      expect(find.byWidgetPredicate((w) => w is Tooltip && w.message == 'AtlasCorp'), findsOneWidget);
    });
  });
}
