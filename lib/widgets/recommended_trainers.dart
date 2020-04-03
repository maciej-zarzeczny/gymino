import 'package:flutter/material.dart';

import './recommended_trainer.dart';
import '../models/trainer.dart';
import '../widgets/custom_title.dart';
import '../widgets/trainer_pick.dart';

class RecommendedTrainers extends StatelessWidget {
  final List<Trainer> recommendedTrainers;

  RecommendedTrainers(this.recommendedTrainers);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: recommendedTrainers.length > 1
          ? MediaQuery.of(context).size.width * 0.7
          : MediaQuery.of(context).size.width * 0.57,
      constraints: BoxConstraints(minHeight: 250),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          recommendedTrainers.length > 1 ? CustomTitle('Polecani dla ciebie') : CustomTitle('Polecany dla ciebie'),
          Expanded(
            child: recommendedTrainers.length > 1
                ? ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    scrollDirection: Axis.horizontal,
                    itemCount: recommendedTrainers.length,
                    itemBuilder: (context, index) {
                      return RecommendedTrainer(recommendedTrainers[index]);
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(width: 10.0);
                    },
                  )
                : TrainerPick(recommendedTrainers[0]),
          ),
        ],
      ),
    );
  }
}
