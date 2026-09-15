import 'package:flutter/material.dart';

class MonvuraTheme {
  MonvuraTheme._();

  static const Color midnight = Color(0xFF0F0B1E);
  static const Color surfaceViolet = Color(0xFF1B1530);
  static const Color surfaceElevated = Color(0xFF261D42);
  static const Color borderSubtle = Color(0xFF352B59);

  static const Color violetPrimary = Color(0xFF8B5CF6);
  static const Color lavenderAccent = Color(0xFFA78BFA);
  static const Color indigoGlow = Color(0xFF6366F1);
  static const Color roseMoon = Color(0xFFF43F5E);
  static const Color starGold = Color(0xFFFBBF24);

  static const Color textHigh = Color(0xFFF3F4F6);
  static const Color textMuted = Color(0xFF9CA3AF);
  static const Color textDim = Color(0xFF6B7280);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: midnight,
      primaryColor: violetPrimary,
      colorScheme: const ColorScheme.dark(
        primary: violetPrimary,
        secondary: lavenderAccent,
        surface: surfaceViolet,
        error: roseMoon,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textHigh,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceViolet,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: textHigh,
          fontSize: 19,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
        iconTheme: IconThemeData(color: lavenderAccent),
      ),
      cardTheme: CardThemeData(
        color: surfaceViolet,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: borderSubtle, width: 1),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surfaceViolet,
        indicatorColor: violetPrimary.withAlpha(50),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: lavenderAccent,
            );
          }
          return const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: textMuted,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: lavenderAccent);
          }
          return const IconThemeData(color: textMuted);
        }),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceElevated,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderSubtle),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderSubtle),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: lavenderAccent, width: 1.5),
        ),
        hintStyle: const TextStyle(color: textDim, fontSize: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: violetPrimary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        ),
      ),
    );
  }
}
