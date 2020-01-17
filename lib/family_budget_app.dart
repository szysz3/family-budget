import 'package:family_budget/page/splash_page.dart';
import 'package:flutter/material.dart';

class FamilyBudgetApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blueGrey,
        fontFamily: 'Montserrat',
      ),
      home: SplashPage(),
    );
  }
}
