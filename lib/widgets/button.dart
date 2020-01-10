import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;
  final Function onTapFunction;

  Button({this.text, this.onTapFunction});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapFunction,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 4.0,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 15.0,
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.button,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
    );
  }
}

class GoogleSignInButton extends StatelessWidget {
  final Function signInWithGoogle;

  GoogleSignInButton(this.signInWithGoogle);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: signInWithGoogle,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 4.0,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 15.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              width: 25,
              height: 25,
              image: AssetImage('assets/images/google_logo.png'),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(
                'Zaloguj przez Google',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
    );
  }
}
