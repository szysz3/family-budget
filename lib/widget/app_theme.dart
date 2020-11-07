import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(fontFamily: "Montserrat");

  static final ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.blueGrey,
      primaryColor: colorSchemeDark.primary,
      accentColor: colorSchemeDark.secondary,
      cardTheme: CardTheme(elevation: 8),
      cardColor: colorSchemeDark.surface,
      canvasColor: colorSchemeDark.background,
      colorScheme: colorSchemeDark,
      fontFamily: "Montserrat");

  static final ColorScheme colorSchemeDark = ColorScheme.dark(
      primary: Colors.blueGrey[700],
      primaryVariant: Colors.blueGrey[900],
      secondary: Colors.blueGrey[400],
      secondaryVariant: Colors.blueGrey[600],
      background: Colors.grey[900],
      surface: Colors.grey[850]);
}
