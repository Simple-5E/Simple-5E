import 'package:flutter/material.dart';

final light = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  primaryColor: const Color(0xFF1E88E5), // Slightly muted blue
  hintColor: const Color(0xFF9E9E9E), // Medium Gray
  scaffoldBackgroundColor: const Color(0xFFFAFAFA), // Very Light Gray
  fontFamily: 'Roboto',
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Color(0xFF424242)), // Dark Gray
    bodyMedium: TextStyle(color: Color(0xFF616161)), // Medium Dark Gray
  ),
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF1E88E5), // Slightly muted blue
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFE3F2FD), // Very Light Blue
    onPrimaryContainer: Color(0xFF1565C0), // Darker Blue
    secondary: Color(0xFF26A69A), // Teal
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFFE0F2F1), // Very Light Teal
    onSecondaryContainer: Color(0xFF00796B), // Dark Teal
    error: Color(0xFFD32F2F), // Error Red
    onError: Colors.white, // Dark Gray
    surface: Colors.white,
    onSurface: Color(0xFF424242), // Dark Gray
    surfaceContainerHighest: Color(0xFFEEEEEE), // Light Gray
    onSurfaceVariant: Color(0xFF616161), // Medium Dark Gray
  ),
  cardTheme: CardTheme(
    color: Colors.white,
    elevation: 1,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    shadowColor: Colors.black.withOpacity(0.1),
  ),
  appBarTheme: const AppBarTheme(
    color: Color(0xFF1E88E5), // Slightly muted blue
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
    hintStyle: TextStyle(color: Color(0xFF9E9E9E)),
    labelStyle: TextStyle(color: Color(0xFF1E88E5)),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Color(0xFFBDBDBD)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Color(0xFF1E88E5), width: 2),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Color(0xFFBDBDBD)),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF1E88E5),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      elevation: 1,
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF26A69A),
    foregroundColor: Colors.white,
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),
);
