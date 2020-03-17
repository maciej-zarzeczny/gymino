import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/exercise.dart';
import '../screens/exercise_overview_screen.dart';

class ExerciseCard extends StatelessWidget {
  final Exercise _exercise;
  ExerciseCard(this._exercise);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(ExerciseOverviewScreen.routeName, arguments: _exercise.id),
      child: Container(
        height: size * 0.15,
        width: size * 0.15,
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: size * 0.15,
              height: size * 0.15,
              decoration: BoxDecoration(
                color: Color.fromRGBO(227, 227, 227, 1),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(_exercise.image),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(Colors.black26, BlendMode.darken)
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width - (size * 0.15) - 40.0,
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                _exercise.name, 
                style: Theme.of(context).textTheme.body1,
              ),
            )
          ],
        ),
      ),
    );
  }
}
