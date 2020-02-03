import 'package:flutter/material.dart';
import 'package:sqilly/globals.dart';

import '../models/workout.dart';
import '../screens/workout_overview_screen.dart';
import '../widgets/difficulty_level.dart';

class WorkoutCard extends StatelessWidget {
  final bool isFullSize;
  final Workout workout;

  WorkoutCard(this.workout, this.isFullSize);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(WorkoutOverviewScreen.routeName, arguments: workout.id);
      },
      child: Container(
        width: isFullSize
            ? double.infinity
            : MediaQuery.of(context).size.width * 0.45,
        height: isFullSize
            ? MediaQuery.of(context).size.height * 0.2
            : double.infinity,
        constraints: BoxConstraints(minHeight: 150),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          image: DecorationImage(
            image: AssetImage(workout.imageUrl),
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            colorFilter: ColorFilter.mode(Colors.black38, BlendMode.darken),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.bottomLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      workout.name,
                      style: Theme.of(context).textTheme.display1.copyWith(
                            color: Global().canvasColor,
                            fontWeight: FontWeight.w500,   
                            fontSize: isFullSize ? 20 : 17,                         
                          ),
                          maxLines: isFullSize ? 1 : 2,
                          overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 3.0),
                    DifficultyLevel(workout.difficulty),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(                  
                  padding: const EdgeInsets.symmetric(
                      horizontal: 7.0, vertical: 7.0),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(26, 26, 26, 0.7),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.access_time,
                        color: Global().canvasColor,
                        size: 15,
                      ),
                      SizedBox(width: 5.0),
                      Text(
                        '${workout.duration} min',
                        style: Theme.of(context).textTheme.overline.copyWith(
                              color: Global().canvasColor,
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                            ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
