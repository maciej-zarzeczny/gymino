import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/trainer.dart';
import '../screens/trainer_workouts_screen.dart';

class TrainerPick extends StatelessWidget {
  final Trainer trainer;

  TrainerPick(this.trainer);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(TrainerWorkoutsScreen.routeName, arguments: trainer.id);
      },
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.15,
        constraints: BoxConstraints(minHeight: 100),
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
        child: Center(
          child: Text(
            trainer.name,
            style: Theme.of(context).textTheme.display2,
          ),
        ),
      ),
    );
  }
}
