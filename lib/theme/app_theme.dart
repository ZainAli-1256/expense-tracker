import 'package:flutter/material.dart';

/// Modern dark theme for the Expense Tracker app
class AppTheme {
  // Dark mode color palette
  static const Color primaryDark = Color(0xFF1A1A2E); // Deep navy
  static const Color secondaryDark = Color(0xFF16213E); // Darker navy
  static const Color accentPurple = Color(0xFF7C3AED); // Vibrant purple
  static const Color accentBlue = Color(0xFF3B82F6); // Bright blue
  static const Color greenSuccess = Color(0xFF10B981); // Success green
  static const Color redError = Color(0xFFEF4444); // Error red
  static const Color textLight = Color(0xFFF3F4F6); // Light gray
  static const Color textMuted = Color(0xFF9CA3AF); // Muted gray
  static const Color surfaceDark = Color(0xFF0F172A); // Darkest surface
  static const Color cardDark = Color(0xFF1E293B); // Card background

  // Gradient colors
  static const List<Color> gradientPurpleBlue = [accentPurple, accentBlue];

  static const List<Color> gradientGreen = [greenSuccess, Color(0xFF059669)];

  static const List<Color> gradientRed = [redError, Color(0xFFDC2626)];

  // Get dark theme
  static ThemeData getDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: accentPurple,
      scaffoldBackgroundColor: primaryDark,

      // Color scheme
      colorScheme: const ColorScheme.dark(
        primary: accentPurple,
        secondary: accentBlue,
        tertiary: greenSuccess,
        error: redError,
        surface: cardDark,
        onPrimary: textLight,
        onSecondary: textLight,
        onSurface: textLight,
      ),

      // App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryDark,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textLight,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Text Themes
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: textLight,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: textLight,
        ),
        headlineSmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textLight,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textLight,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textLight,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: textLight,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textMuted,
        ),
        labelSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textMuted,
        ),
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentPurple,
          foregroundColor: textLight,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      // Card Theme - ✅ FIXED
      cardTheme: CardThemeData(
        color: cardDark,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardDark,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF374151), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: accentPurple, width: 2),
        ),
        hintStyle: const TextStyle(color: textMuted, fontSize: 14),
        labelStyle: const TextStyle(color: textLight, fontSize: 14),
      ),

      // FAB Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: accentPurple,
        foregroundColor: textLight,
        elevation: 8,
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: Color(0xFF374151),
        thickness: 1,
      ),
    );
  }
}
