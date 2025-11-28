// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:ui' as ui;
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:multisales_app/main.dart';
import 'package:firebase_core/firebase_core.dart';
// ignore: unused_import
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseCoreMocks();

  testWidgets('MultiSales app smoke test', (WidgetTester tester) async {
    // Mock Firebase initialization
    await Firebase.initializeApp();
    tester.view.physicalSize = const ui.Size(1280, 1024);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    // Build app and trigger a frame
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(
          size: ui.Size(1920, 1200),
          devicePixelRatio: 1.0,
        ),
        child: const MultiSalesApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify that a MaterialApp is present (MaterialApp.router under the hood)
    expect(find.byType(MaterialApp), findsOneWidget);

    // Verify the debug banner is disabled
    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.debugShowCheckedModeBanner, isFalse);
  });
}
