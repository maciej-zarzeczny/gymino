import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
      elevation: 0,
    );

    return Container(
      height: MediaQuery.of(context).size.height * 0.35,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: CachedNetworkImageProvider(workout.imageUrl),
          fit: BoxFit.cover,
          alignment: Alignment.center,
          colorFilter: ColorFilter.mode(Colors.black38, BlendMode.darken),
        ),
      ),
      child: Stack(
        children: <Widget>[          
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + _appBar.preferredSize.height),
            child: Align(
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20.0),
                    padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 7.0),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(26, 26, 26, 0.7),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          'Poziom: ',
                          style: Theme.of(context).textTheme.overline.copyWith(color: Global().canvasColor, fontWeight: FontWeight.normal),
                        ),
                        DifficultyLevel(workout.difficulty),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Wrap(
                      runSpacing: 10.0,
                      children: workout.keywords.map((keyword) {
                        return Keyword(keyword, false);
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          workout.isPremium
              ? Container(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  color: Colors.black54,
                  child: Center(
                    child: Icon(
                      Icons.lock,
                      color: Global().canvasColor,  
                      size: 45,
                    ),
                  ),
                )
              : Container(),
          _appBar,
          Positioned(
            bottom: -2,
            left: 0,
            right: 0,
            child: Container(
              height: (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top) * 0.05,
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
