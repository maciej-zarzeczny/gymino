import 'package:flutter/material.dart';

import '../globals.dart';
import '../models/workout.dart';
import '../widgets/keyword.dart';
import '../widgets/difficulty_level.dart';

class WorkoutHeader extends StatelessWidget {
  final Workout workout;

  WorkoutHeader(
    this.workout,
  );

  @override
  Widget build(BuildContext context) {
    final _appBar = AppBar(
      backgroundColor: Colors.transparent,
    );

    return Container(
      height: MediaQuery.of(context).size.height * 0.35,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(workout.imageUrl),
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
          colorFilter: ColorFilter.mode(Colors.black38, BlendMode.darken),
        ),
      ),
      child: Stack(
        children: <Widget>[  
          _appBar,        
          Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top +
                    _appBar.preferredSize.height),
            child: Align(
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // IconButton(
                  //   padding: const EdgeInsets.all(0.0),
                  //   onPressed: () {
                  //     Navigator.of(context).pop();
                  //   },
                  //   icon: Global().backArrow(),
                  // ),
                  // SizedBox(height: 5.0),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20.0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 7.0, vertical: 7.0),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(26, 26, 26, 0.7),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          'Poziom: ',
                          style: Theme.of(context).textTheme.overline.copyWith(
                              color: Global().canvasColor,
                              fontWeight: FontWeight.normal),
                        ),
                        DifficultyLevel(workout.difficulty),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                color: Global().canvasColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
