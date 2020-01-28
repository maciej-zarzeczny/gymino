import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../globals.dart';
import '../models/workout.dart';
import '../widgets/keyword.dart';

class WorkoutHeader extends StatelessWidget {
  final Workout workout;
  final Function startWorkout;

  WorkoutHeader({
    this.workout,
    this.startWorkout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.35,
      width: double.infinity,
      child: Stack(
        children: <Widget>[
          Image(
            width: double.infinity,
            image: AssetImage(workout.imageUrl),
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
          Container(
            color: Colors.black26,
            width: double.infinity,
            height: double.infinity,
          ),
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Align(
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                    padding: const EdgeInsets.all(0.0),
                    onPressed: () {
                      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
                      Navigator.of(context).pop();
                    },
                    icon: Global().backArrow(),
                  ),
                  Container(
                      constraints: BoxConstraints(minWidth: 100),
                      child: Text(
                        workout.difficulty,
                        style: Theme.of(context).textTheme.headline,
                        textAlign: TextAlign.center,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(bottom: 10.0)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      children: workout.keywords.entries.map((keyword) {
                        return Keyword(keyword.value, false);
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: -2,
            left: 0,
            right: 0,
            child: Container(
              height: (MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top) *
                  0.05,                  
              padding: const EdgeInsets.all(0.0),
              margin: const EdgeInsets.all(0.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            right: 40,
            bottom: ((MediaQuery.of(context).size.height -
                            MediaQuery.of(context).padding.top) *
                        0.05) /
                    2 -
                5,
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
        ],
      ),
    );
  }
}
