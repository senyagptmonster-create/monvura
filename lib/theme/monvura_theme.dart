import 'package:flutter/material.dart';

class MonvuraTheme {
  static const background = Color(0xFF080B14);
  static const surface = Color(0xFF101424);
  static const card = Color(0xFF181F38);
  static const indigo = Color(0xFF6366F1);
  static const lavender = Color(0xFFA5B4FC);
  static const cyan = Color(0xFF06B6D4);
  static const textPrimary = Color(0xFFEEF2FF);
  static const textSecondary = Color(0xFF94A3B8);

  static ThemeData get themeData {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: indigo,
      cardColor: card,
      fontFamily: 'AppFont',
      colorScheme: const ColorScheme.dark(
        primary: indigo,
        secondary: lavender,
        surface: surface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
