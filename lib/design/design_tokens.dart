import 'package:flutter/material.dart';

class DesignTokens {
  // Colors
  static const Color primary = Color(0xFF0D47A1);
  static const Color secondary = Color(0xFFFF7043);
  static const Color neutralBg = Color(0xFFF7F7F7);
  static const Color neutralDark = Color(0xFF121212);

  // Spacing
  static const double spacingSmall = 8.0;
  static const double spacing = 16.0;
  static const double spacingLarge = 32.0;

  // Typography
  static final TextTheme textTheme = TextTheme(
    displayLarge: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
    headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
    titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
    bodyLarge: TextStyle(fontSize: 16),
    bodyMedium: TextStyle(fontSize: 14),
  );
}
