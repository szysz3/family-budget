import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(fontFamily: "Montserrat");

  static final ThemeData darkTheme =
      ThemeData(brightness: Brightness.dark, fontFamily: "Montserrat");
}
