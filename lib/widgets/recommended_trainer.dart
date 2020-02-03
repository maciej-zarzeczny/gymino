import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../size_config.dart';
import '../globals.dart';
import '../models/trainer.dart';
import '../screens/trainer_workouts_screen.dart';

class RecommendedTrainer extends StatelessWidget {
  final Trainer recommendedTrainer;

  RecommendedTrainer(this.recommendedTrainer);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(TrainerWorkoutsScreen.routeName,
            arguments: recommendedTrainer.id);
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          image: DecorationImage(
            image: CachedNetworkImageProvider(recommendedTrainer.imageUrl),
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
                recommendedTrainer.name,
                style: Theme.of(context)
                    .textTheme
                    .display1
                    .copyWith(color: Global().canvasColor, fontWeight: FontWeight.w500),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,                    
              ),
              SizedBox(height: 5.0),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.people,
                    color: Global().canvasColor,
                    size: SizeConfig.safeBlockHorizontal * 5,
                  ),
                  SizedBox(width: 5),
                  Text(
                    recommendedTrainer.numberOfFollowers,
                    style: Theme.of(context).textTheme.body1.copyWith(color: Global().canvasColor, fontSize: SizeConfig.safeBlockHorizontal * 4),
                  ),
                  SizedBox(width: 10.0),
                  Icon(
                    Icons.fitness_center,
                    color: Global().canvasColor,
                    size: SizeConfig.safeBlockHorizontal * 5,
                  ),
                  SizedBox(width: 5.0),
                  Text(
                    recommendedTrainer.numberOfWorkouts.toString(),
                    style: Theme.of(context).textTheme.body1.copyWith(color: Global().canvasColor, fontSize: SizeConfig.safeBlockHorizontal * 4),
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
