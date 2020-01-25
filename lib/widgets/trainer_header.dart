import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/trainer.dart';
import '../screens/trainer_info_screen.dart';

class TrainerHeader extends StatelessWidget {
  final Trainer trainer;
  final int numberOfWorkouts;

  TrainerHeader(
    this.trainer,
    this.numberOfWorkouts,
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(TrainerInfoScreen.routeName, arguments: trainer);
      },
      child: Container(
        width: double.infinity,
        height: (MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top) *
            0.3,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black38,
              offset: Offset(0.0, 5.0),
              blurRadius: 5.0,
            ),
          ],
        ),
        child: Stack(
          children: <Widget>[
            CachedNetworkImage(
              width: double.infinity,
              imageUrl: trainer.imageUrl,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              errorWidget: (context, url, error) => Icon(
                Icons.error_outline,
                color: Colors.white,
              ),
            ),
            Container(
              color: Colors.black12,
              width: double.infinity,
              height: double.infinity,
            ),
            Positioned(
              top: 0,
              left: 0,
              child: IconButton(
                iconSize: 30,
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(Icons.arrow_back),
                color: Colors.white,
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(TrainerInfoScreen.routeName,
                      arguments: trainer);
                },
                icon: Icon(Icons.info_outline),
                color: Colors.white,
                iconSize: 30,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(Icons.favorite,
                          color: Theme.of(context).primaryColor),
                      Padding(
                        padding: const EdgeInsets.only(left: 3),
                        child: Text(
                          trainer.numberOfFollowers,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                              fontSize: 23),
                        ),
                      ),
                    ],
                  ),
                  Text(trainer.name, style: Theme.of(context).textTheme.title),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      '$numberOfWorkouts treningów',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
