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
          // decoration: BoxDecoration(
          //     gradient: LinearGradient(
          //         begin: Alignment.topLeft,
          //         end: Alignment.bottomRight,
          //         colors: [Colors.blueGrey[200], Colors.blueGrey[100]])),
          child: Builder(builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(bottom: 32),
              child: Text(
                'Please log in',
                // style: TextStyle(fontSize: 40, color: Colors.grey[200]),
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
        // elevation: 8,
        // color: Colors.grey[200],
        child: Row(
          children: <Widget>[
            _getLoginButton(
                context, "assets/google.svg", _onGoogleSignInPressed),
            _getLoginButton(
                context, "assets/facebook.svg", _onFacebookSignInPressed)
          ],
        ));
  }

  Widget _getLoginButton(
      BuildContext context, String iconPath, Function onPressedAction) {
    return Expanded(
      child: RawMaterialButton(
        elevation: 0,
        shape: CircleBorder(),
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
