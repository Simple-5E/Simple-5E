import 'package:flutter/material.dart';

final dark = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  primaryColor: const Color(0xFF3F51B5), // Indigo
  hintColor: const Color(0xFF9E9E9E), // Medium Gray
  scaffoldBackgroundColor: const Color(0xFF121212), // Very Dark Gray
  fontFamily: 'Roboto',
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Color(0xFFE0E0E0)), // Very Light Gray
    bodyMedium: TextStyle(color: Color(0xFFBDBDBD)), // Light Gray
  ),
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF3F51B5), // Indigo
    onPrimary: Color(0xFFFFFFFF), // White
    primaryContainer: Color(0xFF303F9F), // Darker Indigo
    onPrimaryContainer: Color(0xFFE8EAF6), // Very Light Indigo
    secondary: Color(0xFF00796B), // Dark Teal
    onSecondary: Color(0xFFFFFFFF), // White
    secondaryContainer: Color(0xFF004D40), // Darker Teal
    onSecondaryContainer: Color(0xFFE0F2F1), // Very Light Teal
    error: Color(0xFFCF6679), // Light Red
    onError: Color(0xFF000000), // Very Light Gray
    surface: Color(0xFF1E1E1E), // Dark Gray
    onSurface: Color(0xFFE0E0E0), // Very Light Gray
    onSurfaceVariant: Color(0xFFBDBDBD), // Light Gray
    background: Color(0xFF121212),
    onBackground: Color(0xFFE0E0E0),
  ),
  cardTheme: CardTheme(
      color: const Color(0xFF1E1E1E), // Dark Gray
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      shadowColor: Colors.black),
  appBarTheme: const AppBarTheme(
    color: Color(0xFF1E1E1E), // Dark Gray
    elevation: 0,
    iconTheme: IconThemeData(color: Color(0xFFE0E0E0)),
    titleTextStyle: TextStyle(
      color: Color(0xFFE0E0E0),
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF2C2C2C), // Slightly Lighter Dark Gray
    hintStyle: const TextStyle(color: Color(0xFF9E9E9E)),
    labelStyle: const TextStyle(color: Color(0xFF3F51B5)), // Indigo
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFF424242)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide:
          const BorderSide(color: Color(0xFF3F51B5), width: 2), // Indigo
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFF424242)),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF3F51B5), // Indigo
      foregroundColor: const Color(0xFFFFFFFF), // White
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      elevation: 2,
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: const Color(0xFF00796B), // Dark Teal
    foregroundColor: const Color(0xFFFFFFFF), // White
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),
  iconTheme: const IconThemeData(
    color: Color(0xFFBDBDBD), // Light Gray
    size: 24.0,
  ),
);
