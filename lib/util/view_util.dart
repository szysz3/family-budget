import 'package:flutter/material.dart';

class ViewUtil {
  static showErrorSnackbar(String message, BuildContext context) {
    Scaffold.of(context).showSnackBar(SnackBar(
      // backgroundColor: Colors.red[400],
      content: Text(
        message,
        // style: TextStyle(
        //     fontSize: 12, color: Colors.white70, fontWeight: FontWeight.w600),
      ),
    ));
  }
}
