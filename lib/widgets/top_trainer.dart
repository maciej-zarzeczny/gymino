import 'package:flutter/material.dart';

import '../models/trainer.dart';
import '../screens/trainer_workouts_screen.dart';

class TopTrainer extends StatelessWidget {
  final Trainer topTrainer;

  TopTrainer(this.topTrainer);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: (MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top) *
          0.3,      
      child: GestureDetector(
        onTap: () {          
          Navigator.of(context).pushNamed(TrainerWorkoutsScreen.routeName, arguments: topTrainer.id);
        },
        child: Stack(
          children: <Widget>[
            Image(
              width: double.infinity,
              image: NetworkImage(topTrainer.imageUrl),
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
            Container(
              color: Colors.black12,
              width: double.infinity,
              height: double.infinity,
            ),
            Container(
              padding: const EdgeInsets.all(15),
              alignment: Alignment.bottomLeft,
              child: Text(topTrainer.name, style: Theme.of(context).textTheme.title),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Text('NAJCZĘŚCIEJ WYBIERANY',
                      style: Theme.of(context).textTheme.headline),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(top: 15, bottom: 5),
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Icon(Icons.favorite, color: Colors.white),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 3),
                      child: Text(
                        topTrainer.numberOfFollowers,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
