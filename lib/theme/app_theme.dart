import 'package:flutter/material.dart';

class AppTheme {
  static const Color ink = Color(0xFF141414);
  static const Color paper = Color(0xFFF7F1E8);
  static const Color coral = Color(0xFFE96B53);
  static const Color teal = Color(0xFF1E7A72);
  static const Color gold = Color(0xFFD6A44D);
  static const Color slate = Color(0xFF4D4D4D);

  static ThemeData get lightTheme {
    final base = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: paper,
      colorScheme: ColorScheme.fromSeed(
        seedColor: coral,
        brightness: Brightness.light,
        primary: ink,
        secondary: teal,
        surface: const Color(0xFFFFFBF5),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 68,
          height: 0.95,
          fontWeight: FontWeight.w800,
          letterSpacing: -2.6,
          color: ink,
        ),
        displayMedium: TextStyle(
          fontSize: 46,
          height: 1.0,
          fontWeight: FontWeight.w800,
          letterSpacing: -1.6,
          color: ink,
        ),
        headlineMedium: TextStyle(
          fontSize: 30,
          height: 1.1,
          fontWeight: FontWeight.w700,
          color: ink,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          height: 1.2,
          fontWeight: FontWeight.w700,
          color: ink,
        ),
        bodyLarge: TextStyle(
          fontSize: 17,
          height: 1.6,
          color: ink,
        ),
        bodyMedium: TextStyle(
          fontSize: 15,
          height: 1.55,
          color: slate,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
          color: ink,
        ),
      ),
    );

    return base.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: Colors.white.withValues(alpha: 0.74),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: BorderSide(
            color: ink.withValues(alpha: 0.08),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: ink,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ink,
          side: BorderSide(color: ink.withValues(alpha: 0.18)),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        side: BorderSide(color: ink.withValues(alpha: 0.08)),
        backgroundColor: Colors.white.withValues(alpha: 0.85),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999),
        ),
      ),
    );
  }
}
