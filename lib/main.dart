import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'family_budget_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  _initCrashlytics();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) => {
            SystemChrome.setSystemUIOverlayStyle(
                SystemUiOverlayStyle(statusBarColor: Colors.transparent))
          })
      .then((_) {
    runZoned<Future<void>>(() async {
      runApp(FamilyBudgetApp());
    }, onError: Crashlytics.instance.recordError);
  });
}

_initCrashlytics() {
  Crashlytics.instance.enableInDevMode = true;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
}
