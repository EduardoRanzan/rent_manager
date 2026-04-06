import 'package:flutter/material.dart';
import 'package:rent_manager/core/theme/input_theme.dart';

class AppTheme {
  static ThemeData initTheme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.amberAccent,
      brightness: Brightness.dark,
    );

    return ThemeData(
      colorScheme: colorScheme,
      inputDecorationTheme: InputTheme().initTheme(),
    );
  }
}