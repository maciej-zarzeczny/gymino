import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../globals.dart';
import '../models/trainer.dart';
import '../screens/trainer_workouts_screen.dart';

class TopTrainer extends StatelessWidget {
  final Trainer topTrainer;

  TopTrainer(this.topTrainer);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(TrainerWorkoutsScreen.routeName,
            arguments: topTrainer.id);
      },
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.25,        
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        constraints: BoxConstraints(minHeight: 150),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          image: DecorationImage(
            image: CachedNetworkImageProvider(topTrainer.imageUrl),
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            colorFilter: ColorFilter.mode(Colors.black38, BlendMode.darken),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                topTrainer.name,
                style: Theme.of(context).textTheme.display2,
              ),
              SizedBox(height: 5.0),
              Row(
                children: <Widget>[                  
                  Icon(
                    Icons.fitness_center,
                    color: Global().canvasColor,
                  ),
                  SizedBox(width: 5.0),
                  Text(
                    topTrainer.numberOfWorkouts.toString(),
                    style: Theme.of(context).textTheme.body1.copyWith(color: Global().canvasColor),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
