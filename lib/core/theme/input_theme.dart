import 'package:flutter/material.dart';

class InputTheme {
  InputDecorationTheme initTheme() {
    return InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}