import 'package:flutter/material.dart';

import './recommended_trainer.dart';
import '../models/trainer.dart';

class PopularTrainers extends StatelessWidget {  
  final List<Trainer> popularTrainers;

  PopularTrainers(this.popularTrainers);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top) * 0.2,
      constraints: BoxConstraints(minHeight: 160),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'Popularni',
              style: TextStyle(
                  fontSize: 15,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.normal),
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(0.0),
              itemCount: popularTrainers.length,
              itemBuilder: (context, i) =>
                  RecommendedTrainer(popularTrainers[i]),
            ),
          ),
        ],
      ),
    );
  }
}
