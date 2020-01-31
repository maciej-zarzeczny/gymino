import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../globals.dart';
import '../providers/workouts_provider.dart';
import '../models/workout.dart';
import '../widgets/workout_header.dart';
import '../widgets/exercise_card.dart';
import '../screens/workout_screen.dart';
import '../models/exercise.dart';
import '../providers/users_provider.dart';
import '../models/user.dart';

class WorkoutOverviewScreen extends StatefulWidget {
  static const String routeName = '/workout-overview';

  @override
  _WorkoutOverviewScreenState createState() => _WorkoutOverviewScreenState();
}

class _WorkoutOverviewScreenState extends State<WorkoutOverviewScreen> {
  String workoutId;
  WorkoutsProvider workoutsProvider;
  Workout workout;
  bool _isLoading = true;

  @override
  void initState() {
    Future.microtask(() {
      workoutsProvider = Provider.of<WorkoutsProvider>(context, listen: false);
      workoutId = ModalRoute.of(context).settings.arguments as String;
      workout = workoutsProvider.findById(workoutId);
      if (workout == null) {
        workoutsProvider.fetchWorkoutById(workoutId).then((_) {
          setState(() {
            _isLoading = false;
          });
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UsersProvider usersProvider;
    List<Exercise> exercises;
    UserData userData;
    bool isSaved = false;

    if (!_isLoading) {
      workout = workoutsProvider.findById(workoutId);
      usersProvider = Provider.of<UsersProvider>(context);
      exercises = workoutsProvider.getExercises(workoutId);
      userData = usersProvider.userData;

      if (userData.savedWorkouts != null &&
          userData.savedWorkouts.containsKey(workoutId)) {
        isSaved = true;
      }
    }

    void startWorkout() {
      Navigator.of(context).pushNamed(WorkoutScreen.routeName, arguments: {
        'exercises': exercises,
        'workoutName': workout.name,
        'imageUrl': workout.imageUrl,
      });
    }

    void addToFavourites() {
      setState(() => isSaved = true);
      usersProvider.addWorkoutToFavourites(
        workoutId,
        workout.difficulty,
        workout.duration,
        workout.name,
        workout.imageUrl,
        workoutsProvider.currentTrainerId,
      );
    }

    void removeFromFavourites() {
      setState(() => isSaved = false);
      usersProvider.removeWorkoutFromFavourites(workoutId);
    }

    return Scaffold(
      body: _isLoading
          ? Global().loadingIndicator(context)
          : Container(
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
              width: double.infinity,
              child: Column(
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
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                    color: Color.fromRGBO(119, 119, 119, 1),
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
                          child: GestureDetector(
                            onTap: isSaved
                                ? removeFromFavourites
                                : addToFavourites,
                            child: Icon(
                              isSaved ? Icons.bookmark : Icons.bookmark_border,
                              color: Theme.of(context).primaryColor,
                              size: 28,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(0.0),
                      itemCount: exercises.length,
                      itemBuilder: (context, i) {
                        return ExerciseCard(exercises[i]);
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
