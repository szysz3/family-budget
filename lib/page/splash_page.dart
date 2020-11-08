import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../util/auth.dart';
import 'home_page.dart';
import 'login_page.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPage createState() => _SplashPage();
}

class _SplashPage extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _goHomeOrLogIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset("assets/piggy-bank.svg", height: 300)
          ],
        ),
      ),
    ));
  }

  _goHomeOrLogIn() async {
    Widget targetPage;
    if (!await Auth().isSignedIn()) {
      targetPage = LoginPage();
    } else {
      SignInResult signedUser = await Auth().getSignedInUser();
      targetPage = HomePage(signInResult: signedUser);
    }
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => targetPage), (r) => false);
  }
}
