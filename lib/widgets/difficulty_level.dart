import 'package:flutter/material.dart';

class DifficultyLevel extends StatelessWidget {
  final int difficulty;

  DifficultyLevel(this.difficulty);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(
          Icons.star,
          color: Theme.of(context).accentColor,
          size: 15,
        ),
        SizedBox(width: 3.0),
        Icon(
          Icons.star,
          color: difficulty > 1
              ? Theme.of(context).accentColor
              : Color.fromRGBO(244, 245, 246, 0.5),
          size: 15,
        ),
        SizedBox(width: 3.0),
        Icon(
          Icons.star,
          color: difficulty > 2
              ? Theme.of(context).accentColor
              : Color.fromRGBO(244, 245, 246, 0.5),
          size: 15,
        ),
      ],
    );
  }
}