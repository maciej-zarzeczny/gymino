import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/workout.dart';
import './badge.dart';
import '../screens/workout_overview_screen.dart';

class WorkoutCard extends StatelessWidget {
  final bool isFullSize;
  final Workout workout;

  WorkoutCard(this.workout, this.isFullSize);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
        Navigator.of(context).pushNamed(WorkoutOverviewScreen.routeName, arguments: workout.id);
      },
      child: Container(
        padding: isFullSize ? const EdgeInsets.symmetric(horizontal: 10.0) : const EdgeInsets.only(left: 10.0),
        width: isFullSize
            ? double.infinity
            : MediaQuery.of(context).size.width * 0.7,
        height: isFullSize
            ? MediaQuery.of(context).size.height * 0.2
            : double.infinity,
        constraints: BoxConstraints(minHeight: 180),        
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image(
                width: double.infinity,
                image: AssetImage(workout.imageUrl),
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            Container(
              alignment: Alignment.bottomLeft,
              padding: const EdgeInsets.all(15.0),
              child: Text(
                workout.name,
                style: Theme.of(context).textTheme.display1,
              ),
            ),
            Badge(workout.difficulty, false),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Icon(
                    Icons.watch_later,
                    color: Colors.white,
                    size: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 3.0),
                    child: Text(
                      '${workout.duration} min',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
