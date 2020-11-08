import 'package:family_budget/util/view_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';

import '../util/auth.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final logger = Logger();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                Theme.of(context).colorScheme.background,
                Theme.of(context).colorScheme.surface
              ])),
          child: Builder(builder: (BuildContext context) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(bottom: 32),
                  child: Text(
                    'Please log in',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
                SizedBox(
                  height: 200,
                  child: _getLoginButtonsCard(context),
                ),
              ],
            );
          })),
    );
  }

  Widget _getLoginButtonsCard(BuildContext context) {
    return Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        margin: const EdgeInsets.only(left: 32, right: 32),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _getLoginButton(context, "assets/google.svg",
                _onGoogleSignInPressed, CircleBorder()),
            _getLoginButton(
                context,
                "assets/facebook.svg",
                _onFacebookSignInPressed,
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0))))
          ],
        ));
  }

  Widget _getLoginButton(BuildContext context, String iconPath,
      Function onPressedAction, OutlinedBorder border) {
    return Flexible(
      child: RawMaterialButton(
        elevation: 0,
        shape: border,
        onPressed: () {
          onPressedAction(context);
        },
        padding: EdgeInsets.all(8),
        child: SvgPicture.asset(iconPath, height: 100),
      ),
    );
  }

  _onGoogleSignInPressed(BuildContext scaffoldContext) async {
    SignInResult _signInResult;
    try {
      _signInResult = await Auth().signInWithGoogle();
    } on Exception catch (exception) {
      ViewUtil.showErrorSnackbar(
          "Sign in failed. Reason: $exception", scaffoldContext);
      return;
    }
    _navigateToHomePage(_signInResult);
  }

  _navigateToHomePage(SignInResult singInResult) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => HomePage(
                  signInResult: singInResult,
                )),
        (r) => false);
  }

  _onFacebookSignInPressed(BuildContext scaffoldContext) {
    ViewUtil.showErrorSnackbar("Not implemented yet!", scaffoldContext);
  }
}
