import 'package:flutter/material.dart';

class TextStyleTheme {
  static TextStyle get screenTitle =>
      const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2, fontSize: 25);

  static TextStyle get drawerWelcome =>
      const TextStyle(letterSpacing: 2, fontSize: 15, fontWeight: FontWeight.w500);

  static TextStyle get drawerVersion =>
      const TextStyle(letterSpacing: 1, fontSize: 12);

}
