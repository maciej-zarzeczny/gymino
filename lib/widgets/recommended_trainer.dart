import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../widgets/badge.dart';
import '../models/trainer.dart';
import '../screens/trainer_workouts_screen.dart';

class RecommendedTrainer extends StatelessWidget {
  final Trainer recommendedTrainer;

  RecommendedTrainer(this.recommendedTrainer);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(TrainerWorkoutsScreen.routeName, arguments: recommendedTrainer.id);
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Stack(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: CachedNetworkImage(
                  width: double.infinity,
                  imageUrl: recommendedTrainer.imageUrl,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,                  
                  errorWidget: (context, url, error) => Icon(Icons.error_outline, color: Colors.white,),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(10.0)),
              ),
              Container(
                alignment: Alignment.bottomLeft,
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  recommendedTrainer.name,
                  style: Theme.of(context).textTheme.display1,
                ),
              ),
              Badge(recommendedTrainer.numberOfFollowers, true),
            ],
          ),
        ),
      ),
    );
  }
}
