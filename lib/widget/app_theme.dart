import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.blueGrey,
      primaryColor: colorSchemeLight.primary,
      accentColor: colorSchemeLight.secondary,
      cardTheme: CardTheme(elevation: 8),
      cardColor: colorSchemeLight.surface,
      canvasColor: colorSchemeLight.background,
      colorScheme: colorSchemeLight,
      fontFamily: "Montserrat");

  static final ColorScheme colorSchemeLight = ColorScheme.light(
    primary: Colors.blueGrey[300],
    primaryVariant: Colors.blueGrey[100],
    secondary: Colors.blueGrey[50],
    secondaryVariant: Colors.blueGrey[100],
    background: Colors.blueGrey[50],
    surface: Colors.grey[50],
    onSurface: Colors.grey[800],
  );

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
