import 'package:flutter/material.dart';

import '../widgets/workout_card.dart';
import '../models/workout.dart';

class RecentWorkouts extends StatelessWidget {
  final List<Workout> recentWorkouts;

  RecentWorkouts(this.recentWorkouts);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.2,
      constraints: BoxConstraints(minHeight: 170),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'Ostatnio dodane',
              style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.normal),
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(0.0),
              itemCount: recentWorkouts.length,
              itemBuilder: (context, i) =>
                  WorkoutCard(recentWorkouts[i], false),
            ),
          ),
        ],
      ),
    );
  }
}
