import 'package:flutter/material.dart';

class NoData extends StatelessWidget {
  final String displayText;
  final Function onPressedFunction;

  NoData(this.displayText, this.onPressedFunction);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(displayText),
          RaisedButton(
            child: Text('Odśwież'),
            onPressed: () => onPressedFunction(),
          ),
        ],
      ),
    );
  }
}
