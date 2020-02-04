import 'package:flutter/material.dart';

import './recommended_trainer.dart';
import '../models/trainer.dart';
import '../widgets/custom_title.dart';

class RecommendedTrainers extends StatelessWidget {
  final List<Trainer> recommendedTrainers;

  RecommendedTrainers(this.recommendedTrainers);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top) *
          0.35,
      constraints: BoxConstraints(minHeight: 250),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          recommendedTrainers.length > 1
              ? CustomTitle('Polecani dla ciebie')
              : CustomTitle('Polecany dla ciebie'),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              scrollDirection: Axis.horizontal,
              itemCount: recommendedTrainers.length,
              itemBuilder: (context, index) {
                return RecommendedTrainer(recommendedTrainers[index]);
              },
              separatorBuilder: (context, index) {
                return SizedBox(width: 10.0);
              },
            ),
          ),
        ],
      ),
    );
  }
}
