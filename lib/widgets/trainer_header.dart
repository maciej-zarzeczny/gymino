import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sqilly/globals.dart';

import '../models/trainer.dart';
import '../screens/trainer_info_screen.dart';

class TrainerHeader extends StatelessWidget {
  final Trainer trainer;

  TrainerHeader(
    this.trainer,
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(TrainerInfoScreen.routeName, arguments: trainer);
      },
      child: Stack(
        children: <Widget>[
          CachedNetworkImage(
            width: double.infinity,
            imageUrl: trainer.image,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            errorWidget: (context, url, error) => Center(
              child: Icon(
              Icons.error_outline,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black38,
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
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
                        style: Theme.of(context)
                            .textTheme
                            .body1
                            .copyWith(color: Global().canvasColor, fontSize: 15),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
