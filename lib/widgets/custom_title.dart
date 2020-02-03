import 'package:flutter/material.dart';

class CustomTitle extends StatelessWidget {
  final String text;

  CustomTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Text(
        text,
        style: Theme.of(context).textTheme.display1,
      ),
    );
  }
}
