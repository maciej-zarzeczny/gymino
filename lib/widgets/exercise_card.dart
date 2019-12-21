import 'package:flutter/material.dart';

class ExerciseCard extends StatelessWidget {
  final String exerciseName;
  final bool withLine;

  ExerciseCard(this.exerciseName, this.withLine);

  @override
  Widget build(BuildContext context) {
    final size =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity,
      height: size * 0.15,
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: size * 0.15,
            height: size * 0.15,
            decoration: BoxDecoration(
              color: Color.fromRGBO(227, 227, 227, 1),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Text(
              exerciseName,
              style: Theme.of(context).textTheme.display2,
            ),
          )
        ],
      ),
    );
  }
}
