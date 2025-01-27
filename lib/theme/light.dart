import 'package:flutter/material.dart';

final light = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  primaryColor: const Color(0x001E3C54), // Deep Blue
  hintColor: const Color(0xFF6D7F8F), // Muted Blue Grey
  scaffoldBackgroundColor: const Color(0xFFF0F4F8), // Very Light Blue Grey
  fontFamily: 'Roboto',
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Color(0xFF1F3751)), // Deep Blue
    bodyMedium: TextStyle(color: Color(0xFF3A5068)), // Medium Blue
  ),
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF1F3751), // Deep Blue
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFD0E4FF), // Light Blue
    onPrimaryContainer: Color(0xFF0D1C2A), // Very Dark Blue
    secondary: Color(0xFF4A6572), // Blue Grey
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFFCDE5FF), // Very Light Blue
    onSecondaryContainer: Color(0xFF0D1C2A), // Very Dark Blue
    error: Color(0xFFBA1A1A), // Red
    onError: Colors.white,
    surface: Colors.white,
    onSurface: Color(0xFF1F3751), // Deep Blue
    surfaceContainerHighest: Color(0xFFE1E9F0), // Light Blue Grey
    onSurfaceVariant: Color(0xFF3A5068), // Medium Blue
  ),
  cardTheme: CardTheme(
    color: Colors.white,
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    shadowColor: const Color(0xFF1F3751).withValues(alpha: 0.1),
  ),
  appBarTheme: const AppBarTheme(
    color: Color(0xFF1F3751), // Deep Blue
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    hintStyle: TextStyle(color: Color(0xFF6D7F8F)),
    labelStyle: TextStyle(color: Color(0xFF1F3751)),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Color(0xFFB0BEC5)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Color(0xFF1F3751), width: 2),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Color(0xFFB0BEC5)),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF1F3751),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      elevation: 2,
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF4A6572),
    foregroundColor: Colors.white,
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  ),
);
