import 'package:flutter/material.dart';

import '../models/exercise.dart';

class ExerciseOverviewScreen extends StatelessWidget {
  static const routeName = '/exerciseOverview';

  @override
  Widget build(BuildContext context) {
    final Exercise _exercise =
        ModalRoute.of(context).settings.arguments as Exercise;

    return Scaffold(
      body: Center(
        child: Text(_exercise.name),
      ),
    );
  }
}
