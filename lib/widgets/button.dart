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
