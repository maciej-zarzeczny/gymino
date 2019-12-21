import 'package:flutter/material.dart';

import '../models/trainer.dart';
import './badge.dart';
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
        height: MediaQuery.of(context).size.height * 0.2,
        constraints: BoxConstraints(minHeight: 180),
        padding: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 10.0),
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image(
                width: double.infinity,
                image: NetworkImage(trainer.imageUrl),
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            Container(
              alignment: Alignment.bottomLeft,
              padding: const EdgeInsets.all(15.0),
              child: Text(
                trainer.name,
                style: Theme.of(context).textTheme.display1,
              ),
            ),
            Badge(trainer.numberOfFollowers, true),
          ],
        ),
      ),
    );
  }
}
