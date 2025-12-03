import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multisales_app/presentation/widgets/radio_choice_chip.dart';

void main() {
  group('RadioChoiceChip', () {
    testWidgets('renders label and toggles selected icon on tap', (tester) async {
      bool selected = false;
      final chipKey = const Key('radio-chip');

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                body: Center(
                  child: RadioChoiceChip(
                    key: chipKey,
                    label: 'Option A',
                    selected: selected,
                    onTap: () => setState(() => selected = !selected),
                  ),
                ),
              );
            },
          ),
        ),
      );

      // Initially not selected
      expect(find.text('Option A'), findsOneWidget);
      expect(find.byIcon(Icons.radio_button_off), findsOneWidget);
      expect(find.byIcon(Icons.radio_button_checked), findsNothing);

      // Tap to select
      await tester.tap(find.byKey(chipKey));
      await tester.pumpAndSettle();

      // Selected state shows checked icon
      expect(find.byIcon(Icons.radio_button_checked), findsOneWidget);
      expect(find.byIcon(Icons.radio_button_off), findsNothing);
    });

    testWidgets('calls onTap callback', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RadioChoiceChip(
              key: const Key('chip'),
              label: 'Tap me',
              selected: false,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('chip')));
      await tester.pump();

      expect(tapped, isTrue);
    });
  });
}
