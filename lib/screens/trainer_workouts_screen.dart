import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../globals.dart';
import '../screens/trainer_info_screen.dart';
import '../models/trainer.dart';
import '../providers/trainers_provider.dart';
import '../providers/workouts_provider.dart';
import '../widgets/recent_workouts.dart';
import '../widgets/workout_card.dart';
import '../widgets/more_loading_indicator.dart';
import '../models/workout.dart';
import '../widgets/custom_title.dart';
import '../widgets/trainer_header.dart';
import '../providers/users_provider.dart';

class TrainerWorkoutsScreen extends StatefulWidget {
  static const routeName = '/trainer';

  @override
  _TrainerWorkoutsScreenState createState() => _TrainerWorkoutsScreenState();
}

class _TrainerWorkoutsScreenState extends State<TrainerWorkoutsScreen> {
  String _trainerId;
  bool _isLoading = true;
  bool _moreLoading = false;
  ScrollController _scrollController = ScrollController();
  WorkoutsProvider workoutsProvider;
  Trainer trainer;
  double _nameOpacity = 1.0;

  @override
  void initState() {
    Future.microtask(() {
      _trainerId = ModalRoute.of(context).settings.arguments as String;
      workoutsProvider = Provider.of<WorkoutsProvider>(context, listen: false);
      workoutsProvider.currentTrainerId = _trainerId;
      trainer = Provider.of<TrainersProvider>(context, listen: false)
          .findById(_trainerId);
      int userExperience = Provider.of<UsersProvider>(context, listen: false)
          .userData
          .experienceLevel;

      if (workoutsProvider.workouts == null ||
          workoutsProvider.fromSavedWorkouts) {
        workoutsProvider.fetchWorkouts(userExperience).then((_) {
          setState(() {
            _isLoading = false;
          });
        }).catchError((err) {
          print(err);
          Global().showAlertDialog(
              context,
              'Błąd',
              'Podczas połączenia z serwerem wystąpił błąd, spróbuj ponownie później.',
              'Ok',
              () => Navigator.of(context).pop());
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }

      _scrollController.addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          setState(() {
            _moreLoading = true;
          });

          if (!workoutsProvider.allWorkoutsLoaded) {
            workoutsProvider.fetchMoreWorkouts().then((_) {
              setState(() {
                _moreLoading = false;
              });
            });
          } else {
            double edge = 50.0;
            double offsetFromBottom =
                _scrollController.position.maxScrollExtent -
                    _scrollController.position.pixels;
            if (offsetFromBottom < edge) {
              _scrollController
                  .animateTo(
                      _scrollController.offset - (edge - offsetFromBottom),
                      duration: new Duration(milliseconds: 500),
                      curve: Curves.easeOut)
                  .then((_) {
                setState(() {
                  _moreLoading = false;
                });
              });
            }
          }
        }
      });

      _scrollController.addListener(() {
        if (_scrollController.position.pixels >=
                MediaQuery.of(context).size.height * 0.18 &&
            _nameOpacity != 0.0) {
          setState(() {
            _nameOpacity = 0.0;
          });
        } else if (_scrollController.position.pixels < 100 &&
            _nameOpacity == 0.0) {
          setState(() {
            _nameOpacity = 1.0;
          });
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Workout> workouts;
    List<Workout> recommendedWorkouts;

    if (_trainerId != null) {
      workouts = workoutsProvider.workouts;
      recommendedWorkouts = workoutsProvider.recommendedWorkouts;

      if (workouts.isNotEmpty && recommendedWorkouts.isNotEmpty) {
        recommendedWorkouts.forEach((recommendedWorkout) {
          workouts
              .removeWhere((workout) => workout.id == recommendedWorkout.id);
        });
      }
    }

    return Scaffold(
      body: _isLoading
          ? Global().loadingIndicator(context)
          : Container(
              color: Colors.white,
              child: CustomScrollView(
                controller: _scrollController,
                slivers: <Widget>[
                  SliverAppBar(
                    pinned: true,
                    floating: false,
                    snap: false,
                    expandedHeight: MediaQuery.of(context).size.height * 0.25,
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      title: AnimatedOpacity(
                        opacity: 1.0 - _nameOpacity,
                        duration: Duration(milliseconds: 200),
                        child: Text(
                          trainer.name.toUpperCase(),
                          style: Theme.of(context).textTheme.title.copyWith(
                                color: Global().canvasColor,
                              ),
                        ),
                      ),
                      background: GestureDetector(
                        onTap: () => Navigator.of(context).pushNamed(
                            TrainerInfoScreen.routeName,
                            arguments: trainer),
                        child: TrainerHeader(trainer),
                      ),
                    ),
                    actions: <Widget>[
                      IconButton(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        onPressed: () => Navigator.of(context).pushNamed(
                            TrainerInfoScreen.routeName,
                            arguments: trainer),
                        icon: Icon(
                          Icons.info_outline,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                    ],
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index == 0) {
                          return recommendedWorkouts.isNotEmpty
                              ? RecentWorkouts(recommendedWorkouts)
                              : Container();
                        } else if (index == 1) {
                          return workouts.isNotEmpty
                              ? CustomTitle(recommendedWorkouts.isNotEmpty
                                  ? 'Inne'
                                  : 'Wszystkie treningi')
                              : Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 30.0, horizontal: 10.0),
                                    child: Text('Brak dodanych treningów'),
                                  ),
                                );
                        } else if (index == workouts.length + 2) {
                          return MoreLoadingIndicator(_moreLoading);
                        } else {
                          return Padding(
                            padding: EdgeInsets.only(
                              left: 20.0,
                              right: 20.0,
                              top: index == 2 ? 0 : 5.0,
                              bottom: 5.0,
                            ),
                            child: WorkoutCard(workouts[index - 2], true),
                          );
                        }
                      },
                      childCount: workouts.length + 3,
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
