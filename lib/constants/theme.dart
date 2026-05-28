import 'package:dental/constants/fonts.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.dark(
      brightness: Brightness.dark,     
      primary: const Color(0xFF6ACCCA),
      secondary: const Color(0xFF9FE2BF),
      tertiary: const Color(0xFFC2C4C4),
    ),
    primaryColor: Colors.blue,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
    ),
    fontFamily: 'Nunito',
    fontFamilyFallback: ['Roboto', 'Arial', 'sans-serif'],
    textTheme: FontsTheme.darktextTheme,
  );
  static final ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.light(
      brightness: Brightness.light,
      primary: const Color(0xFF6ACCCA),
      secondary: const Color(0xFF9FE2BF),
      tertiary: const Color(0xFFC2C4C4),
    ),
    primaryColor: Colors.blue,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
    ),
    fontFamily: 'Nunito',
    fontFamilyFallback: ['Roboto', 'Arial', 'sans-serif'],
    textTheme: FontsTheme.lighttextTheme,
  );
}
