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
      height: recentWorkouts.length > 1
          ? MediaQuery.of(context).size.height * 0.35
          : MediaQuery.of(context).size.height * 0.31,
      constraints: BoxConstraints(minHeight: 150),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          recentWorkouts.length > 1
              ? CustomTitle('Polecane dla ciebie')
              : CustomTitle('Polecany dla ciebie'),
          Expanded(
            child: recentWorkouts.length > 1
                ? ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    itemCount: recentWorkouts.length,
                    itemBuilder: (context, i) =>
                        WorkoutCard(recentWorkouts[i], false),
                    separatorBuilder: (context, i) => SizedBox(
                      width: 10.0,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: WorkoutCard(recentWorkouts[0], true),
                  ),
          ),
        ],
      ),
    );
  }
}
