import 'package:flutter/material.dart';

import '../widgets/workout_card.dart';
import '../models/workout.dart';
import '../widgets/custom_title.dart';

class RecentWorkouts extends StatelessWidget {
  final List<Workout> recentWorkouts;

  RecentWorkouts(this.recentWorkouts);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.35,
      constraints: BoxConstraints(minHeight: 250),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CustomTitle('Wybrane dla ciebie'),
          Expanded(
            child: ListView.separated(              
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              itemCount: recentWorkouts.length,
              itemBuilder: (context, i) =>
                  WorkoutCard(recentWorkouts[i], false),
              separatorBuilder: (context, i) => SizedBox(
                width: 10.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
