import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(fontFamily: "Montserrat");

  static final ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.blueGrey,
      primaryColor: Colors.blueGrey[700],
      accentColor: Colors.blueGrey[400],
      fontFamily: "Montserrat");
}
