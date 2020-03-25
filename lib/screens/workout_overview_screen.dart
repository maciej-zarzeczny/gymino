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
          workout = workoutsProvider.findById(workoutId);
          setState(() {
            _isLoading = false;
          });
        }).catchError((err) {
          Global().showAlertDialog(
            context,
            'Błąd',
            'Podczas łączenia z serwerem wystąpił błąd, spróbuj ponownie później.',
            'Ok',
            () => Navigator.of(context).pop(),
          );
          _isLoading = false;
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
      usersProvider = Provider.of<UsersProvider>(context);
      exercises = workout.getExercises();
      userData = usersProvider.userData;

      if (userData.savedWorkouts != null && userData.savedWorkouts.containsKey(workoutId)) {
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

    void addToFavourites(context) {
      setState(() => isSaved = true);
      usersProvider
          .addWorkoutToFavourites(
        workoutId,
        workout.difficulty,
        workout.duration,
        workout.name,
        workout.imageUrl,
        workoutsProvider.currentTrainerId,
      )
          .then((_) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Dodano do zapisanych"),
        ));
      }).catchError((err) {
        Global().showAlertDialog(
            context, 'Błąd', 'Podczas łączenia z serwerem wystąpił błąd, spróbuj ponownie później.', 'Ok', () => Navigator.of(context).pop());
      });
    }

    void removeFromFavourites(context) {
      setState(() => isSaved = false);
      usersProvider.removeWorkoutFromFavourites(workoutId).then((_) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Usunięto z zapisanych"),
        ));
      }).catchError((err) {
        Global().showAlertDialog(
            context, 'Błąd', 'Podczas łączenia z serwerem wystąpił błąd, spróbuj ponownie później.', 'Ok', () => Navigator.of(context).pop());
      });
    }

    return Scaffold(
      body: _isLoading
          ? Global().loadingIndicator(context)
          : Builder(
              builder: (context) => Container(
                height: MediaQuery.of(context).size.height,
                color: Global().canvasColor,
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    WorkoutHeader(workout),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        workout.name,
                        style: Theme.of(context).textTheme.display1,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                            decoration: BoxDecoration(
                              color: Global().lightGrey,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Icon(
                                  Icons.access_time,
                                  color: Global().mediumGrey,
                                  size: 17,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 3.0),
                                  child: Text(
                                    '${workout.duration} min',
                                    style: TextStyle(
                                      color: Global().mediumGrey,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 5.0),
                          GestureDetector(
                            onTap: () {
                              if (isSaved) {
                                removeFromFavourites(context);
                              } else {
                                addToFavourites(context);
                              }
                            },
                            child: Icon(
                              isSaved ? Icons.bookmark : Icons.bookmark_border,
                              color: Theme.of(context).primaryColor,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Expanded(
                        child: ListView.builder(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: MediaQuery.of(context).padding.bottom),
                      itemCount: exercises.length + 1,
                      itemBuilder: (context, i) {
                        if (i == 0) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                workout.description,
                                style: Theme.of(context).textTheme.body1,
                                textAlign: TextAlign.justify,
                              ),
                              !workout.isPremium
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                                      child: Text(
                                        'Lista ćwiczeń',
                                        style: Theme.of(context).textTheme.display1,
                                      ),
                                    )
                                  : Container(),
                            ],
                          );
                        } else if (!workout.isPremium) {
                          return ExerciseCard(exercises[i - 1]);
                        } else {
                          return Container();
                        }
                      },
                    )),
                  ],
                ),
              ),
            ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FloatingActionButton(
          onPressed: startWorkout,
          backgroundColor: Theme.of(context).accentColor,
          elevation: 5,
          child: Icon(
            Icons.play_arrow,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
