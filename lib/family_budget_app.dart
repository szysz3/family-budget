import 'package:family_budget/page/splash_page.dart';
import 'package:family_budget/widget/app_theme.dart';
import 'package:family_budget/widget/custom_scroll_behavior.dart';
import 'package:flutter/material.dart';

class FamilyBudgetApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: CustomScrollBehavior(),
          child: child,
        );
      },
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: SplashPage(),
    );
  }
}
