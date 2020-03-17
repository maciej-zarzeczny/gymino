import 'package:flutter/material.dart';

import '../globals.dart';

class NoData extends StatelessWidget {
  final String displayText;
  final Function onPressedFunction;

  NoData(this.displayText, this.onPressedFunction);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Global().canvasColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            displayText,
            style: Theme.of(context).textTheme.body1.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          FlatButton(
            child: Text(
              'Odśwież',
              style: Theme.of(context).textTheme.button.copyWith(
                    color: Theme.of(context).accentColor,
                  ),
            ),
            onPressed: () => onPressedFunction(),
          ),
        ],
      ),
    );
  }
}
