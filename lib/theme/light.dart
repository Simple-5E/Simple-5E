import 'package:flutter/material.dart';

final light = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF1F3751),
    brightness: Brightness.light,
  ).copyWith(
    onPrimary: Colors.white,
  ),
  cardTheme: const CardThemeData(
    elevation: 1,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1F3751),
    foregroundColor: Colors.white,
    centerTitle: false,
    elevation: 0,
    scrolledUnderElevation: 3,
    surfaceTintColor: Color(0xFF1F3751),
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w500,
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 1,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
    ).copyWith(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        return ColorScheme.fromSeed(
          seedColor: const Color(0xFF1F3751),
          brightness: Brightness.light,
        ).primary;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        return ColorScheme.fromSeed(
          seedColor: const Color(0xFF1F3751),
          brightness: Brightness.light,
        ).onPrimary;
      }),
    ),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    elevation: 3,
    focusElevation: 6,
    hoverElevation: 4,
    highlightElevation: 6,
    shape: CircleBorder(),
  ),
);
