import 'package:flutter/material.dart';

sealed class UiConfig {
  static ThemeData get thema => ThemeData(
        primarySwatch: Colors.deepOrange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            minimumSize: const WidgetStatePropertyAll(
              Size(220, 60),
            ),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 24,
              ),
            ),
            textStyle: WidgetStateProperty.all(
              const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
}
