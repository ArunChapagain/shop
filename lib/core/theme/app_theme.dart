import 'package:flutter/material.dart';

class AppTheme {
  // Color palette based on the UI design
  static const Color primaryColor = Color(0xFFFF6600); // Orange accent color
  static const Color backgroundColor = Color.fromARGB(
    255,
    255,
    229,
    215,
  ); // Light orange background color
  static const Color textPrimaryColor = Color(
    0xFF333333,
  ); // Dark grey for primary text
  static const Color textSecondaryColor = Color(
    0xFF666666,
  ); // Light grey for secondary text
  static const Color cardBackgroundColor = Colors.white;
  static const Color shadowColor = Color(0x29000000); // Subtle shadow color

  // Light Theme
  static ThemeData lightTheme() {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: const Color(0xFFF6EAE4),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFFF6EAE4),
        foregroundColor: textPrimaryColor,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      textTheme: TextTheme(
        titleLarge: TextStyle(
          color: textPrimaryColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: TextStyle(
          color: textPrimaryColor,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        bodyMedium: TextStyle(color: textSecondaryColor, fontSize: 14),
      ),
      cardTheme: CardTheme(
        color: cardBackgroundColor,
        elevation: 4,
        shadowColor: shadowColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
