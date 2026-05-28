import 'package:flutter/material.dart';

class FontsTheme {
  static final TextTheme lighttextTheme = TextTheme(
    titleMedium: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    ),
    bodyLarge: TextStyle(fontSize: 18, color: Colors.black87),
    bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
    bodySmall: TextStyle(fontSize: 14, color: Colors.black54),
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w200,    
      color: Colors.black87,
    ),
    headlineMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w200,
      color: Colors.black87,
    ),
    headlineSmall: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w300,
      color: Colors.black87,
    ),
  );
  static final TextTheme darktextTheme = lighttextTheme.apply(
    bodyColor: Colors.white70,
    displayColor: Colors.white70,
  );
}
