import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/workouts_provider.dart';

import '../models/workout.dart';
import '../widgets/workout_header.dart';
import '../widgets/exercise_card.dart';
import '../screens/workout_screen.dart';

class WorkoutOverviewScreen extends StatefulWidget {
  static const String routeName = '/workout-overview';

  @override
  _WorkoutOverviewScreenState createState() => _WorkoutOverviewScreenState();
}

class _WorkoutOverviewScreenState extends State<WorkoutOverviewScreen> {
  String _workoutId;
  bool _isLoading = true;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) {
      Provider.of<WorkoutsProvider>(context)
          .fetchExercises(ModalRoute.of(context).settings.arguments as String)
          .then((_) {
        setState(() {
          _isLoading = false;
          _workoutId = ModalRoute.of(context).settings.arguments as String;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Workout workout;
    final workoutsProvider = Provider.of<WorkoutsProvider>(context);
    final exercises = workoutsProvider.exercises;
    if (_workoutId != null) {
      workout = workoutsProvider.findById(_workoutId);
    }

    void startWorkout() {
      Navigator.of(context).pushNamed(WorkoutScreen.routeName, arguments: {        
        'exercises': exercises,
      });
    }

    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              height: (MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top) *
                  1,
              width: double.infinity,
              margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: ListView.builder(
                padding: const EdgeInsets.all(0.0),
                itemCount: exercises.length + 1,
                itemBuilder: (context, i) {
                  if (i == 0) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        WorkoutHeader(
                          workout: workout,
                          startWorkout: startWorkout,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            workout.name,
                            style: Theme.of(context).textTheme.body2,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 5.0),
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(227, 227, 227, 1),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Icon(
                                      Icons.access_time,
                                      color: Color.fromRGBO(119, 119, 119, 1),
                                      size: 17,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 3.0),
                                      child: Text(
                                        '${workout.duration} min',
                                        style: TextStyle(
                                          color:
                                              Color.fromRGBO(119, 119, 119, 1),
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Icon(
                                  Icons.bookmark_border,
                                  color: Theme.of(context).primaryColor,
                                  size: 28,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    );
                  } else {
                    return ExerciseCard(exercises[i - 1].name, true);
                  }
                },
              ),
            ),
    );
  }
}
