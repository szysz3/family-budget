import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.blueGrey,
      primaryColor: Colors.blueGrey[200],
      fontFamily: "Montserrat");

  static final ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      backgroundColor: Colors.blueGrey[600],
      cardTheme: CardTheme(color: Colors.blueGrey[50]),
      cardColor: Colors.red,
      primarySwatch: Colors.red,
      primaryColor: Colors.blueGrey[600],
      fontFamily: "Montserrat");
}
