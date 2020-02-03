import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class Global {
  final Map<int, Color> primaryColor = {
    50: Color.fromRGBO(26, 26, 26, .1),
    100: Color.fromRGBO(26, 26, 26, .2),
    200: Color.fromRGBO(26, 26, 26, .3),
    300: Color.fromRGBO(26, 26, 26, .4),
    400: Color.fromRGBO(26, 26, 26, .5),
    500: Color.fromRGBO(26, 26, 26, .6),
    600: Color.fromRGBO(26, 26, 26, .7),
    700: Color.fromRGBO(26, 26, 26, .8),
    800: Color.fromRGBO(26, 26, 26, .9),
    900: Color.fromRGBO(26, 26, 26, 1),
  };

  final Color darkGrey = Color.fromRGBO(66, 75, 81, 1.0);
  final Color mediumGrey = Color.fromRGBO(149, 158, 164, 1.0);
  final Color softGrey = Color.fromRGBO(218, 225, 228, 1.0);
  final Color lightGrey = Color.fromRGBO(244, 245, 246, 1.0);

  final Color canvasColor = Color.fromRGBO(250, 250, 250, 1.0);

  Widget loadingIndicator(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      color: canvasColor,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget backArrow() {
    return Icon(
      Platform.isIOS ? CupertinoIcons.back : Icons.arrow_back,
      color: Colors.white,
      size: 35,
    );
  }

  Future<void> showAlertDialog(BuildContext context, String title,
      String subtitle, String actionText, Function actionFunction) async {
    return Platform.isIOS
        ? showCupertinoDialog<void>(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: Text(title),
                content: Text(subtitle),
                actions: <Widget>[
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    child: Text(actionText),
                    onPressed: actionFunction,
                  ),
                ],
              );
            })
        : showDialog<void>(
            context: context,
            barrierDismissible: true,
            builder: (context) {
              return AlertDialog(
                title: Text(
                  title,
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                content: Text(subtitle),
                actions: <Widget>[
                  FlatButton(
                    child: Text(actionText),
                    onPressed: actionFunction,
                  ),
                ],
              );
            },
          );
  }
}
