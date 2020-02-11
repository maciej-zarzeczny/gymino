import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/trainer.dart';
import '../widgets/badge.dart';
import '../globals.dart';
import '../screens/trainer_workouts_screen.dart';

class TrainerPick extends StatelessWidget {
  final Trainer trainer;

  TrainerPick(this.trainer);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(TrainerWorkoutsScreen.routeName, arguments: trainer);
      },
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.2,
        constraints: BoxConstraints(minHeight: 150),
        margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          image: DecorationImage(
            image: CachedNetworkImageProvider(trainer.imageUrl),
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            colorFilter: ColorFilter.mode(Colors.black38, BlendMode.darken),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.bottomLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      trainer.name,
                      style: Theme.of(context).textTheme.display2,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 5.0),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.fitness_center,
                          color: Global().canvasColor,
                          size: 20,
                        ),
                        SizedBox(width: 5.0),
                        Text(
                          trainer.numberOfWorkouts.toString(),
                          style: Theme.of(context).textTheme.body1.copyWith(
                                color: Global().canvasColor,
                                fontSize: 15,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    trainer.gym
                        ? Badge(
                            text: 'Siłownia',
                            icon: Icons.access_time,
                            withIcon: false,
                          )
                        : SizedBox(
                            width: 0,
                            height: 0,
                          ),
                    SizedBox(width: 5.0),
                    trainer.calisthenics
                        ? Badge(
                            text: 'Kalistenika',
                            icon: Icons.access_time,
                            withIcon: false,
                          )
                        : SizedBox(
                            width: 0,
                            height: 0,
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
