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
        Navigator.of(context).pushNamed(TrainerWorkoutsScreen.routeName, arguments: recommendedTrainer);
      },
      child: CachedNetworkImage(
        imageUrl: recommendedTrainer.image,
        placeholder: (context, url) => Center(
          child: Icon(
            Icons.image,
            color: Global().darkGrey,
          ),
        ),
        errorWidget: (context, url, error) => Center(
          child: Icon(
            Icons.broken_image,
            color: Global().darkGrey,
          ),
        ),
        imageBuilder: (context, imageProvider) => Container(
          width: MediaQuery.of(context).size.width * 0.5,
          decoration: BoxDecoration(
            color: Global().mediumGrey,
            borderRadius: BorderRadius.circular(15.0),
            image: DecorationImage(
              image: imageProvider,
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
                  style: Theme.of(context).textTheme.display1.copyWith(color: Global().canvasColor, fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 5.0),
                Row(
                  children: <Widget>[
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
      ),
    );
  }
}
