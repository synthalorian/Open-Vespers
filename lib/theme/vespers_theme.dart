import 'package:flutter/material.dart';

class VespersTheme {
  static const Color background = Color(0xFF0F1118);
  static const Color surface = Color(0xFF181C28);
  static const Color surfaceLight = Color(0xFF1F2536);
  static const Color warmGold = Color(0xFFD4A86A);
  static const Color softAmber = Color(0xFFE8C496);
  static const Color deepBlue = Color(0xFF2D3A5C);
  static const Color twilight = Color(0xFF4A3F6B);
  static const Color starlight = Color(0xFFBFB8D0);
  static const Color textPrimary = Color(0xFFE8E4DF);
  static const Color textSecondary = Color(0xFF8A8698);
  static const Color divider = Color(0xFF252A3A);

  static ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: background,
        colorScheme: const ColorScheme.dark(
          primary: warmGold,
          secondary: twilight,
          surface: surface,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: warmGold,
          elevation: 0,
        ),
        cardTheme: const CardThemeData(
          color: surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: warmGold,
          foregroundColor: Color(0xFF1A1A2E),
        ),
        useMaterial3: true,
      );
}
