import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData initTheme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.amberAccent,
      brightness: Brightness.dark,
    );

    return ThemeData(
      colorScheme: colorScheme
    );
  }
}