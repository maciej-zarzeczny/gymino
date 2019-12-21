import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/trainer.dart';
import '../providers/trainers_provider.dart';
import '../providers/workouts_provider.dart';
import '../widgets/trainer_header.dart';
import '../widgets/recent_workouts.dart';
import '../widgets/workout_card.dart';

class TrainerWorkoutsScreen extends StatefulWidget {
  static const routeName = '/trainer';

  @override
  _TrainerWorkoutsScreenState createState() => _TrainerWorkoutsScreenState();
}

class _TrainerWorkoutsScreenState extends State<TrainerWorkoutsScreen> {
  String _trainerId;
  bool _isLoading = true;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) {
      Provider.of<WorkoutsProvider>(context)
          .fetchWorkouts(ModalRoute.of(context).settings.arguments as String)
          .then((_) {
        setState(() {
          _isLoading = false;
          _trainerId = ModalRoute.of(context).settings.arguments as String;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Trainer trainer;
    final workoutsProvider = Provider.of<WorkoutsProvider>(context);
    final workouts = workoutsProvider.workouts;
    final recentWorkouts = workoutsProvider.recentWorkouts;

    if (_trainerId != null) {
      trainer = Provider.of<TrainersProvider>(context, listen: false)
          .findById(_trainerId);
    }

    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              height: (MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top) *
                  1,
              margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: ListView.builder(
                padding: const EdgeInsets.all(0.0),
                itemCount: workouts.length + 1,
                itemBuilder: (context, i) {
                  if (i == 0) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TrainerHeader(trainer, workouts.length),
                        recentWorkouts.isNotEmpty
                            ? RecentWorkouts(recentWorkouts)
                            : Container(),
                        workouts.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, bottom: 10),
                                child: Text(
                                  'Wszystkie treningi',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.normal),
                                ),
                              )
                            : Container(
                                height: (MediaQuery.of(context).size.height -
                                        MediaQuery.of(context).padding.top) *
                                    0.7,
                                width: double.infinity,
                                child: Center(
                                  child: Text('Brak dodanych treningów'),
                                ),
                              ),
                      ],
                    );
                  } else {
                    return WorkoutCard(workouts[i - 1], true);
                  }
                },
              ),
            ),
    );
  }
}
