import 'package:flutter/material.dart';

class AugustaTheme {
  static const background = Color(0xFF1A2F1A);
  static const surface = Color(0xFF2D4A2D);
  static const gold = Color(0xFFC9A84C);
  static const textPrimary = Color(0xFFF5F0E8);
  static const textSecondary = Color(0xFFA8C8A8);

  static ThemeData get dark => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: background,
        colorScheme: const ColorScheme.dark(
          primary: gold,
          secondary: gold,
          surface: surface,
          onPrimary: background,
          onSecondary: background,
          onSurface: textPrimary,
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontFamily: 'PlayfairDisplay', fontSize: 32, fontWeight: FontWeight.bold, color: textPrimary, letterSpacing: 1.5),
          headlineMedium: TextStyle(fontFamily: 'PlayfairDisplay', fontSize: 24, fontWeight: FontWeight.bold, color: textPrimary, letterSpacing: 1.0),
          titleLarge: TextStyle(fontFamily: 'PlayfairDisplay', fontSize: 20, fontWeight: FontWeight.bold, color: textPrimary),
          labelLarge: TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.bold, color: gold, letterSpacing: 3.0),
          bodyLarge: TextStyle(fontFamily: 'Inter', fontSize: 16, color: textPrimary),
          bodyMedium: TextStyle(fontFamily: 'Inter', fontSize: 14, color: textSecondary),
        ),
        appBarTheme: const AppBarTheme(backgroundColor: background, foregroundColor: textPrimary, elevation: 0),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(backgroundColor: background, selectedItemColor: gold, unselectedItemColor: textSecondary),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: gold, foregroundColor: background,
            textStyle: const TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 2.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          ),
        ),
      );
}
